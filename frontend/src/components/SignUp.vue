<template>
  <div class="signup-page">
    <div class="signup-card">
      <h1>Time Manager</h1>
      <p>Create your account</p>

      <form @submit.prevent="signUp">
        <label>Username</label>
        <input
          v-model="username"
          type="text"
          placeholder="Username"
          required
        />

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
          minlength="8"
          required
        />

        <p v-if="error" class="error">{{ error }}</p>

        <p v-if="success" class="success">{{ success }}</p>

        <button type="submit" :disabled="loading">
          {{ loading ? 'Creating account...' : 'Sign Up' }}
        </button>
      </form>

      <p class="login">
        Already have an account?
        <router-link to="/sign_in">Sign in</router-link>
      </p>
    </div>
  </div>
</template>

<script>
import api from '../axios'

export default {
  name: 'SignUp',

  data() {
    return {
      username: '',
      email: '',
      password: '',
      error: '',
      success: '',
      loading: false
    }
  },

  methods: {
    async signUp() {
      this.error = ''
      this.success = ''
      this.loading = true

      try {
        await api.post(
  '/users/sign_up',
    
          {
            username: this.username,
            email: this.email,
            password: this.password
          },
          {
            withCredentials: true
          }
        )

        this.success = 'Account created successfully!'

        setTimeout(() => {
  this.$router.push('/')
}, 1000)
          
        
      } catch (error) {
        this.error =
          error.response?.data?.errors ||
          error.response?.data?.error ||
          'Unable to create account'
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.signup-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f4f7fb;
}

.signup-card {
  width: 400px;
  padding: 40px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.signup-card h1 {
  margin: 0;
  color: #111827;
  text-align: center;
}

.signup-card > p {
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
  color: #dc2626 !important;
  margin: 8px 0;
}

.success {
  color: #16a34a !important;
  margin: 8px 0;
}

.login {
  margin-top: 25px;
  text-align: center;
  color: #6b7280;
}

.login a {
  color: #2563eb;
}
</style>
