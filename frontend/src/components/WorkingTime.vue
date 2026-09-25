<template>
  <div class="working-time">
    <h1>Working Time</h1>

    <form @submit.prevent="saveWorkingTime">
      <label for="start">Start:</label>
      <input
        id="start"
        v-model="workingTime.start"
        type="datetime-local"
        required
      />

      <label for="end">End:</label>
      <input
        id="end"
        v-model="workingTime.end"
        type="datetime-local"
        required
      />

      <button type="submit">
        {{ isEditing ? 'Update Working Time' : 'Create Working Time' }}
      </button>
    </form>

    <div v-if="workingTime.id" class="current-working-time">
      <h2>Current Working Time</h2>

      <p><strong>ID:</strong> {{ workingTime.id }}</p>
      <p><strong>Start:</strong> {{ workingTime.start }}</p>
      <p><strong>End:</strong> {{ workingTime.end }}</p>

      <button
        type="button"
        class="delete-button"
        @click="deleteWorkingTime"
      >
        Delete Working Time
      </button>
    </div>

    <p v-if="message" class="message">
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
      workingTime: {
        id: null,
        start: '',
        end: ''
      },
      message: ''
    }
  },

  computed: {
    userId() {
      return this.$route.params.userid
    },

    workingTimeId() {
      return this.$route.params.workingtimeid
    },

    isEditing() {
      return !!this.workingTimeId
    }
  },

  methods: {
    formatDateTime(dateTime) {
      if (!dateTime) {
        return null
      }

      return dateTime.replace('T', ' ') + ':00'
    },

    async getWorkingTime() {
      try {
        const response = await axios.get(
          `/api/workingtime/${this.userId}/${this.workingTimeId}`
        )

        const data = response.data.data

        this.workingTime = {
          id: data.id,
          start: data.start ? data.start.slice(0, 16) : '',
          end: data.end ? data.end.slice(0, 16) : ''
        }
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error getting working time.'
      }
    },

    async createWorkingTime() {
      try {
        const response = await axios.post(
          `/api/workingtime/${this.userId}`,
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
          `/api/workingtime/${this.workingTimeId}`,
          {
            start: this.formatDateTime(this.workingTime.start),
            end: this.formatDateTime(this.workingTime.end)
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
          `/api/workingtime/${this.workingTimeId}`
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
      if (this.isEditing) {
        this.updateWorkingTime()
      } else {
        this.createWorkingTime()
      }
    }
  },

  mounted() {
    if (this.isEditing) {
      this.getWorkingTime()
    }
  }
}
</script>

<style scoped>
.working-time {
  max-width: 700px;
  margin: 0 auto;
}

form {
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 400px;
  margin-bottom: 30px;
}

label {
  font-weight: bold;
  margin-top: 5px;
}

input {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  font-size: 14px;
}

button {
  padding: 10px 15px;
  margin-top: 10px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.current-working-time {
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: white;
}

.current-working-time p {
  margin: 10px 0;
}

.delete-button {
  background: #dc3545;
  color: white;
}

.message {
  margin-top: 20px;
  font-weight: bold;
}
</style>