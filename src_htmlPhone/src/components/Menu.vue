<template>
  <div
    style="width: 326px; height: 743px;"
    class="phone_app"
  >
    <div
      style="
        width: 342px;
        height: 756px;
      "
      class="backblur"
      :style="{background: 'url(' + backgroundURL +')'}"
    />
    <InfoBare class="infobare" />
    <div
      class="menu"
      @click="onBack"
    >
      <div class="menu_content">
        <div class="menu_buttons">
          <button
            v-for="(but, key) of Apps"
            :key="but.name"
            class="letra"

            :class="{ select: key === currentSelect}"
            :style="{backgroundImage: 'url(' + but.icons +')'}"
            @click.stop="openApp(but)"
          >
            {{ but.intlName }}
            <span
              v-if="but.puce !== undefined && but.puce !== 0"
              class="puce"
            >{{ but.puce }}</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapGetters} from 'vuex'
import InfoBare from './InfoBare'

export default {
  components: {
    InfoBare
  },
  data: function () {
    return {
      currentSelect: 0,
      nBotonesMenu: 3,
    }
  },
  computed: {
    ...mapGetters(['nbMessagesUnread', 'backgroundURL', 'Apps', 'useMouse'])
  },
  created() {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowLeft', this.onLeft)
      this.$bus.$on('keyUpArrowRight', this.onRight)
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.currentSelect = -1
    }
    this.$bus.$on('keyUpBackspace', this.onBack)
  },
  beforeDestroy() {
    this.$bus.$off('keyUpArrowLeft', this.onLeft)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  },
  methods: {
    ...mapGetters(['closePhone']),
    onLeft: function () {
      const l = Math.floor(this.currentSelect / this.nBotonesMenu)
      const newS = (this.currentSelect + this.nBotonesMenu - 1) % this.nBotonesMenu + l * this.nBotonesMenu
      this.currentSelect = Math.min(newS, this.Apps.length - 1)
    },
    onRight: function () {
      const l = Math.floor(this.currentSelect / this.nBotonesMenu)
      let newS = (this.currentSelect + 1) % this.nBotonesMenu + l * this.nBotonesMenu
      if (newS >= this.Apps.length) {
        newS = l * this.nBotonesMenu
      }
      this.currentSelect = newS
    },
    onUp: function () {
      let newS = this.currentSelect - this.nBotonesMenu
      if (newS < 0) {
        const r = this.currentSelect % this.nBotonesMenu
        newS = Math.floor((this.Apps.length - 1) / this.nBotonesMenu) * this.nBotonesMenu
        this.currentSelect = Math.min(newS + r, this.Apps.length - 1)
      } else {
        this.currentSelect = newS
      }
    },
    onDown: function () {
      const r = this.currentSelect % this.nBotonesMenu
      let newS = this.currentSelect + this.nBotonesMenu
      if (newS >= this.Apps.length) {
        newS = r
      }
      this.currentSelect = newS
    },
    openApp(app) {
      this.$router.push({name: app.routeName})
    },
    onEnter() {
      this.openApp(this.Apps[this.currentSelect])
    },
    onBack: function () {
      this.$router.push({name: 'home'})
    }
  }
}
</script>

<style scoped>
.menu {
  position: relative;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  padding: 6px 8px;
}

.backblur {
  top: -6px;
  left: -6px;
  right: -6px;
  bottom: -6px;
  position: absolute;
  background-size: cover !important;
  background-position: center !important;
  -webkit-animation: blur 500ms;
  filter: blur(6px);

}

.menu_content {
  display: flex;
  flex-direction: column;
}

.menu_buttons {
  margin-top: 24px;
  display: flex;
  width: 100%;
  margin-left: 10px;
  align-items: flex-start;
  align-content: flex-start;
  flex-flow: row;
  flex-wrap: wrap;
  margin-bottom: 0;
  transition: all 0.5s ease-in-out;
}

.menu_buttons {
  animation-name: up;
  animation-duration: 0.6s;
  animation-fill-mode: forwards;
}

@keyframes blur {
  0% { filter: blur(0px);}
  50% { filter: blur(3px);}
  100% { filter: blur(6px);}
}

@keyframes up {
  from {
    transform: translate3d(0, 100vh, 0);
  }
  to {
    transform: translate3d(0, 0, 0);
  }
}



button {
  position: relative;
  border: none;
  width: 80px;
  height: 110px;
  margin: 8px;
  color: white;
  background-size: 64px 64px;
  background-position: center 6px;
  background-repeat: no-repeat;
  background-color: transparent;
  font-size: 14px;
  padding-top: 72px;
  text-align: center;
}

button .puce {
  position: absolute;
  display: block;
  background-color: #EE3838;
  font-size: 14px;
  width: 26px;
  height: 26px;
  top: -5px;
  left: 51px;
  line-height: 28px;
  text-align: center;
  border-radius: 50%;
  bottom: 32px;
  right: 12px;
}

button.select, button:hover {
  background-color: rgba(255, 255, 255, 0.2);
  border-radius: 12px;
}

.letra {
  font-weight: 400;
}

</style>
