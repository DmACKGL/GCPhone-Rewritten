import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import VueTimeago from './TimeAgo'
import PhoneAPI from './PhoneAPI'
import Notification from './Notification'
import AutoFocus from './directives/autofocus'
import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faAngleLeft,
  faComment,
  faLocationArrow,
  faUndo,
  faCamera,
  faTrash,
  faPhone,
  faCircle,
  faSearch,
  faCopy,
  faMask,
  faSms,
  faSave,
  faPlus,
  faMinus,
  faImage,
  faMobile,
  faBell,
  faVolumeDown,
  faGlobeAmericas,
  faMousePointer,
  faExclamationTriangle,
  faExclamationCircle,
  faHome,
  faHeart,
  faCog,
  faClock,
  faStar,
  faUser,
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
library.add(
  faAngleLeft,
  faComment,
  faLocationArrow,
  faUndo,
  faCamera,
  faTrash,
  faPhone,
  faCircle,
  faSearch,
  faCopy,
  faMask,
  faSms,
  faSave,
  faPlus,
  faMinus,
  faImage,
  faMobile,
  faBell,
  faVolumeDown,
  faGlobeAmericas,
  faMousePointer,
  faExclamationTriangle,
  faExclamationCircle,
  faHome,
  faHeart,
  faCog,
  faClock,
  faStar,
  faUser,
)
// eslint-disable-next-line no-unused-vars
import $ from "expose-loader?exposes[]=$&exposes[]=jQuery!jquery";

Vue.component('FontAwesomeIcon', FontAwesomeIcon)

Vue.use(VueTimeago)
Vue.use(Notification)
Vue.config.productionTip = false

Vue.prototype.$bus = new Vue()
Vue.prototype.$phoneAPI = PhoneAPI

window.VueTimeago = VueTimeago
window.Vue = Vue
window.store = store

Vue.directive('autofocus', AutoFocus)

/* eslint-disable no-new */
window.APP = new Vue({
  el: '#app',
  store,
  router,
  render: h => h(App)
})
