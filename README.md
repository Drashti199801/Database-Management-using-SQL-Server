# Database-Management-using-SQL-Server

# Overview
This repository contains a detailed SQL script to set up a comprehensive database named SWC_DB. The database is designed to manage information about purchasers, suppliers, part types, parts, and purchases. The script includes table creation, data insertion, views, triggers, and stored procedures to maintain data integrity and facilitate database operations.

# Database Setup Details

**1. Database Creation**
Drop Existing Database: The script first checks if a database named SWC_DB already exists. If it does, the database is dropped.
Create New Database: A new database named SWC_DB is then created.

**2. Table Definitions**
The following tables are created to store various data related to the system:

**Purchasers:**
Fields: PurchaserID, FirstName, LastName, Email, StreetNumber, StreetName, City, Province, Country, PostalCode, Phone.
Purpose: Stores personal and contact information of the purchasers.
Constraints: Ensures first and last names are at least 3 characters long, sets a default value for Country to 'Canada'.

**Suppliers:**
Fields: SupplierID, SupplierName.
Purpose: Stores names of suppliers.

**PartTypes:**
Fields: PartTypeID, PartTypeName.
Purpose: Stores different types of parts.

**Parts:**
Fields: PartID, PartNumber, SupplierID, PartTypeID, PartDescription, UnitPrice.
Purpose: Stores detailed information about each part.
Constraints: Ensures unit price is non-negative, and part descriptions are at least 3 characters long.
Foreign Keys: References Suppliers and PartTypes.

**Purchases:**
Fields: PurchaseID, PurchaserID, PartID, DesktopBundle, PurchaseDate, UnitPrice, Quantity.
Purpose: Records information about purchases made by purchasers.
Constraints: Ensures quantity is positive.
Foreign Keys: References Purchasers and Parts.

**3. Initial Data Insertion**

The script inserts sample data into the tables to facilitate initial testing and development:

Purchasers: Inserts sample purchaser information.
Suppliers: Inserts sample supplier names.
PartTypes: Inserts sample part types.
Parts: Inserts sample parts with their details.
Purchases: Inserts sample purchase records.

**4. Indexes**
To improve query performance, the script creates indexes:

Phone Index: An index on the Phone field of the Purchasers table.
Unique Email Index: A unique index on the Email field of the Purchasers table to ensure no duplicate emails.

**5. Views**
The script creates views to provide useful data aggregations and calculations:

PurchaseDetailsWithExtendedAmount:
Description: This view combines information from purchases, purchasers, parts, suppliers, and part types. It calculates and includes the extended amount for each purchase (UnitPrice * Quantity).

DesktopBundleTotalCost:
Description: This view calculates the total cost of desktop bundles based on their component parts.

**6. Triggers**
Triggers automate certain actions in the database:

CheckPostalCode:
Description: This trigger ensures that if a purchaser's postal code is not provided, it is set to 'N/A'.

CalculateExtendedAmountTrigger:
Description: This trigger calculates the extended amount for each purchase automatically when a new purchase is inserted.

**7. Stored Procedures**
Stored procedures encapsulate repetitive tasks:

CalculateBundleTotalCost:
Description: This procedure calculates the total cost for a specified bundle by summing the unit prices of its components.

UpdatePartUnitPrice:
Description: This procedure updates the unit price of a specified part.

**Usage**
To use this script, follow these steps:
Open SQL Client: Use SQL Server Management Studio (SSMS) or any compatible tool.
Connect to SQL Server: Connect to your SQL Server instance.
Run the Script: Open the script file (e.g., database_setup.sql) and execute it.

**Testing the Script**
The script includes test insertions and queries to verify:
Proper setup of the database.
Correct functioning of constraints, triggers, and views.
