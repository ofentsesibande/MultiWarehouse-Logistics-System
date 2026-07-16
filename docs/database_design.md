# Relational Database Schema Design (3NF)
**System:** Multi-Warehouse Inventory & Logistics Optimization System  
**Phase:** 2 - System Architecture & Data Modeling  

---

## 1. Relational Table Specifications

### 1.1 Users Table
Stores authentication data and system access privileges to enforce RBAC.
*   `UserID` (INT, Primary Key, Auto-Increment)
*   `Username` (VARCHAR(50), Unique, Not Null)
*   `PasswordHash` (VARCHAR(255), Not Null) — *Enforcing NFR-204 (bcrypt)*[cite: 1]
*   `Role` (VARCHAR(20), Not Null) — *Enforcing FR-101 ('Warehouse Staff', 'Logistics Manager')*[cite: 1]
*   `AssignedWarehouseID` (INT, Nullable, Foreign Key -> Warehouses.WarehouseID)

### 1.2 Warehouses Table
Tracks distinct physical fulfillment hubs[cite: 1].
*   `WarehouseID` (INT, Primary Key, Auto-Increment)
*   `WarehouseName` (VARCHAR(100), Not Null)
*   `LocationCity` (VARCHAR(50), Not Null)

### 1.3 Products Table
The global inventory master list containing absolute product definitions[cite: 1].
*   `ProductID` (INT, Primary Key, Auto-Increment)
*   `SKU` (VARCHAR(50), Unique, Not Null)
*   `ProductName` (VARCHAR(150), Not Null)
*   `SafetyStock` (INT, Not Null, Default 10)
*   `AvgDailyUsage` (INT, Not Null)
*   `LeadTimeDays` (INT, Not Null)

### 1.4 Stock_Levels Table (Composite Key Bridge Table)
Maps the physical relationship between products and separate warehouses[cite: 1]. This normalizes the schema by removing multi-valued attributes[cite: 1].
*   `WarehouseID` (INT, Foreign Key -> Warehouses.WarehouseID)[cite: 1]
*   `ProductID` (INT, Foreign Key -> Products.ProductID)[cite: 1]
*   `Quantity` (INT, Not Null, Check Constraint: `Quantity >= 0`) — *Enforcing NFR-202*[cite: 1]
*   *Composite Primary Key:* `(WarehouseID, ProductID)`[cite: 1]

### 1.5 Inventory_Logs Table (System Audit Trail)
An immutable ledger tracking every system state transition for absolute transparency[cite: 1].
*   `LogID` (BIGINT, Primary Key, Auto-Increment)
*   `ProductID` (INT, Foreign Key -> Products.ProductID)[cite: 1]
*   `WarehouseID` (INT, Foreign Key -> Warehouses.WarehouseID)[cite: 1]
*   `UserID` (INT, Foreign Key -> Users.UserID)[cite: 1]
*   `TransactionType` (VARCHAR(20)) — *('STOCK-IN', 'STOCK-OUT', 'TRANSFER-OUT', 'TRANSFER-IN')*
*   `QuantityChanged` (INT, Not Null)
*   `Timestamp` (DATETIME, Default Current_Timestamp)

---

## 2. Business Logic Formula Verification
To satisfy **FR-108**, the query layer calculates the dynamic reorder metric utilizing the standard inventory management safety calculation[cite: 1]:

$$\text{Reorder Flag Status} = \text{If}(\text{Stock\_Levels.Quantity} \le \text{Products.SafetyStock} + (\text{Products.AvgDailyUsage} \times \text{Products.LeadTimeDays}))$$