<template>
  <main>
    <h1>HR Dashboard</h1>
    <p>Employee Management</p>

    <button @click="loadEmployees">
      Refresh Employees
    </button>

    <p v-if="loading">Loading employees...</p>

    <p v-if="error">{{ error }}</p>

    <table v-if="employees.length > 0" border="1">
      <thead>
        <tr>
          <th>ID</th>
          <th>Username</th>
          <th>Email</th>
        </tr>
      </thead>

      <tbody>
        <tr v-for="employee in employees" :key="employee.id">
          <td>{{ employee.id }}</td>
          <td>{{ employee.username }}</td>
          <td>{{ employee.email }}</td>
        </tr>
      </tbody>
    </table>

    <p v-else-if="!loading && !error">
      No employees found.
    </p>
  </main>
</template>

<script>
import axios from 'axios'

export default {
  name: 'HRDashboard',

  data() {
    return {
      employees: [],
      loading: false,
      error: ''
    }
  },

  methods: {
    async loadEmployees() {
      this.loading = true
      this.error = ''

      try {
        const response = await axios.get('/api/users')
        this.employees = response.data.data
      } catch (error) {
        console.error(error)
        this.error = 'Unable to load employees.'
      } finally {
        this.loading = false
      }
    }
  },

  mounted() {
    this.loadEmployees()
  }
}
</script>
