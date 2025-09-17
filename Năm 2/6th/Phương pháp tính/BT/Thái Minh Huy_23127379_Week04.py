import numpy as np
import matplotlib.pyplot as plt

T = np.array([0, 8, 16, 24, 32, 40], dtype=float)
O = np.array([14.621, 11.843, 9.870, 8.418, 7.305, 6.413], dtype=float)

# Nội suy đa thức bằng Lagrange, xây dựng đa thức Lagrange
def Lagrange_interpolation(x, X, Y):
    n = len(X)
    result = 0
    for i in range(n):
        term = Y[i]
        p = 1
        for j in range(n):
            if i != j:
                p *= (x - X[j]) / (X[i] - X[j])
        result += term * p

    return result

# Xây dựng các hệ số của đường cong bậc 3 theo Spline tự nhiên
def cubic_Spline_coefficients(X, Y):
    n = len(X)
    h = np.diff(X)
    
    alpha = np.zeros(n)
    for i in range(1, n - 1):
        alpha[i] = (3 / h[i]) * (Y[i + 1] - Y[i]) - (3 / h[i - 1]) * (Y[i] - Y[i - 1])

    A = np.zeros((n, n))
    A[0, 0] = 1
    A[-1, -1] = 1

    for i in range(1, n - 1):
        A[i, i - 1] = h[i - 1]
        A[i, i] = 2 * (h[i - 1] + h[i])
        A[i, i + 1] = h[i]
    c = np.linalg.solve(A, alpha)

    a = Y[:-1]
    b = np.zeros(n - 1)
    d = np.zeros(n - 1)
    for i in range(n - 1):
        b[i] = (Y[i + 1] - Y[i]) / h[i] - h[i] * (2 * c[i] + c[i + 1]) / 3
        d[i] = (c[i + 1] - c[i]) / (3 * h[i])

    return a, b, c[:-1], d

# Sau khi xây dựng, Tập giá trị có n ẩn x thì sẽ có n - 1 hàm g(x)
def cubic_spline_Interpolation(x, X, a, b, c, d):
    n = len(X)
    for i in range(n - 1):
        if X[i] <= x <= X[i + 1]:
            dx = x - X[i]
            return a[i] + b[i] * dx + c[i] * dx ** 2 + d[i] *dx ** 3
    return None

# Kiểm tra đáp án giữa giải tay và máy tính của câu 1 và câu 2
print("Exercise 1")
list_x = np.array([1.3, 1.7, 2.3, 2.7], dtype=float)
list_y = np.array([1.2, 8.6, 4.7, 6.6], dtype=float)
x_1 = 1.4
A, B, C, D = cubic_Spline_coefficients(list_x, list_y)
# Lấy các hệ số a, b, c, d và lưu thành một mảng array
result_x1 = cubic_spline_Interpolation(x_1, list_x, A, B, C, D)
print("Result of x =", x_1, "when use cubic Spline natural is y =", result_x1)
x_2 = 2.5
result_x2 = cubic_spline_Interpolation(x_2, list_x, A, B, C, D)
print("Result of x =", x_2, "when use cubic Spline natural is y =", result_x2)

print("\nExcercise 2")
set_x = np.array([1.8, 2.0, 2.2, 2.4, 2.6], dtype=float)
J_x = np.array([0.5815, 0.5767, 0.5560, 0.5202, 0.4708], dtype=float)
x_req = 2.1
j_result_1 = Lagrange_interpolation(x_req, set_x, J_x)
print("Result of x =", x_req, "when use Lagrange interpolation is J =", j_result_1)
jA, jB, jC, JD = cubic_Spline_coefficients(set_x, J_x)
j_result_2 = cubic_spline_Interpolation(x_req, set_x, jA, jB, jC, JD)
print("Result of x =", x_req, "when use Natural cubic Spline interpolation is J =", j_result_2)

# Bài tập chính của mã nguồn này
print("\nExercise 3")
x_value = 27
y_real_value = 7.986
print("Real Value:", y_real_value)
a_spline, b_spline, c_spline, d_spline = cubic_Spline_coefficients(T, O)

lagrange_result = Lagrange_interpolation(x_value, T, O)
print("Lagrange interpolation:", lagrange_result)
error_Lagrange = y_real_value - lagrange_result
print("Error in Lagrange Interpolation:", error_Lagrange)

spline_natural_result = cubic_spline_Interpolation(x_value, T, a_spline, b_spline, c_spline, d_spline)
print("\nSpline natural interpolation:", spline_natural_result)
error_natural_spline = y_real_value - spline_natural_result
print("Error in Natural Spline Interpolation:", error_natural_spline)

# Phác họa đồ thị
T_new = np.linspace(0, 40, 200)
O_lagrange = [Lagrange_interpolation(t, T, O) for t in T_new]
O_Spline = [cubic_spline_Interpolation(t, T, a_spline, b_spline, c_spline, d_spline) for t in T_new]

plt.plot(T, O, 'o', label = 'Original data')
plt.plot(T_new, O_lagrange, label = 'Lagrange')
plt.plot(T_new, O_Spline, label = 'Spline')
plt.plot(x_value, y_real_value, 'ro', label = f'({x_value}, {y_real_value})', markersize=8)
plt.xlabel('Temperature (°C)')
plt.ylabel('Oxygen (mg/L)')
plt.title('Interpolation oxygen depends on temperature')
plt.legend()
plt.grid(True)
plt.show()


