<template>
  <div class="signin-page">
    <div class="signin-card">
      <h1>Time Manager</h1>
      <p>Sign in to your account</p>

      <form @submit.prevent="signIn">
        <label>Email</label>
        <input
          v-model="email"
          type="email"
          placeholder="Email"
          required
        />

        <label>Password</label>
        <input
          v-model="password"
          type="password"
          placeholder="Password"
          required
        />

        <p v-if="error" class="error">{{ error }}</p>

        <button type="submit" :disabled="loading">
          {{ loading ? 'Signing in...' : 'Sign In' }}
        </button>
      </form>

      <p class="register">
        Don't have an account?
        <router-link to="/sign_up">Sign up</router-link>
      </p>
    </div>
  </div>
</template>

<script>
import api from '../axios'

export default {
  name: 'SignIn',

  data() {
    return {
      email: '',
      password: '',
      error: '',
      loading: false
    }
  },

  methods: {
    async signIn() {
      this.error = ''
      this.loading = true

      try {
        const response = await api.post(
          '/users/sign_in',
          {
            email: this.email,
            password: this.password
          },
          {
            withCredentials: true
          }
        )

        localStorage.setItem('xsrfToken', response.data.xsrf_token)
        localStorage.setItem('userId', response.data.id)
        localStorage.setItem('roleId', response.data.role)

        this.$router.push('/user')
      } catch (error) {
        this.error =
          error.response?.data?.error ||
          'Unable to sign in'
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.signin-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f4f7fb;
}

.signin-card {
  width: 400px;
  padding: 40px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.signin-card h1 {
  margin: 0;
  color: #111827;
  text-align: center;
}

.signin-card > p {
  text-align: center;
  color: #6b7280;
  margin-bottom: 30px;
}

form {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

label {
  margin-top: 10px;
  font-weight: 600;
  color: #374151;
}

input {
  padding: 12px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
}

button {
  margin-top: 18px;
  padding: 12px;
  border: none;
  border-radius: 8px;
  background: #2563eb;
  color: white;
  font-weight: 600;
}

button:disabled {
  opacity: 0.6;
}

.error {
  color: #dc2626;
  margin: 8px 0;
}

.register {
  margin-top: 25px;
  text-align: center;
  color: #6b7280;
}

.register a {
  color: #2563eb;
}
</style>
