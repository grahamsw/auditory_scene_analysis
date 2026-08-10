<script setup lang="ts">
import { ref, onUnmounted, computed, watch } from 'vue'
import { getAudioContext } from '../../audio'

const isPlaying = ref(false)
const toneFreq = ref(1000)
const noiseLevel = ref(0.0) // User control for noise volume (0 to 1)
const toneDuration = ref(0.2) // Seconds
const gapDuration = ref(0.06) // Seconds
const gapsEnabled = ref(true) // If false, the tone plays continuously
const noiseMuted = ref(false) // If true, noise is silenced to reveal gaps

let audioCtx: AudioContext | null = null
let toneOsc: OscillatorNode | null = null
let toneGain: GainNode | null = null
let noiseSource: AudioBufferSourceNode | null = null
let noiseGain: GainNode | null = null
let noiseFilter: BiquadFilterNode | null = null
let masterGain: GainNode | null = null
let noiseBuffer: AudioBuffer | null = null

// Scheduler state
let nextEventTime = 0
let timerId: number | null = null
let animationId: number | null = null
const lookAhead = 0.1
const scheduleInterval = 25

// Playhead and visual tracking
const currentTime = ref(0)
const cycleDur = computed(() => toneDuration.value + gapDuration.value)

function createWhiteNoiseBuffer(ctx: AudioContext) {
  const bufferSize = 2 * ctx.sampleRate
  const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate)
  const output = buffer.getChannelData(0)
  for (let i = 0; i < bufferSize; i++) {
    output[i] = Math.random() * 2 - 1
  }
  return buffer
}

function updatePlayhead() {
  if (isPlaying.value && audioCtx) {
    const elapsed = audioCtx.currentTime - (nextEventTime - cycleDur.value)
    currentTime.value = elapsed % cycleDur.value
    animationId = requestAnimationFrame(updatePlayhead)
  }
}

function scheduleCycle(time: number) {
  if (!toneGain || !noiseGain || !audioCtx) return

  const tDur = toneDuration.value
  const gDur = gapDuration.value
  const total = tDur + gDur
  const rampTime = 0.003 // 3ms ramp to prevent clicks

  // --- Tone Scheduling ---
  
  // Tone ON phase
  toneGain.gain.setValueAtTime(0, time)
  toneGain.gain.linearRampToValueAtTime(0.05, time + rampTime)
  toneGain.gain.setValueAtTime(0.05, time + tDur - rampTime)
  
  // Tone GAP phase (OFF if gapsEnabled, otherwise ON)
  const gapToneVolume = gapsEnabled.value ? 0 : 0.05
  toneGain.gain.linearRampToValueAtTime(gapToneVolume, time + tDur)
  toneGain.gain.setValueAtTime(gapToneVolume, time + total - rampTime)
  
  // Ramp back down at the very end of the cycle to prepare for next cycle's onset
  toneGain.gain.linearRampToValueAtTime(0, time + total)

  // --- Noise Scheduling ---
  
  // Noise OFF during tone
  noiseGain.gain.setValueAtTime(0, time)
  noiseGain.gain.setValueAtTime(0, time + tDur - rampTime)
  
  // Noise ON during gap (if noise is not muted)
  const targetNoiseVolume = noiseMuted.value ? 0 : noiseLevel.value * 0.6
  noiseGain.gain.linearRampToValueAtTime(targetNoiseVolume, time + tDur)
  noiseGain.gain.setValueAtTime(targetNoiseVolume, time + total - rampTime)
  
  // Ramp back to 0 at the cycle boundary
  noiseGain.gain.linearRampToValueAtTime(0, time + total)
}

function scheduler() {
  if (!audioCtx) return
  while (nextEventTime < audioCtx.currentTime + lookAhead) {
    scheduleCycle(nextEventTime)
    nextEventTime += cycleDur.value
  }
  timerId = window.setTimeout(scheduler, scheduleInterval)
}

function start() {
  if (isPlaying.value) return
  audioCtx = getAudioContext()
  if (audioCtx.state === 'suspended') audioCtx.resume()

  masterGain = audioCtx.createGain()
  masterGain.gain.setValueAtTime(0, audioCtx.currentTime)
  masterGain.gain.linearRampToValueAtTime(1.0, audioCtx.currentTime + 0.05)
  masterGain.connect(audioCtx.destination)

  // Tone path
  toneOsc = audioCtx.createOscillator()
  toneOsc.type = 'sine'
  toneOsc.frequency.value = toneFreq.value
  
  toneGain = audioCtx.createGain()
  toneGain.gain.setValueAtTime(0, audioCtx.currentTime)

  toneOsc.connect(toneGain)
  toneGain.connect(masterGain)
  toneOsc.start()

  // Noise path
  if (!noiseBuffer) {
    noiseBuffer = createWhiteNoiseBuffer(audioCtx)
  }
  noiseSource = audioCtx.createBufferSource()
  noiseSource.buffer = noiseBuffer
  noiseSource.loop = true

  // Bandpass filter centered around the tone frequency to concentrate the masking power
  noiseFilter = audioCtx.createBiquadFilter()
  noiseFilter.type = 'bandpass'
  noiseFilter.frequency.value = toneFreq.value
  noiseFilter.Q.value = 1.5 // Moderately wide band

  noiseGain = audioCtx.createGain()
  noiseGain.gain.setValueAtTime(0, audioCtx.currentTime)

  noiseSource.connect(noiseFilter)
  noiseFilter.connect(noiseGain)
  noiseGain.connect(masterGain)
  noiseSource.start()

  isPlaying.value = true
  nextEventTime = audioCtx.currentTime
  scheduler()
  updatePlayhead()
}

function stop() {
  isPlaying.value = false
  if (timerId) clearTimeout(timerId)
  if (animationId) cancelAnimationFrame(animationId)
  
  const ctx = audioCtx
  const mGain = masterGain
  
  if (mGain && ctx) {
    mGain.gain.cancelScheduledValues(ctx.currentTime)
    mGain.gain.setTargetAtTime(0, ctx.currentTime, 0.02)
    
    setTimeout(() => {
      try {
        toneOsc?.stop()
        noiseSource?.stop()
      } catch (e) {}
      
      toneOsc?.disconnect()
      toneGain?.disconnect()
      noiseSource?.disconnect()
      noiseFilter?.disconnect()
      noiseGain?.disconnect()
      mGain.disconnect()
      
      toneOsc = null
      toneGain = null
      noiseSource = null
      noiseFilter = null
      noiseGain = null
      masterGain = null
    }, 100)
  }
  currentTime.value = 0
}

watch(toneFreq, (newVal) => {
  if (toneOsc && noiseFilter && audioCtx) {
    toneOsc.frequency.setTargetAtTime(newVal, audioCtx.currentTime, 0.05)
    noiseFilter.frequency.setTargetAtTime(newVal, audioCtx.currentTime, 0.05)
  }
})

onUnmounted(() => {
  stop()
})

// Visual drawing dimensions
const svgWidth = 400

const playheadX = computed(() => {
  return (currentTime.value / cycleDur.value) * svgWidth
})

const toneRects = computed(() => {
  const rects = []
  const wTone = (toneDuration.value / cycleDur.value) * svgWidth
  const wGap = (gapDuration.value / cycleDur.value) * svgWidth
  
  // Display two cycles in the visualizer for context
  for (let i = 0; i < 2; i++) {
    const xStart = i * (svgWidth / 2)
    const scale = 0.5 // Scale to fit two cycles in svgWidth
    
    rects.push({
      x: xStart,
      width: wTone * scale,
      y: 15,
      height: 35,
      class: 'tone-block'
    })
    
    // If gaps are disabled, the tone block fills the gap
    if (!gapsEnabled.value) {
      rects.push({
        x: xStart + wTone * scale,
        width: wGap * scale,
        y: 15,
        height: 35,
        class: 'tone-block fill'
      })
    }
  }
  return rects
})

const noiseRects = computed(() => {
  const rects = []
  const wTone = (toneDuration.value / cycleDur.value) * svgWidth
  const wGap = (gapDuration.value / cycleDur.value) * svgWidth
  
  if (noiseMuted.value || noiseLevel.value === 0) return []
  
  for (let i = 0; i < 2; i++) {
    const xStart = i * (svgWidth / 2)
    const scale = 0.5
    
    rects.push({
      x: xStart + wTone * scale,
      width: wGap * scale,
      y: 15,
      height: 35,
      class: 'noise-block'
    })
  }
  return rects
})

const isContinuityIllusionActive = computed(() => {
  // Threshold where the illusion works: Noise is loud enough (e.g. > 0.35) and gaps are enabled
  return gapsEnabled.value && noiseLevel.value >= 0.45 && !noiseMuted.value
})
</script>

<template>
  <div class="controls">
    <div class="visualizer-container">
      <div class="diagram-label">Physical Stimulus (Sound hitting eardrums)</div>
      <div class="diagram picket-diagram">
        <svg :width="svgWidth" height="60" :viewBox="`0 0 ${svgWidth} 60`">
          <!-- Background grids / channels -->
          <rect x="0" y="15" :width="svgWidth" height="35" fill="#111" rx="4" />
          
          <!-- Tone blocks -->
          <rect v-for="(r, idx) in toneRects" :key="'t-'+idx"
            :x="r.x" :y="r.y" :width="r.width" :height="r.height"
            fill="#646cff" opacity="0.8" rx="2"
          />
          
          <!-- Noise blocks -->
          <rect v-for="(r, idx) in noiseRects" :key="'n-'+idx"
            :x="r.x" :y="r.y" :width="r.width" :height="r.height"
            fill="#d14d4d" :opacity="0.1 + noiseLevel * 0.7" rx="2"
          />
          
          <!-- Playhead -->
          <line v-if="isPlaying"
            :x1="playheadX" y1="0" :x2="playheadX" y2="60"
            stroke="#ffffff" stroke-width="2"
          />
        </svg>
      </div>

      <div class="diagram-label">Perceptual Experience (What the brain reconstructs)</div>
      <div class="diagram picket-diagram">
        <svg :width="svgWidth" height="60" :viewBox="`0 0 ${svgWidth} 60`">
          <rect x="0" y="15" :width="svgWidth" height="35" fill="#111" rx="4" />
          
          <!-- If the illusion is active, the brain hears a SINGLE continuous tone -->
          <template v-if="isContinuityIllusionActive">
            <!-- Continuous Tone Bar -->
            <rect x="0" y="27" :width="svgWidth" height="12" fill="#646cff" opacity="0.9" rx="2" />
            <!-- Overlapping Noise bursts -->
            <rect v-for="(r, idx) in noiseRects" :key="'pn-'+idx"
              :x="r.x" :y="r.y" :width="r.width" :height="r.height"
              fill="#d14d4d" :opacity="0.1 + noiseLevel * 0.7" rx="2"
            />
          </template>
          
          <!-- Otherwise, the brain hears the physical reality (chopped up tone) -->
          <template v-else>
            <rect v-for="(r, idx) in toneRects" :key="'pt-'+idx"
              :x="r.x" :y="r.y" :width="r.width" :height="r.height"
              fill="#646cff" opacity="0.8" rx="2"
            />
            <rect v-for="(r, idx) in noiseRects" :key="'pn2-'+idx"
              :x="r.x" :y="r.y" :width="r.width" :height="r.height"
              fill="#d14d4d" :opacity="0.1 + noiseLevel * 0.7" rx="2"
            />
          </template>

          <!-- Playhead -->
          <line v-if="isPlaying"
            :x1="playheadX" y1="0" :x2="playheadX" y2="60"
            stroke="#ffffff" stroke-width="2"
          />
        </svg>
      </div>
    </div>

    <div class="button-group">
      <button v-if="!isPlaying" class="primary" @click="start">Start Demo</button>
      <button v-else @click="stop" class="stop">Stop Demo</button>
      
      <button :class="{ active: !gapsEnabled }" @click="gapsEnabled = !gapsEnabled">
        {{ gapsEnabled ? 'Make Tone Continuous (Reference)' : 'Restore Physical Gaps' }}
      </button>
    </div>

    <div class="parameter">
      <div class="param-header">
        <label>Noise Level (Masker): {{ (noiseLevel * 100).toFixed(0) }}%</label>
        <button class="small mute-btn" :class="{ 'stop': noiseMuted }" @click="noiseMuted = !noiseMuted">
          {{ noiseMuted ? 'Unmute Noise' : 'Mute Noise (Reveal Gaps)' }}
        </button>
      </div>
      <input type="range" v-model.number="noiseLevel" min="0.0" max="1.0" step="0.01">
      
      <p class="hint" :class="{ highlight: isContinuityIllusionActive }">
        <span v-if="noiseMuted || noiseLevel === 0">
          <strong>No Noise:</strong> The gaps are fully audible. You hear a pulsing, chopped-up tone.
        </span>
        <span v-else-if="noiseLevel < 0.45">
          <strong>Low Noise:</strong> The noise is audible, but too quiet. The brain can still tell the tone is turning off.
        </span>
        <span v-else-if="isContinuityIllusionActive">
          <strong>Illusion Active:</strong> The noise is loud enough to mask the gaps. The brain assumes the tone is continuous and running <em>behind</em> the noise. Press "Mute Noise" to verify it is actually silent!
        </span>
      </p>
    </div>

    <div class="grid">
      <div class="parameter">
        <label>Tone Pitch (Frequency): {{ toneFreq }} Hz</label>
        <input type="range" v-model.number="toneFreq" min="400" max="2000" step="10">
      </div>
      <div class="parameter">
        <label>Tone Duration: {{ (toneDuration * 1000).toFixed(0) }} ms</label>
        <input type="range" v-model.number="toneDuration" min="0.05" max="0.5" step="0.01">
      </div>
      <div class="parameter">
        <label>Gap Duration: {{ (gapDuration * 1000).toFixed(0) }} ms</label>
        <input type="range" v-model.number="gapDuration" min="0.02" max="0.2" step="0.01">
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

.picket-diagram {
  background-color: #111;
  padding: 0.5rem;
  margin-bottom: 1.2rem;
  border-radius: 6px;
  border: 1px solid #333;
}

.param-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.param-header label {
  margin-bottom: 0;
}

button.small {
  padding: 0.3rem 0.6rem;
  font-size: 0.75rem;
  border-radius: 4px;
}

.mute-btn {
  background-color: #333;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.tone-block {
  fill: #646cff;
}

.tone-block.fill {
  fill: #5058df;
  opacity: 0.5;
}

.noise-block {
  fill: #d14d4d;
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
  .picket-diagram {
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
}
</style>
