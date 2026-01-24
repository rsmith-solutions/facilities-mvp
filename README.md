# Facilities MVP

This project is an early-stage facilities operations system inspired by real-world gaps observed while using existing CMMS/facilities management software in a church environment.

The goal is to design and build a **practical, affordable base system** that supports daily facility operations without unnecessary complexity, unused modules, or high cost.

This repository is being developed incrementally, with a strong emphasis on:
- Real operational workflows
- Clear scope boundaries
- Infrastructure-as-Code (Terraform)
- Near-zero idle cloud cost
- Maintainability and clarity over feature volume

---

## Problem Context

Many facilities—especially churches, nonprofits, and small organizations—need:
- A reliable way to manage work orders
- Basic documentation of maintenance activity
- Photo evidence of completed work
- Simple inventory awareness and alerts

Existing platforms often bundle these needs into expensive, inflexible packages with features that go unused and integrations that are unreliable.

This project explores an alternative approach: **start with what facilities actually need to function day-to-day, then grow deliberately.**

---

## Current Scope

- Facilities management backend MVP

- Focus on secure identity, tenancy, and core work-order lifecycle

- Infrastructure-first approach with minimal UI assumptions

## Current Architecture (Phase A.5)

- AWS API Gateway (HTTP API)
- AWS Lambda (AWS_PROXY, payload format v2.0)
- DynamoDB (single-table design)
- Amazon Cognito User Pool
- JWT authentication enforced at API Gateway

## Authentication & Authorization

- Authentication is handled by Amazon Cognito.
- API Gateway validates Cognito-issued JWTs on protected routes.
- Unauthorized requests are blocked at the gateway (Lambda not invoked).
- State-changing routes are protected; read-only routes remain public during early phasesState-changing routes are protected; health/read-only routes may remain public during early phases..

## Identity & Tenancy Model

- JWTs currently do not include an org/tenant claim (custom:* or cognito:groups).
- The JWT sub claim is treated as the authoritative user identifier.
- Tenancy is derived from a user profile record stored in DynamoDB, keyed by sub.

## User Profile Item (DynamoDB)

- PK: USER#<sub>
- SK: PROFILE
- Attributes:
   - orgId (currently ORG#default)
   - role (currently manager)
   - email
   - createdAt
   - updatedAt

## User Bootstrap Endpoint

- Endpoint: POST /me/bootstrap
- Authentication: Required (JWT)
- Purpose: One-time creation of the user profile record
- Behavior:
   - Creates the user profile if it does not exist
   - Idempotent (safe to call multiple times)
   - Does not overwrite existing data

- This endpoint must be called once per authenticated user before accessing org-scoped resources.

### Verified Behavior
  
- PATCH /work-orders/{id}/status
   - Returns 401 when no JWT is provided
   - Accepts requests with a valid Cognito JWT
- POST /me/bootstrap
   - Requires JWT
   - Successfully creates a USER#<sub> profile record
- Lambda recieves validated JWT claims via:
	event.requestContext.authorizer.jwt.claims

## Work Orders (Current State)

- Work orders are currently written using a temporary tenant pattern.
- This will be refactored in the next phase to fully enforce org-based isolation.

# Planned changes:

- Remove tenantId from request body/query
- Derive orgId from the user profile
- Update DynamoDB keys from TENANT#... to ORG#...
- Enforce org scoping on all reads and writes 

**Phase A (in progress):**

- Core work-order domain logic
- Secure identity foundation complete
- User-to-org derivation implemented
- Next focus: org-scoped work-order creation and retrieval

 * Current Phase A scope and foundations *

- Work order model design
- AWS + Terraform foundation
- Minimal backend infrastructure

Future phases will be added only after the core workflow is stable and useful.

---

## Technology Approach

- AWS (serverless-first)
- Terraform for all infrastructure
- Designed to incur little to no cost when idle
- No always-on compute

This is not a production SaaS—yet. It is a learning project with real-world intent.

---

## Status

Foundational setup complete.

## Phase A – Work Orders (Complete)

Phase A implements the core work order backend and workflow.

**Capabilities:**
- Create and retrieve work orders via HTTP API
- Enforced status transitions:
  - New → Assigned → In Progress → On Hold → Complete
- Automatic tracking of:
  - startedAt
  - completedAt
  - completedBy
  - laborMinutes (calculated)
- Completion notes supported
- Serverless architecture with near-zero idle cost

**Architecture:**
- Amazon API Gateway (HTTP API)
- AWS Lambda (Python)
- Amazon DynamoDB (single-table design with GSI)
- Infrastructure defined entirely with Terraform

This phase intentionally excludes authentication, role-based access, inventory, and attachments, which will be added incrementally in later phases.

### Testing (Development)
Endpoints can be tested using curl or Postman once deployed.  
Authentication is not yet enabled in Phase A.


Currently defining the work order domain model before implementation.

