<template>
  <div
    id="racing-hud"
  >
    <div class="inside">
      <table class="table table-borderless table-sm">
        <tbody class="text-white">
          <tr>
            <td>Pos</td>
            <td class="text-right">
              {{ raceInfo.currentPosition }}/{{ raceInfo.players }}
            </td>
          </tr>
          <tr>
            <td>Lap</td>
            <td class="text-right">
              {{ raceInfo.currentLap+1 }}/{{ raceInfo.totalLaps }}
            </td>
          </tr>
          <tr>
            <td>Checkpoint</td>
            <td class="text-right">
              {{ raceInfo.currentCheckpoint }}/{{ raceInfo.checkpoints }}
            </td>
          </tr>
          <tr>
            <td class="timing">
              Current Lap
            </td>
            <td class="timing text-right">
              {{ lapTime }}
            </td>
          </tr>
          <tr>
            <td class="timing">
              Best Lap
            </td>
            <td class="timing text-right">
              {{ bestLap }}
            </td>
          </tr>
          <tr>
            <td class="timing">
              Total Time
            </td>
            <td class="timing text-right">
              {{ totalTime }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import {mapGetters} from "vuex";

const {DateTime} = require('luxon');

export default {
  data() {
    return {
      nowLap: DateTime.local(),
      nowTotal: DateTime.local(),
      tick: null,
      lapTime: "--:--:--",
      totalTime: "--:--:--",
      bestLap: "--:--:--",
      lapTimes: []
    }
  },
  computed: {
    ...mapGetters(['raceInfo', 'raceStatus', 'raceLap'])
  },
  watch: {
    raceStatus() {
      this.raceStatus === 1 ? this.startTimers() : this.stopTimers()
    },
    raceLap() {
      if(this.raceLap !== 0) {
        this.lapTimes.push(DateTime.fromFormat(this.lapTime, 'mm:ss.SSS').toMillis())
        this.nowLap = DateTime.local()
        this.bestLap = DateTime.fromMillis(Math.min.apply(Math, this.lapTimes)).toFormat('mm:ss.SSS')
      }
    }

  },
  created() {
  },
  mounted() {

  },
  beforeDestroy() {
    if (this.tick) clearInterval(this.tick)
  },
  methods: {
    startTimers() {
      const self = this
      this.nowLap = this.nowTotal = DateTime.local()
      this.tick = setInterval(() => {
        self.lapTime = DateTime
          .local()
          .diff(this.nowLap)
          .toFormat('mm:ss.SSS')
        self.totalTime = DateTime
          .local()
          .diff(this.nowTotal)
          .toFormat('mm:ss.SSS')
      }, 10)
    },
    stopTimers() {
      clearInterval(this.tick)
    }
  },
}
</script>

<style scoped lang="scss">
  *::v-deep {
    @import '~bootstrap/scss/bootstrap.scss';
  }
</style>

<style scoped>
#racing-hud {
  background-color: #4e4e4e75;
  position: absolute;
  bottom: 3%;
  right: 2%;
  font-size: 22px;
  font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans","Liberation Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
}
#racing-hud .inside {
  margin: 10px
}
.timing {
  font-size: 15px;
}

</style>
