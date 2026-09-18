"""
Triangle classifier — DEMO for Code Coverage vs Mutation Testing
(Software Testing, AI-First).

Given three side lengths, return the triangle type.
Five well-chosen tests reach 100% statement AND 100% branch coverage
(measure it: coverage run --branch -m pytest) — yet a mutation run of the
same code scores only 4/6 (67%). Two mutants survive: the fixes are in
README.md. Coverage says "done"; mutation says "you have not tested enough".
"""


def triangle(a, b, c):
    if a <= 0 or b <= 0 or c <= 0:
        return "Invalid"
    if a + b <= c or a + c <= b or b + c <= a:
        return "NotATriangle"
    if a == b and b == c:
        return "Equilateral"
    if a == b or b == c or a == c:
        return "Isosceles"
    return "Scalene"
