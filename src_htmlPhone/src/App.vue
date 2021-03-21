<template>
  <div
    style="height: 100vh; width: 100vw;"
    @contextmenu="closePhone"
  >
    <notification />
    <div
      v-if="showPhone && tempoHide === false"
      :style="{zoom: zoom}"
      :class="{
        'getin-phone': !notification && showPhone,
        'getout-phone': fadeout,
        'notin-phone': notification,
      }"
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
import store from '@/store'

export default {
  name: 'App',
  components: {
  },
  data: function () {
    return {
      showPhone: false,
      fadeout: false,
      soundCall: null,
      notification: false,

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
      if (this.show) {
        this.fadeout = false
        this.showPhone = true
      } else {
        this.fadeout = true
        this.removePhone(2000);
      }
    },
  },

  mounted () {
    this.loadConfig()
    window.addEventListener('message', (event) => {
      if (event.data.event === 'notification') {
        // FIXME: create store for 'notifications'
        store.commit('SET_PHONE_VISIBILITY', true)
        this.notification = true
        this.removePhone(7)
      }
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
    },
    removePhone (timer) {
      new Promise((resolve) => {
        setTimeout(() => {
          if (!this.show) {
            this.showPhone = false;
            this.notification = false;
          }else {
            // FIXME: create store for 'notifications'
            store.commit('SET_PHONE_VISIBILITY', false)
          }
          resolve();
        },timer)
      })
    }
  }
}
</script>

<style lang="scss">
body {
  overflow-y: hidden;
  overflow-x: hidden;
}

.getin-phone {
  -webkit-animation: getin-phone 1s;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

@keyframes getin-phone {
  0% {
    position: absolute;
    transform: translateY(100%);
  }
  100% {
    position: absolute;
    transform: translateY(0%);
  }
}
.getout-phone {
  -webkit-animation: getout-phone 1s forwards;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

@keyframes getout-phone {
  0% {
    position: absolute;
    transform: translateY(0%);
  }
  100% {
    position: absolute;
    transform: translateY(100%);
  }
}

.notin-phone {
  -webkit-animation-name: notin-phone, notout-phone;
  -webkit-animation-fill-mode: forwards;
  -webkit-animation-duration: 1s, 1s;
  -webkit-animation-delay: 0ms, 4s;
  -webkit-animation-iteration-count: 1, 1;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

@keyframes notin-phone {
  0% {
    position: absolute;
    transform: translateY(100%);
  }
  100% {
    position: absolute;
    transform: translateY(65%);
  }
}

@keyframes notout-phone {
  0% {
    position: absolute;
    transform: translateY(65%);
  }
  100% {
    position: absolute;
    transform: translateY(100%);
  }
}


</style>
