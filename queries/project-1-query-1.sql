-- ============================================================
-- QUERY 1: Three-table JOIN
-- "What skills do accepted applicants have for each company?"
-- Joins: Application -> Applicant_Skill -> Skill
-- Also joins Company via Job_Listing for company names
-- ============================================================
SELECT
    c.company_name,
    jl.title AS listing_title,
    a.username,
    s.skill_name,
    ask.proficiency_level,
    app.offer_salary
FROM Application app
JOIN Applicant a ON app.applicant_id = a.applicant_id
JOIN Job_Listing jl ON app.listing_id = jl.listing_id
JOIN Company c ON jl.company_id = c.company_id
JOIN Applicant_Skill ask ON a.applicant_id = ask.applicant_id
JOIN Skill s ON ask.skill_id = s.skill_id
WHERE app.status = 'accepted'
ORDER BY c.company_name, a.username, s.skill_name;
-- Expected output: Multiple rows showing each accepted
-- applicant's skills per company. For example, bob_algo
-- accepted at Google SWE Intern will appear with rows for
-- Python, C++, ML, and System Design. Approximately 50+ rows
-- since each accepted applicant contributes one row per skill.
