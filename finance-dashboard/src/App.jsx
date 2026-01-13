import "./App.css";
import { useEffect, useState } from "react";
import {
  getCategoryBreakdown,
  getSpendingTrend,
} from "./api/analytics";

import CategoryPie from "./components/CategoryPie";
import SpendingTrend from "./components/SpendingTrend";

export default function App() {
  const [categories, setCategories] = useState([]);
  const [trend, setTrend] = useState([]);

 useEffect(() => {
  getCategoryBreakdown(2026, 1)
    .then((res) => {
      console.log("Category API response:", res.data);

      // 直接用 API 的 categories
      setCategories(res.data.categories);
    })
    .catch((err) => {
      console.error("Category API error:", err);
    });

  getSpendingTrend(7).then((res) => {
    setTrend(res.data.trend);
  });
}, []);



  return (
    <div className="dashboard">
      {/* Title */}
      <div className="dashboard-title">
        📊 <span>Finance Dashboard</span>
      </div>

      {/* Top Grid */}
      <div className="grid-2">
        <div className="card">
          <div className="card-title">Category Breakdown</div>
          <CategoryPie data={categories} />
        </div>

        <div className="card">
          <div className="card-title">Monthly Overview</div>
          <p style={{ color: "#666" }}>
            Total categories: {categories.length}
          </p>
        </div>
      </div>

      {/* Trend Card */}
      <div className="card">
        <div className="card-title">Spending Trend (Last 7 Days)</div>
        <SpendingTrend data={trend} />
      </div>
    </div>
  );
}