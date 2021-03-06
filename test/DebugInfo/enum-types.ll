; REQUIRES: object-emission
;
; RUN: %llc_dwarf -filetype=obj -O0 < %s | llvm-dwarfdump -debug-dump=info - | FileCheck %s

; Make sure we can handle enums with the same identifier but in enum types of
; different compile units.
; rdar://17628609

; CHECK: DW_TAG_compile_unit
; CHECK: 0x[[ENUM:.*]]: DW_TAG_enumeration_type
; CHECK-NEXT:   DW_AT_name {{.*}} "EA"
; CHECK: DW_TAG_subprogram
; CHECK: DW_AT_MIPS_linkage_name {{.*}} "_Z4topA2EA"
; CHECK: DW_TAG_formal_parameter
; CHECK: DW_AT_type [DW_FORM_ref4] (cu + 0x{{.*}} => {0x[[ENUM]]})

; CHECK: DW_TAG_compile_unit
; CHECK: DW_TAG_subprogram
; CHECK:   DW_AT_MIPS_linkage_name {{.*}} "_Z4topB2EA"
; CHECK: DW_TAG_formal_parameter
; CHECK: DW_AT_type [DW_FORM_ref_addr] {{.*}}[[ENUM]]

; Function Attrs: nounwind ssp uwtable
define void @_Z4topA2EA(i32 %sa) #0 {
entry:
  %sa.addr = alloca i32, align 4
  store i32 %sa, i32* %sa.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %sa.addr, metadata !22, metadata !MDExpression()), !dbg !23
  ret void, !dbg !24
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind ssp uwtable
define void @_Z4topB2EA(i32 %sa) #0 {
entry:
  %sa.addr = alloca i32, align 4
  store i32 %sa, i32* %sa.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %sa.addr, metadata !25, metadata !MDExpression()), !dbg !26
  ret void, !dbg !27
}

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0, !12}
!llvm.module.flags = !{!19, !20}
!llvm.ident = !{!21, !21}

!0 = !MDCompileUnit(language: DW_LANG_C_plus_plus, producer: "clang version 3.5.0 (trunk 214102:214133) (llvm/trunk 214102:214132)", isOptimized: false, emissionKind: 1, file: !1, enums: !2, retainedTypes: !2, subprograms: !6, globals: !11, imports: !11)
!1 = !MDFile(filename: "a.cpp", directory: "")
!2 = !{!3}
!3 = !MDCompositeType(tag: DW_TAG_enumeration_type, name: "EA", line: 1, size: 32, align: 32, file: !1, elements: !4, identifier: "_ZTS2EA")
!4 = !{!5}
!5 = !MDEnumerator(name: "EA_0", value: 0) ; [ DW_TAG_enumerator ] [EA_0 :: 0]
!6 = !{!7}
!7 = !MDSubprogram(name: "topA", linkageName: "_Z4topA2EA", line: 5, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 5, file: !1, scope: !8, type: !9, function: void (i32)* @_Z4topA2EA, variables: !11)
!8 = !MDFile(filename: "a.cpp", directory: "")
!9 = !MDSubroutineType(types: !10)
!10 = !{null, !"_ZTS2EA"}
!11 = !{}
!12 = !MDCompileUnit(language: DW_LANG_C_plus_plus, producer: "clang version 3.5.0 (trunk 214102:214133) (llvm/trunk 214102:214132)", isOptimized: false, emissionKind: 1, file: !13, enums: !14, retainedTypes: !14, subprograms: !16, globals: !11, imports: !11)
!13 = !MDFile(filename: "b.cpp", directory: "")
!14 = !{!15}
!15 = !MDCompositeType(tag: DW_TAG_enumeration_type, name: "EA", line: 1, size: 32, align: 32, file: !13, elements: !4, identifier: "_ZTS2EA")
!16 = !{!17}
!17 = !MDSubprogram(name: "topB", linkageName: "_Z4topB2EA", line: 5, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 5, file: !13, scope: !18, type: !9, function: void (i32)* @_Z4topB2EA, variables: !11)
!18 = !MDFile(filename: "b.cpp", directory: "")
!19 = !{i32 2, !"Dwarf Version", i32 2}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{!"clang version 3.5.0 (trunk 214102:214133) (llvm/trunk 214102:214132)"}
!22 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "sa", line: 5, arg: 1, scope: !7, file: !8, type: !"_ZTS2EA")
!23 = !MDLocation(line: 5, column: 14, scope: !7)
!24 = !MDLocation(line: 6, column: 1, scope: !7)
!25 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "sa", line: 5, arg: 1, scope: !17, file: !18, type: !"_ZTS2EA")
!26 = !MDLocation(line: 5, column: 14, scope: !17)
!27 = !MDLocation(line: 6, column: 1, scope: !17)
