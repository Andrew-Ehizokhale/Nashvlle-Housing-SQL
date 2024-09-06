select *
from [Nashville Housing]

/* Convert the SaleDate to Date*/
select SaleDate, Convert(Date, SaleDate)
from [Nashville Housing]

update [Nashville Housing]
SET SaleDate = Convert(Date, SaleDate)

AlTER TABLE [Nashville Housing]
ADD SaleDate_converted Date;

update [Nashville Housing]
SET SaleDate_converted = Convert(Date, SaleDate)

select SaleDate_converted, Convert(Date, SaleDate)
from [Nashville Housing]


/* Fill(Populate) the null values in Property Address*/

select *
from [Nashville Housing]
where propertyaddress is NULL


select a.ParcelID,a.propertyaddress, b.parcelID, b.propertyaddress
from [Nashville Housing] a
join [Nashville Housing] b
ON a.ParcelID = b.parcelID and a.UniqueID != b.UniqueID
where a.propertyaddress is NULL


select a.ParcelID,a.propertyaddress, b.parcelID, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
from [Nashville Housing] a
join [Nashville Housing] b
ON a.ParcelID = b.parcelID and a.UniqueID != b.UniqueID
where a.propertyaddress is NULL

/* lets update a.propertyaddress*/

update a
SET propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
from [Nashville Housing] a
join [Nashville Housing] b
ON a.ParcelID = b.parcelID and a.UniqueID != b.UniqueID
where a.propertyaddress is NULL



/* lets break the address into individual columns (address, City, state)*/

select propertyAddress 
from [Nashville Housing]

select SUBSTRING(propertyaddress,1, CHARINDEX(',', propertyAddress)-1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyAddress)+ 1, LEN(propertyAddress)) as City
from [Nashville Housing]


/* Creating columns for the address and city*/

alter Table [Nashville Housing]
ADD Address Nvarchar(255);

update [Nashville Housing]
SET Address = SUBSTRING(propertyaddress,1, CHARINDEX(',', propertyAddress)-1)


alter Table [Nashville Housing]
ADD City Nvarchar(255);

update [Nashville Housing]
SET City = SUBSTRING(propertyaddress, CHARINDEX(',', propertyAddress)+ 1, LEN(propertyAddress))
from [Nashville Housing]



select OwnerAddress
from [Nashville Housing]

/* seperating address, city and state*/

select PARSENAME(REPLACE(OWnerAddress,',','.'), 1),
PARSENAME(REPLACE(OWnerAddress,',','.'), 2),
PARSENAME(REPLACE(OWnerAddress,',','.'), 3)
from [Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD Owner_Address Nvarchar(255);

update [Nashville Housing]
SET Owner_Address = PARSENAME(REPLACE(OWnerAddress,',','.'), 3)


ALTER TABLE [Nashville Housing]
ADD Owner_City Nvarchar(255)


UPDATE [Nashville Housing]
SET Owner_City = PARSENAME(REPLACE(OWnerAddress,',','.'), 2)


ALTER TABLE [Nashville Housing]
ADD Owner_State Nvarchar(255)

UPDATE [Nashville Housing]
SET Owner_State = PARSENAME(REPLACE(OWnerAddress,',','.'), 1)


select distinct(SoldAsVacant)
from [Nashville Housing]
/* I want to change N and Y to No and Yes respectively*/

select SoldAsVacant,
CASE
	when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
from [Nashville Housing]

/* Lets Update it */
Update [Nashville Housing]
SET SoldAsVacant = CASE
	when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END



/* deleting unused data*/

alter table [Nashville Housing]
drop column PropertyAddress;


alter table [Nashville Housing]
drop column SaleDate, OwnerAddress;

alter table [Nashville Housing]
drop column TaxDistrict;


/* Lets remove Duplicates*/

select *, ROW_NUMBER() OVER( partition by parcelID, 
										SalePrice,
										LegalReference
										order by UniqueID) as row_num
from [Nashville Housing]

/* Using cte to use the row_num column*/
 
 WITH ROWNumCTE
 AS
 (
 select *, ROW_NUMBER() OVER( partition by parcelID, 
										SalePrice,
										LegalReference
										order by UniqueID) as row_num
from [Nashville Housing]
 )

 delete
 from ROWNumCTE
 where row_num > 1


