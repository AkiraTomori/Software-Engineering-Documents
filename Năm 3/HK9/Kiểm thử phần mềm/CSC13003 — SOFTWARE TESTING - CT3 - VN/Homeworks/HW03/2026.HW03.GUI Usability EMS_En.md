# HW03 – GUI & Usability Testing on EMS (Event Management System)

## 1. General Information

| **Exercise ID** | **HW03-AI (EMS edition)** |
| --- | --- |
| **Duration** | 10 hours |
| **Deadline** | Please refer to the submission link on Moodle |
| **Form** | **Group assignment** — one shared checklist per group; each member owns one scenario individually |
| **Group size** | 3–4 students (four scenarios A–D; a four-member group covers all four) |
| **Submission** | Moodle (group folder + one report per member) |
| **Lecturers & TAs** | Dr. Lam Quang Vu / Dr. Tran Duy Hoang / MSc. Tran Thi Bich Hanh / MSc. Truong Phuoc Loc / MSc. Ho Tuan Thanh |
| **Contact** | lqvu@fit.hcmus.edu.vn / tdhoang@fit.hcmus.edu.vn / ttbhanh@fit.hcmus.edu.vn / tploc@fit.hcmus.edu.vn / hthanh@fit.hcmus.edu.vn |
| **AI Policy** | Open — a declaration and an attached AI Audit Report are **mandatory** |
| **Required Bloom-AI Level** | G9.3 (Analyse) → G9.4 (Collaborate with AI for exploratory testing) |

## 2. Guiding Principles

These principles define how you are expected to work throughout the series of assignments in this course. Read them carefully before you begin, as your submission will be evaluated against them.

- **AI-First strategy.** You are required to apply AI to the testing techniques covered in class. However, this does not mean issuing a single, generic prompt such as *"generate a GUI checklist and find usability problems in this app."* Instead, you must guide the AI through every step of the technique as it was taught, using the AI as a disciplined assistant rather than a black box.
- **Human review.** Every result produced by the AI must be carefully reviewed by you, the student. You are fully responsible for the correctness of these results. You are expected to make any necessary corrections and refinements — submitting the raw AI output without review is not acceptable.
- **AI Audit Report.** The entire process of using AI must be recorded in a complete log. You are encouraged to build Agent Skills that can automatically perform these activities on similar exercises. If you do **not** use AI, you must still declare this explicitly.
- **Documentation.** The whole working process must be documented in a text-based format such as Markdown.
- **Quality over completion.** Your work will be graded not merely on whether it is complete, but on the quantity and quality of the deliverables: the shared checklist, the per-screen execution, the usability report, the cross-platform matrix, bug reports, screenshots, and referenced links.

## 3. Learning Outcomes

By completing this assignment, you will be able to:

- Design, as a team, a reusable GUI checklist grounded in recognised UI heuristics (Nielsen, Norman, Shneiderman) and the EMS interface, and document the reference sources and AI prompts behind it.
- Apply that shared checklist to the concrete screens of an assigned functional scenario and report defects.
- Design a user-testing scenario, run it with 5 real users on the pages you own, and analyse the results into a Usability Report.
- Perform cross-browser and cross-platform testing on the EMS web frontend across multiple operating systems, browsers, and device classes.
- Demonstrate Bloom-AI competencies at levels **G9.3 (Analyse)** and **G9.4 (Collaborate with AI for exploratory testing)**.

## 4. System Under Test (SUT)

**SUT:** **EMS — Event Management System, Faculty of Information Technology.** A web application for creating, publishing, and running academic events, with administration, participant registration, check-in, support requests, analytics, and system configuration.

**Web (SUT):** https://promoter-starboard-prude.ngrok-free.dev/

**Admin account (for admin scenarios A and C, and the admin side of D):** `admin@gmail.com` / `Admin@123` — the account must hold the **ADMIN** role on EMS.

**User accounts (for the user side of scenarios B and D):** register your own **student / lecturer / guest** account through the EMS sign-up flow. Do not share a single account across the group for the user-side scenarios — each member needs their own so their actions are distinguishable.

> The application is served through an ngrok tunnel and its data may be reset periodically. Take your evidence (screenshots, recordings) as you go; do not assume a state you created earlier will still be there next session.

The EMS features are organised into the following pools, which map onto the four scenarios in §5:

- **Pool A — Event administration.** Dashboard KPIs (Total Events, Total Check-ins, Attendance Rate, Total Users); Events list; Add/Edit Event (thumbnail 4:3 + banner 24:9 upload, Rich-Text content, date/time validation); registration configuration (student/lecturer/guest toggles, Max Slots, Waitlist, additional roles); Draft / Publish / Preview / Important Update / Delete; Participants & Reviews approval; Check-in.
- **Pool B — Participant experience.** Public home with the featured-event carousel; category browsing and search; event detail; registration form (role selection, waitlist); My Registrations and the barcode/QR ticket; post-event star reviews.
- **Pool C — User administration.** Users list (Avatar+Name, Role, Member Code, Active, Audit columns); Assign Role; Block / Unblock; Reset Password; Export to Excel; audit log.
- **Pool D — Support requests.** User side: create a support request (category, content, image attachment), My Requests list and detail with the official response. Admin side: Support Requests list (Pending / Resolved tabs, search by member code or category), request detail with image lightbox, internal note, and official response.

Beyond the functional pools above, this homework focuses on the **user interface**. The interface concerns are organised into four **interface aspects (IA)** — used as the coverage dimensions of the shared checklist:

- **IA-01: General UI standards** (layout, alignment, typography, colour, consistency, i18n EN/VI, empty/loading states).
- **IA-02: Forms** (labels, validation, error placement, required-field handling, uploads, rich-text editor).
- **IA-03: Navigation** (menus, breadcrumbs, tabs, sidebar, drag-and-drop reorder, back/return actions, deep links).
- **IA-04: Feedback / state** (toasts, badges, confirmation dialogs, progress bars, status colours, real-time updates).

## 5. Scope Selection

This homework is done as a **group** with an **individual core**.

- **Group deliverable (shared):** the group designs **one** GUI checklist that every member will use (Task 1, Part A). It must cover all four interface aspects IA-01…IA-04.
- **Individual deliverable:** each member chooses **one** of the four scenarios below and works it end to end (Task 1 Part B, Task 2, Task 3).

**Scenarios (each member picks exactly one):**

- **Scenario A — Admin creates and manages events.** Function group: the event lifecycle on the admin side.
- **Scenario B — User registers to attend an event.** Function group: public discovery and participant registration.
- **Scenario C — Admin manages users.** Function group: user administration.
- **Scenario D — User requests Support and Admin resolves it.** Function group: the support-request lifecycle across both the user and admin sides.

For your chosen scenario, **list at least three (3) screens** that belong to the function group and test each of them with the group checklist. Suggested screens (you may choose others in the same group, but you must justify the choice):

- **Scenario A (choose ≥ 3):** (A1) Events list with status filters and notification dots; (A2) Add/Edit Event form — image upload + Rich-Text + date/time validation; (A3) Registration & Roles configuration panel — Max Slots / Waitlist / additional role; (A4) Participants & Reviews approval — status colours, progress bar, Export; (A5) Check-in tab — scan-state handling and real-time log.
- **Scenario B (choose ≥ 3):** (B1) Home / events listing — featured carousel, categories, search/filter; (B2) Event detail page — banner, schedule, register button, waitlist notice; (B3) Registration form — role selection, additional role, confirmation; (B4) My Registrations / ticket — status and barcode/QR; (B5) Post-event review — 1–5 star rating.
- **Scenario C (choose ≥ 3):** (C1) Users list — search, role/active filters, columns; (C2) Assign Role / edit user; (C3) Block-Unblock and Reset-Password dialogs — confirmation + audit; (C4) Export to Excel — column completeness and download feedback.
- **Scenario D (choose ≥ 3):** (D1) User — create support request form with image attachment; (D2) User — My Requests list and detail with the response; (D3) Admin — Support Requests list, Pending/Resolved tabs, search; (D4) Admin — request detail — image lightbox, internal note, official response.

**No-duplication rule.** Within a group, no two members may own the same scenario **and** the same set of screens. Where a group has more than four members and a scenario is shared, the members sharing it must choose **different** screens so their coverage does not overlap.

## 6. Requirements

For each of the following tasks, document your process in the report and attach the required evidence. Tasks 1B, 2, and 3 all operate on the **same three (or more) screens** of your chosen scenario.

### Task 1 — GUI Checklist

**Part A — Shared checklist (group deliverable).**

- As a group, **design one GUI checklist of more than 40 items** that together cover all four interface aspects — **general UI standards (IA-01)**, **forms (IA-02)**, **navigation (IA-03)**, and **feedback / state (IA-04)**. Review the course lectures on GUI checklists (Nielsen's 10 heuristics, Norman's 6 principles, Shneiderman's 8 golden rules, and the per-widget checklists) before you begin.
- Ground the checklist in **reference sources**. Use an AI tool to generate an initial set, then critically review it and add items of your own. **Submit, as group artefacts:** (1) the checklist itself, (2) the list of reference sources you drew on (books, articles, standards, the course slides), and (3) the **AI prompts** you used to generate and refine it.
- For each item you added beyond the AI output, **explain why the AI missed it** — e.g. the quality of your prompt, the limits of the model, or a characteristic specific to the EMS interface. Items AI tends to overlook include accessibility, right-to-left (RTL) layout, dark mode, keyboard navigation, and EN/VI internationalisation, but these are only examples.

**Part B — Execution on your scenario (individual deliverable).**

- **Execute the shared checklist** against each of your **≥ 3 chosen screens**, marking every item **Passed** or **Failed** per screen. Add a **Notes** column that records, for each **Failed** item, the reason it failed. Attach screenshots for the **Failed** items only.
- Report all discovered bugs both in your report and via the submission channel in §7. For each bug include: screen, steps to reproduce, expected vs actual, severity, and a screenshot.

### Task 2 — User Testing with 5 Real Users → Usability Report

Instead of judging usability yourself, **design a user-testing scenario, run it with five (5) real users** on the ≥ 3 screens of your package, then **collect and analyse the results** into a **Usability Report** on those web pages. Review the course lectures on usability testing before you begin.

**Phase 1 — Design & prepare**

- **Write the task scenario.** Turn your package into a realistic, goal-oriented task the user must complete on your screens — give a goal, **not** step-by-step clicks (e.g. Scenario B: *"register for an upcoming workshop and show me your check-in QR"*; Scenario D: *"report that a registration failed and follow it until it is resolved"*).
- **Define what you will measure.** At minimum: **task success** (completed / partial / failed), **time on task**, **error / hesitation count**, and a post-task **SUS** or **UEQ-S** score. Add a short set of open-ended probe questions covering clarity, error recovery, speed, and trust.
- **Recruit five (5) real participants** matching the target user profile (students, lecturers, or event-goers as fits your scenario), with verifiable contact details (Zalo / email / phone, middle four digits masked). Participants **must be people outside this class**.
- **Run a pilot** with one extra person to catch an unclear task or broken flow, and refine before the real sessions.

**Phase 2 — Run the 5 sessions (one per participant)**

- **Set the stage.** Tell the participant you are testing the *product*, not them; ask them to **think aloud**.
- **Observe neutrally.** No leading hints; step in only if they are completely stuck. Record the screen (and audio, with consent) and take **structured notes** on friction points, errors, hesitations, and verbalised frustration.
- **Close each session.** Have the participant complete the **SUS / UEQ-S** scale, then ask your probe questions.

**Phase 3 — Collect, analyse & report**

- **Score** the SUS / UEQ-S across the five participants and tabulate the task metrics (success rate, mean time, errors).
- **Analyse the usability of the related web pages:** group similar pain points, separate isolated bugs from systemic design issues, and rank findings by **severity (0–4)**.
- **Report.** Produce a **Usability Report** with: the scenario, the participant table (5 people, masked), the metrics table, the ranked findings with a screenshot each, and a prioritised list of concrete recommendations. Log genuine bugs through the channel in §7.
- The TA may randomly call **two (2)** participants to verify them. Impersonation results in **0 points for Task 2**.

### Task 3 — Cross-Browser / Cross-Platform

Test how your **three functions/screens** render and behave across a broad compatibility matrix. Review the course lectures on compatibility testing (the emulator/simulator/real-device distinction and the BrowserStack "rungs") before you begin.

- **Coverage required — per screen, build a compatibility matrix covering:**
    - **3 operating systems** — e.g. Windows, macOS, and Android **or** iOS.
    - **5 browsers** — e.g. Chrome, Firefox, Safari, Edge, and Opera (or Samsung Internet on mobile).
    - **3 device classes** — desktop, tablet, and phone.
- Your matrix does not need every one of the 3×5×3 combinations, but it **must exercise every operating system at least once, every browser at least once, and every device class at least once, for each of the three screens.** State clearly which cells you covered and mark each **Pass / Fail**.
- Use a **BrowserStack** or **LambdaTest** trial (strongly preferred). If your trial has expired, substitute another cloud tool (Sauce Labs, CrossBrowserTesting) or real physical devices, provided each screenshot clearly shows the **browser / OS / device** name alongside the EMS URL. You are responsible for obtaining your own trial access.
- Capture a screenshot for **every cell** in your matrix; each screenshot must overlay your username in the form **MSSV@....edu.vn** (your student-ID email). Attach screenshots for any rendering/layout **Fail** with a short note on the defect (overflow, overlap, broken layout, unreadable text, non-responsive control, etc.).

## 7. Bug & Usability Findings — Submission Channel

Every defect and every usability improvement you propose across Tasks 1–3 must be reported **twice**:

1. **Submit each finding to the Google Form:** https://forms.gle/CJQFQCAXcsDbXDMM9 — use your **student-ID email** (`MSSV@....edu.vn`, or the address the form requests) so your submissions are attributable to you.
2. **Aggregate all of your findings into one file** — the **Bug & Usability Findings Log** — and include it in your submission. The log must consolidate everything you sent to the form, with at least these columns: *ID · Scenario/Screen · Type (Bug | Usability) · Description · Steps/Heuristic · Severity · Suggested fix · Screenshot ref · Form-submission timestamp.*

The aggregated file and the form submissions must be consistent; the TA may cross-check counts.

## 8. Agent Skill

- You are encouraged to build **Agent Skills** that apply the GUI-checklist execution, the heuristic usability evaluation, and the compatibility-matrix runs, so they can be reused on additional EMS screens and flows.
- Submit the skills together with demonstration videos (YouTube links) that show, end to end, how you used the skills on a complete screen or flow.

## 9. Allowed Tools and Bloom-AI Level

You may use the following tools, and you must declare them in your AI Audit Report:

- Any AI tool of your choice (e.g., ChatGPT, Claude, Gemini, Copilot, Cursor).
- A BrowserStack or LambdaTest trial (or another cloud cross-browser tool / real devices).
- Google Forms (the findings channel in §7).

The required Bloom-AI level for this homework is **G9.3 (Analyse)** and **G9.4 (Collaborate)**.

## 10. AI Audit Report (Mandatory Appendix)

Attach the AI Audit Report as an appendix. Use the content of the given AI Templates if needed.

- If you did not use AI, declare: *"I do not use any AI help in this exercise."*
- If you did use AI, declare: *"I use AI tools for the following tasks,"* and include, for each interaction: the name of the AI tool, the date and time, your prompt, and the AI output.

To simplify this, you are encouraged to create a skill or rule that extracts the information above automatically after an AI session. The group's checklist prompts (§6, Task 1 Part A) belong here as well.

## 11. AI Critique (200–300 words, Mandatory)

Write a paragraph of 200–300 words critiquing the AI. Where did the AI get something wrong, biased, or incomplete? Why did it fail to catch the issue? What principle have you learned about collaborating with AI during this assignment? Use the content of the given AI Templates if needed.

## 12. Anti-AI-Cheat Constraints

This homework relies on genuine runs against the live EMS and real cross-platform captures. The following must not be AI-generated or fabricated, and the TAs verify them during grading:

- The **per-screen execution evidence** — screenshots of the actual EMS screens you tested, showing real state.
- The **cross-platform screenshots**, which must show your student-ID email overlay (**MSSV@....edu.vn**) alongside the EMS URL and the browser/OS/device identity.
- The **five (5) user-testing participants** (name plus Zalo / phone, middle four digits masked) and their raw session data. The TA may randomly call up to two of them; impersonation voids Task 2.

## 13. Git Commit Log

- Create a new Git commit for each step of the testing procedure (for example: checklist design, checklist execution per screen, bug logging, the heuristic evaluation, and each cross-platform run).
- Provide the Git commit log in a text-based file format.

## 14. Oral Defense

A randomly selected **30% of students** may be invited to a 5–7-minute oral defense during the week following the deadline, to explain how they completed this homework.

## 15. Submission Regulations

- **Filename format:** `<StudentID>_HW03_AI_GUIUsability_EMS_<SelfAssessedGrade>.zip`
    - *SelfAssessedGrade:* a 3-digit number in the range [000, 100].
    - *Example:* `25127001_HW03_AI_GUIUsability_EMS_090.zip`
- **Group-level artefacts (submitted once per group; each member also keeps a copy):**
    - The **shared GUI checklist** (Excel or Markdown, > 40 items across IA-01…IA-04).
    - The **reference-sources list** and the **AI prompts** used to build the checklist.
- **Individual `.zip` — required contents:**
    - Main report (Markdown + PDF): the chosen scenario, the ≥ 3 screens and why, the checklist-execution results per screen, the Usability Report, and the cross-platform report.
    - **User-testing evidence:** the task scenario, the table of 5 participants (masked contacts), per-session observation notes, the SUS / UEQ-S responses, the metrics table, and screen recordings where available.
    - **Bug & Usability Findings Log** (the aggregated §7 file), consistent with your Google-Form submissions.
    - Cross-browser / cross-platform screenshots (with the Student-ID overlay).
    - AI Critique and AI Audit Report (Markdown + PDF).
    - Git commit log (text file).
    - Agent Skills + demo-video links.
    - A `README.md` with the self-assessment table (below) and a test summary: scenario chosen; screens tested; checklist items designed / executed / passed / failed; number of bugs; number of user-testing participants (5) and usability issues by severity; compatibility cells covered; demo videos.
    - Any other supporting materials.
- Submit to Moodle. For the deadline, refer to the submission link.

## 16. Assessment Template

| **No.** | **Criteria** | **Grade** | **Self-Assessed Grade** |
| --- | --- | --- | --- |
| **1a** | Task 1A — Shared checklist (> 40 items, IA-01…IA-04) + reference sources + AI prompts *(group)* | 15 |  |
| **1b** | Task 1B — Checklist execution on ≥ 3 screens + bug reports *(individual)* | 15 |  |
| **2** | Task 2 — User testing with 5 real users (scenario + 5 sessions + analysis → Usability Report) | 25 |  |
| **3** | Task 3 — Cross-Browser / Cross-Platform matrix (3 OS × 5 browsers × 3 device classes) | 25 |  |
| **4** | Bug & Usability Findings submission (Google Form) + aggregated log | 10 |  |
| **5** | Agent Skills | 10 |  |
|  | **Total** | **100** |  |

## 17. References

- ISTQB Foundation Level Syllabus (latest edition).
- Nielsen, J. *10 Usability Heuristics for User Interface Design.*
- Norman, D. *The Design of Everyday Things* (6 principles).
- Shneiderman, B. *Eight Golden Rules of Interface Design.*
- Course slides: *GUI + Usability + Compatibility Testing (AI-First, Combined).*
- BrowserStack / LambdaTest documentation — cross-browser & cross-platform testing.
- Hardman, P. (2025). *A Post-AI Learning Taxonomy.*

## 18. Other Regulations

- Late submission is **not permitted**.
- Missing any required document results in **0 points**.
- Copying between students — **including prompts** — results in a **grade of 0 for both parties**. The group's shared checklist is expected to be identical within the group; everything else (screen selection, execution, usability, cross-platform, findings) must be your own.
