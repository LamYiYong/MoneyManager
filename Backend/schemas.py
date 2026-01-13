from pydantic import BaseModel
from datetime import date, datetime
from typing import Optional
from typing import Dict

# ===== Expense =====

class ExpenseBase(BaseModel):
    amount: float
    category: str
    date: date
    note: Optional[str] = None


# create expense(frontend)
class ExpenseCreate(ExpenseBase):
    pass


# return expense(bankend)
class ExpenseResponse(ExpenseBase):
    id: int
    user_id: int
    created_at: datetime

    class Config:
        from_attributes = True  # Pydantic v2

class MonthlySummaryResponse(BaseModel):
    year: int
    month: int
    total_amount: float
    by_category: Dict[str, float]
