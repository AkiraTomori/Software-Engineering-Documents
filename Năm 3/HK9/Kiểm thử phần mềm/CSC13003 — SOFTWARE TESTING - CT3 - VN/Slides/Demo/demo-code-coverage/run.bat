@echo off
REM Chay test + do coverage tren Windows
python -m pip install -r requirements.txt -q
echo ===== STATEMENT COVERAGE =====
python -m coverage run -m pytest -q
python -m coverage report -m payout.py
echo.
echo ===== BRANCH COVERAGE =====
python -m coverage run --branch -m pytest -q
python -m coverage report -m payout.py
echo.
echo Tao bao cao HTML (mo htmlcov\index.html):
python -m coverage html
