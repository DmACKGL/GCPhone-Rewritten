<template>
  <div
    class="phone_title_content"
    :style="style"
    :class="{'hasInfoBare': showInfoBare}"
  >
    <InfoBare v-if="showInfoBare" />
    <div
      class="phone_title"
      :style="{backgroundColor: backgroundColor}"
    >
      <button
        class="btn-back"
        @click.stop="back"
      >
        <i
          class="fas fa-angle-left"
          @click.stop="back"
        />
      </button>
      {{ title }}
    </div>
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import InfoBare from './InfoBare'

export default {
  components: {
    InfoBare
  },
  props: {
    title: {
      type: String,
      required: true
    },
    showInfoBare: {
      type: Boolean,
      default: true
    },
    backgroundColor: {
      type: String,
      default: null,
    }
  },
  computed: {
    ...mapGetters(['themeColorTitle']),
    style () {
      return {
        backgroundColor: this.backgroundColor || this.themeColorTitle,
        color: this.color || '#FFF'
      }
    }
  },
  methods: {
    back () {
      this.$emit('back')
    }
  },

}
</script>
<style scoped>
</style>
