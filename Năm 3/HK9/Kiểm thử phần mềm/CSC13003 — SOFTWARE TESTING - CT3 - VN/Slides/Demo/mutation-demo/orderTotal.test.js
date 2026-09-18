const { orderTotal } = require('./orderTotal');
test('discount applies at pct=10 boundary', () => {
  expect(orderTotal([{ price: 100, qty: 2 }], { pct: 10 })).toBe(210); // 180 + 30 ship
});
test('free-shipping boundary at exactly 500', () => {
  expect(orderTotal([{ price: 250, qty: 2 }], null)).toBe(500);
});
test('no discount just below pct 10', () => {
  expect(orderTotal([{ price: 100, qty: 1 }], { pct: 9 })).toBe(130); // 100 + 30 ship
});
test('large order over 500 has no shipping', () => {
  expect(orderTotal([{ price: 300, qty: 2 }], null)).toBe(600);
});
