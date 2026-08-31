### Systems Analyst Summary
## Phase 1: Sign-Off (Summary)

Project Name: Multi-Warehouse Inventory & Logistics Optimization System  
Analyst: Ofentse Sibande (Tshwane University of Technology)  
Key Problems Solved:
*   **Revenue Leakage & Process Bottlenecks:** Mitigated through a documented, dual-verification state-machine workflow for inter-warehouse transfers (FR-105/106).  
*   **Data Inconsistencies ("Phantom Inventory"):** Controlled via strict database-level transactional boundaries (ACID) to handle concurrent warehouse operations seamlessly (NFR-201).  
*   **Operational Inefficiencies:** Optimized using an automated, math-driven low-stock warning model (FR-107/108).  
*   **Access Management Rules (RBAC):** Defined explicit operational privileges dividing local Warehouse Staff transactions from globally scoped Logistics Manager administrative capabilities.  
*   **Platform & Workflow Integrity:** Executed within an isolated development feature branch (feat/phase1-requirements), mapped through a local-to-remote deployment workflow, and successfully integrated via a structured Pull Request into the central development branch (dev).  

## Phase 2: System Architecture & Data Modeling
*   **Objective:** Translate functional requirements into a 3rd Normal Form database blueprint.
*   **Design Decision:** Chose a Composite Primary Key configuration for the `Stock_Levels` bridge table using `(WarehouseID, ProductID)`. This avoids redundant rows and guarantees that a single warehouse cannot have duplicate rows for the same SKU, enforcing relational data integrity at the database engine layer.
*   **Risk Mitigated:** By designing an immutable `Inventory_Logs` table, any stock anomalies can be fully auditable by tracking the exact user, time, and quantity changed, addressing the corporate goal of avoiding "phantom inventory".

## Phase 3: Prototyping & Technical Implementation
* **Objective:** Translate 3NF structural concepts into standardized, executable SQL schema matrices.
* **Key Challenge Overcome:** Enforcing data constraints at the engine level rather than relying on application code. Implemented the `CHECK (Quantity >= 0)` constraint directly inside the `Stock_Levels` table definition. This strictly guarantees that software bugs cannot result in physically impossible negative stock balances, maintaining absolute ledger integrity.
* **Testing Mechanics:** Configured repeatable seeding metrics detailing contrasting stock levels (normal vs. low-stock thresholds) across three regional fulfillment centers (Johannesburg, Pretoria, Durban) to verify alert criteria and role-based querying models dynamically.

### Phase 3 Analyst Sign-Off & Summary
* **Database Schema Instantiation:** Transformed 3NF layouts into executable SQL DDL scripts (`database/schema.sql`) defining constraints, composite keys, and audit logging tables.
* **Engine-Level Integrity:** Applied explicit `CHECK` constraints to guarantee stock cannot drop below zero.
* **Audit Trail Strategy:** Built an immutable `Inventory_Logs` table capturing transaction types, timestamps, user IDs, and quantity shifts to eradicate phantom inventory.
* **Seeding Strategy:** Created `database/seed.sql` representing regional distribution hubs with contrasting stock levels to test dynamic automated reorder calculations.