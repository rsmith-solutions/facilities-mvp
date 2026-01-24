# Facilities MVP — Requirements

## 1. Tenancy & Isolation
- The system is multi-tenant (each customer/church is a tenant).
- Tenants must not be able to view, infer, or access other tenants’ data.
- Tenant context is derived from authenticated identity (JWT claims), not client-supplied input.
- All data access patterns must be tenant-scoped (no table scans for business queries).

## 2. Authentication & Access Model (Invite-Only)
- Authentication uses AWS Cognito User Pool.
- Only tenant admins/managers can invite users.
- The platform owner (you) bootstraps the first tenant admin.
- Users are internal staff only (no contractor login accounts).
- Contractors/vendors are stored as tenant-owned records and referenced on work orders.

## 3. Roles (RBAC)
Roles:
- TenantAdmin: full access within tenant; manage users and roles.
- Manager: manage work orders; assign; move status; close; manage vendors.
- Technician: view assigned work orders; update status per rules; add completion info.

RBAC enforcement:
- Roles are enforced server-side.
- Client-supplied role/tenant values are never trusted.

## 4. Work Orders
### 4.1 Required fields
- equipmentId is required from day 1.
- createdAt, updatedAt required.
- status required.

### 4.2 Status values
- OPEN
- IN_PROGRESS
- ON_HOLD
- COMPLETED
- CLOSED

### 4.3 Allowed transitions
- OPEN → IN_PROGRESS
- IN_PROGRESS → ON_HOLD
- IN_PROGRESS → COMPLETED
- ON_HOLD → IN_PROGRESS
- COMPLETED → CLOSED

### 4.4 Transition rules
- CLOSED is terminal (no further transitions).
- ON_HOLD requires onHoldReason (mandatory).
- COMPLETED requires completedAt, completedBy, laborMinutes.
- Conditional writes must enforce transitions (prevent invalid jumps and race conditions).

### 4.5 Status history (audit)
- System must record append-only status changes:
  - fromStatus, toStatus, changedAt, changedBy
  - onHoldReason (when toStatus is ON_HOLD)

## 5. Equipment
- Equipment records exist per tenant.
- Minimal fields: equipmentId, name, type, location (optional: make/model/serial).
- Work orders must reference equipmentId.

## 6. Vendors / Contractors (no login)
- Vendors are tenant-owned records (no Cognito accounts).
- Work orders may reference vendor usage later (vendor requested/quoted/approved/completed).
- System must support vendor history for lifecycle metrics.

## 7. Non-Functional Requirements
Security:
- Least-privilege IAM for each Lambda.
- Encryption at rest for DynamoDB and S3.
- No public S3 access; presigned URLs used for uploads/downloads (future phase).
- API requires authentication for protected routes.

Observability:
- Structured logging (JSON) for Lambdas.
- Errors must be measurable (CloudWatch metrics/alarms in later phase).

## 8. Phasing
- Phase A: core work order lifecycle + required equipmentId.
- Phase A.5: Cognito auth + RBAC + role-aware list endpoint.
- Later phases: attachments/photos, inventory automation, vendor repair history metrics.
