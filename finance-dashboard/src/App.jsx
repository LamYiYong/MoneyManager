import { useEffect, useState } from "react";
import {
  getMonthlySummary,
  getCategoryBreakdown,
  getSpendingTrend,
} from "./api/analytics";

import CategoryPie from "./components/CategoryPie";
import SpendingTrend from "./components/SpendingTrend";

export default function App() {
  const [categories, setCategories] = useState([]);
  const [trend, setTrend] = useState([]);

useEffect(() => {
  getCategoryBreakdown(2026, 1).then((res) => {
    console.log("RAW category response:", res.data);
    setCategories(res.data.categories);
  }).catch(err => {
    console.error("Category API error:", err);
  });

  getSpendingTrend(7).then((res) => {
    console.log("RAW trend response:", res.data);
    setTrend(res.data.trend);
  }).catch(err => {
    console.error("Trend API error:", err);
  });
}, []);



  return (
    <div style={{ padding: 20 }}>
      <h1>📊 Finance Dashboard</h1>

      <h2>Category Breakdown</h2>
      <CategoryPie data={categories} />

      <h2>Spending Trend (Last 7 Days)</h2>
      <SpendingTrend data={trend} />
    </div>
  );
}
