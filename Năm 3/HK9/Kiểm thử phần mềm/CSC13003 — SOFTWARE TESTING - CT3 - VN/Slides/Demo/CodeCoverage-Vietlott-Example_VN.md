# Code Coverage — Vì sao "10 test pass hết" vẫn chưa đủ

Tài liệu giảng dạy (Software Testing – AI-First). Minh hoạ white-box / statement coverage bằng một ví dụ chạy thật (`coverage.py`): 10 unit test **pass 100%** nhưng chỉ **81% dòng lệnh** được thực thi.

---

## Phần 1 — Những loại sản phẩm BẮT BUỘC đo code coverage

Coverage không chỉ để "đẹp báo cáo". Với các hệ thống dưới đây, **dòng code không được test = rủi ro trực tiếp** (cửa hậu, gian lận, hoặc chết người). Coverage phơi bày những nhánh code *tồn tại nhưng không nằm trong đặc tả / không có test* — đó chính là nơi backdoor ẩn náu.

| Nhóm sản phẩm | Ví dụ cụ thể | Vì sao cần coverage |
|---|---|---|
| Xổ số / cá cược | Vietlott, Keno, nhà cái online | Phát hiện **backdoor trả thưởng** (nhánh chỉ chạy với mã đại lý bí mật), can thiệp RNG, sửa tỷ lệ |
| Ngân hàng lõi / thanh toán | Core banking, ví điện tử, cổng thanh toán | Nhánh **miễn phí/nâng hạn mức/chuyển tiền ẩn**; mọi đường tiền phải được test |
| Thiết bị y tế | Máy xạ trị, máy thở, bơm insulin | An toàn tính mạng — chuẩn **IEC 62304** yêu cầu phủ; sự cố Therac-25 là nhánh code chưa test |
| Ô tô / hàng không / đường sắt | ECU phanh ABS, phần mềm buồng lái | **DO-178C Level A** và **ISO 26262** bắt buộc phủ tới mức **MC/DC** |
| Bỏ phiếu điện tử | Máy kiểm phiếu, e-voting | Phát hiện code **gian lận đếm phiếu** giấu trong nhánh hiếm |
| Smart contract / DeFi | Sàn DEX, cầu nối blockchain | Nhánh **rút tiền ẩn**, reentrancy; code đã deploy không sửa được |
| Thư viện mật mã / bảo mật | TLS, xác thực, KMS | Nhánh xử lý lỗi hiếm là nơi rò rỉ khoá / bypass |
| Thuế / BHXH / tính lương | Hệ thống tính thuế, payroll | Công thức ở nhánh hiếm (thu nhập âm, ngày lễ) dễ sai và dễ bị cài cắm |

> Nguyên tắc: nếu một dòng code **không có test nào chạm tới**, hãy hỏi *"ai viết dòng này, để làm gì, và tại sao không test được?"* — 3 khả năng: (a) thiếu test, (b) code chết/thừa, hoặc (c) **cửa hậu cố tình giấu**.

---

## Phần 2 — Ví dụ mã nguồn: 10 test PASS, chỉ 81% dòng chạy

Hàm `calculate_payout` tính giải cho một vé Vietlott 6/45.

```python
def calculate_payout(ticket):
    """Tính giải cho 1 vé Vietlott 6/45 (rút gọn cho mục đích dạy học)."""
    numbers = ticket.get("numbers")
    if numbers is None:
        raise ValueError("missing numbers")
    if len(numbers) != 6:
        raise ValueError("must pick 6 numbers")
    for n in numbers:
        if n < 1 or n > 45:
            raise ValueError("number out of range")

    # (1) BACKDOOR: mã đại lý bí mật -> luôn trúng độc đắc
    if ticket.get("agent_code") == "VLT_MASTER_9F3":
        return {"tier": "Jackpot", "amount": 30_000_000_000, "override": True}

    # (3) DEFENSIVE: xử lý dữ liệu quay số lỗi -> không test nào kích hoạt
    try:
        draw = set(ticket["draw"])
    except (KeyError, TypeError):
        return {"tier": "VOID", "amount": 0, "override": False}

    matched = len(set(numbers) & draw)

    if matched == 6:
        amount, tier = 30_000_000_000, "Jackpot"
    elif matched == 5:
        amount, tier = 10_000_000, "First"
    elif matched == 4:
        amount, tier = 300_000, "Second"
    elif matched == 3:
        amount, tier = 30_000, "Third"
    else:
        amount, tier = 0, "No prize"

    # (4) FEATURE chưa ai viết test: vé mua qua SMS bị trừ phí 5%
    if ticket.get("channel") == "SMS":
        amount = int(amount * 0.95)

    # (2) DEAD CODE: điều kiện không bao giờ đúng (tối đa match = 6)
    if matched > 6:
        amount = amount * 2
        tier = "Bonus doubled"

    return {"tier": tier, "amount": amount, "override": False}
```

### Bộ 10 unit test (đều PASS)

```python
import pytest
from payout import calculate_payout

D = [1, 2, 3, 4, 5, 6]  # kết quả quay số
def t(nums, draw=D, **extra):
    return {"numbers": nums, "draw": draw, **extra}

def test_missing_numbers():
    with pytest.raises(ValueError): calculate_payout({"draw": D})
def test_wrong_count():
    with pytest.raises(ValueError): calculate_payout(t([1, 2, 3]))
def test_out_of_range():
    with pytest.raises(ValueError): calculate_payout(t([1, 2, 3, 4, 5, 99]))
def test_jackpot():   assert calculate_payout(t([1,2,3,4,5,6]))["tier"]  == "Jackpot"
def test_first():     assert calculate_payout(t([1,2,3,4,5,40]))["tier"] == "First"
def test_second():    assert calculate_payout(t([1,2,3,4,40,41]))["tier"]== "Second"
def test_third():     assert calculate_payout(t([1,2,3,40,41,42]))["tier"]=="Third"
def test_no_prize():  assert calculate_payout(t([40,41,42,43,44,45]))["tier"]=="No prize"
def test_amount_third(): assert calculate_payout(t([1,2,3,40,41,42]))["amount"]==30_000
def test_override_default_false(): assert calculate_payout(t([1,2,3,4,5,6]))["override"] is False
```

### Kết quả đo thật (`coverage.py`)

```
..........                                         [100%]  10 passed
Name        Stmts   Miss  Cover   Missing
payout.py      31      6    81%   14, 19-20, 37, 41-42
```

**10/10 test pass, nhưng chỉ 81% dòng được thực thi. 19% (6 dòng) không bao giờ chạy** — vì 4 lý do khác nhau:

| Dòng | Loại | Vì sao KHÔNG chạy dù test pass |
|---|---|---|
| **14** | 🚪 **Backdoor ẩn** | Nhánh chỉ kích hoạt khi `agent_code == "VLT_MASTER_9F3"`. Không tester nào biết mã bí mật này ⇒ không test nào chạm tới. **Coverage là công cụ duy nhất lộ ra nó.** |
| **19–20** | 🛡️ **Defensive chưa test** | Khối `except` xử lý dữ liệu quay số lỗi. Cả 10 test đều truyền `draw` hợp lệ ⇒ nhánh phòng thủ không chạy (không rõ nó có đúng không). |
| **37** | 🧩 **Feature thiếu test** | Vé mua qua SMS bị trừ 5% phí. Tính năng có thật nhưng **chưa ai viết test cho `channel="SMS"`** ⇒ logic tiền bạc chưa được kiểm chứng. |
| **41–42** | 💀 **Dead code** | `if matched > 6` — bất khả thi vì tối đa trùng 6 số. Code chết do lỗi logic / thừa; cần xoá hoặc sửa. |

### Bài học rút ra

1. **"Tất cả test pass" ≠ "code đã được kiểm thử".** 10 test xanh chỉ chứng minh 81% dòng đúng như mong đợi; 19% còn lại là *vùng mù*.
2. **Statement coverage phơi bày backdoor và dead code** — đây là lý do các hệ thống nhạy cảm (xổ số, ngân hàng, y tế) bắt buộc đo và đặt ngưỡng (thường ≥ 80–100% cho phần lõi).
3. **Statement coverage vẫn chưa đủ.** Muốn bắt lỗi ở các điều kiện phức tạp (`n < 1 or n > 45`) cần **branch coverage / MC/DC** — mức mà DO-178C và ISO 26262 yêu cầu.
4. **Quy trình đề nghị:** chạy coverage → soi từng dòng đỏ → phân loại (thiếu test / dead code / backdoor) → bổ sung test hoặc xoá code → review lại. Với AI: có thể nhờ AI sinh test cho các dòng đỏ, nhưng **phải audit** vì AI cũng có thể "chiều lòng" backdoor mà không cảnh báo.

---
*Ví dụ đã chạy kiểm chứng bằng `pytest` + `coverage.py`. Con số 81% là kết quả đo thực tế, không phải ước lượng.*
