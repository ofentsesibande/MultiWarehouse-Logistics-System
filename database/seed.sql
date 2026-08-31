-- ====================================================================
-- REPEATABLE SEED DATA FOR LOGISTICS TESTING
-- ====================================================================

-- Insert Sample Warehouses
INSERT INTO Warehouses (WarehouseID, WarehouseName, LocationCity) VALUES
(1, 'Gauteng Central Hub', 'Johannesburg'),
(2, 'Tshwane North Depot', 'Pretoria'),
(3, 'Coastal Gateway Fulfillment', 'Durban');

-- Insert Sample Products
-- SKU Format: CATEGORY-PRODUCT_ID-SIZE/TYPE
INSERT INTO Products (ProductID, SKU, ProductName, SafetyStock, AvgDailyUsage, LeadTimeDays) VALUES
(101, 'ELEC-LAP-MBP14', 'MacBook Pro 14 Inch', 5, 2, 5),
(102, 'ELEC-PHN-IP15P', 'iPhone 15 Pro Max', 10, 4, 3),
(103, 'ACC-WCH-AW9SL', 'Apple Watch Series 9', 8, 3, 4);

-- Insert Users (Passwords are pre-hashed representations)
INSERT INTO Users (UserID, Username, PasswordHash, Role, AssignedWarehouseID) VALUES
(1, 'sibande_o', '$2b$12$K3fQ9oGvMvWdO9/9199sRe9E5H79qZ7Yf8E2', 'Logistics Manager', NULL), -- Global access
(2, 'johnd_staff', '$2b$12$B4rT7pYvMuWdO8/8188sRe8E4H88qZ8Yf7E1', 'Warehouse Staff', 1); -- Restructured to GP Hub

-- Initialize Inventory Stock Levels across physical warehouses
INSERT INTO Stock_Levels (WarehouseID, ProductID, Quantity) VALUES
(1, 101, 15), -- Johannesburg Macbook stock
(1, 102, 3),  -- Low stock: Alert calculation: 3 <= 10 + (4 * 3) = 22
(2, 101, 0),  -- Out of stock in Pretoria
(2, 103, 12), -- Normal stock in Pretoria
(3, 102, 25); -- Plenty of stock in Durban