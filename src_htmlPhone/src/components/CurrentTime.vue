<template>
  <span>{{ time }}</span>
</template>

<script>
export default {
  data () {
    return {
      time: '',
      myInterval: 0
    }
  },
  created: function () {
    this.updateTime()
    this.myInterval = setInterval(this.updateTime, 1000)
  },
  beforeDestroy: function () {
    clearInterval(this.myInterval)
  },
  methods: {
    updateTime: function () {
      const time = new Date();
      let minutes = time.getMinutes();
      minutes = minutes > 9 ? minutes : '0' + minutes
      let heure = time.getHours();
      heure = heure > 9 ? heure : '0' + heure
      this.time = heure + ':' + minutes
    }
  }
}
</script>

<style scoped>
</style>
