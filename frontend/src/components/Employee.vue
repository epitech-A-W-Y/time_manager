<template>
  <div class="employee-page">
    <header>
      <h1>Time Manager</h1>
      <p>Employee Dashboard</p>
    </header>

    <main>
      <section class="welcome">
        <h2>Welcome, Employee 👋</h2>
        <p>Manage your working time easily.</p>
      </section>

      <section class="clock-card">
        <h2>My Clock</h2>

        <div class="status">
          <span class="dot"></span>
          <span>Currently clocked out</span>
        </div>

        <button class="clock-in">
          Clock In
        </button>

        <button class="clock-out">
          Clock Out
        </button>
      </section>

      <section class="working-time">
        <h2>My Working Time</h2>

        <div class="info">
          <div>
            <strong>Today</strong>
            <p>0h 00min</p>
          </div>

          <div>
            <strong>This Week</strong>
            <p>0h 00min</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped>
.employee-page {
  min-height: 100vh;
  background: #f5f7fa;
  font-family: Arial, sans-serif;
  color: #222;
}

header {
  background: #1f2937;
  color: white;
  padding: 25px 40px;
}

header h1 {
  margin: 0;
}

header p {
  margin: 5px 0 0;
}

main {
  max-width: 900px;
  margin: 40px auto;
  padding: 0 20px;
}

.welcome,
.clock-card,
.working-time {
  background: white;
  padding: 25px;
  margin-bottom: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.status {
  margin: 20px 0;
  display: flex;
  align-items: center;
  gap: 10px;
}

.dot {
  width: 12px;
  height: 12px;
  background: #999;
  border-radius: 50%;
}

button {
  padding: 12px 25px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  margin-right: 10px;
  font-size: 15px;
}

.clock-in {
  background: #2563eb;
  color: white;
}

.clock-out {
  background: #dc2626;
  color: white;
}

.info {
  display: flex;
  gap: 30px;
}

.info div {
  background: #f3f4f6;
  padding: 20px;
  border-radius: 8px;
  min-width: 150px;
}

.info p {
  font-size: 20px;
  margin-bottom: 0;
}
</style>