#!/usr/bin/env bash
# Automated Verification & Grading Script for Lab 1 (Phase 1 & Phase 2 Multi-Region Outage Remediation)
set -e

echo "============================================================"
echo "🧪 Starting Lab 1 Automated Verification & Grading Suite"
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

# 2. Check Primary US Cloud Run Service
echo "------------------------------------------------------------"
echo "🔍 1. Checking US Region Cloud Run Service (us-central1)..."
US_STATUS=$(gcloud run services describe hr-vacation-app-us --region=us-central1 --format="value(status.conditions[0].status)" 2>/dev/null || true)
if [ "$US_STATUS" == "True" ]; then
  echo "  ✅ PASS: US Cloud Run Service (hr-vacation-app-us) is Active."
  SCORE=$((SCORE + 25))
else
  echo "  ⚠️  WARNING: US Cloud Run Service (hr-vacation-app-us) is not active or missing."
fi

# 3. Check Multi-Region European Cloud Run Service
echo "------------------------------------------------------------"
echo "🔍 2. Checking EU Region Cloud Run Service (europe-west1)..."
EU_STATUS=$(gcloud run services describe hr-vacation-app-eu --region=europe-west1 --format="value(status.conditions[0].status)" 2>/dev/null || true)
if [ "$EU_STATUS" == "True" ]; then
  echo "  ✅ PASS: European Cloud Run Service (hr-vacation-app-eu) is Active."
  SCORE=$((SCORE + 25))
else
  echo "  ⚠️  WARNING: European Cloud Run Service (hr-vacation-app-eu) is not active or missing."
fi

# 4. Check Regional Routing Fix (DB_READ_HOST in europe-west1)
echo "------------------------------------------------------------"
echo "🔍 3. Checking Regional Routing Misconfiguration Fix..."
EU_READ_HOST=$(gcloud run services describe hr-vacation-app-eu --region=europe-west1 --format="value(spec.template.spec.containers[0].env)" 2>/dev/null | grep -o 'DB_READ_HOST=[^,]*' | cut -d'=' -f2 || true)
if [ -n "$EU_READ_HOST" ] && [[ "$EU_READ_HOST" != *"10.100.0.5"* ]]; then
  echo "  ✅ PASS: European DB_READ_HOST correctly configured ($EU_READ_HOST)."
  SCORE=$((SCORE + 25))
else
  echo "  ❌ FAIL: European DB_READ_HOST is misconfigured ($EU_READ_HOST)."
  echo "     Must point to local European read replica (e.g. 10.200.0.5 or read-db.hr-vacation.internal)."
fi

# 5. Check Cloud Run Revision & Container Image Tag
echo "------------------------------------------------------------"
echo "🔍 4. Checking Hotfix Revision Deployment..."
LATEST_REV=$(gcloud run services describe hr-vacation-app-eu --region=europe-west1 --format="value(status.latestReadyRevisionName)" 2>/dev/null || true)
if [ -n "$LATEST_REV" ]; then
  echo "  ✅ PASS: Latest active revision ready ($LATEST_REV)."
  SCORE=$((SCORE + 25))
else
  echo "  ❌ FAIL: Latest revision build pending or failed."
fi

echo "============================================================"
echo "🎯 FINAL LAB 1 SCORE: $SCORE / $TOTAL"
if [ "$SCORE" -eq 100 ]; then
  echo "🎉 SUCCESS: Lab 1 Multi-Region Outage Remediation Fully Verified!"
  exit 0
else
  echo "⚠️  INCOMPLETE: Review failed checks above and re-run verify.sh."
  exit 1
fi
echo "============================================================"
