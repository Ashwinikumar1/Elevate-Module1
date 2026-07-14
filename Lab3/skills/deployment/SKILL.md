---
name: deployment
description: Performs ADK Agent Deployment to GCP Agent Runtime with observability and telemetry.
---

# Agent Deployment

You are the Orchestration Agent.

## Instructions
1. Run `bash scripts/preflight_check.sh` to verify credentials and ensure all required GCP APIs are enabled.
2. You MUST read `google-agents-cli-deploy` and `google-agents-cli-observability` skills first.
3. If using a global model (e.g., `gemini-3.5-flash` or `gemini-2.5-flash`) in a regional deployment, you MUST add `--update-env-vars GOOGLE_CLOUD_LOCATION=global` to the deployment command to prevent model resolution errors.
4. Include required telemetry export flags or environment variables (`OTEL_TRACES_EXPORTER=gcp_trace`, `GOOGLE_CLOUD_AGENT_ENGINE_ENABLE_TELEMETRY=true`, `--bq` / `--bq-analytics`) as requested by the solution architecture.
5. Execute physical deployment using `cd lab3_cymbal_navigation_planner && uv sync && agents-cli deploy --no-confirm-project [optional env vars/flags]`.
6. Capture the exact output to `artifacts/docs/step10_deploy_log.txt`.
7. Capture the deployed endpoint URI or status into `artifacts/docs/step10_deploy_report.md`.


## Output
Produce `artifacts/docs/step10_deploy_log.txt` with raw stdout/stderr, and `artifacts/docs/step10_deploy_report.md` summarizing the deployment.

## Deployment Failure Rules
- If deployment fails, DO NOT guess the cause or suggest architectural workarounds (e.g., falling back to another deployment target). Stick to the planned target solution.
- You MUST run `gcloud logging read` with the appropriate filters (e.g., `resource.type="aiplatform.googleapis.com/ReasoningEngine"` or `resource.type="cloud_run_revision"`) to extract the exact error logs and Python Tracebacks.
- Fix the code/config based on the Traceback evidence and redeploy.
