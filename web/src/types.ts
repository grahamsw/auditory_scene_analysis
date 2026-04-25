export interface Demo {
  id: string;
  title: string;
  description: string;
  instruction: string;
}

export interface HomophonicSettings {
  riseTime: number;
  fallTime: number;
  baseLevel: number;
  base1Dur: number;
  peakDur: number;
  base2Dur: number;
  cycleDur: number;
  filterFreq: number
  filterQ: number
  isSpatialSwapped: boolean
  isCurved: boolean
  }

declare global {
  interface Window {
    webkitAudioContext: typeof AudioContext;
  }
}
