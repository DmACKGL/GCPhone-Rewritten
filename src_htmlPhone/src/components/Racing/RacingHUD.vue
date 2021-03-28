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
              {{ raceInfo.currentLap }}/{{ raceInfo.totalLaps }}
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
      now: DateTime.local(),
      tick: null,
      lapTime: "--:--:--",
      totalTime: "--:--:--",
      bestLap: "--:--:--"
    }
  },
  computed: {
    ...mapGetters(['raceInfo'])
  },
  watch: {
    raceStatus() {
      if (this.raceStatus) {
        this.tick = setInterval(() => {
          this.lapTime = DateTime
            .local()
            .diff(this.now)
            .toFormat('mm:ss.SSS')
          this.totalTime = DateTime
            .local()
            .diff(this.now)
            .toFormat('mm:ss.SSS')
        }, 10)
      } else {
        clearInterval(this.tick)
      }
    },
    currentLap() {
      console.log(this.currentLap)
    }
  },
  created() {
  },
  mounted() {

  },
  beforeDestroy() {
  },
  methods: {},
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
