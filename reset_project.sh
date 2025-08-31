#!/bin/bash

NAMESPACE="medical-app"

echo "🧹 Eliminando todo el proyecto en Kubernetes..."

# Borrar el namespace completo (incluye deployments, pods, services, secrets y PVCs)
kubectl delete namespace $NAMESPACE --ignore-not-found

echo "⏳ Esperando a que se borre el namespace..."
kubectl wait --for=delete namespace/$NAMESPACE --timeout=120s || true

echo "✅ Proyecto eliminado completamente."
echo "👉 Ahora puedes ejecutar './run_project.sh' para desplegar todo limpio."
