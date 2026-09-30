<template>
  <div class="admin-page">
    <header>
      <h1>Time Manager</h1>
      <p>Administrator Dashboard</p>
    </header>

    <main>
      <section class="welcome">
        <h2>Welcome, Administrator 👋</h2>
        <p>Manage users and monitor the Time Manager system.</p>
      </section>

      <section class="users-card">
        <h2>User Management</h2>

        <div class="user">
          <div>
            <strong>Employee 1</strong>
            <p>Employee</p>
          </div>

          <button>Manage</button>
        </div>

        <div class="user">
          <div>
            <strong>Employee 2</strong>
            <p>Employee</p>
          </div>

          <button>Manage</button>
        </div>

        <div class="user">
          <div>
            <strong>Manager 1</strong>
            <p>Manager</p>
          </div>

          <button>Manage</button>
        </div>
      </section>

      <section class="system-card">
        <h2>System Overview</h2>

        <div class="stats">
          <div>
            <strong>3</strong>
            <p>Total Users</p>
          </div>

          <div>
            <strong>2</strong>
            <p>Employees</p>
          </div>

          <div>
            <strong>1</strong>
            <p>Managers</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped>
.admin-page {
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
.users-card,
.system-card {
  background: white;
  padding: 25px;
  margin-bottom: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.user {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px;
  margin-top: 12px;
  background: #f3f4f6;
  border-radius: 8px;
}

.user p {
  margin: 5px 0 0;
}

button {
  padding: 10px 18px;
  border: none;
  border-radius: 8px;
  background: #2563eb;
  color: white;
  cursor: pointer;
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