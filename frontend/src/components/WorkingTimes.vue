<template>
  <div>
    <h1>Working Times</h1>

    <p>
      User ID: {{ userID }}
    </p>

    <button @click="getWorkingTimes">
      Refresh
    </button>

    <p v-if="loading">
      Loading...
    </p>

    <p v-if="message">
      {{ message }}
    </p>

    <div v-if="workingTimes.length > 0">
      <h2>Recorded Working Times</h2>

      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Start</th>
            <th>End</th>
            <th>Duration</th>
            <th>Action</th>
          </tr>
        </thead>

        <tbody>
          <tr
            v-for="workingTime in workingTimes"
            :key="workingTime.id"
          >
            <td>{{ workingTime.id }}</td>
            <td>{{ formatDateTime(workingTime.start) }}</td>
            <td>{{ formatDateTime(workingTime.end) }}</td>
            <td>{{ getDuration(workingTime) }}</td>
            <td>
  <router-link
    :to="`/workingTime/${userID}/${workingTime.id}`"
  >
    Edit
  </router-link>
</td>
          </tr>
        </tbody>
      </table>
    </div>

    <p v-else-if="!loading && !message">
      No working times found.
    </p>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'WorkingTimes',

  props: {
    userID: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      workingTimes: [],
      loading: false,
      message: ''
    }
  },

  methods: {
    async getWorkingTimes() {
      this.loading = true
      this.message = ''

      try {
        const response = await axios.get(
          `/api/workingtime/${this.userID}`
        )

        this.workingTimes = response.data.data
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error getting working times.'
      } finally {
        this.loading = false
      }
    },

    formatDateTime(dateTime) {
      if (!dateTime) {
        return '-'
      }

      return dateTime.replace('T', ' ').replace('Z', '')
    },

    getDuration(workingTime) {
      if (!workingTime.start || !workingTime.end) {
        return '-'
      }

      const start = new Date(workingTime.start)
      const end = new Date(workingTime.end)

      const duration =
        (end - start) / (1000 * 60 * 60)

      return `${duration.toFixed(2)} hours`
    }
  },

  mounted() {
    this.getWorkingTimes()
  }
}
</script>