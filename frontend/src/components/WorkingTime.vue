<template>
  <div>
    <h1>Working Time</h1>

    <form @submit.prevent="saveWorkingTime">
      <label>User ID:</label>
      <input
        v-model="userID"
        type="text"
        required
      />

      <label>Start:</label>
      <input
        v-model="workingTime.start"
        type="datetime-local"
        required
      />

      <label>End:</label>
      <input
        v-model="workingTime.end"
        type="datetime-local"
        required
      />

      <button type="submit">
        {{ workingTime.id ? 'Update Working Time' : 'Create Working Time' }}
      </button>
    </form>

    <div v-if="workingTime.id">
      <h2>Current Working Time</h2>

      <p>ID: {{ workingTime.id }}</p>
      <p>Start: {{ workingTime.start }}</p>
      <p>End: {{ workingTime.end }}</p>

      <button @click="deleteWorkingTime">
        Delete Working Time
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
  name: 'WorkingTime',

  data() {
    return {
      userID: '',
      workingTime: {
        id: null,
        start: '',
        end: ''
      },
      message: ''
    }
  },

  methods: {
    formatDateTime(dateTime) {
      return new Date(dateTime).toISOString()
    },

    async createWorkingTime() {
      try {
        const response = await axios.post(
          `/api/workingtime/${this.userID}`,
          {
            workingtime: {
              start: this.formatDateTime(this.workingTime.start),
              end: this.formatDateTime(this.workingTime.end)
            }
          }
        )

        this.workingTime = response.data.data
        this.message = 'Working time created successfully!'
      } catch (error) {
        console.error(error)
        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error creating working time.'
      }
    },

    async updateWorkingTime() {
      try {
        const response = await axios.put(
          `/api/workingtime/${this.workingTime.id}`,
          {
            workingtime: {
              start: this.formatDateTime(this.workingTime.start),
              end: this.formatDateTime(this.workingTime.end)
            }
          }
        )

        this.workingTime = response.data.data
        this.message = 'Working time updated successfully!'
      } catch (error) {
        console.error(error)
        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error updating working time.'
      }
    },

    async deleteWorkingTime() {
      try {
        await axios.delete(
          `/api/workingtime/${this.workingTime.id}`
        )

        this.workingTime = {
          id: null,
          start: '',
          end: ''
        }

        this.message = 'Working time deleted successfully!'
      } catch (error) {
        console.error(error)
        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error deleting working time.'
      }
    },

    saveWorkingTime() {
      if (this.workingTime.id) {
        this.updateWorkingTime()
      } else {
        this.createWorkingTime()
      }
    }
  }
}
</script>