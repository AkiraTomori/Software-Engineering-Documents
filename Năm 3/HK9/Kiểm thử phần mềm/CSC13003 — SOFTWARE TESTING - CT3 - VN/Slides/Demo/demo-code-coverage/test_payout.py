"""10 unit test — TẤT CẢ ĐỀU PASS, nhưng chỉ phủ ~81% dòng của payout.py."""
import pytest
from payout import calculate_payout

D = [1, 2, 3, 4, 5, 6]  # kết quả quay số


def t(nums, draw=D, **extra):
    return {"numbers": nums, "draw": draw, **extra}


def test_missing_numbers():
    with pytest.raises(ValueError):
        calculate_payout({"draw": D})


def test_wrong_count():
    with pytest.raises(ValueError):
        calculate_payout(t([1, 2, 3]))


def test_out_of_range():
    with pytest.raises(ValueError):
        calculate_payout(t([1, 2, 3, 4, 5, 99]))


def test_jackpot():
    assert calculate_payout(t([1, 2, 3, 4, 5, 6]))["tier"] == "Jackpot"


def test_first():
    assert calculate_payout(t([1, 2, 3, 4, 5, 40]))["tier"] == "First"


def test_second():
    assert calculate_payout(t([1, 2, 3, 4, 40, 41]))["tier"] == "Second"


def test_third():
    assert calculate_payout(t([1, 2, 3, 40, 41, 42]))["tier"] == "Third"


def test_no_prize():
    assert calculate_payout(t([40, 41, 42, 43, 44, 45]))["tier"] == "No prize"


def test_amount_third():
    assert calculate_payout(t([1, 2, 3, 40, 41, 42]))["amount"] == 30_000


def test_override_default_false():
    assert calculate_payout(t([1, 2, 3, 4, 5, 6]))["override"] is False
