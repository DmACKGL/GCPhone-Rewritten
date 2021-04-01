import store from '@/store'
import VoiceRTC from './VoiceRCT'
import Vue from 'vue'
import {Howl} from 'howler'
import emoji from './emoji.json'
import axios from 'axios'

const keyEmoji = Object.keys(emoji)

let USE_VOICE_RTC = false
const BASE_URL = 'https://gcphone/'

/* eslint-disable camelcase */
class PhoneAPI {
  constructor() {
    window.addEventListener('message', (event) => {
      const eventType = event.data.event
      if (eventType !== undefined && typeof this['on' + eventType] === 'function') {
        this['on' + eventType](event.data)
      } else if (event.data.show !== undefined) {
        // Toggle phone
        store.commit('SET_PHONE_VISIBILITY', event.data.show)
      }
    })
    this.config = null
    this.voiceRTC = null
    this.soundList = {}
  }

  async post(method, data) {
    const ndata = data === undefined ? '{}' : JSON.stringify(data)
    return axios.post(BASE_URL + method, ndata)
      .then(function(response) {
          try {
            return JSON.parse(response.data)
          } catch (e) {
            return response
          }
      })
      .catch(error => this.log(error));
  }

  async log(...data) {
    if (process.env.NODE_ENV === 'production') {
      return this.post('log', data)
    } else {
      return console.log(...data)
    }
  }

  convertEmoji(text) {
    for (const e of keyEmoji) {
      text = text.replace(new RegExp(`:${e}:`, 'g'), emoji[e])
    }
    return text
  }

  // === Gestion des messages
  async sendMessage(phoneNumber, message) {
    return this.post('sendMessage', {phoneNumber, message})
  }

  async deleteMessage(id) {
    return this.post('deleteMessage', {id})
  }

  async deleteMessagesNumber(number) {
    return this.post('deleteMessageNumber', {number})
  }

  async deleteAllMessages() {
    return this.post('deleteAllMessage')
  }

  async setMessageRead(number) {
    return this.post('setReadMessageNumber', {number})
  }

  // === Gestion des contacts
  async updateContact(id, display, phoneNumber) {
    return this.post('updateContact', {id, display, phoneNumber})
  }

  async addContact(display, phoneNumber) {
    return this.post('addContact', {display, phoneNumber})
  }

  async deleteContact(id) {
    return this.post('deleteContact', {id})
  }

  // == Gestion des appels
  async appelsDeleteHistorique(numero) {
    return this.post('appelsDeleteHistorique', {numero})
  }

  async appelsDeleteAllHistorique() {
    return this.post('appelsDeleteAllHistorique')
  }

  // === Autre
  async closePhone() {
    return this.post('closePhone')
  }

  async setUseMouse(useMouse) {
    return this.post('useMouse', useMouse)
  }

  async setGPS(x, y) {
    return this.post('setGPS', {x, y})
  }

  async takePhoto() {
    store.commit('SET_TEMPO_HIDE', true)
    const data = await this.post('takePhoto', {
      url: this.config.fileUploadService_Url,
      field: this.config.fileUploadService_Field
    })
    store.commit('SET_TEMPO_HIDE', false)
    return data
  }

  async getReponseText(data) {
    if (process.env.NODE_ENV === 'production') {
      return this.post('reponseText', data || {})
    } else {
      return {text: window.prompt()}
    }
  }

  async faketakePhoto() {
    return this.post('faketakePhoto')
  }

  async callEvent(eventName, data) {
    return this.post('callEvent', {eventName, data})
  }

  async deleteALL() {
    localStorage.clear()
    store.dispatch('tchatReset')
    store.dispatch('notesReset')
    store.dispatch('resetPhone')
    store.dispatch('resetMessage')
    store.dispatch('resetContact')
    store.dispatch('resetBourse')
    store.dispatch('resetAppels')
    return this.post('deleteALL')
  }

  async getConfig() {
    if (this.config === null) {
      this.config = await axios.get('/html/static/config/config.json')
                        .then(response => response.data)
      if (this.config.useWebRTCVocal === true) {
        this.voiceRTC = new VoiceRTC(this.config.RTCConfig)
        USE_VOICE_RTC = true
        await this.notififyUseRTC(this.config.useWebRTCVocal)
      }
    }
    return this.config
  }

  async onsetEnableApp(data) {
    store.dispatch('setEnableApp', data)
  }

  async setIgnoreFocus(ignoreFocus) {
    await this.post('setIgnoreFocus', {ignoreFocus})
  }

  // === App Tchat
  async tchatGetMessagesChannel(channel) {
    await this.post('tchat_getChannel', {channel})
  }

  async tchatSendMessage(channel, message) {
    await this.post('tchat_addMessage', {channel, message})
  }

  // === App Notes
  async notesGetMessagesChannel(channel) {
    window.localStorage.setItem('gc_notas_locales', channel)
  }

  async notesSendMessage(channel, message) {
    await this.post('notes_addMessage', {channel, message})
  }

  // ==========================================================================
  // Racing
  // ==========================================================================

  getRaces() {
    return this.post('getRaces')
  }
  joinRace(raceID, yourAlias) {
    return this.post('joinRace', {raceID, yourAlias})
  }
  createRace(raceInfo) {
    return this.post('createRace', {raceInfo})
  }

  setRaceGPS(raceID) {
    return this.post('racingSetGPS', {raceID: raceID})
  }

  startRace(raceID) {
    return this.post('racingStartRace', {raceID: raceID})
  }

  // Core
  onupdateRacingActive(data) {
    store.dispatch('setRacingActive', data.data)
  }
  onupdateRacingStatus(data) {
    store.dispatch('setRacingStatus', data.data)
  }
  onupdateRacingID(data) {
    store.dispatch('setRacingID', data.data)
  }
  onupdateRacingRaces() {
    store.dispatch('racingGet')
  }

  // Laps
  onupdateRacingCurrentLap(data) {
    store.dispatch('setRacingCurrentLap', data.data)
  }
  onupdateRacingLaps(data) {
    store.dispatch('setRacingTotalLaps', data.data)
  }

  // Checkpoint
  onupdateRacingCurrentCheckpoint(data){
    store.dispatch('setRacingCurrentCheckpoint', data.data)
  }
  onupdateRacingCheckpoints(data) {
    store.dispatch('setRacingTotalCheckpoints', data.data)
  }

  // Players
  onupdateRacingCurrentPosition(data) {
    store.dispatch('setRacingCurrentPosition', data.data)
  }
  onupdateRacingPlayers(data) {
    store.dispatch('setRacingPlayers', data.data)
  }

  // ==========================================================================
  //  Gestion des events
  // ==========================================================================
  onupdateMyPhoneNumber(data) {
    store.commit('SET_MY_PHONE_NUMBER', data.myPhoneNumber)
  }

  onupdateMessages(data) {
    store.commit('SET_MESSAGES', data.messages)
  }

  onnewMessage(data) {
    store.commit('ADD_MESSAGE', data.message)
  }

  onupdateContacts(data) {
    store.commit('SET_CONTACTS', data.contacts)
  }

  onhistoriqueCall(data) {
    store.commit('SET_APPELS_HISTORIQUE', data.historique)
  }

  onupdateBankbalance(data) {
    store.commit('SET_BANK_AMONT', data.banking)
  }

  onupdateBourse(data) {
    store.commit('SET_BOURSE_INFO', data.bourse)
  }

  onupdateNotification(data) {
    store.commit('SET_NOTIFICATION_SHOW', data.active)
  }

  onupdateNotificationInfo(data) {
    store.commit('SET_NOTIFICATION_INFO', data.info)
  }

  onupdatePlayerID(data) {
    store.commit('SET_PLAYER_ID', data.id)
  }

  // Call
  async startCall(numero, extraData = undefined) {
    if (USE_VOICE_RTC === true) {
      const rtcOffer = await this.voiceRTC.prepareCall()
      return this.post('startCall', {numero, rtcOffer, extraData})
    } else {
      return this.post('startCall', {numero, extraData})
    }
  }


  async acceptCall(infoCall) {
    if (USE_VOICE_RTC === true) {
      const rtcAnswer = await this.voiceRTC.acceptCall(infoCall)
      return this.post('acceptCall', {infoCall, rtcAnswer})
    } else {
      return this.post('acceptCall', {infoCall})
    }
  }

  async rejectCall(infoCall) {
    return this.post('rejectCall', {infoCall})
  }

  async notififyUseRTC(use) {
    return this.post('notififyUseRTC', use)
  }

  onwaitingCall(data) {
    store.commit('SET_APPELS_INFO_IF_EMPTY', {
      ...data.infoCall,
      initiator: data.initiator
    })
  }

  onacceptCall(data) {
    if (USE_VOICE_RTC === true) {
      if (data.initiator === true) {
        this.voiceRTC.onReceiveAnswer(data.infoCall.rtcAnswer)
      }
      this.voiceRTC.addEventListener('onCandidate', (candidates) => {
        this.post('onCandidates', {id: data.infoCall.id, candidates})
      })
    }
    store.commit('SET_APPELS_INFO_IS_ACCEPTS', true)
  }

  oncandidatesAvailable(data) {
    this.voiceRTC.addIceCandidates(data.candidates)
  }

  onrejectCall() {
    if (this.voiceRTC !== null) {
      this.voiceRTC.close()
    }
    store.commit('SET_APPELS_INFO', null)
  }

  // Tchat Event
  ontchat_receive(data) {
    store.dispatch('tchatAddMessage', data)
  }

  ontchat_channel(data) {
    store.commit('TCHAT_SET_MESSAGES', data)
  }

  // Notes Event
  onnotes_receive(data) {
    store.dispatch('notesAddMessage', data)
  }

  onnotes_channel(data) {
    store.commit('NOTES_SET_MESSAGES', data)
  }

  // =====================
  onautoStartCall(data) {
    this.startCall(data.number, data.extraData)
  }

  onautoAcceptCall(data) {
    store.commit('SET_APPELS_INFO', data.infoCall)
    this.acceptCall(data.infoCall)
  }

  // === Twitter
  twitter_login(username, password) {
    this.post('twitter_login', {username, password})
  }

  twitter_changePassword(username, password, newPassword) {
    this.post('twitter_changePassword', {username, password, newPassword})
  }

  twitter_createAccount(username, password, avatarUrl) {
    this.post('twitter_createAccount', {username, password, avatarUrl})
  }

  twitter_postTweet(username, password, message) {
    this.post('twitter_postTweet', {username, password, message})
  }

  twitter_postTweetImg(username, password, message) {
    this.post('twitter_postTweetImg', {username, password, message})
  }

  twitter_toggleLikeTweet(username, password, tweetId) {
    this.post('twitter_toggleLikeTweet', {username, password, tweetId})
  }

  twitter_setAvatar(username, password, avatarUrl) {
    this.post('twitter_setAvatarUrl', {username, password, avatarUrl})
  }

  twitter_getTweets(username, password) {
    this.post('twitter_getTweets', {username, password})
  }

  twitter_getFavoriteTweets(username, password) {
    this.post('twitter_getFavoriteTweets', {username, password})
  }

  ontwitter_tweets(data) {
    store.commit('SET_TWEETS', data)
  }

  ontwitter_favoritetweets(data) {
    store.commit('SET_FAVORITE_TWEETS', data)
  }

  ontwitter_newTweet(data) {
    store.dispatch('addTweet', data.tweet)
  }

  ontwitter_setAccount(data) {
    store.dispatch('setAccount', data)
  }

  ontwitter_updateTweetLikes(data) {
    store.commit('UPDATE_TWEET_LIKE', data)
  }

  ontwitter_setTweetLikes(data) {
    store.commit('UPDATE_TWEET_ISLIKE', data)
  }

  ontwitter_showError(data) {
    Vue.notify({
      title: store.getters.IntlString(data.title, ''),
      message: store.getters.IntlString(data.message),
      icon: 'twitter',
      backgroundColor: '#e0245e80'
    })
  }

  ontwitter_showSuccess(data) {
    Vue.notify({
      title: store.getters.IntlString(data.title, ''),
      message: store.getters.IntlString(data.message),
      icon: 'twitter'
    })
  }

  onplaySound({sound, volume = 1}) {
    var path = '/html/static/sound/' + sound
    if (!sound) return
    if (this.soundList[sound] !== undefined) {
      this.soundList[sound].volume = volume
    } else {
      this.soundList[sound] = new Howl({
        src: path,
        volume: volume,
        loop: true,
      })
      this.soundList[sound].play()
    }
  }

  onsetSoundVolume({sound, volume = 1}) {
    if (this.soundList[sound] !== undefined) {
      this.soundList[sound].volume = volume
    }
  }

  onstopSound({sound}) {
    if (this.soundList[sound] !== undefined) {
      this.soundList[sound].pause()
      delete this.soundList[sound]
    }
  }

}

const instance = new PhoneAPI()

export default instance
