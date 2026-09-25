<template>
  <div class="app">
    <aside class="sidebar">
      <div class="brand">
        <div class="brand-icon">⏱</div>
        <div>
          <h1>Time Manager</h1>
          <span>Employee workspace</span>
        </div>
      </div>

      <nav class="navigation">
        <router-link to="/user" class="nav-item">
          <span class="nav-icon">👤</span>
          <span>User</span>
        </router-link>

        <router-link
          :to="`/workingTimes/${userId}`"
          class="nav-item"
        >
          <span class="nav-icon">📅</span>
          <span>Working Times</span>
        </router-link>

        <router-link
          :to="`/workingTime/${userId}`"
          class="nav-item"
        >
          <span class="nav-icon">➕</span>
          <span>Add Working Time</span>
        </router-link>

        <router-link
          :to="`/clock/${userId}`"
          class="nav-item"
        >
          <span class="nav-icon">🕐</span>
          <span>Clock Manager</span>
        </router-link>

        <router-link
          :to="`/chartManager/${userId}`"
          class="nav-item"
        >
          <span class="nav-icon">📊</span>
          <span>Dashboard</span>
        </router-link>
      </nav>

      <div class="sidebar-footer">
        <div class="status-dot"></div>
        <div>
          <strong>System online</strong>
          <span>API connected</span>
        </div>
      </div>
    </aside>

    <div class="main-wrapper">
      <header class="topbar">
        <div>
          <p class="page-label">TIME MANAGEMENT</p>
          <h2>Workspace</h2>
        </div>

        <div class="user-badge">
          <div class="avatar">Y</div>
          <div>
            <strong>User #{{ userId }}</strong>
            <span>Employee</span>
          </div>
        </div>
      </header>

      <main class="main-content">
        <User v-if="$route.path !== '/user'" />
        <router-view />
      </main>
    </div>
  </div>
</template>

<script>
import User from './components/User.vue'

export default {
  name: 'App',

  components: {
    User
  },

  data() {
    return {
      userId: 1
    }
  }
}
</script>

<style>
* {
  box-sizing: border-box;
}

html,
body,
#app {
  margin: 0;
  min-height: 100%;
  font-family:
    Inter,
    -apple-system,
    BlinkMacSystemFont,
    "Segoe UI",
    sans-serif;
}

body {
  background: #f4f7fb;
  color: #172033;
}

button,
input,
select,
textarea {
  font: inherit;
}

button {
  cursor: pointer;
}

.app {
  min-height: 100vh;
  display: flex;
  background: #f4f7fb;
}

/* SIDEBAR */

.sidebar {
  width: 250px;
  min-height: 100vh;
  background: #111827;
  color: white;
  display: flex;
  flex-direction: column;
  padding: 28px 18px;
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 10px 32px;
}

.brand-icon {
  width: 42px;
  height: 42px;
  border-radius: 12px;
  background: #2563eb;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 21px;
}

.brand h1 {
  margin: 0;
  font-size: 17px;
  font-weight: 700;
}

.brand span {
  display: block;
  margin-top: 3px;
  color: #9ca3af;
  font-size: 11px;
}

/* NAVIGATION */

.navigation {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 13px;
  border-radius: 10px;
  color: #cbd5e1;
  text-decoration: none;
  font-size: 14px;
  transition: 0.2s ease;
}

.nav-item:hover {
  background: #1f2937;
  color: white;
}

.nav-item.router-link-active {
  background: #2563eb;
  color: white;
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
}

.nav-icon {
  width: 22px;
  text-align: center;
  font-size: 16px;
}

/* SIDEBAR FOOTER */

.sidebar-footer {
  margin-top: auto;
  border-top: 1px solid #293241;
  padding: 18px 10px 5px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.status-dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: #22c55e;
}

.sidebar-footer strong {
  display: block;
  font-size: 12px;
}

.sidebar-footer span {
  display: block;
  color: #9ca3af;
  font-size: 11px;
  margin-top: 2px;
}

/* MAIN AREA */

.main-wrapper {
  margin-left: 250px;
  width: calc(100% - 250px);
  min-height: 100vh;
}

.topbar {
  height: 82px;
  background: white;
  border-bottom: 1px solid #e5e7eb;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 38px;
}

.page-label {
  margin: 0 0 3px;
  color: #2563eb;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.2px;
}

.topbar h2 {
  margin: 0;
  font-size: 21px;
  color: #111827;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 10px;
}

.avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: #dbeafe;
  color: #2563eb;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}

.user-badge strong {
  display: block;
  font-size: 13px;
}

.user-badge span {
  display: block;
  color: #6b7280;
  font-size: 11px;
  margin-top: 2px;
}

/* CONTENT */

.main-content {
  padding: 36px 38px 50px;
  max-width: 1500px;
  margin: 0 auto;
}

/* COMMON COMPONENT STYLING */

.main-content h1 {
  margin: 0 0 8px;
  color: #111827;
  font-size: 28px;
  font-weight: 700;
}

.main-content h2 {
  color: #1f2937;
}

.main-content p {
  color: #6b7280;
}

.main-content button {
  border: none;
  border-radius: 8px;
  background: #2563eb;
  color: white;
  padding: 10px 17px;
  font-weight: 600;
  transition: 0.2s ease;
}

.main-content button:hover {
  background: #1d4ed8;
  transform: translateY(-1px);
}

.main-content input,
.main-content select {
  border: 1px solid #d1d5db;
  border-radius: 8px;
  padding: 10px 12px;
  background: white;
  color: #111827;
  outline: none;
  transition: 0.2s ease;
}

.main-content input:focus,
.main-content select:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

/* TABLES */

.main-content table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(15, 23, 42, 0.05);
}

.main-content th {
  background: #f8fafc;
  color: #64748b;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  text-align: left;
  padding: 14px 16px;
  border-bottom: 1px solid #e5e7eb;
}

.main-content td {
  padding: 15px 16px;
  border-bottom: 1px solid #eef2f7;
  color: #374151;
  font-size: 14px;
}

.main-content tr:last-child td {
  border-bottom: none;
}

.main-content tr:hover td {
  background: #f8fafc;
}

.main-content a {
  color: #2563eb;
}

/* RESPONSIVE */

@media (max-width: 850px) {
  .sidebar {
    width: 210px;
  }

  .main-wrapper {
    margin-left: 210px;
    width: calc(100% - 210px);
  }

  .topbar,
  .main-content {
    padding-left: 22px;
    padding-right: 22px;
  }
}

@media (max-width: 650px) {
  .sidebar {
    width: 70px;
    padding: 20px 10px;
  }

  .brand {
    justify-content: center;
    padding-left: 0;
    padding-right: 0;
  }

  .brand > div:last-child,
  .nav-item span:last-child,
  .sidebar-footer > div:last-child {
    display: none;
  }

  .nav-item {
    justify-content: center;
  }

  .main-wrapper {
    margin-left: 70px;
    width: calc(100% - 70px);
  }

  .topbar {
    padding: 0 16px;
  }

  .main-content {
    padding: 24px 16px;
  }
}
</style>