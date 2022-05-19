--Cleaning Data in SQL Query

Select *
From NashvilleHousing

--Standardize Date Format

Select SaleDate, Convert(Date, Saledate)
From NashvilleHousing

Update NashvilleHousing
Set SaleDate= Convert(Date, Saledate)--This did not update correctly, so instead will try Altering the table

Alter Table NashvilleHousing
Add SalesDateConverted Date

Update NashvilleHousing
Set SalesDateConverted = Convert(Date, Saledate)

Select SaleDate, SalesDateConverted
From NashvilleHousing

--updating null values in property address
Select *
From NashvilleHousing
order by parcelid


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
--The ISNULL() function returns a specified value if the expression is NULL. 
--If the expression is NOT NULL, this function returns the expression.
--ISNULL(expression, specified value)
From NashvilleHousing a
Join NashvilleHousing b on b.ParcelID= a.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b on b.ParcelID= a.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking up propertyadress into individual columns (address, city) using substring

select propertyaddress
from NashvilleHousing

select (SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1)) as Address,
--charindex(',', propertyaddress) used for the length because sql searches the line until it will find the ',' thus specifying the position
(SUBSTRING(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress))) as City
FROM NashvilleHousing

select *
from NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = (SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1)) 

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = (SUBSTRING(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress)))

select propertysplitcity
from NashvilleHousing

--breaking up owner address into address, city, state using Parsename

select * 
From NashvilleHousing

select
PARSENAME(replace(owneraddress, ',','.'),3),
--parsname looks for periods so have to convert the commas into periods, it also selects them backwards 
PARSENAME(replace(owneraddress, ',','.'),2),
PARSENAME(replace(owneraddress, ',','.'),1)
from NashvilleHousing

alter table nashvillehousing
add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(owneraddress, ',','.'),3)

alter table nashvillehousing
add OwnerSplitCity nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(owneraddress, ',','.'),2)

alter table nashvillehousing
add OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(owneraddress, ',','.'),1)

--Change Y and N to yes and no in soldasvacant

select distinct(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2

select soldasvacant,
(Case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else SoldAsVacant
	end)
from nashvillehousing

update NashvilleHousing
set SoldAsVacant=(Case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else SoldAsVacant
	end)

--removing duplicates 

with RowNumCTE as (
select *,
	ROW_NUMBER() Over (
	Partition By	ParcelID, 
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by uniqueid)row_num
from NashvilleHousing)
--if there is only 1row number, we can infer that the values are different between our column selection

delete
from RowNumCTE
where row_num>1

--deleting unused columns

select*
from NashvilleHousing

alter table nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress, saledate