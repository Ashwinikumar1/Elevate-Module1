# Module 1: GCP Infrastructure Migration & Application Modernization

Welcome to **Module 1** of Project Elevate. This repository contains the complete codebase, infrastructure templates, step-by-step student guides, and evaluation tools for **Lab 1**, **Lab 2**, and **Lab 3**.

> 🎓 **CE Curriculum Guide**: For a strategic explanation of how these 3 labs connect Module 0 (Foundations), Module 1 (Applied Competency), and Advanced Multi-Agent Modules for Customer Engineers, read **[MODULE1_CE_CURRICULUM_OVERVIEW.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/MODULE1_CE_CURRICULUM_OVERVIEW.md)**.

---


## 📂 Repository Taxonomy

```
Module1/
├── README.md                              <-- Master Module Overview (You are here)
├── 📁 Lab1/                               <-- Lab 1: Application Containerization & Basic GCP Infrastructure
│   ├── 📁 app/                            <-- HR Vacation Node.js application & Dockerfile
│   ├── 📁 docs/                           <-- Lab 1 setup guides & assignment specifications
│   │   ├── README.md
│   │   ├── lab_assignment.md
│   │   └── lab_setup_guide.md
│   └── 📁 terraform/                      <-- Lab 1 Terraform IaC & deploy script
│       ├── main.tf, iam.tf, gcs.tf
│       └── deploy.sh
│
└── 📁 Lab2/                               <-- Lab 2: AWS-to-GCP Enterprise Reference Migration
    ├── 📁 data/                           <-- AWS production state inputs (aws_environment.json)
    ├── 📁 docs/                           <-- Student guides, solution docs & business proposals
    │   ├── STUDENT_LAB_GUIDE.md           <-- Primary Student Lab Guide & Rubric
    │   ├── STEP_BY_STEP_SOLUTION.md       <-- Detailed Technical Solution Walkthrough
    │   ├── lab_deployment_solution_report.md <-- Lab Report & Architecture Specification
    │   ├── aws_to_gcp_migration_analysis.md <-- Migration Technical Strategy
    │   └── gcp_value_proposition_analysis.md <-- Executive TCO & Business Case Analysis
    └── 📁 terraform/                      <-- Org-Policy Compliant Terraform IaC & Automated Grader
        ├── main.tf
        ├── deploy.sh
        └── verify.sh                      <-- Automated Grading & Evaluation Test Suite

└── 📁 Lab3/                           <-- Lab 3: Cymbal Navigation Agent Evaluation, Deployment & Publishing
    ├── README.md                          <-- Lab 3 Overview & Task Summary
    ├── STUDENT_LAB_GUIDE.md               # Primary Exhaustive Student Guide & Rubric
    ├── scripts/preflight_check.sh         # GCP Auth & Service API verification script
    ├── skills/                            # Agentic Skills Directory (evaluation, deployment, publish, observability)
    ├── cymbal_navigation_agent/           # Core Customer Agent Package
    └── tests/eval/                        # ADK Evaluation Datasets & Metrics Config
```


---

## 🚀 Lab 1 Overview: Application Containerization & Initial GCP Provisioning

### 🎯 What You Will Learn
- Containerize legacy enterprise applications using Docker.
- Build and push container images to Google Cloud Artifact Registry / Container Registry.
- Write basic Terraform code to provision Google Cloud Storage buckets and service accounts.
- Enforce IAM least-privilege access for cloud resources.

### 📚 Documents to Refer To for Lab 1
1. **[Lab 1 Student Lab Execution Guide](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab1/docs/STUDENT_LAB_GUIDE.md)** (**START HERE FOR PHASE 2 OUTAGE REMEDIATION**): Diagnosing & Remediating Multi-Region Cloud Infrastructure Outages via Agentic AI Tooling.
2. **[Lab 1 Setup Guide](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab1/docs/lab_setup_guide.md)**: Environment preparation, Node.js runtime setup, and GCP authentication.
3. **[Lab 1 Assignment](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab1/docs/lab_assignment.md)**: Step-by-step task requirements and container building procedures.
4. **[Lab 1 Readme](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab1/docs/README.md)**: Architectural overview of the sample HR Vacation service.


### ⚡ Quick Start for Lab 1
```bash
# 1. Provision baseline infrastructure
cd Lab1/terraform
terraform apply -auto-approve

# 2. Deploy Cloud Run services
bash deploy.sh

# 3. Run Automated Verification & Grading Suite
cd ..
bash verify.sh
```


---

## 🛡️ Lab 2 Overview: AWS-to-GCP Enterprise Reference Migration

### 🎯 What You Will Learn
- Parse production AWS infrastructure state files (`aws_environment.json`).
- Translate AWS core primitives (VPC, EKS, KMS, S3) into production-grade GCP equivalents (VPC Subnetwork, GKE Standard, Cloud KMS, GCS).
- Satisfy enterprise **GCP Organization Security Policies** (`constraints/compute.vmExternalIpAccess` for Private Clusters & `constraints/compute.requireShieldedVm` for Secure Boot).
- Automated test scoring and infrastructure verification using `verify.sh`.

### 📚 Documents to Refer To for Lab 2
1. **[Student Lab Execution Guide](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/docs/STUDENT_LAB_GUIDE.md)** (**START HERE**): Step-by-step student instructions, Altostrat permission checklists, and troubleshooting table.
2. **[Step-by-Step Solution Guide](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/docs/STEP_BY_STEP_SOLUTION.md)**: Technical solution guide mapping AWS JSON primitives to GCP Terraform resources.
3. **[Solution & Evaluation Report](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/docs/lab_deployment_solution_report.md)**: Full lab summary, role matrices, and policy compliance rules.
4. **[AWS to GCP Migration Strategy](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/docs/aws_to_gcp_migration_analysis.md)**: In-depth technical architecture comparison.
5. **[Value Proposition & Business Analysis](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/docs/gcp_value_proposition_analysis.md)**: Executive TCO benefits and modernization strategy.

### ⚡ Quick Start for Lab 2
```bash
# 1. Navigate to Terraform directory
cd Lab2/terraform

# 2. Apply infrastructure
terraform apply -var="gcp_project_id=YOUR_PROJECT_ID" -var="gcp_region=us-east1" -auto-approve

# 3. Run Automated Grader
bash verify.sh
```

---

## 🤖 Lab 3 Overview: Cymbal Navigation Agent Evaluation, Deployment & Publishing

### 🎯 What You Will Learn
- Verify GCP preflight authentication & service API status (`aiplatform`, `cloudresourcemanager`, `iam`, `logging`, `monitoring`, `bigquery`, `discoveryengine`).
- Test customer-provided ADK agent code locally using `agents-cli run` and `agents-cli playground`.
- Execute the ADK Quality Flywheel evaluation framework (`evalset.json` & `eval_config.yaml`).
- Deploy agent to managed Vertex AI Agent Runtime (Reasoning Engine) with global model handling and BigQuery Telemetry.
- Programmatically register reasoning engine endpoints into Gemini Enterprise.
- Audit 4-tier enterprise observability (Cloud Trace, Prompt-Response Logging, BigQuery Agent Analytics, Third-Party Telemetry).

### 📚 Documents to Refer To for Lab 3
1. **[Student Lab Guide](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/STUDENT_LAB_GUIDE.md)** (**START HERE**): Exhaustive step-by-step student instructions, rubric, and task walkthroughs.
2. **[Lab 3 Readme](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/README.md)**: Architectural overview and quick reference commands.

### ⚡ Quick Start for Lab 3
```bash
# 1. Navigate to Lab 3 directory
cd Lab3

# 2. Run GCP Preflight Check
bash scripts/preflight_check.sh

# 3. Execute ADK Evaluation
agents-cli eval run --config tests/eval/eval_config.yaml

# 4. Deploy to Vertex AI Agent Runtime
agents-cli deploy --deployment-target agent_runtime --no-confirm-project --bq
```


---

## 🔐 Altostrat Organization Requirements & Policies

When executing labs under the **Altostrat Organization**, ensure:
1. **User Role**: You are assigned `roles/owner` or `roles/editor` on your student GCP project.
2. **GCP Auth**: You run `gcloud auth application-default login` before invoking Terraform.
3. **Org Constraints Enabled**:
   - Private GKE nodes are mandatory (`enable_private_nodes = true`).
   - Secure Boot is mandatory on compute nodes (`enable_secure_boot = true`).
   - KMS IAM Encrypter/Decrypter roles are explicitly granted to GCP service agents (`container-engine-robot` and `gs-project-accounts`).
