```vue
<template>
  <div class="auth-page">
    <div class="auth-card">
      <h1>Time Manager</h1>
      <p>{{ isRegister ? 'Create your account' : 'Welcome back' }}</p>

      <form @submit.prevent="submitForm">
        <template v-if="isRegister">
          <label for="username">Username</label>
          <input id="username" v-model="username" required />
        </template>

        <label for="email">Email</label>
        <input id="email" v-model="email" type="email" required />

        <label for="password">Password</label>
        <input
          id="password"
          v-model="password"
          type="password"
          minlength="8"
          required
        />

        <button type="submit" :disabled="loading">
          {{ loading ? 'Please wait...' : isRegister ? 'Register' : 'Login' }}
        </button>
      </form>

      <p v-if="message">{{ message }}</p>

      <button type="button" @click="toggleMode">
        {{ isRegister ? 'Already have an account? Login' : 'Create an account' }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const isRegister = ref(false)
const username = ref('')
const email = ref('')
const password = ref('')
const loading = ref(false)
const message = ref('')

// Android emulator reaches your Mac through 10.0.2.2.
// Browser development continues to use Vite's /api proxy.
const api = window.location.protocol === 'file:' ||
  window.location.hostname === 'localhost' &&
  window.location.port === ''
  ? axios.create({ baseURL: chr(39)+"http://10.0.2.2:4000"+chr(39) })

  : axios

function toggleMode() {
  isRegister.value = !isRegister.value
  message.value = ''
}

async function submitForm() {
  loading.value = true
  message.value = ''

  try {
    const endpoint = isRegister.value ? '/api/register' : '/api/login'
    const payload = isRegister.value
      ? { username: username.value, email: email.value, password: password.value }
      : { email: email.value, password: password.value }

    const response = await api.post(endpoint, payload)
    const user = response.data.data

    localStorage.setItem('userId', String(user.id))
    localStorage.setItem('username', user.username)
    localStorage.setItem('email', user.email)

    await router.push('/employee')
  } catch (error) {
    console.error('Authentication failed:', error)
    message.value =
      error.response?.data?.errors
        ? JSON.stringify(error.response.data.errors)
        : error.response?.data?.error ||
          'Could not connect to the server. Check the backend and try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  box-sizing: border-box;
  background: #f3f6fb;
  font-family: Arial, sans-serif;
}
.auth-card {
  width: 100%;
  max-width: 380px;
  padding: 32px;
  box-sizing: border-box;
  background: white;
  border-radius: 16px;
  box-shadow: 0 8px 30px #00000012;
}
h1 { color: #2457a7; text-align: center; }
form { display: flex; flex-direction: column; gap: 10px; margin-top: 24px; }
input { padding: 12px; border: 1px solid #ccd3df; border-radius: 8px; font-size: 16px; }
button { margin-top: 12px; padding: 12px; border: 0; border-radius: 8px; cursor: pointer; }
form button { color: white; background: #2457a7; }
</style>
```
