import { createRouter, createWebHistory } from 'vue-router'

import Communication from '../components/Communication.vue'
import Employee from '../components/Employee.vue'
import Manager from '../components/Manager.vue'
import Administrator from '../components/Administrator.vue'

const routes = [
  {
    path: '/',
    redirect: '/employee'
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
  history: createWebHistory(),
  routes
})

export default router