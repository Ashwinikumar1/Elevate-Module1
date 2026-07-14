# Lab 3: Building, Evaluating, Deploying & Publishing the Cymbal Navigation Agent with ADK

Welcome to **Lab 3** of Project Elevate. In this hands-on lab, you will act as a Lead AI & Solutions Engineer at **Cymbal Group**. You will take pre-developed agent code for the **Cymbal Navigation & Planner Agent**, validate its local execution, run comprehensive ADK evaluations, deploy it to Vertex AI Agent Runtime (Reasoning Engine) with BigQuery Observability, register it into Gemini Enterprise, and verify full 4-tier enterprise observability.

---

## 🎯 Learning Objectives

By completing this lab, you will learn how to:
1. **Verify GCP Environment & Enable Required APIs**: Use automated preflight verification scripts to validate `gcloud` credentials and enable Vertex AI, IAM, Telemetry, BigQuery, and Gemini Enterprise APIs.
2. **Local Agent Testing**: Execute non-interactive CLI smoke tests and interactive web-based playground sessions using `agents-cli`.
3. **Execute ADK Agent Evaluation (Quality Flywheel)**: Evaluate agent tool usage, factual grounding, response quality, and trajectory efficiency using built-in metrics and custom domain judges.
4. **Deploy to Vertex AI Agent Runtime**: Deploy the agent as a production-grade Reasoning Engine instance with OpenTelemetry Cloud Tracing and BigQuery Agent Analytics export.
5. **Publish & Register to Gemini Enterprise**: Programmatically register the deployed Reasoning Engine instance into a Gemini Enterprise Engine & Collection.
6. **Verify 4-Tier Enterprise Observability**: Audit Cloud Trace spans, Prompt-Response logging, BigQuery `agent_events` dataset queries, and privacy configurations.
7. **Leverage Agentic Skills**: Utilize standardized agent skills located in `skills/` (and `.agents/skills/`) to automate execution and validation workflows.

---

## 📋 Prerequisites & Environment Setup

Before starting the lab, ensure you have satisfied the following setup requirements:

### 1. Account & Project Credentials
* **Altostrat GCP Account**: You must be assigned `roles/owner` or `roles/editor` on your assigned student GCP Project.
* **Active GCloud Authentication**: Ensure `gcloud` is authenticated with application default credentials:
  ```bash
  gcloud auth login
  gcloud auth application-default login
  ```
* **Project ID Configuration**: Set your active GCP project ID:
  ```bash
  gcloud config set project YOUR_PROJECT_ID
  export GCP_PROJECT_ID="YOUR_PROJECT_ID"
  ```

### 2. Required Installed Tools
* **Google Agents CLI (`agents-cli`)**: Pre-installed via `uv tool install google-agents-cli` or local environment (`~/.local/bin/agents-cli`).
* **Python Runtime & UV**: Python 3.10+ and `uv` package resolver installed.
* **Google Maps API Key (Optional for Local Live Maps)**:
  ```bash
  export GOOGLE_MAPS_API_KEY="YOUR_MAPS_API_KEY"
  ```

---

## 🏢 Business Scenario: The Cymbal Navigation & Planner Agent

**Cymbal Group** requires an enterprise location-aware travel and event planning assistant. The customer engineering team has provided pre-developed agent source code in `cymbal_navigation_agent/`. 

The agent integrates two primary tool capabilities:
1. **Google Search Tool (`google_search`)**: Native grounding tool for real-time web intelligence, local event details, and reviews.
2. **Google Maps API Tools (`search_google_maps` & `get_route_directions`)**: Custom API tools for physical address lookups, venue ratings, coordinates, and multi-modal transit/driving directions.

```
lab3_cymbal_navigation_planner/
├── agents-cli-manifest.yaml           # agents-cli configuration manifest
├── pyproject.toml                     # Python dependencies & build configuration
├── scripts/
│   └── preflight_check.sh             # GCP Auth & Service API verification script
├── skills/                            # Agentic Skills Directory
│   ├── evaluation/SKILL.md            # Skill: ADK Evaluation
│   ├── deployment/SKILL.md            # Skill: Agent Runtime Deployment
│   ├── publish/SKILL.md               # Skill: Gemini Enterprise Publishing
│   └── observability/SKILL.md         # Skill: 4-Tier Telemetry Verification
├── cymbal_navigation_agent/           # Core Agent Source Code (Customer Provided)
│   ├── agent.py                       # Root agent, prompts, and callback initialization
│   └── tools.py                       # Google Maps Places & Directions API tools
└── tests/
    └── eval/                          # Evaluation Suite
        ├── datasets/
        │   ├── evalset.json           # Primary evaluation dataset
        │   └── basic-dataset.json     # Default fallback evaluation dataset
        └── eval_config.yaml           # Evaluation metric declarations & custom judge
```

---

## ⚙️ Step 0: Mandatory GCP Preflight Check & Service API Enablement

Before attempting local testing, evaluation, or deployment, you must run the preflight check. This script verifies your `gcloud` credentials and automatically enables all mandatory GCP APIs:
* `aiplatform.googleapis.com` (Vertex AI Reasoning Engines)
* `cloudresourcemanager.googleapis.com` (Resource Manager)
* `iam.googleapis.com` (Identity & Access Management)
* `logging.googleapis.com` (Cloud Logging)
* `monitoring.googleapis.com` (Cloud Monitoring / OpenTelemetry)
* `bigquery.googleapis.com` (BigQuery Telemetry Analytics)
* `discoveryengine.googleapis.com` (Gemini Enterprise Engine)

### Command:
```bash
cd lab3_cymbal_navigation_planner
bash scripts/preflight_check.sh
```

---

## 💻 Step 1: Local Development & Smoke Testing

Verify that the pre-developed customer agent code executes properly in your local environment.

### Non-Interactive Smoke Test:
Run single prompts directly from the CLI:
```bash
agents-cli run "What major tech conferences are happening in San Francisco soon, and how do I get to Moscone Center from SFO airport?"
```

### Interactive Web Playground:
Launch the interactive web-based UI playground to test multi-turn travel queries:
```bash
agents-cli playground
```

---

## 🚀 Lab Student Tasks (3 Core Tasks)

You have **3 main tasks** to complete in this lab. For each task, you can execute standard CLI commands or leverage the corresponding skill in the `skills/` directory.

---

### Task 1: ADK Evaluation & Quality Flywheel Execution

In this task, you will evaluate the agent's accuracy, tool execution logic, factual grounding, and navigation recommendations against the golden dataset (`tests/eval/datasets/evalset.json`).

#### Using the `evaluation` Skill:
Leverage the skill specification in `skills/evaluation/SKILL.md`:
1. Read `skills/evaluation/SKILL.md` or invoke the `evaluation` skill.
2. Ensure `tests/eval/datasets/evalset.json` is populated.
3. Run evaluation inference and grading:
   ```bash
   agents-cli eval run --config tests/eval/eval_config.yaml
   ```

#### Evaluated Metrics:
* **`multi_turn_task_success`**: Overall goal completion.
* **`multi_turn_tool_use_quality`**: Technical correctness of Google Search and Maps API function calling.
* **`multi_turn_trajectory_quality`**: Efficiency of planning steps.
* **`final_response_quality`**: Clarity and completeness of travel output.
* **`hallucination`**: Factual grounding against returned tool data.
* **`navigation_accuracy_judge`**: Custom LLM judge evaluating route clarity, place ratings, and address accuracy.

#### Expected Output Artifact:
* `artifacts/docs/step9_eval_report.md` (Contains metric summary scores and pass/fail analysis).

---

### Task 2: Deploy Agent to Vertex AI Agent Runtime with BigQuery Observability

In this task, you will deploy the agent to managed **Vertex AI Agent Runtime** (Reasoning Engine) with OpenTelemetry Cloud Tracing and BigQuery Agent Analytics enabled.

#### Using the `deployment` Skill:
Leverage the skill specification in `skills/deployment/SKILL.md`:
1. Read `skills/deployment/SKILL.md` or invoke the `deployment` skill.
2. Execute physical deployment with telemetry export flags and global model resolution:
   ```bash
   agents-cli deploy \
     --deployment-target agent_runtime \
     --no-confirm-project \
     --update-env-vars GOOGLE_CLOUD_LOCATION=global,OTEL_TRACES_EXPORTER=gcp_trace,GOOGLE_CLOUD_AGENT_ENGINE_ENABLE_TELEMETRY=true \
     --bq
   ```

#### Deployment Rules & Environment Handling:
* **Global Model Resolution**: Sets `GOOGLE_CLOUD_LOCATION=global` to resolve global models (e.g., `gemini-2.5-flash` or `gemini-3.5-flash`) in regional deployments (`us-central1`).
* **Telemetry Exports**: Configures `OTEL_TRACES_EXPORTER=gcp_trace` and `--bq` for automated BigQuery streaming.

#### Expected Output Artifacts:
* `artifacts/docs/step10_deploy_log.txt` (Raw deployment output logs)
* `artifacts/docs/step10_deploy_report.md` (Summary of deployed Reasoning Engine resource URI and status)

---

### Task 3: Register to Gemini Enterprise & Verify 4-Tier Observability

In this task, you will register the deployed Reasoning Engine instance into Gemini Enterprise and audit all four enterprise observability tiers.

#### Part 3A: Gemini Enterprise Registration
Leverage the skill specification in `skills/publish/SKILL.md`:
1. Verify `deployment_metadata.json` exists after Task 2 deployment.
2. Define your target Gemini Enterprise App ID:
   ```bash
   export GEMINI_ENTERPRISE_APP_ID="projects/$GCP_PROJECT_ID/locations/global/collections/default_collection/engines/cymbal-app"
   ```
3. Execute registration:
   ```bash
   agents-cli publish gemini-enterprise \
     --gemini-enterprise-app-id "$GEMINI_ENTERPRISE_APP_ID" \
     --display-name "Cymbal Navigation Agent" \
     --description "AI Travel and Navigation Planner powered by Google Search & Google Maps"
   ```
4. **Expected Outputs**: `artifacts/docs/step16_publish_log.txt` and `artifacts/docs/step16_publish_report.md`.

#### Part 3B: 4-Tier Observability Verification
Leverage the skill specification in `skills/observability/SKILL.md`:
Audit the 4 observability tiers:
1. **Cloud Trace**: OpenTelemetry span hierarchy (`invoke_agent`, `generate_content`, `execute_tool`).
2. **Prompt-Response Logging**: Verify privacy settings (`OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT=NO_CONTENT`).
3. **BigQuery Agent Analytics**: Query `agent_events` table for session traces and tool invocations:
   ```sql
   SELECT event_id, event_type, agent_name, timestamp
   FROM `YOUR_PROJECT_ID.telemetry.agent_events`
   ORDER BY timestamp DESC LIMIT 10;
   ```
4. **Third-Party Integrations**: Confirm external telemetry hooks.
5. **Expected Outputs**: `artifacts/docs/step17_observability_log.txt` and `artifacts/docs/step17_observability_report.md`.

---

## 🛠️ How to Leverage the Skills Folder (`skills/`)

The workspace includes standard skill instructions located in `skills/` (and `.agents/skills/`). Skills provide detailed instructions, schema definitions, and automated verification rules for both human developers and agentic coding assistants.

| Skill Name | Skill File Location | Primary Purpose |
|---|---|---|
| **Preflight Check** | `scripts/preflight_check.sh` | Automated verification of credentials and GCP APIs |
| **`evaluation`** | [skills/evaluation/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/evaluation/SKILL.md) | ADK evaluation run execution and score reporting |
| **`deployment`** | [skills/deployment/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/deployment/SKILL.md) | Agent Runtime deployment with telemetry & global model handling |
| **`publish`** | [skills/publish/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/publish/SKILL.md) | Programmatic Gemini Enterprise app registration |
| **`observability`** | [skills/observability/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/observability/SKILL.md) | 4-tier telemetry verification (Cloud Trace, BQ Analytics, Logging) |

---

## ✅ Summary Checklist for Lab Completion

Before submitting your lab work, verify that you have produced all required report artifacts:

- [ ] Run `bash scripts/preflight_check.sh` successfully.
- [ ] Tested local agent via `agents-cli run` or `agents-cli playground`.
- [ ] Completed Task 1 (Evaluation) and generated `artifacts/docs/step9_eval_report.md`.
- [ ] Completed Task 2 (Deployment) and generated `artifacts/docs/step10_deploy_report.md` & `step10_deploy_log.txt`.
- [ ] Completed Task 3A (Gemini Enterprise Registration) and generated `artifacts/docs/step16_publish_report.md`.
- [ ] Completed Task 3B (Observability Verification) and generated `artifacts/docs/step17_observability_report.md`.

---
*End of Student Lab Guide.*
