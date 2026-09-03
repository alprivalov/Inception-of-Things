# Clear — remettre l'environnement à zéro avant la correction

À exécuter **avant** de commencer la démo (avant d'utiliser `correction.md`), pour repartir d'un état propre — comme si rien n'avait encore été fait, exactement ce que l'évaluateur verra.

---

## 1. Vérifier les outils du Niveau 1 (VM hôte)

```bash
echo "===== GIT =====" ; git --version
echo "===== CURL =====" ; curl --version | head -n 1
echo "===== SSH =====" ; ssh -V
echo "===== MAKE =====" ; make --version | head -n 1
echo "===== VIRTUALBOX =====" ; VBoxManage --version
echo "===== VAGRANT =====" ; vagrant --version
echo "===== DOCKER =====" ; docker --version
echo "===== DOCKER COMPOSE =====" ; docker compose version
echo "===== KUBECTL =====" ; kubectl version --client
echo "===== K3D =====" ; k3d version
echo "===== HELM =====" ; helm version
```

Si un outil manque, se référer au script de bootstrap du Niveau 1 (installation de Docker/VirtualBox/Vagrant/kubectl/K3d/Helm).

---

## 2. Vérifier l'espace disque disponible

```bash
df -h /
```
Prévoir au moins ~10-15 Go libres avant de relancer p1 (2 VMs) + p2 (1 VM) + p3 (K3d/Docker).

---

## 3. Détruire les VMs de p1 (repartir de zéro)

1. Éteindre proprement (pas de destruction de données précieuses, c'est un cluster K3s reproductible) :

```bash
VBoxManage controlvm "alprivalS" poweroff
VBoxManage controlvm "alprivalSW" poweroff
```

2. Supprimer les VMs et leurs disques :


```bash
VBoxManage unregistervm "alprivalS" --delete
VBoxManage unregistervm "alprivalSW" --delete
```

```bash
cd ~/neworigin/p1
vagrant destroy -f
cd ~/neworigin
```

Vérifier qu'aucune VM `alprivalS`/`alprivalSW` ne traîne encore dans VirtualBox :
```bash
VBoxManage list vms
```
(supprimer manuellement si besoin : `VBoxManage unregistervm "<nom>" --delete`)

---

## 4. Détruire la VM de p2 (repartir de zéro)

```bash
cd ~/neworigin/p2
vagrant destroy -f
cd ~/neworigin
```

---

## 5. Supprimer le cluster K3d de p3 (pour que `install.sh` reparte vraiment de zéro)

```bash
k3d cluster list
k3d cluster delete iot
```

⚠️ Important : si le cluster existe déjà, `install.sh` va sauter la création du cluster (idempotent) — pour une vraie démo "installation en live" comme exigé par le sujet, il vaut mieux repartir sans cluster existant.

---

## 6. Nettoyer les restes locaux (tokens, fichiers générés)

```bash
rm -f ~/neworigin/p1/node-token
rm -f ~/neworigin/p2/node-token
```

(Ces fichiers sont de toute façon dans les `.gitignore`, mais autant repartir propre localement aussi.)

---

## 7. Vérifier l'état Git (rendu officiel + repo GitHub public)

```bash
cd ~/neworigin
git status
git log -1 --oneline
```
→ doit afficher "working tree clean" et être à jour avec le remote 42.

```bash
cd ~/Inception-of-Things
git status
git log -1 --oneline
cat deployement.yaml | grep image
```
→ vérifier quelle version (`v1` ou `v2`) est actuellement pushée sur GitHub, pour savoir d'où repartira la démo.

---

## 8. Vérifier le contexte kubectl par défaut

```bash
kubectl config get-contexts
```
S'assurer qu'aucun contexte périmé (pointant vers une VM/cluster détruit) ne reste actif par défaut — sinon les premières commandes `kubectl` de la démo pourraient échouer avec des erreurs de connexion.

---

## Une fois tout ça fait

L'environnement est prêt pour une démo complète et crédible depuis zéro — passer à `correction.md` pour dérouler la soutenance.
