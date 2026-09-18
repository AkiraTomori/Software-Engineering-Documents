"""Weak suite: 5 tests, all PASS, 100% statement AND 100% branch coverage.

    coverage run --branch -m pytest -q
    coverage report -m triangle.py     ->  100%

But it never tests the triangle-inequality BOUNDARY (a+b == c) nor an
'a==c only' isosceles case — so two mutants survive (see run_mutation.py).
The strengthened suite that reaches 100% mutation is in test_triangle_strong.py.
"""
from triangle import triangle


def test_equilateral():
    assert triangle(2, 2, 2) == "Equilateral"


def test_isosceles():
    assert triangle(2, 2, 3) == "Isosceles"


def test_scalene():
    assert triangle(3, 4, 5) == "Scalene"


def test_not_a_triangle():
    assert triangle(1, 2, 9) == "NotATriangle"


def test_invalid():
    assert triangle(0, 1, 1) == "Invalid"
