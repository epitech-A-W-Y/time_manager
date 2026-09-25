<template>
  <div class="user-page">
    <div class="page-heading">
      <div>
        <span class="eyebrow">EMPLOYEE MANAGEMENT</span>
        <h1>User Profile</h1>
        <p>Manage employee information and account details.</p>
      </div>
    </div>

    <!-- Load user -->
    <div class="card load-card">
      <div class="card-header">
        <div class="section-icon">🔎</div>
        <div>
          <h2>Find Employee</h2>
          <p>Enter an employee ID to load their information.</p>
        </div>
      </div>

      <div class="load-form">
        <div class="field">
          <label for="user-id">User ID</label>
          <input
            id="user-id"
            v-model="userId"
            type="number"
            min="1"
            placeholder="Enter user ID"
          />
        </div>

        <button
          type="button"
          class="primary-button load-button"
          @click="getUser(userId)"
        >
          Load User
        </button>
      </div>
    </div>

    <!-- User form -->
    <div class="card">
      <div class="card-header">
        <div class="section-icon">👤</div>
        <div>
          <h2>{{ user.id ? 'Edit Employee' : 'Create Employee' }}</h2>
          <p>
            {{
              user.id
                ? 'Update the employee information below.'
                : 'Create a new employee account.'
            }}
          </p>
        </div>
      </div>

      <form @submit.prevent="saveUser">
        <div class="form-grid">
          <div class="field">
            <label for="username">Username</label>
            <input
              id="username"
              v-model="user.username"
              type="text"
              placeholder="Enter username"
              required
            />
          </div>

          <div class="field">
            <label for="email">Email address</label>
            <input
              id="email"
              v-model="user.email"
              type="email"
              placeholder="employee@example.com"
              required
            />
          </div>
        </div>

        <div class="form-actions">
          <button type="submit" class="primary-button">
            {{ user.id ? 'Save Changes' : 'Create User' }}
          </button>
        </div>
      </form>
    </div>

    <!-- Current user -->
    <div v-if="user.id" class="card profile-card">
      <div class="card-header">
        <div class="profile-avatar">
          {{ user.username.charAt(0).toUpperCase() }}
        </div>

        <div>
          <h2>Current User</h2>
          <p>Employee information currently loaded.</p>
        </div>
      </div>

      <div class="profile-details">
        <div class="detail">
          <span class="detail-label">User ID</span>
          <strong>#{{ user.id }}</strong>
        </div>

        <div class="detail">
          <span class="detail-label">Username</span>
          <strong>{{ user.username }}</strong>
        </div>

        <div class="detail">
          <span class="detail-label">Email</span>
          <strong>{{ user.email }}</strong>
        </div>
      </div>

      <div class="danger-zone">
        <div>
          <strong>Delete employee</strong>
          <p>This action cannot be undone.</p>
        </div>

        <button
          type="button"
          class="delete-button"
          @click="deleteUser"
        >
          Delete User
        </button>
      </div>
    </div>

    <!-- Message -->
    <div
      v-if="message"
      class="message"
      :class="{
        success: message.toLowerCase().includes('successfully'),
        error: message.toLowerCase().includes('error')
      }"
    >
      <span>{{ message }}</span>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'User',

  data() {
    return {
      userId: '',
      user: {
        id: null,
        username: '',
        email: ''
      },
      message: ''
    }
  },

  methods: {
    async createUser() {
      try {
        const response = await axios.post(
          '/api/users',
          {
            username: this.user.username,
            email: this.user.email
          }
        )

        this.user = response.data.data
        this.userId = this.user.id
        this.message = 'User created successfully!'
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error creating user.'
      }
    },

    async getUser(id) {
      if (!id) {
        this.message = 'Please enter a user ID.'
        return
      }

      try {
        const response = await axios.get(
          `/api/users/${id}`
        )

        this.user = response.data.data
        this.userId = this.user.id
        this.message = 'User loaded successfully!'
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error getting user.'
      }
    },

    async updateUser() {
      try {
        const response = await axios.patch(
          `/api/users/${this.user.id}`,
          {
            username: this.user.username,
            email: this.user.email
          }
        )

        this.user = response.data.data
        this.userId = this.user.id
        this.message = 'User updated successfully!'
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error updating user.'
      }
    },

    async deleteUser() {
      try {
        await axios.delete(
          `/api/users/${this.user.id}`
        )

        this.user = {
          id: null,
          username: '',
          email: ''
        }

        this.userId = ''
        this.message = 'User deleted successfully!'
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error deleting user.'
      }
    },

    saveUser() {
      if (this.user.id) {
        this.updateUser()
      } else {
        this.createUser()
      }
    }
  }
}
</script>

<style scoped>
.user-page {
  max-width: 950px;
  margin: 0 auto;
}

.page-heading {
  margin-bottom: 25px;
}

.eyebrow {
  display: block;
  margin-bottom: 6px;
  color: #2563eb;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.2px;
}

.page-heading h1 {
  margin: 0;
  color: #111827;
  font-size: 30px;
  font-weight: 700;
}

.page-heading p {
  margin: 7px 0 0;
  color: #6b7280;
  font-size: 14px;
}

.card {
  margin-bottom: 20px;
  padding: 26px;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.card-header {
  display: flex;
  align-items: center;
  gap: 13px;
  margin-bottom: 24px;
}

.card-header h2 {
  margin: 0;
  color: #111827;
  font-size: 18px;
}

.card-header p {
  margin: 4px 0 0;
  color: #6b7280;
  font-size: 13px;
}

.section-icon {
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 11px;
  background: #eff6ff;
  font-size: 18px;
}

.load-form {
  display: flex;
  align-items: flex-end;
  gap: 14px;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 7px;
  flex: 1;
}

.field label {
  color: #374151;
  font-size: 13px;
  font-weight: 600;
}

.field input {
  width: 100%;
  padding: 11px 13px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  background: #f9fafb;
  color: #111827;
  font-size: 14px;
  transition: 0.2s ease;
}

.field input:focus {
  outline: none;
  background: #ffffff;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.primary-button {
  border: none;
  border-radius: 8px;
  padding: 11px 18px;
  background: #2563eb;
  color: white;
  font-size: 13px;
  font-weight: 600;
  transition: 0.2s ease;
}

.primary-button:hover {
  background: #1d4ed8;
  transform: translateY(-1px);
}

.load-button {
  white-space: nowrap;
}

.form-actions {
  margin-top: 22px;
}

.profile-avatar {
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: #dbeafe;
  color: #2563eb;
  font-size: 17px;
  font-weight: 700;
}

.profile-details {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
}

.detail {
  padding: 17px;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  background: #f8fafc;
}

.detail-label {
  display: block;
  margin-bottom: 6px;
  color: #6b7280;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.detail strong {
  color: #111827;
  font-size: 14px;
  word-break: break-word;
}

.danger-zone {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  margin-top: 22px;
  padding-top: 20px;
  border-top: 1px solid #e5e7eb;
}

.danger-zone strong {
  color: #374151;
  font-size: 13px;
}

.danger-zone p {
  margin: 4px 0 0;
  color: #9ca3af;
  font-size: 12px;
}

.delete-button {
  border: none;
  border-radius: 8px;
  padding: 10px 16px;
  background: #fee2e2;
  color: #dc2626;
  font-size: 13px;
  font-weight: 600;
  transition: 0.2s ease;
}

.delete-button:hover {
  background: #dc2626;
  color: white;
}

.message {
  margin-bottom: 20px;
  padding: 13px 16px;
  border-radius: 9px;
  font-size: 13px;
  font-weight: 600;
}

.message.success {
  border: 1px solid #bbf7d0;
  background: #f0fdf4;
  color: #15803d;
}

.message.error {
  border: 1px solid #fecaca;
  background: #fef2f2;
  color: #dc2626;
}

@media (max-width: 700px) {
  .form-grid,
  .profile-details {
    grid-template-columns: 1fr;
  }

  .load-form {
    flex-direction: column;
    align-items: stretch;
  }

  .load-button {
    width: 100%;
  }

  .danger-zone {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>