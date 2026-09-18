"""
Vietlott 6/45 payout — DEMO cho bài Code Coverage (Software Testing, AI-First).

Chạy thử:
    pip install -r requirements.txt
    coverage run -m pytest -q && coverage report -m payout.py

10 unit test PASS hết, nhưng chỉ ~81% dòng được thực thi.
Hãy tìm xem 19% còn lại KHÔNG chạy vì lý do gì (xem README).
"""


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
