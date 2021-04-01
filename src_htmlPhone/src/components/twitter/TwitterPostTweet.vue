<template>
  <div
    style="width: 326px; height: 743px;"
    class="phone_content"
  >
    <div class="tweet_write">
      <label for="textbox" />
      <textarea
        id="textbox"
        v-model.trim="message"
        v-autofocus
        class="textarea-input"
        :placeholder="IntlString('APP_TWITTER_PLACEHOLDER_MESSAGE')"
      />
      <span
        class="tweet_send"
        @click="tweeter"
      >{{ IntlString('APP_TWITTER_BUTTON_ACTION_TWEETER') }}</span>
    </div>
  </div>
</template>

<script>
import {mapActions, mapGetters} from 'vuex'

export default {
  components: {},
  data() {
    return {
      message: ''
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse'])
  },
  watch: {},
  created() {
    if (!this.useMouse) {
      this.$bus.$on('keyUpEnter', this.onEnter)
    }
    this.$bus.$on('keyUpBackspace', this.onBack)
  },
  async mounted() {
  },
  beforeDestroy() {
    this.$bus.$off('keyUpBackspace', this.onBack)
    this.$bus.$off('keyUpEnter', this.onEnter)
  },
  methods: {
    ...mapActions(['twitterPostTweet']),
    async onEnter() {
      try {
        const rep = await this.$phoneAPI.getReponseText({
          // TODO: ???????????
          // text: 'https://i.imgur.com/axLm3p6.png'
        })
        if (rep !== undefined && rep.text !== undefined) {
          const message = rep.text.trim()
          if (message.length !== 0) {
            this.twitterPostTweet({message})
          }
        }
      } catch (e) {
        await this.$phoneAPI.log(e)
      }
    },
    async tweeter() {
      if (this.message === '') return
      await this.twitterPostTweet({message: this.message})
      this.message = ''
    },
    onBack() {
      if (this.useMouse === true && document.activeElement.tagName !== 'BODY') return
      this.$bus.$emit('twitterHome')
    }
  }
}
</script>

<style scoped>
.phone_content {
  background: #DBF0F4;

}

.tweet_write {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: flex-end;
}

.tweet_write .textarea-input {
  align-self: center;
  width: 90%;
  margin-top: 20px;
  border: none;
  outline: none;
  padding: 13px 16px;
  height: 336px;
  background-color: #ffffff;
  border-radius: 16px;
  resize: none;
  color: #222;
  font-size: 18px;
}


.tweet_send {
  align-self: flex-end;
  width: 120px;
  height: 32px;
  float: right;
  border-radius: 16px;
  background-color: rgb(29, 161, 242);
  color: white;
  line-height: 32px;
  text-align: center;
  margin: 26px 20px;
  font-size: 16px;
}

.tweet_send:hover {
  cursor: pointer;
  background-color: #0084b4;
}
</style>
