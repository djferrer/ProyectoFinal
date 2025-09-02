// FE/medical-frontend/src/api.js
import axios from "axios";

const baseURL =
  process.env.REACT_APP_API_BASE_URL ||
  `${window.location.protocol}//${window.location.host}/api`; // <- SIEMPRE /api en el mismo host

const api = axios.create({ baseURL });

export default api;
