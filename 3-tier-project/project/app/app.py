from flask import Flask, request, jsonify
import os
import mysql.connector
import boto3

app = Flask(__name__)

# DB Connection
def get_db():
    return mysql.connector.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASS'],
        database=os.environ['DB_NAME']
    )

# S3 Client
s3 = boto3.client("s3", region_name=os.environ['REGION'])

# Upload Image to S3
@app.route("/upload", methods=["POST"])
def upload():
    file = request.files['file']
    key = os.environ['S3_PATH'] + file.filename

    s3.upload_fileobj(file, os.environ['S3_BUCKET'], key)

    url = f"{os.environ['CLOUDFRONT_URL']}/{key}"

    return jsonify({"url": url})


# Register User
@app.route("/register", methods=["POST"])
def register():
    data = request.json

    db = get_db()
    cur = db.cursor()

    cur.execute("""
        INSERT INTO users 
        (first_name, last_name, email, password, mobile, location, dob, photo_url)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
    """, (
        data["first_name"],
        data["last_name"],
        data["email"],
        data["password"],
        data["mobile"],
        data["location"],
        data["dob"],
        data["photo_url"]
    ))

    db.commit()

    return jsonify({"status": "registered"})


# Login User
@app.route("/login", methods=["POST"])
def login():
    data = request.json

    db = get_db()
    cur = db.cursor(dictionary=True)

    cur.execute("""
        SELECT * FROM users 
        WHERE email=%s AND password=%s
    """, (data["email"], data["password"]))

    user = cur.fetchone()

    if user:
        return jsonify(user)
    else:
        return jsonify({"error": "Invalid credentials"})


# Health Check
@app.route("/health")
def health():
    return {"status": "ok"}


app.run(host="0.0.0.0", port=9090)