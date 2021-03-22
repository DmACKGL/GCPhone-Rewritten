<template>
  <div
    id="racing-hud"
  >
    <div id="Lap">
      Vuelta: {{ currentLap }}/{{ laps }}
    </div>
    <div id="Checkpoints">
      Checkpoint: {{ currentCheckpoint }}/{{ checkpoints }}
    </div>
    <div id="Laptime">
      Vuelta: {{ lapTime }}
    </div>
    <div id="FastestLaptime">
      Mas Rapida: {{ fastestLapTime }}
    </div>
    <div id="OverallTime">
      General: {{ overAllTime }}
    </div>
  </div>
</template>

<script>
var { DateTime } = require('luxon');

export default {
  data() {
    return {
      currentLap: 0,
      laps: 3,

      now: DateTime.local(),
      tick: null,

      lapTime: '00:00:00.000',
      fastestLapTime: '00:00.000',
      overAllTime: '00:00:00.000',

      currentCheckpoint: 0,
      checkpoints: 3,

    }
  },
  computed: {

  },
  watch: {
  },
  created() {
  },
  mounted() {
    this.tick = setInterval(() => {
      this.lapTime = DateTime
        .local()
        .diff(this.now)
        .toFormat('mm:ss.SSS')
      this.overAllTime = DateTime
        .local()
        .diff(this.now)
        .toFormat('mm:ss.SSS')
    }, 10)

  },
  beforeDestroy() {
  },
  methods: {
  },
}
</script>

<style scoped>
  #racing-hud {
    position:absolute;
    top:65%;
    left:2%;
    font-size:22px;
    color:white;
    letter-spacing: 1.1px;
    font-weight: 600;
    text-decoration: none;
    font-style: normal;
    font-variant: small-caps;
    text-transform: none;
    text-shadow: 1px 1px 1px rgba(1,1,1,1);
  }
</style>
