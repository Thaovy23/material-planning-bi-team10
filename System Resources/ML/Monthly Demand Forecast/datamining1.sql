SELECT 
    p.ProductID,
    p.ProductName,
    YEAR(CONVERT(date, CAST(OrderDateKey AS CHAR(8)), 112)) AS OrderYear,
    MONTH(CONVERT(date, CAST(OrderDateKey AS CHAR(8)), 112)) AS OrderMonth,
    count(*) AS NumTransactions,
    SUM(f.ReceivedQty - f.RejectedQty) AS TotalDemandQty
FROM FactMaterial AS f
INNER JOIN DimProduct AS p
    ON f.ProductKey = p.ProductID
GROUP BY 
    p.ProductID,
    YEAR(CONVERT(date, CAST(OrderDateKey AS CHAR(8)), 112)),
    MONTH(CONVERT(date, CAST(OrderDateKey AS CHAR(8)), 112)),
    p.ProductName
ORDER BY 
    p.ProductID,
    
    OrderYear,
    OrderMonth;

