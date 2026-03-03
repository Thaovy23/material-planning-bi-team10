SELECT
    pv.ProductID,
    pv.VendorID,
    v.VendorName,
    v.CreditRating,
    v.PreferredVendorStatus,
    v.ActiveFlag,
    pv.AverageLeadTime,
    pv.StandardPrice,
    pv.LastReceiptCost,
    (pv.StandardPrice + pv.LastReceiptCost) / 2.0 AS AvgCost
FROM ProductVendor pv
JOIN DimVendor v ON pv.VendorID = v.VendorID


