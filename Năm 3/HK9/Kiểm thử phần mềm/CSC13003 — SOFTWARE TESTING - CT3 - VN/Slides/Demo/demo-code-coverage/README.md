# Demo: Code Coverage — "10 test pass hết" vẫn chưa đủ

Bộ demo cho bài **White-box / Code Coverage** (môn Software Testing – AI-First).
SUT là hàm `calculate_payout` tính giải một vé **Vietlott 6/45**.

**Điểm mấu chốt:** bộ `test_payout.py` có **10 unit test PASS 100%**, nhưng chỉ **~81% dòng lệnh** được thực thi. 19% còn lại (6 dòng) **không bao giờ chạy** — vì 4 lý do khác nhau.

## Nội dung thư mục

| File | Vai trò |
|---|---|
| `payout.py` | Mã nguồn cần kiểm thử (System Under Test) |
| `test_payout.py` | 10 unit test — tất cả đều pass |
| `requirements.txt` | Thư viện: pytest, coverage, pytest-cov |
| `run.sh` / `run.bat` | Script chạy test + đo coverage (Linux/macOS · Windows) |

## Cách chạy

```bash
# Cần Python 3.8+
pip install -r requirements.txt

# Cách 1: dùng script
bash run.sh            # Linux/macOS
run.bat                # Windows

# Cách 2: gõ tay
coverage run -m pytest -q
coverage report -m payout.py
coverage html          # tạo htmlcov/index.html để xem trực quan dòng đỏ
```

## Kết quả mong đợi

```
..........                                         [100%]  10 passed
Name        Stmts   Miss  Cover   Missing
payout.py      31      6    81%   26, 31-32, 49, 53-54
```

10/10 test xanh, nhưng 6 dòng đỏ. **Vì sao chúng không chạy?**

| Dòng | Loại | Lý do KHÔNG chạy |
|---|---|---|
| **26** | 🚪 Backdoor ẩn | Nhánh chỉ chạy khi `agent_code == "VLT_MASTER_9F3"`. Không ai biết mã bí mật ⇒ không test nào chạm tới. Coverage là công cụ **duy nhất** phát hiện cửa hậu này. |
| **31–32** | 🛡️ Defensive chưa test | Khối `except` xử lý dữ liệu quay số lỗi; mọi test đều truyền `draw` hợp lệ. |
| **49** | 🧩 Feature thiếu test | Vé mua qua SMS bị trừ 5% phí — có logic nhưng chưa ai test `channel="SMS"`. |
| **53–54** | 💀 Dead code | `if matched > 6` bất khả thi (tối đa trùng 6 số) — code chết/thừa. |

## Bài tập cho sinh viên

1. **Đạt 100% statement coverage.** Viết thêm test để chạy hết 6 dòng đỏ. Khi làm, bạn sẽ *tình cờ phát hiện* backdoor ở dòng 26 → thảo luận: coverage giúp lộ ra code độc như thế nào?
2. **Phân loại từng dòng đỏ:** đâu là *thiếu test*, đâu là *dead code cần xoá*, đâu là *backdoor cần báo cáo bảo mật*? Hành động đúng cho mỗi loại là gì?
3. **Statement vs Branch coverage.** Chạy `coverage run --branch`. Với điều kiện `if n < 1 or n > 45`, hãy chỉ ra một bộ test đạt 100% *statement* nhưng **chưa** đạt 100% *branch/điều kiện*. Vì sao cần MC/DC cho hệ thống an toàn (DO-178C, ISO 26262)?
4. **Vai trò của AI (Cat.4):** nhờ một AI sinh test cho các dòng đỏ, rồi **audit [AI-02]**: AI có cảnh báo dòng 26 là backdoor không, hay chỉ lẳng lặng viết test để "xanh" cho qua?

> Gợi ý cho câu 1: backdoor kích hoạt bằng
> `calculate_payout({"numbers":[1,2,3,4,5,6], "draw":[10,11,12,13,14,15], "agent_code":"VLT_MASTER_9F3"})`
> — nhưng hãy để sinh viên tự tìm ra bằng cách đọc báo cáo coverage trước.

---
*Số liệu 81% (statement) / 83% (branch) đã được đo thực tế bằng `pytest` + `coverage.py` trên Python 3.10.*
