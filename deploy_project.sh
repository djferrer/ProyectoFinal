#!/bin/bash
set -e

NAMESPACE="medical-app"

echo "🧹 Eliminando namespace anterior si existe..."
kubectl delete namespace $NAMESPACE --ignore-not-found

echo "⏳ Esperando a que se eliminen los recursos anteriores..."
sleep 5

echo "🚀 Creando namespace..."
kubectl create namespace $NAMESPACE

echo "🔑 Creando Secret de MySQL..."
kubectl apply -f k8s/secret.yaml

echo "💾 Creando volumen para MySQL..."
kubectl apply -f k8s/mysql-volume.yaml

echo "📦 Creando ConfigMap con init.sql..."
kubectl apply -f k8s/mysql-initdb-configmap.yaml

echo "🐬 Desplegando MySQL..."
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml

echo "⏳ Esperando a que MySQL esté listo..."
kubectl rollout status deployment/mysql-medical -n $NAMESPACE
echo "⌛ Esperando 15 segundos extra para inicialización de MySQL..."
sleep 15

echo "🖥️ Desplegando Backend..."
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml

echo "⏳ Esperando a que Backend esté listo..."
kubectl rollout status deployment/contact-backend -n $NAMESPACE
echo "⌛ Esperando 20 segundos extra para Spring Boot..."
sleep 20

echo "🌐 Desplegando Frontend..."
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml

echo "⏳ Esperando a que Frontend esté listo..."
kubectl rollout status deployment/medical-frontend -n $NAMESPACE
echo "⌛ Esperando 10 segundos extra para inicialización del Frontend..."
sleep 10

echo "📡 Iniciando port-forward (MySQL:3306, Backend:8080, Frontend:3000)..."
kubectl port-forward svc/mysql 3306:3306 -n $NAMESPACE \
  >/dev/null 2>&1 &
kubectl port-forward svc/medical-backend 8080:8080 -n $NAMESPACE \
  >/dev/null 2>&1 &
kubectl port-forward svc/medical-frontend 3000:3000 -n $NAMESPACE

echo "✅ Proyecto desplegado con éxito."
echo "   - Swagger Backend: http://localhost:8080/swagger-ui/index.html"
echo "   - Frontend:        http://localhost:3000"
echo "   - MySQL:           127.0.0.1:3306 (user=root / pass=netect123)"
echo "⚠️ Usa CTRL+C para detener los port-forward."
