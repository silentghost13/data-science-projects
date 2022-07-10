/*

	Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;

-- Standardize Date Format

SELECT SaleDate, CONVERT(date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted date;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing;

-- Populate Property Address Data

SELECT db1.ParcelID, db1.PropertyAddress, db2.ParcelID, db2.PropertyAddress, ISNULL(db1.PropertyAddress, db2.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing db1
JOIN PortfolioProject.dbo.NashvilleHousing db2
	ON db1.ParcelID = db2.ParcelID
	AND db1.[UniqueID ] <> db2.[UniqueID ]
WHERE db1.PropertyAddress IS NULL;

UPDATE db1
SET PropertyAddress = ISNULL(db1.PropertyAddress, db2.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing db1
JOIN PortfolioProject.dbo.NashvilleHousing db2
	ON db1.ParcelID = db2.ParcelID
	AND db1.[UniqueID ] <> db2.[UniqueID ]
WHERE db1.PropertyAddress IS NULL;

-- Breaking Out Address into Individual Column (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255), 
	PropertySplitCity nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1),
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing;

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress nvarchar(255),
	OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM PortfolioProject.dbo.NashvilleHousing;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = 
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END;

-- Remove Duplicates (IRL don't actually remove data if you are not sure, use temporary table)

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
	) row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
-- You can change "SELECT *" to "DELETE" if you want to delete it
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

-- Delete Unused Column (IRL don't actually remove data if you are not sure, ask someone)
/*

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

*/


-- Creating temp table
DROP TABLE IF EXISTS #nashville_housing_temp
CREATE TABLE #nashville_housing_temp
(
unique_id float,
parcel_id nvarchar(255),
land_use nvarchar(255),
property_address nvarchar(255),
property_city nvarchar(255),
land_value float,
building_value float,
total_value float,
sale_price float,
sale_date date,
year_built float,
sold_as_vacant nvarchar(255)
)

INSERT INTO #nashville_housing_temp
SELECT [UniqueID ], ParcelID, LandUse, PropertySplitAddress, PropertySplitCity, LandValue, BuildingValue, TotalValue, SalePrice, SaleDateConverted, YearBuilt, SoldAsVacant
FROM PortfolioProject.dbo.NashvilleHousing;

--Delete duplicates 
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY 
		parcel_id,
		property_address,
		sale_date,
		sale_price
		ORDER BY
			unique_id
	) row_num
FROM #nashville_housing_temp
)

DELETE
FROM RowNumCTE
WHERE row_num > 1

--Deleting missing value
DELETE
FROM #nashville_housing_temp
WHERE total_value IS NULL;

DELETE
FROM #nashville_housing_temp
WHERE year_built IS NULL;

SELECT *
FROM #nashville_housing_temp;

--Find the highest value per city
SELECT property_city, SUM(land_value) as land_value_per_city, SUM(building_value) as building_value_per_city, SUM(total_value) as total_value_per_city
FROM #nashville_housing_temp
GROUP BY property_city
ORDER BY total_value_per_city DESC;

--Find the most used land use per city
SELECT property_city, land_use, COUNT(land_use) as land_use_per_city
FROM #nashville_housing_temp
GROUP BY property_city, land_use
ORDER BY property_city, land_use_per_city DESC;

