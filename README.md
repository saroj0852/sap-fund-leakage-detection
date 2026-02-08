# 📊 SAP ABAP – Fund Leakage Detection System

## Overview
This project is a rule-based financial risk analysis system developed in SAP ABAP.

It compares allocated funds with actual utilization and classifies departments into:
- High Risk
- Medium Risk
- Low Risk

## Features
- Fiscal year selection
- Dynamic risk threshold configuration
- Utilization percentage calculation
- Traffic light risk indicator
- ALV interactive output
- Modular architecture using INCLUDE programs

## Business Logic
Utilization % = (Utilized / Allocated) × 100

Risk Rules:
- > 100% → High Risk
- 70–100% → Medium Risk
- < 70% → Low Risk

## Technical Components
- ABAP Report Programming
- Internal Tables
- Modular Programming
- ALV (CL_SALV_TABLE)

## Author
Veda
SAP ABAP Developer
