-- ============================================================
-- Recruit.log: Test Data Population
-- Authors: Ganesh Batchu & Quinn Lambert
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- COMPANIES (12 rows)
-- ============================================================
INSERT INTO Company (company_name, industry, company_size, headquarters_location, website_url) VALUES
('Google',          'Technology',       'enterprise',   'Mountain View, CA',    'https://google.com'),
('Meta',            'Technology',       'enterprise',   'Menlo Park, CA',       'https://meta.com'),
('Stripe',          'Fintech',          'large',        'San Francisco, CA',    'https://stripe.com'),
('Figma',           'Design Tech',      'mid',          'San Francisco, CA',    'https://figma.com'),
('Palantir',        'Data Analytics',   'large',        'Denver, CO',           'https://palantir.com'),
('Jane Street',     'Finance',          'mid',          'New York, NY',         'https://janestreet.com'),
('Datadog',         'Cloud/DevOps',     'large',        'New York, NY',         'https://datadoghq.com'),
('Ramp',            'Fintech',          'mid',          'New York, NY',         'https://ramp.com'),
('Anthropic',       'AI',               'mid',          'San Francisco, CA',    'https://anthropic.com'),
('Scale AI',        'AI',               'mid',          'San Francisco, CA',    'https://scale.com'),
('Citadel',         'Finance',          'large',        'Chicago, IL',          'https://citadel.com'),
('Startup XYZ',     'SaaS',             'startup',      'Austin, TX',           'https://startupxyz.io');

-- ============================================================
-- SKILLS (15 rows)
-- ============================================================
INSERT INTO Skill (skill_name, skill_type) VALUES
('Python',          'language'),
('Java',            'language'),
('JavaScript',      'language'),
('TypeScript',      'language'),
('C++',             'language'),
('SQL',             'language'),
('React',           'framework'),
('Node.js',         'framework'),
('Django',          'framework'),
('Spring Boot',     'framework'),
('Docker',          'tool'),
('Git',             'tool'),
('AWS',             'tool'),
('Machine Learning','concept'),
('System Design',   'concept');

-- ============================================================
-- JOB LISTINGS (14 rows)
-- ============================================================
INSERT INTO Job_Listing (company_id, title, role_type, location, posted_date, closing_date, is_active, salary_min, salary_max, description, experience_level, listing_type) VALUES
-- Internships (listing_ids 1-7)
(1,  'SWE Intern Summer 2026',           'internship',   'Mountain View, CA',    '2025-09-01', '2026-01-15', 1, 9500, 11000, 'Google SWE internship for BS/MS students', 'entry', 'internship'),
(2,  'Production Engineering Intern',    'internship',   'Menlo Park, CA',       '2025-09-15', '2026-02-01', 1, 9000, 10000, 'Meta production engineering intern role', 'entry', 'internship'),
(3,  'Backend Intern',                   'internship',   'San Francisco, CA',    '2025-10-01', '2026-03-01', 1, 8500, 9500,  'Stripe backend engineering internship',   'entry', 'internship'),
(4,  'Frontend Intern',                  'internship',   'San Francisco, CA',    '2025-10-15', '2026-02-15', 1, 8000, 9000,  'Figma frontend engineering intern',       'entry', 'internship'),
(5,  'Defense Tech Intern',              'internship',   'Denver, CO',           '2025-08-15', '2025-12-15', 0, 9000, 10500, 'Palantir forward deployed intern',        'entry', 'internship'),
(6,  'Trading Intern',                   'internship',   'New York, NY',         '2025-09-01', '2025-12-01', 0, 14000, 16000,'Jane Street quantitative trading intern', 'entry', 'internship'),
(7,  'Co-op Data Engineer',              'co-op',        'New York, NY',         '2025-10-01', '2026-04-01', 1, 8000, 9000,  'Datadog 6-month data engineering co-op',  'entry', 'internship'),
-- Full-time (listing_ids 8-14)
(1,  'SWE L3 New Grad',                  'full-time',    'Mountain View, CA',    '2025-08-01', '2026-03-01', 1, 150000, 185000, 'Google new grad SWE position',         'entry', 'full_time'),
(2,  'Production Engineer E3',           'full-time',    'Menlo Park, CA',       '2025-09-01', '2026-02-01', 1, 140000, 170000, 'Meta PE new grad role',                'entry', 'full_time'),
(8,  'Backend Engineer',                 'full-time',    'New York, NY',         '2025-10-01', NULL,         1, 135000, 165000, 'Ramp backend SWE mid-level',           'mid',   'full_time'),
(9,  'Research Engineer',                'full-time',    'San Francisco, CA',    '2025-09-15', NULL,         1, 180000, 250000, 'Anthropic AI research engineering',     'mid',   'full_time'),
(10, 'ML Engineer',                      'full-time',    'San Francisco, CA',    '2025-10-01', '2026-01-15', 1, 145000, 190000, 'Scale AI ML engineering role',          'mid',   'full_time'),
(11, 'Quantitative Researcher',          'full-time',    'Chicago, IL',          '2025-08-01', '2025-12-01', 0, 200000, 350000, 'Citadel quant research new grad',       'entry', 'full_time'),
(12, 'Full-Stack Engineer',              'full-time',    'Austin, TX',           '2025-11-01', NULL,         1, 90000,  120000, 'Startup XYZ early stage full-stack',    'entry', 'full_time');

-- ============================================================
-- INTERNSHIP subtypes (7 rows, matching listing_ids 1-7)
-- ============================================================
INSERT INTO Internship (listing_id, season, is_coop, duration) VALUES
(1, 'summer',   0, '12 weeks'),
(2, 'summer',   0, '12 weeks'),
(3, 'summer',   0, '12 weeks'),
(4, 'summer',   0, '10 weeks'),
(5, 'summer',   0, '12 weeks'),
(6, 'summer',   0, '10 weeks'),
(7, 'spring',   1, '26 weeks');

-- ============================================================
-- FULL_TIME_POSITION subtypes (7 rows, matching listing_ids 8-14)
-- ============================================================
INSERT INTO Full_Time_Position (listing_id, employment_type, signing_bonus, remote_policy) VALUES
(8,  'full-time', 30000,  'onsite'),
(9,  'full-time', 25000,  'hybrid'),
(10, 'full-time', 20000,  'hybrid'),
(11, 'full-time', 15000,  'onsite'),
(12, 'full-time', 40000,  'remote'),
(13, 'full-time', 100000, 'onsite'),
(14, 'full-time', 5000,   'remote');

-- ============================================================
-- APPLICANTS (15 rows)
-- ============================================================
INSERT INTO Applicant (email, username, university, gpa, graduation_year, years_of_experience, degree_level, is_anonymized) VALUES
('alice@neu.edu',       'alice_dev',        'Northeastern University',  3.85, 2026, 1, 'BS', 1),
('bob@mit.edu',         'bob_algo',         'MIT',                      3.92, 2026, 2, 'BS', 1),
('carol@stanford.edu',  'carol_ml',         'Stanford University',      3.78, 2025, 1, 'MS', 1),
('dave@gatech.edu',     'dave_sys',         'Georgia Tech',             3.65, 2026, 0, 'BS', 1),
('eve@berkeley.edu',    'eve_data',         'UC Berkeley',              3.91, 2025, 2, 'MS', 1),
('frank@cmu.edu',       'frank_sec',        'Carnegie Mellon',          3.70, 2026, 1, 'BS', 1),
('grace@umich.edu',     'grace_web',        'University of Michigan',   3.55, 2027, 0, 'BS', 1),
('henry@cornell.edu',   'henry_quant',      'Cornell University',       3.95, 2025, 2, 'MS', 1),
('iris@uiuc.edu',       'iris_cloud',       'UIUC',                     3.60, 2026, 1, 'BS', 1),
('jack@purdue.edu',     'jack_backend',     'Purdue University',        3.42, 2027, 0, 'BS', 1),
('kate@columbia.edu',   'kate_ai',          'Columbia University',      3.88, 2025, 3, 'PhD', 1),
('leo@uw.edu',          'leo_devops',       'University of Washington', 3.72, 2026, 1, 'BS', 1),
('mia@usc.edu',         'mia_front',        'USC',                      3.50, 2026, 0, 'BS', 1),
('noah@rice.edu',       'noah_full',        'Rice University',          3.68, 2026, 1, 'BS', 1),
('olivia@neu.edu',      'olivia_ds',        'Northeastern University',  3.80, 2026, 2, 'MS', 0);

-- ============================================================
-- APPLICANT_SKILL (40 rows — diverse skill distributions)
-- ============================================================
INSERT INTO Applicant_Skill (applicant_id, skill_id, proficiency_level, years_used) VALUES
-- Alice (1): Python, Java, React, Git
(1, 1, 'advanced', 3),     (1, 2, 'intermediate', 2),  (1, 7, 'intermediate', 1),  (1, 12, 'advanced', 3),
-- Bob (2): Python, C++, ML, System Design
(2, 1, 'advanced', 4),     (2, 5, 'advanced', 3),      (2, 14, 'advanced', 2),     (2, 15, 'intermediate', 1),
-- Carol (3): Python, JS, React, Django, ML
(3, 1, 'advanced', 3),     (3, 3, 'intermediate', 2),  (3, 7, 'advanced', 2),      (3, 9, 'intermediate', 1), (3, 14, 'intermediate', 1),
-- Dave (4): Java, Spring Boot, SQL, Docker
(4, 2, 'intermediate', 2), (4, 10, 'beginner', 1),     (4, 6, 'intermediate', 2),  (4, 11, 'beginner', 0),
-- Eve (5): Python, SQL, AWS, ML, Docker
(5, 1, 'advanced', 4),     (5, 6, 'advanced', 3),      (5, 13, 'intermediate', 2), (5, 14, 'advanced', 3),    (5, 11, 'intermediate', 1),
-- Frank (6): C++, Python, System Design
(6, 5, 'intermediate', 2), (6, 1, 'intermediate', 2),  (6, 15, 'beginner', 1),
-- Grace (7): JS, TypeScript, React, Node.js
(7, 3, 'intermediate', 1), (7, 4, 'beginner', 1),      (7, 7, 'beginner', 1),      (7, 8, 'beginner', 0),
-- Henry (8): Python, C++, ML, System Design, SQL
(8, 1, 'advanced', 4),     (8, 5, 'advanced', 4),      (8, 14, 'advanced', 3),     (8, 15, 'advanced', 2),    (8, 6, 'intermediate', 2),
-- Iris (9): Python, Docker, AWS, Git
(9, 1, 'intermediate', 2), (9, 11, 'intermediate', 1),  (9, 13, 'intermediate', 1), (9, 12, 'advanced', 2),
-- Jack (10): Java, SQL, Git
(10, 2, 'beginner', 1),    (10, 6, 'beginner', 1),     (10, 12, 'intermediate', 1);

-- ============================================================
-- LISTING_REQUIREMENT (25 rows)
-- ============================================================
INSERT INTO Listing_Requirement (listing_id, skill_id, is_required, desired_proficiency) VALUES
-- Google SWE Intern (1): Python, Java, System Design
(1, 1, 1, 'intermediate'),  (1, 2, 0, 'intermediate'),  (1, 15, 0, 'beginner'),
-- Meta PE Intern (2): Python, C++, Docker
(2, 1, 1, 'intermediate'),  (2, 5, 1, 'intermediate'),  (2, 11, 0, 'beginner'),
-- Stripe Backend Intern (3): Python, Java, SQL
(3, 1, 1, 'intermediate'),  (3, 2, 0, 'intermediate'),  (3, 6, 1, 'intermediate'),
-- Figma Frontend Intern (4): JS, TypeScript, React
(4, 3, 1, 'intermediate'),  (4, 4, 1, 'beginner'),      (4, 7, 1, 'intermediate'),
-- Palantir Intern (5): Java, Python, System Design
(5, 2, 1, 'intermediate'),  (5, 1, 1, 'intermediate'),  (5, 15, 0, 'beginner'),
-- Jane Street Trading Intern (6): C++, Python, ML
(6, 5, 1, 'advanced'),      (6, 1, 1, 'advanced'),      (6, 14, 0, 'intermediate'),
-- Datadog Co-op (7): Python, SQL, Docker, AWS
(7, 1, 1, 'intermediate'),  (7, 6, 1, 'intermediate'),  (7, 11, 0, 'beginner'),    (7, 13, 0, 'beginner'),
-- Google New Grad (8): Python, System Design
(8, 1, 1, 'advanced'),      (8, 15, 1, 'intermediate'),
-- Anthropic Research (11): Python, ML
(11, 1, 1, 'advanced'),     (11, 14, 1, 'advanced');

-- ============================================================
-- APPLICATIONS (30 rows — mix of outcomes)
-- ============================================================
INSERT INTO Application (applicant_id, listing_id, applied_date, status, rejection_stage, offer_salary, notes) VALUES
-- Alice (1) applies to: Google intern, Stripe intern, Figma intern, Datadog co-op, Google new grad
(1, 1, '2025-09-15', 'accepted',  NULL,           10500,  'Passed all rounds'),
(1, 3, '2025-10-10', 'rejected',  'interview',    NULL,   'Final round rejection'),
(1, 4, '2025-10-20', 'rejected',  'OA',           NULL,   'Failed online assessment'),
(1, 7, '2025-10-15', 'withdrawn', NULL,           NULL,   'Withdrew after Google offer'),
(1, 8, '2026-01-05', 'applied',   NULL,           NULL,   'Pending review'),

-- Bob (2) applies to: Google intern, Jane Street intern, Palantir intern, Google new grad, Citadel FT
(2, 1, '2025-09-10', 'accepted',  NULL,           11000,  'Strong performance'),
(2, 6, '2025-09-20', 'accepted',  NULL,           15500,  'Top candidate'),
(2, 5, '2025-09-05', 'rejected',  'interview',    NULL,   'System design round'),
(2, 8, '2025-12-01', 'accepted',  NULL,           175000, 'Return offer from internship'),
(2, 13, '2025-09-01', 'rejected', 'OA',           NULL,   'Quant assessment cutoff'),

-- Carol (3) applies to: Figma intern, Stripe intern, Anthropic, Scale AI
(3, 4, '2025-10-20', 'accepted',  NULL,           8500,   'Great culture fit'),
(3, 3, '2025-10-15', 'rejected',  'application',  NULL,   'Resume screen rejection'),
(3, 11, '2025-10-01', 'accepted', NULL,           210000, 'Research role match'),
(3, 12, '2025-10-15', 'rejected', 'interview',    NULL,   'ML depth insufficient'),

-- Dave (4) applies to: Stripe intern, Palantir intern, Datadog co-op
(4, 3, '2025-10-20', 'rejected',  'OA',           NULL,   'SQL portion failed'),
(4, 5, '2025-09-01', 'rejected',  'application',  NULL,   'Resume filtered'),
(4, 7, '2025-10-15', 'accepted',  NULL,           8500,   'Strong SQL skills'),

-- Eve (5) applies to: Google new grad, Anthropic, Scale AI, Ramp
(5, 8, '2025-09-01', 'rejected',  'interview',    NULL,   'System design round'),
(5, 11, '2025-10-01', 'accepted', NULL,           230000, 'Strong ML background'),
(5, 12, '2025-10-20', 'accepted', NULL,           175000, 'Good fit'),
(5, 10, '2025-10-25', 'accepted', NULL,           155000, 'Backend strength'),

-- Frank (6): Palantir intern, Google intern
(6, 5, '2025-08-20', 'accepted',  NULL,           10000,  'Forward deployed match'),
(6, 1, '2025-09-20', 'rejected',  'phoneScreen',  NULL,   'Phone screen cutoff'),

-- Grace (7): Figma intern
(7, 4, '2025-11-01', 'applied',   NULL,           NULL,   'Awaiting OA'),

-- Henry (8): Jane Street intern, Citadel FT, Anthropic
(8, 6, '2025-09-05', 'accepted',  NULL,           16000,  'Exceptional quant skills'),
(8, 13, '2025-08-15', 'accepted', NULL,           300000, 'Top performer'),
(8, 11, '2025-09-20', 'rejected', 'interview',    NULL,   'Chose quant over research'),

-- Iris (9): Datadog co-op, Google intern
(9, 7, '2025-10-10', 'rejected',  'interview',    NULL,   'Docker knowledge gaps'),
(9, 1, '2025-09-25', 'rejected',  'OA',           NULL,   'Algorithm section'),

-- Jack (10): Stripe intern, Startup XYZ FT
(10, 3, '2025-11-01', 'applied',  NULL,           NULL,   'Pending'),
(10, 14, '2025-11-15', 'accepted', NULL,          95000,  'Early team member');

-- ============================================================
-- ADVISORS (5 rows)
-- ============================================================
INSERT INTO Advisor (name, email, role, institution, department) VALUES
('Dr. Sarah Chen',      'schen@neu.edu',        'faculty',                      'Northeastern University',  'Computer Science'),
('Marcus Williams',     'mwilliams@mit.edu',    'careerCenter',                 'MIT',                      'Career Services'),
('Dr. Priya Patel',     'ppatel@stanford.edu',  'faculty',                      'Stanford University',      'Computer Science'),
('James Rodriguez',     'jrod@berkeley.edu',    'institutionalResearcher',      'UC Berkeley',              'Institutional Research'),
('Linda Nakamura',      'lnakamura@cmu.edu',    'consultant',                   'Carnegie Mellon',          'Career Services');

-- ============================================================
-- ADVISOR_BOOKMARK (10 rows)
-- ============================================================
INSERT INTO Advisor_Bookmark (advisor_id, listing_id, last_viewed, is_bookmarked) VALUES
(1, 1, '2025-11-01', 1),   -- Dr. Chen bookmarks Google intern
(1, 3, '2025-11-05', 1),   -- Dr. Chen bookmarks Stripe intern
(1, 7, '2025-11-10', 0),   -- Dr. Chen viewed Datadog co-op
(2, 1, '2025-10-15', 1),   -- Marcus bookmarks Google intern
(2, 6, '2025-10-20', 1),   -- Marcus bookmarks Jane Street intern
(2, 8, '2025-11-01', 1),   -- Marcus bookmarks Google new grad
(3, 11, '2025-10-10', 1),  -- Dr. Patel bookmarks Anthropic
(3, 12, '2025-10-15', 0),  -- Dr. Patel viewed Scale AI
(4, 1, '2025-11-20', 0),   -- James viewed Google intern
(4, 8, '2025-11-20', 1);   -- James bookmarks Google new grad