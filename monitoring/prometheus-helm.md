# 🛠️ Prometheus Installation using Helm

This guide explains how to install Prometheus on Kubernetes using Helm.

---

## ✅ Prerequisites

- Kubernetes cluster (EKS or local)
- `kubectl` installed and configured
- Helm installed (`v3+`)
- Internet access from the cluster to pull Helm charts

---

## 📥 Step 1: Add Helm Repo

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

---

## 🚀 Step 2: Install Prometheus Stack

```bash
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

---

## 🔍 Step 3: Verify Installation

```bash
kubectl get all -n monitoring
```

You should see Prometheus pods, services, and related CRDs.

---

## 🌐 Step 4: Access Prometheus UI

Use port forwarding:

```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
```

Open in browser: [http://localhost:9090](http://localhost:9090)

Or expose it via LoadBalancer or Ingress if required.
