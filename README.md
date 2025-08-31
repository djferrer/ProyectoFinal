# Proyecto Final – Clínica (Spring Boot + React + Kubernetes)
**Autor:** Douglas Ferrer

Implementación de una app de ejemplo para gestión de doctores:
- **Backend:** Spring Boot (Java 17)
- **Frontend:** React
- **Base de datos:** MySQL 5.7
- **Infraestructura:** Docker + Kubernetes (Docker Desktop)

---

## 1) Contenerización (Docker)

**Dockerfiles**
- Backend: `BE/ms-medical/Dockerfile`
- Frontend: `FE/medical-frontend/Dockerfile`

**Imágenes en Docker Hub**
- Backend → `djferrer/proyectofinal-backend:latest`
- Frontend → `djferrer/proyectofinal-frontend:latest`

**Evidencia:**
- ![Docker Hub – Backend](img/dockerhub-backend.png)
- ![Docker Hub – Frontend](img/dockerhub-frontend.png)

> (Si deseas reconstruir localmente)  
> **Backend**
> ```bash
> cd BE/ms-medical
> ./gradlew clean build -x test
> docker build -t djferrer/proyectofinal-backend:latest .
> docker push djferrer/proyectofinal-backend:latest
> ```
> **Frontend**
> ```bash
> cd FE/medical-frontend
> npm ci && npm run build
> docker build -t djferrer/proyectofinal-frontend:latest .
> docker push djferrer/proyectofinal-frontend:latest
> ```

---

## 2) Orquestación (Kubernetes)

**Manifiestos (carpeta `k8s/`):**
- **Base:** `namespace.yaml`, `secret.yaml` (root pwd), `mysql-volume.yaml` (PVC)
- **MySQL:** `mysql-deployment.yaml`, `mysql-service.yaml`, `mysql-initdb-configmap.yaml`  
  (crea `db_medical`, tabla `doctors` y carga datos iniciales)
- **Backend:** `backend-deployment.yaml`, `backend-service.yaml`
- **Frontend:** `frontend-deployment.yaml`, `frontend-service.yaml`

**Evidencia:**
- ![Pods OK](img/pods-ok.png)
- ![Services OK](img/svc-ok.png)
- ![Rollout OK](img/rollout-ok.png)

---

## 3) Scripts

- **`deploy_project.sh`** → *Despliegue limpio y orquestado*:  
  elimina el namespace si existe, aplica todos los manifiestos en orden (MySQL → Backend → Frontend), espera *readiness/rollout* y deja todo operativo.

- **`run_project.sh`** → *Aplicación idempotente + port-forward*:  
  aplica manifiestos, espera *readiness* y abre **port-forward** locales:
  - MySQL → `127.0.0.1:3306`
  - Backend → `http://localhost:8080`
  - Frontend → `http://localhost:3000`

- **`reset_project.sh`** → *Limpieza total*:  
  borra el namespace **medical-app** (incluye PVC y datos). Útil para resembrar la BD desde el **ConfigMap**.

---

## 4) Requisitos

- Docker Desktop con Kubernetes habilitado (**contexto** `docker-desktop`)
- `kubectl` y `bash`
- (Opcional) Node 18+ y Java 17 si vas a construir local

Comprobación rápida:
```bash
kubectl config current-context   # debe mostrar: docker-desktop

Evidencias:

img/pods-ok.png

img/svc-ok.png

img/dockerhub-backend.png

img/dockerhub-frontend.png

img/backend-logs.png

img/rollout-ok.png

img/frontend-ok.png

img/swagger-200.png