# Branching & Release Strategy

A lightweight trunk-based workflow suited to a small team shipping continuously.

## Branching

- **`main`** is always deployable. Every commit on `main` has passed the full
  pipeline (lint, tests, IaC validation, image build).
- **Feature branches** (`feature/<short-description>`) branch off `main` and are
  short-lived — merged within a day or two to avoid drift.
- No long-running release branches. Releases are cut from `main` with tags.

## Pull requests

- All changes reach `main` via PR — no direct pushes.
- The CI pipeline runs on every PR; a PR cannot merge while any check is red.
- At least one review approval required (branch protection).

## Releases

- Production releases are marked with annotated tags: `v1.0.0`, `v1.1.0`, …
  following semantic versioning.
- The container image is tagged with both the commit SHA (traceability) and the
  release tag (human-readable).

## Environments

| Environment | Trigger | Approval |
|---|---|---|
| Build/test | every push & PR | none (automated gates) |
| Production | merge to `main` + `ENABLE_DEPLOY=true` | manual approval via GitHub Environment |

The `production` environment uses a GitHub *deployment environment* so a reviewer
must approve before the deploy job runs — preventing unreviewed changes from
reaching Azure.

## Rollback

- Re-deploy the previous image tag (images are immutable and retained).
- Because infrastructure is defined in Bicep, environment state is reproducible
  rather than hand-patched.
