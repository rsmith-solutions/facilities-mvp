## DynamoDB Key Design (Work Orders)

Table: facilities_work_orders

WorkOrder item:
- PK = ORG#<orgId>
- SK = WO#<workOrderId>

Assignee index (GSI1):
- GSI1PK = ASSIGNEE#<userId>
- GSI1SK = ORG#<orgId>#WO#<workOrderId>
