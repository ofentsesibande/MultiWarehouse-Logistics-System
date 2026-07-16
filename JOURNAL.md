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