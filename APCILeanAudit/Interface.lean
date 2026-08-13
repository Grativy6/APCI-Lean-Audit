import Std

namespace APCILeanAudit

universe uWorld uTrace uAnswer uObservation

/-- The requested answer cannot distinguish worlds that have the same trace. -/
def FiberConstant {World : Type uWorld} {Trace : Type uTrace}
    {Answer : Type uAnswer} (trace : World → Trace)
    (answer : World → Answer) : Prop :=
  ∀ ⦃x y⦄, trace x = trace y → answer x = answer y

/-- A decoder defined on every value of the declared trace type. -/
def ExactCertificate {World : Type uWorld} {Trace : Type uTrace}
    {Answer : Type uAnswer} (trace : World → Trace)
    (answer : World → Answer) : Prop :=
  ∃ decode : Trace → Answer, ∀ x, decode (trace x) = answer x

/-- The subtype of trace values that the interface can actually produce. -/
def Reachable {World : Type uWorld} {Trace : Type uTrace}
    (trace : World → Trace) : Type uTrace :=
  {t : Trace // ∃ x, trace x = t}

/-- A decoder defined only on traces that the interface can actually produce. -/
def ExactOnReachable {World : Type uWorld} {Trace : Type uTrace}
    {Answer : Type uAnswer} (trace : World → Trace)
    (answer : World → Answer) : Prop :=
  ∃ decode : Reachable trace → Answer,
    ∀ x, decode ⟨trace x, ⟨x, rfl⟩⟩ = answer x

variable {World : Type uWorld} {Trace : Type uTrace} {Answer : Type uAnswer}
variable {trace : World → Trace} {answer : World → Answer}

theorem exactCertificate_implies_fiberConstant
    (h : ExactCertificate trace answer) : FiberConstant trace answer := by
  rcases h with ⟨decode, hdecode⟩
  intro x y hxy
  calc
    answer x = decode (trace x) := (hdecode x).symm
    _ = decode (trace y) := congrArg decode hxy
    _ = answer y := hdecode y

theorem exactOnReachable_implies_fiberConstant
    (h : ExactOnReachable trace answer) : FiberConstant trace answer := by
  rcases h with ⟨decode, hdecode⟩
  intro x y hxy
  have hs :
      (⟨trace x, ⟨x, rfl⟩⟩ : Reachable trace) =
      ⟨trace y, ⟨y, rfl⟩⟩ := by
    apply Subtype.ext
    exact hxy
  calc
    answer x = decode ⟨trace x, ⟨x, rfl⟩⟩ := (hdecode x).symm
    _ = decode ⟨trace y, ⟨y, rfl⟩⟩ := congrArg decode hs
    _ = answer y := hdecode y

theorem fiberConstant_implies_exactOnReachable
    (h : FiberConstant trace answer) : ExactOnReachable trace answer := by
  classical
  let decode : Reachable trace → Answer :=
    fun t => answer (Classical.choose t.property)
  refine ⟨decode, ?_⟩
  intro x
  dsimp only [decode]
  apply h
  exact Classical.choose_spec
    (show ∃ y, trace y = trace x from ⟨x, rfl⟩)

theorem exactOnReachable_iff_fiberConstant :
    ExactOnReachable trace answer ↔ FiberConstant trace answer := by
  constructor
  · exact exactOnReachable_implies_fiberConstant
  · exact fiberConstant_implies_exactOnReachable

/-- Exact total characterization, including empty-type boundary cases. -/
theorem exactCertificate_iff_fiberConstant_and_decoderSpaceNonempty :
    ExactCertificate trace answer ↔
      FiberConstant trace answer ∧ Nonempty (Trace → Answer) := by
  constructor
  · rintro ⟨decode, hdecode⟩
    exact ⟨exactCertificate_implies_fiberConstant ⟨decode, hdecode⟩,
      ⟨decode⟩⟩
  · rintro ⟨hfiber, ⟨fallback⟩⟩
    rcases fiberConstant_implies_exactOnReachable hfiber with
      ⟨decode, hdecode⟩
    classical
    refine ⟨fun t => if ht : ∃ x, trace x = t then
      decode (show Reachable trace from ⟨t, ht⟩) else fallback t, ?_⟩
    intro x
    have hx : ∃ y, trace y = trace x := ⟨x, rfl⟩
    simpa only [dif_pos hx] using hdecode x

/-- Convenient total-decoder corollary with a designated fallback answer. -/
theorem exactCertificate_iff_fiberConstant [Inhabited Answer] :
    ExactCertificate trace answer ↔ FiberConstant trace answer := by
  constructor
  · exact exactCertificate_implies_fiberConstant
  · intro hfiber
    apply (exactCertificate_iff_fiberConstant_and_decoderSpaceNonempty
      (trace := trace) (answer := answer)).2
    exact ⟨hfiber, ⟨fun _ => default⟩⟩

theorem leftInverse_implies_injective
    {Code : Type uTrace} {encode : World → Code} {decode : Code → World}
    (h : Function.LeftInverse decode encode) : Function.Injective encode :=
  h.injective

theorem collision_persists_under_postprocessing
    {Observation : Type uObservation} (post : Trace → Observation)
    {x y : World} (h : trace x = trace y) :
    post (trace x) = post (trace y) :=
  congrArg post h

end APCILeanAudit
