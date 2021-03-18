<template>
  <div style="width: 326px; height: 743px;">
    <list
      :list="contactsList"
      :show-header="false"
      @select="onSelect"
    />
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { generateColorForStr } from '@/Utils'
import List from './../List.vue'

export default {
  name: 'Contacts',
  components: { List },
  data () {
    return {
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'contacts']),
    contactsList () {
      return [{
        display: this.IntlString('APP_PHONE_ENTER_NUMBER'),
        letter: '#',
        backgroundColor: '#D32F2F',
        custom: true
      }, ...this.contacts.slice(0).map(c => {
        c.backgroundColor = generateColorForStr(c.number)
        return c
      })]
    }
  },
  created () {

  },
  beforeDestroy () {
  },
  methods: {
    ...mapActions(['startCall']),
    onSelect (itemSelect) {
      if (itemSelect !== undefined) {
        if (itemSelect.custom === true) {
          this.$router.push({name: 'appels.number'})
        } else {
          this.startCall({ numero: itemSelect.number })
        }
      }
    }
  }
}
</script>

<style scoped>

</style>
