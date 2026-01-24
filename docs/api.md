# Work Orders API (Minimum Contract)

Base: API Gateway REST API
Auth: Cognito JWT Authorizer
Content-Type: application/json

## POST /work-orders
Creates a work order.

Auth: REQUIRED

Request body (minimum):
{
  "orgId": "ORG_ID",
  "title": "TITLE",
  "description": "DESCRIPTION",
  "priority": "low|medium|high",
  "assignedTo": "USER_ID_OR_NULL"
}

Response:
- 201 Created
{
  "id": "WORK_ORDER_ID",
  "orgId": "ORG_ID",
  "title": "TITLE",
  "description": "DESCRIPTION",
  "priority": "low|medium|high",
  "status": "new",
  "assignedTo": "USER_ID_OR_NULL",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}

Errors:
- 400 Bad Request (validation)
- 401 Unauthorized / 403 Forbidden

## GET /work-orders/{id}
Fetches a work order by id.

Auth: REQUIRED

Response:
- 200 OK (same shape as POST response)
- 404 Not Found

Errors:
- 401 Unauthorized / 403 Forbidden

## PATCH /work-orders/{id}/status
Updates the status of a work order.

Auth: REQUIRED

Request body:
{
  "status": "new|assigned|in_progress|blocked|done|cancelled"
}

Allowed transitions:
- new -> assigned|cancelled
- assigned -> in_progress|blocked|cancelled
- in_progress -> blocked|done|cancelled
- blocked -> in_progress|cancelled
- done -> (terminal)
- cancelled -> (terminal)

Response:
- 200 OK (updated item)
Errors:
- 400 Bad Request (invalid status or invalid transition)
- 404 Not Found
- 401 Unauthorized / 403 Forbidden
