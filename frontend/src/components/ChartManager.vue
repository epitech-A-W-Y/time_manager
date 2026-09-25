<template>
  <div class="dashboard-page">

    <!-- Header -->
    <div class="page-header">
      <div>
        <span class="eyebrow">ANALYTICS</span>
        <h1>Working Time Dashboard</h1>
        <p>
          Visualize working hours and activity for the selected employee.
        </p>
      </div>

      <div class="employee-badge">
        <span>EMPLOYEE</span>
        <strong>#{{ userId }}</strong>
      </div>
    </div>

    <!-- Controls -->
    <div class="controls-card">
      <div class="control-info">
        <div class="control-icon">📊</div>

        <div>
          <h2>Dashboard Controls</h2>
          <p>Select an employee to load their working-time data.</p>
        </div>
      </div>

      <div class="controls-row">
        <div class="input-group">
          <label for="userId">User ID</label>

          <input
            id="userId"
            v-model.number="userId"
            type="number"
            min="1"
            placeholder="1"
            @keyup.enter="loadCharts"
          />
        </div>

        <button
          class="load-button"
          :disabled="loading || !userId"
          @click="loadCharts"
        >
          {{ loading ? 'Loading...' : 'Load Dashboard' }}
        </button>
      </div>
    </div>

    <!-- Error message -->
    <div v-if="errorMessage" class="message error">
      {{ errorMessage }}
    </div>

    <!-- Summary -->
    <div class="summary-grid">

      <div class="summary-card">
        <div class="summary-icon blue">⏱</div>

        <div>
          <span>Total Hours</span>
          <strong>{{ totalHours.toFixed(1) }} h</strong>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon green">📅</div>

        <div>
          <span>Working Days</span>
          <strong>{{ workingDays }}</strong>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon purple">◷</div>

        <div>
          <span>Average / Day</span>
          <strong>{{ averageHours.toFixed(1) }} h</strong>
        </div>
      </div>

    </div>

    <!-- Charts -->
    <div v-if="!loading && hasData" class="charts-grid">

      <!-- Bar chart -->
      <div class="chart-card">
        <div class="chart-header">
          <div>
            <span class="chart-number">01</span>
            <h2>Working Hours</h2>
            <p>
              Hours worked for each recorded day.
            </p>
          </div>

          <span class="chart-type">BAR</span>
        </div>

        <div class="chart-container">
          <Bar
            :data="chartData"
            :options="chartOptions"
          />
        </div>
      </div>

      <!-- Line chart -->
      <div class="chart-card">
        <div class="chart-header">
          <div>
            <span class="chart-number">02</span>
            <h2>Working Hours Evolution</h2>
            <p>
              Evolution of working hours over time.
            </p>
          </div>

          <span class="chart-type">LINE</span>
        </div>

        <div class="chart-container">
          <Line
            :data="lineChartData"
            :options="lineChartOptions"
          />
        </div>
      </div>

      <!-- Pie chart -->
      <div class="chart-card pie-card">
        <div class="chart-header">
          <div>
            <span class="chart-number">03</span>
            <h2>Working Hours Distribution</h2>
            <p>
              Distribution of recorded hours across working days.
            </p>
          </div>

          <span class="chart-type">PIE</span>
        </div>

        <div class="pie-container">
          <Pie
            :data="pieChartData"
            :options="pieChartOptions"
          />
        </div>
      </div>

    </div>

    <!-- Empty state -->
    <div
      v-else-if="!loading && !errorMessage"
      class="empty-state"
    >
      <div class="empty-icon">📊</div>

      <h2>No working-time data</h2>

      <p>
        There are no working times recorded for employee #{{ userId }} yet.
      </p>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading-state">
      <div class="spinner"></div>
      <p>Loading working-time data...</p>
    </div>

  </div>
</template>

<script>
import axios from 'axios'

import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  CategoryScale,
  LinearScale,
  Filler
} from 'chart.js'

import { Bar, Line, Pie } from 'vue-chartjs'

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  CategoryScale,
  LinearScale,
  Filler
)

export default {
  name: 'ChartManager',

  components: {
    Bar,
    Line,
    Pie
  },

  data() {
    return {
      userId: Number(this.$route.params.userid) || 1,

      totalHours: 0,
      workingDays: 0,
      averageHours: 0,

      loading: false,
      errorMessage: '',

      chartData: {
        labels: [],
        datasets: []
      },

      lineChartData: {
        labels: [],
        datasets: []
      },

      pieChartData: {
        labels: [],
        datasets: []
      },

      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,

        plugins: {
          legend: {
            display: true,
            position: 'top'
          },

          tooltip: {
            callbacks: {
              label(context) {
                return `${context.parsed.y.toFixed(1)} hours`
              }
            }
          }
        },

        scales: {
          y: {
            beginAtZero: true,

            title: {
              display: true,
              text: 'Hours'
            },

            ticks: {
              callback(value) {
                return `${value}h`
              }
            }
          },

          x: {
            title: {
              display: true,
              text: 'Date'
            }
          }
        }
      },

      lineChartOptions: {
        responsive: true,
        maintainAspectRatio: false,

        plugins: {
          legend: {
            display: true,
            position: 'top'
          }
        },

        scales: {
          y: {
            beginAtZero: true,

            title: {
              display: true,
              text: 'Hours'
            },

            ticks: {
              callback(value) {
                return `${value}h`
              }
            }
          },

          x: {
            title: {
              display: true,
              text: 'Date'
            }
          }
        }
      },

      pieChartOptions: {
        responsive: true,
        maintainAspectRatio: false,

        plugins: {
          legend: {
            position: 'right'
          },

          tooltip: {
            callbacks: {
              label(context) {
                const value = context.parsed

                return `${context.label}: ${value.toFixed(1)} hours`
              }
            }
          }
        }
      }
    }
  },

  computed: {
    hasData() {
      return this.workingDays > 0
    }
  },

  mounted() {
    this.loadCharts()
  },

  methods: {
    async loadCharts() {
      if (!this.userId) {
        this.errorMessage = 'Please enter a valid User ID.'
        return
      }

      this.loading = true
      this.errorMessage = ''

      try {
        const response = await axios.get(
          `/api/workingtime/${this.userId}`
        )

        const workingTimes = response.data.data || []

        const labels = []
        const hours = []

        let total = 0

        workingTimes.forEach(workingTime => {
          const start = new Date(workingTime.start)
          const end = new Date(workingTime.end)

          if (
            Number.isNaN(start.getTime()) ||
            Number.isNaN(end.getTime())
          ) {
            return
          }

          const duration =
            (end - start) / (1000 * 60 * 60)

          labels.push(
            start.toLocaleDateString('en-GB', {
              day: '2-digit',
              month: 'short'
            })
          )

          hours.push(
            Math.max(0, Number(duration.toFixed(2)))
          )

          total += duration
        })

        this.totalHours = total
        this.workingDays = workingTimes.length

        this.averageHours =
          workingTimes.length > 0
            ? total / workingTimes.length
            : 0

        /*
         * BAR CHART
         */
        this.chartData = {
          labels,

          datasets: [
            {
              label: 'Hours worked',
              data: hours,

              borderRadius: 6,
              borderSkipped: false
            }
          ]
        }

        /*
         * LINE CHART
         */
        this.lineChartData = {
          labels,

          datasets: [
            {
              label: 'Hours worked',
              data: hours,

              tension: 0.35,
              fill: true,

              pointRadius: 4,
              pointHoverRadius: 6
            }
          ]
        }

        /*
         * PIE CHART
         */
        this.pieChartData = {
          labels,

          datasets: [
            {
              label: 'Hours worked',
              data: hours,

              borderWidth: 2
            }
          ]
        }
      } catch (error) {
        console.error(error)

        this.errorMessage =
          error.response?.data?.message ||
          error.message ||
          'Unable to load working-time data.'

        this.totalHours = 0
        this.workingDays = 0
        this.averageHours = 0
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.dashboard-page {
  max-width: 1200px;
  margin: 0 auto;
}

/* HEADER */

.page-header {
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

.page-header h1 {
  margin: 0;
  color: #111827;
  font-size: 30px;
  font-weight: 700;
}

.page-header p {
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

/* CONTROLS */

.controls-card {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 25px;
  margin-bottom: 20px;
  padding: 22px;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  background: white;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.control-info {
  display: flex;
  align-items: center;
  gap: 13px;
}

.control-icon {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 11px;
  background: #eff6ff;
  font-size: 19px;
}

.control-info h2 {
  margin: 0;
  color: #111827;
  font-size: 16px;
}

.control-info p {
  margin: 4px 0 0;
  color: #6b7280;
  font-size: 12px;
}

.controls-row {
  display: flex;
  align-items: flex-end;
  gap: 10px;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.input-group label {
  color: #374151;
  font-size: 11px;
  font-weight: 700;
}

.input-group input {
  width: 90px;
  box-sizing: border-box;
  padding: 10px 11px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  outline: none;
  color: #111827;
  font-size: 13px;
}

.input-group input:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.load-button {
  padding: 10px 16px;
  border: none;
  border-radius: 8px;
  background: #2563eb;
  color: white;
  font-size: 12px;
  font-weight: 700;
  cursor: pointer;
  transition: 0.2s ease;
}

.load-button:hover:not(:disabled) {
  background: #1d4ed8;
}

.load-button:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

/* MESSAGES */

.message {
  margin-bottom: 20px;
  padding: 13px 16px;
  border-radius: 9px;
  font-size: 13px;
  font-weight: 600;
}

.message.error {
  border: 1px solid #fecaca;
  background: #fef2f2;
  color: #dc2626;
}

/* SUMMARY */

.summary-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
  margin-bottom: 20px;
}

.summary-card {
  display: flex;
  align-items: center;
  gap: 13px;
  padding: 19px;
  border: 1px solid #e5e7eb;
  border-radius: 14px;
  background: white;
  box-shadow: 0 5px 18px rgba(15, 23, 42, 0.04);
}

.summary-icon {
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 10px;
  font-size: 18px;
}

.summary-icon.blue {
  background: #eff6ff;
}

.summary-icon.green {
  background: #f0fdf4;
}

.summary-icon.purple {
  background: #faf5ff;
}

.summary-card span {
  display: block;
  margin-bottom: 4px;
  color: #6b7280;
  font-size: 11px;
  font-weight: 600;
}

.summary-card strong {
  color: #111827;
  font-size: 23px;
}

/* CHARTS */

.charts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
}

.chart-card {
  min-width: 0;
  padding: 22px;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  background: white;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
}

.chart-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 15px;
  margin-bottom: 20px;
}

.chart-number {
  display: block;
  margin-bottom: 3px;
  color: #2563eb;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.8px;
}

.chart-header h2 {
  margin: 0;
  color: #111827;
  font-size: 17px;
}

.chart-header p {
  margin: 5px 0 0;
  color: #6b7280;
  font-size: 11px;
}

.chart-type {
  padding: 5px 8px;
  border-radius: 6px;
  background: #f1f5f9;
  color: #64748b;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.6px;
}

.chart-container {
  height: 330px;
  position: relative;
}

.pie-card {
  grid-column: 1 / -1;
}

.pie-container {
  height: 370px;
  max-width: 700px;
  margin: 0 auto;
}

/* EMPTY STATE */

.empty-state {
  padding: 55px 25px;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  background: white;
  text-align: center;
}

.empty-icon {
  margin-bottom: 12px;
  font-size: 35px;
}

.empty-state h2 {
  margin: 0;
  color: #111827;
  font-size: 18px;
}

.empty-state p {
  margin: 7px 0 0;
  color: #6b7280;
  font-size: 13px;
}

/* LOADING */

.loading-state {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  min-height: 250px;
  color: #6b7280;
}

.loading-state p {
  margin-top: 12px;
  font-size: 13px;
}

.spinner {
  width: 28px;
  height: 28px;
  border: 3px solid #dbeafe;
  border-top-color: #2563eb;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* RESPONSIVE */

@media (max-width: 850px) {
  .page-header,
  .controls-card {
    align-items: stretch;
    flex-direction: column;
  }

  .employee-badge {
    align-self: flex-start;
    text-align: left;
  }

  .controls-row {
    align-items: stretch;
  }

  .input-group {
    flex: 1;
  }

  .input-group input {
    width: 100%;
  }

  .summary-grid,
  .charts-grid {
    grid-template-columns: 1fr;
  }

  .pie-card {
    grid-column: auto;
  }
}

@media (max-width: 500px) {
  .controls-row {
    flex-direction: column;
  }

  .load-button {
    width: 100%;
  }

  .chart-container {
    height: 280px;
  }

  .pie-container {
    height: 300px;
  }
}
</style>