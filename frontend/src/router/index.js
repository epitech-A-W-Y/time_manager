import { createRouter, createWebHistory } from 'vue-router'
import User from '../components/User.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import WorkingTime from '../components/WorkingTime.vue'

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
    }
  ]
})

export default router