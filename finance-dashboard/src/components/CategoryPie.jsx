import { PieChart, Pie, Tooltip, Cell } from "recharts";

const COLORS = ["#4f46e5", "#22c55e", "#f59e0b", "#ef4444"];

export default function CategoryPie({ data }) {
  if (!data || data.length === 0) {
    return <p>No category data</p>;
  }

  return (
    <PieChart width={280} height={260}>
      <Pie
        data={data}
        dataKey="amount"
        nameKey="category"
        cx="50%"
        cy="50%"
        outerRadius={90}
        label
        labelLine={false}
      >
        {data.map((_, index) => (
          <Cell key={index} fill={COLORS[index % COLORS.length]} />
        ))}
      </Pie>
      <Tooltip />
    </PieChart>
  );
}
