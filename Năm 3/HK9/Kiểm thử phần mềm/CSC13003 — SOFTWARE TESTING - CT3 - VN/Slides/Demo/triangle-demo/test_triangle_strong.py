"""Strengthened suite: adds a boundary case and each-clause isosceles cases.
Same 100% coverage as the weak suite — but now kills every mutant (6/6 = 100%).
"""
from triangle import triangle


def test_weak_cases():
    assert triangle(2, 2, 2) == "Equilateral"
    assert triangle(2, 2, 3) == "Isosceles"
    assert triangle(3, 4, 5) == "Scalene"
    assert triangle(0, 1, 1) == "Invalid"


def test_inequality_boundary():          # kills M1: a+b<=c -> a+b<c
    assert triangle(1, 2, 3) == "NotATriangle"


def test_isosceles_each_clause():        # kills M3: dropped 'a==c' clause
    assert triangle(5, 4, 5) == "Isosceles"   # a==c only
    assert triangle(2, 3, 3) == "Isosceles"   # b==c only
    assert triangle(3, 2, 2) == "Isosceles"   # b==c (a first) — a!=b
