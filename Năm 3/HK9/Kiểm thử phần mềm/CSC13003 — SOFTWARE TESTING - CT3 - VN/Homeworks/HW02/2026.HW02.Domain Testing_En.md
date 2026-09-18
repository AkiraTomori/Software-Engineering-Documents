# HW02 – Domain Testing on EShop

## 1. General Information

| **Exercise ID** | **HW02-AI** |
| --- | --- |
| **Duration** | 10 hours |
| **Deadline** | Please refer to the submission link on Moodle |
| **Form** | Individual Assignment |
| **Submission** | Moodle (report) |
| **Lecturers & TAs** | Dr. Lam Quang Vu / Dr. Tran Duy Hoang / MSc. Tran Thi Bich Hanh / MSc. Truong Phuoc Loc / MSc. Ho Tuan Thanh |
| **Contact** | lqvu@fit.hcmus.edu.vn / tdhoang@fit.hcmus.edu.vn / ttbhanh@fit.hcmus.edu.vn / tploc@fit.hcmus.edu.vn / hthanh@fit.hcmus.edu.vn |
| **AI Policy** | Open — a declaration and an attached AI Audit Report are **mandatory** |
| **Required Bloom-AI Level** | G9.1 → G9.6, depending on the homework (see the *CLO Mapping*) |

## 2. Guiding Principles

These principles define how you are expected to work throughout the series of assignments in this course. Read them carefully before you begin, as your submission will be evaluated against them.

- **AI-First strategy.** You are required to apply AI to the testing techniques covered in class. However, this does not mean issuing a single, generic prompt such as *"generate test cases and find bugs in this feature."* Instead, you must guide the AI through every step of the testing technique as it was taught, using the AI as a disciplined assistant rather than a black box.
- **Human review.** Every result produced by the AI must be carefully reviewed by you, the student. You are fully responsible for the correctness of these results. You are expected to make any necessary corrections and refinements — submitting the raw AI output without review is not acceptable.
- **AI Audit Report.** The entire process of using AI must be recorded in a complete log. You are encouraged to build Agent Skills that can automatically perform these testing techniques on similar exercises. If you do **not** use AI, you must still declare this explicitly.
- **Documentation.** The whole working process must be documented in a text-based format such as Markdown.
- **Quality over completion.** Your work will be graded not merely on whether it is complete, but on the quantity and quality of the deliverables: the general reports, test case reports, bug reports, test summary reports, scripts, screenshots, videos, and referenced links.

## 3. Learning Outcomes

By completing this assignment, you will be able to:

- Apply Domain Testing and Boundary Value Analysis techniques to a real-world System Under Test.
- Demonstrate Bloom-AI competencies at levels **G9.2 (Apply)** and **G9.3 (Analyse)**.

## 4. System Under Test (SUT)

**SUT:** EShop — a Vietnamese e-commerce demo application designed for testing practice.

**Repository:** https://github.com/ttbhanh/eshop-sut

The application's features are organised into the following pools:

- **Pool A — Authentication, Categories, and Products**
    - FR-01: Account registration
    - FR-02: Login and account lockout
    - FR-03: Forgot password and password reset (two steps)
    - FR-04: Personal profile management
    - FR-05: Product listing and search
    - FR-06: Product detail view
- **Pool B — Shopping Cart and Checkout**
    - FR-07: Shopping cart
    - FR-08: Checkout
    - FR-09: Discount coupons
    - FR-10: Order state machine
    - FR-11: Order history view (user)
- **Pool C — Web Admin**
    - FR-12: Access control
    - FR-13: Dashboard
    - FR-14: Category management (CRUD)
    - FR-15: Product management (CRUD)
    - FR-16: Product import from CSV
    - FR-17: Coupon management (CRUD)
    - FR-18: Order management (admin)
    - FR-19: User management (admin)
- **Pool D — Mobile App**

## 5. Feature Selection

Within each group, every student must select **four (4) features — one from each pool** — and ensure that **no feature is duplicated** among the members of the group.

## 6. Requirements

For each of your selected features, complete the following tasks:

1. **Domain Testing.** With the support of AI tools, apply the domain testing technique to design a comprehensive set of test cases. You are encouraged to add more test cases where needed for thorough coverage. Provide a detailed, step-by-step explanation of how you applied the technique. Review the course lectures before you begin.
2. **Boundary Value Analysis.** Likewise, apply the boundary value analysis technique to design a comprehensive set of test cases, adding more as needed for thorough coverage. Provide a detailed, step-by-step explanation of how you applied the technique. Again, review the course lectures beforehand.
3. **AI gap analysis.** If your AI tools miss any test cases or bugs, you must report them. Explain *why* the AI missed them — for example, due to the quality of your input (prompt), the limitations of the AI tool itself, or the inherent complexity of the feature under test.
4. **Bug reporting.** Report all discovered bugs both in the Markdown report and on your group's GitHub Issues page. Remember to attach bug screenshots to each GitHub issue.

## 7. Agent Skill

- You are encouraged to build Agent Skills that apply the domain testing and boundary value analysis techniques, so that they can be reused on additional features in future testing tasks.
- Submit the skills together with demonstration videos (YouTube links) that show, end to end, how you used the skills on a complete feature.

## 8. Allowed Tools and Bloom-AI Level

You may use the following tools, and you must declare them in your AI Audit Report:

- Any AI tool of your choice (e.g., ChatGPT, Claude, Gemini, Copilot, Cursor).
- *(Optional)* AI test-generation tools (e.g., Diffblue) for cross-checking.

The required Bloom-AI level for this homework is **G9.2 (Apply)** and **G9.3 (Analyse)**.

## 9. AI Audit Report (Mandatory Appendix)

Attach the AI Audit Report as an appendix. Use the content of the given AI Templates if needed.

- If you did not use AI, declare: *"I do not use any AI help in this exercise."*
- If you did use AI, declare: *"I use AI tools for the following tasks,"* and include the following information for each interaction:
    - Name of the AI tool
    - Date and time
    - Your prompt
    - The AI output

To simplify this process, you are encouraged to create a skill or rule that extracts the information above automatically after an AI session.
## 10. AI Critique (200–300 words, Mandatory)

Write a paragraph of 200–300 words critiquing the AI. Address the following questions: Where did the AI get something wrong, biased, or incomplete? Why did it fail to catch the issue? What principle have you learned about collaborating with AI during this assignment?

Use the content of the given AI Templates if needed.

## 11. Anti-AI-Cheat Constraints

- None.

## 12. Git Commit Log

- Create a new Git commit for each step of the testing procedure of each feature.
- Provide the Git commit log in a text-based file format.

## 13. Oral Defense

A randomly selected **30% of students** may be invited to a 5–7-minute oral defense during the week following the deadline, to explain how they completed this homework.

## 14. Submission Regulations

- **Filename format:** `<StudentID>_HW02_AI_DomainTesting_<SelfAssessedGrade>.zip`
    - *SelfAssessedGrade:* a 3-digit number in the range [000, 100].
    - *Example:* `25127001_HW02_AI_DomainTesting_090.zip`
- **Required contents of the `.zip`:**
    - Main report (Markdown + PDF), including the Domain Testing report and the Boundary Value Analysis report.
    - Bug report, with screenshots of the bugs on the GitHub Issues page.
    - AI Critique and AI Audit Report (Markdown + PDF).
    - Git commit log (text file).
    - A `README.md` containing the self-assessment table (below) and a test summary report: number of features; number of test cases designed, executed, passed, failed, and not yet executed; number of bugs; and demo videos.
    - Any other supporting materials.
- Submit to Moodle. For the deadline, refer to the submission link.

## 15. Assessment Template

| **No.** | **Criteria** | **Grade** | **Self-Assessed Grade** |
| --- | --- | --- | --- |
| **1** | Feature A (Domain + Boundary) | 25 |  |
| **2** | Feature B (Domain + Boundary) | 25 |  |
| **3** | Feature C (Domain + Boundary) | 25 |  |
| **4** | Feature D (Mobile, Domain + Boundary) | 15 |  |
| **5** | Agent Skills | 10 |  |
|  | **Total** | **100** |  |

## 16. References

- ISTQB Foundation Level Syllabus (latest edition).
- Hardman, P. (2025). *A Post-AI Learning Taxonomy.*
- Fuster Rabella, M. (2025). *OECD Education Working Paper No. 338.*
- Anthropic (2025). *Building Reliable AI Test Agents* — engineering blog.
- DeepEval & Promptfoo documentation — LLM testing frameworks.

## 17. Other Regulations

- Late submission is **not permitted**.
- Missing any required document results in **0 points**.
- Copying between students — **including prompts** — results in a **grade of 0 for both parties**.
