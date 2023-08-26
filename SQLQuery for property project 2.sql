/*
Cleaning Data in SQL Queries
*/
SELECT *
FROM NashvilleHousing

--Standarize SalesDate Formate

SELECT SaleDate,CONVERT(date,SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)


ALTER TABLE NashvilleHousing 
ADD SaleDateConverted date;


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)


ALTER TABLE NashvilleHousing 
DROP COLUMN SaleDate


---POPULATE Property address data

SELECT A.ParcelID,A.PropertyAddress,B.ParcelID ,B.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM NashvilleHousing A
join NashvilleHousing B
ON  A.ParcelID=B.ParcelID 
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress =ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM NashvilleHousing A
join NashvilleHousing B
ON  A.ParcelID=B.ParcelID 
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--Breakiing out adress into individual columns(adress,city,state)

SELECT LEN(PropertyAddress)
from NashvilleHousing 
 

 SELECT 
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS PropertySplitAddress,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS PropertySplitcity

from NashvilleHousing 


ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE NashvilleHousing 
ADD  PropertySplitcity nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT*
FROM  NashvilleHousing



--Split the Owmer Address using Parse


SELECT PARSENAME(REPLACE ( OwnerAddress,',','.'),3) AS ADDRESS,
PARSENAME(REPLACE ( OwnerAddress,',','.'),2)AS CITY,
PARSENAME(REPLACE ( OwnerAddress,',','.'),1) AS STATE


FROM NashvilleHousing


ALTER TABLE NashvilleHousing
ADD ADDRESS NVARCHAR(255);

UPDATE NashvilleHousing
SET ADDRESS= PARSENAME(REPLACE ( OwnerAddress,',','.'),3)
 

ALTER TABLE NashvilleHousing
ADD CITY NVARCHAR(255);

UPDATE NashvilleHousing
SET CITY = PARSENAME(REPLACE ( OwnerAddress,',','.'),2)


ALTER TABLE  NashvilleHousing
ADD STATE NVARCHAR(255);

UPDATE NashvilleHousing
SET STATE=PARSENAME(REPLACE ( OwnerAddress,',','.'),1)


SELECT*
FROM NashvilleHousing



--change y ana N to yes and no in sold as vacant 

SELECT DISTINCT( SoldAsVacant) ,COUNT( SoldAsVacant)
from NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldASVacant,
CASE WHEN  SoldASVacant='Y' THEN 'Yes'
WHEN  SoldASVacant='N' THEN 'No'
ELSE SoldAsVacant
END
FROM NashvilleHousing

 UPDATE NashvilleHousing
 SET SoldASVacant= CASE WHEN  SoldASVacant='Y' THEN 'Yes'
WHEN  SoldASVacant='N' THEN 'No'
ELSE SoldAsVacant
END 

--REMOVE DUPLICATE


WITH RowNumCTE AS (

SELECT*,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  LegalReference,
			  SaleDate
			  ORDER BY UniqueID 
			  ) row_num 

FROM  PortfolioProject.. NashvilleHousing )

SELECT*  --use delete instead of select then use select again to make sure that row_num >1 was deleted
FROM RowNumCTE 
WHERE row_num>1
--order by PropertyAddress




--DELETE unuseable columns
SELECT*
FROM NashvilleHousing 

alter table NashvilleHousing 
DROP COLUMN TaxDistrict
