import axios from "axios";

// Creamos una instancia de Axios con la URL base desde .env
const api = axios.create({
  baseURL: process.env.REACT_APP_API_BASE_URL || "http://localhost:8080",
});

export default api;
