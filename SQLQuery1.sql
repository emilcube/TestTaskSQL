--1
SELECT count(DM_City.Name) AS First_Row_is_Region_and_Second_row_is_Moscow
FROM DM_Card INNER JOIN DM_POS 
ON DM_Card.POS_ID=DM_POS.ID
INNER JOIN DM_MEGAMall
ON DM_POS.MEGAMall_ID=DM_MEGAMall.ID
INNER JOIN DM_City
ON DM_MEGAMall.City_ID=DM_City.ID
WHERE (DM_Card.EmbossingDate between '01.07.2015' and '31.07.2015') AND DM_City.Name!='Москва'
UNION
SELECT count(DM_City.Name)
FROM DM_Card INNER JOIN DM_POS 
ON DM_Card.POS_ID=DM_POS.ID
INNER JOIN DM_MEGAMall
ON DM_POS.MEGAMall_ID=DM_MEGAMall.ID
INNER JOIN DM_City
ON DM_MEGAMall.City_ID=DM_City.ID
WHERE (DM_Card.EmbossingDate between '01.07.2015' and '31.07.2015') AND DM_City.Name='Москва'

--2
SELECT count(DM_Card.Card_ID)*100/(SELECT count(DM_Card.Card_ID)
FROM DM_Card INNER JOIN DM_Purchase
ON DM_Card.Card_ID=DM_Purchase.Card_ID
WHERE DM_Card.EmbossingDate between '01.06.2015' and '30.06.2015') as Percentage
FROM DM_Card INNER JOIN DM_Purchase
ON DM_Card.Card_ID=DM_Purchase.Card_ID
WHERE DM_Card.EmbossingDate between '01.06.2015' and '30.06.2015'  AND
DATEDIFF(day,DM_Card.EmbossingDate,DM_Purchase.TransactionDate)<=30

--4
SELECT DM_SocioDemograph.Client_ID, DM_SocioDemograph.BirthDate,
DATEDIFF(hour,DM_SocioDemograph.BirthDate,GETDATE())/8766 AS Age
FROM DM_SocioDemograph

--5
SELECT top 5 DM_MEGAMall.Name, Count(DM_MEGAMall.Name)
FROM DM_Purchase INNER JOIN DM_Shop
ON DM_Purchase.Terminal_ID=DM_Shop.Terminal_ID
INNER JOIN DM_Brand
ON DM_Shop.Brand_ID=DM_Brand.Id
INNER JOIN DM_MEGAMall
ON DM_Shop.MEGAMall_ID=DM_MEGAMall.ID
WHERE DM_Brand.Name='Zara'
GROUP BY
DM_MEGAMall.Name

--7
SELECT *
FROM
(SELECT Table000.Name,Count(Table000.Name) as Purchase_specific_month
FROM 
(SELECT DM_Brand.Name, DM_Purchase.Card_ID
FROM DM_Purchase INNER JOIN DM_Shop
ON DM_Purchase.Terminal_ID=DM_Shop.Terminal_ID
INNER JOIN DM_Brand
ON DM_Shop.Terminal_ID=DM_Brand.ID
WHERE (DM_Purchase.TransactionDate between '01.06.2015' and '30.06.2015')
) AS Table000
GROUP BY Table000.Name) AS A

LEFT JOIN

(SELECT Table111.Name,Count(Table111.Name) as Repeated_purchase
FROM
(SELECT DM_Brand.Name, DM_Purchase.Card_ID
FROM DM_Purchase INNER JOIN DM_Shop
ON DM_Purchase.Terminal_ID=DM_Shop.Terminal_ID
INNER JOIN DM_Brand
ON DM_Shop.Terminal_ID=DM_Brand.ID
WHERE (DM_Purchase.TransactionDate between '01.06.2015' and '30.06.2015')
INTERSECT
SELECT DM_Brand.Name, DM_Purchase.Card_ID
FROM DM_Purchase INNER JOIN DM_Shop
ON DM_Purchase.Terminal_ID=DM_Shop.Terminal_ID
INNER JOIN DM_Brand
ON DM_Shop.Terminal_ID=DM_Brand.ID
WHERE (DM_Purchase.TransactionDate between '01.07.2015' and '30.09.2015') 
) AS Table111
GROUP BY Table111.Name) AS B
ON A.Name=B.Name

--8
SELECT DM_MEGAMall.Name, DM_Brand.Name, DM_Category.Name
FROM DM_Shop, DM_Category, DM_MEGAMall, DM_Brand
WHERE DM_Category.ID=DM_Shop.Category_ID AND DM_MEGAMall.ID=DM_Shop.MEGAMall_ID AND DM_Brand.ID=DM_Shop.Brand_ID
AND DM_Category.Name='Одежда'
ORDER BY DM_MEGAMall.Name

--9
SELECT * 
FROM DM_Card
WHERE DM_Card.Card_ID IN 
(SELECT A.Card_ID
FROM (
SELECT DM_Card.Card_ID, DM_City.Name
FROM (DM_Card INNER JOIN DM_Purchase
ON DM_Card.Card_ID=DM_Purchase.Card_ID
INNER JOIN DM_Shop
ON DM_Purchase.Terminal_ID=DM_Shop.Terminal_ID
INNER JOIN DM_MEGAMall
ON DM_Shop.MEGAMall_ID=DM_MEGAMall.ID
INNER JOIN DM_City
ON DM_MEGAMall.City_ID=DM_City.ID) 
EXCEPT
SELECT DM_Card.Card_ID, DM_City.Name
FROM DM_Card INNER JOIN DM_POS
ON DM_Card.POS_ID=DM_POS.ID
INNER JOIN DM_MEGAMall
ON DM_POS.MEGAMall_ID=DM_MEGAMall.ID
INNER JOIN DM_City
ON DM_MEGAMall.City_ID=DM_City.ID
) AS A)

--10
SELECT DM_SocioDemograph.Client_ID, DM_SocioDemograph.ChildrenCount
FROM DM_SocioDemograph