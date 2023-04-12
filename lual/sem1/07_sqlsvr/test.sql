-- Create a new database called 'DatabaseName'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'lual_Customer_DB2301'
)
CREATE DATABASE lual_Customer_DB2301
GO

alter database [lual_Customer_DB2301] modify name = [lual_Cust_DB2301];

use lual_Cust_DB2301;

alter database Collins_Cust_DB2301 set auto_shrink on;


-- create Sales db adn specify file primary file group
CREATE DATABASE [Collins_SalesDB] ON PRIMARY

( NAME = 'Collins_SalesDB', FILENAME ='/var/opt/mssql/data/Collins_SalesDB.mdf' , SIZE = 3072KB ,MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ),
FILEGROUP [MyFileGroup]
( NAME = 'Collins_SalesDB_FG', FILENAME = '/var/opt/mssql/data/Collins_SalesDB_FG.ndf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
LOG ON
( NAME = 'Collins_SalesDB_log', FILENAME = '/var/opt/mssql/data/Collins_SalesDB_log.ldf' , SIZE = 2048KB ,MAXSIZE = 2048GB , FILEGROWTH = 10%)
COLLATE SQL_Latin1_General_CP1_CI_AS;


use Collins_Cust_DB2301;

USE [master];
GO
RESTORE DATABASE [AdventureWorks2016]
FROM DISK = '/var/opt/mssql/backup/AdventureWorks2016.bak'
WITH
    MOVE 'AdventureWorks2016' TO '/var/opt/mssql/data/AdventureWorks2016.mdf',
    MOVE 'AdventureWorks2016_log' TO '/var/opt/mssql/data/AdventureWorks2016_log.ldf',
    FILE = 1,
    NOUNLOAD,
    STATS = 5;
GO

