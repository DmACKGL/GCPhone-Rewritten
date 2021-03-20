<template>
  <div class="phone_app">
    <PhoneTitle
      v-if="showHeader"
      :title="title"
      :show-info-bare="showInfoBare"
      @back="back"
    />
    <!-- <InfoBare v-if="showInfoBare"/>
    <div v-if="title !== ''" class="phone_title" v-bind:style="styleTitle()">{{title}}</div>
    -->
    <div
      style="width: 324px; height: 595px;"
      class="phone_content elements"
    >
      <div
        v-for="(elem, key) in list"
        :key="elem[keyDispay]"
        class="element"
        :class="{ select: key === currentSelect}"
        @click.stop="selectItem(elem)"
        @contextmenu.prevent.stop="optionItem(elem)"
      >
        <div
          class="elem-pic"
          :style="stylePuce(elem)"
          @click.stop="selectItem(elem)"
        >
          {{ elem.letter || elem[keyDispay][0] }}
        </div>
        <div
          v-if="elem.puce !== undefined && elem.puce !== 0"
          class="elem-puce"
          @click.stop="selectItem(elem)"
          @contextmenu.prevent.stop="optionItem(elem)"
        >
          {{ elem.puce }}
        </div>
        <div
          v-if="elem.keyDesc === undefined || elem.keyDesc === ''"
          class="elem-title"
          @click.stop="selectItem(elem)"
          @contextmenu.prevent.stop="optionItem(elem)"
        >
          {{ elem[keyDispay] }}
        </div>
        <div
          v-if="elem.keyDesc !== undefined && elem.keyDesc !== ''"
          class="elem-title-has-desc"
          @click.stop="selectItem(elem)"
          @contextmenu.prevent.stop="optionItem(elem)"
        >
          {{ elem[keyDispay] }}
        </div>
        <div
          v-if="elem.keyDesc !== undefined && elem.keyDesc !== ''"
          class="elem-description"
          @click.stop="selectItem(elem)"
          @contextmenu.prevent.stop="optionItem(elem)"
        >
          {{ elem.keyDesc }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import PhoneTitle from './PhoneTitle'
import {mapGetters} from 'vuex'

export default {
  name: 'Hello',
  components: {
    PhoneTitle
  },
  props: {
    title: {
      type: String,
      default: 'Title'
    },
    showHeader: {
      type: Boolean,
      default: true
    },
    showInfoBare: {
      type: Boolean,
      default: true
    },
    list: {
      type: Array,
      required: true
    },
    color: {
      type: String,
      default: '#FFFFFF'
    },
    backgroundColor: {
      type: String,
      default: '#4CAF50'
    },
    keyDispay: {
      type: String,
      default: 'display'
    },
    disable: {
      type: Boolean,
      default: false
    },
    titleBackgroundColor: {
      type: String,
      default: '#FFFFFF'
    }
  },
  data: function () {
    return {
      currentSelect: 0
    }
  },
  computed: {
    ...mapGetters(['useMouse'])
  },
  watch: {
    list: function () {
      this.currentSelect = 0
    }
  },
  created: function () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpArrowRight', this.onRight)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.currentSelect = -1
    }
  },
  beforeDestroy: function () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('keyUpEnter', this.onEnter)
  },
  methods: {
    stylePuce(data) {
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
    },
    scrollIntoViewIfNeeded: function () {
      this.$nextTick(() => {
        document.querySelector('.select').scrollIntoViewIfNeeded()
      })
    },
    onUp: function () {
      if (this.disable === true) return
      this.currentSelect = this.currentSelect === 0 ? this.list.length - 1 : this.currentSelect - 1
      this.scrollIntoViewIfNeeded()
    },
    onDown: function () {
      if (this.disable === true) return
      this.currentSelect = this.currentSelect === this.list.length - 1 ? 0 : this.currentSelect + 1
      this.scrollIntoViewIfNeeded()
    },
    selectItem(item) {
      this.$emit('select', item)
    },
    optionItem(item) {
      this.$emit('option', item)
    },
    back() {
      this.$emit('back')
    },
    onRight: function () {
      if (this.disable === true) return
      this.$emit('option', this.list[this.currentSelect])
    },
    onEnter: function () {
      if (this.disable === true) return
      this.$emit('select', this.list[this.currentSelect])
    }
  }
}
</script>

<style scoped>
.list {
  height: 100%;
}


.elements {
  overflow-y: auto;
}

.element {
  height: 58px;
  line-height: 58px;
  display: flex;
  align-items: center;
  position: relative;
  font-weight: 300;
  font-size: 18px;
}

.element.select, .element:hover {
  background-color: #DDD;
}

.elem-pic {
  margin-left: 12px;
  height: 48px;
  width: 48px;
  text-align: center;
  line-height: 48px;
  font-weight: 200;
}

.elem-puce {
  background-color: #EE3838;
  top: 0;
  color: white;
  height: 18px;
  width: 18px;
  line-height: 18px;
  border-radius: 50%;
  text-align: center;
  font-size: 14px;
  margin: 0;
  padding: 0;
  position: absolute;
  left: 42px;
  z-index: 6;
}

.elem-title {
  margin-left: 12px;
  font-size: 20px;
  font-weight: 400;
}

.elem-title-has-desc {
  margin-top: -15px;
  margin-left: 12px;
}

.elem-description {
  text-align: left;
  color: grey;
  position: absolute;
  display: block;
  width: 75%;
  left: 73px;
  top: 12px;
  font-size: 14px;
  font-style: italic;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
