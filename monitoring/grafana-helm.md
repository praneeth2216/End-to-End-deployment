# 📊 Grafana Installation using Helm

This document outlines how to install and access Grafana using Helm on a Kubernetes cluster.

---

## ✅ Prerequisites

- Kubernetes cluster
- Helm v3+
- Prometheus stack (already deployed)
- `kubectl` configured

---

## 🛠️ Step 1: Access Grafana

Grafana is included with `kube-prometheus-stack`.

Check if it's installed:

```bash
kubectl get svc -n monitoring
```

Find a service like:

```
prometheus-grafana   ClusterIP   10.XX.XX.X   <none>   80/TCP   5m
```

---

## 🌐 Step 2: Port Forward

```bash
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
```

Access Grafana: [http://localhost:3000](http://localhost:3000)

---

## 🔐 Step 3: Login Credentials

Default:
- **Username**: admin
- **Password**: `kubectl get secret --namespace monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode`

---

## 📈 Step 4: Import Dashboards

1. Login to Grafana
2. Go to **Dashboards > Import**
3. Use Dashboard ID from [Grafana.com](https://grafana.com/grafana/dashboards/)

Example: Node Exporter Full - ID `1860`

---

## 🧪 Step 5: Connect to Prometheus (if needed)

- Navigate to **Configuration > Data Sources**
- Add Prometheus with URL: `http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090`

---

## 🗂 Notes

- Change service type to LoadBalancer or configure Ingress for public access.
- Customize dashboards for Kubernetes metrics.
