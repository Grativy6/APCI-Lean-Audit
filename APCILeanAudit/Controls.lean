import APCILeanAudit.Interface
import APCILeanAudit.FiniteCapacity

namespace APCILeanAudit

namespace EmptyBoundaryControl

def emptyTrace : Empty → Unit := fun x => Empty.elim x

def emptyAnswer : Empty → Empty := fun x => x

theorem fiberConstant_is_vacuous : FiberConstant emptyTrace emptyAnswer := by
  intro x
  exact Empty.elim x

theorem total_decoder_does_not_exist :
    ¬ ExactCertificate emptyTrace emptyAnswer := by
  rintro ⟨decode, _⟩
  exact Empty.elim (decode ())

end EmptyBoundaryControl

namespace ConcreteCapacityControl

def twoToOne : Fin 2 → Fin 1 := fun _ => 0

theorem twoToOne_collision : twoToOne 0 = twoToOne 1 := rfl

theorem twoToOne_no_leftInverse :
    ¬ ∃ decode : Fin 1 → Fin 2, Function.LeftInverse decode twoToOne := by
  exact no_exact_decoder_one_more twoToOne

end ConcreteCapacityControl

end APCILeanAudit
