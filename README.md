# ResourcePulse — Demo Repository

This repo is a sandbox for the [azure-iac-reviewer](https://github.com/resourcepulse-io/azure-iac-reviewer) GitHub Action.

Open a pull request that touches any `.bicep` file and the action posts a comment with:
- Cost delta (monthly estimate, public Azure pricing)
- Coverage — what was priced vs what couldn't be resolved
- Low-noise warnings for tags, regions, and SKUs

No Azure subscription access required.

---

## Quick start (5 min)

### 1. Fork this repo

Click **Fork** in the top-right corner. Keep the default settings.

### 2. Add your API key

In your fork:

1. Go to **Settings** (top navigation bar of your repo)
2. In the left sidebar, click **Secrets and variables → Actions**
3. Click **New repository secret**
4. Fill in the fields:
   - **Name:** `AZURE_IAC_REVIEWER_API_KEY`
   - **Secret:** paste the key you received
5. Click **Add secret**

### 3. Make a change and open a PR

Create a branch and edit one of the Bicep files. For an interesting cost diff, try one of these:

**Option A — bump the App Service SKU:**

In `infra/modules/appservice.bicep`, change line 10:
```bicep
// before
: { name: 'B1', tier: 'Basic', size: 'B1', family: 'B', capacity: 1 }

// after
: { name: 'S2', tier: 'Standard', size: 'S2', family: 'S', capacity: 2 }
```

**Option B — upgrade storage replication:**

In `infra/modules/storage.bicep`, change line 10:
```bicep
// before
var skuName = env == 'prod' ? 'Standard_GRS' : 'Standard_LRS'

// after
var skuName = env == 'prod' ? 'Standard_GRS' : 'Standard_ZRS'
```

**Option C — add a resource** (produces the highest cost delta):

Add a new module call in `infra/main.bicep` for any Azure resource.

### 4. Open a PR targeting `main`

The **Azure IaC Review** workflow runs automatically. Within ~30 seconds a comment appears on your PR.

---

## Repository structure

```
infra/
  main.bicep              # Root template — wires all modules together
  modules/
    appservice.bicep      # App Service Plan + Web App (B1 dev / P2v3 prod)
    storage.bicep         # Storage Account (LRS dev / GRS prod)
    keyvault.bicep        # Key Vault (standard dev / premium prod)
    cosmos.bicep          # Cosmos DB (400 RU/s dev / 1000 RU/s prod)
  params/
    dev.bicepparam        # westeurope, env=dev
    prod.bicepparam       # westeurope, env=prod
.github/workflows/
  bicep-review.yml        # Triggers on PRs that touch infra/**
```

The modules use `env`-based SKU logic so changes that promote a config from dev to prod produce meaningful cost diffs.

---

## Workflow details

```yaml
- uses: resourcepulse-io/azure-iac-reviewer@main
  with:
    api_key: ${{ secrets.AZURE_IAC_REVIEWER_API_KEY }}
    param_file: infra/params/dev.bicepparam   # resolves Azure region
    env: dev                                   # applies dev policy rules
    comment_mode: update                       # edits the same comment on each push
```

The workflow only triggers on changes under `infra/**` to avoid noise from unrelated commits.
