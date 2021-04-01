<template>
  <div
    id="phone_app"
    class="phone_app"
  >
    <div class="elements">
      <div
        v-for="(val, key) in racingTracks"
        :key="key"
        class="element card shadow mr-3"
        :class="{'active': selectIndex === key}"
        @click.stop="selectItem(val)"
      >
        <div class="card-body p-1">
          <div class="row">
            <div class="col">
              <font-awesome-icon :icon="['fas', 'flag-checkered']" />
              {{ val.name }}
            </div>
            <div class="col-md-auto text-muted">
              <font-awesome-icon :icon="['fas', 'route']" />
              {{ val.km | units('m', 'km', true) }}
            </div>
          </div>
          <div class="row">
            <div class="col">
              <font-awesome-icon :icon="['fas', 'road']" />
              {{ val.type }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapGetters} from 'vuex'
import Modal from '@/components/Modal/index.js'

require('jquery');
require('popper.js');
require('bootstrap');


export default {
  name: 'Recents',
  components: {},
  data() {
    return {
      trackID: 0,
      ignoreControls: false,
      selectIndex: 0,
    }
  },

  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'racingTracks']),
  },
  created() {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.selectIndex = -1
    }
    this.$bus.$on('keyUpBackspace', this.onBack)
  },
  beforeDestroy() {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  },
  methods: {
    scrollIntoViewIfNeeded: function () {
      this.$nextTick(() => {
        this.$el.querySelector('.active').scrollIntoViewIfNeeded()
      })
    },
    onUp() {
      if (this.ignoreControls === true) return
      this.selectIndex = Math.max(0, this.selectIndex - 1)
      this.scrollIntoViewIfNeeded()
    },
    onDown() {
      if (this.ignoreControls === true) return
      this.selectIndex = Math.min(this.racingTracks.length - 1, this.selectIndex + 1)
      this.scrollIntoViewIfNeeded()
    },
    async selectItem(item) {
      this.$bus.$emit('changeSelectedTrack', item.id)
      this.ignoreControls = true
      let choix = [
        {id: 0, title: this.IntlString('APP_RACING_CREATE'), icons: 'flag-checkered', color: 'green'},
        {id: 1, title: this.IntlString('APP_RACING_CREATE_PREVIEW'), icons: 'eye', color: 'orange'},
        {id: 2, title: this.IntlString('APP_RACING_CREATE_GPS'), icons: 'map-marker'},
      ]
      const rep = await Modal.CreateModal({choix})
      this.ignoreControls = false
      switch (rep.id) {
        case 0:
          this.$bus.$emit('creating', true)
          break
      }
    },
    async onEnter() {
      if (this.ignoreControls === true) return
      await this.selectItem(this.racingTracks[this.selectIndex])
    },
  },
}
</script>


<style scoped lang="scss">
*::v-deep {
  @import '~bootstrap/scss/bootstrap.scss';
}
</style>

<style scoped>
.content {
  height: 100%;
}

.elements {
  overflow-y: auto;
}

.element {
  display: flex;
  position: relative;
  margin: 14px 10px;
  border-radius: 2px;
}

.active, .element:hover {
  background: radial-gradient(rgba(3, 168, 244, 0.14), rgba(3, 169, 244, 0.26));
}
.select{
  background: radial-gradient(rgba(3, 168, 244, 0.14), rgba(3, 169, 244, 0.26));
}

.elem-pic {
  margin-left: 12px;
  height: 48px;
  width: 48px;
  text-align: center;
  line-height: 48px;
  font-weight: 700;
  border-radius: 50%;
  color: white;
}

.time {
  margin-right: 12px;
  font-size: 13px;
  font-weight: 500;
  color: #c8c7cb;
}

.elem-content {
  margin-left: 12px;
  width: auto;
  flex-grow: 1;
  margin-top: 13px;
}

.elem-content-p {
  font-size: 20px;
  line-height: 20px;
  width: 153px;
}

.elem-content-s {
  font-size: 12px;
  line-height: 18px;
  width: 137px;
  display: flex;
}

.elem-histo-pico {
  display: flex;
  flex-direction: column;
}

.elem-histo-pico svg {
  width: 16px;
  height: 16px;
  margin-left: 6px;
}

.lastCall {
  padding-left: 4px;
}

.elem-icon {
  width: 28px;
}

</style>
