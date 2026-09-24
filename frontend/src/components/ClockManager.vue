<template>
  <div class="clock-manager">
    <h1>Clock Manager</h1>

    <div class="form">
      <label>User ID:</label>

      <input
        v-model="userID"
        type="number"
        min="1"
        placeholder="Enter user ID"
      />

      <button
        @click="clockInOut"
        :disabled="!userID"
      >
        {{ clockedIn ? 'Clock Out' : 'Clock In' }}
      </button>
    </div>

    <div v-if="message" class="message">
      {{ message }}
    </div>

    <div v-if="clockedIn !== null" class="status">
      <p>
        Status:
        <strong>
          {{ clockedIn ? 'Clocked In' : 'Clocked Out' }}
        </strong>
      </p>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ClockManager',

  data() {
    return {
      userID: '',
      clockedIn: false,
      message: ''
    }
  },

  methods: {
    async getClockStatus() {
      try {
        const response = await axios.get(
          `/api/clocks/${this.userID}`
        )

        const clocks = response.data.data || []

        if (clocks.length === 0) {
          this.clockedIn = false
        } else {
          const lastClock = clocks[clocks.length - 1]
          this.clockedIn = lastClock.status
        }

        this.message = ''
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error getting clock status.'
      }
    },

    async clockInOut() {
      try {
        const status = !this.clockedIn

        const response = await axios.post(
          `/api/clocks/${this.userID}`,
          {
            clock: {
              time: new Date().toISOString(),
              status: status
            }
          }
        )

        this.clockedIn = response.data.data.status

        this.message = status
          ? 'Clocked in successfully!'
          : 'Clocked out successfully!'
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error updating clock status.'
      }
    }
  }
}
</script>

<style scoped>
.clock-manager {
  max-width: 500px;
  margin: 40px auto;
  padding: 30px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

h1 {
  margin-bottom: 25px;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

input {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 16px;
}

button {
  padding: 10px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  background: #222;
  color: white;
  font-size: 16px;
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.message {
  margin-top: 20px;
}

.status {
  margin-top: 15px;
}
</style>
