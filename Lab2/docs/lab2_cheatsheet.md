# Lab 2: AWS-to-GCP Enterprise Reference Migration — Quick Reference Cheatsheet

**Lab Code**: 1.4 | **Domain**: `altostrat.com` | **Target Project**: `alpha-code-461805` | **Region**: `us-east1`  
**Customer Focus**: Cymbal Group (Cymbal Direct / Cymbal Shops) — `adserver1-prd` Stack  

---

## ⚡ 1. Fast-Track CLI Execution Workflow

Run these commands sequentially in your terminal to initialize, provision, and verify the reference infrastructure:

### Step 1: Configure Active GCP Project & ADC
```bash
gcloud config set project alpha-code-461805
gcloud auth application-default login
```

### Step 2: Enable Mandatory GCP Service APIs
```bash
gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com \
  cloudkms.googleapis.com \
  storage.googleapis.com \
  iam.googleapis.com \
  artifactregistry.googleapis.com
```

### Step 3: Initialize & Deploy Terraform IaC
```bash
cd /Users/ashwinikm/Desktop/lab2_test/terraform

# Initialize Terraform modules & providers
terraform init

# Plan and Apply Org-Policy Compliant GCP Infrastructure
terraform plan -var="gcp_project_id=alpha-code-461805" -var="gcp_region=us-east1"
terraform apply -var="gcp_project_id=alpha-code-461805" -var="gcp_region=us-east1" -auto-approve
```
*Note: GKE cluster & node pool creation takes ~8–10 minutes.*

### Step 4: Run Automated Verification Script (100/100 Points)
```bash
cd /Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/terraform
bash verify.sh
```

---

## 🛡️ 2. Altostrat Security Policy Directives & Terraform Implementation

| Altostrat Security Constraint | Required Policy Flag / Setting | Targeted Terraform Configuration in `main.tf` |
| :--- | :--- | :--- |
| **`constraints/compute.vmExternalIpAccess`** | Mandatory Private GKE Cluster Nodes | `private_cluster_config { enable_private_nodes = true }` |
| **`constraints/compute.requireShieldedVm`** | Mandatory Shielded VM & Secure Boot | `node_config { shielded_instance_config { enable_secure_boot = true, enable_integrity_monitoring = true } }` |
| **Cloud KMS IAM Service Agent Grants** | Encrypter/Decrypter permissions for GKE & GCS | Explicit `google_kms_crypto_key_iam_member` granting `roles/cloudkms.cryptoKeyEncrypterDecrypter` to Service Agents |
| **Storage Isolation & Uniform Security** | Prevent public access & enforce CMEK | `uniform_bucket_level_access = true`, `encryption { default_kms_key_name = google_kms_crypto_key.gke_kms_key.id }` |

---

## 🔧 3. Troubleshooting & 409 "Already Exists" State Sync Guide

If `terraform apply` encounters `Error 409: Resource already exists` (because resources were provisioned in a prior step or state file was missing), sync state using existing `terraform.tfstate` or import existing resources into your workspace:

### Method A: Sync Existing State File
```bash
cp /Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab2/terraform/terraform.tfstate* /Users/ashwinikm/Desktop/lab2_test/terraform/
```

### Method B: Terraform Resource Import Commands
```bash
cd /Users/ashwinikm/Desktop/lab2_test/terraform

# Import VPC Network
terraform import google_compute_network.vpc_network projects/alpha-code-461805/global/networks/adserver1-prd-vpc

# Import Cloud KMS KeyRing & Crypto Key
terraform import google_kms_key_ring.kms_key_ring projects/alpha-code-461805/locations/us-east1/keyRings/adserver1-prd-keyring
terraform import google_kms_crypto_key.gke_kms_key projects/alpha-code-461805/locations/us-east1/keyRings/adserver1-prd-keyring/cryptoKeys/adserver1-prd-gke-key

# Import GKE Node Pool Service Account
terraform import google_service_account.gke_node_sa projects/alpha-code-461805/serviceAccounts/adserver1-prd-node-sa@alpha-code-461805.iam.gserviceaccount.com
```

---

## 🎯 4. Verification Checkpoint Map (100 Points Total)

| Checkpoint | Target Resource | Key Verification Command | Expected Output |
| :--- | :--- | :--- | :--- |
| **[1/5] GKE Status** | `adserver1-prd` | `gcloud container clusters list --location=us-east1` | Status `RUNNING`, Private Endpoint enabled |
| **[2/5] Node Pool** | `prd-adserver1-prd-main` | `gcloud container node-pools list --cluster=adserver1-prd` | Status `RUNNING`, Secure Boot `true` |
| **[3/5] VPC Subnets** | `adserver1-prd-vpc` | `gcloud compute networks subnets list --network=adserver1-prd-vpc` | Active Subnets in `10.17.0.0/19` & `10.17.32.0/19` |
| **[4/5] GCS Bucket** | `ad-server-frequency-cappi-deployment-*` | `gcloud storage buckets list --filter="..."` | Enforced Uniform Access & CMEK Key ID |
| **[5/5] Cloud KMS** | `adserver1-prd-keyring` | `gcloud kms keys list --location=us-east1 --keyring=...` | CryptoKey `adserver1-prd-gke-key` in state `ENABLED` |
