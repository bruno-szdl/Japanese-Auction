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

       makeArtifact("screen", "auction_tools.AuctionScreen", [], ScreenId) [wid(AuctionWSPId)];
       focus(ScreenId) [wid(AuctionWspId)];

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

       !create_scheme;
       .

+!create_scheme
    : .findall(X, goods(X, _), GoodsList) &
       GoodsList \== []
    <- .wait(100);
       .nth(0, GoodsList, G);
       ?goods(G, P);
        +currentAuction(G, P);
       .concat("scheme_for_", G, SchemeName); 
       .print("Creating scheme...");
       createScheme(SchemeName, auction_scheme, SchArtId)[artifact_id(OrgArtId)];
       
       .print("Adding scheme...");
       addScheme(SchemeName)[artifact_id(GrArtId)];
       
       .print("Focusing in scheme...");
       focus(SchArtId)[wid(AuctionWspId)];
       .

+!create_scheme
    <- .print("");
       .print("");
       .print("------- All goods have been auctioned off -------");
       .

+!create_auction_room
    : currentAuction(G, P)
    <- .print("creating auction room");

       .concat("/main/auction_room_", G, RoomName);
        createWorkspace(RoomName);
        joinWorkspace(RoomName, AuctionRoomId);
        .print("Joined auction room");

        setStatus(G) [wid(AuctionWSPId), artifact_id(ScreenId)];
        makeArtifact(G, "auction_tools.AuctionGoods", [], GId)[wid(AuctionRoomId)];
        +currentGood(G, GId);
        focus(GId) [wid(AuctionRoomId)];
        setGood(G, P) [artifact_id(GId)];

       .print("Auction for ", G, " started!");
       .print(G, "'s value is now ", P, "!");
       .

+!finish_auction
    <- !create_scheme;
    .

+!check_participants
    : currentGood(G, GId)
    <- .wait(10);
       checkParticipants [artifact_id(GId)];
       .

+!reset
    : currentGood(G, GId) &
      bidders(B)[artifact_id(GId)] &
      B > 1
    <- resetGoal(check_participants)[artifact_id(SchArtId)].

+!reset
    : currentGood(G, GId)
    <- stopFocus(GId);
       -goods(G, _);
       .concat("/main/auction_room_", G, RoomName);
       -currentGood(G, _);
       -currentAuction(G, _);
       ?joinedWsp(A,_,RoomName);
       quitWorkspace(A);
    .