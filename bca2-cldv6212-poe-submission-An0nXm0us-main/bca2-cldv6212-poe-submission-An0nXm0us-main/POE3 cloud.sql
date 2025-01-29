-- in case tables exist already.
drop table Customers;
drop table Products;
drop table Orders;
drop table OrderDetails;

-- Create the Customers table to store customer information.
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,                  -- Unique identifier for each customer
    FirstName VARCHAR2(50) NOT NULL,                -- Customer's first name (required)
    LastName VARCHAR2(50) NOT NULL,                 -- Customer's last name (required)
    Email VARCHAR2(100) UNIQUE,                     -- Customer's email address (must be unique)
    Phone VARCHAR2(20),                             -- Customer's phone number (optional)
    Address VARCHAR2(255),                          -- Customer's street address (optional)
    City VARCHAR2(50),                              -- Customer's city (optional)
    Province VARCHAR2(50),                          -- Customer's province (optional)
    ZipCode VARCHAR2(10),                           -- Customer's postal code (optional)
    RegistrationDate DATE DEFAULT SYSDATE           -- Date of registration, defaulting to today's date
);

-- Create the Products table to store product information.
CREATE TABLE Products (
    ProductID NUMBER PRIMARY KEY,                   -- Unique identifier for each product
    ProductName VARCHAR2(100) NOT NULL,             -- Name of the product (required)
    Description VARCHAR2(255),                      -- Product description (optional)
    Price NUMBER(10, 2) NOT NULL,                   -- Product price with two decimal places (required)
    StockQuantity NUMBER DEFAULT 0                  -- Quantity available in stock, defaulting to 0
);

-- Create the Orders table to store information about each order.
CREATE TABLE Orders (
    OrderID NUMBER PRIMARY KEY,                     -- Unique identifier for each order
    CustomerID NUMBER REFERENCES Customers(CustomerID) ON DELETE CASCADE,  -- Links to CustomerID in Customers table; deleting a customer allows system to delete their orders
    OrderDate DATE DEFAULT SYSDATE,                 -- Date of the order, defaulting to today's date
    TotalAmount NUMBER(10, 2),                      -- Total amount of the order, calculated later
    Status VARCHAR2(20) DEFAULT 'Pending'           -- Order status (e.g., 'Pending', 'Shipped', etc.), defaulting to 'Pending'
);

-- Create the OrderDetails table to store details of each product within an order.
CREATE TABLE OrderDetails (
    OrderDetailID NUMBER PRIMARY KEY,               -- Unique identifier for each order detail entry
    OrderID NUMBER REFERENCES Orders(OrderID) ON DELETE CASCADE, -- Links to OrderID in Orders table; deleting an order deletes its details
    ProductID NUMBER REFERENCES Products(ProductID),  -- Links to ProductID in Products table
    Quantity NUMBER NOT NULL,                       -- Quantity of the product in the order (required)
    UnitPrice NUMBER(10, 2) NOT NULL,               -- Price per unit of the product at the time of order (required)
    TotalPrice NUMBER(10, 2) GENERATED ALWAYS AS (Quantity * UnitPrice) VIRTUAL -- Total price for this product in the order (calculated as Quantity * UnitPrice)
);

-- Create an index on the CustomerID in Orders table to speed up customer-related queries.
CREATE INDEX idx_orders_customer ON Orders(CustomerID);

-- Create an index on OrderID and ProductID in OrderDetails table to speed up queries involving specific orders and products.
CREATE INDEX idx_orderdetails_order_product ON OrderDetails(OrderID, ProductID);

--Insertion of data
-- Insert sample data into the Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, Province, ZipCode)
VALUES (1, 'Lindiwe', 'Mabena', 'lindiwe.mabena@gmail.com', '0721234567', '123 Park St', 'Johannesburg', 'Gauteng', '2001');

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, Province, ZipCode)
VALUES (2, 'Thabo', 'Nkosi', 'thabo.nkosi@gmail.com', '0732345678', '456 Highveld Ave', 'Pretoria', 'Gauteng', '0181');

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, Province, ZipCode)
VALUES (3, 'Nomvula', 'Dlamini', 'nomvula.dlamini@gmail.com', '0743456789', '789 Beach Rd', 'Cape Town', 'Western Cape', '8001');

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, Province, ZipCode)
VALUES (4, 'Sipho', 'Mthembu', 'sipho.mthembu@gmail.com', '0764567890', '101 Soweto Rd', 'Soweto', 'Gauteng', '1804');

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, Province, ZipCode)
VALUES (5, 'Ayanda', 'Zulu', 'ayanda.zulu@gmail.com', '0785678901', '202 Umhlanga Dr', 'Durban', 'KwaZulu-Natal', '4320');

-- Insert sample data into the Products table
INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity)
VALUES (1, 'T-Shirt', 'Black T-Shirt with a white BackRow logo', 250.00, 500);

INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity)
VALUES (2, 'Give or Take', 'Give or Take mp3 record', 15.00, 20000);

INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity)
VALUES (3, 'Insecure', 'Insecure mp3 record', 10.00, 20000);

INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity)
VALUES (4, 'Setbacks', 'Setbacks mp3 record', 2500.00, 150);

INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity)
VALUES (5, 'T-Shirt', 'White T-Shirt with a black BackRow logo', 250.00, 750);

-- Insert sample data into the Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1, 1, TO_DATE('2023-11-10', 'YYYY-MM-DD'), 14000.00, 'Shipped');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (2, 2, TO_DATE('2023-11-11', 'YYYY-MM-DD'), 10000.00, 'Pending');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (3, 3, TO_DATE('2023-11-12', 'YYYY-MM-DD'), 5000.00, 'Delivered');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (4, 4, TO_DATE('2023-11-13', 'YYYY-MM-DD'), 12000.00, 'Shipped');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (5, 5, TO_DATE('2023-11-14', 'YYYY-MM-DD'), 2500.00, 'Pending');

-- Insert sample data into the OrderDetails table
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (1, 1, 1, 1, 250.00);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (2, 1, 3, 2, 10.00);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (3, 2, 2, 1, 15.00);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (4, 3, 5, 1, 250.00);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (5, 4, 1, 1, 250.00);
