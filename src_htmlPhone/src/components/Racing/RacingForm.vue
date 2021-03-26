<template>
  <div
    id="phone_app"
    class="phone_app"
  >
    <div class="container mt-3">
      <div
        class="group inputText form-group mr-1"
        data-type="text"
        data-maxlength="64"
        data-defaultValue=""
      >
        <label for="eventName">{{ IntlString("APP_RACING_CREATE_EVENTNAME") }}</label>
        <input
          id="eventName"
          v-model="raceCreate.eventName"
          class="form-control"
          type="text"
        >
      </div>
      <div
        class="group inputText form-group mr-1"
        data-type="text"
        data-maxlength="64"
        data-defaultValue=""
      >
        <label for="yourAlias">{{ IntlString("APP_RACING_CREATE_ALIAS") }}</label>
        <input
          id="yourAlias"
          v-model="raceCreate.yourAlias"
          class="form-control"
          type="text"
        >
      </div>
      <div
        class="group inputText form-group mr-1"
        data-type="text"
        data-maxlength="64"
        data-defaultValue=""
      >
        <label for="ammount">{{ IntlString('APP_RACING_CREATE_MONEY') }}</label>
        <input
          id="ammount"
          v-model="raceCreate.money"
          class="form-control"
          type="number"
          pattern="[0-9]"
          @keydown.up.prevent
          @keydown.down.prevent
        >
      </div>
      <div
        class="group inputText form-group mr-1"
        data-type="text"
        data-maxlength="64"
        data-defaultValue=""
      >
        <label for="laps">{{ IntlString('APP_RACING_CREATE_LAPS') }}</label>
        <input
          id="laps"
          v-model="raceCreate.Laps"
          class="form-control"
          type="number"
          pattern="[0-9]"
          @keydown.up.prevent
          @keydown.down.prevent
        >
      </div>
      <div
        class="group inputText form-group mr-1"
        data-type="text"
        data-maxlength="64"
        data-defaultValue=""
      >
        <label for="CST">{{ IntlString('APP_RACING_CREATE_COUNTDOWN') }}</label>
        <input
          id="CST"
          v-model="raceCreate.CST"
          class="form-control"
          type="number"
          pattern="[0-9]"
          @keydown.up.prevent
          @keydown.down.prevent
        >
      </div>
      <div
        class="group inputText form-group form-check mr-1"
        data-type="checkbox"
      >
        <input
          id="reverse"
          v-model="raceCreate.reverse"
          class="form-check-input"
          type="checkbox"
          @keydown.up.prevent
          @keydown.down.prevent
        >
        <label for="reverse">{{ IntlString('APP_RACING_CREATE_REVERSE') }}</label>
      </div>
      <div
        class="group inputText form-group form-check mr-1"
        data-type="checkbox"
      >
        <input
          id="position"
          v-model="raceCreate.showPosition"
          class="form-check-input"
          type="checkbox"
          @keydown.up.prevent
          @keydown.down.prevent
        >
        <label for="position">{{ IntlString('APP_RACING_CREATE_POSITION') }}</label>
      </div>
      <div
        class="group inputText form-group form-check mr-1"
        data-type="checkbox"
      >
        <input
          id="sendNotification"
          v-model="raceCreate.sendNotification"
          class="form-check-input"
          type="checkbox"
          @keydown.up.prevent
          @keydown.down.prevent
        >
        <label for="sendNotification">{{ IntlString('APP_RACING_CREATE_SEND_NOTIFICATION') }}</label>
      </div>
      <div
        class="group mr-1"
        data-type="button"
        @click.stop="doCreate"
      >
        <input
          type="button"
          class="btn btn-primary btn-lg btn-block"
          :value="IntlString('APP_RACING_CREATE')"
          @click.stop="doCreate"
        >
      </div>
    </div>
  </div>
</template>

<script>
import {mapActions, mapGetters} from 'vuex'
import Swal from 'sweetalert2'

require('jquery');
require('popper.js');
require('bootstrap');
export default {
  name: 'Recents',
  components: {},
  data() {
    return {
      ignoreControls: false,
      currentRef: 0,
      raceCreate: {
        trackID: null,
        eventName: "",
        yourAlias: "",
        Laps: null,
        money: null,
        CST: null,
        reverse: false,
        showPosition: false,
        sendNotification: false,
        players: [],
      },
    }
  },

  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'racingTracks']),
  },
  watch: {
    ignoreControls() {
      console.log("IGNORE: " + this.ignoreControls)
    },
  },
  created() {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
      this.$bus.$on('keyUpBackspace', this.onBack)
    }
  },
  beforeDestroy() {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  },
  methods: {
    ...mapActions(['racingCreate']),
    doCreate() {
      this.$bus.$emit('ignoreControls', false)
      Swal.fire({
        title: this.IntlString('APP_RACING_CREATE_REQUEST_TITLE'),
        text: this.IntlString('APP_RACING_CREATE_REQUEST_TEXT'),
        target: '.phone_screen',
        allowOutsideClick: false, //makes modal behave captively
        allowEscapeKey: false,
        allowEnterKey: false,
        showConfirmButton: false,
        showCancelButton: false,
        willOpen() {
          Swal.showLoading(); //Adds built in loader animation during modal open
        },
        willClose() {
          Swal.hideLoading(); //might not be necessary
        },
      })
      this.racingCreate(this.raceCreate)
        .then(response => {
          if (response) {
            Swal.fire({
              icon: 'success',
              target: '.phone_screen',
              showConfirmButton: false,
              timer: 1500
            })
          } else {
            Swal.fire({
              icon: 'error',
              target: '.phone_screen',
              showConfirmButton: false,
              timer: 1500
            })
          }
          this.$bus.$emit('ignoreControls', true)
          this.$bus.$emit('racingHome')
        })
    },
    onBack() {
      //this.$bus.$emit('racingHome')
    },
    onUp() {
      if (this.ignoreControls === true) return
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
    },
    onDown() {
      if (this.ignoreControls === true) return
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
    },
    onEnter: function () {
      if (this.ignoreControls === true) return
      let select = document.querySelector('.group.select')
      if (select === null) return

      if (select.dataset !== null) {
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
        if (select.dataset.type === 'checkbox') {
          select.querySelector('input').click()
        }
        if (select.dataset.type === 'button') {
          select.click()
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
