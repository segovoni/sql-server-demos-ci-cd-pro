-------------------------------------------------------------------------
-- Demo:       SQL Server CI/CD                                         -
--                                                                      -
-- Script:     Create trigger TR_Product_SafetyStockLevel               -
-- Author:     Sergio Govoni                                            -
-- Notes:      --                                                       -
-------------------------------------------------------------------------

USE [AdventureWorks2017];
GO

CREATE OR ALTER TRIGGER Production.TR_Product_SafetyStockLevel
  ON Production.Product
AFTER INSERT AS
BEGIN
  /* 
     Avoid to insert products with safety stock level lower than 10!
  */
  
  -- Testing all rows in the Inserted virtual table
  IF EXISTS (SELECT ProductID FROM inserted WHERE (SafetyStockLevel < 10))
  BEGIN
    -- Error!!
    EXEC Production.usp_Raiserror_SafetyStockLevel
      @Message = 'Safety stock level cannot be lower than 10!';
  END;
END;
GO