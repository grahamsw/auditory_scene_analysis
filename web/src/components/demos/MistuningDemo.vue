<script setup lang="ts">
import { ref, onUnmounted, watch } from 'vue'
import { getAudioContext } from '../../audio'

const isPlaying = ref(false)
const fundamental = ref(200)
const mistuning = ref(1.0) // 1.0 = in tune, 1.1 = 10% mistuned
const targetPartial = ref(3)

interface PartialNode {
  osc: OscillatorNode;
  gain: GainNode;
}

let partials: PartialNode[] = []
let masterGain: GainNode | null = null

function start() {
  if (isPlaying.value) return
  const ctx = getAudioContext()
  if (ctx.state === 'suspended') ctx.resume()

  masterGain = ctx.createGain()
  masterGain.gain.setValueAtTime(0, ctx.currentTime)
  masterGain.gain.linearRampToValueAtTime(0.2, ctx.currentTime + 0.1)
  masterGain.connect(ctx.destination)

  // Create 8 harmonics
  for (let i = 1; i <= 8; i++) {
    const osc = ctx.createOscillator()
    const gain = ctx.createGain()
    
    let freq = fundamental.value * i
    if (i === targetPartial.value) {
      freq *= mistuning.value
    }

    osc.frequency.setValueAtTime(freq, ctx.currentTime)
    gain.gain.setValueAtTime(1 / i, ctx.currentTime) // Roll off higher harmonics

    osc.connect(gain)
    gain.connect(masterGain)
    osc.start()
    
    partials.push({ osc, gain })
  }

  isPlaying.value = true
}

function updateFrequencies() {
  if (!isPlaying.value) return
  const ctx = getAudioContext()
  
  partials.forEach((p, idx) => {
    const pNum = idx + 1
    let freq = fundamental.value * pNum
    if (pNum === targetPartial.value) {
      freq *= mistuning.value
    }
    p.osc.frequency.setTargetAtTime(freq, ctx.currentTime, 0.05)
  })
}

watch([fundamental, mistuning, targetPartial], updateFrequencies)

function stop() {
  isPlaying.value = false
  const ctx = getAudioContext()
  
  if (masterGain) {
    masterGain.gain.setTargetAtTime(0, ctx.currentTime, 0.05)
    setTimeout(() => {
      partials.forEach(p => p.osc.stop())
      partials = []
      masterGain?.disconnect()
      masterGain = null
    }, 100)
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
        <!-- Harmonic series representation -->
        <line x1="20" y1="90" x2="180" y2="90" stroke="#444" stroke-width="2" />
        <line v-for="i in 8" :key="i"
          :x1="20 + (i-1)*20" :y1="90" 
          :x2="20 + (i-1)*20" :y2="i === targetPartial ? 90 - (60 * mistuning) : 90 - (40)" 
          :stroke="i === targetPartial ? '#646cff' : '#888'" 
          stroke-width="4" 
        />
      </svg>
    </div>

    <div class="button-group">
      <button v-if="!isPlaying" class="primary" @click="start">Start Demo</button>
      <button v-else @click="stop">Stop Demo</button>
    </div>

    <div class="parameter">
      <label>Mistuning: {{ ((mistuning - 1) * 100).toFixed(1) }}%</label>
      <input type="range" v-model.number="mistuning" min="0.8" max="1.2" step="0.005">
      <p class="hint">As you move the slider, the {{ targetPartial }}{{ targetPartial === 3 ? 'rd' : 'th' }} partial will "pop out" as a separate tone.</p>
    </div>

    <div class="parameter">
      <label>Fundamental Frequency: {{ fundamental }}Hz</label>
      <input type="range" v-model.number="fundamental" min="100" max="400" step="1">
    </div>

    <div class="parameter">
      <label>Target Partial: {{ targetPartial }}</label>
      <input type="range" v-model.number="targetPartial" min="1" max="8" step="1">
    </div>
  </div>
</template>
