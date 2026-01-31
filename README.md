# Facilities MVP

This project is an early-stage facilities operations system inspired by real-world gaps observed while using existing CMMS/facilities management software in a church environment.

The goal is to design and build a **practical, affordable base system** that supports daily facility operations without unnecessary complexity, unused modules, or high ongoing cost.

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

---

## Design Principles

- Identity is authoritative; clients are not trusted
- Tenant context is derived, never submitted
- Infrastructure is disposable and reproducible
- Documentation favors clarity over completeness

---

## Current Architecture (Phase A.5)

- AWS API Gateway (HTTP API)
- AWS Lambda (Python, AWS_PROXY, payload format v2.0)
- DynamoDB (single-table design)
- Amazon Cognito User Pool
- JWT authentication enforced at API Gateway

## Authentication & Authorization

- Authentication is handled by Amazon Cognito.
- API Gateway validates Cognito-issued JWTs on protected routes.
- Unauthorized requests are blocked at the gateway (Lambda not invoked).
- State-changing routes are protected;
- Health and read-only routes remain public during early phases

## Identity & Tenancy Model

- JWTs do not include an org/tenant claim.
- The JWT sub claim is treated as the authoritative user identifier.
- Tenancy is derived from a user profile record stored in DynamoDB, keyed by sub.
- Clients nexver submit orgId or tenant identifiers

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
- Purpose:
	- One-time creation of the user profile record
 	- Required before accessing org-scoped resources 
- Behavior:
   - Creates the user profile if it does not exist
   - Idempotent (safe to call multiple times)
   - Does not overwrite existing data

### Verified Behavior
  
- PATCH /work-orders/{id}/status
   - Returns 401 when no JWT is provided
   - Accepts requests with a valid Cognito JWT
- POST /me/bootstrap
   - Requires a valid Cognito JWT
   - Successfully creates a USER#<sub> profile record
- Lambda recieves validated JWT claims via:
	event.requestContext.authorizer.jwt.claims

## Work Orders (Current State)

- Work orders are currently written using a temporary tenant pattern.
- Tenant context will be fully enforced using derived orgId values in Phase A.5
- Client supplied tenant identifiers are being removed.

## Phase A – Work Orders (Complete)

Phase A implements the core work order domain logic and lifecycle, independent of identity concerns.

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

**Architecture:**
- Amazon API Gateway (HTTP API)
- AWS Lambda (Python)
- Amazon DynamoDB (single-table design)
- Infrastructure defined entirely with Terraform

Phase A deliberately focuses on domain correctness and data modeling. 

## Phase A.5 – Identity & Tenancy Enforcement (In Progress)

Phase A.5 layers secure identity and tenant isolation onto the existing work order domain.

**Capabilities:**
- Amazon Cognito User Pool authentication
- JWT validation enforced at API Gateway
- User identity derived from JWT `sub` claim
- User profile bootstrap workflow
- Organization context derived server-side

**Key Design Decisions:**
- `orgId` is not accepted from request payloads
- Tenant isolation is enforced in Lambda logic
- API Gateway blocks unauthorized requests before execution
- 
# Phase A.5 Planned changes:

- Remove 'tenantId' from request body and query parameters
- Derive 'orgId' from user profile records
- Update DynamoDB keys from 'TENANT#' ... to 'ORG#' ...
- Enforce org scoping on all reads and writes 

**Phase A (in progress):**

- Core work-order domain logic
- Secure identity foundation complete
- User-to-org derivation implemented
- Next focus: org-scoped work-order creation and retrieval

**Current Phase A scope and foundations**

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

This is not a production SaaS—yet. 
It is a learning project with real-world intent and architectual disciipline.

---

## Status

- Phase A: Complete
- Phase A.5: In Progress

## Next Steps (Explicitly Out of Scope for Now)
- Role-based access control
- Inventory and asset tracking
- File uploads and attachments
- Frontend or UI Implementation

### Testing (Development)
Endpoints can be tested using curl or Postman once deployed.  
Authentication is not yet enabled in Phase A.


Currently defining the work order domain model before implementation.

