import { createRouter, createWebHistory } from 'vue-router'

import User from '../components/User.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import WorkingTime from '../components/WorkingTime.vue'
import ClockManager from '../components/ClockManager.vue'
import ChartManager from '../components/ChartManager.vue'
import SignIn from '../components/SignIn.vue'
import SignUp from '../components/SignUp.vue'

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

  if (to.meta.requiresAuth && (!xsrfToken || !userId)) {
    return '/sign_in'
  }

  if (
    (to.path === '/sign_in' || to.path === '/sign_up') &&
    xsrfToken &&
    userId
  ) {
    return '/user'
  }

  return true
})

export default router
