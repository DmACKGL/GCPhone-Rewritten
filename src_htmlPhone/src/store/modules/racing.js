import PhoneAPI from './../../PhoneAPI'

const state = {
  races: [],
  tracks: [],
  raceProcessing: false,
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
  raceProcessing: ({raceProcessing}) => raceProcessing,
  races: ({races}) => races,
  racingTracks: ({tracks}) => tracks,
}

const actions = {
  async racingGet({commit}) {
    return PhoneAPI.getRaces()
      .then(response => {
        if (response.code) {
          commit('')
          return true
        } else {
          return false
        }
      })
  },

  racingReset ({commit}) {
    commit('RACING_RESET')
  },

  racingCreate ({commit}, race) {
    commit('RACING_SET_PROCCESING', true)
    commit('RACING_ADD_RACE', race)
    return PhoneAPI.createRace(race)
      .then(response => {
        if (response.raceID){
          commit('RACING_ADD_RACE', response)
          commit('RACING_SET_PROCCESING', false)
          commit('SET_RACING_RACEID', response.raceID)
          commit('SET_RACING_ACTIVE', true)
          return true
        } else {
          commit('RACING_SET_PROCCESING', false)
          return false
        }
      })

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
  RACING_SET_TRACKS(state, data) {
    state.tracks = data
  },
  RACING_SET_RACES(state, data){
    state.races = data
  },
  RACING_SET_RACEINFO(state, data) {
    state.raceInfo = data
  },
  RACING_RESET(state) {
    state.raceInfo = []
  },

  RACING_SET_PROCCESING(state, status) {
    state.raceProcessing = status
  },

  RACING_ADD_RACE(state, race) {
    state.races.push(race)
  },

  // Core
  SET_RACING_ACTIVE(state, status) {
    state.raceInfo.active = status
  },
  SET_RACING_STATUS(state, status) {
    state.raceInfo.status = status
  },
  SET_RACING_RACEID(state, raceID) {
    state.raceInfo.raceID = raceID
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
  state.tracks = [
    {
      id: 1,
      name: "Grand Prix 3.0",
      type: "Lap",
      km: "18.26 KM"
    },
    {
      id: 2,
      name: "Drag Queen",
      type: "Sprint",
      km: "300 KM"
    }
  ]
}
