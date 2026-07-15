# Lab 1 Student Lab Guide: Modernizing GCP Workloads via Agentic Tools
**Module 1 - Phase 1 | Learning Lab (Build)**

---

## 📌 Quick Overview & Constraints

| Metric | Details |
|---|---|
| **Lab Title** | Module 1 - Phase 1: Modernizing GCP Workloads via Agentic Tools |
| **Lab Format** | Learning Lab (Guided Scenario-Driven Build) |
| **Learner Profile** | Practice CE, Platform CE (incl. PA), Outcome CE, GCC Engineers |

> ⚠️ **ZERO-CONSOLE POLICY**: Direct interaction with `console.cloud.google.com` is strictly prohibited. You MUST use Agentic AI tools (VS Code Antigravity Extension, Antigravity CLI, Agent Skills, `gcloud` MCP) for all discovery, code refactoring, deployment, and testing.

---

## 📝 Lab Summary

In this lab, you transition from application engineering to cloud production operations on Google Cloud. Using Agentic AI tools (VS Code Antigravity Plugin, Antigravity CLI, Antigravity 2.0, MCP), you discover a single-region brownfield HR application (`ce-sample-hr-vacation`), analyze customer feedback from Cymbal Group, and upgrade the system into a resilient, multi-region architecture.

### Core Google Cloud Services Used:
* **Cloud Run (Frontend & Backend)**: Containerized UI and API layers.
* **AlloyDB / Cloud SQL**: Relational database for transactional employee records and accrual balances.
* **Firestore**: NoSQL document store for async workflow states and notifications.
* **VPC & Serverless Access**: Foundational network boundary and private service connectors.

---

## 🎓 Learning Objectives

1. **Agentic Tooling & Context Engineering**: Select the right agentic tools and construct READMEs and architecture diagrams for grounded AI reasoning.
2. **Workload Analysis**: Discover brownfield GCP applications and synthesize customer meeting transcripts.
3. **Multi-Region Modernization**: Deploy primary region resources declaratively via Terraform IaC and secondary region resources imperatively via CLI/MCP.
4. **Resiliency Verification**: Test Anycast load balancing, local database latency (<50ms), and execute disaster recovery failover.

---

## 🏢 Scenario & Problem Identification

You are consulting for **Cymbal Group's Enterprise Architecture Division**. Their internal **Vacation Request Subsystem** operates in a single region (`us-central1`). During peak cycles, remote international subsidiaries experience severe latency, and recent regional outages locked out 15,000 employees.

### Key Technical Blockers to Eliminate:
1. **Single-Region SPOF**: All compute and database instances reside solely in `us-central1`.
2. **Database Read Bottlenecks**: Global read queries route to a single database node, causing >800ms latency.
3. **Unbalanced Ingress**: Traffic routes directly to regional Cloud Run without global Anycast failover.

---

## 📋 High-Level Task Execution Flow

```
1. Discovery & Baseline Docs  ➜  2. Customer Requirements Analysis  ➜  3. Declarative Primary IaC
                                                                             │
5. DR Verification & Failover    4. Imperative Secondary Expansion ◄────────┘
```

---

## 🛠️ Step-by-Step Task Instructions

---

### Task 1: Workload Discovery & Baseline Architecture

Analyze the brownfield codebase under `Lab1/ce-sample-hr-vacation` using your Agentic AI IDE.

1. **Prompt Agentic IDE**:
   ```text
   Inspect the codebase and IaC under Lab1/ce-sample-hr-vacation. Identify active GCP services, network boundaries, and single-region dependencies.
   ```
2. **Generate Baseline Documentation Artifacts**:
   - `docs/baseline_summary.md`: Description of single-region GCP services and SPOF risks.
   - `docs/baseline_architecture.mermaid`: Mermaid flowchart depicting initial single-region flow.

*Note: We will share what good looks like during verification.*

> 🤖 **Scoring Check 1**: LLM Judge validates `baseline_summary.md` and `baseline_architecture.mermaid` match reference specs by **≥80%**.

---

### Task 2: Customer Requirements Analysis & Blueprinting

1. Open and inspect [docs/customer_requirements.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab1/docs/customer_requirements.md).
2. **Prompt Agentic IDE**:
   ```text
   Analyze docs/customer_requirements.md and extract latency, availability, and multi-region routing mandates into a structured enhancement plan.
   ```
3. **Generate Target Architecture Artifacts**:
   - `docs/updated_summary.md`: Multi-region architecture specification.
   - `docs/updated_architecture.mermaid`: Target dual-region Anycast topology diagram.

> 🤖 **Scoring Check 2**: LLM Judge validates `updated_summary.md` and `updated_architecture.mermaid` match customer specs by **≥80%**.

---

### Task 3: Upgrading to Multi-Region Load Balancing (Steps 1–3)

#### Step 1: Declare European Cloud Run App Service
In `terraform/main.tf`, declare `app_europe` in `europe-west1`:
```hcl
resource "google_cloud_run_v2_service" "app_europe" {
  name     = "hr-vacation-app-europe"
  location = "europe-west1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.repository_id}/app:latest"
      ports {
        container_port = 8080
      }
      env {
        name  = "DB_WRITE_HOST"
        value = "write-db.hr-vacation.internal"
      }
      env {
        name  = "DB_READ_HOST"
        value = "read-db.hr-vacation.internal"
      }
      env {
        name  = "DB_PASS"
        value = random_password.alloydb_password.result
      }
    }
    vpc_access {
      connector = google_vpc_access_connector.vpc_connector.id
      egress    = "ALL_TRAFFIC"
    }
  }
}
```

#### Step 2: Create European Serverless NEG
```hcl
resource "google_compute_region_network_endpoint_group" "serverless_neg_europe" {
  name                  = "hr-vacation-neg-europe"
  network_endpoint_type = "SERVERLESS"
  region                = "europe-west1"
  cloud_run {
    service = google_cloud_run_v2_service.app_europe.name
  }
}
```

#### Step 3: Register Both Regional NEGs to GCLB Backend Service
```hcl
resource "google_compute_backend_service" "backend_service" {
  name                  = "hr-vacation-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg_europe.id
  }
}
```

---

### Task 4: Cross-Region AlloyDB Replication & Private DNS (Step 4)

#### Step 4: Provision DR Secondary Cluster & Cloud DNS Record Set
In `terraform/main.tf`, declare the secondary AlloyDB cluster and DNS abstraction:

```hcl
# AlloyDB Secondary DR Cluster in europe-west1
resource "google_alloydb_cluster" "secondary" {
  cluster_id   = "hr-vacation-cluster-secondary"
  location     = "europe-west1"
  cluster_type = "SECONDARY"

  network_config {
    network = google_compute_network.vpc_network.id
  }
  secondary_config {
    primary_cluster_name = google_alloydb_cluster.primary.name
  }
  deletion_protection = false
}

# Secondary instance in europe-west1
resource "google_alloydb_instance" "secondary_instance" {
  cluster       = google_alloydb_cluster.secondary.name
  instance_id   = "hr-vacation-secondary-instance"
  instance_type = "SECONDARY"

  machine_config {
    cpu_count = 2
  }
  depends_on = [google_alloydb_instance.primary_instance]
}

# Map DB_WRITE_HOST: write-db.hr-vacation.internal -> Primary AlloyDB IP
resource "google_dns_record_set" "write_dns" {
  name         = "write-db.hr-vacation.internal."
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "A"
  ttl          = 60
  rrdatas      = [google_alloydb_instance.primary_instance.ip_address]
}
```

Document declarative vs. imperative trade-offs in `docs/imperative_vs_declarative.md`.

---

### Task 5: System Verification & DR Failover Promotion (Step 5)

1. Apply Terraform configuration: `terraform apply`.
2. Verify GCLB Anycast routing directs traffic to nearest regional endpoint.
3. Perform DR failover test: Promote `google_alloydb_cluster.secondary` in `europe-west1` and update `write_dns` record to point to the promoted instance without redeploying backend logic.
4. Execute automated verification:
   ```bash
   bash verify.sh
   ```

---

## 📊 Summary Scoring Matrix

| Task Area | Deliverable / Verification Standard | Weight |
|---|---|---|
| **Zero Console Policy** | 100% execution via Agentic AI IDE / CLI / MCP | Required |
| **Task 1 Baseline Artifacts** | `baseline_summary.md` & `baseline_architecture.mermaid` (LLM Judge ≥80%) | 20 Points |
| **Task 2 Requirements Blueprint** | `updated_summary.md` & `updated_architecture.mermaid` (LLM Judge ≥80%) | 20 Points |
| **Task 3 Declarative Primary IaC** | Primary region Cloud Run, NEGs, and GCLB configured in Terraform | 20 Points |
| **Task 4 Secondary DR Replication** | AlloyDB Secondary cluster, instance & Private DNS set up in `europe-west1` | 20 Points |
| **Task 5 Resilience & DR Failover** | `verify.sh` passes health checks and AlloyDB DR promotion failover test | 20 Points |

---
*End of Lab 1 Student Lab Guide.*
