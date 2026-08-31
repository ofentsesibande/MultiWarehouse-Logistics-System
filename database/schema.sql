-- ====================================================================
-- DATABASE INITIALIZATION SCHEMA
-- System: Multi-Warehouse Inventory & Logistics Optimization System
-- Target Engine: PostgreSQL / SQLite / SQL Server compatible syntax
-- ====================================================================

-- 1. Create Warehouses Table
CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY,
    WarehouseName VARCHAR(100) NOT NULL,
    LocationCity VARCHAR(50) NOT NULL
);

-- 2. Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    SKU VARCHAR(50) UNIQUE NOT NULL,
    ProductName VARCHAR(150) NOT NULL,
    SafetyStock INT NOT NULL DEFAULT 10,
    AvgDailyUsage INT NOT NULL,
    LeadTimeDays INT NOT NULL
);

-- 3. Create Users Table (Role-Based Access Control)
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Warehouse Staff', 'Logistics Manager')),
    AssignedWarehouseID INT,
    FOREIGN KEY (AssignedWarehouseID) REFERENCES Warehouses(WarehouseID)
);

-- 4. Create Stock_Levels Table (Composite Key Bridge Table)
CREATE TABLE Stock_Levels (
    WarehouseID INT,
    ProductID INT,
    Quantity INT NOT NULL DEFAULT 0,
    PRIMARY KEY (WarehouseID, ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    CONSTRAINT chk_non_negative_stock CHECK (Quantity >= 0)
);

-- 5. Create Inventory_Logs Table (System Audit Ledger)
CREATE TABLE Inventory_Logs (
    LogID INTEGER PRIMARY KEY,
    ProductID INT NOT NULL,
    WarehouseID INT NOT NULL,
    UserID INT NOT NULL,
    TransactionType VARCHAR(20) NOT NULL CHECK (TransactionType IN ('STOCK-IN', 'STOCK-OUT', 'TRANSFER-OUT', 'TRANSFER-IN')),
    QuantityChanged INT NOT NULL,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);