# Fichiers nécessaires au déploiement de notre application FastAPI

Ce répertoire contient tous les fichiers manifests Kubernetes requis pour le déploiement de notre application FastAPI sur le cluster EKS.
Ces fichiers sont surveillés en continu par ArgoCD pour garantir que toutes les modifications sont correctement propagées sur notre cluster EKS.

## Structure des fichiers
### Fichiers principaux (mis à jour par le pipeline CI GitLab) :

  [backend.yaml](./backend.yaml)
  
  [frontend.yaml](./frontend.yaml)

### Fichiers de configuration :

1. [Persistent Volume](./create_pv.yaml)

#### Configuration du stockage persistant pour la base de données :

    Création du volume persistant (PersistentVolume)
    Définition de la classe de stockage (StorageClass)

2. [Backend](./backend.yaml)

#### Configuration complète du backend :

    Secrets pour la base de données (credentials)
    ConfigMap (variables d'environnement)
    PersistentVolumeClaim (PVC) pour la DB
    Services :
        Service pour la base de données
        Service pour le backend
    Déploiements :
        Déploiement de la base de données
        Déploiement de l'application backend
    Ingress pour le backend

3. [Frontend](./frontend.yaml)

#### Configuration complète du frontend :

    Service pour le frontend
    Déploiement de l'application frontend
    Ingress pour le frontend

### Workflow ArgoCD
ArgoCD surveille en permanence ce dépôt et :

    Détecte les modifications apportées aux fichiers
    Synchronise automatiquement l'état désiré avec le cluster EKS
    Garantit la cohérence entre la configuration déclarative et l'état réel du cluster
