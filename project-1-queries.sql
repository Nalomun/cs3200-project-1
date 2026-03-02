-- ============================================================
-- Recruit.log: SQL Data Definition Language (DDL)
-- SQLite3 Implementation
-- Authors: Ganesh Batchu & Quinn Lambert
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- Drop tables in reverse dependency order for clean re-runs
-- ============================================================
DROP TABLE IF EXISTS Advisor_Bookmark;
DROP TABLE IF EXISTS Listing_Requirement;
DROP TABLE IF EXISTS Applicant_Skill;
DROP TABLE IF EXISTS Application;
DROP TABLE IF EXISTS Internship;
DROP TABLE IF EXISTS Full_Time_Position;
DROP TABLE IF EXISTS Job_Listing;
DROP TABLE IF EXISTS Advisor;
DROP TABLE IF EXISTS Skill;
DROP TABLE IF EXISTS Applicant;
DROP TABLE IF EXISTS Company;

-- ============================================================
-- COMPANY
-- An employer that posts job and internship listings
-- ============================================================
CREATE TABLE Company (
    company_id          INTEGER     PRIMARY KEY AUTOINCREMENT,
    company_name        TEXT        NOT NULL UNIQUE,
    industry            TEXT        NOT NULL,
    company_size        TEXT        NOT NULL CHECK (company_size IN ('startup', 'mid', 'large', 'enterprise')),
    headquarters_location TEXT      NOT NULL,
    website_url         TEXT
);

-- ============================================================
-- JOB_LISTING
-- A specific internship or job posting from a company
-- ============================================================
CREATE TABLE Job_Listing (
    listing_id          INTEGER     PRIMARY KEY AUTOINCREMENT,
    company_id          INTEGER     NOT NULL,
    title               TEXT        NOT NULL,
    role_type           TEXT        NOT NULL CHECK (role_type IN ('internship', 'co-op', 'full-time', 'part-time')),
    location            TEXT        NOT NULL,
    posted_date         DATE        NOT NULL,
    closing_date        DATE,
    is_active           BOOLEAN     NOT NULL DEFAULT 1,
    salary_min          REAL,
    salary_max          REAL,
    description         TEXT,
    experience_level    TEXT        NOT NULL CHECK (experience_level IN ('entry', 'mid', 'senior')),
    listing_type        TEXT        NOT NULL CHECK (listing_type IN ('internship', 'full_time')),
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (salary_max IS NULL OR salary_min IS NULL OR salary_max >= salary_min)
);

-- ============================================================
-- INTERNSHIP (is-a Job_Listing)
-- Seasonal/co-op positions inheriting from Job_Listing
-- ============================================================
CREATE TABLE Internship (
    listing_id          INTEGER     PRIMARY KEY,
    season              TEXT        NOT NULL CHECK (season IN ('spring', 'summer', 'fall', 'winter')),
    is_coop             BOOLEAN     NOT NULL DEFAULT 0,
    duration            TEXT,
    FOREIGN KEY (listing_id) REFERENCES Job_Listing(listing_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- FULL_TIME_POSITION (is-a Job_Listing)
-- Full-time/contract roles inheriting from Job_Listing
-- ============================================================
CREATE TABLE Full_Time_Position (
    listing_id          INTEGER     PRIMARY KEY,
    employment_type     TEXT        NOT NULL CHECK (employment_type IN ('full-time', 'part-time', 'contract')),
    signing_bonus       REAL,
    remote_policy       TEXT        NOT NULL CHECK (remote_policy IN ('onsite', 'hybrid', 'remote')),
    FOREIGN KEY (listing_id) REFERENCES Job_Listing(listing_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- SKILL
-- A programming language, framework, or technical skill
-- ============================================================
CREATE TABLE Skill (
    skill_id            INTEGER     PRIMARY KEY AUTOINCREMENT,
    skill_name          TEXT        NOT NULL UNIQUE,
    skill_type          TEXT        NOT NULL CHECK (skill_type IN ('language', 'framework', 'tool', 'concept'))
);

-- ============================================================
-- APPLICANT
-- A CS student who submits applications and reports outcomes
-- ============================================================
CREATE TABLE Applicant (
    applicant_id        INTEGER     PRIMARY KEY AUTOINCREMENT,
    email               TEXT        NOT NULL UNIQUE,
    username            TEXT        NOT NULL UNIQUE,
    university          TEXT        NOT NULL,
    gpa                 REAL        CHECK (gpa >= 0.0 AND gpa <= 4.0),
    graduation_year     INTEGER     NOT NULL,
    years_of_experience INTEGER     NOT NULL DEFAULT 0,
    degree_level        TEXT        NOT NULL CHECK (degree_level IN ('BS', 'MS', 'PhD')),
    is_anonymized       BOOLEAN     NOT NULL DEFAULT 1
);

-- ============================================================
-- APPLICANT_SKILL (Association: Applicant <-> Skill)
-- Links applicants to their skills with proficiency detail
-- ============================================================
CREATE TABLE Applicant_Skill (
    applicant_id        INTEGER     NOT NULL,
    skill_id            INTEGER     NOT NULL,
    proficiency_level   TEXT        NOT NULL CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced')),
    years_used          INTEGER     DEFAULT 0,
    PRIMARY KEY (applicant_id, skill_id),
    FOREIGN KEY (applicant_id) REFERENCES Applicant(applicant_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- LISTING_REQUIREMENT (Association: Job_Listing <-> Skill)
-- Skills required or preferred for a specific job listing
-- ============================================================
CREATE TABLE Listing_Requirement (
    listing_id          INTEGER     NOT NULL,
    skill_id            INTEGER     NOT NULL,
    is_required         BOOLEAN     NOT NULL DEFAULT 1,
    desired_proficiency TEXT        NOT NULL CHECK (desired_proficiency IN ('beginner', 'intermediate', 'advanced')),
    PRIMARY KEY (listing_id, skill_id),
    FOREIGN KEY (listing_id) REFERENCES Job_Listing(listing_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- APPLICATION (Association: Applicant <-> Job_Listing)
-- An applicant's submission to a specific job listing
-- Constraint: One application per applicant per listing
-- ============================================================
CREATE TABLE Application (
    application_id      INTEGER     PRIMARY KEY AUTOINCREMENT,
    applicant_id        INTEGER     NOT NULL,
    listing_id          INTEGER     NOT NULL,
    applied_date        DATE        NOT NULL,
    status              TEXT        NOT NULL CHECK (status IN ('applied', 'rejected', 'accepted', 'withdrawn')),
    rejection_stage     TEXT        CHECK (rejection_stage IN ('application', 'OA', 'phoneScreen', 'interview', 'offer')),
    offer_salary        REAL,
    notes               TEXT,
    UNIQUE (applicant_id, listing_id),
    FOREIGN KEY (applicant_id) REFERENCES Applicant(applicant_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (listing_id) REFERENCES Job_Listing(listing_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- rejection_stage should only be set if status is 'rejected'
    CHECK (
        (status = 'rejected' AND rejection_stage IS NOT NULL) OR
        (status != 'rejected' AND rejection_stage IS NULL)
    ),
    -- offer_salary should only be set if status is 'accepted'
    CHECK (
        (status = 'accepted' AND offer_salary IS NOT NULL) OR
        (status != 'accepted' AND offer_salary IS NULL)
    )
);

-- ============================================================
-- ADVISOR
-- Faculty, career center staff, or institutional researcher
-- ============================================================
CREATE TABLE Advisor (
    advisor_id          INTEGER     PRIMARY KEY AUTOINCREMENT,
    name                TEXT        NOT NULL,
    email               TEXT        NOT NULL UNIQUE,
    role                TEXT        NOT NULL CHECK (role IN ('faculty', 'careerCenter', 'institutionalResearcher', 'consultant')),
    institution         TEXT        NOT NULL,
    department          TEXT
);

-- ============================================================
-- ADVISOR_BOOKMARK (Association: Advisor <-> Job_Listing)
-- Tracks which listings advisors have accessed/bookmarked
-- ============================================================
CREATE TABLE Advisor_Bookmark (
    advisor_id          INTEGER     NOT NULL,
    listing_id          INTEGER     NOT NULL,
    last_viewed         DATE        NOT NULL,
    is_bookmarked       BOOLEAN     NOT NULL DEFAULT 0,
    PRIMARY KEY (advisor_id, listing_id),
    FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (listing_id) REFERENCES Job_Listing(listing_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);