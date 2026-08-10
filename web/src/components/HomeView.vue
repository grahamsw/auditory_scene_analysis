<script setup lang="ts">
</script>

<template>
  <div class="overview">
    <h2>Project Overview</h2>
    <p class="subhead">Perceptual Hypotheses and the Construction of Sound</p>
    
    <div class="content-text">
      <section class="intro-section">
        <p> 
          We do not hear sound waves. We hear <em>sources</em>: cars, voices, footsteps, a door slamming, wind in the trees.
        </p>
        <p>
          Yet, what actually arrives at our eardrums is ultimately reduced to a <strong>single fluctuating value</strong> over time—a one-dimensional function of air pressure. (Two-dimensional since we have two ears, but the principle holds.) Whether one complex object is making a noisy racket, or two simple objects are playing in harmony, or 3,000 leaves are rustling in the wind, the physical signal at the eardrum is just the sum of all those sound pressures.
        </p>
        <p class="quote-box">
          "It is like being given the number <strong>837</strong> and asked: <em>what numbers were added to get this?</em>" <br>
          <span class="author">— Albert S. Bregman, <em>Auditory Scene Analysis</em></span>
        </p>
        <p>
          Mathematically, this inverse problem is impossible to solve without making a set of strong assumptions. The auditory system solves it by using constraints built into our neural wiring—either hardcoded by ancestor survival bias or learned through lifelong immersion in a physical world.
        </p>
      </section>

      <section class="assumptions-section">
        <h3>The Rules of the Auditory Parser</h3>
        <p>
          To separate the 1D pressure wave into distinct "auditory objects," the brain operates on a set of ecological assumptions about how physical things make sound in the natural world:
        </p>
        <ul class="assumptions-list">
          <li>
            <strong>Common Onset & Offset (Temporal Synchrony):</strong>
            Components that start or stop at the same millisecond probably come from the same physical impact.
          </li>
          <li>
            <strong>Harmonic Coherence (Harmonicity):</strong>
            Vibrating systems (strings, vocal tracts) naturally produce overtones at integer multiples ($f, 2f, 3f...$). If a set of frequencies is harmonically related, the brain fuses them into a single complex pitch rather than hearing individual sine tones.
          </li>
          <li>
            <strong>Common Amplitude Modulation (Common Fate):</strong>
            Overtones belonging to the same object grow louder and decay together.
          </li>
          <li>
            <strong>Common Frequency Modulation (Co-modulation):</strong>
            If components fluctuate in pitch together (such as sharing the same vibrato or micro-jitter of a human voice), they are grouped.
          </li>
          <li>
            <strong>Good Continuation (Spectral & Temporal Continuity):</strong>
            Physical objects do not vanish and reappear. If a sound is briefly interrupted, the brain assumes it continued behind any louder sound (like a noise burst) that masked the gap.
          </li>
          <li>
            <strong>Pitch & Timbre Proximity:</strong>
            Sounds that are close in pitch or share a similar spectral texture over time are grouped sequentially into a single continuous melody or stream.
          </li>
          <li>
            <strong>Exclusive Allocation:</strong>
            A single piece of acoustic energy is usually assigned to only one object. If a component is "captured" by a sequential pattern, it cannot be used to fuse with other simultaneous components.
          </li>
        </ul>
      </section>

      <section class="disturbing-section">
        <h3>Violating the Physics of Sound</h3>
        <p>
          Natural acoustic objects cannot violate the laws of physics. A physical string cannot vibrate out-of-tune with its own sub-harmonics; a voice cannot speak with its 3rd partial starting 40 milliseconds late; a tone cannot go silent precisely when a noise burst triggers unless an external coordinator is switching them.
        </p>
        <p>
          By using digital synthesis, we can deliberately violate these assumptions. When we do, we confront the auditory system with a contradiction: the signal looks like one object, but behaves like multiple, physically impossible objects.
        </p>
        <p>
          The effect of these violations is often <strong>uncanny and other-worldly</strong>. It bypasses our conscious intellect and exposes the raw, automated machinery of perception. You don't just notice the difference; you hear a ghostly "whistle" hovering inside a hum, or experience a stuttering sound that magically repairs itself. 
        </p>
      </section>

      <section class="threshold-section">
        <h3>Interactive Thresholds</h3>
        <p>
          The demonstrations on this site focus on <strong>threshold effects</strong>:
        </p>
        <div class="threshold-grid">
          <div class="threshold-card">
            <h4>Apparent Continuity</h4>
            <p>Control the volume of noise bursts to find the exact threshold where your brain stops hearing a broken, stuttering tone and starts hearing a single, continuous tone running behind the noise.</p>
          </div>
          <div class="threshold-card">
            <h4>Hysteresis & Memory</h4>
            <p>Trigger a dynamic frequency sweep to hear a harmonic drift out of tune, pop out as a whistle, and return. Experience how the brain continues to track it as a separate whistle for a few seconds even after it has returned to tune.</p>
          </div>
          <div class="threshold-card">
            <h4>Temporal Synchrony</h4>
            <p>Adjust the delay of a single harmonic's onset. Witness how a delay of only 30ms breaks fusion, splitting a single musical tone into two distinct events.</p>
          </div>
        </div>
      </section>

      <div class="external-links">
        <a href="https://web.archive.org/web/20210211053155/http://webpages.mcgill.ca/staff/Group2/abregm1/web/" target="_blank" class="link-button">
          Visit Bregman's Auditory Scene Analysis Archive
        </a>
      </div>
    </div>
  </div>
</template>

<style scoped>
.overview {
  max-width: 850px;
  margin: 0 auto;
}

.subhead {
  font-size: 1.3rem;
  color: #646cff;
  margin-top: -1rem;
  margin-bottom: 2.5rem;
  font-weight: 500;
}

.content-text section {
  margin-bottom: 3rem;
}

.content-text h3 {
  font-size: 1.4rem;
  color: #fff;
  border-left: 4px solid #646cff;
  padding-left: 0.8rem;
  margin-bottom: 1.2rem;
}

.content-text p {
  margin-bottom: 1.5rem;
  line-height: 1.7;
  font-size: 1.1rem;
  color: #ccc;
}

.quote-box {
  background-color: #1a1a1a;
  border-radius: 8px;
  padding: 1.5rem;
  margin: 2rem 0;
  border-left: 4px solid #888;
  font-style: italic;
  font-size: 1.15rem !important;
}

.quote-box .author {
  display: block;
  margin-top: 0.5rem;
  font-size: 0.95rem;
  font-style: normal;
  color: #888;
}

.assumptions-list {
  padding-left: 1.5rem;
  margin-bottom: 2rem;
}

.assumptions-list li {
  margin-bottom: 1rem;
  line-height: 1.6;
  font-size: 1.05rem;
  color: #ccc;
}

.assumptions-list strong {
  color: #fff;
}

.threshold-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.threshold-card {
  background-color: #1a1a1a;
  border: 1px solid #333;
  padding: 1.2rem;
  border-radius: 8px;
  transition: transform 0.2s, border-color 0.2s;
}

.threshold-card:hover {
  transform: translateY(-2px);
  border-color: #646cff;
}

.threshold-card h4 {
  margin-top: 0;
  margin-bottom: 0.6rem;
  color: #646cff;
  font-size: 1.1rem;
}

.threshold-card p {
  font-size: 0.95rem;
  color: #aaa;
  margin-bottom: 0;
  line-height: 1.5;
}

.external-links {
  margin-top: 4rem;
  text-align: center;
}

.link-button {
  display: inline-block;
  background-color: #646cff;
  color: white;
  padding: 0.9rem 1.8rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  font-size: 1.05rem;
  transition: background-color 0.2s, transform 0.2s;
}

.link-button:hover {
  background-color: #747bff;
  transform: translateY(-1px);
}

@media (prefers-color-scheme: light) {
  .subhead {
    color: #4b53ff;
  }
  .content-text h3 {
    color: #213547;
    border-left-color: #4b53ff;
  }
  .content-text p, .assumptions-list li {
    color: #444;
  }
  .assumptions-list strong {
    color: #111;
  }
  .quote-box {
    background-color: #f5f5f5;
    color: #333;
  }
  .threshold-card {
    background-color: #f9f9f9;
    border-color: #ddd;
  }
  .threshold-card h4 {
    color: #4b53ff;
  }
  .threshold-card p {
    color: #666;
  }
}
</style>
