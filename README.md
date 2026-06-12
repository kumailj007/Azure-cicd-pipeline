# CI/CD Pipeline on Azure — AZ-400

[![CI/CD](https://github.com/kumailj007/Azure-cicd-pipeline/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/kumailj007/Azure-cicd-pipeline/actions/workflows/ci-cd.yml)

A complete CI/CD pipeline for a containerized service, built with GitHub Actions and Bicep. Demonstrates the **AZ-400 (DevOps Engineer Expert)** skill set: continuous integration, automated testing, infrastructure as code, containerization, and a gated release strategy.

> **Cert link:** Backs my **AZ-400 (DevOps Engineer)** knowledge. The CI stages run automatically on GitHub on every push — the green badge above is live proof the automation works. The Azure deploy stage is defined and ready, gated behind a repo variable so the pipeline stays green without a subscription.

---

## The pipeline

Every push and pull request to `main` triggers four stages:

| Stage | What it does | Runs where |
|---|---|---|
| **Lint & Test** | `ruff` lint + `pytest` integration tests on the FastAPI app | GitHub runner (free) |
| **Validate Bicep** | `az bicep build` validates the IaC compiles | GitHub runner (free) |
| **Build image** | `docker build` of the app container | GitHub runner (free) |
| **Deploy** | `az deployment group create` to Azure App Service | Azure (gated, off by default) |

The first three run on GitHub's own infrastructure at no cost — that's what the passing badge proves.

---

## How it maps to AZ-400 domains

| AZ-400 domain | Implemented by |
|---|---|
| Continuous integration | Automated lint + test gate on every push/PR |
| Infrastructure as Code | Bicep (`main.bicep`), validated in-pipeline |
| Containerization | Dockerfile, image build stage |
| Continuous delivery | Gated deploy stage to Azure App Service |
| Release strategy | Trunk-based branching, SHA + semver image tags (BRANCHING-STRATEGY.md) |
| Secure pipelines | Secrets via GitHub Secrets, deploy gated on a repo variable |

---

## Files

- `.github/workflows/ci-cd.yml` — the pipeline
- `main.py` — FastAPI service (`/health`, `/version`)
- `test_main.py` — pytest integration tests
- `requirements.txt` — Python dependencies
- `main.bicep` — App Service IaC (hosts the container)
- `Dockerfile` — container build
- `BRANCHING-STRATEGY.md` — branching & release strategy

---

## Enabling the Azure deploy (optional)

The deploy stage is off by default. To enable it with a real subscription:

1. Add an Azure service principal JSON as a repo **secret** named `AZURE_CREDENTIALS`.
2. Add a repo **variable** `ENABLE_DEPLOY` set to `true`.
3. Push to `main` — the deploy job provisions the App Service via Bicep.

Until then, the pipeline runs CI only and stays green.

---

## Run the app locally

```
pip install -r requirements.txt
uvicorn main:app --reload
# http://127.0.0.1:8000/health  ->  {"status":"ok"}
pytest -v
```

---

**Author:** Kumail Janjua
