# Project Elevate: Module 1 Strategic Overview & Curriculum Journey

**Target Audience**: Customer Engineers (Practice CEs, Platform CEs, Partner Advisors, Outcome CEs) & Solution Architects  
**Scope**: Module 1 Curriculum Positioning (Connecting Module 0 ➔ Module 1 [Labs 1, 2, 3] ➔ Advanced Agent Modules)  
**Author**: Ashwini Kumar

---

## Curriculum Positioning

In the evolving cloud landscape, Customer Engineers (CEs) must move beyond manual, console-driven demonstrations to position **Agentic AI-assisted cloud engineering**. **Project Elevate** is structured as a progressive learning journey:

```
+-----------------------------------------------------------------------------------+
| MODULE 0: Agentic Foundations & Tooling Landscape                                 |
| • Understanding VS Code Antigravity IDE, Agentic Test Harness & google-agents-cli |
| • Establishing Model Context Protocol (MCP) & Google Agent Skills primitives       |
+-----------------------------------------------------------------------------------+
                                         │
                                         ▼
+-----------------------------------------------------------------------------------+
| MODULE 1: Applied Core Competency (Labs 1, 2 & 3)                                 |
| • Lab 1: App Containerization, Multi-Region Routing & Zero-Console Outage Triage  |
| • Lab 2: AWS-to-GCP Enterprise Migration, Compliant IaC & Migration Center AI      |
| • Lab 3: ADK Agent Evaluation, Agent Runtime Deployment & GE Publishing            |
+-----------------------------------------------------------------------------------+
                                         │
                                         ▼
+-----------------------------------------------------------------------------------+
| ADVANCED MODULES: Architectural Choices, FinOps & Production Governance           |
| • Architectural decision frameworks & trade-off analysis (Latency vs. Accuracy)  |
| • FinOps token optimization, cost engineering & enterprise scale governance      |
+-----------------------------------------------------------------------------------+
```


### Strategic Value of Module 1 for Customer Engineers:
Module 1 serves as the critical bridge where CEs transition from tool literacy (Module 0) to **remediating, migrating, evaluating, deploying, and observing real-world workloads** using Agentic AI tooling. CEs demonstrate how agentic workflows accelerate customer migrations, maintain strict organization security policies, enforce zero-console production discipline, and validate AI quality before enterprise publishing.

---

## Connecting Lab 1, Lab 2, and Lab 3

The three labs in Module 1 form a cohesive story representing the typical end-to-end customer digital transformation journey for **Cymbal Group**:

```
+------------------+         +------------------+         +------------------+
|      LAB 1       |         |      LAB 2       |         |      LAB 3       |
|  Containerize &  | ======> |  Migrate AWS to  | ======> | Build & Observe  |
| Remediate App    |         | GCP Infrastructure|        | Enterprise Agent |
+------------------+         +------------------+         +------------------+
```

### 1. Lab 1: Legacy Application Containerization & Outage Remediation
* **Customer Context**: Cymbal Group modernizes its legacy monolithic HR vacation service into containerized Cloud Run microservices connected to multi-region Cloud SQL Postgres.
* **CE Relevance**: Customers frequently face post-migration outages caused by misconfigurations. In a restricted production environment with **no manual GCP console access**, CEs leverage Agentic AI tools to parse Cloud Logging traces, identify cross-region transatlantic latency (`DB_READ_HOST`), refactor connection pool memory leaks (`new Pool()`), and imperatively hotfix Cloud Run revisions.
* **Key Outcome**: Proves how agentic CLI tools accelerate high-pressure root cause analysis (RCA) and hotfixing without human console error.

### 2. Lab 2: AWS-to-GCP Enterprise Reference Migration (Challenge Lab)
* **Customer Context**: Cymbal Group's **AdServer Production Migration Team** provides an AWS state dump export (`aws_environment.json`) containing EC2, EKS, KMS, and S3 resources.
* **CE Relevance**: CEs frequently receive raw third-party environment exports during pre-sales discovery. CEs use Agentic AI tools to ingest `aws_environment.json`, generate cross-cloud mapping matrices, construct logical architecture diagrams, draft TCO value proposition reports, and write org-policy compliant GCP Terraform (enforcing private GKE clusters & Shielded VMs). Finally, CEs use GCP Migration Center AI features to generate tailored executive proposals.
* **Key Outcome**: Demonstrates how Agentic AI turns unstructured customer exports into deployable IaC and executive business proposals in minutes.

### 3. Lab 3: ADK Agent Evaluation, Deployment, Publishing & 4-Tier Observability
* **Customer Context**: With core infrastructure and apps modernized on GCP, Cymbal Group builds an intelligent AI travel assistant (**Cymbal Navigation Agent**) integrating Google Search & Google Maps API tools.
* **CE Relevance**: Deploying GenAI agents requires rigorous quality control and enterprise observability. CEs run automated preflight service API checks (`preflight_check.sh`), execute the ADK Quality Flywheel evaluation over golden datasets (`evalset.json` & `eval_config.yaml`), deploy to Vertex AI Agent Runtime (Reasoning Engine) with global model handling, programmatically register endpoints into Gemini Enterprise, and audit the 4 enterprise telemetry tiers (Cloud Trace, Prompt-Response Logging, BigQuery Agent Analytics, and Third-Party integration).
* **Key Outcome**: Establishes the complete Agent Development Life Cycle (ADLC)—moving from prototype code to production reasoning engines with enterprise telemetry verification.

---

## 📊 Summary Comparison Matrix: Module 1 Labs

| Dimension | Lab 1 | Lab 2 | Lab 3 |
|---|---|---|---|
| **Core Domain** | App Modernization & Outage Remediation | Infrastructure Migration & Compliance | AI Agent Lifecycle & Governance |
| **Customer Target** | Cymbal HR Monolith ➔ Cloud Run | Cymbal AdServer AWS ➔ GCP Migration | Cymbal Navigation Agent |
| **CE Skill Mastery** | Log Triage, Zero-Console Hotfix | Ingest JSON State, IaC, TCO Proposal | ADK Evaluation, Agent Runtime, GE |
| **Agentic AI Role** | Code & Log Parsing, Refactoring | Cross-Cloud Mapping & IaC Generation | Quality Flywheel & Telemetry Audit |
| **Grading Method** | `verify.sh` (Cloud Run & Routing) | `verify.sh` (GKE, VPC, KMS, GCS) | Metric Reports & Telemetry Checks |

---

## 🚀 Transitioning to Advanced Agentic Modules

By completing Module 1, Customer Engineers possess practical, validated capability across app modernization (Lab 1), cloud migration IaC (Lab 2), and basic ADK agent deployment & observability (Lab 3). 

This sets the exact technical baseline required for **Advanced Agentic Modules**, where CEs make critical architectural choices, dive deep into framework selection trade-offs, optimize FinOps & LLM token consumption models, evaluate latency vs. quality constraints, and design enterprise governance strategies for production scale.



