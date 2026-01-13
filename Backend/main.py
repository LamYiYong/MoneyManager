from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

import models
import schemas
import crud
from database import engine, Base, SessionLocal
from typing import List


app = FastAPI(
    title="Money Manager API",
    description="Personal Finance Management Backend",
    version="1.0.0"
)

# ========= Session Dependency =========
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)


@app.get("/")
def root():
    return {"message": "Money Manager API is running 🚀"}


# ========= Expense APIs =========

# new expense
@app.post("/expenses", response_model=schemas.ExpenseResponse)
def create_expense(
    expense: schemas.ExpenseCreate,
    db: Session = Depends(get_db)
):

    return crud.create_expense(db=db, expense=expense, user_id=1)


# call out user expense
@app.get("/expenses", response_model=list[schemas.ExpenseResponse])
def get_expenses(
    db: Session = Depends(get_db)
):
    return crud.get_expenses(db=db, user_id=1)

@app.get(
    "/analytics/monthly-summary",
    response_model=schemas.MonthlySummaryResponse
)
def monthly_summary(
    year: int,
    month: int,
    db: Session = Depends(get_db)
):
    return crud.get_monthly_summary(
        db=db,
        user_id=1, 
        year=year,
        month=month
    )
