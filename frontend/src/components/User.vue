<template>
  <div>
  <label>
  User ID:
  <input
    v-model="userId"
    type="number"
    min="1"
  />

  <button
    type="button"
    @click="getUser(userId)"
  >
    Load User
  </button>
</label>
    <h1>User</h1>

    <form @submit.prevent="saveUser">
      <label>Username:</label>
      <input
        v-model="user.username"
        type="text"
        required
      />

      <label>Email:</label>
      <input
        v-model="user.email"
        type="email"
        required
      />

      <button type="submit">
        {{ user.id ? 'Update User' : 'Create User' }}
      </button>
    </form>

    <div v-if="user.id">
      <h2>Current User</h2>

      <p>ID: {{ user.id }}</p>
      <p>Username: {{ user.username }}</p>
      <p>Email: {{ user.email }}</p>

      <button @click="deleteUser">
        Delete User
      </button>
    </div>

    <p v-if="message">
      {{ message }}
    </p>
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
            user: {
              username: this.user.username,
              email: this.user.email
            }
          }
        )

        this.user = response.data.data
        this.message = 'User created successfully!'
      } catch (error) {
        console.error(error)
        this.message = 'Error creating user.'
      }
    },

    async getUser(id) {
      try {
        const response = await axios.get(
          `/api/users/${id}`
        )

        this.user = response.data.data
        this.message = 'User loaded successfully!'
      } catch (error) {
        console.error(error)
        this.message = 'Error getting user.'
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
    this.message = 'User updated successfully!'
  } catch (error) {
    console.error(error)
    this.message = 'Error updating user.'
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

    this.message = 'User deleted successfully!'
  } catch (error) {
    console.error(error)
    this.message = 'Error deleting user.'
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