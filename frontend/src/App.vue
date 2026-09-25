<template>
  <div class="app">
    <nav class="navbar">
      <div class="nav-title">
        Time Manager
      </div>

      <div class="nav-links">
        <router-link to="/user">Users</router-link>

        <router-link :to="`/workingTimes/${userId}`">
          Working Times
        </router-link>

        <router-link :to="`/workingTime/${userId}`">
          Add Working Time
        </router-link>

        <router-link :to="`/clock/${userId}`">
          Clock Manager
        </router-link>

        <router-link :to="`/chartManager/${userId}`">
          Dashboard
        </router-link>
      </div>
    </nav>

    <main class="main-content">
      <User v-if="$route.path !== '/user'" />
      <router-view />
    </main>
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

<style scoped>
.app {
  min-height: 100vh;
  background: #f8f9fa;
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 30px;
  background: #ffffff;
  border-bottom: 1px solid #ddd;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

.nav-title {
  font-size: 22px;
  font-weight: bold;
}

.nav-links {
  display: flex;
  gap: 20px;
  align-items: center;
}

.nav-links a {
  text-decoration: none;
  color: #444;
  font-weight: 500;
}

.nav-links a:hover {
  color: #000;
}

.nav-links a.router-link-active {
  font-weight: bold;
  color: #000;
}

.main-content {
  padding: 20px;
}

@media (max-width: 900px) {
  .navbar {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .nav-links {
    flex-wrap: wrap;
    gap: 12px;
  }
}
</style>