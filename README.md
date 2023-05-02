# Portfolio Static Website

## Provisioning

### Deploy Remote State

```bash
terraform -chdir=terraform/remote-state-lock init
terraform -chdir=terraform/remote-state-lock plan
terraform -chdir=terraform/remote-state-lock apply
```

### Deploy CloudFront

```bash
terraform -chdir=terraform/cloudfront init
terraform -chdir=terraform/cloudfront plan
terraform -chdir=terraform/cloudfront apply
```
