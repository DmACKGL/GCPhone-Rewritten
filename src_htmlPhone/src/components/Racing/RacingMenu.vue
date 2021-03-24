<template>
  <div
    id="phone_app"
    class="phone_app"
  >
    <div class="elements">
      <div
        v-for="(val, key) in races"
        :key="key"
        class="element card shadow mr-3"
        :class="{'active': selectIndex === key}"
        @click.stop="selectItem(val)"
      >
        <h5 class="card-title">
          {{ val.eventName }}
        </h5>
        <div class="card-body p-0">
          <div class="row m-1 text-center">
            <div class="col">
              <font-awesome-icon :icon="['fas', 'user']" />
              <br>
              1
            </div>
            <div class="col">
              <font-awesome-icon :icon="['fas', 'money-bill-alt']" />
              <br>
              ${{ val.money | toCurrency }}
            </div>
            <div class="col">
              <font-awesome-icon :icon="['fas', 'road']" />
              <br>
              {{ racingTracks.find(track => track.id === val.trackID).name }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapActions, mapGetters} from 'vuex'
import Modal from '@/components/Modal/index.js'
import Swal from 'sweetalert2'

export default {
  name: 'Recents',
  components: {},
  data () {
    return {
      ignoreControls: false,
      selectIndex: 0
    }
  },

  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'races' , 'racingTracks']),
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.selectIndex = -1
    }
    this.$bus.$on('keyUpBackspace', this.onBack)
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  },
  methods: {
    ...mapActions(['startCall', 'addContact']),
    getContact (num) {
      return this.contacts.find(e => e.number === num)
    },
    scrollIntoViewIfNeeded: function () {
      this.$nextTick(() => {
        this.$el.querySelector('.active').scrollIntoViewIfNeeded()
      })
    },
    onBack() {
      if (this.ignoreControls === true) return
    },
    onUp () {
      if (this.ignoreControls === true) return
      this.selectIndex = Math.max(0, this.selectIndex - 1)
      this.scrollIntoViewIfNeeded()
    },
    onDown () {
      if (this.ignoreControls === true) return
      this.selectIndex = Math.min(this.races.length - 1, this.selectIndex + 1)
      this.scrollIntoViewIfNeeded()
    },
    async selectItem (item) {
      const raceID = item.num
      this.ignoreControls = true
      this.$bus.$emit('ignoreControls', true)
      let choix = [
        {id: 0, title: this.IntlString('APP_RACING_JOIN'), icons: 'check-circle', color: 'green'}
      ]
      const rep = await Modal.CreateModal({ choix })
      this.ignoreControls = false
      this.$bus.$emit('ignoreControls', false)
      switch (rep.id) {
        case 0:
          await Swal.fire({
            icon: 'success',
            title: 'All set!',
            text: `You joined the race! ${raceID}`,
            target: '.phone_screen',
            showConfirmButton: false,
            timer: 1500
          })
          break
      }
    },
    async onEnter () {
      if (this.ignoreControls === true) return
      await this.selectItem(this.races[this.selectIndex])
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

.element{
  display: flex;
  align-items: center;
  position: relative;
  margin: 14px 10px;
  border-radius: 2px;
}
.active, .element:hover {
  background: radial-gradient(rgba(3, 168, 244, 0.14), rgba(3, 169, 244, 0.26));
}
.elem-pic{
  margin-left: 12px;
  height: 48px;
  width: 48px;
  text-align: center;
  line-height: 48px;
  font-weight: 700;
  border-radius: 50%;
  color: white;
}

.time{
  margin-right: 12px;
  font-size: 13px;
  font-weight: 500;
  color: #c8c7cb;
}

.elem-content{
  margin-left: 12px;
  width: auto;
  flex-grow: 1;
  margin-top: 13px;
}

.elem-content-p{
  font-size: 20px;
  line-height: 20px;
  width: 153px;
}
.elem-content-s{
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
.elem-icon{
  width: 28px;
}

</style>
