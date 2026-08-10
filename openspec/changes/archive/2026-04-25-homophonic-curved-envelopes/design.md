## Context

The current Homophonic Continuity demo uses linear ramps (`linearRampToValueAtTime`) for both audio volume changes and SVG visualization. The user wants to introduce "accelerating" curves where the rate of change increases over the duration of the segment.

## Goals / Non-Goals

**Goals:**
- Implement "start slow, get faster" curves for Rise and Fall segments.
- Synchronize audio scheduling with SVG rendering for these curves.
- Provide a toggle to switch between Linear and Curved modes.

**Non-Goals:**
- Allowing user-defined curve exponents (hardcoded quadratic or exponential is sufficient).
- Real-time modulation of the curve shape (beyond the binary Linear/Curved toggle).

## Decisions

### Decision: Quadratic Curves for SVG and Audio
To achieve the "start slow, get faster" shape:
- **Rise**: $y = y_{start} + (y_{end} - y_{start}) \cdot (t/T)^2$. This has a zero slope at $t=0$ and max slope at $t=T$.
- **Fall**: $y = y_{start} - (y_{start} - y_{end}) \cdot (t/T)^2$. This also has a zero slope at $t=0$ (peak) and max slope at $t=T$ (base level).
- **Rationale**: Quadratic curves are easy to implement in SVG using Quadratic Bezier segments (`Q`). For Web Audio, `setValueCurveAtTime` can accurately reproduce this polynomial.
- **Alternatives**: `exponentialRampToValueAtTime` was considered, but it never reaches zero slope at the start (it's always proportional to the current value) and cannot handle a fall that "starts slow" in the way described (it starts steep and gets shallow).

### Decision: SVG Path Implementation
We will use the `Q` (Quadratic Bezier) command. 
- **Rise Path**: `M x1,y1 Q x1+(x2-x1),y1 x2,y2`? No, to get zero slope at the start, the control point must be at `(x2, y1)` (horizontal line from start) or `(x1, y1)`?
- To get a slope of 0 at $(x_1, y_1)$ and pass through $(x_2, y_2)$, the control point for a quadratic bezier should be at $(x_2, y_1)$.
- **Fall Path**: Similarly, to start horizontal at peak $(x_3, y_{peak})$ and end at $(x_4, y_{base})$, the control point should be at $(x_4, y_{peak})$.

### Decision: Audio Implementation with `setValueCurveAtTime`
- **Rationale**: `linearRampToValueAtTime` and `exponentialRampToValueAtTime` are fixed shapes. `setValueCurveAtTime` allows a pre-calculated array of values representing the quadratic curve.
- **Calculation**: A Float32Array of ~50-100 points per segment will be generated on the fly when scheduling.

## Risks / Trade-offs

- **[Risk] Complexity of SVG coordinate math** → Mitigation: Use clear helper variables for control points in the `envelopePath` computed property.
- **[Risk] Audio Click on segment transitions** → Mitigation: Ensure the `setValueCurve` ends exactly at the target value.
