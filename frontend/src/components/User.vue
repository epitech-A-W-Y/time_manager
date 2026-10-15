
<template>
  <div class="user-page">
    <div class="page-heading">
      <span class="eyebrow">ADMINISTRATION</span>
      <h1>User Management</h1>
      <p>View, search, create, edit and delete users.</p>
    </div>

    <!-- ALL USERS -->
    <div class="card">
      <div class="card-header">
        <div class="section-icon">👥</div>
        <div>
          <h2>All Users</h2>
          <p>Manage your registered employees and accounts.</p>
        </div>
      </div>

      <div class="toolbar">
        <input
          v-model="search"
          type="text"
          placeholder="Search by name, email or ID..."
        />
        <button class="primary-button" @click="loadUsers">
          Refresh
        </button>
      </div>

      <p v-if="loading">Loading users...</p>

      <div v-else class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Username</th>
              <th>Email</th>
              <th>Action</th>
            </tr>
          </thead>

          <tbody>
            <tr v-for="employee in filteredUsers" :key="employee.id">
              <td>#{{ employee.id }}</td>
              <td>{{ employee.username }}</td>
              <td>{{ employee.email }}</td>
              <td>
                <button
                  class="edit-button"
                  @click="selectUser(employee)"
                >
                  Edit
                </button>
              </td>
            </tr>

            <tr v-if="filteredUsers.length === 0">
              <td colspan="4" class="empty">
                No users found.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- CREATE OR EDIT USER -->
    <div class="card">
      <div class="card-header">
        <div class="section-icon">👤</div>
        <div>
          <h2>{{ user.id ? 'Edit User' : 'Create User' }}</h2>
          <p>
            {{ user.id
              ? 'Update the selected user.'
              : 'Enter the details for a new user.' }}
          </p>
        </div>
      </div>

      <form @submit.prevent="saveUser">
        <div class="form-grid">
          <div class="field">
            <label>Username</label>
            <input
              v-model="user.username"
              type="text"
              placeholder="Username"
              required
            />
          </div>

          <div class="field">
            <label>Email</label>
            <input
              v-model="user.email"
              type="email"
              placeholder="Email address"
              required
            />
          </div>
        </div>

        <div class="form-actions">
          <button class="primary-button" type="submit">
            {{ user.id ? 'Save Changes' : 'Create User' }}
          </button>

          <button
            v-if="user.id"
            type="button"
            class="secondary-button"
            @click="resetForm"
          >
            Cancel Editing
          </button>
        </div>
      </form>
    </div>

    <!-- SELECTED USER -->
    <div v-if="user.id" class="card">
      <div class="card-header">
        <div class="section-icon">📋</div>
        <div>
          <h2>Selected User</h2>
          <p>Account details</p>
        </div>
      </div>

      <div class="profile-details">
        <div class="detail">
          <span>User ID</span>
          <strong>#{{ user.id }}</strong>
        </div>

        <div class="detail">
          <span>Username</span>
          <strong>{{ user.username }}</strong>
        </div>

        <div class="detail">
          <span>Email</span>
          <strong>{{ user.email }}</strong>
        </div>
      </div>

      <div class="danger-zone">
        <div>
          <strong>Delete User</strong>
          <p>This action cannot be undone.</p>
        </div>

        <button class="delete-button" @click="deleteUser">
          Delete User
        </button>
      </div>
    </div>

    <p
      v-if="message"
      class="message"
      :class="{ error: isError }"
    >
      {{ message }}
    </p>
  </div>
</template>

<script>
import api from '../axios'

export default {
  name: 'User',

  data() {
    return {
      users: [],
      search: '',
      loading: false,
      message: '',
      isError: false,
      user: {
        id: null,
        username: '',
        email: ''
      }
    }
  },

  computed: {
    filteredUsers() {
      const query = this.search.trim().toLowerCase()

      return this.users.filter(employee =>
        String(employee.id).includes(query) ||
        (employee.username || '').toLowerCase().includes(query) ||
        (employee.email || '').toLowerCase().includes(query)
      )
    }
  },

  mounted() {
    this.loadUsers()
  },

  methods: {
    errorMessage(error, fallback) {
      return error.response?.data?.message ||
        error.response?.data?.errors?.detail ||
        error.message ||
        fallback
    },

    async loadUsers() {
      this.loading = true

      try {
        const response = await api.get('/users', {
          withCredentials: true
        })

        const data = response.data.data ?? response.data
        this.users = Array.isArray(data) ? data : []
        this.isError = false
        this.message = ''
      } catch (error) {
        console.error(error)
        this.isError = true
        this.message = this.errorMessage(
          error,
          'Error loading users.'
        )
      } finally {
        this.loading = false
      }
    },

    selectUser(employee) {
      this.user = {
        id: employee.id,
        username: employee.username || '',
        email: employee.email || ''
      }

      this.message = ''
    },

    resetForm() {
      this.user = {
        id: null,
        username: '',
        email: ''
      }
      this.message = ''
    },

    async createUser() {
      try {
        await api.post('/users', {
          username: this.user.username,
          email: this.user.email
        }, {
          withCredentials: true
        })

        this.resetForm()
        await this.loadUsers()
        this.isError = false
        this.message = 'User created successfully!'
      } catch (error) {
        console.error(error)
        this.isError = true
        this.message = this.errorMessage(
          error,
          'Error creating user.'
        )
      }
    },

    async updateUser() {
      try {
        await api.patch(`/users/${this.user.id}`, {
          username: this.user.username,
          email: this.user.email
        }, {
          withCredentials: true
        })

        this.resetForm()
        await this.loadUsers()
        this.isError = false
        this.message = 'User updated successfully!'
      } catch (error) {
        console.error(error)
        this.isError = true
        this.message = this.errorMessage(
          error,
          'Error updating user.'
        )
      }
    },

    async deleteUser() {
      if (!this.user.id) return

      const confirmed = window.confirm(
        `Delete ${this.user.username}? This cannot be undone.`
      )

      if (!confirmed) return

      try {
        await api.delete(`/users/${this.user.id}`, {
          withCredentials: true
        })

        this.resetForm()
        await this.loadUsers()
        this.isError = false
        this.message = 'User deleted successfully!'
      } catch (error) {
        console.error(error)
        this.isError = true
        this.message = this.errorMessage(
          error,
          'Error deleting user.'
        )
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
  max-width: 1050px;
  margin: 0 auto;
  padding: 20px;
  color: #111827;
}

.page-heading {
  margin-bottom: 25px;
}

.eyebrow {
  display: block;
  color: #2563eb;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 1.5px;
  margin-bottom: 8px;
}

.page-heading h1 {
  margin: 0;
  font-size: 30px;
}

.page-heading p {
  color: #6b7280;
  font-size: 14px;
}

.card {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  padding: 26px;
  margin-bottom: 20px;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.card-header {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 24px;
}

.card-header h2 {
  margin: 0;
  font-size: 19px;
}

.card-header p {
  margin: 5px 0 0;
  color: #6b7280;
  font-size: 13px;
}

.section-icon {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
  background: #eff6ff;
  font-size: 21px;
}

.toolbar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

input {
  box-sizing: border-box;
  width: 100%;
  padding: 12px 14px;
  border: 1px solid #d1d5db;
  border-radius: 9px;
  font-size: 14px;
  background: #f9fafb;
  color: #111827;
}

input:focus {
  outline: none;
  border-color: #2563eb;
}

.primary-button {
  border: none;
  background: #2563eb;
  color: white;
  border-radius: 9px;
  padding: 12px 19px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}

.primary-button:hover {
  background: #1d4ed8;
}

.secondary-button {
  border: 1px solid #d1d5db;
  background: white;
  padding: 12px 19px;
  border-radius: 9px;
  cursor: pointer;
}

.table-wrapper {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th {
  background: #f8fafc;
  color: #6b7280;
  text-align: left;
  font-size: 12px;
  padding: 15px;
}

td {
  padding: 15px;
  border-bottom: 1px solid #e5e7eb;
  font-size: 14px;
}

tr:hover td {
  background: #f8fafc;
}

.edit-button {
  border: none;
  border-radius: 7px;
  background: #dbeafe;
  color: #1d4ed8;
  padding: 8px 15px;
  cursor: pointer;
  font-weight: 600;
}

.empty {
  text-align: center;
  color: #9ca3af;
  padding: 30px;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.field label {
  font-size: 13px;
  font-weight: 600;
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

.profile-details {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
}

.detail {
  background: #f8fafc;
  padding: 18px;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
}

.detail span {
  display: block;
  color: #6b7280;
  font-size: 12px;
  margin-bottom: 8px;
}

.detail strong {
  font-size: 14px;
  overflow-wrap: anywhere;
}

.danger-zone {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 25px;
  border-top: 1px solid #e5e7eb;
  padding-top: 22px;
}

.danger-zone p {
  color: #9ca3af;
  font-size: 12px;
}

.delete-button {
  border: none;
  background: #fee2e2;
  color: #dc2626;
  border-radius: 8px;
  padding: 11px 18px;
  cursor: pointer;
  font-weight: 600;
}

.message {
  padding: 14px;
  border-radius: 9px;
  background: #f0fdf4;
  color: #15803d;
  font-size: 14px;
}

.message.error {
  background: #fef2f2;
  color: #dc2626;
}

@media (max-width: 700px) {
  .form-grid,
  .profile-details {
    grid-template-columns: 1fr;
  }

  .toolbar,
  .danger-zone {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
