# Lab 2: AWS-to-GCP Enterprise Reference Migration via Agentic AI Tooling

**Lab Title**: Lab 2: AWS-to-GCP Enterprise Reference Migration  
**Lab Code**: 1.4  
**Lab Type**: **Challenge Lab** (Independent skill application; minimal step-by-step instructions)  
**Intended Learner Profile**: Practice CEs, Platform CEs (incl. Partner Advisors), Outcome CEs, GCC Engineers  
**Organization Domain**: `altostrat.com`  

---

## 🎯 Lab Summary & Learning Objectives

In this **Challenge Lab**, you will master the use of **Agentic AI tools** (such as VS Code Antigravity IDE, Antigravity CLI, Google Agent Skills, and MCP) to accelerate enterprise cloud migration scenarios. 

You will analyze an existing Amazon Web Services (AWS) environment export (`aws_environment.json`) provided by the customer via email, generate a cross-cloud mapping comparison, produce logical architecture diagrams, write org-policy compliant GCP Terraform code, deploy the reference infrastructure to Google Cloud, and generate an executive business proposal using Migration Center AI capabilities.

### By completing this lab, you will learn how to:
1. **Leverage Agentic AI Tools for Migration Discovery**: Use natural language prompts and MCP skills to parse `aws_environment.json` and extract AWS primitives (EC2 `c5.large`, EKS Cluster `adserver1-prd`, CloudWatch, S3 buckets, and KMS keys).
2. **Generate Cross-Cloud Comparisons & Diagrams**: Prompt your Agentic AI assistant to generate structured AWS-to-GCP technical mapping matrices, logical architecture diagrams, and TCO/value proposition documents.
3. **Generate Org-Policy Compliant GCP Terraform**: Produce modular Terraform code that strictly adheres to **Altostrat Organization Security Policies** (`constraints/compute.vmExternalIpAccess` requiring private GKE nodes & `constraints/compute.requireShieldedVm` requiring Secure Boot).
4. **Deploy & Validate GCP Reference Architecture**: Imperatively deploy the generated Terraform infrastructure to Google Cloud and pass automated verification scoring (`verify.sh`).
5. **Generate Tailored Proposals with Migration Center AI**: Utilize GCP Console Migration Center AI features to generate an executive business proposal.

---

## 🏢 Challenge Scenario: Cymbal Group AdServer Production Migration

You are a Lead Platform Cloud Engineer consulting for the **AdServer Production Migration Team** at **Cymbal Group**. Over email, the customer engineering team has provided a JSON dump of their active Amazon Web Services (AWS) environment (`aws_environment.json`), which has been loaded into your lab environment at `Lab2/data/aws_environment.json`.

```json
{
    "version": 3,
    "terraform_version": "0.12.31",
    "serial": 1,
    "lineage": "78d0e957-f85d-7abf-764b-15d8988cfb23",
    "modules": [
        {
            "path": [ "root" ],
            "outputs": {
                "aws_eks_cluster_tfer--adserver1-prd_id": {
                    "sensitive": false,
                    "type": "string",
                    "value": "adserver1-prd"
                }
...
```

The Cymbal Group leadership team wants to migrate their ad-serving infrastructure to Google Cloud Platform to achieve better performance, zero-trust container security, and cost optimization. 

Your mission is to use Agentic AI tools to understand their AWS topology, translate it into an equivalent production-grade GCP architecture, write and deploy the compliant Terraform code, and prepare executive business proposal artifacts.

---

## 🛡️ Altostrat Organization Security Constraints Notice

Because your project operates under the **Altostrat Organization**, security policies are strictly enforced. Your generated Terraform configuration MUST satisfy the following org policies:

1. **`constraints/compute.vmExternalIpAccess` (No Public VM IPs)**:
   - GKE nodes cannot have public IP addresses. You must enable `private_cluster_config` with `enable_private_nodes = true`.
2. **`constraints/compute.requireShieldedVm` (Shielded Instances)**:
   - All compute instances and GKE node pools must have `shielded_instance_config` with `enable_secure_boot = true` and `enable_integrity_monitoring = true`.
3. **Cloud KMS Service Agent IAM Grants**:
   - GKE (`service-<PROJECT_NUMBER>@container-engine-robot.iam.gserviceaccount.com`) and Cloud Storage (`service-<PROJECT_NUMBER>@gs-project-accounts.iam.gserviceaccount.com`) service agents must be explicitly granted `roles/cloudkms.cryptoKeyEncrypterDecrypter` on Cloud KMS keys prior to resource creation.

---

## ⚡ High-Level Challenge Task List (5 Core Tasks)

---

### Task 1: Analyze AWS Infrastructure State via Agentic AI

Use your Agentic AI IDE or CLI to inspect and summarize `Lab2/data/aws_environment.json`.

#### Example AI Prompt:
> *"Analyze `Lab2/data/aws_environment.json`. Identify all AWS compute, network, container, storage, and key management resources. Extract VPC CIDR blocks, instance machine types, EKS cluster names, and S3 bucket identifiers."*

#### Extracted AWS Environment Baseline:
* **VPC Network**: AWS VPC (`10.17.0.0/16`) across two Availability Zones (`us-east-1a`, `us-east-1b`).
* **Container Cluster**: AWS EKS Cluster (`adserver1-prd`) running node pool `c5.large`.
* **Storage & Encryption**: AWS S3 deployment bucket & AWS KMS Customer Managed Key.

---

### Task 2: Generate Cross-Cloud Mapping & Technical Artifacts

Use your Agentic AI assistant to create standard technical comparison documents for Cymbal Group leadership.

#### Required Deliverable Documents:
1. **Resource Mapping Comparison**: Map AWS primitives to GCP equivalents:
   - AWS VPC ➔ GCP Private VPC (`google_compute_network`) & Custom Subnets (`google_compute_subnetwork`).
   - AWS EKS Cluster ➔ GCP GKE Standard Private Cluster (`google_container_cluster`).
   - AWS EC2 `c5.large` ➔ GCP Compute Engine `c2-standard-4` / Node Pool.
   - AWS S3 Bucket ➔ GCP Cloud Storage Bucket (`google_storage_bucket`) with Uniform Bucket-Level Access.
   - AWS KMS Key ➔ GCP Cloud KMS Key Ring & Crypto Key (`google_kms_crypto_key`).
2. **Logical Architecture Diagrams**: Architectural diagrams illustrating AWS "as-is" vs GCP "to-be".
3. **Value Proposition & TCO Analysis**: Executive document explaining GCP security (Shielded VMs, Private GKE), cost advantages, and unified IAM.

---

### Task 3: Generate & Apply Org-Policy Compliant GCP Terraform

Generate modular Terraform code in `Lab2/terraform/` meeting all Altostrat organization security rules.

#### Step 3.1: Initialize & Configure Environment
```bash
cd Lab2/terraform
export PROJECT_ID=$(gcloud config get-value project)
gcloud auth application-default login
```

#### Step 3.2: Review & Apply Terraform Code
```bash
terraform init
terraform plan -var="gcp_project_id=${PROJECT_ID}" -var="gcp_region=us-east1"
terraform apply -var="gcp_project_id=${PROJECT_ID}" -var="gcp_region=us-east1" -auto-approve
```
*Note: GKE private cluster provisioning takes approximately 8-10 minutes.*

---

### Task 4: Run Automated Verification & Validation Suite

Run the automated grader script [verify.sh](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/terraform/verify.sh) to test all 5 evaluation checkpoints:

```bash
cd Lab2/terraform
bash verify.sh
```

#### Verification Checkpoints (100 Points):
- [ ] **[1/5] GKE Cluster Status**: `adserver1-prd` in status `RUNNING` (20 Points).
- [ ] **[2/5] GKE Node Pool**: `prd-adserver1-prd-main` with Shielded VM Secure Boot enabled (20 Points).
- [ ] **[3/5] VPC Subnets**: Subnets `adserver1-prd-subnet-a` & `subnet-b` active in private network (20 Points).
- [ ] **[4/5] Cloud Storage**: Bucket `ad-server-frequency-cappi-deployment-${PROJECT_ID}` with Uniform Access and KMS Encryption enabled (20 Points).
- [ ] **[5/5] Cloud KMS**: Key `adserver1-prd-gke-key` in state `ENABLED` with service account bindings (20 Points).

---

### Task 5: Generate Tailored Proposal via Migration Center AI

Use GCP Console Migration Center AI tools or Agentic prompts to generate a custom business proposal for Cymbal Group:
1. Navigate to **GCP Console ➔ Migration Center**.
2. Run AI proposal generator or prompt Agentic assistant:
   > *"Generate an executive migration business proposal for Cymbal Group detailing modernizing AWS adserver1-prd to GCP GKE Private Cluster with Cloud KMS encryption."*

---

## 🛠️ Student Troubleshooting Guide

| Issue / Error | Cause | Remediation |
| :--- | :--- | :--- |
| **`403 IAM_PERMISSION_DENIED`** | Account lacks GCP project permissions or wrong active account | Run `gcloud config set account <your-email>@altostrat.com` and ensure project Owner/Editor role is assigned. |
| **`MISSING_IAM_PERMISSIONS_ON_CRYPTO_KEY`** | Service agents missing KMS Encrypter/Decrypter permissions | Ensure `google_kms_crypto_key_iam_member` resources exist in `main.tf` and `depends_on` is specified for GKE and GCS. |
| **`Constraint constraints/compute.vmExternalIpAccess violated`** | Public IP assignment blocked by Altostrat policy | Add `private_cluster_config { enable_private_nodes = true }` in `main.tf`. |
| **`Constraint constraints/compute.requireShieldedVm violated`** | Secure Boot not enabled on VM/Node Pool | Add `shielded_instance_config { enable_secure_boot = true }` in `node_config`. |

---
*End of Lab 2 Challenge Lab Guide.*
