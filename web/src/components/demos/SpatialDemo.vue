<script setup lang="ts">
import { ref, onUnmounted } from 'vue'
import { getAudioContext } from '../../audio'

const isPlaying = ref(false)
const mode = ref<'monaural' | 'dichotic'>('monaural')
const isDelayed = ref(false)
const tempo = ref(0.2)

let intervalId: number | null = null

function playNoiseBurst(pan: number, duration: number) {
  const ctx = getAudioContext()
  
  // Create noise buffer
  const bufferSize = ctx.sampleRate * duration
  const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate)
  const data = buffer.getChannelData(0)
  for (let i = 0; i < bufferSize; i++) {
    data[i] = Math.random() * 2 - 1
  }

  const source = ctx.createBufferSource()
  source.buffer = buffer

  const gain = ctx.createGain()
  const panner = ctx.createStereoPanner()
  
  panner.pan.setValueAtTime(pan, ctx.currentTime)

  gain.gain.setValueAtTime(0, ctx.currentTime)
  gain.gain.linearRampToValueAtTime(0.2, ctx.currentTime + 0.001)
  gain.gain.linearRampToValueAtTime(0, ctx.currentTime + duration)

  source.connect(gain)
  gain.connect(panner)
  panner.connect(ctx.destination)

  source.start()
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
    
    // ABA pattern
    const subStep = count % 3
    let pan = 0
    
    if (mode.value === 'dichotic') {
      pan = (subStep === 1) ? 1 : -1 // B is Right (1), A is Left (-1)
    }

    playNoiseBurst(pan, 0.04)
    
    count++
    
    let wait = tempo.value
    if (subStep === 0) { // After first A
      wait = isDelayed.value ? tempo.value * 1.3 : tempo.value
    } else if (subStep === 1) { // After B
      wait = isDelayed.value ? tempo.value * 0.7 : tempo.value
    } else { // After second A
      wait = tempo.value * 2 // Gap between triplets
    }

    intervalId = window.setTimeout(tick, wait * 1000)
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
    <div class="button-group">
      <button v-if="!isPlaying" class="primary" @click="start">Start Demo</button>
      <button v-else @click="stop">Stop Demo</button>
    </div>

    <div class="parameter">
      <label>Mode</label>
      <div class="button-group">
        <button :class="{ primary: mode === 'monaural' }" @click="mode = 'monaural'">Monaural (Centered)</button>
        <button :class="{ primary: mode === 'dichotic' }" @click="mode = 'dichotic'">Dichotic (Left/Right)</button>
      </div>
    </div>

    <div class="parameter">
      <label>B-Tone Timing</label>
      <div class="button-group">
        <button :class="{ primary: !isDelayed }" @click="isDelayed = false">Exactly Halfway</button>
        <button :class="{ primary: isDelayed }" @click="isDelayed = true">Slightly Delayed</button>
      </div>
      <p class="hint">In Dichotic mode, it is much harder to tell if the B tone is delayed.</p>
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
