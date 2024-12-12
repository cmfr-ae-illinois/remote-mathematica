(* ::Package:: *)

BeginPackage["RemoteKernel`"]


Begin["`Private`"]


PortIn = "25565";
PortOut = "25575";
ClusterAdresse = "campuscluster.illinois.edu";
ToAdresse[port_String, name_String, adresse_String] := StringJoin[port,"@", name, ".", adresse];


End[]


ConnectToKernel::usage = "ConnectToKernel[name] connect to a kernel running on the node 'name' on the illinois cluster and listening to the port 25565 and 25575 (defual in valentin script). return a link use to communicate with the kernel"


ConnectToKernel[name_String] := (link = LinkConnect[StringJoin[RemoteKernel`Private`ToAdresse[RemoteKernel`Private`PortIn, name, RemoteKernel`Private`ClusterAdresse], ",", RemoteKernel`Private`ToAdresse[RemoteKernel`Private`PortOut, name, RemoteKernel`Private`ClusterAdresse]], LinkProtocol->"TCPIP"]; LinkActivate[link]; LinkRead[link]; link)


KillKernel::usage = "stop the kernel and close the link"


KillKernel[lk_LinkObject] := (LinkWrite[lk, Unevaluated[Quit[]]]; LinkClose[lk])


LinkReadQ::usage = "see if there is an answer and get it if there is"


LinkReadQ[lk_LinkObject] := If[LinkReadyQ[lk], {True, LinkRead[lk]}, {False, Null}]


EndPackage[]
