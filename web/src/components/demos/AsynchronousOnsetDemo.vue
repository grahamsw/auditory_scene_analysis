<script setup lang="ts">
import { ref, onUnmounted, computed } from 'vue'
import { getAudioContext } from '../../audio'

const isPlaying = ref(false)
const fundamental = ref(200)
const onsetDelay = ref(0.0) // Onset delay in seconds (0.0 to 0.15, i.e. 0 to 150ms)
const targetPartial = ref(3) // Harmonic index to delay (1-8)
const noteDuration = ref(0.4) // Duration of each note (seconds)
const repeatRate = ref(1.5) // Repeat interval (seconds)

let audioCtx: AudioContext | null = null
let intervalId: number | null = null
let animationId: number | null = null
let playheadStartTime = 0
const playheadProgress = ref(-1) // -1 means not playing a note, 0 to 1 means playing

function playNote(time: number) {
  if (!audioCtx) return
  
  const baseFreq = fundamental.value
  const target = targetPartial.value
  const delay = onsetDelay.value
  const duration = noteDuration.value

  const master = audioCtx.createGain()
  master.gain.setValueAtTime(0, time)
  master.gain.linearRampToValueAtTime(0.2, time + 0.005)
  master.gain.setValueAtTime(0.2, time + duration - 0.01)
  master.gain.exponentialRampToValueAtTime(0.001, time + duration)
  master.connect(audioCtx.destination)

  // We keep track of the oscillators so we can stop them if the user presses stop
  const noteOscs: OscillatorNode[] = []

  // Create 5 harmonics
  for (let i = 1; i <= 5; i++) {
    const osc = audioCtx.createOscillator()
    const gain = audioCtx.createGain()
    
    osc.frequency.setValueAtTime(baseFreq * i, time)
    
    // Volume roll-off: quieter fundamental and shallower roll-off (1/sqrt(i)) to reduce upward masking
    const vol = 0.2 / Math.sqrt(i)
    
    let onsetTime = time
    if (i === target) {
      onsetTime = time + delay
    }

    gain.gain.setValueAtTime(0, time)
    gain.gain.setValueAtTime(0, onsetTime)
    gain.gain.linearRampToValueAtTime(vol, onsetTime + 0.005)
    gain.gain.setValueAtTime(vol, time + duration - 0.01)
    gain.gain.exponentialRampToValueAtTime(0.001, time + duration)

    osc.connect(gain)
    gain.connect(master)
    
    osc.start(onsetTime)
    osc.stop(time + duration)
    
    noteOscs.push(osc)
  }

  // Trigger playhead animation in sync
  const delayToStartAnimation = (time - audioCtx.currentTime) * 1000
  setTimeout(() => {
    if (!isPlaying.value) return
    playheadStartTime = performance.now()
    animatePlayhead()
  }, Math.max(0, delayToStartAnimation))
}

function animatePlayhead() {
  if (!isPlaying.value) {
    playheadProgress.value = -1
    return
  }
  
  const now = performance.now()
  const elapsed = (now - playheadStartTime) / 1000
  const duration = noteDuration.value
  
  if (elapsed < duration) {
    playheadProgress.value = elapsed / duration
    animationId = requestAnimationFrame(animatePlayhead)
  } else {
    playheadProgress.value = -1
  }
}

function tick(nextTime: number) {
  if (!isPlaying.value) return
  
  playNote(nextTime)
  
  const nextScheduled = nextTime + repeatRate.value
  const msToNext = (nextScheduled - (audioCtx?.currentTime || 0)) * 1000
  
  intervalId = window.setTimeout(() => {
    tick(nextScheduled)
  }, Math.max(25, msToNext - 50)) // Look ahead by 50ms
}

function start() {
  if (isPlaying.value) return
  audioCtx = getAudioContext()
  if (audioCtx.state === 'suspended') audioCtx.resume()

  isPlaying.value = true
  
  // Start the scheduling tick
  const startOffset = audioCtx.currentTime + 0.1
  tick(startOffset)
}

function stop() {
  isPlaying.value = false
  if (intervalId) clearTimeout(intervalId)
  if (animationId) cancelAnimationFrame(animationId)
  playheadProgress.value = -1
}

onUnmounted(() => {
  stop()
})

// Visual drawing helper
const svgWidth = 400
const svgHeight = 130

const playheadX = computed(() => {
  if (playheadProgress.value < 0) return 0
  const startX = 60
  const width = svgWidth - 80
  return startX + playheadProgress.value * width
})

const harmonicBars = computed(() => {
  const bars = []
  const startX = 60
  const width = svgWidth - 80
  const duration = noteDuration.value
  
  for (let i = 1; i <= 5; i++) {
    const isTarget = i === targetPartial.value
    const delay = isTarget ? onsetDelay.value : 0
    const delayPct = delay / duration
    
    const x = startX + delayPct * width
    const w = width * (1 - delayPct)
    const y = 15 + (i - 1) * 18
    
    bars.push({
      index: i,
      x,
      y,
      width: w,
      height: 10,
      isTarget,
      label: `H${i}`
    })
  }
  return bars
})
</script>

<template>
  <div class="controls">
    <div class="visualizer-container">
      <div class="diagram-label">Harmonic Onset Timeline (Note Playback)</div>
      <div class="diagram onset-diagram">
        <svg :width="svgWidth" :height="svgHeight" :viewBox="`0 0 ${svgWidth} ${svgHeight}`">
          <!-- Timeline axes -->
          <line x1="60" y1="115" x2="380" y2="115" stroke="#444" stroke-width="2" />
          <text x="60" y="127" fill="#666" font-size="10" text-anchor="middle">0 ms</text>
          <text x="220" y="127" fill="#666" font-size="10" text-anchor="middle">{{ (noteDuration * 500).toFixed(0) }} ms</text>
          <text x="380" y="127" fill="#666" font-size="10" text-anchor="middle">{{ (noteDuration * 1000).toFixed(0) }} ms</text>

          <!-- Harmonic Bars -->
          <g v-for="b in harmonicBars" :key="b.index">
            <!-- Label -->
            <text x="45" :y="b.y + 9" fill="#aaa" font-size="10" font-weight="bold" text-anchor="end">
              {{ b.label }}
            </text>
            
            <!-- Bar -->
            <rect 
              :x="b.x" :y="b.y" :width="b.width" :height="b.height"
              :fill="b.isTarget ? '#646cff' : '#555'"
              :opacity="b.isTarget ? 0.9 : 0.6"
              rx="2"
            />
            
            <!-- If target is delayed, draw a dotted line indicating the delay gap -->
            <line v-if="b.isTarget && onsetDelay > 0"
              x1="60" :y1="b.y + 5" :x2="b.x" :y2="b.y + 5"
              stroke="#646cff" stroke-width="1.5" stroke-dasharray="3,3"
            />
          </g>

          <!-- Playhead line -->
          <line v-if="playheadProgress >= 0"
            :x1="playheadX" y1="5" :x2="playheadX" y2="115"
            stroke="#ff4646" stroke-width="2"
          />
        </svg>
      </div>
    </div>

    <div class="button-group">
      <button v-if="!isPlaying" class="primary" @click="start">Start Repeating Note</button>
      <button v-else @click="stop" class="stop">Stop Demo</button>
    </div>

    <div class="parameter">
      <label>Onset Delay (Target Harmonic): {{ (onsetDelay * 1000).toFixed(0) }} ms</label>
      <input type="range" v-model.number="onsetDelay" min="0.0" max="0.15" step="0.005">
      
      <p class="hint" :class="{ highlight: onsetDelay > 0.02 }">
        <span v-if="onsetDelay === 0">
          <strong>Perfect Synchrony (0 ms):</strong> All components start together. The sound fuses perfectly into a single musical tone.
        </span>
        <span v-else-if="onsetDelay <= 0.02">
          <strong>Sub-threshold Delay ({{ (onsetDelay * 1000).toFixed(0) }} ms):</strong> The delay is barely audible. The components still mostly fuse.
        </span>
        <span v-else>
          <strong>Fusion Broken ({{ (onsetDelay * 1000).toFixed(0) }} ms):</strong> You hear a separate "chirp" or "ping" at the beginning of the note. This is the target harmonic popping out because it violated the simultaneous onset rule.
        </span>
      </p>
    </div>

    <div class="grid">
      <div class="parameter">
        <label>Fundamental (Pitch): {{ fundamental }} Hz</label>
        <input type="range" v-model.number="fundamental" min="100" max="400" step="5">
      </div>
      <div class="parameter">
        <label>Target Harmonic:</label>
        <div class="radio-group">
          <label 
            v-for="h in [1, 2, 3, 4, 5]" 
            :key="h" 
            class="radio-label" 
            :class="{ active: targetPartial === h }"
          >
            <input 
              type="radio" 
              :value="h" 
              v-model="targetPartial" 
              name="onsetHarmonic"
            />
            H{{ h }}
          </label>
        </div>
      </div>
      <div class="parameter">
        <label>Note Duration: {{ (noteDuration * 1000).toFixed(0) }} ms</label>
        <input type="range" v-model.number="noteDuration" min="0.2" max="0.8" step="0.05">
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

.onset-diagram {
  background-color: #111;
  padding: 0.8rem;
  border-radius: 6px;
  border: 1px solid #333;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
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
  .onset-diagram {
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
  .radio-label {
    background-color: #eee;
    border-color: #ccc;
    color: #333;
  }
  .radio-label:hover {
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

.radio-label:hover {
  border-color: #646cff;
  color: #fff;
}

.radio-label.active {
  background-color: #646cff;
  border-color: #fff;
  color: #fff;
  font-weight: bold;
}

.radio-label input[type="radio"] {
  display: none;
}
</style>
