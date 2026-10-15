
<template>
  <section class="dashboard">
    <header class="welcome">
      <p class="eyebrow">TIME MANAGER / {{ roleTitle.toUpperCase() }}</p>
      <h1>{{ greeting }}, {{ username || 'User' }}!</h1>
      <p class="subtitle">{{ description }}</p>
      <span class="role-badge">{{ roleTitle }}</span>
    </header>

    <div class="summary">
      <div class="summary-card">
        <span>{{ summaryLabel }}</span>
        <strong>{{ roleTitle }}</strong>
        <small>Your current access level</small>
      </div>
      <div class="summary-card">
        <span>Account</span>
        <strong>{{ username || 'User' }}</strong>
        <small>Signed in successfully</small>
      </div>
    </div>

    <h2 class="section-title">{{ sectionTitle }}</h2>
    <p class="section-description">{{ sectionDescription }}</p>

    <div class="cards">
      <article
        v-for="item in cards"
        :key="item.title"
        class="card"
      >
        <div class="icon">{{ item.icon }}</div>
        <h3>{{ item.title }}</h3>
        <p>{{ item.description }}</p>
        <button
          v-if="item.to"
          @click="$router.push(item.to)"
        >
          {{ item.action }} →
        </button>
      </article>
    </div>

    <p class="notice">{{ notice }}</p>

    <button class="logout" @click="signOut">
      Sign out
    </button>
  </section>
</template>

<script>
import api from '../axios'

export default {
  name: 'RoleDashboard',

  computed: {
    username() {
      return localStorage.getItem('username') || ''
    },

    role() {
      return (localStorage.getItem('role') || 'employee').toLowerCase()
    },

    roleTitle() {
      return this.role.charAt(0).toUpperCase() + this.role.slice(1)
    },

    userId() {
      return localStorage.getItem('userId')
    },

    greeting() {
      if (this.role === 'admin') return 'Administration'
      if (this.role === 'manager') return 'Team overview'
      return 'Welcome back'
    },

    description() {
      if (this.role === 'admin') {
        return 'Manage user accounts, roles, and overall system activity.'
      }

      if (this.role === 'manager') {
        return 'Monitor working-time records and review your team’s activity.'
      }

      return 'Track your working hours, manage your clock, and review your progress.'
    },

    summaryLabel() {
      if (this.role === 'admin') return 'System access'
      if (this.role === 'manager') return 'Team access'
      return 'Personal access'
    },

    sectionTitle() {
      if (this.role === 'admin') return 'Administration tools'
      if (this.role === 'manager') return 'Team management'
      return 'My workspace'
    },

    sectionDescription() {
      if (this.role === 'admin') {
        return 'Tools for managing users and reviewing system information.'
      }

      if (this.role === 'manager') {
        return 'Tools for reviewing working times and team statistics.'
      }

      return 'Everything you need to manage your own working day.'
    },

    cards() {
      const id = this.userId

      if (this.role === 'admin') {
        return [
          {
            icon: '👥',
            title: 'User Management',
            description: 'Open the user area to review existing accounts.',
            action: 'Manage users',
            to: '/user'
          },
          {
            icon: '🛡️',
            title: 'Roles & Responsibilities',
            description: 'Administer account access and review assigned roles.',
            action: 'View users',
            to: '/user'
          },
          {
            icon: '📊',
            title: 'System Statistics',
            description: 'Open the existing charts page for working-time information.',
            action: 'View charts',
            to: id ? `/chartManager/${id}` : null
          },
          {
            icon: '📅',
            title: 'Working-Time Records',
            description: 'Open the working-time area for available records.',
            action: 'Open records',
            to: id ? `/workingTimes/${id}` : null
          }
        ]
      }

      if (this.role === 'manager') {
        return [
          {
            icon: '👥',
            title: 'Team Records',
            description: 'Review working-time records using the existing records page.',
            action: 'Review records',
            to: id ? `/workingTimes/${id}` : null
          },
          {
            icon: '📊',
            title: 'Team Statistics',
            description: 'Review available working-time charts and summaries.',
            action: 'View statistics',
            to: id ? `/chartManager/${id}` : null
          },
          {
            icon: '🕒',
            title: 'Attendance Overview',
            description: 'Open the clock area to review clock activity.',
            action: 'View clocks',
            to: id ? `/clock/${id}` : null
          }
        ]
      }

      return [
        {
          icon: '🕒',
          title: 'Clock In & Out',
          description: 'Record and review your clock activity.',
          action: 'Open clock',
          to: id ? `/clock/${id}` : null
        },
        {
          icon: '📅',
          title: 'My Working Times',
          description: 'Review your own working-time records.',
          action: 'View my times',
          to: id ? `/workingTimes/${id}` : null
        },
        {
          icon: '📈',
          title: 'My Statistics',
          description: 'Review your available working-time charts.',
          action: 'View statistics',
          to: id ? `/chartManager/${id}` : null
        },
        {
          icon: '➕',
          title: 'Add Working Time',
          description: 'Open the form for creating a working-time record.',
          action: 'Add record',
          to: id ? `/workingTime/${id}` : null
        }
      ]
    },

    notice() {
      if (this.role === 'admin') {
        return 'Administrator access should be enforced by the backend.'
      }

      if (this.role === 'manager') {
        return 'Team-wide access depends on the backend permissions and available team data.'
      }

      return 'Your working-time actions should be restricted to your own account.'
    }
  },

  methods: {
    async signOut() {
      try {
        await api.delete('/users/sign_out', {
          withCredentials: true
        })
      } catch (error) {
        console.error('Sign-out request failed:', error)
      } finally {
        localStorage.removeItem('xsrfToken')
        localStorage.removeItem('userId')
        localStorage.removeItem('username')
        localStorage.removeItem('roleId')
        localStorage.removeItem('role')
        this.$router.push('/sign_in')
      }
    }
  }
}
</script>

<style scoped>
.dashboard {
  max-width: 1100px;
  margin: 0 auto;
  padding: 32px 24px;
  color: #111827;
}

.welcome {
  position: relative;
  padding: 30px;
  margin-bottom: 24px;
  background: linear-gradient(135deg, #eff6ff, #ffffff);
  border: 1px solid #dbeafe;
  border-radius: 18px;
}

.eyebrow {
  color: #2563eb;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 1.5px;
}

h1 {
  margin: 14px 0 8px;
  font-size: 32px;
}

.subtitle {
  color: #64748b;
  line-height: 1.6;
}

.role-badge {
  display: inline-block;
  margin-top: 8px;
  padding: 6px 12px;
  border-radius: 20px;
  background: #dbeafe;
  color: #1d4ed8;
  font-size: 12px;
  font-weight: 700;
}

.summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
  margin-bottom: 32px;
}

.summary-card {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 22px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 14px;
}

.summary-card span,
.summary-card small {
  color: #64748b;
}

.summary-card strong {
  font-size: 21px;
  overflow-wrap: anywhere;
}

.section-title {
  margin-bottom: 8px;
  font-size: 23px;
}

.section-description {
  margin-bottom: 22px;
  color: #64748b;
}

.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
  gap: 20px;
}

.card {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  padding: 24px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 15px;
  box-shadow: 0 4px 14px rgba(15, 23, 42, 0.04);
}

.icon {
  font-size: 30px;
}

.card h3 {
  margin: 16px 0 8px;
  font-size: 18px;
}

.card p {
  flex: 1;
  color: #64748b;
  line-height: 1.6;
}

.card button,
.logout {
  margin-top: 16px;
  padding: 11px 16px;
  color: white;
  background: #2563eb;
  border: 0;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
}

.card button:hover {
  background: #1d4ed8;
}

.notice {
  margin-top: 28px;
  padding: 14px 16px;
  color: #475569;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  line-height: 1.5;
}

.logout {
  background: #475569;
}

@media (max-width: 600px) {
  .dashboard {
    padding: 20px 14px;
  }

  .welcome {
    padding: 22px;
  }

  h1 {
    font-size: 26px;
  }
}
</style>
