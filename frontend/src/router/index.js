
import { createRouter, createWebHistory } from 'vue-router'

import User from '../components/User.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import WorkingTime from '../components/WorkingTime.vue'
import ClockManager from '../components/ClockManager.vue'
import ChartManager from '../components/ChartManager.vue'
import SignIn from '../components/SignIn.vue'
import SignUp from '../components/SignUp.vue'
import RoleDashboard from '../components/RoleDashboard.vue'
import Communication from '../components/Communication.vue'
import Employee from '../components/Employee.vue'
import Manager from '../components/Manager.vue'
import Administrator from '../components/Administrator.vue'


const router = createRouter({
  history: createWebHistory(),

  routes: [
    {
      path: '/',
      redirect: '/sign_in',
      meta: { public: true }
    },
    {
      path: '/sign_in',
      name: 'SignIn',
      component: SignIn,
      meta: { public: true }
    },
    {
      path: '/sign_up',
      name: 'SignUp',
      component: SignUp,
      meta: { public: true }
    },
    {
      path: '/employee',
      name: 'EmployeeDashboard',
      component: RoleDashboard,
      meta: { requiresAuth: true, roles: ['employee'] }
    },
    {
      path: '/manager',
      name: 'ManagerDashboard',
      component: RoleDashboard,
      meta: { requiresAuth: true, roles: ['manager'] }
    },
    {
      path: '/admin',
      name: 'AdminDashboard',
      component: RoleDashboard,
      meta: { requiresAuth: true, roles: ['admin'] }
    },
    {
      path: '/administrator',
      redirect: '/admin'
    },
    {
      path: '/communication',
      name: 'Communication',
      component: Communication,
      meta: { requiresAuth: true }
    },
    {
      path: '/legacy-employee',
      name: 'LegacyEmployee',
      component: Employee,
      meta: { requiresAuth: true, roles: ['employee'] }
    },
    {
      path: '/legacy-manager',
      name: 'LegacyManager',
      component: Manager,
      meta: { requiresAuth: true, roles: ['manager'] }
    },
    {
      path: '/legacy-administrator',
      name: 'LegacyAdministrator',
      component: Administrator,
      meta: { requiresAuth: true, roles: ['admin'] }
    },
    {
      path: '/user',
      name: 'User',
      component: User,
      meta: { requiresAuth: true }
    },
    {
      path: '/workingTimes/:userID',
      name: 'WorkingTimes',
      component: WorkingTimes,
      props: true,
      meta: { requiresAuth: true }
    },
    {
      path: '/workingTime/:userid',
      name: 'WorkingTimeCreate',
      component: WorkingTime,
      meta: { requiresAuth: true }
    },
    {
      path: '/workingTime/:userid/:workingtimeid',
      name: 'WorkingTimeEdit',
      component: WorkingTime,
      meta: { requiresAuth: true }
    },
    {
      path: '/clock/:userid',
      name: 'ClockManager',
      component: ClockManager,
      meta: { requiresAuth: true }
    },
    {
      path: '/chartManager/:userid',
      name: 'ChartManager',
      component: ChartManager,
      meta: { requiresAuth: true }
    }
  ]
})

router.beforeEach((to) => {
  const xsrfToken = localStorage.getItem('xsrfToken')
  const userId = localStorage.getItem('userId')
  const role = (localStorage.getItem('role') || '').toLowerCase()

  if (to.meta.requiresAuth && (!xsrfToken || !userId)) {
    return '/sign_in'
  }

  if (to.meta.roles && !to.meta.roles.includes(role)) {
    if (role === 'admin') return '/admin'
    if (role === 'manager') return '/manager'
    if (role === 'employee') return '/employee'
    return '/sign_in'
  }

  if (
    (to.path === '/sign_in' || to.path === '/sign_up') &&
    xsrfToken &&
    userId
  ) {
    if (role === 'admin') return '/admin'
    if (role === 'manager') return '/manager'
    if (role === 'employee') return '/employee'
    return '/user'
  }

  return true
})

export default router

