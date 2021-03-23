const state = {
  raceInfo: {
    active: false,
    state: 0,
    raceID: 0,

    currentLap: 0,
    totalLaps: 0,

    checkpoints: 0,
    currentCheckpoint: 0,

    players: [],
    currentPosition: 1,
  }
}

const getters = {
  raceInfo: ({raceInfo}) => raceInfo,
}

const actions = {
  racingReset ({commit}) {
    commit('RACING_RESET')
  },

  // Core
  setRacingActive({commit, state}, status) {
    commit('SET_RACING_ACTIVE', status)
    return state.raceInfo.active
  },
  setRacingStatus({commit, state}, status) {
    commit('SET_RACING_STATUS', status)
    return state.raceInfo.status
  },
  setRacingID({commit, state}, id) {
    commit('SET_RACING_STATUS', id)
    return state.raceInfo.raceID
  },

  // Laps
  setRacingCurrentLap({commit, state}, lap) {
    commit('SET_RACING_CURRENT_LAP', lap)
    return state.raceInfo.currentLap
  },
  setRacingBestLap({commit,state}, timing) {
    commit('SET_RACING_BEST_LAP', timing)
    return state.raceInfo.bestLap
  },
  setRacingTotalLaps({commit,state}, laps) {
    commit('SET_RACING_TOTAL_LAPS', laps)
    return state.raceInfo.totalLaps
  },

  // CheckPoint
  setRacingTotalCheckpoints({commit, state}, checkpoints) {
    commit('SET_RACING_CHECKPOINTS', checkpoints)
    return state.raceInfo.checkpoints
  },
  setRacingCurrentCheckpoint({commit, state}, checkpoint) {
    commit('SET_RACING_CURRENT_CHECKPOINT', checkpoint)
    return state.raceInfo.currentCheckpoint
  },


  // Positions
  setRacingPlayers({commit,state}, players) {
    commit('SET_RACING_PLAYERS', players)
    return state.raceInfo.players
  },
  setRacingCurrentPosition({commit,state}, laps) {
    commit('SET_RACING_CURRENT_POSITION', laps)
    return state.raceInfo.currentPosition
  }



}

const mutations = {
  RACING_RESET(state) {
    state.raceInfo = []
  },

  // Core
  SET_RACING_ACTIVE(state, status) {
    state.raceInfo.active = status
  },
  SET_RACING_STATUS(state, status) {
    state.raceInfo.status = status
  },

  // Laps
  SET_RACING_CURRENT_LAP(state, lap) {
    state.raceInfo.currentLap = lap
  },
  SET_RACING_BEST_LAP(state, timing) {
    state.raceInfo.bestLap = timing
  },
  SET_RACING_TOTAL_LAPS(state, laps) {
    state.raceInfo.totalLaps = laps
  },

  // CheckPoints
  SET_RACING_CHECKPOINTS(state, checkpoints) {
    state.raceInfo.checkpoints = checkpoints
  },
  SET_RACING_CURRENT_CHECKPOINT(state, checkpoint){
    state.raceInfo.currentCheckpoint = checkpoint
  },

  // Positions
  SET_RACING_PLAYERS(state, players){
    state.raceInfo.players = players
  },
  SET_RACING_CURRENT_POSITION(state, position) {
    state.raceInfo.currentPosition = position
  }
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
