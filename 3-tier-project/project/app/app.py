from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import mysql.connector

app = Flask(__name__)
CORS(app)

def get_db():
    try:
        print("🔌 Connecting to DB...")
        db = mysql.connector.connect(
            host=os.environ['DB_HOST'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASS'],
            database=os.environ['DB_NAME']
        )
        print("✅ DB CONNECTED")
        return db
    except Exception as e:
        print("❌ DB ERROR:", e)
        return None

@app.route("/health")
def health():
    return {"status": "APP OK"}

@app.route("/health/db")
def health_db():
    db = get_db()
    return {"db": "ok"} if db else {"db": "failed"}

@app.route("/register", methods=["POST"])
def register():
    try:
        data = request.json
        print("📥 REGISTER:", data)

        db = get_db()
        if not db:
            return {"error": "DB failed"}

        cur = db.cursor()

        cur.execute("""
        INSERT INTO users(first_name,last_name,email,password,mobile,location,dob)
        VALUES (%s,%s,%s,%s,%s,%s,%s)
        """, (
            data.get("first_name"),
            data.get("last_name"),
            data.get("email"),
            data.get("password"),
            data.get("mobile"),
            data.get("location"),
            data.get("dob")
        ))

        db.commit()
        print("✅ INSERT SUCCESS")

        return {"status": "registered"}

    except Exception as e:
        print("❌ ERROR:", e)
        return {"error": str(e)}

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    print("🔐 LOGIN:", data)

    db = get_db()
    cur = db.cursor(dictionary=True)

    cur.execute("SELECT * FROM users WHERE email=%s AND password=%s",
                (data["email"], data["password"]))

    user = cur.fetchone()
    return jsonify(user if user else {"error": "Invalid"})

app.run(host="0.0.0.0", port=9090)