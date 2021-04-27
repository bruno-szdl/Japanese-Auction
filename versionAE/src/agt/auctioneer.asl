{ include("goods.asl") }

// Agent sample_agent in project versionA

/* Initial beliefs and rules */


/* Initial goals */

!start.

/* Plans */

+!start
    <- joinWorkspace("/main/auction_wsp", AuctionWSPId);
       makeArtifact("screen", "auction_tools.AuctionScreen", [], ScreenId) [wid(AuctionWSPId)];
       !createAuction.

+!createAuction
    :  .findall(X, goods(X, _), GoodsList) &
       GoodsList \== []
    <- .wait(100);
       .nth(0, GoodsList, G)
       ?goods(G, P)
       .concat("/main/auction_room_", G, RoomName);
        createWorkspace(RoomName);
        joinWorkspace(RoomName, AuctionRoomId);
        .print("Joined auction room");
        setStatus(G) [wid(AuctionWSPId), artifact_id(ScreenId)];
        makeArtifact(G, "auction_tools.AuctionGoods", [], GId)[wid(AuctionRoomId)];
        focus(GId) [wid(AuctionRoomId)];
        setGood(G, P) [artifact_id(GId)];
       .print("Auction for ", G, " started!");
       .print(G, "'s value is now ", P, "!");
       .wait(100);
       startAuction [wid(AuctionRoomId)];
       .

+!createAuction
    <- .print("All auctions have finished");
       setStatus("finished") [wid(AuctionWSPId), artifact_id(ScreenId)].

+raisedPrice [artifact_id(GId)]
    <- .wait(10);
       checkParticipants [artifact_id(GId)];
       .

+sold [artifact_id(GId)]
  <- ?name(G);
      stopFocus(GId);
      -goods(G, P);
     .print("Leaving the room");
     .concat("/main/auction_room_", G, RoomName);
     ?joinedWsp(A,_,RoomName);
     quitWorkspace(A);
     !createAuction;
     .

+notSold [artifact_id(GId)]
  <- ?name(G);
      stopFocus(GId);
      -goods(G, P);
     .print("Leaving the room");
     .concat("/main/auction_room_", G, RoomName);
     ?joinedWsp(A,_,RoomName);
     quitWorkspace(A);
     !createAuction;
     .

/*+!checkParticipants(G, GId)
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
       !createAuction.


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
       !createAuction. */

