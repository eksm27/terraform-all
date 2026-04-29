import os

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()

LOGGING_CONFIG = {
    "version": 1,
    "disable_existing_loggers": True,

    "formatters": {
        "json": {
            "()": "pythonjsonlogger.jsonlogger.JsonFormatter",
            "fmt": "%(asctime)s %(levelname)s %(message)s %(method)s %(path)s %(status_code)s %(duration_ms)s %(client)s",
            "rename_fields": {
                "asctime": "timestamp",
                "levelname": "level"
            }
        }
    },

    "handlers": {
        "default": {
            "class": "logging.StreamHandler",
            "formatter": "json"
        }
    },

    "root": {
        "level": LOG_LEVEL,
        "handlers": ["default"]
    }
}