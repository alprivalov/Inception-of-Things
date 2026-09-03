## Memo

## p1 

```bash
vagrant up
vagrant ssh alprivalS
kubectl get nodes
```


## p2

```bash
vagrant up

# create applications and ingress
vagrant ssh alprivalS -c "kubectl apply -f /vagrant/confs/app1/ -f /vagrant/confs/app2/ -f /vagrant/confs/app3/ -f /vagrant/confs/ingress.yaml"

# show k3s ingress and pods 
vagrant ssh alprivalS 
kubectl get pods,svc,ingress

# show ingress file config

cat confs/ingress.yaml
```

## p3 


```bash
# create cluster, namespaces and pods via sh script
chmod +x scripts/install.sh
./scripts/install.sh
```

```bash
# show k3d clusters 
kubectl config current-context

# show namespaces
kubectl get ns

# show pods
kubectl get pods -n argocd              
```

```bash
# link github repository with the ArgoCD application controller 
kubectl apply -f confs/argocd-app.yaml

# show created pods via github repository
kubectl get pods -n dev
```

### ArgoCD tunneling + password

```bash
# create a tunnel from localhost to the argocd-server Service (inside the cluster) to access it from the local browser
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# show argocd auth password as admin
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

### Tunneling wil-playground to get acces localy 

```bash
kubectl get pods -n dev
#  port-forward targets the POD directly
kubectl port-forward -n dev pod/wil-playground-{pod-id} 8888:8888 &
curl http://localhost:8888/
```

### Changing Will app version 

    - Change version in deployement.yaml file
    - git add, commit and push
    - access to localhost:8080 argocd 
    - wait the controller to update with the new version 
confirm : 

```bash
curl http://localhost:8888/
``` 


