import Vue from 'vue'
import Vuex from 'vuex'
import createLogger from 'vuex/dist/logger';

import phone from './modules/phone'
import contacts from './modules/contacts'
import messages from './modules/messages'
import appels from './modules/appels'
import bank from './modules/bank'
import notes from './modules/notes'
import bourse from './modules/bourse'
import tchat from './modules/tchat'
import twitter from './modules/twitter'
import racing from './modules/racing'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production';
export default new Vuex.Store({
  modules: {
    phone,
    contacts,
    messages,
    appels,
    bank,
    bourse,
    notes,
    tchat,
    twitter,
    racing
  },
  strict: debug,
  plugins: debug? [ createLogger() ] : []
})
