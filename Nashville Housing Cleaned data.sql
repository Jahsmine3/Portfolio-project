SELECT *
FROM portfolioproject.nashvillehousing;

SELECT propertyaddress
FROM nashvillehousing

-- seperating the address table by comma

 SELECT 
    SUBSTRING(propertyaddress, 1, LOCATE(',', propertyaddress) - 1) AS Address, 
    SUBSTRING(propertyaddress, LOCATE(',', propertyaddress) + 1, LENGTH(propertyaddress)) AS City
FROM nashvillehousing;

-- Add a new column for the Address 

ALTER TABLE nashvillehousing
ADD PropertySplittedAddress VARCHAR(200);

-- Update the SplittedAddress column with only the address part (before the comma)
UPDATE nashvillehousing
SET PropertySplittedAddress = SUBSTRING(propertyaddress, 1, LOCATE(',', propertyaddress) - 1);

-- Add a new column for the City (if it does not already exist)
ALTER TABLE nashvillehousing
ADD City VARCHAR(200);

-- Update the City column with the city part (after the comma)
UPDATE nashvillehousing
SET City = SUBSTRING(propertyaddress, LOCATE(',', propertyaddress) + 1, LENGTH(propertyaddress));


SELECT *
FROM nashvillehousing


SELECT owneraddress
FROM nashvillehousing

-- creating new columns to split owneradddress
ALTER TABLE nashvillehousing  
ADD SpittedOwnerAddress VARCHAR(255),  
ADD OwnerCity VARCHAR(255),  
ADD OwnerState VARCHAR(255);

-- updating the table
UPDATE nashvillehousing  
SET SpittedOwnerAddress = SUBSTRING_INDEX(owneraddress, ',', 1),  
    OwnerCity = SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', -2), ',', 1),  
    OwnerState = SUBSTRING_INDEX(owneraddress, ',', -1);
    
    SELECT SpittedOwnerAddress, OwnerCity, OwnerState
    FROM nashvillehousing

-- changing Y/N to Yes/No
SELECT DISTINCT(SoldAsVacant)
FROM nashvillehousing


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT  
    SoldAsVacant,  
    CASE  
        WHEN SoldAsVacant = 'Y' THEN 'Yes'  
        WHEN SoldAsVacant = 'N' THEN 'No'  
        ELSE SoldAsVacant  
    END AS SoldAsVacantFormatted  
FROM nashvillehousing;


UPDATE nashvillehousing  
SET SoldAsVacant =  
    CASE  
        WHEN SoldAsVacant = 'Y' THEN 'Yes'  
        WHEN SoldAsVacant = 'N' THEN 'No'  
        ELSE SoldAsVacant  
    END;


-- Deleting duplicates
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY ParcelID,
						Propertyaddress,
						SalePrice,
						SaleDate,
						LegalReference
			ORDER BY UniqueID
		) AS row_num
	FROM nashvillehousing
    )
SELECT * FROM RowNumCTE;

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

  
DELETE FROM nashvillehousing  
WHERE UniqueID IN (SELECT UniqueID FROM RowNumCTE WHERE row_num > 1);

-- checking for the duplicate
SELECT ParcelID, Propertyaddress, SalePrice, SaleDate, LegalReference, COUNT(*) AS DuplicateCount  
FROM nashvillehousing  
GROUP BY ParcelID, Propertyaddress, SalePrice, SaleDate, LegalReference  
HAVING COUNT(*) > 1;
