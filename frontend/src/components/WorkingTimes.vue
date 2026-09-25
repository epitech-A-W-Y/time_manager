<template>
  <div class="working-times-page">
    <div class="page-heading">
      <div>
        <span class="eyebrow">TIME TRACKING</span>
        <h1>Working Times</h1>
        <p>View and manage the employee's recorded working hours.</p>
      </div>

      <button
        type="button"
        class="refresh-button"
        :disabled="loading"
        @click="getWorkingTimes"
      >
        <span>{{ loading ? 'Refreshing...' : '↻ Refresh' }}</span>
      </button>
    </div>

    <!-- Summary -->
    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-icon blue">📅</div>
        <div>
          <span>Total Records</span>
          <strong>{{ workingTimes.length }}</strong>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon green">⏱</div>
        <div>
          <span>Total Hours</span>
          <strong>{{ totalHours }} h</strong>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon purple">👤</div>
        <div>
          <span>Employee</span>
          <strong>#{{ userID }}</strong>
        </div>
      </div>
    </div>

    <!-- Error / status -->
    <div v-if="message" class="message">
      {{ message }}
    </div>

    <!-- Working times -->
    <div class="card">
      <div class="card-header">
        <div>
          <h2>Recorded Working Times</h2>
          <p>All working periods recorded for this employee.</p>
        </div>

        <span class="record-count">
          {{ workingTimes.length }}
          {{ workingTimes.length === 1 ? 'record' : 'records' }}
        </span>
      </div>

      <div v-if="loading" class="empty-state">
        <div class="loading-icon">⏳</div>
        <strong>Loading working times...</strong>
        <p>Please wait while we retrieve the latest data.</p>
      </div>

      <div
        v-else-if="workingTimes.length > 0"
        class="table-wrapper"
      >
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
              <td>
                <span class="id-badge">
                  #{{ workingTime.id }}
                </span>
              </td>

              <td>
                <div class="date-cell">
                  <strong>{{ formatDate(workingTime.start) }}</strong>
                  <span>{{ formatTime(workingTime.start) }}</span>
                </div>
              </td>

              <td>
                <div class="date-cell">
                  <strong>{{ formatDate(workingTime.end) }}</strong>
                  <span>{{ formatTime(workingTime.end) }}</span>
                </div>
              </td>

              <td>
                <span class="duration-badge">
                  {{ getDuration(workingTime) }}
                </span>
              </td>

              <td>
                <router-link
                  class="edit-button"
                  :to="`/workingTime/${userID}/${workingTime.id}`"
                >
                  Edit
                </router-link>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-else class="empty-state">
        <div class="empty-icon">📅</div>
        <strong>No working times found</strong>
        <p>
          There are currently no recorded working periods
          for this employee.
        </p>

        <router-link
          class="add-button"
          :to="`/workingTime/${userID}`"
        >
          + Add Working Time
        </router-link>
      </div>
    </div>
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

  computed: {
    totalHours() {
      const total = this.workingTimes.reduce(
        (sum, workingTime) => {
          if (!workingTime.start || !workingTime.end) {
            return sum
          }

          const start = new Date(workingTime.start)
          const end = new Date(workingTime.end)

          return sum + (end - start) / (1000 * 60 * 60)
        },
        0
      )

      return total.toFixed(1)
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

      return dateTime
        .replace('T', ' ')
        .replace('Z', '')
    },

    formatDate(dateTime) {
      if (!dateTime) {
        return '-'
      }

      return new Date(dateTime).toLocaleDateString(
        'en-GB',
        {
          day: '2-digit',
          month: 'short',
          year: 'numeric'
        }
      )
    },

    formatTime(dateTime) {
      if (!dateTime) {
        return '-'
      }

      return new Date(dateTime).toLocaleTimeString(
        'en-GB',
        {
          hour: '2-digit',
          minute: '2-digit'
        }
      )
    },

    getDuration(workingTime) {
      if (!workingTime.start || !workingTime.end) {
        return '-'
      }

      const start = new Date(workingTime.start)
      const end = new Date(workingTime.end)

      const duration =
        (end - start) / (1000 * 60 * 60)

      return `${duration.toFixed(2)} h`
    }
  },

  mounted() {
    this.getWorkingTimes()
  }
}
</script>

<style scoped>
.working-times-page {
  max-width: 1150px;
  margin: 0 auto;
}

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

.refresh-button {
  border: none;
  border-radius: 8px;
  padding: 11px 17px;
  background: #2563eb;
  color: white;
  font-size: 13px;
  font-weight: 600;
  transition: 0.2s ease;
}

.refresh-button:hover:not(:disabled) {
  background: #1d4ed8;
  transform: translateY(-1px);
}

.refresh-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* SUMMARY */

.summary-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.summary-card {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 20px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 14px;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.summary-icon {
  width: 43px;
  height: 43px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 11px;
  font-size: 18px;
}

.summary-icon.blue {
  background: #eff6ff;
}

.summary-icon.green {
  background: #f0fdf4;
}

.summary-icon.purple {
  background: #f5f3ff;
}

.summary-card span {
  display: block;
  color: #6b7280;
  font-size: 12px;
}

.summary-card strong {
  display: block;
  margin-top: 3px;
  color: #111827;
  font-size: 20px;
}

/* CARD */

.card {
  padding: 26px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 22px;
}

.card-header h2 {
  margin: 0;
  color: #111827;
  font-size: 18px;
}

.card-header p {
  margin: 4px 0 0;
  color: #6b7280;
  font-size: 13px;
}

.record-count {
  padding: 6px 10px;
  border-radius: 20px;
  background: #eff6ff;
  color: #2563eb;
  font-size: 12px;
  font-weight: 600;
}

/* TABLE */

.table-wrapper {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th {
  padding: 13px 14px;
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
  color: #64748b;
  font-size: 11px;
  font-weight: 700;
  text-align: left;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

td {
  padding: 15px 14px;
  border-bottom: 1px solid #eef2f7;
  color: #374151;
  font-size: 13px;
}

tbody tr:last-child td {
  border-bottom: none;
}

tbody tr:hover td {
  background: #f8fafc;
}

.id-badge {
  display: inline-block;
  padding: 5px 8px;
  border-radius: 6px;
  background: #f1f5f9;
  color: #475569;
  font-size: 11px;
  font-weight: 700;
}

.date-cell strong {
  display: block;
  color: #374151;
  font-size: 13px;
}

.date-cell span {
  display: block;
  margin-top: 3px;
  color: #9ca3af;
  font-size: 11px;
}

.duration-badge {
  display: inline-block;
  padding: 6px 9px;
  border-radius: 7px;
  background: #f0fdf4;
  color: #15803d;
  font-size: 12px;
  font-weight: 700;
}

.edit-button {
  display: inline-block;
  padding: 7px 11px;
  border-radius: 7px;
  background: #eff6ff;
  color: #2563eb;
  font-size: 12px;
  font-weight: 600;
  text-decoration: none;
  transition: 0.2s ease;
}

.edit-button:hover {
  background: #2563eb;
  color: white;
}

/* EMPTY / LOADING */

.empty-state {
  padding: 55px 20px;
  text-align: center;
}

.empty-icon,
.loading-icon {
  font-size: 30px;
  margin-bottom: 12px;
}

.empty-state strong {
  display: block;
  color: #374151;
  font-size: 15px;
}

.empty-state p {
  max-width: 400px;
  margin: 7px auto 20px;
  color: #9ca3af;
  font-size: 13px;
}

.add-button {
  display: inline-block;
  padding: 10px 16px;
  border-radius: 8px;
  background: #2563eb;
  color: white;
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
}

.add-button:hover {
  background: #1d4ed8;
}

/* MESSAGE */

.message {
  margin-bottom: 18px;
  padding: 12px 15px;
  border: 1px solid #fecaca;
  border-radius: 9px;
  background: #fef2f2;
  color: #dc2626;
  font-size: 13px;
  font-weight: 600;
}

/* RESPONSIVE */

@media (max-width: 750px) {
  .page-heading {
    align-items: stretch;
    flex-direction: column;
  }

  .refresh-button {
    align-self: flex-start;
  }

  .summary-grid {
    grid-template-columns: 1fr;
  }

  .card {
    padding: 18px;
  }
}
</style>