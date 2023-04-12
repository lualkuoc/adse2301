use lual_Cust_DB2301;

    /*Use the output clause to display the rows affected
by update statements.NB Execute the statements below as
one batch to avoid errors.*/
Create table dbo.Table_3
(
    id Int,
    employee nvarchar(32)
);
--Insert records into table_3
insert into dbo.Table_3
values
(1,'Matt'),
(2,'Joseph'),
(3,'Renny'),
(4,'Daisy');
--Create a table variable to hold the updated values
Declare @updatedTable Table
(
    id int,
    oldData_employee varchar(32),
    newData_employee varchar(32)
);
update dbo.Table_3
set employee = UPPER(employee)
--Use output to specify the details to be displayed
output
inserted.id,
deleted.employee,
inserted.employee
into @updatedTable
--Display all the records that were updated from the updatedTable variable
Select * from @updatedTable;


/* Use the write clause to replace a long string in a column */
--Create a new table called Table_5
Create table dbo.Table_5
(
    EmployeeRole varchar(max),
    Summary varchar(max)
);
--Add records in the new table
Insert into dbo.Table_5
(EmployeeRole,Summary)
values
('Research','This is a very long non-unicode string');
--Display all the records in Table_5
select * from dbo.Table_5;
--This is an incredibly long non-unicode string
--Modify/update the summary column using the write clause
update dbo.table_5
set Summary .write('n incredibly ',9,5)
where EmployeeRole like 'Research';
--Display all the records in Table_5
select * from dbo.Table_5;

-- Display all records from salesterritory table in the sales schema in the adventureworks2016 database. The records should be arranged/sorted by sales lastyear column from the least to the greatest

-- select *
-- from AdventureWorks2016.Sales.SalesTerritory
-- order_by ''

Create schema Person;
-- create table person in person schema
Create Table Person.phoneBilling
(
    Bill_ID int primary key,
    MobileNumber bigint unique,
    CallDetails xml
);

--Add a record into the PhoneBilling Table in the Person Schema
INSERT INTO Person.PhoneBilling
VALUES
(100,9833276605,'<Info> <Call>Local</Call> <Time>45 minutes </Time> <Charges> 200 </Charges> </Info>')
--Display the call details from the PhoneBilling table in the Person Schema
SELECT CallDetails FROM Person.PhoneBilling;

-- Declare and display the contents of an xml variable
Declare @xmlVar XML
set @xmlVar = '<Employee name="Joan" />';
select @xmlVar as 'Contents of @xmlVar';

--Create and register an XML schema
CREATE XML SCHEMA COLLECTION CricketSchemaCollection
AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" >
<xsd:element name="MatchDetails">
<xsd:complexType>
<xsd:complexContent>
<xsd:restriction base="xsd:anyType">
<xsd:sequence>
<xsd:element name="Team" minOccurs="0" maxOccurs="unbounded">
<xsd:complexType>
<xsd:complexContent>
<xsd:restriction base="xsd:anyType">
<xsd:sequence />
<xsd:attribute name="country" type="xsd:string" />
<xsd:attribute name="score" type="xsd:string" />
</xsd:restriction>
</xsd:complexContent>
</xsd:complexType>
</xsd:element>
</xsd:sequence>
</xsd:restriction>
</xsd:complexContent>
</xsd:complexType>
</xsd:element>
</xsd:schema>';

-- Create a cricketTeam table with and xml type and specify the schema used to validate the column.

Create table CricketTeam
(
    TeamID int identity,
    TeamInfo xml(CricketSchemaCollection)

);

-- Add data to the Crcket Team table
INSERT INTO CricketTeam (TeamInfo)
VALUES
('<MatchDetails>
    <Team country="Australia" score="355"></Team>
    <Team country="Zimbabwe" score="200"></Team>
    <Team country="England" score="475"></Team>
</MatchDetails>');

--Create a typed xml variable by using the 'CricketSchemaCollection
DECLARE @team xml(CricketSchemaCollection)
SET @team = '<MatchDetails><Team country="Australia"></Team></MatchDetails>'
SELECT @team as 'Team';

-- Demonstrate the use of exist() method
select TeamID
from CricketTeam
where TeamInfo.exist('(/MatchDetails/Team)') = 1;

--Demonstrate the use of the query() method
SELECT TeamInfo.query('/MatchDetails/Team') AS Info 
FROM CricketTeam

 

--Demonstrate the use of the value() method
SELECT TeamInfo.value('(/MatchDetails/Team/@score)[1]', 'varchar(20)') AS Score 
FROM CricketTeam 
where TeamID=1


-- session 9
use AdventureWorks2016;
select class, avg(ListPrice) as 'Average List Price'
from Production.Product
group by Class;

-- Dispaly the sales in various regions
select [group], sum(salesytd) as 'Total Regional Sales'
from Sales.SalesTerritory
where [Group] like 'N%' or [Group] like 'E%'
group by all [group];

-- Display the sales for regions with sales below 6m
select [Group], convert(decimal(10,2),sum(salesytd)) as 'Tota Region Sales'
from Sales.SalesTerritory
group by [Group]
having sum(salesytd) < 6000000;

-- Display total sales
select [Name], CountryRegionCode, sum(salesytd) as 'Total Region Sales'
from Sales.SalesTerritory
where [Name] <> 'Australia' or [Name] <> 'Canada'
Group by [Name], CountryRegionCode with cube;

-- Display total sales
select [Name], CountryRegionCode, sum(salesytd) as 'Total Region Sales'
from Sales.SalesTerritory
where [Name] <> 'Australia' or [Name] <> 'Canada'
Group by [Name], CountryRegionCode with rollup;

-- Get the avarage/mean price, least order quantity and hieghest unit price discount from the sales.salesorder table.ABORT

select AVG(unitprice) 'Average Unit Price',
Min(OrderQTY) as 'Minimum Order Quantity',
MAX(unitpricediscount) 'Maximum Discount'
from sales.SalesOrderDetail;

-- Get the earliest order dates using min()
select MIN(orderdate) 'Earliest order',
MAX(orderdate) 'Latest Order'
from sales.SalesOrderHeader;


-- Demonstrate the use of the stunion()
select qeometry::Point(251,1,4326).STUnion(
    geometry::Point(252,2,4326));

--Another example on the above
Declare @city1 geography, @city2 geography
set @city1 = geography::STPolyFromText('POLYGON((175.3 -41.5,
178.3 -37.9,172.8 -34.6,175.3 -41.5))',4326)
set @city2 = geography::STPolyFromText('POLYGON((169.3 -46.6,
174.3 -41.6,172.5 -40.7,166.3 -45.8,169.3 -46.6))',4326)
declare @combinedCity geography = @city1.STUnion(@city2)

-- Display the contents combinedCity variable
Select @combinedCity

-- Example of a union aggregate people living in 
Select Geography::UnionAggregate(SpatialLocation) 'Average Location'
from Person.Address
where city like 'London';

-- Example of a Envelope aggregate people living in 
Select Geography::EnvelopeAggregate(SpatialLocation) 
from Person.Address
where city like 'London';

--Return/Obtain an instance that contains a curvepolygon and a polygon
Declare @collectionDemo Table
(
    shape geometry,
    shapeType nvarchar(50)
);
--Add/insert values into the @collectionDemo Table variable
Insert into @collectionDemo
values
('CURVEPOLYGON(CIRCULARSTRING(2 3, 4 1,6 3,4 5,2 3))','Circle'),
('POLYGON((1 1, 4 1,4 5,1 5,1 1))','Rectangle');
--Display a combined shape of the above
Select geometry::CollectionAggregate(shape) as 'Combined Shape'
from @collectionDemo;


-- Example of a Convex hull aggregate people living in 
Select Geography::ConvexHullAggregate(SpatialLocation) 
from Person.Address
where city like 'London';

-- Get/obtain the due and shiping date of the latest recent order
select
from Sales.SalesOrderHeader
where
(
    -- subquery to get the latest order
    select max(orderdate)
    from sales.SalesOrderHeader
);




-- get the first and last names of employees 
Select FirstName 'First Name', LastNmae 'Last Name'
from Person.Person as P 
where exists
(
    -- Subquery to get the employee`s jobtitle
    select *
    from HumanRecources.Employee E --Employee table alias
    where JobTitle like 'Research and Development Manager'
    and P.BusinessEntityID = E.BusinessEntityID
)


--Use nested subqueries to display the names of employees/salesperson whose sales territory is Canada
Select concat(P.FirstName, ' ' , LastName)as [Names]
From Person.Person as P --Person table alias
where P.BusinessEntityID in
(
    --Outer subquery to fetch the person's businessentityID
    Select sp.BusinessEntityID
    from Sales.SalesPerson SP
    where TerritoryID in
    (
        --Inner subquery to fetch the territory ID of the Canada region
        select st.TerritoryID
        from Sales.SalesTerritory ST
        where [Name] like 'Canada'
    )
);



