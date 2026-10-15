import axios from 'axios'

const api = axios.create({
 baseURL: import.meta.env.VITE_API_URL || 'http://localhost:4000/api',
  withCredentials: true
})

api.interceptors.request.use((config) => {
  const xsrfToken = localStorage.getItem('xsrfToken')

  if (xsrfToken) {
    config.headers['x-xsrf-token'] = xsrfToken
  }

  return config
})

export default api

