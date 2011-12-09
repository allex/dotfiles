
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Case insensitive
syntax case ignore

syntax match ilasmComment "\/\/.*"
syntax match ilasmLabel "^[\s\t]\+[a-zA-Z_][a-zA-Z0-9_]*:"
syntax match ilasmString /"[^"]*"/
syntax match ilasmNumber "[0-9]\+"

" The directives
" 
syntax match ilasmDirective "\.namespace"
syntax match ilasmDirective "\.method"
syntax match ilasmDirective "\.class"
syntax match ilasmDirective "\.field"
syntax match ilasmDirective "\.locals"
syntax match ilasmDirective "\.entrypoint"
syntax match ilasmDirective "\.module"
syntax match ilasmDirective "\.data"
syntax match ilasmDirective "\.size"
syntax match ilasmDirective "\.property"
syntax match ilasmDirective "\.get"
syntax match ilasmDirective "\.set"
syntax match ilasmDirective "\.other"
syntax match ilasmDirective "\.permission"
syntax match ilasmDirective "\.custom"
syntax match ilasmDirective "\.subsystem"
syntax match ilasmDirective "\.corflags"
syntax match ilasmDirective "\.file alignement"
syntax match ilasmDirective "\.imagebase"
syntax match ilasmDirective "\.line"
syntax match ilasmDirective "\.language"


" The types

syntax keyword ilasmType int8 uint8 int32 uint32 int64 float32 float64 string void int16 char bool bytearray nullref
 

" The keywords

syntax match ilasmKeyword "^[\s\t]*nop" 
syntax match ilasmKeyword "^[\s\t]*break" 
syntax match ilasmKeyword "^[\s\t]*ldarg.0" 
syntax match ilasmKeyword "^[\s\t]*ldarg.1" 
syntax match ilasmKeyword "^[\s\t]*ldarg.2" 
syntax match ilasmKeyword "^[\s\t]*ldarg.3"
syntax match ilasmKeyword "^[\s\t]*ldloc.0"
syntax match ilasmKeyword "^[\s\t]*ldloc.1"
syntax match ilasmKeyword "^[\s\t]*ldloc.2"
syntax match ilasmKeyword "^[\s\t]*ldloc.3"
syntax match ilasmKeyword "^[\s\t]*stloc.0"
syntax match ilasmKeyword "^[\s\t]*stloc.1"
syntax match ilasmKeyword "^[\s\t]*stloc.2"
syntax match ilasmKeyword "^[\s\t]*stloc.3"
syntax match ilasmKeyword "^[\s\t]*ldarg.s"
syntax match ilasmKeyword "^[\s\t]*ldarga.s"
syntax match ilasmKeyword "^[\s\t]*starg.s"
syntax match ilasmKeyword "^[\s\t]*ldloc.s"
syntax match ilasmKeyword "^[\s\t]*ldloca.s"
syntax match ilasmKeyword "^[\s\t]*stloc.s"
syntax match ilasmKeyword "^[\s\t]*ldnull"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.m1ldc.i4.M1"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.0"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.1"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.2"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.3"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.4"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.5"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.6"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.7"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.8"
syntax match ilasmKeyword "^[\s\t]*ldc.i4.s"
syntax match ilasmKeyword "^[\s\t]*ldc.i4"
syntax match ilasmKeyword "^[\s\t]*ldc.i8"
syntax match ilasmKeyword "^[\s\t]*ldc.r4"
syntax match ilasmKeyword "^[\s\t]*ldc.r8"
syntax match ilasmKeyword "^[\s\t]*dup"
syntax match ilasmKeyword "^[\s\t]*pop"
syntax match ilasmKeyword "^[\s\t]*jmp"
syntax match ilasmKeyword "^[\s\t]*call"
syntax match ilasmKeyword "^[\s\t]*calli"
syntax match ilasmKeyword "^[\s\t]*ret"
syntax match ilasmKeyword "^[\s\t]*br.s"
syntax match ilasmKeyword "^[\s\t]*brfalse.s"
syntax match ilasmKeyword "^[\s\t]*brnull.s"
syntax match ilasmKeyword "^[\s\t]*brzero.s"
syntax match ilasmKeyword "^[\s\t]*brtrue.s"
syntax match ilasmKeyword "^[\s\t]*brinst.s"
syntax match ilasmKeyword "^[\s\t]*beq.s"
syntax match ilasmKeyword "^[\s\t]*bge.s"
syntax match ilasmKeyword "^[\s\t]*bgt.s"
syntax match ilasmKeyword "^[\s\t]*ble.s"
syntax match ilasmKeyword "^[\s\t]*blt.s"
syntax match ilasmKeyword "^[\s\t]*bne.un.s"
syntax match ilasmKeyword "^[\s\t]*bge.un.s"
syntax match ilasmKeyword "^[\s\t]*bgt.un.s"
syntax match ilasmKeyword "^[\s\t]*ble.un.s"
syntax match ilasmKeyword "^[\s\t]*blt.un.s"
syntax match ilasmKeyword "^[\s\t]*br"
syntax match ilasmKeyword "^[\s\t]*brfalse"
syntax match ilasmKeyword "^[\s\t]*brnull"
syntax match ilasmKeyword "^[\s\t]*brzero"
syntax match ilasmKeyword "^[\s\t]*brtrue"
syntax match ilasmKeyword "^[\s\t]*brinst"
syntax match ilasmKeyword "^[\s\t]*beq"
syntax match ilasmKeyword "^[\s\t]*bge"
syntax match ilasmKeyword "^[\s\t]*bgt"
syntax match ilasmKeyword "^[\s\t]*ble"
syntax match ilasmKeyword "^[\s\t]*blt"
syntax match ilasmKeyword "^[\s\t]*bne.un"
syntax match ilasmKeyword "^[\s\t]*bge.un"
syntax match ilasmKeyword "^[\s\t]*bgt.un"
syntax match ilasmKeyword "^[\s\t]*ble.un"
syntax match ilasmKeyword "^[\s\t]*blt.un"
syntax match ilasmKeyword "^[\s\t]*switch"
syntax match ilasmKeyword "^[\s\t]*ldind.i1"
syntax match ilasmKeyword "^[\s\t]*ldind.u1"
syntax match ilasmKeyword "^[\s\t]*ldind.i2"
syntax match ilasmKeyword "^[\s\t]*ldind.u2"
syntax match ilasmKeyword "^[\s\t]*ldind.i4"
syntax match ilasmKeyword "^[\s\t]*ldind.u4"
syntax match ilasmKeyword "^[\s\t]*ldind.i8ldind.u8"
syntax match ilasmKeyword "^[\s\t]*ldind.i"
syntax match ilasmKeyword "^[\s\t]*ldind.r4"
syntax match ilasmKeyword "^[\s\t]*ldind.r8"
syntax match ilasmKeyword "^[\s\t]*ldind.ref"
syntax match ilasmKeyword "^[\s\t]*stind.ref"
syntax match ilasmKeyword "^[\s\t]*stind.i1"
syntax match ilasmKeyword "^[\s\t]*stind.i2"
syntax match ilasmKeyword "^[\s\t]*stind.i4"
syntax match ilasmKeyword "^[\s\t]*stind.i8"
syntax match ilasmKeyword "^[\s\t]*stind.r4"
syntax match ilasmKeyword "^[\s\t]*stind.r8"
syntax match ilasmKeyword "^[\s\t]*add"
syntax match ilasmKeyword "^[\s\t]*sub"
syntax match ilasmKeyword "^[\s\t]*mul"
syntax match ilasmKeyword "^[\s\t]*div"
syntax match ilasmKeyword "^[\s\t]*div.un"
syntax match ilasmKeyword "^[\s\t]*rem"
syntax match ilasmKeyword "^[\s\t]*rem.un"
syntax match ilasmKeyword "^[\s\t]*and"
syntax match ilasmKeyword "^[\s\t]*or"
syntax match ilasmKeyword "^[\s\t]*xor"
syntax match ilasmKeyword "^[\s\t]*shl"
syntax match ilasmKeyword "^[\s\t]*shr"
syntax match ilasmKeyword "^[\s\t]*shr.un"
syntax match ilasmKeyword "^[\s\t]*neg"
syntax match ilasmKeyword "^[\s\t]*not"
syntax match ilasmKeyword "^[\s\t]*conv.i1"
syntax match ilasmKeyword "^[\s\t]*conv.i2"
syntax match ilasmKeyword "^[\s\t]*conv.i4"
syntax match ilasmKeyword "^[\s\t]*conv.i8"
syntax match ilasmKeyword "^[\s\t]*conv.r4"
syntax match ilasmKeyword "^[\s\t]*conv.r8"
syntax match ilasmKeyword "^[\s\t]*conv.u4"
syntax match ilasmKeyword "^[\s\t]*conv.u8"
syntax match ilasmKeyword "^[\s\t]*callvirt"
syntax match ilasmKeyword "^[\s\t]*cpobj"
syntax match ilasmKeyword "^[\s\t]*ldstr"
syntax match ilasmKeyword "^[\s\t]*newobj"
syntax match ilasmKeyword "^[\s\t]*castclass"
syntax match ilasmKeyword "^[\s\t]*isinst"
syntax match ilasmKeyword "^[\s\t]*conv.r.un"
syntax match ilasmKeyword "^[\s\t]*unbox"
syntax match ilasmKeyword "^[\s\t]*throw"
syntax match ilasmKeyword "^[\s\t]*ldfld"
syntax match ilasmKeyword "^[\s\t]*ldflda"
syntax match ilasmKeyword "^[\s\t]*stfld"
syntax match ilasmKeyword "^[\s\t]*ldsfld"
syntax match ilasmKeyword "^[\s\t]*ldsflda"
syntax match ilasmKeyword "^[\s\t]*stsfld"
syntax match ilasmKeyword "^[\s\t]*stobj"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i1.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i2.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i4.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i8.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u1.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u2.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u4.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u8.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i.un"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u.un"
syntax match ilasmKeyword "^[\s\t]*box"
syntax match ilasmKeyword "^[\s\t]*newarr"
syntax match ilasmKeyword "^[\s\t]*ldlen"
syntax match ilasmKeyword "^[\s\t]*ldelema"
syntax match ilasmKeyword "^[\s\t]*ldelem.i1"
syntax match ilasmKeyword "^[\s\t]*ldelem.u1"
syntax match ilasmKeyword "^[\s\t]*ldelem.i2"
syntax match ilasmKeyword "^[\s\t]*ldelem.u2"
syntax match ilasmKeyword "^[\s\t]*ldelem.i4"
syntax match ilasmKeyword "^[\s\t]*ldelem.u4"
syntax match ilasmKeyword "^[\s\t]*ldelem.i8ldelem.u8"
syntax match ilasmKeyword "^[\s\t]*ldelem.i"
syntax match ilasmKeyword "^[\s\t]*ldelem.r4"
syntax match ilasmKeyword "^[\s\t]*ldelem.r8"
syntax match ilasmKeyword "^[\s\t]*ldelem.ref"
syntax match ilasmKeyword "^[\s\t]*stelem.i"
syntax match ilasmKeyword "^[\s\t]*stelem.i1"
syntax match ilasmKeyword "^[\s\t]*stelem.i2"
syntax match ilasmKeyword "^[\s\t]*stelem.i4"
syntax match ilasmKeyword "^[\s\t]*stelem.i8"
syntax match ilasmKeyword "^[\s\t]*stelem.r4"
syntax match ilasmKeyword "^[\s\t]*stelem.r8"
syntax match ilasmKeyword "^[\s\t]*stelem.ref"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i1"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u1"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i2"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u2"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i4"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u4"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i8"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u8"
syntax match ilasmKeyword "^[\s\t]*refanyval"
syntax match ilasmKeyword "^[\s\t]*ckfinite"
syntax match ilasmKeyword "^[\s\t]*mkrefany"
syntax match ilasmKeyword "^[\s\t]*ldtoken"
syntax match ilasmKeyword "^[\s\t]*conv.u2"
syntax match ilasmKeyword "^[\s\t]*conv.u1"
syntax match ilasmKeyword "^[\s\t]*conv.i"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.i"
syntax match ilasmKeyword "^[\s\t]*conv.ovf.u"
syntax match ilasmKeyword "^[\s\t]*add.ovf"
syntax match ilasmKeyword "^[\s\t]*add.ovf.un"
syntax match ilasmKeyword "^[\s\t]*mul.ovf"
syntax match ilasmKeyword "^[\s\t]*mul.ovf.un"
syntax match ilasmKeyword "^[\s\t]*sub.ovf"
syntax match ilasmKeyword "^[\s\t]*sub.ovf.un"
syntax match ilasmKeyword "^[\s\t]*endfinallyendfault"
syntax match ilasmKeyword "^[\s\t]*leave"
syntax match ilasmKeyword "^[\s\t]*leave.s"
syntax match ilasmKeyword "^[\s\t]*stind.i"
syntax match ilasmKeyword "^[\s\t]*conv.u"
syntax match ilasmKeyword "^[\s\t]*arglist"
syntax match ilasmKeyword "^[\s\t]*ceq"
syntax match ilasmKeyword "^[\s\t]*cgt"
syntax match ilasmKeyword "^[\s\t]*cgt.un"
syntax match ilasmKeyword "^[\s\t]*clt"
syntax match ilasmKeyword "^[\s\t]*clt.un"
syntax match ilasmKeyword "^[\s\t]*ldftn"
syntax match ilasmKeyword "^[\s\t]*ldvirtftn"
syntax match ilasmKeyword "^[\s\t]*ldarg"
syntax match ilasmKeyword "^[\s\t]*ldarga"
syntax match ilasmKeyword "^[\s\t]*starg"
syntax match ilasmKeyword "^[\s\t]*ldloc"
syntax match ilasmKeyword "^[\s\t]*ldloca"
syntax match ilasmKeyword "^[\s\t]*stloc"
syntax match ilasmKeyword "^[\s\t]*localloc"
syntax match ilasmKeyword "^[\s\t]*endfilter"
syntax match ilasmKeyword "^[\s\t]*unaligned."
syntax match ilasmKeyword "^[\s\t]*volatile."
syntax match ilasmKeyword "^[\s\t]*tail."
syntax match ilasmKeyword "^[\s\t]*initobj"
syntax match ilasmKeyword "^[\s\t]*cpblk"
syntax match ilasmKeyword "^[\s\t]*initblk"
syntax match ilasmKeyword "^[\s\t]*rethrow"
syntax match ilasmKeyword "^[\s\t]*sizeof"
syntax match ilasmKeyword "^[\s\t]*refanytype"

syntax keyword ilasmDeclaration public private privatescope family assembly famandassem famorassem cil cdecl stdcall thiscall fastcall managed unmanaged auto ansi extends static valuetype explicit init vararg extern at initonly rtspecialname marchal literal notserialized specialname request demand assert deny permitonly linkcheck inheritcheck reqmin reqopt reqrefuse prejitgrant noncasdemand noncaslinkdemand noncasinheritance fromunmanaged callmostderived unicode value enum interface sealed abstract sequential autochar import serializable beforefieldinit nested

if !exists("did_ilasm_syntax_inits")
   	let did_ilasm_syntax_inits=1
	highlight link ilasmComment Comment
	highlight link ilasmLabel Exception
	highlight link ilasmString String
	highlight link ilasmNumber Number
	highlight link ilasmType Type

	highlight link ilasmDirective Preproc
	highlight link ilasmDeclaration Preproc

	highlight link ilasmKeyword Keyword 

endif
let b:current_syntax="ilasm"



