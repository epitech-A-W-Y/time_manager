<template>
  <div>
    <nav>
      <router-link to="/user">User</router-link>
      |
      <router-link to="/workingTimes/1">Working Times</router-link>
      |
      <router-link to="/manager">Manager</router-link>
      |
      <router-link to="/hr">HR</router-link>
    </nav>

    <router-view />
  </div>
</template>
