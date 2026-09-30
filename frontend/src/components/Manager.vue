<template>
  <div class="manager-page">
    <header>
      <h1>Time Manager</h1>
      <p>Manager Dashboard</p>
    </header>

    <main>
      <section class="welcome">
        <h2>Welcome, Manager 👋</h2>
        <p>Monitor your team's working time.</p>
      </section>

      <section class="team-card">
        <h2>Team Overview</h2>

        <div class="employee">
          <div>
            <strong>Employee 1</strong>
            <p>Working time today: 7h 30min</p>
          </div>
          <span class="working">Working</span>
        </div>

        <div class="employee">
          <div>
            <strong>Employee 2</strong>
            <p>Working time today: 6h 45min</p>
          </div>
          <span class="offline">Offline</span>
        </div>

        <div class="employee">
          <div>
            <strong>Employee 3</strong>
            <p>Working time today: 8h 00min</p>
          </div>
          <span class="working">Working</span>
        </div>
      </section>

      <section class="statistics">
        <h2>Team Statistics</h2>

        <div class="stats">
          <div>
            <strong>3</strong>
            <p>Total Employees</p>
          </div>

          <div>
            <strong>2</strong>
            <p>Currently Working</p>
          </div>

          <div>
            <strong>22h 15min</strong>
            <p>Total Today</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped>
.manager-page {
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
.team-card,
.statistics {
  background: white;
  padding: 25px;
  margin-bottom: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.employee {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px;
  margin-top: 12px;
  background: #f3f4f6;
  border-radius: 8px;
}

.employee p {
  margin: 5px 0 0;
}

.working,
.offline {
  padding: 7px 12px;
  border-radius: 20px;
  font-size: 14px;
}

.working {
  background: #dcfce7;
  color: #166534;
}

.offline {
  background: #e5e7eb;
  color: #374151;
}

.stats {
  display: flex;
  gap: 20px;
}

.stats div {
  flex: 1;
  background: #f3f4f6;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}

.stats strong {
  font-size: 24px;
}

.stats p {
  margin-bottom: 0;
}
</style>