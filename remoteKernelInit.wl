(* ::Package:: *)

$Pre = Function[
    Null,
    MemoryConstrained[#, Max[IntegerPart[0.9*(MemoryInUse[]+MemoryAvailable[])]-MemoryInUse[], 1]],
    HoldAll
];

BeginPackage["RemoteKernel`"]
Define[s_Symbol, expr_] := (s = expr)
DefineDefer[s_Symbol, expr_] := (s := expr)
EndPackage[]
