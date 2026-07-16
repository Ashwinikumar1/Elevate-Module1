---
name: observability
description: Performs ADK Observability, Tracing & Logging Verification of Deployed Target Agent.
---

# Observability, Tracing & Logging Verification

You are the Orchestration Agent.

## Instructions
1. You MUST read `google-agents-cli-observability` and `google-agents-cli-workflow` skills before execution.
2. Run `bash scripts/preflight_check.sh` to verify credentials and ensure required telemetry APIs (`logging.googleapis.com`, `monitoring.googleapis.com`, `bigquery.googleapis.com`) are enabled.
3. Verify that the Target Agent has been deployed (`deployment` skill) and that `deployment_metadata.json` exists in `lab3_cymbal_navigation_planner/` or container deployment variables are known.
4. Inspect and verify the four ADK observability tiers on the deployed agent:
   - **Cloud Trace**: OpenTelemetry span hierarchy (`invocation`, `call_llm`, `execute_tool`). Verify `otel_to_cloud=True` (or automatic Agent Runtime tracing).
   - **Prompt-Response Logging**: Verify `OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT` mode (`NO_CONTENT` by default, `true`, or `false`) and `LOGS_BUCKET_NAME`.
   - **BigQuery Agent Analytics**: Verify BigQuery telemetry configuration (either via platform-native export `--bq`/`--bq-analytics` or code-level `BigQueryAgentAnalyticsPlugin`) and dataset configuration (`BQ_ANALYTICS_DATASET_ID` or telemetry dataset). Note: Code-level plugin is optional when platform `--bq` streaming is enabled.
   - **Third-Party Integrations**: Verify any external telemetry configuration (AgentOps, Phoenix, MLflow, etc.).
5. Capture the raw inspection command output and telemetry status checks to `artifacts/docs/observability_log.txt`.
6. Capture the verified configuration state, active tiers, privacy settings, and overall status into `artifacts/docs/observability_report.md`.

## Output
Produce `artifacts/docs/observability_log.txt` with raw stdout/stderr, and `artifacts/docs/observability_report.md` summarizing the observability verification.

## Observability Failure Rules
1. If observability verification fails, DO NOT guess the cause or suggest architectural workarounds. Stick to the planned target solution.
2. If traces or logs are missing, check `gcloud logging read` or inspect exact environment variable configuration and IAM roles (`cloudtrace.agent`, `storage.objectCreator`, BQ editor).
3. Apply evidence-based code/configuration adjustments and re-run verification.
