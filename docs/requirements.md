# Functional Requirements Document (FRD)
## Project: Multi-Warehouse Inventory & Logistics Optimization System
**Version:** 1.0.0  
**Author:** Ofentse Sibande  
**Target Role:** Junior Systems Analyst  

---

## 1. Introduction & Problem Domain
A growing regional distribution business experiences an estimated 15% leakage in gross revenue due to systemic data fragmentation across multiple physical warehouses[cite: 1]. Core operational challenges include phantom inventory listings, manual paper-based transfer tracking, stockouts during peak demand cycles, and a general lack of transactional data integrity[cite: 1]. 

The objective of this system is to design and prototype a unified digital platform that achieves absolute, real-time transactional visibility, enforces data integrity, and automates core logistics processes[cite: 1].

---

## 2. User Roles & Access Control Matrix (RBAC)
The system enforces strict Role-Based Access Control (RBAC) to maintain security and segregation of duties[cite: 1].

| Role | System Permissions |
| :--- | :--- |
| **Warehouse Staff** | • Authenticate securely into local workstation.<br>• View local stock levels for designated warehouse only.<br>• Update local inventory counts (stock-in / stock-out).<br>• Initiate and acknowledge physical stock transfers. |
| **Logistics Manager** | • All permissions of Warehouse Staff.<br>• Global read access across all physical warehouse locations[cite: 1].<br>• Authorize cross-warehouse inventory transfers[cite: 1].<br>• View system audit logs and inventory analytics.<br>• Modify global reorder and safety stock thresholds. |

---

## 3. Functional Requirements (FR)

### 3.1 Authentication & Session Management
*   **FR-101:** The system must enforce a secure login interface requiring a unique username and password.
*   **FR-102:** The backend must parse the user’s role upon authentication and dynamically render the interface matching their assigned scope (Warehouse Staff vs. Logistics Manager)[cite: 1].

### 3.2 Inventory & Multi-Warehouse Tracking
*   **FR-103:** The system must track inventory stock levels distinctly across multiple unique physical locations[cite: 1].
*   **FR-104:** The system must display the exact Stock Keeping Unit (SKU), product name, description, and available quantity for each product at any chosen warehouse.

### 3.3 Inter-Warehouse Transfer Workflow
To prevent phantom inventory during stock movements, the system enforces a strict dual-verification state machine:
*   **FR-105 (Initiation):** Warehouse Staff at the originating site initiates a transfer by specifying the destination warehouse, SKU, and transfer quantity. Stock status updates to `In Transit`.
*   **FR-106 (Verification):** Warehouse Staff at the destination site must explicitly confirm the physical arrival of the stock before the quantities are deducted from the originating site and added to the destination site’s available database ledger.

### 3.4 Automated Low-Stock Alert System
*   **FR-107:** The application tier must execute an automated background routine to check stock thresholds whenever an item is checked out.
*   **FR-108:** The system must dynamically trigger a "Low Stock Warning" on the manager’s dashboard when:
    $$\text{Current Stock} \le \text{Safety Stock} + (\text{Average Daily Usage} \times \text{Lead Time})$$

---

## 4. Non-Functional Requirements (NFR)

### 4.1 Data Integrity & Concurrency
*   **NFR-201:** All inventory adjustments and transfer updates must execute within strict ACID database transactions to prevent race conditions or partial updates[cite: 1].
*   **NFR-202:** Database constraints must strictly forbid stock levels from dropping below zero; any database transaction attempting an operation resulting in a negative stock balance must be rolled back.

### 4.2 Performance & Scalability
*   **NFR-203:** Multi-warehouse inventory summary pages and tracking queries must execute and render in under 2.0 seconds under simulated peak operational concurrent loads[cite: 1].

### 4.3 Security Archetype
*   **NFR-204:** Raw user passwords must never be stored in plain text. Passwords must be cryptographically hashed using industry-standard hashing algorithms (e.g., bcrypt) prior to serialization into the database tier[cite: 1].