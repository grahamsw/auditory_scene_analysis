<script setup lang="ts">
import { ref, computed } from 'vue'
import { type Demo } from './types'
import StreamingDemo from './components/demos/StreamingDemo.vue'
import SpatialDemo from './components/demos/SpatialDemo.vue'
import MistuningDemo from './components/demos/MistuningDemo.vue'
import HomophonicDemo from './components/demos/HomophonicDemo.vue'
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
    title: 'Harmonic Mistuning',
    description: 'Shows how mistuning a single partial in a harmonic complex causes it to perceptually "pop out" as a separate tone.',
    instruction: 'Adjust the mistuning slider to hear the harmonic segregate from the complex.'
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
      <p>{{ activeDemo.description }}</p>
      
      <div class="demo-container">
        <StreamingDemo v-if="activeDemoId === 'streaming'" />
        <MistuningDemo v-if="activeDemoId === 'mistuning'" />
        <HomophonicDemo v-if="activeDemoId === 'homophonic'" />
        <SpatialDemo v-if="activeDemoId === 'spatial'" />
      </div>
    </div>
  </main>
</template>

<style scoped>
.demo-container {
  margin-top: 2rem;
}
</style>
