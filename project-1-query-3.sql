-- ============================================================
-- QUERY 3: GROUP BY with HAVING
-- "Which companies have an acceptance rate below 50%?"
-- Groups applications by company, filters with HAVING
-- ============================================================
SELECT
    c.company_name,
    COUNT(app.application_id) AS total_applications,
    SUM(CASE WHEN app.status = 'accepted' THEN 1 ELSE 0 END) AS total_accepted,
    ROUND(
        100.0 * SUM(CASE WHEN app.status = 'accepted' THEN 1 ELSE 0 END) / COUNT(app.application_id),
        1
    ) AS acceptance_rate_pct
FROM Application app
JOIN Job_Listing jl ON app.listing_id = jl.listing_id
JOIN Company c ON jl.company_id = c.company_id
GROUP BY c.company_id, c.company_name
HAVING acceptance_rate_pct < 50.0
ORDER BY acceptance_rate_pct ASC;
-- Expected output: Companies where fewer than half of
-- applications resulted in acceptance. Google (many applicants,
-- few accepted) and Palantir (mostly rejections) should appear.
-- Approximately 3-5 rows.