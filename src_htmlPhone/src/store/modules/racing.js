const state = {
  races: [],
  currentRace: null,
  messagesChannel: []
}

const getters = {

}

const actions = {
  racingReset ({commit}) {
    commit('RACING_SET_RACES', { messages: [] })
    commit('RACING_SET_CURRENT', { channel: null })
    commit('RACING_REMOVES_ALL_CHANNELS')
  },
}

const mutations = {
  // TODO: ADD MUTATIONS
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  // BoilerPlate when on development
}
