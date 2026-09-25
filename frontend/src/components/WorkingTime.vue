<template>
  <div class="working-time-page">
    <!-- Page heading -->
    <div class="page-heading">
      <div>
        <span class="eyebrow">TIME TRACKING</span>

        <h1>
          {{ isEditing ? 'Edit Working Time' : 'Add Working Time' }}
        </h1>

        <p>
          {{
            isEditing
              ? 'Update the start and end time of this working period.'
              : 'Record a new working period for the employee.'
          }}
        </p>
      </div>

      <div class="user-badge">
        <span>EMPLOYEE</span>
        <strong>#{{ userId }}</strong>
      </div>
    </div>

    <!-- Form card -->
    <div class="card">
      <div class="card-header">
        <div class="section-icon">
          {{ isEditing ? '✏️' : '➕' }}
        </div>

        <div>
          <h2>
            {{ isEditing ? 'Update Working Period' : 'New Working Period' }}
          </h2>

          <p>
            Enter the exact start and end time for this period.
          </p>
        </div>
      </div>

      <form @submit.prevent="saveWorkingTime">
        <div class="form-grid">
          <div class="field">
            <label for="start">Start date and time</label>

            <input
              id="start"
              v-model="workingTime.start"
              type="datetime-local"
              required
            />

            <span class="field-help">
              When the employee started working.
            </span>
          </div>

          <div class="field">
            <label for="end">End date and time</label>

            <input
              id="end"
              v-model="workingTime.end"
              type="datetime-local"
              required
            />

            <span class="field-help">
              When the employee finished working.
            </span>
          </div>
        </div>

        <div class="form-footer">
          <div class="duration-preview">
            <span>Estimated duration</span>
            <strong>
              {{ calculatedDuration }}
            </strong>
          </div>

          <button
            type="submit"
            class="primary-button"
          >
            {{ isEditing ? 'Save Changes' : 'Create Working Time' }}
          </button>
        </div>
      </form>
    </div>

    <!-- Current working time -->
    <div
      v-if="workingTime.id"
      class="card current-card"
    >
      <div class="card-header">
        <div class="section-icon green">
          ✓
        </div>

        <div>
          <h2>Current Working Time</h2>
          <p>
            Working period currently loaded from the API.
          </p>
        </div>

        <span class="status-badge">
          Saved
        </span>
      </div>

      <div class="details-grid">
        <div class="detail">
          <span class="detail-label">Working Time ID</span>
          <strong>#{{ workingTime.id }}</strong>
        </div>

        <div class="detail">
          <span class="detail-label">Start</span>
          <strong>{{ displayDateTime(workingTime.start) }}</strong>
        </div>

        <div class="detail">
          <span class="detail-label">End</span>
          <strong>{{ displayDateTime(workingTime.end) }}</strong>
        </div>

        <div class="detail">
          <span class="detail-label">Duration</span>
          <strong>{{ calculatedDuration }}</strong>
        </div>
      </div>

      <div class="danger-zone">
        <div>
          <strong>Delete this working period</strong>
          <p>
            This will permanently remove the record from the system.
          </p>
        </div>

        <button
          type="button"
          class="delete-button"
          @click="deleteWorkingTime"
        >
          Delete Working Time
        </button>
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
      <span>{{ message }}</span>
    </div>
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
    },

    calculatedDuration() {
      if (!this.workingTime.start || !this.workingTime.end) {
        return '-'
      }

      const start = new Date(this.workingTime.start)
      const end = new Date(this.workingTime.end)

      const duration =
        (end - start) / (1000 * 60 * 60)

      if (duration < 0) {
        return 'Invalid time'
      }

      return `${duration.toFixed(2)} hours`
    }
  },

  methods: {
    formatDateTime(dateTime) {
      if (!dateTime) {
        return null
      }

      return dateTime.replace('T', ' ') + ':00'
    },

    displayDateTime(dateTime) {
      if (!dateTime) {
        return '-'
      }

      const date = new Date(dateTime)

      if (Number.isNaN(date.getTime())) {
        return dateTime.replace('T', ' ').replace('Z', '')
      }

      return date.toLocaleString('en-GB', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    },

    async getWorkingTime() {
      try {
        const response = await axios.get(
          `/api/workingtime/${this.userId}/${this.workingTimeId}`
        )

        const data = response.data.data

        this.workingTime = {
          id: data.id,
          start: data.start
            ? data.start.slice(0, 16)
            : '',
          end: data.end
            ? data.end.slice(0, 16)
            : ''
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
              start: this.formatDateTime(
                this.workingTime.start
              ),
              end: this.formatDateTime(
                this.workingTime.end
              )
            }
          }
        )

        this.workingTime = response.data.data
        this.message =
          'Working time created successfully!'
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
            start: this.formatDateTime(
              this.workingTime.start
            ),
            end: this.formatDateTime(
              this.workingTime.end
            )
          }
        )

        this.workingTime = response.data.data
        this.message =
          'Working time updated successfully!'
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

        this.message =
          'Working time deleted successfully!'
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
.working-time-page {
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

.user-badge {
  padding: 10px 15px;
  border: 1px solid #dbeafe;
  border-radius: 10px;
  background: #eff6ff;
  text-align: right;
}

.user-badge span {
  display: block;
  color: #2563eb;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.8px;
}

.user-badge strong {
  display: block;
  margin-top: 2px;
  color: #1e40af;
  font-size: 14px;
}

/* CARD */

.card {
  margin-bottom: 20px;
  padding: 26px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.card-header {
  display: flex;
  align-items: center;
  gap: 13px;
  margin-bottom: 25px;
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

.section-icon {
  width: 43px;
  height: 43px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  border-radius: 11px;
  background: #eff6ff;
  font-size: 18px;
}

.section-icon.green {
  background: #f0fdf4;
  color: #16a34a;
  font-weight: 700;
}

/* FORM */

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 7px;
}

.field label {
  color: #374151;
  font-size: 13px;
  font-weight: 600;
}

.field input {
  width: 100%;
  padding: 12px 13px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  background: #f9fafb;
  color: #111827;
  font-size: 14px;
  transition: 0.2s ease;
}

.field input:focus {
  outline: none;
  background: white;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.field-help {
  color: #9ca3af;
  font-size: 11px;
}

.form-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  margin-top: 25px;
  padding-top: 20px;
  border-top: 1px solid #eef2f7;
}

.duration-preview {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.duration-preview span {
  color: #6b7280;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.duration-preview strong {
  color: #111827;
  font-size: 16px;
}

.primary-button {
  border: none;
  border-radius: 8px;
  padding: 11px 19px;
  background: #2563eb;
  color: white;
  font-size: 13px;
  font-weight: 600;
  transition: 0.2s ease;
}

.primary-button:hover {
  background: #1d4ed8;
  transform: translateY(-1px);
}

/* CURRENT RECORD */

.current-card .card-header {
  margin-bottom: 20px;
}

.status-badge {
  margin-left: auto;
  padding: 6px 10px;
  border-radius: 20px;
  background: #f0fdf4;
  color: #15803d;
  font-size: 11px;
  font-weight: 700;
}

.details-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}

.detail {
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  background: #f8fafc;
}

.detail-label {
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

/* DELETE */

.danger-zone {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  margin-top: 22px;
  padding-top: 20px;
  border-top: 1px solid #e5e7eb;
}

.danger-zone strong {
  color: #374151;
  font-size: 13px;
}

.danger-zone p {
  margin: 4px 0 0;
  color: #9ca3af;
  font-size: 12px;
}

.delete-button {
  border: none;
  border-radius: 8px;
  padding: 10px 16px;
  background: #fee2e2;
  color: #dc2626;
  font-size: 13px;
  font-weight: 600;
  transition: 0.2s ease;
}

.delete-button:hover {
  background: #dc2626;
  color: white;
}

/* MESSAGE */

.message {
  margin-bottom: 20px;
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

@media (max-width: 750px) {
  .page-heading {
    align-items: stretch;
    flex-direction: column;
  }

  .user-badge {
    align-self: flex-start;
    text-align: left;
  }

  .form-grid,
  .details-grid {
    grid-template-columns: 1fr;
  }

  .form-footer {
    align-items: stretch;
    flex-direction: column;
  }

  .primary-button {
    width: 100%;
  }

  .danger-zone {
    align-items: flex-start;
    flex-direction: column;
  }

  .delete-button {
    width: 100%;
  }
}
</style>