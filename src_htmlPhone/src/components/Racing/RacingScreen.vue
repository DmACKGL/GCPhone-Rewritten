<template>
  <div
    id="phone_app"
    style="width: 326px; height: 743px;"
    class="phone_app"
  >
    <PhoneTitle
      title="Racing"
      @back="onBackspace"
    />
    <div class="content">
      <component
        :is="subMenu[currentMenuIndex].Comp"
        :selectedtrack="selectedTrack"
      />
    </div>
    <div
      v-if="raceInfo.active"
      class="subMenu"
    >
      <div
        class="subMenu-elem"
        :style="{color: themeColor}"
      >
        <div class="subMenu-icon">
          <FontAwesomeIcon
            :icon="['fas', subMenu[0].icon]"
          />
        </div>
        <span
          class="subMenu-name"
        >
          {{ subMenu[0].name }}
        </span>
      </div>
    </div>
    <div
      v-if="!raceInfo.active"
      class="subMenu"
    >
      <div
        v-for="(Comp, i) of subMenu.slice(0, -1)"
        :key="i"
        class="subMenu-elem"
        :style="getColorItem(i)"
        @click="swapMenu(i)"
      >
        <div class="subMenu-icon">
          <FontAwesomeIcon
            :icon="['fas', Comp.icon]"
            @click.stop="swapMenu(i)"
          />
        </div>
        <span
          class="subMenu-name"
          @click.stop="swapMenu(i)"
        >
          {{ Comp.name }}
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import PhoneTitle from './../PhoneTitle'
import store from '@/store'
import RacingMenu from "./RacingMenu";
import RacingCreate from "./RacingCreate";
import RacingForm from "./RacingForm";
import {mapGetters} from 'vuex'

export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      currentMenuIndex: 0,
      ignoreControls: false,
      creating: false,
      selectedTrack: null,
    }
  },
  computed: {
    ...mapGetters(['raceInfo', 'IntlString', 'useMouse', 'themeColor']),
    subMenu () {
      return [{
        Comp: RacingMenu,
        name: this.IntlString('APP_RACING_MENU_RACES'),
        icon: 'flag-checkered'
      },
      {
        Comp: RacingCreate,
        name: this.IntlString('APP_RACING_MENU_MAPS'),
        icon: 'map-marker'
      },
      {
        Comp: RacingMenu,
        name: this.IntlString('APP_RACING_MENU_LEADERBOARD'),
        icon: 'trophy'
      },
      {
        Comp: RacingForm,
      }]
    },
    isOnRace() {
      return !!this.raceInfo.raceID
    }
  },

  created () {
    store.dispatch('racingGet')
    if (!this.useMouse) {
      this.$bus.$on('keyUpBackspace', this.onBackspace)
      this.$bus.$on('keyUpArrowLeft', this.onLeft)
      this.$bus.$on('keyUpArrowRight', this.onRight)
    }
    this.$bus.$on('changeSelectedTrack', (data) => this.selectedTrack = data)
    this.$bus.$on('ignoreControls', this.ignore)
    this.$bus.$on('racingHome', this.home)
    this.$bus.$on('creating', (data) =>{
      this.creating = data
      if (this.creating) {
        this.currentMenuIndex = this.subMenu.length - 1
      }else {
        this.currentMenuIndex = 0
      }
    })
  },
  beforeDestroy () {
    this.$bus.$off('keyUpBackspace', this.onBackspace)
    this.$bus.$off('keyUpArrowLeft', this.onLeft)
    this.$bus.$off('keyUpArrowRight', this.onRight)
  },
  methods: {
    getColorItem (index) {
      if (this.currentMenuIndex === index) {
        return {
          color: this.themeColor
        }
      }
      return {}
    },
    ignore(data) {
      this.ignoreControls = data
      if (this.ignoreControls) {
        this.$bus.$off('keyUpEnter', this.onEnter)
        this.$bus.$off('keyUpBackspace', this.onBack)
        this.$bus.$off('keyUpArrowLeft', this.onLeft)
        this.$bus.$off('keyUpArrowRight', this.onRight)
      } else {
        this.$bus.$on('keyUpEnter', this.onEnter)
        this.$bus.$on('keyUpBackspace', this.onBack)
        this.$bus.$on('keyUpArrowLeft', this.onLeft)
        this.$bus.$on('keyUpArrowRight', this.onRight)
      }
    },
    home() {
      this.currentMenuIndex = 0
    },
    swapMenu (index) {
      this.currentMenuIndex = index
    },
    onLeft () {
      if (!this.isOnRace && !this.creating) {
        this.currentMenuIndex = Math.max(this.currentMenuIndex - 1, 0)
      }
    },
    onRight () {
      if (!this.isOnRace && !this.creating) {
        this.currentMenuIndex = Math.min(this.currentMenuIndex + 1, this.subMenu.length - 1)
      }
    },
    onBackspace: function () {
      if (!this.ignoreControls === true && this.currentMenuIndex === 0 || this.isOnRace) {
        this.$router.push({ name: 'menu' })
      } else if (!this.ignoreControls && this.currentMenuIndex !== 0 && !this.creating){
        this.currentMenuIndex--
      }
    },
  }
}
</script>

<style scoped>
.screen{
  position: relative;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}
.title{
  padding-left: 16px;
  height: 34px;
  line-height: 34px;
  font-weight: 700;
  color: white;
  background-color: #2c3e50;
}
.content{
  height: calc(100% - 68px);
  overflow-y: auto;
  width: 337px;
}
.subMenu{
  border-top: 1px solid rgba(0,0,0,0.24);
  display: flex;
  height: 56px;
}
.subMenu-elem {
  width: 100%;
  text-align: center;
  line-height: 56px;
  height: 56px;
  display: flex;
  color: #959595;
  flex-direction: column;
}
.subMenu-elem-select, .subMenu-elem:hover {
  color: #007aff;
}
.subMenu-icon{
  margin-top: 6px;
  font-size: 22px;
  line-height: 22px;
  height: 22px;
}
.subMenu-name{
  display: block;
  font-size: 14px;
  height: 14px;
  line-height: 14px;
}
</style>
