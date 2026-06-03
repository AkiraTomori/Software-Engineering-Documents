

<script>
import HelloWorld from './components/HelloWorld.vue'
import vueLogo from './assets/logo.png'
export default {
  name: 'App',
  components: {
    HelloWorld
  },
  data() { return { vueLogo }; }
}
</script>
<template>
  <HelloWorld msg="Welcome to Your Vue.js App"/>
</template>
<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
