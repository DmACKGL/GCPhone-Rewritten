<template>
  <div
    style="height: 100vh; width: 100vw;"
    @contextmenu="closePhone"
  >
    <notification />
    <div
      v-if="show === true && tempoHide === false"
      :style="{zoom: zoom}"
      @contextmenu.stop
    >
      <div class="phone_wrapper">
        <div
          v-if="coque"
          class="phone_coque"
          :style="{backgroundImage: 'url(/html/static/img/coque/' + coque.value + ')'}"
        />

        <div
          id="app"
          class="phone_screen"
        >
          <router-view />
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import './PhoneBaseStyle.scss'
import { mapGetters, mapActions } from 'vuex'
import {Howl} from 'howler'
export default {
  name: 'App',
  components: {
  },

  data: function () {
    return {
      soundCall: null
    }
  },

  computed: {
    ...mapGetters(['show', 'zoom', 'coque', 'sonido', 'appelsInfo', 'myPhoneNumber', 'volume', 'tempoHide'])
  },

  watch: {
    appelsInfo (newValue, oldValue) {
      if (this.appelsInfo !== null && this.appelsInfo.is_accepts !== true) {
        if (this.soundCall !== null) {
          this.soundCall.pause()
        }

        let path = '/html/static/sound/Phone_Call_Sound_Effect.ogg';

        if (!this.appelsInfo.initiator) path = '/html/static/sound/' + this.sonido.value

        this.soundCall = new Howl({
          src: path,
          volume: this.volume,
          loop: true,
        })

        this.soundCall.play()
      } else if (this.soundCall !== null) {
        this.soundCall.pause()
        this.soundCall = null
      }
      if (newValue === null && oldValue !== null) {
        this.$router.push({name: 'home'})
        return
      }
      if (newValue !== null) {
        this.$router.push({name: 'appels.active'})
      }
    },
    show () {
      if (this.appelsInfo !== null) {
        this.$router.push({name: 'appels.active'})
      } else {
        this.$router.push({name: 'home'})
      }
      if (this.show === false && this.appelsInfo !== null) {
        this.rejectCall()
      }
    }
  },

  mounted () {
    this.loadConfig()
    window.addEventListener('message', (event) => {
      if (event.data.keyUp !== undefined) {
        this.$bus.$emit('keyUp' + event.data.keyUp)
      }
    })
    window.addEventListener('keyup', (event) => {
      const keyValid = ['ArrowRight', 'ArrowLeft', 'ArrowUp', 'ArrowDown', 'Backspace', 'Enter']
      if (keyValid.indexOf(event.key) !== -1) {
        this.$bus.$emit('keyUp' + event.key)
      }
      if (event.key === 'Escape') {
        this.$phoneAPI.closePhone()
      }
    })
  },

  methods: {
    ...mapActions(['loadConfig', 'rejectCall']),
    closePhone () {
      this.$phoneAPI.closePhone()
    }
  }
}
</script>

<style lang="scss">
</style>
