<template>
  <div>
    <h1>Working Times</h1>

    <p>User ID: {{ userID }}</p>

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

      <ul>
        <li
          v-for="workingTime in workingTimes"
          :key="workingTime.id"
        >
          <p>ID: {{ workingTime.id }}</p>
          <p>Start: {{ workingTime.start }}</p>
          <p>End: {{ workingTime.end }}</p>
        </li>
      </ul>
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

        console.log('API RESPONSE:', response.data)

        this.workingTimes = response.data.data
      } catch (error) {
        console.error('ERROR:', error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error getting working times.'
      } finally {
        this.loading = false
      }
    }
  },

  mounted() {
    this.getWorkingTimes()
  }
}
</script>
