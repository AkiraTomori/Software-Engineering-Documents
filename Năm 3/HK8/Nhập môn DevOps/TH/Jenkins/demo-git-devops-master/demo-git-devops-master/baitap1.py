# Chương trình tính tổng và trung bình của dãy số
def calculate_sum_and_average(numbers):
    if not numbers:
        raise ValueError("Dãy số không được rỗng.")
    total = sum(numbers)
    average = total / len(numbers)
    return total, average

# Hàm nhập dãy số từ người dùng và xử lý lỗi
def get_numbers_from_user():
    while True:
        try:
            input_str = input("Nhập dãy số cách nhau bởi dấu cách: ")
            numbers = list(map(int, input_str.split()))
            if any(n <= 0 for n in numbers):
                raise ValueError("Tất cả các số phải là số nguyên dương.")
            return numbers
        except ValueError as e:
            print(f"Lỗi: {e}. Vui lòng nhập lại.")


# Main function
if __name__ == "__main__":
    numbers = get_numbers_from_user()
    try:
        total, average = calculate_sum_and_average(numbers)
        print(f"Tổng: {total}, Trung bình: {average}")
    except ValueError as e:
        print(f"Lỗi: {e}")


# pip install coverage
# pip install pytest-cov
# pytest --cov=main --cov-report=html
# pytest --cov=./ --cov-report=html -v
# coverage run -m unittest
# coverage report -m
# coverage html
