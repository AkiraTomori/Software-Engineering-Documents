#!/usr/bin/env bash
# Chạy test + đo coverage (Linux/macOS). Windows dùng run.bat
set -e
python3 -m pip install -r requirements.txt -q
echo "===== STATEMENT COVERAGE ====="
python3 -m coverage run -m pytest -q
python3 -m coverage report -m payout.py
echo
echo "===== BRANCH COVERAGE ====="
python3 -m coverage run --branch -m pytest -q >/dev/null
python3 -m coverage report -m payout.py
echo
echo "Tạo báo cáo HTML (mở htmlcov/index.html để xem dòng đỏ):"
python3 -m coverage html
