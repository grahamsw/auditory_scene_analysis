<script setup lang="ts">
import { ref, onUnmounted, onMounted, computed, watch } from 'vue'
import { getAudioContext } from '../../audio'
import type { HomophonicSettings } from '../../types'

const DEFAULT_SETTINGS: HomophonicSettings = {
  riseTime: 0.25,
  fallTime: 0.25,
  baseLevel: 0.25,
  base1Dur: 0.342,
  peakDur: 0.1,
  base2Dur: 0.348,
  cycleDur: 2.0,
  filterFreq: 1000,
  filterQ: 1.0,
  isSpatialEnabled: false,
  isCurved: true
}

const isPlaying = ref(false)
const baseLevel = ref(0.25)
const riseTime = ref(0.25)
const fallTime = ref(0.25)
const isSpatialEnabled = ref(false)
const isCurved = ref(false)
const currentTime = ref(0) // Seconds into the current cycle

// Timing refs (matching SC defaults)
const base1Dur = ref(0.342)
const peakDur = ref(0.1)
const base2Dur = ref(0.348)
const cycleDur = ref(2.0)

// Spectral refs
const filterFreq = ref(1000)
const filterQ = ref(1.0)

// Preset state
const set1 = ref<HomophonicSettings>({ ...DEFAULT_SETTINGS })
const set2 = ref<HomophonicSettings>({ 
  ...DEFAULT_SETTINGS,
  riseTime: 0.001,
  fallTime: 0.001
})
const lastLoadedSet = ref<number | null>(null)

const activeSetLabel = computed(() => {
  if (lastLoadedSet.value === null) return 'No Set Loaded'
  return `Set ${lastLoadedSet.value} Active`
})

function saveToSet(index: number) {
  const settings: HomophonicSettings = {
    riseTime: riseTime.value,
    fallTime: fallTime.value,
    baseLevel: baseLevel.value,
    base1Dur: base1Dur.value,
    peakDur: peakDur.value,
    base2Dur: base2Dur.value,
    cycleDur: cycleDur.value,
    filterFreq: filterFreq.value,
    filterQ: filterQ.value,
    isSpatialEnabled: isSpatialEnabled.value,
    isCurved: isCurved.value
  }
  
  if (index === 1) set1.value = settings
  else set2.value = settings
}

function loadFromSet(index: number) {
  const settings = index === 1 ? set1.value : set2.value
  
  riseTime.value = settings.riseTime
  fallTime.value = settings.fallTime
  baseLevel.value = settings.baseLevel
  base1Dur.value = settings.base1Dur
  peakDur.value = settings.peakDur
  base2Dur.value = settings.base2Dur
  cycleDur.value = settings.cycleDur
  filterFreq.value = settings.filterFreq
  filterQ.value = settings.filterQ
  isSpatialEnabled.value = settings.isSpatialEnabled
  isCurved.value = settings.isCurved
  
  lastLoadedSet.value = index
}

onMounted(() => {
  loadFromSet(1)
})

let audioCtx: AudioContext | null = null
let noiseBuffer: AudioBuffer | null = null
let noiseSource: AudioBufferSourceNode | null = null
let filterNode: BiquadFilterNode | null = null
let constantGainNode: GainNode | null = null
let intermittentGainNode: GainNode | null = null
let constantPanner: StereoPannerNode | null = null
let intermittentPanner: StereoPannerNode | null = null

// Scheduler state
let nextNoteTime = 0
let timerId: number | null = null
let animationId: number | null = null
const lookAhead = 0.1
const scheduleInterval = 25

// Map time to X coordinate in SVG (0 to 200)
const timeToX = (t: number) => (t / cycleDur.value) * 200

const envelopePath = computed(() => {
  const x1 = timeToX(base1Dur.value)
  const x2 = timeToX(base1Dur.value + riseTime.value)
  const x3 = timeToX(base1Dur.value + riseTime.value + peakDur.value)
  const x4 = timeToX(base1Dur.value + riseTime.value + peakDur.value + fallTime.value)
  
  const yBase = 80
  const yPeak = 20
  
  if (isCurved.value) {
    return `M 0,${yBase} L ${x1},${yBase} Q ${x2},${yBase} ${x2},${yPeak} L ${x3},${yPeak} Q ${x4},${yPeak} ${x4},${yBase} L 200,${yBase}`
  } else {
    return `M 0,${yBase} L ${x1},${yBase} L ${x2},${yPeak} L ${x3},${yPeak} L ${x4},${yBase} L 200,${yBase}`
  }
})

const playheadX = computed(() => timeToX(currentTime.value))

function updatePlayhead() {
  if (isPlaying.value && audioCtx) {
    // Calculate current cycle position
    const elapsed = audioCtx.currentTime - (nextNoteTime - cycleDur.value)
    currentTime.value = elapsed % cycleDur.value
    animationId = requestAnimationFrame(updatePlayhead)
  }
}

function createWhiteNoiseBuffer(ctx: AudioContext) {
  const bufferSize = 2 * ctx.sampleRate
  const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate)
  const output = buffer.getChannelData(0)
  for (let i = 0; i < bufferSize; i++) {
    output[i] = Math.random() * 2 - 1
  }
  return buffer
}

function generateQuadraticCurve(startValue: number, endValue: number, isRise: boolean, numPoints = 64) {
  const values = new Float32Array(numPoints)
  for (let i = 0; i < numPoints; i++) {
    const t = i / (numPoints - 1)
    if (isRise) {
      // y = start + (end - start) * t^2
      values[i] = startValue + (endValue - startValue) * (t * t)
    } else {
      // y = start - (start - end) * t^2 (starts slow at start, ends fast at end)
      values[i] = startValue - (startValue - endValue) * (t * t)
    }
  }
  return values
}

function scheduleEnvelope(time: number) {
  if (!constantGainNode || !intermittentGainNode) return

  // Sequence: Base -> Rise -> Peak -> Fall -> Base
  const b1 = base1Dur.value
  const r = riseTime.value
  const p = peakDur.value
  const f = fallTime.value
  const c = cycleDur.value

  // Safety: Ensure segments fit in cycle
  const totalSegments = b1 + r + p + f
  const effectiveC = Math.max(c, totalSegments + 0.01)
  
  // Constant Path: always at baseLevel
  constantGainNode.gain.cancelScheduledValues(time)
  constantGainNode.gain.setValueAtTime(baseLevel.value, time)
  constantGainNode.gain.setValueAtTime(baseLevel.value, time + effectiveC)

  // Intermittent Path: ramps from 0 to (1.0 - baseLevel)
  const peakVal = 1.0 - baseLevel.value
  intermittentGainNode.gain.cancelScheduledValues(time)
  intermittentGainNode.gain.setValueAtTime(0, time)
  intermittentGainNode.gain.setValueAtTime(0, time + b1)
  
  if (isCurved.value) {
    const riseCurve = generateQuadraticCurve(0, peakVal, true)
    const fallCurve = generateQuadraticCurve(peakVal, 0, false)
    intermittentGainNode.gain.setValueCurveAtTime(riseCurve, time + b1, r)
    intermittentGainNode.gain.setValueCurveAtTime(fallCurve, time + b1 + r + p, f)
  } else {
    intermittentGainNode.gain.linearRampToValueAtTime(peakVal, time + b1 + r)
    intermittentGainNode.gain.linearRampToValueAtTime(peakVal, time + b1 + r + p)
    intermittentGainNode.gain.linearRampToValueAtTime(0, time + b1 + r + p + f)
  }
  
  intermittentGainNode.gain.setValueAtTime(0, time + effectiveC)
}

function scheduler() {
  if (!audioCtx) return
  while (nextNoteTime < audioCtx.currentTime + lookAhead) {
    scheduleEnvelope(nextNoteTime)
    nextNoteTime += cycleDur.value
  }
  timerId = window.setTimeout(scheduler, scheduleInterval)
}

function updatePanning() {
  if (!constantPanner || !intermittentPanner || !audioCtx) return
  const constantPan = isSpatialEnabled.value ? -1 : 0
  const intermittentPan = isSpatialEnabled.value ? 1 : 0
  constantPanner.pan.setTargetAtTime(constantPan, audioCtx.currentTime, 0.05)
  intermittentPanner.pan.setTargetAtTime(intermittentPan, audioCtx.currentTime, 0.05)
}

function start() {
  if (isPlaying.value) return
  audioCtx = getAudioContext()
  if (audioCtx.state === 'suspended') audioCtx.resume()

  if (!noiseBuffer) {
    noiseBuffer = createWhiteNoiseBuffer(audioCtx)
  }

  noiseSource = audioCtx.createBufferSource()
  noiseSource.buffer = noiseBuffer
  noiseSource.loop = true
  
  filterNode = audioCtx.createBiquadFilter()
  filterNode.type = 'bandpass'
  filterNode.frequency.value = filterFreq.value
  filterNode.Q.value = filterQ.value

  constantGainNode = audioCtx.createGain()
  intermittentGainNode = audioCtx.createGain()
  
  constantPanner = audioCtx.createStereoPanner()
  intermittentPanner = audioCtx.createStereoPanner()
  updatePanning()

  noiseSource.connect(filterNode)
  
  filterNode.connect(constantGainNode)
  filterNode.connect(intermittentGainNode)
  
  constantGainNode.connect(constantPanner)
  intermittentGainNode.connect(intermittentPanner)
  
  constantPanner.connect(audioCtx.destination)
  intermittentPanner.connect(audioCtx.destination)
  
  noiseSource.start()
  isPlaying.value = true
  
  nextNoteTime = audioCtx.currentTime
  scheduler()
  updatePlayhead()
}

function stop() {
  isPlaying.value = false
  if (timerId) clearTimeout(timerId)
  if (animationId) cancelAnimationFrame(animationId)
  if (noiseSource) {
    try {
      noiseSource.stop()
    } catch (e) {
      // Ignore
    }
    noiseSource.disconnect()
    noiseSource = null
  }
  if (filterNode) {
    filterNode.disconnect()
    filterNode = null
  }
  if (constantGainNode) {
    constantGainNode.disconnect()
    constantGainNode = null
  }
  if (intermittentGainNode) {
    intermittentGainNode.disconnect()
    intermittentGainNode = null
  }
  if (constantPanner) {
    constantPanner.disconnect()
    constantPanner = null
  }
  if (intermittentPanner) {
    intermittentPanner.disconnect()
    intermittentPanner = null
  }
  currentTime.value = 0
}

onUnmounted(() => {
  stop()
})

watch(filterFreq, (newVal) => {
  if (filterNode && audioCtx) {
    filterNode.frequency.setTargetAtTime(newVal, audioCtx.currentTime, 0.05)
  }
})

watch(filterQ, (newVal) => {
  if (filterNode && audioCtx) {
    filterNode.Q.setTargetAtTime(newVal, audioCtx.currentTime, 0.05)
  }
})

watch(isSpatialEnabled, () => {
  updatePanning()
})
</script>

<style scoped>
fieldset {
  border: 1px solid #444;
  border-radius: 8px;
  padding: 1rem;
  margin-bottom: 1.5rem;
}

legend {
  padding: 0 0.5rem;
  font-size: 0.8rem;
  color: #646cff;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

@media (max-width: 600px) {
  .grid {
    grid-template-columns: 1fr;
  }
}

.preset-group {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.preset-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
  justify-content: space-between;
  padding: 0.5rem;
  background-color: #222;
  border-radius: 6px;
}

.preset-label {
  font-size: 0.8rem;
  font-weight: bold;
  color: #646cff;
}

button.small {
  padding: 0.4rem 0.8rem;
  font-size: 0.8rem;
}

button.capture {
  background-color: #444;
}

button.capture:hover {
  background-color: #555;
  border-color: #888;
}
</style>

<template>
  <div class="controls">
    <div class="diagram">
      <svg width="200" height="100" viewBox="0 0 200 100">
        <!-- Envelope Path -->
        <path 
          :d="envelopePath" 
          fill="none" 
          stroke="#646cff" 
          stroke-width="3" 
          stroke-linejoin="round"
        />
        <!-- Playhead -->
        <line 
          v-if="isPlaying"
          :x1="playheadX" y1="0" :x2="playheadX" y2="100" 
          stroke="#ff4646" stroke-width="2" 
        />
      </svg>
    </div>

    <div class="button-group">
      <button v-if="!isPlaying" class="primary" @click="start">Start Demo</button>
      <button v-else @click="stop" class="stop">Stop Demo</button>
    </div>

    <fieldset>
      <legend>Spatial Effect</legend>
      <div class="preset-controls">
        <span class="preset-label">
          {{ isSpatialEnabled ? 'Stereo (L/R)' : 'Mono (Center)' }}
        </span>
        <button class="small" @click="isSpatialEnabled = !isSpatialEnabled">
          Toggle Stereo Effect
        </button>
      </div>
      <div style="text-align: center; font-size: 0.8rem; color: #888; margin-top: 0.5rem;">
        Constant: {{ isSpatialEnabled ? 'Left' : 'Both' }} | 
        Intermittent: {{ isSpatialEnabled ? 'Right' : 'Both' }}
      </div>
    </fieldset>

    <fieldset>
      <legend>Presets & Comparison</legend>
      <div class="preset-group">
        <div class="preset-controls">
          <span class="preset-label">Set 1</span>
          <div class="button-group" style="margin-bottom: 0;">
            <button class="small capture" @click="saveToSet(1)">Capture</button>
            <button class="small" @click="loadFromSet(1)">Use Set 1</button>
          </div>
        </div>
        <div class="preset-controls">
          <span class="preset-label">Set 2</span>
          <div class="button-group" style="margin-bottom: 0;">
            <button class="small capture" @click="saveToSet(2)">Capture</button>
            <button class="small" @click="loadFromSet(2)">Use Set 2</button>
          </div>
        </div>
        <div style="text-align: center; font-size: 0.8rem; color: #888;">
          {{ activeSetLabel }}
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Envelope</legend>
      <div class="grid">
        <div class="parameter">
          <label>Rise Time: {{ (riseTime * 1000).toFixed(0) }}ms</label>
          <input type="range" v-model.number="riseTime" min="0.001" max="5.0" step="0.001">
        </div>
        <div class="parameter">
          <label>Fall Time: {{ (fallTime * 1000).toFixed(0) }}ms</label>
          <input type="range" v-model.number="fallTime" min="0.001" max="5.0" step="0.001">
        </div>
      </div>
      
      <div class="parameter">
        <label>Base Level: {{ (baseLevel * 100).toFixed(0) }}%</label>
        <input type="range" v-model.number="baseLevel" min="0.1" max="0.5" step="0.01">
      </div>

      <div class="preset-controls" style="margin-top: 1rem;">
        <span class="preset-label">
          Curve: {{ isCurved ? 'Accelerating' : 'Linear' }}
        </span>
        <button class="small" @click="isCurved = !isCurved">
          Toggle {{ isCurved ? 'Linear' : 'Curved' }}
        </button>
      </div>
      <div v-if="isCurved" style="text-align: center; font-size: 0.8rem; color: #888; margin-top: 0.5rem;">
        Curves start slow and get faster (quadratic).
      </div>

      <p class="hint" :class="{ highlight: riseTime < 0.01 || fallTime < 0.01 }">
        <span v-if="riseTime < 0.01 || fallTime < 0.01">
          <strong>Abrupt transition:</strong> Likely heard as TWO objects (one joining or leaving).
        </span>
        <span v-else-if="riseTime > 0.1 && fallTime > 0.1">
          <strong>Gradual transition:</strong> Likely heard as ONE object changing volume.
        </span>
        <span v-else>Intermediate transition range.</span>
      </p>
    </fieldset>

    <fieldset>
      <legend>Timing (Seconds)</legend>
      <div class="grid">
        <div class="parameter">
          <label>Base 1: {{ base1Dur.toFixed(3) }}s</label>
          <input type="range" v-model.number="base1Dur" min="0.01" max="1.0" step="0.01">
        </div>
        <div class="parameter">
          <label>Peak: {{ peakDur.toFixed(3) }}s</label>
          <input type="range" v-model.number="peakDur" min="0.01" max="0.5" step="0.01">
        </div>
        <div class="parameter">
          <label>Base 2: {{ base2Dur.toFixed(3) }}s</label>
          <input type="range" v-model.number="base2Dur" min="0.01" max="1.0" step="0.01">
        </div>
        <div class="parameter">
          <label>Cycle: {{ cycleDur.toFixed(1) }}s</label>
          <input type="range" v-model.number="cycleDur" min="0.5" max="15.0" step="0.1">
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Spectral Filter</legend>
      <div class="grid">
        <div class="parameter">
          <label>Frequency: {{ filterFreq }}Hz</label>
          <input type="range" v-model.number="filterFreq" min="100" max="5000" step="10">
        </div>
        <div class="parameter">
          <label>Bandwidth (Q): {{ filterQ.toFixed(1) }}</label>
          <input type="range" v-model.number="filterQ" min="0.1" max="20.0" step="0.1">
        </div>
      </div>
    </fieldset>
  </div>
</template>
