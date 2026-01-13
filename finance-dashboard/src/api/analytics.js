import axios from "axios";

const API_BASE = "http://127.0.0.1:8000";

export const getMonthlySummary = (year, month) =>
  axios.get(`${API_BASE}/analytics/monthly-summary`, {
    params: { year, month },
  });

export function getCategoryBreakdown(year, month) {
  return axios.get(
    `http://127.0.0.1:8000/analytics/category-breakdown?year=${year}&month=${month}`
  );
}


export const getSpendingTrend = (days) =>
  axios.get(`${API_BASE}/analytics/spending-trend`, {
    params: { days },
  });
