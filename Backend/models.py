from sqlalchemy import Column, Integer, String, Float, Date, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from datetime import datetime

from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)

    # ：email + password_hash
    email = Column(String(255), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)

    created_at = Column(DateTime, default=datetime.utcnow)

    # relationship: one user many expense
    expenses = relationship("Expense", back_populates="user", cascade="all, delete-orphan")


class Expense(Base):
    __tablename__ = "expenses"

    id = Column(Integer, primary_key=True, index=True)

    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)

    amount = Column(Float, nullable=False)  # Expense Amount
    category = Column(String(100), nullable=False)  # Category：Food / Transport / etc
    date = Column(Date, nullable=False)  # Date

    note = Column(Text, nullable=True)  # Note (Optional)

    created_at = Column(DateTime, default=datetime.utcnow)

    # relationship: 每个 expense 属于一个 user
    user = relationship("User", back_populates="expenses")
