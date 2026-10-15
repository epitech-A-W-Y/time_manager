
<template>
  <div class="clock-manager">
    <h1>Clock Manager</h1>

    <p v-if="loading">Loading clock history...</p>

    <div v-else>
      <p class="status">
        Status:
        <strong>{{ isClockedIn ? 'Clocked In' : 'Clocked Out' }}</strong>
      </p>

      <div class="buttons">
        <button
          class="clock-in"
          :disabled="isClockedIn || saving"
          @click="clockAction"
        >
          {{ saving && !isClockedIn ? 'Saving...' : 'Clock In' }}
        </button>

        <button
          class="clock-out"
          :disabled="!isClockedIn || saving"
          @click="clockAction"
        >
          {{ saving && isClockedIn ? 'Saving...' : 'Clock Out' }}
        </button>
      </div>

      <p v-if="message" class="message">{{ message }}</p>

      <div v-if="lastClock" class="last-clock">
        <h2>Last Clock</h2>
        <p><strong>Time:</strong> {{ formatDate(lastClock.time) }}</p>
        <p>
          <strong>Action:</strong>
          {{ lastClock.status ? 'Clock In' : 'Clock Out' }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const userId = localStorage.getItem('userId')
const loading = ref(true)
const saving = ref(false)
const isClockedIn = ref(false)
const lastClock = ref(null)
const message = ref('')

async function loadClocks() {
  if (!userId) {
    message.value = 'Please log in before using the clock.'
    loading.value = false
    return
  }

  try {
    const response = await fetch(`/api/clocks/${userId}`)

    if (!response.ok) {
      throw new Error(`Unable to load clocks (${response.status})`)
    }

    const result = await response.json()
    const clocks = (result.data || []).slice().sort(
      (a, b) => new Date(a.time) - new Date(b.time)
    )

    lastClock.value = clocks.length ? clocks[clocks.length - 1] : null
    isClockedIn.value = lastClock.value
      ? Boolean(lastClock.value.status)
      : false
  } catch (error) {
    console.error('Load clocks error:', error)
    message.value = 'Unable to load clock history. Check the backend and try again.'
  } finally {
    loading.value = false
  }
}

async function clockAction() {
  if (!userId || saving.value) return

  saving.value = true
  message.value = ''

  try {
    const response = await fetch(`/api/clocks/${userId}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({})
    })

    if (!response.ok) {
      throw new Error(`Clock request failed (${response.status})`)
    }

    const result = await response.json()

    if (!result.data) {
      throw new Error('The server did not return the clock record.')
    }

    lastClock.value = result.data
    isClockedIn.value = Boolean(result.data.status)

    message.value = isClockedIn.value
      ? 'You are now clocked in.'
      : 'You are now clocked out.'
  } catch (error) {
    console.error('Clock action error:', error)
    message.value = error.message || 'Unable to save the clock action.'
  } finally {
    saving.value = false
  }
}

function formatDate(date) {
  return new Date(date).toLocaleString()
}

onMounted(loadClocks)
</script>

<style scoped>
.clock-manager {
  max-width: 600px;
  margin: 40px auto;
  padding: 30px;
  text-align: center;
  font-family: Arial, sans-serif;
}

.buttons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin: 30px 0;
}

button {
  padding: 12px 25px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.clock-in {
  background: #2ecc71;
  color: white;
}

.clock-out {
  background: #e74c3c;
  color: white;
}

.status {
  font-size: 20px;
}

.message {
  margin-top: 20px;
  font-weight: bold;
}

.last-clock {
  margin-top: 30px;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
}
</style>