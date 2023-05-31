
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [sq].[dbo].[Nashville Housing Data for Data Cleaning] b
     on a.ParcelID = b.ParcelID
     AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [sq].[dbo].[Nashville Housing Data for Data Cleaning] b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress is null
--------------------------------------------------

--Breaking address to separeted values
------------------------------------------------------
--Change Y and N to Yes or No
--SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
--FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning]
--GROUP BY SoldAsVacant
--ORDER BY 2

SELECT SoldAsVacant,
    CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
	AS SoldAsVacantCorrect
FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning]
--GROUP BY SoldAsVacant
--ORDER BY 2

UPDATE [sq].[dbo].[Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
------------------------------------------------------
---Removing duplicates
SELECT ParcelID,  
	   SalePrice, 
	   LegalReference,
       COUNT(*) AS RowNumber
FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning]
GROUP BY ParcelID, 
	   SalePrice, 
	   LegalReference
HAVING COUNT(*) > 1;

DELETE FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning]
    WHERE UniqueID NOT IN
    (
        SELECT MAX(UniqueID) AS MaxRecordID
        FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning]
        GROUP BY ParcelID, 
	             SalePrice, 
	             LegalReference
    );

SELECT *
FROM dbo.[sq].[dbo].[Nashville Housing Data for Data Cleaning]
------------------------------------------------------
---removind unused columns

--ALTER TABLE [sq].[dbo].[Nashville Housing Data for Data Cleaning]
--DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

--SELECT *
--FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning]

---------------------------------------------------------
UPDATE [sq].[dbo].[Nashville Housing Data for Data Cleaning]
SET SaleDate = SaleDateConv

SELECT * FROM [sq].[dbo].[Nashville Housing Data for Data Cleaning]
------------------------------------------------------
---breaking out ownername to separate columns
ALTER TABLE [sq].[dbo].[Nashville Housing Data for Data Cleaning] ADD first_name VARCHAR(50);
ALTER TABLE [sq].[dbo].[Nashville Housing Data for Data Cleaning] ADD last_name VARCHAR(50);
ALTER TABLE [sq].[dbo].[Nashville Housing Data for Data Cleaning] ADD middle_name VARCHAR(50);

UPDATE [sq].[dbo].[Nashville Housing Data for Data Cleaning]
SET first_name = SUBSTRING(OwnerName, ',', 1)
-----------------------------------------------------