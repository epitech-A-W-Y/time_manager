
import { createRouter, createWebHashHistory } from 'vue-router'

import Auth from '../components/Auth.vue'
import Communication from '../components/Communication.vue'
import Employee from '../components/Employee.vue'
import Manager from '../components/Manager.vue'
import Administrator from '../components/Administrator.vue'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    component: Auth
  },
  {
    path: '/employee',
    component: Employee
  },
  {
    path: '/manager',
    component: Manager
  },
  {
    path: '/administrator',
    component: Administrator
  },
  {
    path: '/communication',
    component: Communication
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
