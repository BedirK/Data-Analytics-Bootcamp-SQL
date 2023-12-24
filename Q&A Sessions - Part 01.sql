--Soru: Tablodaki CategoryName ve Description kolonların allians ile çekiniz (Top 5 olarak)

SELECT 
TOP 5 
C.CategoryName KategoriAdlari, C.[Description] Aciklamalar FROM Categories C

--Soru: İçinde 'A' bulunmayan şehirleri seçiniz

SELECT * FROM Customers
WHERE
City NOT LIKE '%A%'

--Soru: PostalCode kolonu boş olan ve Region kolonu dolu olan gözlemlerin filtreleyiniz

SELECT PostalCode, Region
FROM Customers
WHERE PostalCode IS NULL 
AND Region IS NOT NULL

--Soru: Berlin ve London'un filtreleyin

SELECT *
FROM Customers
WHERE City = 'Berlin' OR City = 'London' 

SELECT *
FROM Customers
WHERE City IN ('Berlin','London') -- Şematik ve işlem kolaylılığı için çoklu seçimlerde "IN" kullanılabilir.

--Soru: Berlin ve London'u içermeyen gözlemleri çekiniz

SELECT *
FROM Customers
WHERE City <> 'Berlin' AND City <> 'London'

SELECT *
FROM Customers
WHERE City NOT IN ('Berlin','London') 

--Soru: Şehir bilgisi London veya Tacoma olan tüm personelin id , ad ve soyad bilgisini çekiniz
SELECT EmployeeID, LastName, FirstName, City
FROM Employees
WHERE City = 'Tacoma' OR City = 'London'

--ROUND 2 
--Soru: CategoryId adetlerini ayrı ayrı hesaplanyınız (ürünler)

SELECT
CategoryID ,
COUNT(CategoryID) adet
FROM
Products
GROUP BY
CategoryID

--Soru: CategoryId bazında min , max ve ortalama birim fiyatlarını hesaplayınız
--(Max fiyatlara göre yüksek fiyattan düşük fiyata sıralanması)

SELECT CategoryID, MIN(UnitPrice) min_br_fyt, MAX(UnitPrice) max_br_fyt, AVG(UnitPrice) ort_br_fyt
FROM Products
GROUP BY CategoryID
ORDER BY MAX (UnitPrice) DESC

--Soru: Customer tablosunundan ContactName, Orders tablosundan OrderID’ı çekiniz

SELECT C.ContactName, O.OrderID FROM Customers C
LEFT JOIN Orders O
ON C.CustomerID = O.CustomerID

--Soru: Orders tablosunundan OrderID ile Customers tablosundan ContactName’i birleşmiş bir tablodan çekiniz

SELECT O.OrderID, C.ContactName ,COUNT(*)
FROM Orders O
INNER JOIN Customers C
ON O.CustomerID = C.CustomerID   --GROUP BY  C.ContactName , OrderID having COUNT(*)>1   //// TO CHECK DUPLICATE or ERRORS

--Soru: Ürün ve Şirket adlarını listeleyin

SELECT P.ProductName UrunAdi, S.CompanyName SirketIsmi
FROM Products P 
LEFT JOIN Suppliers S 
ON P.SupplierID = S.SupplierID

--Soru: Ürün ve kategori adlarını listeleyin

SELECT P.ProductName, C.CategoryName
FROM Products P
LEFT JOIN Categories C
ON P.CategoryID = C.CategoryID

--BONUS :)
SELECT * FROM
(SELECT P.ProductName, C.CategoryName
FROM Products P
LEFT JOIN Categories C
ON P.CategoryID = C.CategoryID) A
WHERE A.CategoryName LIKE 'B%'

--Soru: Ürün ve Şirket adlarını listeleyiniz ve adetlerini bulun

SELECT A.SirketIsmi, A.UrunAdi, COUNT(A.SirketIsmi) sirketsayisi, COUNT(A.UrunAdi) urunsayisi FROM
(SELECT P.ProductName UrunAdi, S.CompanyName SirketIsmi
FROM Products P 
LEFT JOIN Suppliers S 
ON P.SupplierID = S.SupplierID) A
GROUP BY A.SirketIsmi, A.UrunAdi

--ALTERNATIF COZUM
SELECT P.ProductName UrunAdi, COUNT(ProductName), S.CompanyName SirketIsmi, COUNT(CompanyName)
FROM Products P 
LEFT JOIN Suppliers S 
ON P.SupplierID = S.SupplierID
GROUP BY ProductName, CompanyName

--Soru: Kategori bazında toplam fiyatın hesaplanması ve toplam birim fiyatı 200'den düşük kategorilerin filtreleyiniz

SELECT * FROM
(SELECT CategoryID, SUM(UnitPrice) toplam_br_fyt
FROM Products
GROUP BY CategoryID) A 
WHERE toplam_br_fyt < 200

--ALTERNATIF 1.CİL ÇÖZUM
SELECT CategoryID, SUM(UnitPrice) toplam_br_fyt
FROM Products
GROUP BY CategoryID
HAVING SUM(UnitPrice) < 200

--Soru: En ucuz 5 ürünün ortalama fiyatı nedir ?

SELECT AVG(UnitPrice) Ortalam_br_fyt FROM 
(SELECT TOP 5 ProductName, UnitPrice
 FROM Products
ORDER BY UnitPrice ASC) A 

--Soru: En pahalı ürününün adı nedir?

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products)

-- BONUS (EN PAHALI 2. ÜRÜN NEDİR)

SELECT TOP 1 ProductName, UnitPrice
FROM Products
WHERE UnitPrice <> (SELECT MAX(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC

--Soru: En pahalı ve en ucuz ürünü listeleyiniz. (UNION)

SELECT * FROM
(SELECT TOP 1 * FROM Products
ORDER BY UnitPrice DESC) A
UNION
SELECT * FROM
(SELECT TOP 1 * FROM Products
ORDER BY UnitPrice ASC) B

--Soru: Zamanında teslim edemediğim siparişlerim ID’leri nelerdir ve kaç gün geç gönderildi?

SELECT OrderID, RequiredDate, ShippedDate, DATEDIFF(DAY, ShippedDate, RequiredDate) GecikmeSuresi
FROM Orders     
WHERE DATEDIFF(DAY, ShippedDate, RequiredDate) > 0 
ORDER BY GecikmeSuresi DESC

-- ODEV 1 "Geciken Urunler"in ortalama Kac gun Geciktiğini bulan sorguyu yazınız.

SELECT OrderID, AVG(GecikmeSuresi) OrtalamaGecikmeSuresi FROM
(SELECT OrderID, RequiredDate, ShippedDate, DATEDIFF(DAY, ShippedDate, RequiredDate) GecikmeSuresi
FROM Orders     
WHERE DATEDIFF(DAY, ShippedDate, RequiredDate) > 0 ) A 
GROUP BY OrderID

-- ODEV 2 "Erken Giden Urunler" ortalama kac gun erken gittiğini bulan sorguyu yazınız.

SELECT OrderID, AVG(ErkenTeslimSuresi) OrtalamaErkenTeslimSuresi FROM
(SELECT OrderID, RequiredDate, ShippedDate, DATEDIFF(DAY, RequiredDate, ShippedDate) ErkenTeslimSuresi
FROM Orders     
WHERE DATEDIFF(DAY, RequiredDate, ShippedDate) > 0 ) B
GROUP BY OrderID
