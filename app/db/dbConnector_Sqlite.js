const sqlite3 = require("sqlite3");
const { open } = require("sqlite");
const path = require("path");

async function getDb() {
  return open({
    filename: path.join(__dirname, "project-1-database.sqlite3"),
    driver: sqlite3.Database,
  });
}

// --- JOB LISTINGS ---
async function getListings() {
  const db = await getDb();
  return db.all(`
    SELECT jl.*, c.company_name, c.industry, c.headquarters_location
    FROM Job_Listing jl
    JOIN Company c ON jl.company_id = c.company_id
    ORDER BY jl.posted_date DESC
  `);
}

async function getListingById(id) {
  const db = await getDb();
  const listing = await db.get(`
    SELECT jl.*, c.company_name, c.industry, c.website_url, c.headquarters_location
    FROM Job_Listing jl
    JOIN Company c ON jl.company_id = c.company_id
    WHERE jl.listing_id = ?
  `, id);

  const requirements = await db.all(`
    SELECT s.skill_name, s.skill_type, lr.is_required, lr.desired_proficiency
    FROM Listing_Requirement lr
    JOIN Skill s ON lr.skill_id = s.skill_id
    WHERE lr.listing_id = ?
  `, id);

  const applications = await db.all(`
    SELECT app.*, a.username, a.university, a.gpa, a.degree_level
    FROM Application app
    JOIN Applicant a ON app.applicant_id = a.applicant_id
    WHERE app.listing_id = ?
    ORDER BY app.applied_date DESC
  `, id);

  return { listing, requirements, applications };
}

// --- APPLICANTS ---
async function getApplicants() {
  const db = await getDb();
  return db.all(`
    SELECT a.*,
      COUNT(app.application_id) AS total_apps,
      SUM(CASE WHEN app.status = 'accepted' THEN 1 ELSE 0 END) AS accepted_count
    FROM Applicant a
    LEFT JOIN Application app ON a.applicant_id = app.applicant_id
    GROUP BY a.applicant_id
    ORDER BY a.gpa DESC
  `);
}

async function getApplicantById(id) {
  const db = await getDb();
  const applicant = await db.get(`SELECT * FROM Applicant WHERE applicant_id = ?`, id);
  const skills = await db.all(`
    SELECT s.skill_name, s.skill_type, ask.proficiency_level, ask.years_used
    FROM Applicant_Skill ask
    JOIN Skill s ON ask.skill_id = s.skill_id
    WHERE ask.applicant_id = ?
    ORDER BY ask.proficiency_level DESC
  `, id);
  const applications = await db.all(`
    SELECT app.*, jl.title, c.company_name, c.industry
    FROM Application app
    JOIN Job_Listing jl ON app.listing_id = jl.listing_id
    JOIN Company c ON jl.company_id = c.company_id
    WHERE app.applicant_id = ?
    ORDER BY app.applied_date DESC
  `, id);
  return { applicant, skills, applications };
}

// --- APPLICATIONS ---
async function getApplications() {
  const db = await getDb();
  return db.all(`
    SELECT app.*, a.username, a.university, a.gpa, jl.title, c.company_name,
      CASE
        WHEN app.status = 'accepted' THEN 'Offer Received'
        WHEN app.status = 'withdrawn' THEN 'Self-Withdrawn'
        WHEN app.status = 'applied' THEN 'In Progress'
        WHEN app.rejection_stage = 'application' THEN 'Rejected: Resume Screen'
        WHEN app.rejection_stage = 'OA' THEN 'Rejected: Online Assessment'
        WHEN app.rejection_stage = 'phoneScreen' THEN 'Rejected: Phone Screen'
        WHEN app.rejection_stage = 'interview' THEN 'Rejected: Final Interview'
        WHEN app.rejection_stage = 'offer' THEN 'Rejected: Post-Offer'
        ELSE 'Unknown'
      END AS outcome_detail
    FROM Application app
    JOIN Applicant a ON app.applicant_id = a.applicant_id
    JOIN Job_Listing jl ON app.listing_id = jl.listing_id
    JOIN Company c ON jl.company_id = c.company_id
    ORDER BY app.applied_date DESC
  `);
}

// --- ANALYTICS (all 8 queries) ---
async function getAnalytics() {
  const db = await getDb();

  const query1 = await db.all(`
    SELECT c.company_name, jl.title AS listing_title, a.username, s.skill_name, ask.proficiency_level, app.offer_salary
    FROM Application app
    JOIN Applicant a ON app.applicant_id = a.applicant_id
    JOIN Job_Listing jl ON app.listing_id = jl.listing_id
    JOIN Company c ON jl.company_id = c.company_id
    JOIN Applicant_Skill ask ON a.applicant_id = ask.applicant_id
    JOIN Skill s ON ask.skill_id = s.skill_id
    WHERE app.status = 'accepted'
    ORDER BY c.company_name, a.username, s.skill_name
  `);

  const query2 = await db.all(`
    SELECT a.username, a.university, a.gpa, a.degree_level
    FROM Applicant a
    WHERE a.gpa > (
      SELECT AVG(a2.gpa) FROM Applicant a2
      JOIN Application app ON a2.applicant_id = app.applicant_id
      WHERE app.status = 'accepted'
    )
    ORDER BY a.gpa DESC
  `);

  const query3 = await db.all(`
    SELECT c.company_name,
      COUNT(app.application_id) AS total_applications,
      SUM(CASE WHEN app.status = 'accepted' THEN 1 ELSE 0 END) AS total_accepted,
      ROUND(100.0 * SUM(CASE WHEN app.status = 'accepted' THEN 1 ELSE 0 END) / COUNT(app.application_id), 1) AS acceptance_rate_pct
    FROM Application app
    JOIN Job_Listing jl ON app.listing_id = jl.listing_id
    JOIN Company c ON jl.company_id = c.company_id
    GROUP BY c.company_id, c.company_name
    HAVING acceptance_rate_pct < 50.0
    ORDER BY acceptance_rate_pct ASC
  `);

  const query4 = await db.all(`
    SELECT DISTINCT a.username, a.university, a.degree_level, a.gpa, a.years_of_experience
    FROM Applicant a
    LEFT JOIN Applicant_Skill ask ON a.applicant_id = ask.applicant_id
    LEFT JOIN Skill s ON ask.skill_id = s.skill_id
    WHERE (a.degree_level IN ('MS', 'PhD') AND a.years_of_experience >= 2)
    OR (a.degree_level = 'BS' AND a.gpa > 3.8 AND s.skill_name = 'Python' AND ask.proficiency_level = 'advanced')
    ORDER BY a.degree_level, a.gpa DESC
  `);

  const query5 = await db.all(`
    SELECT c.company_name, jl.title, a.username, app.offer_salary,
      RANK() OVER (PARTITION BY c.company_id ORDER BY app.offer_salary DESC) AS salary_rank
    FROM Application app
    JOIN Applicant a ON app.applicant_id = a.applicant_id
    JOIN Job_Listing jl ON app.listing_id = jl.listing_id
    JOIN Company c ON jl.company_id = c.company_id
    WHERE app.status = 'accepted' AND app.offer_salary IS NOT NULL
    ORDER BY c.company_name, salary_rank
  `);

  const query6 = await db.all(`
    SELECT a.username, c.company_name, jl.title, app.status,
      CASE
        WHEN app.status = 'accepted' THEN 'Offer Received'
        WHEN app.status = 'withdrawn' THEN 'Self-Withdrawn'
        WHEN app.status = 'applied' THEN 'In Progress'
        WHEN app.rejection_stage = 'application' THEN 'Rejected: Resume Screen'
        WHEN app.rejection_stage = 'OA' THEN 'Rejected: Online Assessment'
        WHEN app.rejection_stage = 'phoneScreen' THEN 'Rejected: Phone Screen'
        WHEN app.rejection_stage = 'interview' THEN 'Rejected: Final Interview'
        WHEN app.rejection_stage = 'offer' THEN 'Rejected: Post-Offer'
        ELSE 'Unknown'
      END AS outcome_detail
    FROM Application app
    JOIN Applicant a ON app.applicant_id = a.applicant_id
    JOIN Job_Listing jl ON app.listing_id = jl.listing_id
    JOIN Company c ON jl.company_id = c.company_id
    ORDER BY a.username, c.company_name
  `);

  const query7 = await db.all(`
    WITH RECURSIVE salary_brackets(bracket_low, bracket_high) AS (
      SELECT 0, 25000
      UNION ALL
      SELECT bracket_low + 25000, bracket_high + 25000
      FROM salary_brackets
      WHERE bracket_high < (SELECT MAX(offer_salary) FROM Application WHERE status = 'accepted')
    ),
    accepted_offers AS (
      SELECT app.offer_salary, a.username, c.company_name
      FROM Application app
      JOIN Applicant a ON app.applicant_id = a.applicant_id
      JOIN Job_Listing jl ON app.listing_id = jl.listing_id
      JOIN Company c ON jl.company_id = c.company_id
      WHERE app.status = 'accepted' AND app.offer_salary IS NOT NULL
    )
    SELECT sb.bracket_low || ' - ' || sb.bracket_high AS salary_range,
      COUNT(ao.offer_salary) AS num_offers,
      COALESCE(GROUP_CONCAT(ao.username || ' (' || ao.company_name || ')'), 'None') AS applicants
    FROM salary_brackets sb
    LEFT JOIN accepted_offers ao ON ao.offer_salary >= sb.bracket_low AND ao.offer_salary <= sb.bracket_high
    GROUP BY sb.bracket_low, sb.bracket_high
    HAVING num_offers > 0
    ORDER BY sb.bracket_low
  `);

  const query8 = await db.all(`
    SELECT s.skill_name, s.skill_type,
      (SELECT COUNT(DISTINCT app.applicant_id) FROM Application app
       JOIN Applicant_Skill ask2 ON app.applicant_id = ask2.applicant_id
       WHERE ask2.skill_id = s.skill_id AND app.status = 'accepted') AS accepted_with_skill,
      (SELECT COUNT(DISTINCT app.applicant_id) FROM Application app
       JOIN Applicant_Skill ask2 ON app.applicant_id = ask2.applicant_id
       WHERE ask2.skill_id = s.skill_id AND app.status = 'rejected') AS rejected_with_skill,
      (SELECT COUNT(DISTINCT ask2.applicant_id) FROM Applicant_Skill ask2
       WHERE ask2.skill_id = s.skill_id) AS total_applicants_with_skill
    FROM Skill s
    ORDER BY accepted_with_skill DESC
  `);

  return { query1, query2, query3, query4, query5, query6, query7, query8 };
}

// --- HOMEPAGE STATS ---
async function getHomepageStats() {
  const db = await getDb();
  
  const totalListings = await db.get(`
    SELECT COUNT(*) as count FROM Job_Listing
  `);
  
  const totalApplicants = await db.get(`
    SELECT COUNT(*) as count FROM Applicant
  `);
  
  const totalApplications = await db.get(`
    SELECT COUNT(*) as count FROM Application
  `);
  
  const acceptedOffers = await db.get(`
    SELECT COUNT(*) as count FROM Application WHERE status = 'accepted'
  `);
  
  return {
    totalListings: totalListings.count,
    totalApplicants: totalApplicants.count,
    totalApplications: totalApplications.count,
    acceptedOffers: acceptedOffers.count
  };
}

module.exports = { getListings, getListingById, getApplicants, getApplicantById, getApplications, getAnalytics, getHomepageStats };
