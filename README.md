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

**Phase A (in progress):**
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
Currently defining the work order domain model before implementation.

