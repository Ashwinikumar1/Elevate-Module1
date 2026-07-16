# Lab 3: Cymbal Navigation & Planner Agent Implementation, Evaluation, Deployment & Publishing

Welcome to **Lab 3** of Project Elevate! This repository contains the complete implementation, evaluation suite, deployment automation, and registration workflows for the **Cymbal Navigation & Planner Group**.

> 📖 **Primary Student Guide**: For detailed step-by-step instructions, learning objectives, rubric checklists, and task walkthroughs, please refer to the **[Student Lab Guide (STUDENT_LAB_GUIDE.md)](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/STUDENT_LAB_GUIDE.md)**.

---

## 🏬 Problem Scenario & Architecture

**Cymbal Group** requires an enterprise location-aware travel and event planning assistant. Customer engineers have pre-developed the core agent code in `cymbal_navigation_agent/`. 

The agent integrates two key tools:
1. **Built-in Google Search Tool** (`google_search` from `google.adk.tools`): For up-to-date web intelligence, event schedules, and reviews.
2. **Google Maps API Tools** (`search_google_maps` & `get_route_directions` in `tools.py`): For location details, physical addresses, coordinates, and multi-modal route calculation.

```
lab3_cymbal_navigation_planner/
├── README.md                          # Master Overview (You are here)
├── STUDENT_LAB_GUIDE.md               # Primary Exhaustive Student Guide & Rubric
├── agents-cli-manifest.yaml           # agents-cli configuration manifest
├── pyproject.toml                     # Python dependencies & build configuration
├── scripts/
│   └── preflight_check.sh             # GCP Auth & Service API verification script
├── skills/                            # Standardized Agentic Skills
│   ├── evaluation/SKILL.md            # Skill: ADK Agent Evaluation
│   ├── deployment/SKILL.md            # Skill: Agent Runtime Deployment
│   ├── publish/SKILL.md               # Skill: Gemini Enterprise Publishing
│   └── observability/SKILL.md         # Skill: 4-Tier Observability Audit
├── cymbal_navigation_agent/           # Core Agent Package (Customer Provided)
│   ├── agent.py                       # ADK Agent definition & prompt logic
│   ├── tools.py                       # Google Maps Places & Directions API tools
│   └── app_utils/
│       └── deploy.py                  # Agent Runtime deployment script
└── tests/
    └── eval/                          # Evaluation Suite
        ├── datasets/
        │   ├── evalset.json           # Comprehensive evaluation dataset
        │   └── basic-dataset.json     # Default fallback evaluation dataset
        └── eval_config.yaml           # Metric configuration (built-in & custom metrics)
```

---

## 🎯 Learning Objectives & Prerequisites

### Learning Objectives:
* Validate GCP preflight authentication and service API status.
* Test agent code locally via CLI non-interactive prompts and interactive web UI playground.
* Execute the ADK Quality Flywheel evaluation suite (inference + grading with LLM-as-judge).
* Deploy to managed Vertex AI Agent Runtime (Reasoning Engine) with global model handling and BigQuery telemetry.
* Programmatically publish and register deployed reasoning engine endpoints into Gemini Enterprise.
* Audit and verify the 4 enterprise telemetry tiers (Cloud Trace, Prompt-Response Logging, BigQuery Agent Analytics, Third-Party integrations).

### Prerequisites:
* **Altostrat GCP Account** with `roles/owner` or `roles/editor`.
* Active `gcloud` login: `gcloud auth application-default login`.
* Target GCP Project set: `gcloud config set project YOUR_PROJECT_ID`.
* Installed `agents-cli`, `uv`, `python 3.10+`.

---

## ⚡ Quick Task Overview (3 Core Student Tasks)

### Step 0: Mandatory GCP Preflight Check
Verify active credentials and enable all mandatory GCP service APIs (`aiplatform`, `cloudresourcemanager`, `iam`, `logging`, `monitoring`, `bigquery`, `discoveryengine`):
```bash
bash scripts/preflight_check.sh
```

### Step 1: Local Development & Smoke Testing
Test the pre-developed customer agent code locally:
```bash
# Non-interactive CLI prompt execution
agents-cli run "Find upcoming events at Moscone Center and give me driving directions from SFO"

# Launch interactive web playground
agents-cli playground
```

### Task 1: Execute ADK Evaluation (Quality Flywheel)
Leverage [skills/evaluation/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/evaluation/SKILL.md) to run inference and LLM-as-judge scoring:
```bash
agents-cli eval run --config tests/eval/eval_config.yaml
```
*Output Report*: `artifacts/docs/eval_report.md`

### Task 2: Deploy to Vertex AI Agent Runtime with BigQuery Observability
Leverage [skills/deployment/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/deployment/SKILL.md) to deploy as a Reasoning Engine instance:
```bash
agents-cli deploy \
  --deployment-target agent_runtime \
  --no-confirm-project \
  --update-env-vars GOOGLE_CLOUD_LOCATION=global,OTEL_TRACES_EXPORTER=gcp_trace,GOOGLE_CLOUD_AGENT_ENGINE_ENABLE_TELEMETRY=true \
  --bq
```
*Output Artifacts*: `artifacts/docs/deploy_log.txt` & `artifacts/docs/deploy_report.md`

### Task 3A: Register Deployed Agent to Gemini Enterprise
Leverage [skills/publish/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/publish/SKILL.md) to register your agent endpoint:
```bash
export GEMINI_ENTERPRISE_APP_ID="projects/YOUR_PROJECT_ID/locations/global/collections/default_collection/engines/cymbal-app"

agents-cli publish gemini-enterprise \
  --gemini-enterprise-app-id "$GEMINI_ENTERPRISE_APP_ID" \
  --display-name "Cymbal Navigation Agent" \
  --description "AI Travel and Navigation Planner powered by Google Search & Google Maps"
```
*Output Artifacts*: `artifacts/docs/publish_log.txt` & `artifacts/docs/publish_report.md`

### Task 3B: Verify 4-Tier Enterprise Observability
Leverage [skills/observability/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/observability/SKILL.md) to audit Cloud Trace, Prompt-Response Logging, and BigQuery telemetry.
*Output Artifacts*: `artifacts/docs/observability_log.txt` & `artifacts/docs/observability_report.md`

---

## 🛠️ Leveraging Skills in `skills/` Folder

This project equips agents and human engineers with dedicated skills in `skills/` (and `.agents/skills/`):
* **`evaluation`**: [skills/evaluation/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/evaluation/SKILL.md)
* **`deployment`**: [skills/deployment/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/deployment/SKILL.md)
* **`publish`**: [skills/publish/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/publish/SKILL.md)
* **`observability`**: [skills/observability/SKILL.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/skills/observability/SKILL.md)

---
*For full walkthroughs and evaluation rubrics, refer to **[STUDENT_LAB_GUIDE.md](file:///Users/ashwinikm/Desktop/Project_Elevate/lab3_cymbal_navigation_planner/STUDENT_LAB_GUIDE.md)**.*
