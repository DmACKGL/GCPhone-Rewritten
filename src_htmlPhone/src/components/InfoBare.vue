<template>
  <div
    style="width: 326px; top: 3px;"
    class="phone_infoBare barre-header"
  >
    <!-- <span class="reseau">{{ config.reseau }}</span>-->
    <span class="time">
      <current-time style="font-size: 12px; margin-right: 2px;" />
      #{{ myID }}
    </span>
    <div class="signal">
      <hr class="barre1">
      <hr class="barre2">
      <hr class="barre3">
      <hr class="barre4 nosignal">
    </div>
  </div>
</template>
<script>
import {mapGetters} from 'vuex'
import CurrentTime from './CurrentTime'

export default {
  components: {
    CurrentTime
  },
  computed: mapGetters(['myID', 'config']),
}
</script>
<style scoped>

.barre-header {
  height: 24px;
  font-size: 17px;
  line-height: 24px;
  padding: 1px 20px 0 24px;
  width: 100%;
  color: white;
  background-color: rgba(0, 0, 0, 0.2);
  position: relative;
}

.barre-header hr {
  position: absolute;
  display: inline-block;
}

.reseau {
  font-size: 12px;
}


.nosignal {
  background-color: rgba(255, 255, 255, 0.6) !important;
  color: rgba(255, 255, 255, 0.6) !important;
}

.barre1 {
  height: 3px;
  width: 3px;
  right: 12.5%;
  background-color: white;
  border: none;
  bottom: -3px;
}

.barre2 {
  height: 6px;
  width: 3px;
  right: 11.5%;
  background-color: white;
  border: none;
  bottom: -3px;
}

.barre3 {
  height: 9px;
  width: 3px;
  right: 10%;
  background-color: white;
  border: none;
  bottom: -3px;
}
.barre4 {
  height: 12px;
  width: 3px;
  right: 9%;
  background-color: white;
  border: none;
  bottom: -3px;
}

.time {
  text-align: right;
  float: left;
  margin-right: -14px;
  font-size: 12px;
  padding-right: 12px;
}

.playerID {
  text-align: center;
  float: left;
  margin: auto;
  width: 88%;
  font-size: 12px;
  padding-right: 12px;
}
</style>
