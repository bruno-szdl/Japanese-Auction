// Agent sample_agent in project versionA
{ include("$moiseJar/asl/org-obedient.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }


/* Initial beliefs and rules */
nGoods(10).
goods("good1", 100).
goods("good2", 200).
goods("good3", 300).
goods("good4", 400).
goods("good5", 500).
goods("good6", 600).
goods("good7", 700).
goods("good8", 800).
goods("good9", 900).
goods("good10", 1000).

/* Initial goals */



/* Plans */


+permission(Ag, MCond, committed(Ag, Mission, Scheme), Deadline) : .my_name(Ag)
<-  ?focusing(ArtId,Scheme,_,_,_,_)
    commitMission(Mission)[artifact_id(ArtId)].