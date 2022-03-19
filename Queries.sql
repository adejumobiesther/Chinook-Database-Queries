/*which country has the most invoices*/
SELECT BillingCountry, COUNT(*) counter
FROM Invoice
GROUP BY BillingCountry
ORDER BY counter DESC

/*which city has the best customers*/
SELECT BillingCity, SUM(total) totals
FROM Invoice
GROUP BY BillingCity
ORDER BY totals DESC

/*who is the best customer */
SELECT C.CustomerId, C.FirstName, C.LastName, SUM(IL.UnitPrice * IL.Quantity) total_price
FROM Customer C
JOIN Invoice I
ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL
ON IL.InvoiceId = I.InvoiceId
GROUP BY C.CustomerId, C.FirstName, C.LastName
ORDER BY total_price DESC

/* Details of Rock Music Listeners */
SELECT DISTINCT C.FirstName, C.LastName, C.Email, G.Name
FROM Genre G
JOIN Track T
ON T.GenreId = G.GenreId
JOIN InvoiceLine IL
ON IL.TrackId = T.TrackId
JOIN Invoice I
ON IL.InvoiceId = I.InvoiceId
JOIN Customer C
ON I.CustomerId = C.CustomerId
WHERE G.Name = "Rock"
ORDER BY C.Email

/*Who is writing the Rock Music */
SELECT AR.Name, COUNT(A.AlbumId) Number_of_songs
FROM Genre G
JOIN Track T
ON T.GenreId = G.GenreId
JOIN Album A
ON T.AlbumId = A.AlbumId
JOIN Artist AR
ON A.ArtistId = AR.ArtistId 
WHERE G.Name = "Rock"
GROUP BY AR.Name
ORDER BY Number_of_songs DESC
LIMIT 10

/*Artist that earned the most according to InvoiceLine and customer that patronised the Artist*/
SELECT C.CustomerId, C.FirstName, C.LastName, AR.Name as artist_name, SUM(IL.UnitPrice * IL.Quantity) Total_Earnings
FROM Customer C
JOIN Invoice I
ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL
ON IL.InvoiceId = I.InvoiceId
JOIN Track T
ON IL.TrackId = T.TrackId
JOIN Album A
ON T.AlbumId = A.AlbumId
JOIN Artist AR
ON A.ArtistId = AR.ArtistId
GROUP BY C.CustomerId, C.FirstName, C.LastName, artist_name
ORDER BY Total_Earnings DESC

/* Most Popular Music Genre for each Country */
with t1 as (
SELECT G.Name, G.GenreId, C.Country, COUNT(IL.UnitPrice * IL.Quantity) Total_amount
FROM Genre G
JOIN Track T
ON T.GenreId = G.GenreId
JOIN InvoiceLine IL
ON IL.TrackId = T.TrackId
JOIN Invoice I
ON IL.InvoiceId = I.InvoiceId
JOIN Customer C
ON I.CustomerId = C.CustomerId
GROUP BY G.Name, G.GenreId, C.Country),
t2 as (
SELECT Name, GenreId, Country, SUM(Total_amount) sum_total
FROM t1
GROUP BY Name, GenreId,Country),
t3 as (
SELECT Country, MAX(sum_total) sum_total
FROM t2
GROUP BY Country)

SELECT t2.Name, t2.GenreId, t2.Country, t2.sum_total
FROM t2
INNER JOIN t3 
ON t2.Country = t3.Country AND t2.sum_total = t3.sum_total

/*Track name with song length longer than the average song length*/
SELECT Name, Milliseconds
FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds)
                        FROM Track)
ORDER BY Milliseconds DESC

/* Customer that spent the most on music for each country */
with t1 as (SELECT C.CustomerId, C.Country,C.FirstName, C.LastName, SUM(Total) Total_spent
FROM Customer C
JOIN Invoice I
ON I.CustomerId = C.CustomerId
GROUP BY C.CustomerId, C.Country, C.FirstName, C.LastName),
t2 as(
SELECT Country, MAX(Total_spent) Total_spent
FROM t1
GROUP BY Country)

SELECT t1.CustomerId, t1.Country, t1.FirstName, t1.LastName, t1.Total_spent
FROM t1
JOIN t2
ON t1.Country = t2.Country AND t1.Total_spent = t2.Total_spent

/*which year did each country have the most invoices*/
with t1 as (SELECT BillingCountry, strftime('%Y', InvoiceDate) as Year, COUNT(*) counter
FROM Invoice
GROUP BY BillingCountry, Year),
t2 as (SELECT BillingCountry, Year, MAX(counter) as counter
FROM t1
GROUP BY BillingCountry)

SELECT t1.BillingCountry, t1.Year, t1.counter
FROM t1
JOIN t2
ON t1.BillingCountry = t2.BillingCountry and t1.counter= t2.counter




