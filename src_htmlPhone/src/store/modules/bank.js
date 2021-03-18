import PhoneAPI from './../../PhoneAPI'

const state = {
  bankAmont: '0'
}

const getters = {
  bankAmont: ({ bankAmont }) => bankAmont
}

const actions = {
  // eslint-disable-next-line no-unused-vars
  sendpara ({ state }, { id, amount }) {
    PhoneAPI.callEvent('gcphone:bankTransfer', {id, amount})
  }
}

const mutations = {
  SET_BANK_AMONT (state, bankAmont) {
    state.bankAmont = bankAmont
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

