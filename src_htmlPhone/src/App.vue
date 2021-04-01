<template>
  <div>
    <div
      style="height: 100vh; width: 100vw;"
      @contextmenu="closePhone"
    >
      <RacingHUD v-if="raceInfo.active" />
      <notification />
      <div
        v-if="showPhone && tempoHide === false"
        :style="{zoom: zoom}"
        :class="{
          'getin-phone': !notification && showPhone,
          'getout-phone': !notification && fadeout,
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
    }
  },

  computed: {
    ...mapGetters(['raceInfo', 'notification', 'notificationInfo', 'show', 'zoom', 'coque', 'sonido', 'appelsInfo', 'myPhoneNumber', 'volume', 'tempoHide']),
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
        this.removePhone(1000);
      }
      store.commit('SET_NOTIFICATION_SHOW', false)
    },
    notification () {
      if (this.notification) {
        this.showPhone = true
        this.removePhone(6000)
      }
    },
  },

  mounted () {
    if (process.env.NODE_ENV !== 'production') {
      this.showPhone = true
    }
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
    },
    removePhone (timer) {
      new Promise((resolve) => {
        setTimeout(() => {
          if (!this.show) {
            this.showPhone = false;
          }
          store.commit('SET_NOTIFICATION_SHOW', false)
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
    transform: translate3d(0, 100vh, 0);
  }
  100% {
    position: absolute;
    transform: translate3d(0, 0, 0);
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
    transform: translate3d(0, 0 ,0);
  }
  100% {
    position: absolute;
    transform: translate3d(0, 100vh, 0);
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
    transform: translate3d(0, 100vh ,0);
  }
  100% {
    position: absolute;
    transform: translate3d(0, 70vh, 0);
  }
}

@keyframes notout-phone {
  0% {
    position: absolute;
    transform: translate3d(0, 70vh, 0);
  }
  100% {
    position: absolute;
    transform: translate3d(0, 100vh, 0);
  }
}


</style>
