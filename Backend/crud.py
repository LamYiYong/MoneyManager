import pandas as pd
from datetime import date

from sqlalchemy.orm import Session
from datetime import date

import models
import schemas


# new expense
def create_expense(
    db: Session,
    expense: schemas.ExpenseCreate,
    user_id: int
):
    db_expense = models.Expense(
        user_id=user_id,
        amount=expense.amount,
        category=expense.category,
        date=expense.date,
        note=expense.note
    )

    db.add(db_expense)
    db.commit()
    db.refresh(db_expense)

    return db_expense


# call out a user expense
def get_expenses(
    db: Session,
    user_id: int
):
    return (
        db.query(models.Expense)
        .filter(models.Expense.user_id == user_id)
        .order_by(models.Expense.date.desc())
        .all()
    )

def get_monthly_summary(
    db: Session,
    user_id: int,
    year: int,
    month: int
):
    
    expenses = (
        db.query(models.Expense)
        .filter(models.Expense.user_id == user_id)
        .all()
    )

    if not expenses:
        return {
            "year": year,
            "month": month,
            "total_amount": 0,
            "by_category": {}
        }

    # 2. convert to DataFrame
    data = [{
        "amount": e.amount,
        "category": e.category,
        "date": e.date
    } for e in expenses]

    df = pd.DataFrame(data)

    # 3. filter (year, month)
    df["date"] = pd.to_datetime(df["date"])
    df = df[
        (df["date"].dt.year == year) &
        (df["date"].dt.month == month)
    ]

    if df.empty:
        return {
            "year": year,
            "month": month,
            "total_amount": 0,
            "by_category": {}
        }

    # 4. calculate
    total_amount = round(float(df["amount"].sum()), 2)

    by_category = {
    k: round(float(v), 2)
    for k, v in (
        df.groupby("category")["amount"]
        .sum()
        .to_dict()
    ).items()
    }

    return {
        "year": year,
        "month": month,
        "total_amount": total_amount,
        "by_category": by_category
    }