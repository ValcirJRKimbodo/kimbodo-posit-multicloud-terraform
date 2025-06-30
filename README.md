# 🌐 **Posit Multicloud Terraform IAC**

> *Professional‑grade Infrastructure‑as‑Code skeleton for GCP today – AWS/Azure tomorrow.*

---

## Table&nbsp;of&nbsp;Contents
1. [Project Goals](#project-goals)
2. [High‑Level Architecture](#high-level-architecture)
3. [Repository Layout](#repository-layout)
4. [Prerequisites](#prerequisites)
5. [Quick Start (GCP → dev)](#quick-start-gcp--dev)
6. [Per‑Environment Workflow](#per-environment-workflow)
7. [Modules Overview](#modules-overview)
8. [Variables & Secrets](#variables--secrets)
9. [CI / CD Pipeline](#ci--cd-pipeline)
10. [Extending to AWS & Azure](#extending-to-aws--azure)
11. [Troubleshooting](#troubleshooting)
12. [Contributing](#contributing)
13. [License](#license)

---

## Project Goals
- **Repeatable** creation of core cloud primitives (network, subnets, clusters, IPs).
- **Modular** – each cloud lives in its own reusable module; roots orchestrate composition.
- **Opinionated but flexible**: sensible defaults, easy overrides via variables.
- **Production‑ready** coding standards (fmt, lint, security scanning, remote state, locking).

---

## High‑Level Architecture
```
┌────────────────────────────────────────────────────────────┐
│                 Google Cloud   (today)                     │
│  ┌───────────────┐     ┌────────────────────────────────┐  │
│  │   VPC (MVP)   │     │  Static IP (Traefik LB)        │  │
│  │ 10.10.0.0/24  │     │                                │  │
│  └───────────────┘     └────────────────────────────────┘  │
│        │                                                │  │
│  ┌───────────────┐                                      │  │
│  │   Subnet      │ Pods: 10.136.0.0/14                  │  │
│  └───────────────┘                                      │  │
│        │                                                │  │
│  ┌───────────────────────────────┐                      │  │
│  │       GKE Cluster (MVP)       │                      │  │
│  └───────────────────────────────┘                      │  │
└────────────────────────────────────────────────────────────┘
```

> **Next:** replicate with `eks/` on AWS & `aks/` on Azure using same folder layout.

---

## Repository Layout
```text
terraform/
├─ modules/              # Re‑usable building blocks (cloud‑agnostic where possible)
│  ├─ network/           #   VPC + Subnets + Secondary ranges
│  ├─ gke/               #   Google Kubernetes Engine cluster + node pools
│  └─ static-ip/         #   Regional static address (LB / Ingress)
└─ envs/                 # Root modules (one per env × cloud)
   ├─ dev/               #   Non‑prod environment on GCP
   ├─ prod/              #   Production (to be created later)
   └─ ...                #   aws-dev, azure-dev …
```
*See also:* `.gitignore`, `Makefile` (optional helper), pre‑commit hooks.

---

## Prerequisites
| Tool | Version | Notes |
|------|---------|-------|
| Terraform | **≥ 1.7** | Install via [`tfenv`](https://github.com/tfutils/tfenv) for easy switching |
| Google Cloud CLI | latest | `gcloud auth application-default login` |
| A GCP project | owner role | **billing enabled** |
| Service Account | `roles/owner` or fine‑grained set | JSON key exported in `GOOGLE_APPLICATION_CREDENTIALS` |
| `tflint`, `tfsec`, `checkov` | optional but recommended | enforced in CI |

> **APIs to enable once:**
> ```bash
> gcloud services enable compute.googleapis.com container.googleapis.com
> ```

---

## Quick Start (GCP → dev)
```bash

# 0) AuthN
$ export GOOGLE_APPLICATION_CREDENTIALS=$HOME/key-sa-posit.json

# 1) Initialize backend & providers
$ terraform init

# 2) Review changes
$ terraform plan -out tfplan

# 3) Apply!
$ terraform apply tfplan
```
Outputs:
```text
Apply complete! Resources: 10 added.

Outputs:
  gke_endpoint = 34.69.x.x
  traefik_ip   = 104.198.152.96
```
Use `gcloud container clusters get-credentials posit-cluster-mvp --region us-central1` to talk to the cluster.

---

## Per‑Environment Workflow
| Action | Command | Typical cadence |
|--------|---------|-----------------|
| Format code | `terraform fmt -recursive` | every commit |
| Validate | `terraform validate` | every commit |
| Generate plan | `terraform plan -out tfplan` | PR comment in CI |
| Apply | `terraform apply tfplan` | merge to `main` |
| Destroy | `terraform destroy -auto-approve` | ephemeral envs |

State backend lives in **GCS bucket `tfstate-posit-demo`** with locking handled by Cloud Storage.

---

## Modules Overview
| Module | Cloud | What it does | Key vars |
|--------|-------|-------------|----------|
| `network` | GCP | Creates custom‑mode VPC + subnet with primary & secondary ranges | `primary_cidr`, `pods_cidr` |
| `gke` | GCP | Stand‑alone GKE (Standard) cluster | `cluster_name`, `pods_range_name`, node‑pool settings |
| `static-ip` | GCP | Reserves regional IPv4 | `name`, `region` |

> **Design choice:** modules expose **self‑links** instead of names to avoid look‑ups when cross‑referencing resources.

---

## Variables & Secrets
| File | Purpose |
|------|---------|
| `variables.tf` (root) | Declares **public** inputs (project_id, region, etc.) |
| `terraform.tfvars` | Environment‑specific values – **never commit credentials** |

Secrets at runtime:
- **Cloud creds** via `GOOGLE_APPLICATION_CREDENTIALS` (GCP) or env‑var‐based injection.
- **Future**: HashiCorp Vault or Terraform Cloud sensitive vars.

---

## Troubleshooting
| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `403: required "container.clusters.get"` | SA missing roles | Grant `roles/container.admin` & `roles/compute.networkAdmin` |
| `Error 409: Already Exists` | Resource name collision | Increment `cluster_name` or destroy stale res |
| Terraform lock stuck | Interrupted apply | `terraform force-unlock <id>` then re‑plan |

---

## Contributing
1. Fork / branch off **`develop`**.
2. Run `make precommit` (fmt + lint) – commits failing checks are blocked.
3. Open a MR/PR; reviewers will look for *idempotency* and *zero‑downtime upgrade*.
4. Squash‑merge → `develop`; tag and fast‑forward `main` on release.

---

## License
Apache 2.0 – see `LICENSE` file.

> **Maintainer:** Valcir Balbinotti Junior — feel free to ping me on Kimbodo's Slack
