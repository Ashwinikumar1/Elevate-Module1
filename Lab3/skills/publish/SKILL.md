---
name: publish
description: Performs Gemini Enterprise Publishing & Registration of Deployed Target Agent.
---

# Gemini Enterprise Agent Publishing & Registration

You are the Orchestration Agent.

## Instructions
1. You MUST read `google-agents-cli-publish` and `google-agents-cli-workflow` skills before execution.
2. Run `bash scripts/preflight_check.sh` to verify credentials and ensure required GCP APIs are enabled (including `discoveryengine.googleapis.com`).
3. Verify that the Target Agent has been deployed (`deployment` skill) and that `deployment_metadata.json` exists in `lab3_cymbal_navigation_planner/` (for Agent Runtime) or that the deployed Cloud Run agent card URL (`--agent-card-url`) is available.
4. Ensure the Gemini Enterprise App resource ID is configured via the `--gemini-enterprise-app-id` flag (`projects/<project>/locations/global/collections/<collection>/engines/<engine>`) or the `GEMINI_ENTERPRISE_APP_ID` (or `ID`) environment variable.
5. Execute physical publishing non-interactively using:
   ```bash
   cd lab3_cymbal_navigation_planner && agents-cli publish gemini-enterprise --gemini-enterprise-app-id "$GEMINI_ENTERPRISE_APP_ID" --display-name "Cymbal Navigation Agent" --description "AI Travel and Navigation Planner powered by Google Search & Google Maps"
   ```
6. Capture the raw command output and registration JSON response to `artifacts/docs/publish_log.txt`.
7. Capture the registered Gemini Enterprise engine/collection details, agent display name, registration type (`adk` vs `a2a`), and status into `artifacts/docs/publish_report.md`.

## Output
Produce `artifacts/docs/publish_log.txt` with raw stdout/stderr, and `artifacts/docs/publish_report.md` summarizing the Gemini Enterprise registration.

## Publishing Failure Rules
1. If registration fails, DO NOT guess the cause or suggest architectural workarounds. Stick to the planned target solution.
2. For `Session not found` errors on Agent Runtime, upgrade `google-cloud-aiplatform` SDK (> 1.128.0) in the project requirements, redeploy, and re-run publishing.
3. Inspect `publish_log.txt` or query `gcloud logging read` for exact HTTP error messages and tracebacks, apply evidence-based fixes, and re-run.
