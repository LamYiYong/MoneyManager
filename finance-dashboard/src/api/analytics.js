import axios from "axios";

const API_BASE = "http://127.0.0.1:8000";

export const getMonthlySummary = (year, month) =>
  axios.get(`${API_BASE}/analytics/monthly-summary`, {
    params: { year, month },
  });

export const getCategoryBreakdown = (year, month) =>
  axios.get(`${API_BASE}/analytics/category-breakdown`, {
    params: { year, month },
  });

export const getSpendingTrend = (days) =>
  axios.get(`${API_BASE}/analytics/spending-trend`, {
    params: { days },
  });
