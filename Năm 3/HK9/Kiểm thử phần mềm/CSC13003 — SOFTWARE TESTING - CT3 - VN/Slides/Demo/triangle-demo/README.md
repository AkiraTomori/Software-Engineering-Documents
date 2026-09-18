# Demo: Triangle classifier — Code Coverage vs Mutation Testing

A minimal, runnable demo for the **Software Testing (AI-First)** course.
The SUT is `triangle(a, b, c)`, the classic triangle-type classifier.

**The point:** a suite of **5 tests reaches 100% statement AND 100% branch
coverage** — yet a mutation run of the *same code* scores only **4/6 (67%)**.
Two mutants survive. They are real test gaps. Coverage says "done"; mutation
says "you have not tested enough".

## Files

| File | Role |
|---|---|
| `triangle.py` | the SUT — classify Invalid / NotATriangle / Equilateral / Isosceles / Scalene |
| `test_triangle.py` | the **weak** suite — 5 tests, all pass, 100% statement & branch coverage |
| `test_triangle_strong.py` | the **strong** suite — adds boundary + each-clause tests → 100% mutation |
| `run_mutation.py` | a tiny self-contained mutation harness (6 mutants) |
| `requirements.txt` · `run.sh` / `run.bat` | deps and one-command runners |

## How to run

```bash
pip install -r requirements.txt
bash run.sh                 # Linux/macOS   (run.bat on Windows)

# or by hand:
coverage run --branch -m pytest -q test_triangle.py
coverage report -m triangle.py        # -> 100% statement, 100% branch
python run_mutation.py                # -> 4/6 (67%), 2 survivors
python run_mutation.py --strong       # -> 6/6 (100%)
```

## Expected result

```
triangle.py   10 stmts   0 miss   8 branch   0 partial   100%      <- coverage

Suite: WEAK (5 tests)
  M1  a+b <= c  ->  a+b < c     triangle-inequality boundary   SURVIVED
  M2  (a==b && b==c) -> ||      equilateral condition          KILLED
  M3  drop the 'a==c' clause    isosceles condition            SURVIVED
  M4  a <= 0  ->  a < 0         invalid guard boundary         KILLED
  M5  a + b  ->  a - b          arithmetic operator            KILLED
  M6  b == c  ->  b != c        equilateral condition          KILLED
Mutation score: 4/6 = 67%
```

## Why the two survivors slip past 100% coverage

| Mutant | Why the weak suite never catches it |
|---|---|
| **M1** `a+b <= c → a+b < c` | the suite has no test *at the boundary* `a+b == c`. Both `<=` and `<` give the same answer for `(1,2,9)`, so the mutant behaves identically on every weak-suite input. |
| **M3** drop the `a==c` clause | the suite's only isosceles case is `(2,2,3)` where `a==b`. No test makes **only** `a==c` true (e.g. `(5,4,5)`), so removing that clause changes nothing on the weak suite. |

Coverage is a **structural** measure — did the line/branch execute? Both
survivors *execute* the mutated line; the assertions just don't pin down a
value that would differ. Mutation is a **behavioural** measure — would a bug
here be caught?

## The fix (kills both survivors → 6/6)

Add tests that (a) hit the triangle-inequality **boundary** and (b) exercise
**each isosceles clause** independently — see `test_triangle_strong.py`:

```python
assert triangle(1, 2, 3) == "NotATriangle"   # boundary a+b == c   -> kills M1
assert triangle(5, 4, 5) == "Isosceles"       # a==c only           -> kills M3
assert triangle(2, 3, 3) == "Isosceles"       # b==c only
assert triangle(3, 2, 2) == "Isosceles"
```

Re-run: coverage is **still 100%** (it never dropped) but the mutation score
rises **67% → 100%**. Only the *tests* changed — that is the whole lesson.

## Exercises for students

1. **Reproduce the gap.** Run coverage (100%), then `run_mutation.py` (67%).
   Explain, in your own words, how a test can *run* a line without *checking* it.
2. **Kill the survivors yourself** *before* looking at the strong suite. Which
   input at the boundary kills M1? Which isosceles case kills M3?
3. **Add your own mutant** to `run_mutation.py` (e.g. `a==b → a!=b`). Does the
   strong suite kill it? If not, add the test that does.
4. **Coverage ceiling.** Both suites are at 100% coverage. Argue why "100%
   coverage" must never be reported as "fully tested".

---
*All numbers verified with `pytest` + `coverage.py` and the included mutation
harness on Python 3.10 — measured, not estimated.*
