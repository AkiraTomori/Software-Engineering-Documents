function orderTotal(items, coupon) {
  const sub = items.reduce((s, i) => s + i.price * i.qty, 0);
  const d = coupon && coupon.pct >= 10 ? coupon.pct / 100 : 0;
  const total = sub * (1 - d);
  return total >= 500 ? total : total + 30; // free shipping over 500
}
module.exports = { orderTotal };
