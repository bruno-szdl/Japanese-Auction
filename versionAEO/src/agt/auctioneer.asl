{ include("common.asl") }

// Agent sample_agent in project versionA

/* Initial beliefs and rules */


/* Initial goals */

!create_org.

/* Plans */

+!create_org
    <- .print("Creating workspace auction_wsp...");
       createWorkspace(auction_wsp);

       .print("Joining workspace auction_wsp...");
       joinWorkspace(auction_wsp, AuctionWspId);

       .print("Creating auction_org...");
       makeArtifact(org1, "ora4mas.nopl.OrgBoard", ["src/org/auction-os.xml"], OrgArtId)[wid(AuctionWspId)];
       
       .print("Focusing in org artifact...");
       focus(OrgArtId) [wid(AuctionWspId)];

       .print("Creating group...");
       createGroup(group1, auction_group, GrArtId)[artifact_id(OrgArtId)];
       
       .print("Focusing in group...");
       focus(GrArtId)[wid(AuctionWspId)];
       
       .print("Adopting auctioneer role...");
       adoptRole(auctioneer)[artifact_id(GrArtId)];

       .print("Broadcasting group...");
       .broadcast(tell, new_gr(auction_wsp, group1));

       .print("Waiting group to be formed...");
       .wait(formationStatus(ok)[artifact_id(GrArtId)]);

       .print("Creating scheme...");
       createScheme(scheme1, auction_scheme, SchArtId)[artifact_id(OrgArtId)];
       
       .print("Adding scheme...");
       addScheme(scheme1)[artifact_id(GrArtId)];
       
       .print("Focusing in scheme...");
       focus(SchArtId)[wid(AuctionWspId)];
       .

+!create_auction_room
    <- .wait(100);

       .findall(X, goods(X, _), GoodsList);
       .nth(0, GoodsList, G);
       ?goods(G, P);

        .concat("/main/auction_room_", G, RoomName);
        .print("Creating ", RoomName, "...");
        createWorkspace(RoomName);
        
        .print("Joining auction room...");
        joinWorkspace(RoomName, AuctionRoomId);

        ?joinedWsp(AuctionWspId,_,"/main/auction_wsp");
        .print("Changing screen status to ", G, "...");
        setStatus(G) [wid(AuctionWspId), artifact_id(ScreenId)];

        .print("Creating artifact ", G, "...");
        makeArtifact(G, "auction_tools.AuctionGoods", [], GId)[wid(AuctionRoomId)];
        focus(GId) [wid(AuctionRoomId)];
        setGood(G, P) [artifact_id(GId)];

       .print("Auction for ", G, " started!");
       .print(G, "'s value is now ", P, "!");
       .wait(10)
       .

+!do_auction
    <- .print("Test do_auction");
    .

+!finish_auction
    <- .print("Test finish_auction");
    .
/*
+!startAuctions
    <- .print("All auctions have finished");
       setStatus("finished") [wid(AuctionWspId), artifact_id(ScreenId)].

+!checkParticipants(G, GId)
    : bidders(B)[artifact_id(GId)] &
      B > 1
    <- .wait(100);
       !raisePrice(G, GId).


+!checkParticipants(G, GId)
    : bidders(B)[artifact_id(GId)] &
      B == 1
    <- sold [artifact_id(GId)];
       stopFocus(GId);
       -goods(G, _);
       .concat("/main/auction_room_", G, RoomName);
       ?joinedWsp(A,_,RoomName);
       quitWorkspace(A);
       !startAuctions.


+!checkParticipants(G, GId)
    <- !annouceNoBidder(G, GId).


+!raisePrice(G, GId)
    <- raisePrice [artifact_id(GId)];
       ?price(P);
      .print(G, "'s value is now ", P, "!");
      !checkParticipants(G, GId).


+!annouceNoBidder(G, GId)
    : goods(G, P)
    <- .print("No bidder for ", G, " for ", P, "$!");
       notSold [artifact_id(GId)];
       stopFocus(GId);
       -goods(G, P);
       .concat("/main/auction_room_", G, RoomName);
       ?joinedWsp(A,_,RoomName);
       quitWorkspace(A);
       !startAuctions.

*/