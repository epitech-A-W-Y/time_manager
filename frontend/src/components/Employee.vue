<template>
  <div class="employee-page">
    <h1>Employee Dashboard</h1>

    <p>Welcome to Time Manager</p>

    <ClockManager />
  </div>
</template>

<script setup>
import ClockManager from './ClockManager.vue'
</script>

<style scoped>
.employee-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 20px;
  font-family: Arial, sans-serif;
}

h1 {
  margin-bottom: 10px;
}

p {
  margin-bottom: 30px;
}
</style>