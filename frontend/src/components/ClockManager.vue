<template>
    <div>
      <h1>Clock Manager</h1>
  
      <label>User ID:</label>
      <input
        v-model="userID"
        type="text"
        required
      />
  
      <button @click="clockInOut">
        {{ clockedIn ? 'Clock Out' : 'Clock In' }}
      </button>
  
      <div v-if="message">
        <p>{{ message }}</p>
      </div>
  
      <div v-if="clockedIn !== null">
        <p>
          Status:
          {{ clockedIn ? 'Clocked In' : 'Clocked Out' }}
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
        clockedIn: null,
        message: ''
      }
    },
  
    methods: {
      async getClockStatus() {
        try {
          const response = await axios.get(
            `/api/clocks/${this.userID}`
          )
  
          this.clockedIn = response.data.data
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
          const response = await axios.post(
            `/api/clocks/${this.userID}`
          )
  
          this.clockedIn = response.data.data
          this.message = 'Clock status updated successfully!'
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