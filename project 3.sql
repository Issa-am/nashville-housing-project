-- 
-- changing saleprice datatype to varchar 

alter table nashvillehousing
alter column saleprice type varchar(100)

-- selecting all the rows 
select * from nashvillehousing 


/*populating the null value in propertyaddres with the equivalent comes from the 
same parcelid but different unique id which lead us to make a self join */

-- breaking out address into individual column (Address, City, State)
-- substring, character indexing 

select split_part(propertyaddress, ',', 1), split_part(propertyaddress, ',', 2)
from nashvillehousing

-- now we have separated two columns based on , we need to add two columns to the table
alter table nashvillehousing 
add propertysplitaddress varchar(300)

update nashvillehousing
set propertysplitaddress = split_part(propertyaddress, ',', 1)

alter table nashvillehousing
add propertysplitcity varchar(200)

update nashvillehousing
set propertysplitcity = split_part(propertyaddress, ',', 2)

-- separating owner address into address, city and state
select split_part(owneraddress, ',', 1), split_part(owneraddress, ',', 2),
split_part(owneraddress, ',', 3)
from nashvillehousing

-- adding the three columns to the table 

alter table nashvillehousing 
add ownersplitaddress varchar(300);

update nashvillehousing
set ownersplitaddress = split_part(owneraddress, ',', 1)

alter table nashvillehousing
add ownersplitcity varchar(200)

update nashvillehousing
set ownersplitcity = split_part(owneraddress, ',', 2)

alter table nashvillehousing
add ownersplitstate varchar(200)

update nashvillehousing
set ownersplitstate = split_part(owneraddress, ',', 3)

-- change y and n to yes and no in "sold as vacant" field 
-- we will use a case statement 

select distinct(soldasvacant), count(soldasvacant) from nashvillehousing
group by soldasvacant
order by count 

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
     end
from nashvillehousing 

update nashvillehousing 
set soldasvacant =case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
     end

-- remove duplicates
-- we will use window functions such as row_number(), rank() or dense_rank()
-- we will partition by based on some columns and using wow_number() we will assign ranks
-- to the row numbers duplicated (their row_number() will be 2) and then delete them
-- to do the query we will create a CTE and then we will do query on the CTE

with rownumcte as (
select *,
	row_number() over (
		partition by parcelid,
		propertyaddress,
		saleprice,
		saledate,
		legalreference
		order by 
		    uniqueid) row_num
from nashvillehousing)
delete
from rownumcte
where row_num > 1
--order by propertyaddress

-- now with the query above we found duplicated nd we want to delete them using almost 
-- the same query but replacing "SELECT" with "DELETE"
						 
with rownumcte as (
select *,
	row_number() over (
		partition by parcelid,
		propertyaddress,
		saleprice,
		saledate,
		legalreference
		order by 
		    uniqueid) row_num
from nashvillehousing)
DELETE
from rownumcte
where row_num > 1
--order by propertyaddress


-- delete unused column 

select * from nashvillehousing 

alter table nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress

select saledate from nashvillehousing







