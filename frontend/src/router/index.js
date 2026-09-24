import { createRouter, createWebHistory } from 'vue-router'
import User from '../components/User.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import WorkingTime from '../components/WorkingTime.vue'
import ClockManager from '../components/ClockManager.vue'
import ChartManager from '../components/ChartManager.vue'

const router = createRouter({
  history: createWebHistory(),

  routes: [
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
      path: '/workingTime',
      name: 'WorkingTime', 
      component: WorkingTime
    },
    {
      path: '/clockManager',
      name: 'ClockManager',
      component: ClockManager
    },
    {
      path: '/charts',
      name: 'ChartManager',
      component: ChartManager
    }
  ]
})

export default router