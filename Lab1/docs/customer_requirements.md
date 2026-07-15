# Customer Requirements & Meeting Call Transcripts
**Customer**: Cymbal Group — Enterprise Architecture & Global HR Technology Division  
**Project**: Vacation Request Subsystem Infrastructure Modernization  
**Date**: July 10, 2026  
**Participants**:
* **Marcus Vance** — VP of Enterprise Architecture, Cymbal Group
* **Elena Rostova** — Lead Infrastructure Architect, Cymbal Group
* **David Chen** — Global HR Operations Director, Cymbal Group
* **Lead Platform CE** — Google Cloud Platform Engineering Team

---

## 📞 Executive Meeting Call Transcript

**Marcus Vance (VP of Enterprise Architecture)**:  
"Thanks everyone for joining. As you know, our internal HR Vacation Request Subsystem is critical across retail operations, healthcare staffing, and financial compliance. Last month, during our Q2 review cycle, a minor networking degradation in `us-central1` cascaded into a complete outage. Over 15,000 international employees across EMEA and APAC were locked out. Beyond the outage, our European clinical staff routinely complain of 800ms+ latency when querying accrual balances. We cannot enter Q3 with a single-region single-point-of-failure (SPOF)."

**Elena Rostova (Lead Infrastructure Architect)**:  
"Let me summarize our current technical baseline. Today, the entire application lives in `us-central1`. We have containerized Cloud Run services for the Node.js frontend and backend. They connect to a single Cloud SQL PostgreSQL instance for relational records and native Firestore for async state. Networking is handled via a single VPC subnetwork with Serverless VPC Access connectors. Traffic goes directly to the regional Cloud Run URL, which means we have zero global load balancing or regional failover capability."

**David Chen (Global HR Operations Director)**:  
"From an operational perspective, our key requirements for the modernized system are:
1. **Low Latency**: Read requests from EMEA and APAC must complete in under 50ms locally.
2. **High Availability**: If the entire primary US region goes down, the system must fail over automatically to a secondary European region without dropping user sessions or causing data corruption.
3. **Data Consistency**: Relational database records for vacation balances must remain strictly consistent, while NoSQL workflow states and notifications must be globally available.
4. **Caching Layer**: Frequent balance lookups and session state should be cached to relieve DB pressure during quarterly spikes."

**Elena Rostova**:  
"To fulfill David's team's needs, we designed a multi-region modernization architecture:
- **Secondary Regional Subnet**: Extend our foundational VPC into `europe-west1`.
- **Symmetric Compute Layer**: Deploy Cloud Run frontend and backend symmetrically across both `us-central1` and `europe-west1`.
- **Database Replication**: Provision a Cloud SQL Cross-Region Read Replica in `europe-west1` to handle regional read traffic, and configure Firestore for multi-region availability.
- **Caching Tier**: Provision a Memorystore for Redis instance in the private network for sub-millisecond session and balance caching.
- **Global Anycast Routing**: Place a Global External Application Load Balancer (GCLB) with Serverless NEGs in front of both Cloud Run regions so traffic is dynamically routed to the nearest operational region."

**Marcus Vance**:  
"One final directive: Cymbal's security policy strictly mandates **zero manual Google Cloud Console edits**. All infrastructure discovery, refactoring, code generation, and deployment must be executed using modern **Agentic AI tools**, declarative IaC (Terraform) for baseline infrastructure, and imperative tool calling (`gcloud` CLI / MCP) for multi-region rollout. We need full automated verification and scoring reports."

---

## 🎯 Modernization Requirements Specification

| Requirement ID | Architectural Dimension | Requirement Description | Target State |
|---|---|---|---|
| **REQ-01** | Global Traffic Routing | Implement Anycast IP routing with automatic failover between US and EU compute services. | Global External HTTP(S) Application Load Balancer with Serverless NEGs targeting `us-central1` and `europe-west1`. |
| **REQ-02** | Geographic Redundancy | Compute tier must be symmetrically deployed across two geographic regions to eliminate single-region SPOF. | Cloud Run Frontend and Backend deployed in both `us-central1` and `europe-west1`. |
| **REQ-03** | Database Read Acceleration | Regional read traffic in EMEA must execute against a local database instance to guarantee <50ms read latency. | Cloud SQL PostgreSQL Cross-Region Read Replica in `europe-west1`. |
| **REQ-04** | Async Workflow Resilience | Asynchronous vacation request state and notifications must survive single-region outages. | Multi-Region / Dual-Region Firestore document store configuration. |
| **REQ-05** | High-Performance Caching | Reduce database query load during quarterly balance review peaks. | Provision Memorystore for Redis caching instance within the private VPC. |
| **REQ-06** | Zero-Console Policy | Modernization must be executed exclusively using Agentic AI tooling, Terraform IaC, and MCP CLI tool calls. | 100% automated agentic deployment and log verification without manual console access. |
