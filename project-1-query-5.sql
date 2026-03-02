-- ============================================================
-- QUERY 5: PARTITION BY (Window Function)
-- "Rank applicants by offer salary within each company"
-- Uses RANK() with PARTITION BY
-- ============================================================
SELECT
    c.company_name,
    jl.title,
    a.username,
    app.offer_salary,
    RANK() OVER (
        PARTITION BY c.company_id
        ORDER BY app.offer_salary DESC
    ) AS salary_rank
FROM Application app
JOIN Applicant a ON app.applicant_id = a.applicant_id
JOIN Job_Listing jl ON app.listing_id = jl.listing_id
JOIN Company c ON jl.company_id = c.company_id
WHERE app.status = 'accepted' AND app.offer_salary IS NOT NULL
ORDER BY c.company_name, salary_rank;
-- Expected output: Accepted applicants ranked by salary within
-- each company. For example, at Google: bob_algo (175000, rank 1),
-- bob_algo intern (11000, rank 2), alice_dev intern (10500, rank 3).
-- At Citadel: henry_quant (300000, rank 1). Approximately 14 rows.