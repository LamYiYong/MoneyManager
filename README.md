# 💰 Money Manager

A personal cross-platform expense tracking system built with a shared backend, a web dashboard, and a mobile app.

---

## 🔍 About

Money Manager allows users to record daily expenses using a mobile app and view spending insights through a web dashboard.  
Both the web and mobile clients use the same FastAPI backend.

This project was built as a personal project to practice full-stack and cross-platform development.

---

## 🏗️ Architecture

Flutter Mobile App  
→ FastAPI Backend  
→ Database  

React Web Dashboard  
→ FastAPI Backend  
→ Database  

---

## 🛠 Tech Stack

**Backend**
- Python
- FastAPI
- SQLAlchemy
- SQLite

**Web**
- React
- Recharts
- Axios

**Mobile**
- Flutter
- HTTP package
- Material UI

---

## ✨ Features

**Mobile App**
- Add expense (amount, category, date, note)
- View expense list
- View recent spending trend (last 7 days)
- Tested on a real Android phone

**Web Dashboard**
- Category breakdown (pie chart)
- Monthly overview
- Spending trend visualization

**Backend**
- RESTful API
- Category-based analytics
- Time-based spending trends
- Shared API for web and mobile

---
## 📂 Project Structure
MoneyManager/
├── Backend/
├── finance-dashboard/
├── money_manager_mobile/
└── README.md


---

## ▶️ Run Locally

### Backend
```bash
cd Backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### API docs:
```bash
http://localhost:8000/docs
```

### Web Dashboard
```bash
cd finance-dashboard
npm install
npm run dev
```
### Mobile App
```bash
cd money_manager_mobile
flutter pub get
flutter run
```

# 💡 Why I Built This
1. Practice full-stack development
2. Learn mobile ↔ backend networking
3. Build a realistic multi-platform application
4. Explore data analytics and visualization

# 🚀 Future Improvements
1. User authentication
2.Cloud deployment
3. Monthly and yearly reports
4. Push notifications
5. iOS support
