import Vue from 'vue'
import Router from 'vue-router'

const Home = () => import('@/components/Home')
const Menu = () => import('@/components/Menu')

const Contacts = () => import('@/components/contacts/Contacts')
const Contact = () => import('@/components/contacts/Contact')

const MessagesList = () => import('@/components/messages/MessagesList')
const Messages = () => import('@/components/messages/Messages')
const MessageContactsSelect = () => import('@/components/messages/MessageContactsSelect')

const Appels = () => import('@/components/Appels/Appels')
const AppelsActive = () => import('@/components/Appels/AppelsActive')
const AppelsNumber = () => import('@/components/Appels/AppelsNumber')

const TchatSplashScreen = () => import('@/components/Tchat/TchatSplashScreen')
const TchatChannel = () => import('@/components/Tchat/TchatChannel')
const TchatMessage = () => import('@/components/Tchat/TchatMessage')

const NotesChannel = () => import('@/components/Notes/NotesChannel')
const NotesMessage = () => import('@/components/Notes/NotesMessage')

const TwitterSpashScreen = () => import('@/components/twitter/TwitterSpashScreen')
const TwitterScreen = () => import('@/components/twitter/TwitterScreen')

const Parametre = () => import('@/components/parametre/Parametre')
const Bank = () => import('@/components/Bank/Bank')
const Bourse = () => import('@/components/Bourse/Bourse')
const Photo = () => import('@/components/Photo/Photo')

const App9GAG = () => import('@/components/App9GAG')

const RacingScreen = () => import("../components/Racing/RacingScreen")

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/menu',
      name: 'menu',
      component: Menu
    },
    {
      path: '/contacts',
      name: 'contacts',
      component: Contacts
    },
    {
      path: '/contact/:id/:number?',
      name: 'contacts.view',
      component: Contact
    },
    {
      path: '/messages',
      name: 'messages',
      component: MessagesList
    },
    {
      path: '/messages/select',
      name: 'messages.selectcontact',
      component: MessageContactsSelect
    },
    {
      path: '/messages/:number/:display',
      name: 'messages.view',
      component: Messages
    }, {
      path: '/bourse',
      name: 'bourse',
      component: Bourse
    }, {
      path: '/bank',
      name: 'bank',
      component: Bank
    }, {
      path: '/photo',
      name: 'photo',
      component: Photo
    }, {
      path: '/paramtre',
      name: 'parametre',
      component: Parametre
    }, {
      path: '/appels',
      name: 'appels',
      component: Appels
    }, {
      path: '/appelsactive',
      name: 'appels.active',
      component: AppelsActive
    }, {
      path: '/appelsNumber',
      name: 'appels.number',
      component: AppelsNumber
    }, {
      path: '/tchatsplash',
      name: 'tchat',
      component: TchatSplashScreen
    }, {
      path: '/tchat',
      name: 'tchat.channel',
      component: TchatChannel
    }, {
      path: '/tchat/:channel',
      name: 'tchat.channel.show',
      component: TchatMessage
    }, {
      path: '/notes',
      name: 'notes',
      component: NotesChannel
    }, {
      path: '/notes/:channel',
      name: 'notes.channel.show',
      component: NotesMessage
    }, {
      path: '/twitter/splash',
      name: 'twitter.splash',
      component: TwitterSpashScreen
    }, {
      path: '/twitter/view',
      name: 'twitter.screen',
      component: TwitterScreen
    }, {
      path: '/9gag',
      name: '9gag',
      component: App9GAG
    }, {
      path: '/racing',
      name: 'racing',
      component: RacingScreen,
    }, {
      path: '*',
      redirect: '/'
    }
  ]
})

const originalPush = Router.prototype.push
Router.prototype.push = function push(location, onResolve, onReject) {
  return onResolve || onReject ? originalPush.call(this, location, onResolve, onReject) : originalPush.call(this, location).catch((err) => {
    if (Router.isNavigationFailure(err)) {
      console.log('Navigation Failure')
      return
    }
    return Promise.reject(err)
  });
}
