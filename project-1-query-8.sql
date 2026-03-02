-- ============================================================
-- QUERY 8: Correlated Subquery + Aggregation
-- "For each skill, show how many accepted vs rejected
--  applicants had it, to identify which skills correlate
--  with success"
-- ============================================================
SELECT
    s.skill_name,
    s.skill_type,
    (
        SELECT COUNT(DISTINCT app.applicant_id)
        FROM Application app
        JOIN Applicant_Skill ask2 ON app.applicant_id = ask2.applicant_id
        WHERE ask2.skill_id = s.skill_id AND app.status = 'accepted'
    ) AS accepted_with_skill,
    (
        SELECT COUNT(DISTINCT app.applicant_id)
        FROM Application app
        JOIN Applicant_Skill ask2 ON app.applicant_id = ask2.applicant_id
        WHERE ask2.skill_id = s.skill_id AND app.status = 'rejected'
    ) AS rejected_with_skill,
    (
        SELECT COUNT(DISTINCT ask2.applicant_id)
        FROM Applicant_Skill ask2
        WHERE ask2.skill_id = s.skill_id
    ) AS total_applicants_with_skill
FROM Skill s
ORDER BY accepted_with_skill DESC;
-- Expected output: 15 rows (one per skill). Python should rank
-- highest for accepted_with_skill since most successful
-- applicants know it. Skills like Node.js and TypeScript may
-- show fewer accepted applicants. Git and Docker appear across
-- both accepted and rejected applicants.