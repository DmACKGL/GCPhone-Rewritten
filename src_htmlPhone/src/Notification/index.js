import Vue from 'vue'
import Notification from './Notification'
import events from './events'

const Notify = {
  install: function () {
    if (this.installed) return
    this.installed = true

    Vue.component('Notification', Notification)
    const notify = (params) => {
      events.$emit('add', params)
    }

    Vue.notify = notify
    Object.defineProperties(Vue.prototype, {
      $notify: {
        get: () => Vue.notify
      }
    })
  }
}

export default Notify
