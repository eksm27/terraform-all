import logging
import logging.config
import time
import requests

from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, Response, HTTPException
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

from app.logging_config import LOGGING_CONFIG

# Apply logging
logging.config.dictConfig(LOGGING_CONFIG)
logger = logging.getLogger("app")

# -------------------------
# Lifespan (replaces on_event)
# -------------------------
@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("app_started")
    yield
    logger.info("app_stopped")

app = FastAPI(lifespan=lifespan)

# -------------------------
# Metrics
# -------------------------
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP Requests",
    ["method", "endpoint", "status_code"]
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "Request latency",
    ["method", "endpoint"]
)

# -------------------------
# Middleware
# -------------------------
@app.middleware("http")
async def middleware(request: Request, call_next):
    start_time = time.time()

    response = None
    try:
        response = await call_next(request)
        return response
    finally:
        duration = round((time.time() - start_time) * 1000, 2)
        status = response.status_code if response else 500

        REQUEST_COUNT.labels(
            method=request.method,
            endpoint=request.url.path,
            status_code=status
        ).inc()

        REQUEST_LATENCY.labels(
            method=request.method,
            endpoint=request.url.path
        ).observe(duration / 1000)

        logger.info(
            "request_completed",
            extra={
                "method": request.method,
                "path": request.url.path,
                "status_code": status,
                "duration_ms": duration,
                "client": request.client.host if request.client else "unknown"
            }
        )

# -------------------------
# Health
# -------------------------
@app.get("/health")
def health():
    return {"status": "ok"}

# -------------------------
# Metrics endpoint
# -------------------------
@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

# -------------------------
# GitHub API
# -------------------------
GITHUB_API = "https://api.github.com/users/{}/gists"

@app.get("/{username}")
def get_gists(username: str):
    try:
        response = requests.get(GITHUB_API.format(username), timeout=5)
    except requests.exceptions.RequestException:
        raise HTTPException(status_code=500, detail="GitHub API error")

    if response.status_code == 404:
        raise HTTPException(status_code=404, detail="User not found")

    if response.status_code != 200:
        raise HTTPException(status_code=500, detail="GitHub API failure")

    return [
        {
            "id": g["id"],
            "url": g["html_url"],
            "description": g["description"]
        }
        for g in response.json()
    ]