# Lab 3: Building, Evaluating, Deploying & Publishing the Cymbal Navigation Agent with ADK

Welcome to **Lab 3** of Project Elevate. In this hands-on lab, you will act as a Lead AI & Solutions Engineer at **Cymbal Group**. You will take pre-developed agent code for the **Cymbal Navigation & Planner Agent**, validate its local execution, construct a golden evaluation dataset, run ADK quality flywheel evaluations, deploy the agent to Vertex AI Agent Runtime (Reasoning Engine) with BigQuery Telemetry, register it into Gemini Enterprise, and verify 4-tier enterprise observability.

---

## 🛠️ Tooling Overview: Google Agents CLI (`agents-cli`)

### Installation & Purpose
`agents-cli` is the unified Command-Line Interface for Google's Agent Development Kit (ADK). 
To install or upgrade `agents-cli`, run:
```bash
uv tool install google-agents-cli
```
`agents-cli` automates local agent interactive testing (`agents-cli playground`), non-interactive evaluation runs (`agents-cli eval`), production deployment to Vertex AI Agent Runtime (`agents-cli deploy`), enterprise publishing (`agents-cli publish`), and telemetry audits.

---

## 🎯 Learning Objectives

By completing this lab, you will learn how to:
1. **Verify GCP Environment & Enable Required APIs**: Use automated preflight verification scripts to validate `gcloud` credentials and enable Vertex AI, IAM, Telemetry, BigQuery, and Gemini Enterprise APIs.
2. **Local Agent Testing**: Execute interactive web-based playground sessions and CLI smoke tests using `agents-cli`.
3. **Execute ADK Agent Evaluation (Quality Flywheel)**: Construct a golden evaluation dataset (`evalset.json`) and run ADK quality flywheel evaluations across 6 core metrics.
4. **Deploy to Vertex AI Agent Runtime**: Deploy the agent to Vertex AI Agent Runtime (Reasoning Engine) with OpenTelemetry Cloud Tracing and BigQuery Agent Analytics export enabled.
5. **Publish & Register to Gemini Enterprise**: Programmatically register the deployed Reasoning Engine instance into a pre-enabled Gemini Enterprise Engine & Collection.
6. **Verify 4-Tier Enterprise Observability**: Execute test queries and audit telemetry across Cloud Trace spans, Prompt-Response logs, and BigQuery `agent_events` dataset queries.
7. **Leverage Agentic Skills**: Prompt your AI Coding Assistant (Antigravity) using high-level skill-based workflows.

---

## 📋 Prerequisites & Environment Setup

Before starting the lab tasks, ensure you have satisfied the following setup requirements:

### 1. Account & GCP Project Authentication
* Ensure active GCloud authentication and Application Default Credentials (ADC):
  ```bash
  gcloud auth login
  gcloud auth application-default login
  ```
* Set active GCP Project ID and Vertex AI environment variables:
  ```bash
  export GCP_PROJECT_ID="YOUR_PROJECT_ID"
  export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_ID"
  export GOOGLE_CLOUD_LOCATION="global"
  export GOOGLE_GENAI_USE_VERTEXAI="true"
  gcloud config set project $GCP_PROJECT_ID
  ```

---

## 🏢 Business Scenario: The Cymbal Navigation & Planner Agent

**Cymbal Group** requires an enterprise location-aware travel and event planning assistant. The customer engineering team has provided pre-developed agent source code in `cymbal_navigation_agent/`. 

The agent integrates two primary tool capabilities:
1. **Google Search Tool (`GoogleSearchTool`)**: Native search grounding tool for real-time web intelligence, local event details, and venue reviews.
2. **Google Maps API Tools (`search_google_maps` & `get_route_directions`)**: Custom API tools for physical address lookups, ratings, coordinates, and multi-modal transit/driving directions.

---

## ⚙️ Step 0: Mandatory GCP Preflight Check

Before starting local testing or deployment, run the preflight verification script:

```bash
bash scripts/preflight_check.sh
```

---

## 🚀 Student Lab Tasks (Prompt-Driven Skill Workflows)

In this lab, you will use **Agentic Skills** located in `skills/` (and `.agents/skills/`). You will instruct your AI Coding Assistant (Antigravity) using **high-level agentic prompts**.

> 💡 **Prompting Rule**: Every prompt instructs the assistant to print clear background information on what is happening under the hood so you can follow along as an engineer.

---

### Step 1: Workspace Inspection & Repository Setup

**Goal**: Have your AI assistant inspect the workspace, verify agent configuration manifest files (`agents-cli-manifest.yaml`, `pyproject.toml`), and confirm setup **without initiating execution**.

#### 💡 High-Level Prompt for your AI Assistant:
> *"Please inspect the repository workspace for `cymbal_navigation_agent` and verify all code, configuration files (`agents-cli-manifest.yaml`, `pyproject.toml`), and environment variables (`.env`). Before doing anything, print detailed background information explaining the project architecture, tool declarations, and ADK configuration. Do NOT start executing evaluation runs or deployments until I explicitly instruct you to proceed to the next step."*

---

### Step 2: Local Agent Testing via `agents-cli`

**Goal**: Verify that the agent runs locally and handles tool calling correctly before moving towards production.

#### 💡 High-Level Prompt for your AI Assistant:
> *"Please test the `cymbal_navigation_agent` locally using `agents-cli`. Print background information explaining how local agent serving works under ADK, then launch the interactive web playground (`agents-cli playground`) or run a non-interactive CLI smoke test (`agents-cli run`) to verify that Google Search and Google Maps tools execute cleanly."*

---

### Step 3: Production Readiness — Golden Evaluation Dataset & ADK Quality Flywheel

**Context**: As a Customer Engineer preparing this agent for production deployment, you must evaluate the agent's accuracy, tool execution logic, factual grounding, and navigation trajectory. You will instruct the assistant to create/expand the golden evaluation dataset (`evalset.json`) and run comprehensive evaluations.

#### 💡 High-Level Prompt for your AI Assistant:
> *"As a Customer Engineer moving this agent to production, please follow the `evaluation` skill ([skills/evaluation/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/evaluation/SKILL.md)). First, print background information explaining the ADK Quality Flywheel methodology and metric scoring formulas. Create and expand the golden evaluation dataset (`tests/eval/datasets/evalset.json` or `evals/evalset.json`) with new multi-turn travel evaluation scenarios. Then, run `agents-cli eval run` across all 6 metrics using `tests/eval/eval_config.yaml` and generate the evaluation report artifact at `artifacts/docs/step9_eval_report.md`."*

---

### 🔍 Student Exploration & Metric Analysis

While the evaluation run is executing, inspect the evaluation dataset file (`evalset.json`) and review the **6 Core Metrics** being evaluated:

#### 📊 The 6 Core Evaluation Metrics:

1. **`multi_turn_task_success`**: Measures overall goal completion across multi-turn user conversation sessions.
2. **`multi_turn_tool_use_quality`**: Evaluates technical correctness, parameter accuracy, and tool invocation precision for Google Search and Google Maps API tools.
3. **`multi_turn_trajectory_quality`**: Assesses planning path efficiency, ensuring the agent does not take unnecessary reasoning turns or call redundant tools.
4. **`final_response_quality`**: Rates clarity, formatting, actionable route recommendations, and completeness of the final synthesized response.
5. **`hallucination` (Factuality)**: Audits factual grounding of the generated answers against returned tool payloads to prevent ungrounded claims.
6. **`navigation_accuracy_judge` (Our Custom Domain Metric)**: Custom domain LLM judge evaluating route clarity, place ratings, transit guidance, and location address precision.

> 🎓 **Student Exercise**: Once evaluation completes, open `artifacts/docs/step9_eval_report.md` and inspect the summary scores. Review the individual trajectory step logs to analyze how the agent planned tool calls and synthesized search results.

---

### Step 4: Deploy to Vertex AI Agent Runtime & Publish to Gemini Enterprise

**Goal**: Deploy the agent as a managed Vertex AI Reasoning Engine instance with BigQuery Agent Analytics enabled, then register it into the pre-enabled Gemini Enterprise App.

#### 💡 High-Level Prompt for your AI Assistant:
> *"Please follow the `deployment` skill ([skills/deployment/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/deployment/SKILL.md)) and `publish` skill ([skills/publish/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/publish/SKILL.md)). First, print background information detailing Vertex AI Agent Runtime architecture, telemetry export pipelines, and Gemini Enterprise app registration. Deploy `cymbal_navigation_agent` to Vertex AI Agent Runtime with global model resolution enabled (`GOOGLE_CLOUD_LOCATION=global`), OpenTelemetry trace exporter set to `gcp_trace`, and BigQuery telemetry analytics enabled (`--bq`). Then publish the deployed Reasoning Engine instance to our pre-enabled Gemini Enterprise App under `projects/$GCP_PROJECT_ID/locations/global/collections/default_collection/engines/cymbal-app`. Document all outputs in `artifacts/docs/step10_deploy_report.md` and `artifacts/docs/step16_publish_report.md`."*

---

### Step 5: Execute Test Queries & Verify 4-Tier Observability

**Goal**: Execute live test queries against the deployed agent to generate telemetry traffic, then verify all 4 enterprise observability tiers.

#### 💡 High-Level Prompt for your AI Assistant:
> *"Please use the `observability` skill ([skills/observability/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/observability/SKILL.md)). First, print background information explaining 4-tier enterprise telemetry architecture (Cloud Trace, Prompt-Response Logging, BigQuery Agent Analytics, and Third-Party Metrics). Execute live sample test queries against the deployed Reasoning Engine resource ID. Then verify telemetry across all 4 tiers: audit Cloud Trace spans for `invoke_agent` and `execute_tool`, verify prompt-response privacy policies, run a BigQuery SQL query against `$GCP_PROJECT_ID.telemetry.agent_events`, and save the audit report to `artifacts/docs/step17_observability_report.md`."*

---

## 🔍 Verification: How to Verify Deployment on Gemini Enterprise (GE)

After publishing, verify that your agent is registered and live on Gemini Enterprise using either method:

### Method 1: CLI Verification
Check status using `agents-cli`:
```bash
agents-cli publish status \
  --gemini-enterprise-app-id "projects/$GCP_PROJECT_ID/locations/global/collections/default_collection/engines/cymbal-app"
```

Expected output should confirm:
* **Registration Mode**: `ADK` (Reasoning Engine wrapper)
* **Resource ID**: `projects/<PROJECT_NUMBER>/locations/us-central1/reasoningEngines/<REASONING_ENGINE_ID>`
* **Status**: `ACTIVE`

### Method 2: GCP Console / Gemini Enterprise Web Interface Verification
1. Open GCP Console and go to **Vertex AI Agent Builder / Discovery Engine**:
   `https://console.cloud.google.com/gen-app-builder/engines?project=YOUR_PROJECT_ID`
2. Select your Engine ID: **`cymbal-app`**.
3. Under **Agents / Assistants**, verify **`Cymbal Navigation Agent`** appears in the active agent list.
4. Click **Preview / Test Agent** in the UI and type:
   > *"How do I get from SFO Airport to Moscone Center?"*
5. Confirm that the agent returns structured travel recommendations with tool execution traces visible.

---

## 🛠️ Summary of Available Agent Skills

| Skill | Location | Purpose |
|---|---|---|
| **Preflight Check** | `scripts/preflight_check.sh` | Validates GCP credentials & enables required APIs |
| **`evaluation`** | [skills/evaluation/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/evaluation/SKILL.md) | ADK quality flywheel dataset execution & scoring |
| **`deployment`** | [skills/deployment/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/deployment/SKILL.md) | Deploys agent to Vertex AI Reasoning Engine with BQ telemetry |
| **`publish`** | [skills/publish/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/publish/SKILL.md) | Registers Reasoning Engine into Gemini Enterprise App |
| **`observability`** | [skills/observability/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/projectelevate-module1/Lab3/skills/observability/SKILL.md) | Verifies 4-tier telemetry (Cloud Trace, BQ SQL, Privacy) |

---

## ✅ Submission Checklist

- [ ] Completed GCP Preflight Check (`scripts/preflight_check.sh`).
- [ ] Validated local execution via `agents-cli playground`.
- [ ] Completed Step 3 (Evaluation & Dataset Expansion) → `artifacts/docs/step9_eval_report.md`.
- [ ] Completed Step 4 (Vertex AI Agent Runtime Deployment & GE Publishing) → `artifacts/docs/step10_deploy_report.md` & `artifacts/docs/step16_publish_report.md`.
- [ ] Completed Step 5 (4-Tier Observability Verification) → `artifacts/docs/step17_observability_report.md`.
- [ ] Verified Gemini Enterprise deployment via CLI status or Web UI.

---
*End of Student Lab Guide.*
