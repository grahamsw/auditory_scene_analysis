<script setup lang="ts">
import { ref, onUnmounted, watch, computed } from 'vue'
import { getAudioContext } from '../../audio'

const isPlaying = ref(false)
const fundamental = ref(200)
const mistuning = ref(1.0) // 1.0 = in tune, 1.1 = 10% mistuned
const targetPartial = ref(3)
const fundamentalLevel = ref(1.0) // Lowering fundamental reduces upward masking of higher overtones

const isSweeping = ref(false)
const hysteresisActive = ref(false)
const sweepTime = ref(0)
let sweepStartTime = 0
let animationId: number | null = null

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
  masterGain.gain.linearRampToValueAtTime(0.25, ctx.currentTime + 0.05)
  masterGain.connect(ctx.destination)

  // Create 6 harmonics (harmonics 1 to 6)
  for (let i = 1; i <= 6; i++) {
    const osc = ctx.createOscillator()
    const gain = ctx.createGain()
    
    let freq = fundamental.value * i
    if (i === targetPartial.value) {
      freq *= mistuning.value
    }

    osc.type = 'sine'
    osc.frequency.setValueAtTime(freq, ctx.currentTime)
    
    // All harmonics at equal volume (0.1) to start.
    let vol = 0.1
    if (i === 1) {
      vol = 0.1 * fundamentalLevel.value
    }
    gain.gain.setValueAtTime(vol, ctx.currentTime)

    osc.connect(gain)
    gain.connect(masterGain)
    osc.start()
    
    partials.push({ osc, gain })
  }

  isPlaying.value = true
}

function updateAudioParams() {
  if (!isPlaying.value) return
  const ctx = getAudioContext()
  
  partials.forEach((p, idx) => {
    const pNum = idx + 1
    
    // Frequency
    let freq = fundamental.value * pNum
    if (pNum === targetPartial.value) {
      freq *= mistuning.value
    }
    p.osc.frequency.setTargetAtTime(freq, ctx.currentTime, 0.03)
    
    // Gain / Volume: target harmonic stays unaltered, fundamental is scaled
    let vol = 0.1
    if (pNum === 1) {
      vol = 0.1 * fundamentalLevel.value
    }
    p.gain.gain.setTargetAtTime(vol, ctx.currentTime, 0.03)
  })
}

watch([fundamental, mistuning, targetPartial, fundamentalLevel], updateAudioParams)

function stop() {
  isPlaying.value = false
  stopSweep()
  const ctx = getAudioContext()
  
  if (masterGain) {
    masterGain.gain.cancelScheduledValues(ctx.currentTime)
    masterGain.gain.setTargetAtTime(0, ctx.currentTime, 0.05)
    setTimeout(() => {
      partials.forEach(p => {
        try {
          p.osc.stop()
        } catch(e) {}
        p.osc.disconnect()
        p.gain.disconnect()
      })
      partials = []
      masterGain?.disconnect()
      masterGain = null
    }, 100)
  }
}

// Hysteresis Sweep Logic
// Runs 3 continuous cycles of mistuning (out-of-tune and back) at different rates, 
// then holds at the original pitch to demonstrate hysteresis memory.
// - Cycle 1: Slow (5s duration)
// - Cycle 2: Medium (3s duration)
// - Cycle 3: Fast (1.5s duration)
// - Hold: 3s post-sweep tracking at 1.0
function runSweep() {
  if (!isPlaying.value) {
    start()
  }
  
  isSweeping.value = true
  hysteresisActive.value = false
  sweepStartTime = performance.now()
  
  const tick = () => {
    if (!isSweeping.value || !isPlaying.value) return
    
    const elapsed = (performance.now() - sweepStartTime) / 1000
    sweepTime.value = elapsed
    
    let cycleVal = 1.0
    let isReturning = false
    
    if (elapsed < 5.0) {
      // Cycle 1: Slow (5s duration)
      const e = elapsed
      const d = 5.0
      if (e < d / 2) {
        cycleVal = 1.0 + (e / (d / 2)) * 0.12
        isReturning = false
      } else {
        cycleVal = 1.12 - ((e - d / 2) / (d / 2)) * 0.12
        isReturning = true
      }
    } else if (elapsed < 8.0) {
      // Cycle 2: Medium (3s duration)
      const e = elapsed - 5.0
      const d = 3.0
      if (e < d / 2) {
        cycleVal = 1.0 + (e / (d / 2)) * 0.12
        isReturning = false
      } else {
        cycleVal = 1.12 - ((e - d / 2) / (d / 2)) * 0.12
        isReturning = true
      }
    } else if (elapsed < 9.5) {
      // Cycle 3: Fast (1.5s duration)
      const e = elapsed - 8.0
      const d = 1.5
      if (e < d / 2) {
        cycleVal = 1.0 + (e / (d / 2)) * 0.12
        isReturning = false
      } else {
        cycleVal = 1.12 - ((e - d / 2) / (d / 2)) * 0.12
        isReturning = true
      }
    } else if (elapsed < 12.5) {
      // Post-sweep hold at 1.0
      cycleVal = 1.0
      isReturning = true
    } else {
      // End of sweep
      mistuning.value = 1.0
      hysteresisActive.value = false
      isSweeping.value = false
      return
    }
    
    mistuning.value = cycleVal
    hysteresisActive.value = isReturning
    
    animationId = requestAnimationFrame(tick)
  }
  
  animationId = requestAnimationFrame(tick)
}

function stopSweep() {
  isSweeping.value = false
  hysteresisActive.value = false
  sweepTime.value = 0
  if (animationId !== null) {
    cancelAnimationFrame(animationId)
    animationId = null
  }
}

onUnmounted(() => {
  stop()
})

// Visuals
const svgWidth = 400
const svgHeight = 120

// Compute orbit positions for the Object separation visualizer
const satelliteX = computed(() => {
  // Center of complex tone is at X=200
  // Displacement depends on mistuning level.
  const baseOffset = 200
  const maxDisplacement = 120
  const displacement = (mistuning.value - 1.0) / 0.12 * maxDisplacement
  return baseOffset + displacement
})

const sweepProgressPercent = computed(() => {
  return (sweepTime.value / 12.5) * 100
})

const sweepStatusText = computed(() => {
  if (!isSweeping.value) return ''
  const t = sweepTime.value
  if (t < 5.0) return `Cycle 1 (Slow): ${t < 2.5 ? 'Drifting out...' : 'Returning to tune...'}`
  if (t < 8.0) return `Cycle 2 (Medium): ${t - 5.0 < 1.5 ? 'Drifting out...' : 'Returning to tune...'}`
  if (t < 9.5) return `Cycle 3 (Fast): ${t - 8.0 < 0.75 ? 'Drifting out...' : 'Returning to tune...'}`
  if (t < 12.5) return 'Hysteresis: In tune, but still tracked by the brain!'
  return 'Fused'
})
</script>

<template>
  <div class="controls">
    <div class="visualizer-container">
      <div class="diagram-label">Perceptual Object Map</div>
      <div class="diagram mapping-diagram">
        <svg :width="svgWidth" :height="svgHeight" :viewBox="`0 0 ${svgWidth} ${svgHeight}`">
          <!-- Connection line if mistuned -->
          <line v-if="mistuning > 1.0"
            x1="120" y1="60" :x2="satelliteX" y2="60"
            stroke="#646cff" stroke-width="2" stroke-dasharray="4,4"
          />

          <!-- Complex Tone Object (Fused Core) -->
          <circle cx="120" cy="60" r="30" fill="#333" stroke="#888" stroke-width="2" />
          <text x="120" y="64" fill="#aaa" font-size="11" text-anchor="middle" font-weight="bold">
            Complex Tone
          </text>
          
          <!-- Hysteresis Glow effect -->
          <circle v-if="hysteresisActive"
            :cx="satelliteX" cy="60" r="22"
            fill="none" stroke="#646cff" stroke-width="3"
            class="glow-circle"
          />

          <!-- Target Partial Object (Satellite) -->
          <circle :cx="satelliteX" cy="60" r="16" 
            :fill="mistuning > 1.0 || hysteresisActive ? '#646cff' : '#333'" 
            :stroke="mistuning > 1.0 || hysteresisActive ? '#fff' : '#888'" 
            stroke-width="2" 
          />
          <text :x="satelliteX" y="64" fill="#fff" font-size="10" text-anchor="middle" font-weight="bold">
            H{{ targetPartial }}
          </text>

          <!-- Labels -->
          <text v-if="mistuning > 1.0 || hysteresisActive"
            :x="satelliteX" y="95" 
            :fill="hysteresisActive ? '#a1a6ff' : '#646cff'" 
            font-size="11" text-anchor="middle" font-weight="bold"
          >
            {{ hysteresisActive ? 'Tracked Whistle' : 'Segregated Whistle' }}
          </text>
        </svg>
      </div>

      <!-- Sweep Progress Bar -->
      <div v-if="isSweeping" class="sweep-progress-container">
        <div class="sweep-status">{{ sweepStatusText }}</div>
        <div class="sweep-progress-track">
          <div class="sweep-progress-bar" :style="{ width: `${sweepProgressPercent}%` }"></div>
        </div>
      </div>
    </div>

    <div class="button-group">
      <button v-if="!isPlaying" class="primary" @click="start">Start Sound</button>
      <button v-else @click="stop" class="stop">Stop Sound</button>
      
      <button :class="{ active: isSweeping }" @click="runSweep">
        {{ isSweeping ? 'Restart Hysteresis Sweep' : 'Trigger Hysteresis Sweep' }}
      </button>
    </div>

    <div class="parameter">
      <label>Manual Mistuning: {{ ((mistuning - 1) * 100).toFixed(1) }}%</label>
      <input type="range" v-model.number="mistuning" min="0.88" max="1.12" step="0.002" :disabled="isSweeping">
      
      <p class="hint" :class="{ highlight: mistuning !== 1.0 || hysteresisActive }">
        <span v-if="mistuning === 1.0 && !hysteresisActive">
          <strong>Perfectly In Tune:</strong> The target harmonic fuses completely with the rest. You hear a single, rich hum.
        </span>
        <span v-else-if="mistuning !== 1.0 && !hysteresisActive">
          <strong>Mistuned:</strong> The harmonic has broken the harmonicity rule. It pops out as a distinct pure whistle on top of the hum.
        </span>
        <span v-else-if="hysteresisActive">
          <strong>Hysteresis Active:</strong> The harmonic is physically perfectly in tune, but because your brain was just tracking it, it <em>retains its identity as a separate whistle</em> for a few seconds before fading back into fusion.
        </span>
      </p>
    </div>

    <div class="parameter">
      <label>Fundamental Level: {{ (fundamentalLevel * 100).toFixed(0) }}%</label>
      <input type="range" v-model.number="fundamentalLevel" min="0.0" max="1.0" step="0.05">
      <p class="hint">Lowering the fundamental volume reduces upward masking, making the higher harmonics much easier to distinguish without altering their natural relative volumes.</p>
    </div>

    <div class="grid">
      <div class="parameter">
        <label>Fundamental Frequency: {{ fundamental }}Hz</label>
        <input type="range" v-model.number="fundamental" min="100" max="400" step="1" :disabled="isSweeping">
      </div>

      <div class="parameter">
        <label>Target Harmonic:</label>
        <div class="radio-group">
          <label 
            v-for="h in [2, 3, 4, 5, 6]" 
            :key="h" 
            class="radio-label" 
            :class="{ active: targetPartial === h, disabled: isSweeping }"
          >
            <input 
              type="radio" 
              :value="h" 
              v-model="targetPartial" 
              :disabled="isSweeping"
              name="targetHarmonic"
            />
            H{{ h }}
          </label>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.visualizer-container {
  margin-bottom: 2rem;
}

.diagram-label {
  font-size: 0.85rem;
  color: #888;
  margin-bottom: 0.3rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.mapping-diagram {
  background-color: #111;
  padding: 0.8rem;
  border-radius: 6px;
  border: 1px solid #333;
}

.sweep-progress-container {
  margin-top: 1rem;
}

.sweep-status {
  font-size: 0.85rem;
  font-weight: bold;
  color: #646cff;
  margin-bottom: 0.4rem;
}

.sweep-progress-track {
  width: 100%;
  height: 6px;
  background-color: #222;
  border-radius: 3px;
  overflow: hidden;
}

.sweep-progress-bar {
  height: 100%;
  background-color: #646cff;
  border-radius: 3px;
  transition: width 0.1s linear;
}

.glow-circle {
  stroke-dasharray: 4,4;
  animation: rotateGlow 8s linear infinite;
  transform-origin: center;
}

@keyframes rotateGlow {
  100% {
    transform: rotate(360deg);
  }
}

.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.hint {
  background-color: #222;
  padding: 0.8rem;
  border-radius: 6px;
  margin-top: 0.75rem;
  border-left: 3px solid #444;
}

.hint.highlight {
  border-left-color: #646cff;
  background-color: rgba(100, 108, 255, 0.1);
  color: #fff;
}

@media (prefers-color-scheme: light) {
  .mapping-diagram {
    background-color: #eaeaea;
    border-color: #ccc;
  }
  .hint {
    background-color: #f0f0f0;
    border-left-color: #ccc;
  }
  .hint.highlight {
    background-color: rgba(100, 108, 255, 0.05);
    color: #222;
  }
  .sweep-progress-track {
    background-color: #ddd;
  }
  .radio-label {
    background-color: #eee;
    border-color: #ccc;
    color: #333;
  }
  .radio-label:hover:not(.disabled) {
    border-color: #646cff;
    color: #000;
  }
  .radio-label.active {
    background-color: #646cff;
    border-color: #646cff;
    color: #fff;
  }
}

.radio-group {
  display: flex;
  gap: 0.4rem;
  flex-wrap: wrap;
  margin-top: 0.3rem;
}

.radio-label {
  display: flex;
  align-items: center;
  gap: 0.2rem;
  padding: 0.4rem 0.7rem;
  background-color: #222;
  border: 1px solid #444;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.85rem;
  color: #ccc;
  user-select: none;
  transition: all 0.2s;
}

.radio-label:hover:not(.disabled) {
  border-color: #646cff;
  color: #fff;
}

.radio-label.active {
  background-color: #646cff;
  border-color: #fff;
  color: #fff;
  font-weight: bold;
}

.radio-label.disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.radio-label input[type="radio"] {
  display: none;
}
</style>
