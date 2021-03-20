<template>
  <transition name="modal">
    <div
      class="modal-mask"
      @click.stop="cancel"
    >
      <div class="modal-container">
        <div
          v-for="(val, index) in choix"
          :key="index"
          class="modal-choix"
          :class="{ select: index === currentSelect}"
          :style="{color: val.color}"
          @click.stop="selectItem(val)"
        >
          <div class="fa-icon">
            <FontAwesomeIcon
              :icon="['fas', val.icons]"
              @click.stop="selectItem(val)"
            /> {{ val.title }}
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import store from './../../store'
import { mapGetters } from 'vuex'

export default {
  name: 'Modal',
  store: store,
  props: {
    choix: {
      type: Array,
      default: () => []
    }
  },
  data () {
    return {
      currentSelect: 0
    }
  },
  computed: {
    ...mapGetters(['useMouse'])
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.currentSelect = -1
    }
    this.$bus.$on('keyUpBackspace', this.cancel)
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.cancel)
  },
  methods: {
    scrollIntoViewIfNeeded () {
      this.$nextTick(() => {
        document.querySelector('.modal-choix.select').scrollIntoViewIfNeeded()
      })
    },
    onUp () {
      this.currentSelect = this.currentSelect === 0 ? 0 : this.currentSelect - 1
      this.scrollIntoViewIfNeeded()
    },
    onDown () {
      this.currentSelect = this.currentSelect === this.choix.length - 1 ? this.currentSelect : this.currentSelect + 1
      this.scrollIntoViewIfNeeded()
    },
    selectItem (elem) {
      this.$emit('select', elem)
    },
    onEnter () {
      this.$emit('select', this.choix[this.currentSelect])
    },
    cancel () {
      this.$emit('cancel')
    }
  }
}
</script>

<style scoped>
    .fa-icon {
      margin-left: 3%;
    }

    .modal-mask {
        position: absolute;
        z-index: 99;
        top: 0;
        left: 0;
        width: 334px;
        height: 738px;
        background-color: rgba(0, 0, 0, .3);
        display: flex;
        align-items: flex-end;
        transition: opacity .3s ease;
    }

    .modal-container {
      width: 100%;
      margin: 0;
      background-color: #fff;
      border-radius: 2px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
      transition: all .3s ease;
      padding: 0 0 16px;
      max-height: 100%;
      overflow-y: auto;
    }

    .modal-title {
        text-align: center;
        height: 32px;
        line-height: 32px;
        color: #42B2DC;
        border-bottom: 2px solid #42B2DC;
    }
    .modal-choix {
        font-size: 15px;
        height: 56px;
        line-height: 56px;
        color: gray;
        position: relative;
        font-weight: 400;
    }
    .modal-choix .fa, .modal-choix .fas {
        font-size: 18px;
        line-height: 24px;
        margin-left: 12px;
        margin-right: 12px;
    }
    .modal-choix .picto {
        z-index: 500;
        position: absolute;
        width: 42px;
        background-size: 100% !important;
        background-position-y: 100%;
        height: 42px;
    }
    .modal-choix.select, .modal-choix:hover {
      background-color: #E3E3E3;
      color: #0079d3
    }



</style>
