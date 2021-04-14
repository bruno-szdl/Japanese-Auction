{ include("goods.asl") }
{ include("common-cartago.asl") }

// Agent sample_agent in project versionA

/* Initial beliefs and rules */


/* Initial goals */

!start.

/* Plans */

+!start
    <- joinWorkspace("/main/auction_wsp", AuctionWSPId);
       makeArtifact("screen", "auction_tools.AuctionScreen", [], ScreenId) [wid(AuctionWSPId)];
       joinWorkspace("/main/auction_room", AuctionRoomId);
       .print("Joined auction room");
       !startAuctions.

+!startAuctions
    :  .findall(X, goods(X, _), GoodsList) &
       GoodsList \== []
    <- .nth(0, GoodsList, G)
       ?goods(G, P)
       .wait(100);
        setStatus(G) [wid(AuctionWSPId), artifact_id(ScreenId)];
        makeArtifact(G, "auction_tools.AuctionGoods", [], GId)[wid(AuctionRoomId)];
        focus(GId) [wid(AuctionRoomId)];
        setGood(G, P) [artifact_id(GId)];
       .print("Auction for ", G, " started!");
       .print(G, "'s value is now ", P, "!");
       .wait(10);
       !checkParticipants(G, GId).

+!startAuctions
    <- .print("All auctions have finished").

+!checkParticipants(G, GId)
    : bidders(B)[artifact_id(GId)] &
      B > 1
    <- !raisePrice(G, GId).


+!checkParticipants(G, GId)
    : bidders(B)[artifact_id(GId)] &
      B == 1
    <- sold [artifact_id(GId)];
       stopFocus(GId);
       -goods(G, _);
       !startAuctions.


+!checkParticipants(G, GId)
    <- !annouceNoBidder(G, GId).


+!raisePrice(G, GId)
    <- raisePrice [artifact_id(GId)];
       ?price(P);
      .print(G, "'s value is now ", P, "!");
      .wait(10);
      !checkParticipants(G, GId).


+!annouceNoBidder(G, GId)
    : goods(G, P)
    <- .print("No bidder for ", G, " for ", P, "$!");
       notSold [artifact_id(GId)];
       stopFocus(GId);
       -goods(G, P);
       !startAuctions.

