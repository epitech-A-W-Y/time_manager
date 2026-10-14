import { createRouter, createWebHistory } from 'vue-router'

import User from '../components/User.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import ManagerDashboard from '../components/ManagerDashboard.vue'
import HRDashboard from '../components/HRDashboard.vue'

const router = createRouter({
  history: createWebHistory(),

  routes: [
    {
      path: '/',
      redirect: '/user'
    },
    {
      path: '/user',
      name: 'User',
      component: User
    },
    {
      path: '/workingTimes/:userID',
      name: 'WorkingTimes',
      component: WorkingTimes,
      props: true
    },
    {
      path: '/manager',
      name: 'Manager',
      component: ManagerDashboard
    },
    {
      path: '/hr',
      name: 'HR',
      component: HRDashboard
    }
  ]
})

export default router
