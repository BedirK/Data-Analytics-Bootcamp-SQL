--Soru: Satışlar kaç günde teslim edildi?

SELECT OrderID, DATEDIFF(DAY, OrderDate, ShippedDate) teslim_suresi 
FROM Orders
WHERE ShippedDate IS NOT NULL
ORDER BY teslim_suresi DESC

--Soru: Hangi kargo şirketine toplam 25000 birimden daha az ödeme yapılmıştır ?

SELECT S.CompanyName, SUM(O.Freight) payment
FROM Orders O 
LEFT JOIN Shippers S
ON O.ShipVia = S.ShipperID  
GROUP BY S.CompanyName
HAVING SUM(O.Freight) <= 25000     

--Soru: Çalışanlar ne kadarlık satış yapmıştır?

SELECT E.EmployeeID, E.LastName, E.FirstName, SUM(OD.UnitPrice * OD.Quantity) TotalSales
FROM Orders O 
INNER JOIN  Employees E ON O.EmployeeID = E.EmployeeID
INNER JOIN  [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID, E.LastName, E.FirstName

--ALTERNATIVE QUERY 

SELECT E.EmployeeID, (E.LastName + ' ' + E.FirstName) Salesman, SUM(OD.UnitPrice * OD.Quantity) TotalSales
FROM Orders O 
INNER JOIN  Employees E ON O.EmployeeID = E.EmployeeID
INNER JOIN  [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID, (E.LastName + ' ' + E.FirstName)

--Soru: 50 'den fazla satışı olan çalışanları nasıl bulabilirim ?

SELECT E.EmployeeID, (E.LastName + ' ' + E.FirstName) Salesman, COUNT(O.OrderID) CountSales
FROM Orders O 
INNER JOIN  Employees E ON O.EmployeeID = E.EmployeeID
GROUP BY E.EmployeeID, (E.LastName + ' ' + E.FirstName)
HAVING COUNT(O.OrderID) > 50

--Soru: Çalışanlar ürün bazında ne kadarlık satış yapmışlar?

SELECT E.EmployeeID, (E.LastName + ' ' + E.FirstName) Salesman,P.ProductName, SUM(OD.Quantity) TotalSales, SUM(OD.UnitPrice * OD.Quantity) TotalSalesPrice
FROM Orders O 
INNER JOIN  Employees E ON O.EmployeeID = E.EmployeeID
INNER JOIN  [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN  Products P ON P.ProductID = OD.ProductID
GROUP BY E.EmployeeID, (E.LastName + ' ' + E.FirstName), P.ProductName

--Soru: Toplam birim fiyatı 200'den düşük kategorilerin getiriniz.

SELECT C.CategoryName, SUM(P.UnitPrice) TotalUnitPrice
FROM Categories C 
INNER JOIN Products P ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName
HAVING SUM(P.UnitPrice) < 200

--Soru: En değerli müşterim hangisi? (en fazla satış yaptığım müşteri) (Gelir ve adet bazında)

SELECT TOP 1 C.CompanyName, SUM(OD.Quantity) TotalSales, SUM(OD.UnitPrice * OD.Quantity) TotalSalesPrice
FROM Orders O  
INNER JOIN Customers C ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY C.CompanyName
ORDER BY TotalSalesPrice DESC

--Soru: Discount oranını da hesaba katarak en çok para getiren 5 ürünü bulunuz.

SELECT * FROM (
SELECT *, ROW_NUMBER() OVER(ORDER BY Total_Amount DESC) AS RN
FROM ( SELECT ProductID, ROUND(sum(Amount),0) as Total_Amount
FROM (SELECT ProductID, UnitPrice * Quantity * (1- Discount) as Amount
FROM [Order Details] ) T1
GROUP BY ProductID) T2) T3
WHERE RN <= 5

--Soru: En yüksek ikinci unit_price değerini row_number kullanmadan bulunuz.

SELECT MAX(UnitPrice) UnitPriceValue FROM [Order Details]
WHERE UnitPrice <> (SELECT MAX(UnitPrice) 
FROM [Order Details])

-- same question (by using row number)
SELECT UnitPrice FROM 
(SELECT UnitPrice, ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RN 
FROM [Order Details]) A 
WHERE RN = 2

--Siparişin verildiği gün ile o ayın son günü arasındaki farkı bulunuz

SELECT OrderID, OrderDate, EOMONTH(OrderDate) EndOfMonth, DATEDIFF(DAY,OrderDate,EOMONTH(OrderDate)) DayDiff
FROM Orders

--Soru: 10’dan fazla sipariş veren müşterilerin ID ve sipariş sayılarını bulunuz.

SELECT CustomerID, COUNT(OrderID) CountOrder
FROM Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT OrderID) > 10

--Soru: Bir seferinde 100’den fazla quantitysi alınmış ürünlerden olup stocktaki unit sayısı 100 altında olan ürünlerin ID’lerini listeleyiniz.

SELECT DISTINCT ProductID, Quantity
FROM [Order Details]
WHERE quantity > 100

EXCEPT    -- MINUS

SELECT DISTINCT ProductID, UnitsInStock
FROM Products
WHERE UnitsInStock < 100;

--Soru: 1997 yılındaki her aya ait toplam miktarı hesaplayıp mevcut ay, o aya ait toplam harcama, bir önceki ve bir sonra ki aya ait toplam harcama bilgilerini paylaşınız

--Soru: Orders tablosunda Ship Region’ı dolu olanların bilgisini tutan ama boş olanları Ship_City’nin ilk 3 harfini büyük harf ile gösterecek şekilde alan query’yi yazınız. COALESCE() fonksiyonu, bir ifade listesindeki ilk boş olmayan değeri döndürmek için kullanılır.
