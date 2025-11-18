# Forgejo on K3s

This deploys Forgejo as a Kubernetes application on the p520 K3s cluster.

## Architecture

- **Database**: Uses the host PostgreSQL instance at `192.168.48.5:5432`
- **Storage**: hostPath persistent volume at `/var/lib/forgejo`
- **Network**: NodePort service exposing:
  - HTTP on port 30300
  - SSH on port 30222

## Deployment

1. **Apply the Kubernetes manifests:**

   ```bash
   kubectl apply -k modules/hosts/p520/k3s/forgejo/
   ```

1. **Rebuild NixOS to ensure PostgreSQL and persistence are configured:**

   ```bash
   sudo nixos-rebuild switch --flake .#p520
   ```

1. **Check deployment status:**

   ```bash
   kubectl get pods -n forgejo
   kubectl logs -n forgejo -l app=forgejo
   ```

## Access

- **Web UI**: http://p520:30300 or http://forgejo.michael.lan:30300
- **SSH**: ssh://git@p520:30222

## Configuration

Configuration is managed via ConfigMap (`configmap.yaml`). To update:

1. Edit the ConfigMap
1. Reapply: `kubectl apply -k modules/hosts/p520/k3s/forgejo/`
1. Restart the pod: `kubectl rollout restart deployment/forgejo -n forgejo`

## Database

The PostgreSQL database is automatically created and managed by NixOS at:

- Host: 192.168.48.5
- Database: forgejo
- User: forgejo
- Auth: trust (from pod network 10.42.0.0/16)

## Storage

Data is persisted at `/var/lib/forgejo` on the host, which is:

- Configured as a hostPath PersistentVolume
- Persisted across reboots via impermanence

## Troubleshooting

**Check pod status:**

```bash
kubectl get pods -n forgejo
kubectl describe pod -n forgejo -l app=forgejo
```

**Check logs:**

```bash
kubectl logs -n forgejo -l app=forgejo -f
```

**Test database connection:**

```bash
kubectl exec -n forgejo -it deployment/forgejo -- psql -h 192.168.48.5 -U forgejo -d forgejo
```

**Restart deployment:**

```bash
kubectl rollout restart deployment/forgejo -n forgejo
```
