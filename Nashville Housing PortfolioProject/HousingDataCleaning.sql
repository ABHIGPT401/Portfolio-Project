--------------------------CLEANING DATA

select *
from housingdata


--------Change the sale date

select SaleDateConverted, convert(date,SaleDate)
from housingdata


update housingdata
set SaleDate = convert(Date,SaleDate)

alter table housingdata
add SaleDateConverted Date;

update housingdata
set SaleDateConverted = convert(Date,SaleDate)



------------Populate Property address data

Select *
from housingdata
where PropertyAddress is null

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
from housingdata a
join housingdata b
on a.parcelID = b.parcelID
and a.UniqueID != b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from housingdata a
join housingdata b
on a.parcelID = b.parcelID
and a.UniqueID != b.UniqueID
where a.PropertyAddress is null


--------Breaking Out address into individual columns(address,city,state)

Select PropertyAddress
from housingdata

select
substring(PropertyAddress,1,
charindex(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,(charindex(',',PropertyAddress)+1),
len(PropertyAddress)) as Address2
from housingdata


ALTER TABLE housingdata
Add PropertySplitAddress Nvarchar(255);

Update housingdata
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, 
CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housingdata
Add PropertySplitCity Nvarchar(255);

Update housingdata
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


select * 
from housingdata

select OwnerAddress
from housingdata

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From housingdata

alter table housingdata
Add OwnerSplitAddress Nvarchar(255);

update housingdata
set OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housingdata
Add OwnerSplitCity Nvarchar(255);

Update housingdata
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE housingdata
Add OwnerSplitState Nvarchar(255);

Update housingdata
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select *
from housingdata

----------------change Y and N to Yes and No in " Sold as Vacant " field

select SoldAsVacant
from housingdata
where SoldAsVacant = 'Y' or  SoldAsVacant = 'N'

update housingdata
set SoldAsVacant = 'No'
where SoldAsVacant = 'N';

---------Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housingdata
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From housingdata

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From housingdata


ALTER TABLE housingdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate