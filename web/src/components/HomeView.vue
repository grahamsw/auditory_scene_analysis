<script setup lang="ts">
</script>

<template>
  <div class="overview">
    <h2>Project Overview</h2>
    <p class="subhead">Exploring the Perceptual Organization of Sound</p>
    
    <div class="content-text">
      <p> 
        We don't hear soundwaves. 
      </p>

      <p>
        To be sure, sound hits our ears, gets processed in the cochlea and all, but what we hear isn't that. What we hear is the world around us: people, cars, doors slamming, birds singing. 
      </p>
      <p>
        The demos on this site are based on the work of Albert S. Bregman, that I first came across in <a href="https://global.oup.com/academic/product/thinking-in-sound-9780198522577">Thinking in Sound</a>.
        Bregman was interested in the cataloguing the types of assumptions that are built in to auditory analysis - that sounds that start together or change together tend to come from the same object.
      </p>

      <p>
        Two things struck me about his demos. 
        One was that there was usually a critical parameter - a speed, a pitch. Above a certain level it made the overall demo sound like one thing, and below sound like something else.
        I wanted to see what happened when you set the parameter at the threshold of the change. (My guess was, and is, that this could be disturbing.)
        The second was that in many of these demos were of a similar structure: A sound changes into a second sound in one of two ways. The final sound is identical. (The soundwaves hitting that cochlea are indistinguishable.) But depending on how you get there it sounds different.
      </p>

      <p>
          
      </p>
k
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
  max-width: 800px;
}

.subhead {
  font-size: 1.2rem;
  color: #646cff;
  margin-top: -1rem;
  margin-bottom: 2rem;
  font-weight: 500;
}

.content-text p {
  margin-bottom: 1.5rem;
  line-height: 1.6;
  font-size: 1.1rem;
}

.external-links {
  margin-top: 3rem;
}

.link-button {
  display: inline-block;
  background-color: #646cff;
  color: white;
  padding: 0.8rem 1.5rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  transition: background-color 0.2s;
}

.link-button:hover {
  background-color: #747bff;
}

@media (prefers-color-scheme: light) {
  .subhead {
    color: #4b53ff;
  }
}
</style>
