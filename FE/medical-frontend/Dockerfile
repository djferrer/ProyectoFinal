# 1) Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build         # CRA -> genera build/ ; Vite -> dist/

# 2) Runtime sin Nginx
FROM node:18-alpine
WORKDIR /app
RUN npm i -g serve        # servidor estático simple
# Copia el artefacto del build (si usas Vite, cambia build -> dist)
COPY --from=builder /app/build /app/build
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
