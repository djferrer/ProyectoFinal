#!/bin/bash

NAMESPACE="medical-app"

echo "🚀 Desplegando proyecto completo en Kubernetes..."

# 1. Namespace y secretos
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secret.yaml

# 2. MySQL
kubectl apply -f k8s/mysql-volume.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml

echo "⏳ Esperando a que MySQL esté listo..."
kubectl wait --for=condition=available --timeout=180s deployment/mysql-medical -n $NAMESPACE
echo "⌛ Esperando 15 segundos extra para inicialización de MySQL..."
sleep 15

# 3. Backend (con initContainer que espera MySQL)
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml

echo "⏳ Esperando a que Backend esté listo..."
kubectl wait --for=condition=available --timeout=180s deployment/contact-backend -n $NAMESPACE
echo "⌛ Esperando 20 segundos extra para inicialización de Spring Boot..."
sleep 20

# 4. Frontend
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml

echo "⏳ Esperando a que Frontend esté listo..."
kubectl wait --for=condition=available --timeout=180s deployment/medical-frontend -n $NAMESPACE
echo "⌛ Esperando 10 segundos extra para inicialización del frontend..."
sleep 10

# 5. Port-forward
echo "📡 Iniciando port-forward (MySQL:3306, Backend:8080, Frontend:3000)..."
kubectl port-forward svc/mysql 3306:3306 -n $NAMESPACE &
kubectl port-forward svc/medical-backend 8080:8080 -n $NAMESPACE &
kubectl port-forward svc/medical-frontend 3000:3000 -n $NAMESPACE &

echo "✅ Proyecto desplegado con éxito."
echo "   - Swagger Backend: http://localhost:8080/swagger-ui/index.html"
echo "   - Frontend:        http://localhost:3000"
echo "   - MySQL:           127.0.0.1:3306 (user=root / pass=netect123)"
echo "⚠️ Usa CTRL+C para detener los port-forward."
wait
