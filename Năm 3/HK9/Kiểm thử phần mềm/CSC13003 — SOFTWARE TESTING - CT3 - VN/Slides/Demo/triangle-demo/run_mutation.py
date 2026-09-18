"""A tiny, self-contained mutation harness for triangle().

Injects 6 first-order mutants (one tiny edit each), runs the chosen test
suite against every mutant, and reports KILLED / SURVIVED + mutation score.

    python run_mutation.py            # weak suite  -> 4/6 (67%), 2 survivors
    python run_mutation.py --strong   # strong suite -> 6/6 (100%)

A mutant is KILLED if the suite's expected output differs from the mutant's
output on at least one test input.
"""
import sys

# --- the 6 mutants (each is the original with ONE tiny change) ---
def m1(a, b, c):   # M1  ROR boundary:  a+b <= c  ->  a+b < c
    if a <= 0 or b <= 0 or c <= 0: return "Invalid"
    if a + b < c or a + c <= b or b + c <= a: return "NotATriangle"
    if a == b and b == c: return "Equilateral"
    if a == b or b == c or a == c: return "Isosceles"
    return "Scalene"
def m2(a, b, c):   # M2  COR:  (a==b && b==c) -> (a==b || b==c)
    if a <= 0 or b <= 0 or c <= 0: return "Invalid"
    if a + b <= c or a + c <= b or b + c <= a: return "NotATriangle"
    if a == b or b == c: return "Equilateral"
    if a == b or b == c or a == c: return "Isosceles"
    return "Scalene"
def m3(a, b, c):   # M3  drop the 'a==c' clause of the isosceles test
    if a <= 0 or b <= 0 or c <= 0: return "Invalid"
    if a + b <= c or a + c <= b or b + c <= a: return "NotATriangle"
    if a == b and b == c: return "Equilateral"
    if a == b or b == c: return "Isosceles"
    return "Scalene"
def m4(a, b, c):   # M4  ROR:  a <= 0  ->  a < 0
    if a < 0 or b <= 0 or c <= 0: return "Invalid"
    if a + b <= c or a + c <= b or b + c <= a: return "NotATriangle"
    if a == b and b == c: return "Equilateral"
    if a == b or b == c or a == c: return "Isosceles"
    return "Scalene"
def m5(a, b, c):   # M5  AOR:  a + b  ->  a - b
    if a <= 0 or b <= 0 or c <= 0: return "Invalid"
    if a - b <= c or a + c <= b or b + c <= a: return "NotATriangle"
    if a == b and b == c: return "Equilateral"
    if a == b or b == c or a == c: return "Isosceles"
    return "Scalene"
def m6(a, b, c):   # M6  ROR:  b == c  ->  b != c  (equilateral test)
    if a <= 0 or b <= 0 or c <= 0: return "Invalid"
    if a + b <= c or a + c <= b or b + c <= a: return "NotATriangle"
    if a == b and b != c: return "Equilateral"
    if a == b or b == c or a == c: return "Isosceles"
    return "Scalene"

MUTANTS = [
    ("M1  a+b <= c  ->  a+b < c",  "triangle-inequality boundary", m1),
    ("M2  (a==b && b==c) -> ||",   "equilateral condition",        m2),
    ("M3  drop the 'a==c' clause", "isosceles condition",          m3),
    ("M4  a <= 0  ->  a < 0",      "invalid guard boundary",       m4),
    ("M5  a + b  ->  a - b",       "arithmetic operator",          m5),
    ("M6  b == c  ->  b != c",     "equilateral condition",        m6),
]

# --- test inputs (the ASSERTED expected value comes from the ORIGINAL) ---
from triangle import triangle

WEAK   = [(2,2,2),(2,2,3),(3,4,5),(1,2,9),(0,1,1)]
STRONG = WEAK + [(1,2,3),(5,4,5),(2,3,3),(3,2,2)]

def main():
    suite = STRONG if "--strong" in sys.argv else WEAK
    label = "STRONG" if "--strong" in sys.argv else "WEAK"
    expected = {(a,b,c): triangle(a,b,c) for (a,b,c) in suite}
    print(f"Suite: {label} ({len(suite)} tests)")
    killed = 0
    for name, where, mf in MUTANTS:
        die = any(mf(a,b,c) != expected[(a,b,c)] for (a,b,c) in suite)
        print(f"  {name:32} {where:30} {'KILLED' if die else 'SURVIVED'}")
        killed += die
    print(f"\nMutation score: {killed}/{len(MUTANTS)} = {round(100*killed/len(MUTANTS))}%")
    if killed < len(MUTANTS):
        print("Survivors are real test gaps — see README.md for the fix.")

if __name__ == "__main__":
    main()
