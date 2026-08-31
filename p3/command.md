# Memo

## Tunnel port-forwarding 
    kubectl port-forward svc/argocd-server -n argocd 8080:443

## Argocd admin password 
    kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
