"""Minimal FastAPI service used to demonstrate a CI/CD pipeline (AZ-400)."""
from fastapi import FastAPI

app = FastAPI(title="AZ-400 Demo Service", version="1.0.0")


@app.get("/health")
def health() -> dict[str, str]:
    """Liveness probe used by load balancers and the pipeline smoke test."""
    return {"status": "ok"}


@app.get("/version")
def version() -> dict[str, str]:
    """Return the running application version."""
    return {"version": app.version}
