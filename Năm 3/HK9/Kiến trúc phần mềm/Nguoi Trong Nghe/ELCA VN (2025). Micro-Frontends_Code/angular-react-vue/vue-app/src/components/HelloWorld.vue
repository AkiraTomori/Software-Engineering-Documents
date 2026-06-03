<template>
  <img alt="Vue logo" :src="vueLogo" />
   <img alt="Elca logo" :src="elcaLogo" />
  <h1>Hello from Vue</h1>
  <button @click="hello">Say hello</button>
</template>

<script>
import vueLogo from '../assets/logo.png'
import elcaLogo from '../assets/elca.png'
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  methods: {
    hello() {
      alert('Hi')
    }
  },
  data() { return { vueLogo, elcaLogo }; }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
