; Tests that we name unnamed global addresses.

; Check that the ICE converter handles renaming correctly.
; RUN: %l2i --no-local-syms -i %s --insts | FileCheck %s

; RUN: %l2i --no-local-syms -i %s --insts --args --exit-success \
; RUN:      -default-function-prefix=h -default-global-prefix=g \
; RUN:      | FileCheck --check-prefix=BAD %s

; Check that Subzero's bitcode reader handles renaming correctly.
; RUN: %p2i --no-local-syms -i %s --insts | FileCheck %s

; RUN: %p2i --no-local-syms -i %s --insts --args --exit-success \
; RUN:      -default-function-prefix=h -default-global-prefix=g \
; RUN:      | FileCheck --check-prefix=BAD %s

; TODO(kschimpf) Check global variable declarations, once generated.

@0 = internal global [4 x i8] zeroinitializer, align 4
@1 = internal constant [10 x i8] c"Some stuff", align 1
@g = internal global [4 x i8] zeroinitializer, align 4

define i32 @2(i32 %v) {
  ret i32 %v
}

; CHECK:      define i32 @Function(i32 %__0) {
; CHECK-NEXT: __0:
; CHECK-NEXT:   ret i32 %__0
; CHECK-NEXT: }

define void @hg() {
  ret void
}


; CHECK-NEXT: define void @hg() {
; CHECK-NEXT: __0:
; CHECK-NEXT:   ret void
; CHECK-NEXT: }

define void @3() {
  ret void
}

; CHECK-NEXT: define void @Function1() {
; CHECK-NEXT: __0:
; CHECK-NEXT:   ret void
; CHECK-NEXT: }

define void @h5() {
  ret void
}

; CHECK-NEXT: define void @h5() {
; CHECK-NEXT: __0:
; CHECK-NEXT:   ret void
; CHECK-NEXT: }

; BAD: Warning : Default global prefix 'g' potentially conflicts with name 'g'.
; BAD: Warning : Default function prefix 'h' potentially conflicts with name 'h5'.
