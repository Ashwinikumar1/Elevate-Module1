#!/usr/bin/env bash
# Automated Verification & Grading Suite for Lab 1 (Module 1 - Phase 1: Modernizing GCP Workloads via Agentic Tools)
set -e

echo "============================================================"
echo "🧪 Starting Lab 1 Automated Verification & Grading Suite"
echo "   Module 1 - Phase 1: Modernizing GCP Workloads via Agentic Tools"
echo "============================================================"

# 1. Verify Active GCloud Authentication & Project ID
PROJECT_ID=${GCP_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null || true)}
if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" == "(unset)" ]; then
  echo "❌ FAIL: GCP Project ID is unset."
  echo "👉 Run: gcloud config set project YOUR_PROJECT_ID"
  exit 1
fi
echo "📌 GCP Project: $PROJECT_ID"

SCORE=0
TOTAL=100

# Task 1 Check: Baseline Architecture Documentation
echo "------------------------------------------------------------"
echo "🔍 1. Checking Task 1: Baseline Architecture Documentation..."
if [ -f "docs/baseline_summary.md" ] && [ -f "docs/baseline_architecture.mermaid" ]; then
  echo "  ✅ PASS: Task 1 Baseline Documentation artifacts present."
  SCORE=$((SCORE + 20))
else
  echo "  ⚠️  WARNING: Baseline artifacts (docs/baseline_summary.md or docs/baseline_architecture.mermaid) missing."
fi

# Task 2 Check: Customer Requirements Analysis & Blueprint
echo "------------------------------------------------------------"
echo "🔍 2. Checking Task 2: Customer Requirements Analysis..."
if [ -f "docs/updated_summary.md" ] && [ -f "docs/updated_architecture.mermaid" ]; then
  echo "  ✅ PASS: Task 2 Target Architecture artifacts present."
  SCORE=$((SCORE + 20))
else
  echo "  ⚠️  WARNING: Target artifacts (docs/updated_summary.md or docs/updated_architecture.mermaid) missing."
fi

# Task 3 Check: Primary Region Compute & Infrastructure (us-central1)
echo "------------------------------------------------------------"
echo "🔍 3. Checking Task 3: Declarative Primary Region Infrastructure (us-central1)..."
US_STATUS=$(gcloud run services describe hr-vacation-frontend-us --region=us-central1 --format="value(status.conditions[0].status)" 2>/dev/null || gcloud run services describe hr-vacation-app-us --region=us-central1 --format="value(status.conditions[0].status)" 2>/dev/null || true)
if [ "$US_STATUS" == "True" ]; then
  echo "  ✅ PASS: Primary Region Cloud Run Service is Active."
  SCORE=$((SCORE + 20))
else
  echo "  ⚠️  WARNING: Primary Cloud Run Service (us-central1) is not active or pending."
fi

# Task 4 Check: Imperative Secondary Expansion (europe-west1)
echo "------------------------------------------------------------"
echo "🔍 4. Checking Task 4: Imperative Secondary Region Expansion (europe-west1)..."
EU_STATUS=$(gcloud run services describe hr-vacation-frontend-europe --region=europe-west1 --format="value(status.conditions[0].status)" 2>/dev/null || gcloud run services describe hr-vacation-app-eu --region=europe-west1 --format="value(status.conditions[0].status)" 2>/dev/null || true)
if [ "$EU_STATUS" == "True" ]; then
  echo "  ✅ PASS: European Cloud Run Service is Active."
  SCORE=$((SCORE + 20))
else
  echo "  ⚠️  WARNING: European Cloud Run Service (europe-west1) is missing or incomplete."
fi

# Task 5 Check: Global Anycast Load Balancer & Multi-Region Health Checks
echo "------------------------------------------------------------"
echo "🔍 5. Checking Task 5: Global Load Balancing & Resilience..."
NEG_COUNT=$(gcloud compute network-endpoint-groups list --filter="name~hr-vacation-neg" --format="value(name)" 2>/dev/null | wc -l || echo "0")
if [ "$NEG_COUNT" -ge 1 ]; then
  echo "  ✅ PASS: Serverless Network Endpoint Groups verified ($NEG_COUNT NEGs active)."
  SCORE=$((SCORE + 20))
else
  echo "  ⚠️  WARNING: Serverless NEGs for Global Load Balancing not found."
fi

echo "============================================================"
echo "🎯 FINAL LAB 1 SCORE: $SCORE / $TOTAL"
if [ "$SCORE" -eq 100 ]; then
  echo "🎉 SUCCESS: Lab 1 (Module 1 - Phase 1) Modernization Fully Verified!"
  exit 0
else
  echo "⚠️  INCOMPLETE: Complete missing tasks and re-run verify.sh."
  exit 1
fi
echo "============================================================"
