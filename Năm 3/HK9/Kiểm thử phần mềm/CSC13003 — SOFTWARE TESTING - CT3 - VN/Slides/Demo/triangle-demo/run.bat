@echo off
pip install -r requirements.txt
echo ===== 1) COVERAGE (weak suite) =====
coverage run --branch -m pytest -q test_triangle.py
coverage report -m triangle.py
echo ===== 2) MUTATION (weak suite) =====
python run_mutation.py
echo ===== 3) MUTATION (strong suite) =====
python run_mutation.py --strong
