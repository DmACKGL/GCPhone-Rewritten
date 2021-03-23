import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import VueTimeago from './TimeAgo'
import PhoneAPI from './PhoneAPI'
import Notification from './Notification'
import AutoFocus from './directives/autofocus'
import {library} from '@fortawesome/fontawesome-svg-core'
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
  faArrowRight,
  faArrowUp,
  faArrowDown,
  faFlagCheckered,
  faFlag,
  faCheckCircle,
  faMoneyBillAlt,
  faRoad,
  faMapMarker,
  faTrophy,
  faRoute,
  faEye
} from '@fortawesome/free-solid-svg-icons'


import { faTwitter }  from '@fortawesome/free-brands-svg-icons'
import {FontAwesomeIcon} from '@fortawesome/vue-fontawesome'

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
  faArrowRight,
  faArrowUp,
  faArrowDown,
  faTwitter,
  faFlagCheckered,
  faFlag,
  faCheckCircle,
  faMoneyBillAlt,
  faRoad,
  faMapMarker,
  faTrophy,
  faRoute,
  faEye
)

Vue.component('FontAwesomeIcon', FontAwesomeIcon)
Vue.component('RacingHUD', require('./components/Racing/RacingHUD').default)

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
