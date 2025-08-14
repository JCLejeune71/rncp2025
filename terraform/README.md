# Infrastructure as Code avec Terraform

Ce dépôt contient la configuration Terraform pour déployer une infrastructure EKS complète avec différents composants.

## Architecture du projet
```bash

.
├── main.tf # Fichier principal de configuration
├── modules/ # Répertoire des modules personnalisés
│ ├── argocd/ # Déploiement d'ArgoCD
│ ├── cert_manager/ # Gestion des certificats TLS
│ ├── ebs/ # Configuration des volumes EBS
│ ├── eks/ # Cluster EKS et node groups
│ ├── ingresscontroller/ # Contrôleur d'entrée
│ ├── networking/ # Configuration réseau (VPC, subnets)
│ ├── prometheus/ # Monitoring avec Prometheus
│ ├── vault/ # Intégration de Vault
│ └── velero/ # Backup avec Velero
├── output.tf # Sorties de la configuration
├── providers.tf # Configuration des providers
├── terraform.tfvars # Variables de configuration
└── variables.tf # Déclaration des variables
```

## Prérequis

- Terraform >= 1.0
- AWS CLI configuré avec des credentials valides
- kubectl
- helm (pour certains modules)

## Modules disponibles

### ArgoCD
Installe ArgoCD pour le GitOps:
- Déploiement avec Helm
- Utilisation de la clé SSH
- Déploiement de l'application

### cert_manager
Gère les certificats TLS:
- Intégration avec *Let's Encrypt*
- Renouvellement automatique

### ebs
Crée un volume EBS pour le stockage des données
- Configuration IAM
- Création d'un volume ebs

### eks
Déploie un cluster EKS avec:
- Groups de nodes managés
- Profils Fargate
- Configuration IAM
- Accès administrateur

### ingresscontroller
- Installe Nginx pour le frontend et le backend

### networking
Crée l'infrastructure réseau:
- VPC avec sous-réseaux publics/privés
- NAT Gateways
- Routes

### prometheus
Installe la combinaison Prometheus et Grafana
- Déploiement avec Helm

### vault
Intègre HashiCorp Vault:
- Récupération de secrets via API
- Injection dans les pods

### velero
Effectue la sauvegarde du ckuster
- Planification de sauvegardes
- Stockage dans S3
- Restauration possible

## Utilisation

1. Initialiser Terraform:
```bash
terraform init
```

2. Vérifier la configuration de Terraform:
```bash
terraform plan --auto-approuve
```

3. Déployer la configuration de Terraform:
```bash
terraform plan --auto-approuve
```