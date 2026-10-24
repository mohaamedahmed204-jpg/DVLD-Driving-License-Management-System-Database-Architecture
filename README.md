# 🚗 DVLD - Driving License Management System Database Architecture

[![Database](https://img.shields.io/badge/Database-SQL_Server-0078D4?style=flat&logo=microsoftsqlserver&logoColor=white)](#)
[![Design Tool](https://img.shields.io/badge/Design_Tool-Draw.io-F08705?style=flat&logo=diagramsdotnet&logoColor=white)](#)
[![Architecture](https://img.shields.io/badge/Architecture-ERD_%26_Relational-44CC11?style=flat)](#)

> A production-ready, fully normalized relational database architecture designed to manage the entire lifecycle of driving licenses, applicant test appointments, violations, and international permits.

---

## 🌟 Overview

The **DVLD (Driving & Vehicle License Department)** database is an enterprise-level data architecture designed to manage complex real-world workflows for government driver licensing agencies[cite: 2, 3]. It spans 14 core entities that handle every stage of driver administration: from initial citizen registration and application submission, through multi-tier testing workflows, to license issuance, international permit cross-referencing, and license detentions/fines.

This repository provides:
1. **Database Script & Backup File:** Complete `.bak` and SQL DDL scripts (`DVLD.bak` & `CraeteMyDVLD.sql`) containing ready-to-use sample data for testing[cite: 1, 4].
2. **Entity-Relationship Diagram (ERD):** Conceptual conceptualization built using Draw.io (`DVLD_ERD - Driving License Management.drawio`)[cite: 2].
3. **Relational Schema:** Physical database schema detailing primary/foreign key mappings and constraints (`DVLD_RelationalSchema.drawio`)[cite: 3].

---

## ⚙️ Core Operations & Business Workflows (In Detail)

### 1. 👤 People & User Management Workflow
* **Centralized Identity Registry (`People`):** Serves as the single source of truth for all individuals (citizens, drivers, system users)[cite: 4]. Tracks personal data such as `NationalID`, `FirstName`, `LastName`, `DateOfBirth`, `Gender`, `Address`, `Phone`, `Email`, and `NationalityCountryID`[cite: 4].
* **System Access & Authentication (`Users`):** Manages administrative system users with credentials (`UserName`, `Password`), linked directly to an individual's `PersonID` with account activation toggles (`IsActive`)[cite: 4].

---

### 2. 📝 Application Lifecycle Management
* **Core Application Tracking (`Applications`):** Centralizes all system requests (New License, Renewal, Replacement, International License)[cite: 4]. Records `ApplicationDate`, `ApplicationStatus` (e.g., New, Cancelled, Completed), `LastStatusDate`, `PaidFees`, and the `CreatedByUserID` for auditability[cite: 4].
* **Application Types (`ApplicationTypes`):** Lookup table specifying dynamic fees (`ApplicationFees`) and titles for each application type[cite: 4].

---

### 3. 🚗 Local License Application Process
* **License Subscriptions (`LocalDrivingLicenseApplications`):** Links a base application to a specific target `LicenseClassID` (e.g., Small Commercial, Heavy Duty, Motorcycle)[cite: 4].
* **Class Constraints (`LicenseClasses`):** Enforces business rules per class, such as `MinimumAllowedAge`, `DefaultValidityLength` (in years), and `ClassFees`[cite: 4].

---

### 4. 📝 Multi-Stage Testing Pipeline
* **Test Types (`TestTypes`):** Defines the sequential 3-phase evaluation system:
  1. **Vision Test**
  2. **Written/Theory Test**
  3. **Practical/Street Test**
* **Appointment Scheduling (`TestAppointments`):** Manages appointment bookings per applicant and test type[cite: 4]. Implements an `IsLocked` flag once a test is taken or passed, preventing duplicate booking conflicts, and supports retake applications via `RetakeTestApplicationID`[cite: 4].
* **Test Execution & Results (`Tests`):** Stores pass/fail outcomes (`TestResult` bit), examiner notes (`Notes`), and audit logs (`CreatedByUserID`)[cite: 4].

---

### 5. 💳 Driver & License Issuance System
* **Driver Conversion (`Drivers`):** Converts an applicant into an official driver upon passing all tests, referencing `PersonID` and tracking `CreatedDate`[cite: 4].
* **Local License Issuance (`Licenses`):** Generates active driver cards linked to `ApplicationID`, `DriverID`, and `LicenseClassID`[cite: 4]. Controls expiration dates (`ExpirationDate`), active flags (`IsActive`), and `IssueReason` (First Time, Renew, Replacement for Damaged/Lost)[cite: 4].

---

### 6. 🌐 International Driving Permits
* **International Issuance (`InternationalLicenses`):** Issues international permits cross-referenced with a valid, active local license (`IssuedUsingLocalLicenseID`) and `DriverID`[cite: 4]. Inherits validity checking from the underlying local license[cite: 4].

---

### 7. ⚖️ Detained Licenses & Fines Management
* **Detention Registry (`DetainedLicenses`):** Handles traffic violations by locking a driver's license (`LicenseID`), recording the `DetainDate`, and assigning `FineFees`[cite: 4].
* **Release Workflow:** Tracks the release status (`IsReleased`), release date (`ReleaseDate`), releasing officer (`ReleasedByUserID`), and the associated release application (`ReleaseApplicationID`)[cite: 4].

---

## 💡 Key Architectural Concepts Demonstrated

* **3NF Database Normalization:** Minimizes data redundancy and prevents insertion/update/deletion anomalies across 14 relational tables[cite: 4].
* **Generalization & Specialization (IS-A Relationships):** Implements single-table inheritance patterns where `People` generalizes `Drivers` and `Users`[cite: 4].
* **Audit Trail Accountability:** Enforces data governance across all transactional tables through `CreatedByUserID` and `CreatedDate` fields[cite: 4].
* **Strict Referential Integrity:** Leverages foreign key relationships to prevent orphaned records (e.g., preventing a license from being issued without a passed test and valid application)[cite: 4].
* **State Machine Pattern:** Uses status columns (`ApplicationStatus`, `IsActive`, `IsLocked`, `IsReleased`) to maintain valid state transitions throughout complex business flows[cite: 4].

---

## 📐 Architecture & Design Artifacts

| Artifact | File Name | Description |
| :--- | :--- | :--- |
| **Database Script** | `CraeteMyDVLD.sql`[cite: 4] | T-SQL DDL script creating tables, constraints, and foreign keys. |
| **Database Backup** | `DVLD.bak` | Full MS SQL Server backup with populated sample data for live testing. |
| **ER Diagram** | `DVLD_ERD - Driving License Management.drawio`[cite: 2] | High-level conceptual diagram mapping entities, attributes, and relationships. |
| **Relational Schema** | `DVLD_RelationalSchema.drawio`[cite: 3] | Physical schema diagram illustrating foreign keys, data types, and cardinality. |

---

## 🛠️ Technologies Used

* **Database Engine:** Microsoft SQL Server (T-SQL)[cite: 1, 4]
* **Diagramming Tool:** Draw.io (Diagrams.net)[cite: 2, 3]
* **Versioning & Backup:** SQL Server `.bak` format[cite: 1]

---

## 🚀 Getting Started & Testing

1. Restore Database in SSMS:
    * Open SQL Server Management Studio (SSMS).
    * Right-click Databases > Restore Database...
    * Select Device and browse to the included `DVLD.bak` file[cite: 1].

2. Execute Queries:
    * Start querying tables like `People`, `Applications`, `Licenses`, and `DetainedLicenses` to analyze system workflows[cite: 4]!
  
    * 
