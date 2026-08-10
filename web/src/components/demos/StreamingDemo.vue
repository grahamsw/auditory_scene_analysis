<script setup lang="ts">
import { ref, onUnmounted, computed, watch } from 'vue'
import { getAudioContext } from '../../audio'

const isPlaying = ref(false)
const tempo = ref(0.2) // Current interval in seconds
const frequencyH = ref(800)
const frequencyL = ref(400)

// Computed property to reverse the slider mapping
// Slider left (min = 0.05) maps to tempo = 0.5s (slow)
// Slider right (max = 0.5) maps to tempo = 0.05s (fast)
const tempoSlider = computed({
  get: () => 0.55 - tempo.value,
  set: (val) => {
    tempo.value = 0.55 - val
  }
})

interface ActiveNote {
  osc: OscillatorNode;
  gain: GainNode;
  type: 'H' | 'L';
}

let activeNotes: ActiveNote[] = []
let intervalId: number | null = null

function playTone(freq: number, duration: number, type: 'H' | 'L') {
  const ctx = getAudioContext()
  const osc = ctx.createOscillator()
  const gain = ctx.createGain()

  osc.type = 'sine'
  osc.frequency.setValueAtTime(freq, ctx.currentTime)

  // Smooth onset and decay envelope to prevent clicks
  gain.gain.setValueAtTime(0, ctx.currentTime)
  gain.gain.linearRampToValueAtTime(0.12, ctx.currentTime + 0.008) // 8ms attack
  gain.gain.setValueAtTime(0.12, ctx.currentTime + duration - 0.015)
  gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + duration)

  osc.connect(gain)
  gain.connect(ctx.destination)

  osc.start()
  osc.stop(ctx.currentTime + duration)

  const noteRecord = { osc, gain, type }
  activeNotes.push(noteRecord)

  // Remove reference and disconnect nodes after note finishes
  setTimeout(() => {
    const idx = activeNotes.indexOf(noteRecord)
    if (idx !== -1) {
      activeNotes.splice(idx, 1)
    }
    osc.disconnect()
    gain.disconnect()
  }, duration * 1000 + 100)
}

function start() {
  if (isPlaying.value) return
  isPlaying.value = true
  
  const ctx = getAudioContext()
  if (ctx.state === 'suspended') {
    ctx.resume()
  }

  let count = 0
  
  const tick = () => {
    if (!isPlaying.value) return
    
    // Sequence pattern: L - H - L - [gap]
    const phase = count % 3
    const isHigh = phase === 1
    const f = isHigh ? frequencyH.value : frequencyL.value
    const noteType = isHigh ? 'H' : 'L'
    
    playTone(f, tempo.value * 0.8, noteType)
    
    count++
    // Cycle timing: gap after the third note (count % 3 === 0)
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
  
  // Stop and cleanup all currently sounding oscillators immediately
  activeNotes.forEach(n => {
    try {
      n.osc.stop()
    } catch (e) {}
    n.osc.disconnect()
    n.gain.disconnect()
  })
  activeNotes = []
}

// Watch frequency sliders and smoothly update active oscillators in real-time
watch(frequencyH, (newVal) => {
  const ctx = getAudioContext()
  activeNotes.forEach(n => {
    if (n.type === 'H') {
      n.osc.frequency.setTargetAtTime(newVal, ctx.currentTime, 0.02)
    }
  })
})

watch(frequencyL, (newVal) => {
  const ctx = getAudioContext()
  activeNotes.forEach(n => {
    if (n.type === 'L') {
      n.osc.frequency.setTargetAtTime(newVal, ctx.currentTime, 0.02)
    }
  })
})

onUnmounted(() => {
  stop()
})
</script>

<template>
  <div class="controls">
    <div class="diagram">
      <svg width="200" height="100" viewBox="0 0 200 100">
        <!-- Visual representation of high and low streams -->
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
      <button v-else @click="stop" class="stop">Stop Demo</button>
    </div>

    <div class="parameter">
      <label>Tempo (Speed): {{ (1 / tempo).toFixed(1) }} notes/sec ({{ tempo.toFixed(2) }}s interval)</label>
      <input type="range" v-model.number="tempoSlider" min="0.05" max="0.5" step="0.01">
      <p class="hint">Left is slow (2 notes/sec). Right is fast (20 notes/sec). Fast rates trigger stream segregation.</p>
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
