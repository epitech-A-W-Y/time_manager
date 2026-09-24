<template>
    <div class="charts-page">
  
      <div class="page-header">
        <h1>Working Time Dashboard</h1>
        <p>Visualize working hours and activity for a user.</p>
      </div>
  
      <div class="controls-card">
        <label for="userId">User ID</label>
  
        <div class="controls-row">
          <input
            id="userId"
            v-model="userId"
            type="number"
            min="1"
          />
  
          <button @click="loadCharts">
            Load Charts
          </button>
        </div>
      </div>
  
      <!-- Summary cards -->
      <div class="summary-grid">
  
        <div class="summary-card">
          <h3>Total Hours</h3>
          <p>{{ totalHours.toFixed(1) }} h</p>
        </div>
  
        <div class="summary-card">
          <h3>Working Days</h3>
          <p>{{ workingDays }}</p>
        </div>
  
        <div class="summary-card">
          <h3>Average / Day</h3>
          <p>{{ averageHours.toFixed(1) }} h</p>
        </div>
  
      </div>
  
      <div class="charts-grid">
  
        <!-- Bar chart -->
        <div class="chart-card">
          <h2>Working Hours</h2>
  
          <p class="chart-description">
            Working hours recorded for each day.
          </p>
  
          <div class="chart-container">
            <Bar :data="chartData" :options="chartOptions" />
          </div>
        </div>
  
        <!-- Line chart -->
        <div class="chart-card">
          <h2>Working Hours Evolution</h2>
  
          <p class="chart-description">
            Evolution of working hours over time.
          </p>
  
          <div class="chart-container">
            <Line :data="lineChartData" :options="chartOptions" />
          </div>
        </div>
  
        <!-- Pie chart -->
        <div class="chart-card pie-card">
          <h2>Working Hours Distribution</h2>
  
          <p class="chart-description">
            Distribution of recorded working hours.
          </p>
  
          <div class="pie-container">
            <Pie :data="pieChartData" :options="pieChartOptions" />
          </div>
        </div>
  
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
    LinearScale
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
    LinearScale
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
        userId: 1,
  
        totalHours: 0,
        workingDays: 0,
        averageHours: 0,
  
        chartData: {
          labels: [],
          datasets: [
            {
              label: 'Hours worked',
              data: []
            }
          ]
        },
  
        lineChartData: {
          labels: [],
          datasets: [
            {
              label: 'Hours worked',
              data: []
            }
          ]
        },
  
        pieChartData: {
          labels: [],
          datasets: [
            {
              label: 'Hours worked',
              data: []
            }
          ]
        },
  
        // Options for Bar and Line charts
        chartOptions: {
          responsive: true,
          maintainAspectRatio: false,
  
          scales: {
            y: {
              beginAtZero: true,
  
              title: {
                display: true,
                text: 'Hours'
              }
            }
          }
        },
  
        // Options for Pie chart
        pieChartOptions: {
          responsive: true,
          maintainAspectRatio: false
        }
      }
    },
  
    mounted() {
      this.loadCharts()
    },
  
    methods: {
      loadCharts() {
        axios.get(`/api/workingtime/${this.userId}`)
          .then(response => {
            const workingTimes = response.data.data
  
            const labels = []
            const hours = []
  
            let total = 0
  
            workingTimes.forEach(workingTime => {
              const start = new Date(workingTime.start)
              const end = new Date(workingTime.end)
  
              const duration = (end - start) / (1000 * 60 * 60)
  
              labels.push(start.toLocaleDateString())
              hours.push(duration)
  
              total += duration
            })
  
            // Summary calculations
            this.totalHours = total
            this.workingDays = workingTimes.length
  
            if (workingTimes.length > 0) {
              this.averageHours = total / workingTimes.length
            } else {
              this.averageHours = 0
            }
  
            // Graph 1: Bar chart
            this.chartData = {
              labels: labels,
              datasets: [
                {
                  label: 'Hours worked',
                  data: hours
                }
              ]
            }
  
            // Graph 2: Line chart
            this.lineChartData = {
              labels: labels,
              datasets: [
                {
                  label: 'Hours worked',
                  data: hours
                }
              ]
            }
  
            // Graph 3: Pie chart
            this.pieChartData = {
              labels: labels,
              datasets: [
                {
                  label: 'Hours worked',
                  data: hours
                }
              ]
            }
          })
          .catch(error => {
            console.error(error)
          })
      }
    }
  }
  </script>
  
  <style scoped>
  .charts-page {
    padding: 30px;
    max-width: 1400px;
    margin: 0 auto;
    font-family: Arial, sans-serif;
  }
  
  .page-header {
    margin-bottom: 30px;
  }
  
  .page-header h1 {
    margin: 0;
    font-size: 32px;
  }
  
  .page-header p {
    margin-top: 8px;
    color: #666;
  }
  
  .controls-card {
    background: #f5f5f5;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 30px;
  }
  
  .controls-card label {
    display: block;
    font-weight: bold;
    margin-bottom: 10px;
  }
  
  .controls-row {
    display: flex;
    gap: 10px;
    align-items: center;
  }
  
  .controls-row input {
    width: 100px;
    padding: 9px;
    border: 1px solid #ccc;
    border-radius: 6px;
  }
  
  .controls-row button {
    padding: 9px 18px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    background: #333;
    color: white;
  }
  
  .controls-row button:hover {
    background: #555;
  }
  
  /* Summary cards */
  .summary-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 30px;
  }
  
  .summary-card {
    background: white;
    border: 1px solid #ddd;
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  }
  
  .summary-card h3 {
    margin: 0 0 10px;
    color: #666;
  }
  
  .summary-card p {
    margin: 0;
    font-size: 28px;
    font-weight: bold;
  }
  
  /* Charts */
  .charts-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 25px;
  }
  
  .chart-card {
    background: white;
    border: 1px solid #ddd;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  }
  
  .chart-card h2 {
    margin-top: 0;
    margin-bottom: 5px;
  }
  
  .chart-description {
    color: #777;
    margin-top: 0;
    margin-bottom: 20px;
  }
  
  .chart-container {
    height: 350px;
  }
  
  .pie-card {
    grid-column: 1 / -1;
  }
  
  .pie-container {
    height: 400px;
    max-width: 600px;
    margin: 0 auto;
  }
  
  @media (max-width: 900px) {
    .summary-grid {
      grid-template-columns: 1fr;
    }
  
    .charts-grid {
      grid-template-columns: 1fr;
    }
  
    .pie-card {
      grid-column: auto;
    }
  }
  </style>