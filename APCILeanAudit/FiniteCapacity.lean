import APCILeanAudit.Interface

namespace APCILeanAudit

/-- Remove one designated value from a finite type, on the domain excluding it. -/
private def eraseFin {n : Nat} (pivot x : Fin (n + 1))
    (hx : x ≠ pivot) : Fin n :=
  if hlt : x.val < pivot.val then
    ⟨x.val, by omega⟩
  else
    ⟨x.val - 1, by
      have hne : x.val ≠ pivot.val := by
        intro h
        exact hx (Fin.ext h)
      omega⟩

private theorem eraseFin_injective {n : Nat} (pivot : Fin (n + 1))
    {x z : Fin (n + 1)} (hx : x ≠ pivot) (hz : z ≠ pivot)
    (h : eraseFin pivot x hx = eraseFin pivot z hz) : x = z := by
  apply Fin.ext
  have hpivotx : x.val ≠ pivot.val := by
    intro hval
    exact hx (Fin.ext hval)
  have hpivotz : z.val ≠ pivot.val := by
    intro hval
    exact hz (Fin.ext hval)
  have hv := congrArg Fin.val h
  by_cases hxp : x.val < pivot.val <;>
    by_cases hzp : z.val < pivot.val <;>
      simp [eraseFin, hxp, hzp] at hv <;> omega

/-- Finite pigeonhole in the exact one-more-than-capacity form. -/
theorem fin_succ_not_injective :
    ∀ n : Nat, ∀ encode : Fin (n + 1) → Fin n,
      ¬ Function.Injective encode
  | 0, encode => by
      intro _
      exact (encode 0).elim0
  | n + 1, encode => by
      intro hinjective
      let top : Fin (n + 2) := Fin.last (n + 1)
      let pivot : Fin (n + 1) := encode top
      have hne (x : Fin (n + 1)) : encode x.castSucc ≠ pivot := by
        intro heq
        have hdomain : x.castSucc = top := hinjective heq
        exact (Fin.ne_of_lt (Fin.castSucc_lt_last x)) hdomain
      let smaller : Fin (n + 1) → Fin n :=
        fun x => eraseFin pivot (encode x.castSucc) (hne x)
      have hsmaller : Function.Injective smaller := by
        intro x z hxz
        apply Fin.castSucc_inj.mp
        apply hinjective
        apply eraseFin_injective pivot (hne x) (hne z)
        exact hxz
      exact fin_succ_not_injective n smaller hsmaller

theorem fin_succ_has_collision (n : Nat)
    (encode : Fin (n + 1) → Fin n) :
    ∃ x y, x ≠ y ∧ encode x = encode y := by
  classical
  apply Classical.byContradiction
  intro hcollision
  exact fin_succ_not_injective n encode (by
    intro x y hxy
    apply Classical.byContradiction
    intro hne
    exact hcollision ⟨x, y, hne, hxy⟩)

/-- No decoder can recover all `n+1` inputs from only `n` trace values. -/
theorem no_exact_decoder_one_more (n : Nat)
    (encode : Fin (n + 1) → Fin n) :
    ¬ ∃ decode : Fin n → Fin (n + 1), Function.LeftInverse decode encode := by
  rintro ⟨decode, hdecode⟩
  exact fin_succ_not_injective n encode
    (leftInverse_implies_injective hdecode)

end APCILeanAudit
