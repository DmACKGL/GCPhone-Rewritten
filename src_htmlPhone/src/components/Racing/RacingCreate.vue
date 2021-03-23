<template>
  <div
    id="phone_app"
    class="phone_app"
  >
    <template v-if="state === STATES.MENU">
      <div class="elements">
        <div
          v-for="(val, key) in tracks"
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
                {{ val.km }}
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
    </template>

    <template v-else-if="state === STATES.CREATE">
      <div class="container pr-3 mt-1">
        <div
          class="form-group group"
          data-type="text"
        >
          <label for="eventName">
            <small>{{ IntlString('APP_RACING_CREATE_EVENTNAME') }}</small>
          </label>
          <input
            id="eventName"
            class="form-control"
            type="text"
            :value="raceCreate.eventName"
          >
        </div>
        <div
          class="form-group group"
          data-type="text"
        >
          <label for="yourAlias">
            <small>{{ IntlString('APP_RACING_CREATE_ALIAS') }}</small>
          </label>
          <input
            id="yourAlias"
            class="form-control"
            type="text"
            :value="raceCreate.yourAlias"
          >
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import {mapActions, mapGetters} from 'vuex'
import Modal from '@/components/Modal/index.js'

require('jquery');
require('popper.js');
require('bootstrap');

const STATES = Object.freeze({
  MENU: 0,
  CREATE: 1
})

export default {
  name: 'Recents',
  components: {},
  data() {
    return {
      STATES,
      state: STATES.MENU,
      ignoreControls: false,
      selectIndex: 0,
      selectTrack: 0,
      tracks: [
        {
          name: "Grand Prix 3.0",
          type: "Lap",
          km: "18.26 KM"
        },
        {
          name: "Drag Queen",
          type: "Sprint",
          km: "300 KM"
        }
      ],
      raceCreate: {
        eventName: "",
        yourAlias: "",
        Laps: null,
        money: null,
        CST: null,
        reverse: false,
        showPosition: false,
        sendNotification: false,
      }
    }
  },

  computed: {
    ...mapGetters(['IntlString', 'useMouse']),
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
    ...mapActions([]),
    create() {

    },
    scrollIntoViewIfNeeded: function () {
      this.$nextTick(() => {
        this.$el.querySelector('.active').scrollIntoViewIfNeeded()
      })
    },
    onBack() {
      if (this.state !== this.STATES.MENU) {
        this.state = this.STATES.MENU
      }
    },
    onUp() {
      if (this.state === this.STATES.MENU) {
        if (this.ignoreControls === true) return
        this.selectIndex = Math.max(0, this.selectIndex - 1)
        this.scrollIntoViewIfNeeded()
      } else {
        let select = document.querySelector('.group.select')
        if (select === null) {
          select = document.querySelector('.group')
          select.classList.add('select')
          return
        }
        while (select.previousElementSibling !== null) {
          if (select.previousElementSibling.classList.contains('group')) {
            break
          }
          select = select.previousElementSibling
        }
        if (select.previousElementSibling !== null) {
          document.querySelectorAll('.group').forEach(elem => {
            elem.classList.remove('select')
          })
          select.previousElementSibling.classList.add('select')
          let i = select.previousElementSibling.querySelector('input')
          if (i !== null) {
            i.focus()
          }
        }
      }
    },
    onDown() {
      if (this.state === this.STATES.MENU) {
        if (this.ignoreControls === true) return
        this.selectIndex = Math.min(this.tracks.length - 1, this.selectIndex + 1)
        this.scrollIntoViewIfNeeded()
      } else {
        let select = document.querySelector('.group.select')
        if (select === null) {
          select = document.querySelector('.group')
          select.classList.add('select')
          return
        }
        while (select.nextElementSibling !== null) {
          if (select.nextElementSibling.classList.contains('group')) {
            break
          }
          select = select.nextElementSibling
        }
        if (select.nextElementSibling !== null) {
          document.querySelectorAll('.group').forEach(elem => {
            elem.classList.remove('select')
          })
          select.nextElementSibling.classList.add('select')
          let i = select.nextElementSibling.querySelector('input')
          if (i !== null) {
            i.focus()
          }
        }
      }
    },
    async selectItem(item) {
      const trackID = item.id
      this.ignoreControls = true
      this.$bus.$emit('ignoreControls', true)
      let choix = [
        {id: 0, title: this.IntlString('APP_RACING_CREATE'), icons: 'flag-checkered', color: 'green'},
        {id: 1, title: this.IntlString('APP_RACING_CREATE_PREVIEW'), icons: 'eye', color: 'orange'},
        {id: 2, title: this.IntlString('APP_RACING_CREATE_GPS'), icons: 'map-marker'},
      ]
      const rep = await Modal.CreateModal({choix})
      this.ignoreControls = false
      switch (rep.id) {
        case 0:
          this.state = this.STATES.CREATE
          this.selectTrack = trackID
          break
      }
      this.$bus.$emit('ignoreControls', false)
    },
    onEnter() {
      if (this.state === this.STATES.MENU) {
        if (this.ignoreControls === true) return
          this.selectItem(this.tracks[this.selectIndex])
      } else {
        let select = document.querySelector('.group.select')
        if (select === null) return

        if (select.dataset !== null) {
          console.log(select.dataset)
          if (select.dataset.type === 'text') {
            const $input = select.querySelector('input')
            let options = {
              limit: parseInt(select.dataset.maxlength) || 64,
              text: select.dataset.defaultValue || ''
            }
            this.$phoneAPI.getReponseText(options).then(data => {
              $input.value = data.text
              $input.dispatchEvent(new window.Event('change'))
            })
          }
          if (select.dataset.type === 'button') {
            select.click()
          }
        }
      }
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
