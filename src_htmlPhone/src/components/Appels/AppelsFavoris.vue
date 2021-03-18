<template>
  <div>
    <list
      :list="callList"
      :show-header="false"
      :disable="ignoreControls"
      @select="onSelect"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import List from './../List.vue'
import Modal from '@/components/Modal/index.js'

export default {
  name: 'Favoris',
  components: { List },
  data () {
    return {
      ignoreControls: false
    }
  },
  computed: {
    ...mapGetters(['config']),
    callList () {
      return this.config.serviceCall || []
    }
  },

  created () {
  },

  beforeDestroy () {
  },
  methods: {
    onSelect (itemSelect) {
      if (this.ignoreControls === true) return
      this.ignoreControls = true
      Modal.CreateModal({choix: [...itemSelect.subMenu, {title: 'Cancelar'}]}).then(rep => {
        this.ignoreControls = false
        if (rep.title === 'Cancelar') return
        this.$phoneAPI.callEvent(rep.eventName, rep.type)
        this.$router.push({name: 'home'})
      })
    }
  }
}
</script>

<style scoped>

</style>
