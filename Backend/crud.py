import pandas as pd
import models
import schemas
from datetime import datetime, timedelta
from sqlalchemy.orm import Session

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

def get_category_breakdown(
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
            "categories": []
        }

    data = [{
        "amount": e.amount,
        "category": e.category,
        "date": e.date
    } for e in expenses]

    import pandas as pd
    df = pd.DataFrame(data)

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
            "categories": []
        }

    total_amount = round(float(df["amount"].sum()), 2)

    grouped = (
        df.groupby("category")["amount"]
        .sum()
        .reset_index()
    )

    categories = []
    for _, row in grouped.iterrows():
        amount = round(float(row["amount"]), 2)
        percentage = round((amount / total_amount) * 100, 2)

        categories.append({
            "category": row["category"],
            "amount": amount,
            "percentage": percentage
        })

    return {
        "year": year,
        "month": month,
        "total_amount": total_amount,
        "categories": categories
    }
def get_spending_trend(
    db: Session,
    user_id: int,
    days: int
):
    end_date = datetime.today().date()
    start_date = end_date - timedelta(days=days - 1)

    expenses = (
        db.query(models.Expense)
        .filter(models.Expense.user_id == user_id)
        .filter(models.Expense.date >= start_date)
        .filter(models.Expense.date <= end_date)
        .all()
    )

    # 建完整日期列表
    date_range = pd.date_range(start=start_date, end=end_date)

    if not expenses:
        trend = [
            {"date": d.strftime("%Y-%m-%d"), "amount": 0.0}
            for d in date_range
        ]
        return {
            "days": days,
            "total_amount": 0.0,
            "trend": trend
        }

    data = [{
        "date": e.date,
        "amount": e.amount
    } for e in expenses]

    df = pd.DataFrame(data)
    df["date"] = pd.to_datetime(df["date"])

    daily_sum = (
        df.groupby("date")["amount"]
        .sum()
        .reindex(date_range, fill_value=0)
    )

    trend = []
    for d, amount in daily_sum.items():
        trend.append({
            "date": d.strftime("%Y-%m-%d"),
            "amount": round(float(amount), 2)
        })

    total_amount = round(sum(item["amount"] for item in trend), 2)

    return {
        "days": days,
        "total_amount": total_amount,
        "trend": trend
    }