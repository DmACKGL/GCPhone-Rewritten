<template>
  <div
    id="phone_app"
    class="phone_app"
  >
    <div class="elements">
      <div
        v-for="(histo, key) in historique"
        :key="key"
        class="element card shadow mr-3"
        :class="{'active': selectIndex === key}"
        @click.stop="selectItem(histo)"
      >
        <h5 class="card-title">
          Grand Prix 2021
        </h5>
        <div class="card-body p-0">
          <div class="row m-1 text-center">
            <div class="col">
              <font-awesome-icon :icon="['fas', 'user']" />
              <br>
              10
            </div>
            <div class="col">
              <font-awesome-icon :icon="['fas', 'money-bill-alt']" />
              <br>
              $1.000
            </div>
            <div class="col">
              <font-awesome-icon :icon="['fas', 'road']" />
              <br>
              Eastside Oilers
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapActions, mapGetters} from 'vuex'
import {generateColorForStr, groupBy} from '@/Utils'
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
    ...mapGetters(['IntlString', 'useMouse', 'appelsHistorique', 'contacts']),
    historique () {
      let grpHist = groupBy(this.appelsHistorique, 'num')
      let hist = []
      for (let key in grpHist) {
        const hg = grpHist[key]
        const histoByDate = hg.map(e => {
          e.date = new Date(e.time)
          return e
        }).sort((a, b) => {
          return b.date - a.date
        }).slice(0, 6)
        const contact = this.getContact(key) || {letter: '#'}
        hist.push({
          num: key,
          display: contact.display || key,
          lastCall: histoByDate,
          letter: contact.letter || contact.display[0],
          backgroundColor: contact.backgroundColor || generateColorForStr(key),
          icon: contact.icon
        })
      }
      hist.sort((a, b) => {
        return b.lastCall[0].time - a.lastCall[0].time
      })
      return hist
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.selectIndex = -1
    }
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
  },
  methods: {
    ...mapActions(['startCall', 'appelsDeleteHistorique', 'appelsDeleteAllHistorique', 'addContact']),
    getContact (num) {
      return this.contacts.find(e => e.number === num)
    },
    scrollIntoViewIfNeeded: function () {
      this.$nextTick(() => {
        this.$el.querySelector('.active').scrollIntoViewIfNeeded()
      })
    },
    onUp () {
      if (this.ignoreControls === true) return
      this.selectIndex = Math.max(0, this.selectIndex - 1)
      this.scrollIntoViewIfNeeded()
    },
    onDown () {
      if (this.ignoreControls === true) return
      this.selectIndex = Math.min(this.historique.length - 1, this.selectIndex + 1)
      this.scrollIntoViewIfNeeded()
    },
    async selectItem (item) {
      const numero = item.num
      this.ignoreControls = true
      let choix = [
        {id: 0, title: this.IntlString('APP_RACING_JOIN'), icons: 'check-circle', color: 'green'},
        {id: 1, title: this.IntlString('APP_PHONE_DELETE_ALL'), icons: 'trash', color: 'red'},
        {id: 2, title: this.IntlString('APP_PHONE_CANCEL'), icons: 'undo'},
      ]
      const rep = await Modal.CreateModal({ choix })
      this.ignoreControls = false
      switch (rep.id) {
        case 0:
          await Swal.fire({
            icon: 'success',
            title: 'All set!',
            text: 'You joined the race!',
            target: '.phone_screen',
          })
          break
        case 1:
          this.appelsDeleteHistorique({ numero })
          break
        case 2 :
          this.appelsDeleteAllHistorique()
          break
        case 4 :
          this.$router.push({name: 'contacts.view', params: {id: 0, number: numero}})
      }
    },
    async onEnter () {
      if (this.ignoreControls === true) return
      await this.selectItem(this.historique[this.selectIndex])
    },
    save (numero) {
      if (this.id !== -1) {
        this.addContact({
          number: numero
        })
      } else {
        console.log('No añadido')
      }
      history.back()
    },
    stylePuce (data) {
      data = data || {}
      if (data.icon !== undefined) {
        return {
          backgroundImage: `url(${data.icon})`,
          backgroundSize: 'cover',
          color: 'rgba(0,0,0,0)'
        }
      }
      return {
        color: data.color || this.color,
        backgroundColor: data.backgroundColor || this.backgroundColor,
        borderRadius: '50%'
      }
    }
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
