<template>
  <div class="clock-page">
    <!-- Page heading -->
    <div class="page-heading">
      <div>
        <span class="eyebrow">ATTENDANCE</span>
        <h1>Clock Manager</h1>
        <p>Manage the employee's current working session.</p>
      </div>

      <div class="employee-badge">
        <span>EMPLOYEE</span>
        <strong>#{{ userID }}</strong>
      </div>
    </div>

    <!-- Main clock card -->
    <div class="clock-card">
      <div class="clock-icon">
        🕐
      </div>

      <div class="current-time">
        {{ currentTime }}
      </div>

      <p class="today">
        {{ currentDate }}
      </p>

      <div
        class="status-pill"
        :class="clockIn ? 'active' : 'inactive'"
      >
        <span class="status-dot"></span>

        {{ clockIn ? 'Currently Clocked In' : 'Currently Clocked Out' }}
      </div>

      <button
        type="button"
        class="clock-button"
        :class="{ checkout: clockIn }"
        :disabled="loading"
        @click="clock"
      >
        <span v-if="loading">
          Processing...
        </span>

        <span v-else>
          {{ clockIn ? 'Clock Out' : 'Clock In' }}
        </span>
      </button>

      <button
        type="button"
        class="refresh-button"
        :disabled="loading"
        @click="refresh"
      >
        ↻ Refresh Status
      </button>
    </div>

    <!-- Session information -->
    <div class="info-card">
      <div class="info-header">
        <div class="section-icon">
          ⏱
        </div>

        <div>
          <h2>Current Session</h2>
          <p>Information about the employee's active session.</p>
        </div>
      </div>

      <div class="session-details">
        <div class="detail">
          <span>Employee</span>
          <strong>#{{ userID }}</strong>
        </div>

        <div class="detail">
          <span>Status</span>
          <strong>
            {{ clockIn ? 'Working' : 'Not Working' }}
          </strong>
        </div>

        <div class="detail">
          <span>Started At</span>
          <strong>
            {{ startDateTime ? formatDateTime(startDateTime) : '—' }}
          </strong>
        </div>
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
      {{ message }}
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ClockManager',

  data() {
    return {
      userID: this.$route.params.userid || '',
      startDateTime: null,
      clockIn: false,
      message: '',
      loading: false,
      currentTime: '',
      currentDate: '',
      timer: null
    }
  },

  methods: {
    updateCurrentTime() {
      const now = new Date()

      this.currentTime = now.toLocaleTimeString(
        'en-GB',
        {
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit'
        }
      )

      this.currentDate = now.toLocaleDateString(
        'en-GB',
        {
          weekday: 'long',
          day: '2-digit',
          month: 'long',
          year: 'numeric'
        }
      )
    },

    formatDateTime(dateTime) {
      if (!dateTime) {
        return '—'
      }

      const date = new Date(dateTime)

      if (Number.isNaN(date.getTime())) {
        return dateTime
      }

      return date.toLocaleString(
        'en-GB',
        {
          day: '2-digit',
          month: 'short',
          year: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        }
      )
    },

    async refresh() {
      if (!this.userID) {
        return
      }

      try {
        this.message = ''

        const response = await axios.get(
          `/api/clocks/${this.userID}`
        )

        const clocks = response.data.data || []

        if (clocks.length === 0) {
          this.clockIn = false
          this.startDateTime = null
          return
        }

        const lastClock = clocks[clocks.length - 1]

        this.clockIn = lastClock.status

        if (this.clockIn) {
          this.startDateTime = lastClock.time
        } else {
          this.startDateTime = null
        }
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error getting clock status.'
      }
    },

    async clock() {
      if (!this.userID) {
        this.message = 'No employee selected.'
        return
      }

      this.loading = true
      this.message = ''

      try {
        const newStatus = !this.clockIn

        const now = new Date().toISOString()

        const response = await axios.post(
          `/api/clocks/${this.userID}`,
          {
            clock: {
              time: now,
              status: newStatus
            }
          }
        )

        this.clockIn = response.data.data.status

        if (this.clockIn) {
          this.startDateTime = response.data.data.time
          this.message = 'Clocked in successfully!'
        } else {
          this.startDateTime = null
          this.message = 'Clocked out successfully!'
        }
      } catch (error) {
        console.error(error)

        this.message =
          error.response?.data?.message ||
          error.message ||
          'Error updating clock status.'
      } finally {
        this.loading = false
      }
    }
  },

  mounted() {
    this.updateCurrentTime()
    this.refresh()

    this.timer = setInterval(
      this.updateCurrentTime,
      1000
    )
  },

  beforeUnmount() {
    clearInterval(this.timer)
  }
}
</script>

<style scoped>
.clock-page {
  max-width: 950px;
  margin: 0 auto;
}

/* PAGE HEADING */

.page-heading {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
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

.employee-badge {
  padding: 10px 15px;
  border: 1px solid #dbeafe;
  border-radius: 10px;
  background: #eff6ff;
  text-align: right;
}

.employee-badge span {
  display: block;
  color: #2563eb;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.8px;
}

.employee-badge strong {
  display: block;
  margin-top: 2px;
  color: #1e40af;
  font-size: 14px;
}

/* CLOCK CARD */

.clock-card {
  display: flex;
  align-items: center;
  flex-direction: column;
  padding: 42px 30px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 18px;
  box-shadow: 0 8px 25px rgba(15, 23, 42, 0.05);
  text-align: center;
}

.clock-icon {
  width: 58px;
  height: 58px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 18px;
  border-radius: 16px;
  background: #eff6ff;
  font-size: 26px;
}

.current-time {
  color: #111827;
  font-size: 46px;
  font-weight: 700;
  letter-spacing: -1px;
}

.today {
  margin: 5px 0 18px;
  color: #6b7280;
  font-size: 13px;
}

.status-pill {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 13px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 700;
}

.status-pill.active {
  background: #dcfce7;
  color: #15803d;
}

.status-pill.inactive {
  background: #f1f5f9;
  color: #64748b;
}

.status-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: currentColor;
}

.clock-button {
  width: 240px;
  margin-top: 25px;
  padding: 14px 20px;
  border: none;
  border-radius: 9px;
  background: #2563eb;
  color: white;
  font-size: 14px;
  font-weight: 700;
  transition: 0.2s ease;
}

.clock-button:hover:not(:disabled) {
  background: #1d4ed8;
  transform: translateY(-1px);
}

.clock-button.checkout {
  background: #dc2626;
}

.clock-button.checkout:hover:not(:disabled) {
  background: #b91c1c;
}

.clock-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.refresh-button {
  margin-top: 13px;
  border: none;
  background: transparent;
  color: #64748b;
  font-size: 12px;
  font-weight: 600;
}

.refresh-button:hover:not(:disabled) {
  color: #2563eb;
}

.refresh-button:disabled {
  opacity: 0.5;
}

/* SESSION CARD */

.info-card {
  margin-top: 20px;
  padding: 26px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.info-header {
  display: flex;
  align-items: center;
  gap: 13px;
  margin-bottom: 22px;
}

.section-icon {
  width: 43px;
  height: 43px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 11px;
  background: #eff6ff;
  font-size: 18px;
}

.info-header h2 {
  margin: 0;
  color: #111827;
  font-size: 18px;
}

.info-header p {
  margin: 4px 0 0;
  color: #6b7280;
  font-size: 13px;
}

.session-details {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.detail {
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  background: #f8fafc;
}

.detail span {
  display: block;
  margin-bottom: 6px;
  color: #6b7280;
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.detail strong {
  color: #111827;
  font-size: 13px;
}

/* MESSAGE */

.message {
  margin-top: 20px;
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

/* RESPONSIVE */

@media (max-width: 700px) {
  .page-heading {
    align-items: stretch;
    flex-direction: column;
  }

  .employee-badge {
    align-self: flex-start;
    text-align: left;
  }

  .current-time {
    font-size: 36px;
  }

  .clock-button {
    width: 100%;
    max-width: 300px;
  }

  .session-details {
    grid-template-columns: 1fr;
  }
}
</style>