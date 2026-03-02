-- ============================================================
-- QUERY 7: RCTE (Recursive Common Table Expression)
-- "Build a salary bracket distribution showing how many
--  accepted offers fall into each $25k bracket"
-- Uses recursive CTE to generate the brackets dynamically
-- ============================================================
WITH RECURSIVE salary_brackets(bracket_low, bracket_high) AS (
    -- Anchor: start at the minimum salary bracket
    SELECT 0, 25000
    UNION ALL
    -- Recursive: increment by $25k until we cover all salaries
    SELECT bracket_low + 25000, bracket_high + 25000
    FROM salary_brackets
    WHERE bracket_high < (SELECT MAX(offer_salary) FROM Application WHERE status = 'accepted')
),
accepted_offers AS (
    SELECT
        app.offer_salary,
        a.username,
        c.company_name
    FROM Application app
    JOIN Applicant a ON app.applicant_id = a.applicant_id
    JOIN Job_Listing jl ON app.listing_id = jl.listing_id
    JOIN Company c ON jl.company_id = c.company_id
    WHERE app.status = 'accepted' AND app.offer_salary IS NOT NULL
)
SELECT
    sb.bracket_low || ' - ' || sb.bracket_high AS salary_range,
    COUNT(ao.offer_salary) AS num_offers,
    COALESCE(GROUP_CONCAT(ao.username || ' (' || ao.company_name || ')'), 'None') AS applicants
FROM salary_brackets sb
LEFT JOIN accepted_offers ao
    ON ao.offer_salary >= sb.bracket_low AND ao.offer_salary <= sb.bracket_high
GROUP BY sb.bracket_low, sb.bracket_high
HAVING num_offers > 0
ORDER BY sb.bracket_low;
-- Expected output: Salary brackets with counts. Intern salaries
-- cluster in 0-25000 range, new grad salaries in 75000-200000,
-- and senior offers in 200000-350000. Approximately 5-7 bracket
-- rows depending on salary distribution.