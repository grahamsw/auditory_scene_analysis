<script setup lang="ts">
import { ref, onUnmounted } from 'vue'
import { getAudioContext } from '../../audio'

const isPlaying = ref(false)
const tempo = ref(0.2)
const frequencyH = ref(800)
const frequencyL = ref(400)

let intervalId: number | null = null

function playTone(freq: number, duration: number) {
  const ctx = getAudioContext()
  const osc = ctx.createOscillator()
  const gain = ctx.createGain()

  osc.type = 'sine'
  osc.frequency.setValueAtTime(freq, ctx.currentTime)

  gain.gain.setValueAtTime(0, ctx.currentTime)
  gain.gain.linearRampToValueAtTime(0.1, ctx.currentTime + 0.01)
  gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + duration)

  osc.connect(gain)
  gain.connect(ctx.destination)

  osc.start()
  osc.stop(ctx.currentTime + duration)
}

function start() {
  if (isPlaying.value) return
  isPlaying.value = true
  
  const ctx = getAudioContext()
  if (ctx.state === 'suspended') {
    ctx.resume()
  }

  let count = 0
  const freqs = [frequencyL.value, frequencyH.value, frequencyL.value]
  
  const tick = () => {
    if (!isPlaying.value) return
    
    const f = freqs[count % 3]
    playTone(f, tempo.value * 0.8)
    
    count++
    const nextWait = (count % 3 === 0) ? tempo.value * 1.5 : tempo.value
    intervalId = window.setTimeout(tick, nextWait * 1000)
  }
  
  tick()
}

function stop() {
  isPlaying.value = false
  if (intervalId !== null) {
    clearTimeout(intervalId)
    intervalId = null
  }
}

onUnmounted(() => {
  stop()
})
</script>

<template>
  <div class="controls">
    <div class="diagram">
      <svg width="200" height="100" viewBox="0 0 200 100">
        <circle cx="20" cy="80" r="5" fill="#646cff" />
        <circle cx="50" cy="20" r="5" fill="#646cff" />
        <circle cx="80" cy="80" r="5" fill="#646cff" />
        
        <circle cx="120" cy="80" r="5" fill="#646cff" />
        <circle cx="150" cy="20" r="5" fill="#646cff" />
        <circle cx="180" cy="80" r="5" fill="#646cff" />
      </svg>
    </div>

    <div class="button-group">
      <button v-if="!isPlaying" class="primary" @click="start">Start Demo</button>
      <button v-else @click="stop">Stop Demo</button>
    </div>

    <div class="parameter">
      <label>Tempo (Speed): {{ tempo.toFixed(2) }}s</label>
      <input type="range" v-model.number="tempo" min="0.05" max="0.5" step="0.01">
      <p class="hint">Slow (0.2s+) sounds like a gallop. Fast (0.1s-) sounds like two streams.</p>
    </div>

    <div class="parameter">
      <label>High Frequency: {{ frequencyH }}Hz</label>
      <input type="range" v-model.number="frequencyH" min="400" max="2000" step="10">
    </div>

    <div class="parameter">
      <label>Low Frequency: {{ frequencyL }}Hz</label>
      <input type="range" v-model.number="frequencyL" min="100" max="800" step="10">
    </div>
  </div>
</template>

<style scoped>
.hint {
  font-size: 0.8rem;
  color: #888;
  margin-top: 0.5rem;
}
</style>
