const express = require("express");
const router = express.Router();
const db = require("../db/dbConnector_Sqlite");

router.get("/", async (req, res) => {
  const stats = await db.getHomepageStats();
  res.render("index", { title: "Recruit.log", stats });
});

router.get("/listings", async (req, res) => {
  const listings = await db.getListings();
  res.render("listings", { title: "Job Listings", listings });
});

router.get("/listings/:id", async (req, res) => {
  const { listing, requirements, applications } = await db.getListingById(req.params.id);
  res.render("listing-detail", { title: listing.title, listing, requirements, applications });
});

router.get("/applicants", async (req, res) => {
  const applicants = await db.getApplicants();
  res.render("applicants", { title: "Applicants", applicants });
});

router.get("/applicants/:id", async (req, res) => {
  const { applicant, skills, applications } = await db.getApplicantById(req.params.id);
  res.render("applicant-detail", { title: applicant.username, applicant, skills, applications });
});

router.get("/applications", async (req, res) => {
  const applications = await db.getApplications();
  res.render("applications", { title: "All Applications", applications });
});

router.get("/analytics", async (req, res) => {
  const analytics = await db.getAnalytics();
  res.render("analytics", { title: "Analytics", ...analytics });
});

module.exports = router;
