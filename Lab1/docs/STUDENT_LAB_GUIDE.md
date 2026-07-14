# Lab 1: Diagnosing & Remediating Multi-Region Cloud Infrastructure Outages via Agentic AI Tooling

Welcome to **Lab 1: Learning Lab**. In this hands-on lab, you will act as a Lead Platform & Cloud Solutions Engineer consulting for **Cymbal Group's Enterprise Architecture Division**. You will diagnose, triage, and remediate a live multi-region production outage on the **Cymbal HR Vacation Request Subsystem** using Agentic AI tooling, Google Agent Skills, and the Model Context Protocol (MCP).

> ⚠️ **CRITICAL LAB RESTRICTION**: You are operating in a restricted production environment. **Direct manual web access to the Google Cloud Console (`console.cloud.google.com`) is strictly disabled.** You MUST use Agentic AI tools (VS Code Antigravity Extension, Antigravity CLI, Agent Skills, and `gcloud` via terminal/MCP) for all discovery, log reading, refactoring, deployment, and health verification.

---

## 🎯 Learning Objectives

By completing this lab, you will learn how to:
1. **Diagnose Multi-Region Failures via Agentic AI**: Parse and interpret GCP Cloud Logging request streams and stack traces using Agentic AI natural language prompts and MCP tools.
2. **Identify Cross-Region Routing Bottlenecks**: Detect environment variable routing misconfigurations forcing cross-region transatlantic database reads between Cloud Run in `europe-west1` and AlloyDB Primary in `us-central1`.
3. **Debug & Remediate Database Connection Leaks**: Uncover Node.js connection pool initialization bugs (`new Pool()` invoked inside HTTP request handlers) exhausting AlloyDB pool connection limits under load.
4. **Imperative Hotfix Deployment**: Refactor backend application code, rebuild container images, and update Cloud Run environment revisions using agentic CLI tools.
5. **Simulate Health Checks & Traffic Validation**: Verify system recovery, zero error rate, and local read latency under review cycle loads.

---

## 👥 Intended Learner Profile
* **Target Roles**: Practice CEs, Platform CEs (incl. Partner Advisors), Outcome CEs, and GCC Engineers.
* **Lab Type**: **Learning Lab** (Guided scenario-driven investigation and building).

---

## 📋 Prerequisites & Required Tooling

Before starting the lab, verify your environment contains the following tools:

### 1. Account Credentials & Project ID
* **Altostrat GCP Account**: Assigned `roles/owner` or `roles/editor`.
* **GCloud Credentials**:
  ```bash
  gcloud auth login
  gcloud auth application-default login
  gcloud config set project YOUR_PROJECT_ID
  export GCP_PROJECT_ID="YOUR_PROJECT_ID"
  ```

### 2. Agentic AI Environment Requirements
* **VS Code IDE with Antigravity Plugin** installed and authenticated.
* **Antigravity CLI & Google Agent Skills**: Integrated via Model Context Protocol (MCP).

---

## 🏢 Business Scenario: Outage at Cymbal Group HR Division

Following the successful migration of the **Cymbal HR Vacation Request Subsystem** from a single-region footprint into a multi-region architecture (`us-central1` and `europe-west1`), Cymbal's engineering team deployed release **v2.0**.

Release **v2.0** was intended to integrate with the newly provisioned multi-region **AlloyDB cluster** (US Primary in `us-central1` and Read Replica in `europe-west1`). However, immediately after deployment during peak quarterly review cycles:
* European users experience severe performance degradation and latency exceeding **800ms**.
* Cloud Run backend services throw intermittent **HTTP 500 Internal Server Errors** (`ERR_DB_CONNECTION_EXHAUSTED`).

You have been paged to resolve the incident.

```
+-----------------------------------------------------------------------------------+
|                           CYMBAL HR MULTI-REGION ARCHITECTURE                     |
|                                                                                   |
|   [US Region: us-central1]                   [EU Region: europe-west1]              |
|   +--------------------------+               +--------------------------+         |
|   | Cloud Run (US Frontend)  |               | Cloud Run (EU Frontend)  |         |
|   +------------+-------------+               +------------+-------------+         |
|                |                                          |                       |
|                v                                          v (FAULt 1: CROSS-REGION)|
|   +--------------------------+  Cross-Region Sync +--------------------------+    |
|   | AlloyDB Primary (US)     | <================> | AlloyDB Replica (EU)     |    |
|   +--------------------------+                    +--------------------------+    |
|                                                                                   |
|   FAULT 2: server.js instantiates `new Pool()` inside route handlers              |
+-----------------------------------------------------------------------------------+
```

---

## ⚡ High-Level Task List (5 Core Tasks)

---

### Task 1: Investigate and Triage the Outage

Use Agentic AI prompts or MCP tools to inspect Cloud Logging request streams for the Cloud Run services in `us-central1` and `europe-west1`.

#### Step 1.1: Query Request Latency & Logs
Prompt your Agentic IDE or run via CLI:
```bash
gcloud logging read 'resource.type="cloud_run_revision" AND severity>=ERROR' --limit=20 --format="json"
```

#### Step 1.2: Analyze Diagnostics
* Note response times for `europe-west1` requests (> 800ms).
* Identify stack trace exceptions: `Error: ERR_DB_CONNECTION_EXHAUSTED` thrown from `server.js` route handlers.

---

### Task 2: Resolve Infrastructure Fault (Regional Routing Misconfiguration)

Inspect environment variable settings injected into the Cloud Run revisions during the v2.0 deployment.

#### Step 2.1: Discover Injected Environment Variables
Inspect the configuration of the European Cloud Run service:
```bash
gcloud run services describe hr-vacation-app-eu --region=europe-west1 --format="value(spec.template.spec.containers[0].env)"
```

#### Step 2.2: Identify Routing Misconfiguration
Notice that `DB_READ_HOST` in `europe-west1` was mistakenly set to the US Primary AlloyDB IP (`10.100.0.5`) instead of the local European Read Replica IP (`10.200.0.5`).

#### Step 2.3: Remediate Regional Routing
Update the Cloud Run service environment variables to point `DB_READ_HOST` to the European Read Replica IP:
```bash
gcloud run services update hr-vacation-app-eu \
  --region=europe-west1 \
  --update-env-vars DB_READ_HOST="10.200.0.5"
```

---

### Task 3: Resolve Application Fault (Connection Pool Leak)

Examine the Node.js backend logic in `app/server.js`.

#### Step 3.1: Locate Code Fault
Open `app/server.js` and locate the route handlers for `/api/vacations`:

```javascript
// ❌ FAULTY CODE IN v2.0:
app.get('/api/vacations', async (req, res) => {
    // BUG: Creating a new connection pool instance on EVERY SINGLE HTTP request!
    const pool = new Pool({
        host: process.env.DB_READ_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        max: 20
    });
    
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM vacation_requests');
    res.json(result.rows);
});
```

#### Step 3.2: Refactor `server.js` to Global Connection Pool Singleton
Refactor `app/server.js` to instantiate a single global connection pool at module initialization:

```javascript
// ✅ REMEDIATED CODE: Global Connection Pool Singleton
const pool = new Pool({
    host: process.env.DB_READ_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    max: 20,
    idleTimeoutMillis: 30000
});

app.get('/api/vacations', async (req, res) => {
    try {
        const client = await pool.connect();
        try {
            const result = await client.query('SELECT * FROM vacation_requests');
            res.json(result.rows);
        } finally {
            client.release();
        }
    } catch (err) {
        console.error('Database Query Error:', err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});
```

---

### Task 4: Deploy the Hotfix Imperatively

Rebuild the patched container image and redeploy the Cloud Run services.

#### Step 4.1: Build Container Image
```bash
gcloud builds submit --tag gcr.io/$GCP_PROJECT_ID/hr-vacation-app:v2.1 ./app
```

#### Step 4.2: Update Cloud Run Revisions
Deploy hotfix revision `v2.1` to both regions:
```bash
# Update US Region
gcloud run deploy hr-vacation-app-us \
  --image gcr.io/$GCP_PROJECT_ID/hr-vacation-app:v2.1 \
  --region us-central1

# Update EU Region
gcloud run deploy hr-vacation-app-eu \
  --image gcr.io/$GCP_PROJECT_ID/hr-vacation-app:v2.1 \
  --region europe-west1
```

---

### Task 5: Validate System Recovery

Simulate review cycle traffic and verify recovery metrics.

#### Step 5.1: Execute Health Check & Load Test
```bash
# Test European Endpoint Latency
curl -w "Latency: %{time_total}s\n" -s https://hr-vacation-app-eu-uc.a.run.app/api/vacations
```

#### Step 5.2: Verify Key Recovery Results
* **European Read Latency**: Dropped from >800ms down to **<45ms** (local read replica execution).
* **HTTP Error Rate**: Dropped from intermittent 500s down to **0%**.
* **AlloyDB Active Connections**: Stabilized within normal connection pool bounds.

---

## 📊 Summary Rubric & Scoring Requirements

Your lab work will be evaluated against the following criteria:

| Requirement Area | Verification Standard |
|---|---|
| **No Manual Console Access** | All actions performed imperatively via Agentic AI tools / CLI (`console.cloud.google.com` unused) |
| **Routing Hotfix** | `DB_READ_HOST` in `europe-west1` resolves to local European read replica IP |
| **Code Leak Patch** | `server.js` uses global pool singleton (`new Pool()` outside request handlers) |
| **Deployment Revision** | Cloud Run services running container image `v2.1` with 100% traffic allocation |
| **Latency Recovery** | European read queries resolve in <50ms with 0% connection pool errors |

---
*End of Lab 1 Student Lab Guide.*
