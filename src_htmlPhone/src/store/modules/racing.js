import PhoneAPI from './../../PhoneAPI'

const state = {
  races: [],
  tracks: [],
  raceProcessing: false,
  raceInfo: {
    active: false,
    status: 0,
    raceID: null,
    PI: 0,

    currentLap: 0,
    totalLaps: 0,

    checkpoints: 0,
    currentCheckpoint: 0,
    currentPosition: 1,
    players: 0
  }
}

const getters = {
  raceInfo: ({raceInfo}) => raceInfo,
  raceLap: ({raceInfo}) => raceInfo.currentLap,
  raceStatus: ({raceInfo}) => raceInfo.status,
  raceProcessing: ({raceProcessing}) => raceProcessing,
  races: ({races}) => races,
  racingTracks: ({tracks}) => tracks,
  getRaceById: (state) => (id) => {
    return state.races.find(race => race.raceID === id)
  }
}

const actions = {
  racingGet({commit, getters, dispatch}) {
    return PhoneAPI.getRaces()
      .then(response => {
        if (response.data.code) {
          commit('RACING_SET_RACES', response.data.races)
          commit('RACING_SET_TRACKS', response.data.tracks)
          if (getters.raceInfo.raceID && getters.races.find(race => race.raceID === getters.raceInfo.raceID)) {
            dispatch('setRacingPlayers', getters.races.find(race => race.raceID === getters.raceInfo.raceID).players.length)
          }
          return true
        } else {
          return false
        }
      })
      .catch(() => {
        return false
      })
  },

  racingReset({commit}) {
    commit('RACING_RESET')
  },

  racingJoin({commit, getters, dispatch}, data) {
    commit('RACING_SET_PROCCESING', true)
    return PhoneAPI.joinRace(data.raceID, data.alias)
      .then(response => {
        if (response.data.success) {
          dispatch('setRacingTotalLaps', getters.races.find(race => race.raceID === response.data.eventID).Laps)
          dispatch('setRacingTotalCheckpoints', getters.races.find(race => race.raceID === response.data.eventID).checkpointsCount)
          dispatch('setRacingPlayers', getters.races.find(race => race.raceID ===response.data.eventID).players.length)
          dispatch('setRacingID', response.data.eventID)
          dispatch('setPlayerIndex', response.data.playerIndex)
          dispatch('setRacingActive', true)
          dispatch('racingGet')
        } else {
          return false
        }
      })
      .catch(() => {
        return false
      })
  },

  racingCreate({commit, dispatch}, data) {
    return PhoneAPI.createRace(data)
      .then(response => {
        if (response.data.success) {
          dispatch('racingGet')
          return setTimeout(() => {
            dispatch('racingJoin', {raceID: response.data.eventID, alias: response.data.alias})
            commit('RACING_SET_PROCCESING', false)
            return true
          }, 500)
        } else {
          return false
        }
      })
      .catch(() => {
        return false
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
    commit('SET_RACING_RACEID', id)
    return state.raceInfo.raceID
  },

  setPlayerIndex({commit, state}, PI) {
    commit('SET_RACING_PI', PI)
    return state.raceInfo.PI
  },

  // Laps
  setRacingCurrentLap({commit, state}, lap) {
    commit('SET_RACING_CURRENT_LAP', lap)
    return state.raceInfo.currentLap
  },
  setRacingBestLap({commit, state}, timing) {
    commit('SET_RACING_BEST_LAP', timing)
    return state.raceInfo.bestLap
  },
  setRacingTotalLaps({commit, state}, laps) {
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
  setRacingPlayers({commit, state}, players) {
    commit('SET_RACING_PLAYERS', players)
    return state.raceInfo.players
  },
  setRacingCurrentPosition({commit, state}, laps) {
    commit('SET_RACING_CURRENT_POSITION', laps)
    return state.raceInfo.currentPosition
  }

}

const mutations = {
  RACING_SET_TRACKS(state, data) {
    state.tracks = data
  },
  RACING_SET_RACES(state, data) {
    state.races = []
    Object.assign(state.races, data)
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

  SET_RACING_PI(state, PI) {
    state.raceInfo.PI = PI
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
  SET_RACING_CURRENT_CHECKPOINT(state, checkpoint) {
    state.raceInfo.currentCheckpoint = checkpoint
  },

  // Positions
  SET_RACING_PLAYERS(state, players) {
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
  state.races = [
    {
      owner: 0,
      raceID: 1,
      trackID: 1,
      state: 0,
      eventName: "GrandPrix",
      yourAlias: "DmACK",
      Laps: 1,
      money: 500,
      CST: 1,
      reverse: true,
      showPosition: false,
      sendNotification: false,
      players: [
        {
          id: 0,
          alias: "DmACK",
        },
        {
          id: 100,
          alias: "Mark"
        }
      ],
    }
  ]
  state.tracks = [
    {
      id: 1,
      name: "Grand Prix 3.0",
      type: "Lap",
      km: "18260"
    },
    {
      id: 2,
      name: "Drag Queen",
      type: "Sprint",
      km: "300"
    }
  ]
}
