#!/bin/bash
set -e

NAMESPACE="medical-app"

echo "🚀 Despliegue completo en Kubernetes"

# 0) Limpieza idempotente
kubectl delete namespace "$NAMESPACE" --ignore-not-found || true
kubectl wait --for=delete ns/"$NAMESPACE" --timeout=120s || true

# 1) Base
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secret.yaml

# 2) MySQL
kubectl apply -f k8s/mysql-volume.yaml
kubectl apply -f k8s/mysql-initdb-configmap.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml

echo "⏳ Esperando MySQL..."
kubectl -n "$NAMESPACE" rollout status deploy/mysql-medical --timeout=180s
sleep 10

# 3) Backend
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml
echo "⏳ Esperando Backend..."
kubectl -n "$NAMESPACE" rollout status deploy/contact-backend --timeout=180s
sleep 10

# 4) Frontend
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml
echo "⏳ Esperando Frontend..."
kubectl -n "$NAMESPACE" rollout status deploy/medical-frontend --timeout=180s
sleep 5

# 5) Ingress (¡clave para evitar el 404!)
kubectl apply -f k8s/ingress-frontend.yaml
kubectl apply -f k8s/ingress-backend.yaml

echo "🔎 Validando Endpoints/Ingress"
kubectl -n "$NAMESPACE" get svc,endpoints,ingress -o wide

echo "✅ Listo."
echo "   Frontend:      http://proyectodouglas.local"
echo "   API (doctores) http://proyectodouglas.local/api/doctor"
echo "   Swagger:       http://proyectodouglas.local/api/swagger-ui/index.html"
