# azure-iac-reviewer-demo

A demo repository showing [ResourcePulse](https://resourcepulseapp.com) in action — automatic Azure cost estimates and policy checks on every infrastructure pull request.

## What this repo demonstrates

When you open a pull request that modifies files in `infra/`, the ResourcePulse GitHub Action automatically:

1. Parses the Bicep templates to extract resource definitions
2. Calls the ResourcePulse API to estimate costs and run policy checks
3. Posts a detailed comment directly on the PR

No API key required — this demo runs in **Sandbox mode** using GitHub OIDC authentication.

## Infrastructure

The `infra/` directory contains a simple Azure deployment:

```
infra/
  main.bicep              # Root module
  modules/
    storage.bicep         # Azure Storage Account (Standard_LRS)
    appservice.bicep      # App Service Plan (B1) + Web App
    keyvault.bicep        # Key Vault (Standard)
  params/
    dev.bicepparam        # Dev environment parameters (westeurope)
```

## Try it yourself

1. Fork this repository
2. Open a pull request that changes any file in `infra/`  
   (e.g. change `Standard_LRS` to `Standard_GRS` in `modules/storage.bicep`, or `B1` to `P1v3` in `modules/appservice.bicep`)
3. Watch ResourcePulse post a cost estimate comment on your PR

## Example PR comment

```
## ResourcePulse Report

### Cost Estimate

**Estimated Monthly Cost: $117.86**
**Coverage: 2 of 2 resources (100%)**

| Resource | Change | SKU | Monthly Cost |
|----------|--------|-----|--------------|
| Web/serverfarms | added | P1v3 | +$116.80 |
| Storage/storageaccounts | added | Standard_GRS | +$1.06 |

### Findings

No issues found!

### Summary
0 critical | 0 warnings | Status: **pass**
```

## Workflow

The workflow at `.github/workflows/iac-review.yml` uses sandbox mode — no secrets needed:

```yaml
- uses: resourcepulse-io/azure-iac-reviewer@main
  with:
    param_file: infra/params/dev.bicepparam
    comment_mode: update
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Plans

| Plan | How to get it | Rate limits |
|------|--------------|-------------|
| **Sandbox** | No signup — just use the action | 10 analyses/repo/day |
| **Trial** | [Start free trial](https://resourcepulseapp.com/trial) | Full Pro, 14 days |
| **Pro** | [Upgrade](https://resourcepulseapp.com/upgrade) | 500 analyses/day |

## Privacy

ResourcePulse only sees **anonymized resource type and SKU information** — no resource names, identifiers, or application data leave your environment. See the [action source](https://github.com/resourcepulse-io/azure-iac-reviewer) for details.
