import APCILeanAudit.Interface

namespace APCILeanAudit

/-- Remove one designated value from a finite type, on the domain excluding it. -/
private def eraseAt {n : Nat} (pivot x : Fin (n + 1)) (h : x ≠ pivot) :
    Fin n :=
  ⟨if x.val < pivot.val then x.val else x.val - 1, by
    have hp := pivot.isLt
    have hx := x.isLt
    have hval : x.val ≠ pivot.val := by
      intro heq
      apply h
      exact Fin.ext heq
    split <;> omega⟩

private theorem eraseAt_injective {n : Nat} (pivot : Fin (n + 1))
    {x y : Fin (n + 1)} (hx : x ≠ pivot) (hy : y ≠ pivot)
    (h : eraseAt pivot x hx = eraseAt pivot y hy) : x = y := by
  apply Fin.ext
  have hp := pivot.isLt
  have hxl := x.isLt
  have hyl := y.isLt
  have hxval : x.val ≠ pivot.val := by
    intro heq
    apply hx
    exact Fin.ext heq
  have hyval : y.val ≠ pivot.val := by
    intro heq
    apply hy
    exact Fin.ext heq
  have hval := congrArg (fun z => z.val) h
  simp only [eraseAt] at hval
  split at hval <;> split at hval <;> omega

/-- Finite pigeonhole in the exact one-more-than-capacity form. -/
theorem fin_succ_not_injective :
    ∀ n : Nat, ∀ encode : Fin (n + 1) → Fin n,
      ¬ Function.Injective encode
  | 0, encode => by
      intro _
      exact Fin.elim0 (encode 0)
  | n + 1, encode => by
      intro hinjective
      let pivot : Fin (n + 1) := encode (Fin.last (n + 1))
      let smaller : Fin (n + 1) → Fin n := fun x =>
        eraseAt pivot (encode x.castSucc) (by
          intro heq
          have hdomain : x.castSucc = Fin.last (n + 1) := by
            apply hinjective
            exact heq
          exact (Fin.ne_of_lt (Fin.castSucc_lt_last x)) hdomain)
      have hsmaller : Function.Injective smaller := by
        intro x y hxy
        dsimp only [smaller] at hxy
        have hencoded : encode x.castSucc = encode y.castSucc := by
          apply eraseAt_injective pivot
          exact hxy
        exact Fin.castSucc_inj.mp (hinjective hencoded)
      exact fin_succ_not_injective n smaller hsmaller

theorem fin_succ_has_collision (n : Nat)
    (encode : Fin (n + 1) → Fin n) :
    ∃ x y, x ≠ y ∧ encode x = encode y := by
  classical
  by_contra hcollision
  apply fin_succ_not_injective n encode
  intro x y hxy
  by_contra hne
  exact hcollision ⟨x, y, hne, hxy⟩

/-- No decoder can recover all `n+1` inputs from only `n` trace values. -/
theorem no_exact_decoder_one_more (n : Nat)
    (encode : Fin (n + 1) → Fin n) :
    ¬ ∃ decode : Fin n → Fin (n + 1), Function.LeftInverse decode encode := by
  rintro ⟨decode, hdecode⟩
  exact fin_succ_not_injective n encode
    (leftInverse_implies_injective hdecode)

end APCILeanAudit
