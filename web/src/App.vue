<script setup lang="ts">
import { ref, computed } from 'vue'
import { type Demo } from './types'
import StreamingDemo from './components/demos/StreamingDemo.vue'
import SpatialDemo from './components/demos/SpatialDemo.vue'
import MistuningDemo from './components/demos/MistuningDemo.vue'
import HomophonicDemo from './components/demos/HomophonicDemo.vue'
import PicketFenceDemo from './components/demos/PicketFenceDemo.vue'
import AsynchronousOnsetDemo from './components/demos/AsynchronousOnsetDemo.vue'
import HomeView from './components/HomeView.vue'

const demos = ref<Demo[]>([
  {
    id: 'overview',
    title: 'Overview',
    description: 'An introduction to Auditory Scene Analysis and the principles of perceptual organization.',
    instruction: ''
  },
  {
    id: 'streaming',
    title: 'Stream Segregation',
    description: 'Demonstrates how speed affects whether we hear one alternating melody or two separate high and low melodies.',
    instruction: 'Adjust the speed to hear the sequence split into two separate streams.'
  },
  {
    id: 'mistuning',
    title: 'Harmonic Mistuning & Hysteresis',
    description: 'Shows how mistuning a single partial in a harmonic complex causes it to perceptually "pop out" as a separate tone. Features a hysteresis sweep demonstrating how the brain continues to track the separate whistle even after it returns to perfect tuning.',
    instruction: 'Adjust the mistuning slider or trigger the hysteresis sweep to experience the threshold and tracking effects.'
  },
  {
    id: 'picket_fence',
    title: 'Apparent Continuity (Picket Fence)',
    description: 'Demonstrates the "good continuation" principle. A pure tone with periodic gaps is heard as a stuttering, broken sound. Adding noise bursts in the gaps masks the transitions, causing the brain to assume the tone continues running underneath the noise.',
    instruction: 'Adjust the noise level to find the threshold where the tone transitions from chopped-up to perfectly continuous.'
  },
  {
    id: 'asynchronous_onset',
    title: 'Asynchronous Onset',
    description: 'Illustrates the role of temporal synchrony in object grouping. Delaying the onset of a single partial in a complex harmonic tone by as little as 30 milliseconds breaks fusion, causing it to pop out as a separate "ping" or "chirp" at the start of the note.',
    instruction: 'Adjust the onset delay to hear the target harmonic split off from the unified complex tone.'
  },
  {
    id: 'homophonic',
    title: 'Homophonic Continuity',
    description: 'Explores the "old-plus-new" heuristic. A gradual volume change sounds like one object getting louder, while an abrupt change sounds like a second object joining the first.',
    instruction: 'Toggle between a gradual rise (one object) and an abrupt one (two objects).'
  },
  {
    id: 'spatial',
    title: 'Spatial Segregation',
    description: 'Illustrates the difficulty of making timing judgments when sounds are separated in space.',
    instruction: 'Toggle between monaural (one ear) and dichotic (two ears) to experience the loss of timing information.'
  }
])

const activeDemoId = ref('overview')
const activeDemo = computed(() => demos.value.find(d => d.id === activeDemoId.value))

function selectDemo(id: string) {
  activeDemoId.value = id
}
</script>

<template>
  <aside class="sidebar">
    <h1>Auditory Scene Analysis</h1>
    <div 
      v-for="demo in demos" 
      :key="demo.id"
      :class="['demo-card', { active: activeDemoId === demo.id }]"
      @click="selectDemo(demo.id)"
    >
      <h3>{{ demo.title }}</h3>
    </div>
  </aside>

  <main class="content">
    <div v-if="activeDemoId === 'overview'">
      <HomeView />
    </div>
    <div v-else-if="activeDemo">
      <h2>{{ activeDemo.title }}</h2>
      <p class="demo-description">{{ activeDemo.description }}</p>
      
      <div class="demo-container">
        <StreamingDemo v-if="activeDemoId === 'streaming'" />
        <MistuningDemo v-if="activeDemoId === 'mistuning'" />
        <PicketFenceDemo v-if="activeDemoId === 'picket_fence'" />
        <AsynchronousOnsetDemo v-if="activeDemoId === 'asynchronous_onset'" />
        <HomophonicDemo v-if="activeDemoId === 'homophonic'" />
        <SpatialDemo v-if="activeDemoId === 'spatial'" />
      </div>
    </div>
  </main>
</template>

<style scoped>
.demo-description {
  color: #aaa;
  font-size: 1.05rem;
  line-height: 1.5;
  max-width: 800px;
}

.demo-container {
  margin-top: 2rem;
}

@media (prefers-color-scheme: light) {
  .demo-description {
    color: #555;
  }
}
</style>
