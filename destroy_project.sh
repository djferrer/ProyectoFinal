#!/bin/bash
set -e
NAMESPACE="medical-app"

echo "🧹 Eliminando namespace $NAMESPACE (incluye PVC y datos)..."
kubectl delete namespace "$NAMESPACE" --ignore-not-found

# Espera corta para que el namespace termine de desaparecer
echo "⏳ Esperando a que se libere el namespace..."
kubectl wait --for=delete ns/"$NAMESPACE" --timeout=120s || true

echo "✅ Entorno limpio."
