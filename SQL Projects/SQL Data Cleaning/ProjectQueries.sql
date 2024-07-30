/*
Data Cleaning in SQL Server
*/

USE [Portfolio Project]
GO
SELECT * FROM NashvilleHousing

---------------------------------------------------------------------------------
-- Standardizing Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing;

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

---------------------------------------------------------------------------------
-- Populate Property Address Data

SELECT * FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
	JOIN NashvilleHousing b
		ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
	JOIN NashvilleHousing b
		ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

---------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns(Address, City, State)

SELECT PropertyAddress FROM NashvilleHousing;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

SELECT * FROM NashvilleHousing;

SELECT OwnerAddress FROM NashvilleHousing;

-- Alernative Path
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);
ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);
ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

---------------------------------------------------------------------------------
-- Change Y and N to Yes and NO in 'Sold as Vacant' Yield

SELECT DISTINCT SoldAsVacant,  COUNT(SoldAsVacant) AS 'Field Count'
FROM NashvilleHousing
GROUP BY SoldAsVacant
Order BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldASVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldASVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END;

SELECT DISTINCT SoldAsVacant,  COUNT(SoldAsVacant) AS 'Field Count'
FROM NashvilleHousing
GROUP BY SoldAsVacant
Order BY 2;

---------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress, 
				 SalePrice, 
				 SaleDate, 
				 LegalReference
				 ORDER BY UniqueID) row_num
FROM NashvilleHousing
)

SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

---------------------------------------------------------------------------------
-- Delete Unused columns

SELECT * FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate;

---------------------------------------------------------------------------------