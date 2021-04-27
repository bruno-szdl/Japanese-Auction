{ include("common.asl") }

// Agent in project versionA

/* Initial beliefs and rules */
nSucesses(0).
nFailures(0).
money(0).
counter(0).
maxBid(0).

/* Initial goals */

!getMoney.
!chooseGoodsQuantity.


/* Plans  */

+new_gr(Workspace, GroupName)
  <- .print("Joining workspace ", Workspace, "...");
    joinWorkspace(Workspace, WspId);

    lookupArtifact("screen",ScreenId);
    focus(ScreenId);
    .print("Focused screen");

    .print("Searching group...");
    lookupArtifact(GroupName, GrArtId);
    .print("Adopting participant role...");
    adoptRole(participant)[artifact_id(GrArtId)];
    .print("Focusing in group...");
    focus(GrArtId)[wid(WspId)];
    .

+screenStatus(G)[artifact_id(ScreenId)]
  : wantToBuy(G, I) &
    money(M) & 
    I < M 
  <- !getMaxBid(G, I);
     .concat("/main/auction_room_", G, RoomName);
     joinWorkspace(RoomName, AuctionRoomId);
     .print("Joined auction's room");
     lookupArtifact(G, GId);
     focus(GId);
     addBidder [artifact_id(GId)];
     .print("Focused ", G).

+screenStatus(G)[artifact_id(ScreenId)]
  : wantToBuy(G, _)
  <- .print("I don't have enough money for ", G, ".");
     -wantToBuy(G, _);
     +didNotBuy(G);
     -+nFailures(F+1).

+screenStatus(G)[artifact_id(ScreenId)].
    
+!getMoney
  : .random(R)
  <- -+money(math.round(R*10000)+1000);
     .print("I have ", math.round(R*10000)+1000, "$").

+!chooseGoodsQuantity
  : .random(R) &
    nGoods(NG) &
    N = math.ceil(NG*R)
  <- +goodsQuantity(N);
     !chooseGoods.

+!chooseGoods
  : goodsQuantity(N) &
    counter(C) &
    C < N 
  <- .findall(X, goods(X, _), GoodsList);
     .shuffle(GoodsList, GoodsListShuffled);
     .nth(0, GoodsListShuffled, G);
     ?goods(G, I);
     +wantToBuy(G, I);
     -goods(G, _);
     -+counter(C+1);
     !chooseGoods.

+!chooseGoods 
  <- //+wantToBuy("good1", 100);
     //+wantToBuy("good2", 200); 
    .findall(X, wantToBuy(X, _), L);
     .print("I want to buy ", L);
     .abolish(goods(_,_));
     +goodsList(L);
     -counter(_).

     
+!stay_or_leave
  : maxBid(M) &
    price(P) [artifact_id(GId)] &
    M < P &
    nFailures(F)
  <- .print("Max bid is less than new price. I am leaving the room");
     removeBidder [artifact_id(GId)];
     ?name(G);
     -wantToBuy(G, _);
     +didNotBuy(G)
     stopFocus(GId);
     -+nFailures(F+1);
     .concat("/main/auction_room_", G, RoomName);
     ?joinedWsp(A,_,RoomName);
     quitWorkspace(A).

+!stay_or_leave
  : money(M) &
    price(P) [artifact_id(GId)] &
    M < P &
    nFailures(F) 
  <- .print("Money is less than new price. I am leaving the room");
     removeBidder [artifact_id(GId)];
     ?name(G);
     -wantToBuy(G, _);
     +didNotBuy(G)
     stopFocus(GId);
     -+nFailures(F+1);
     .concat("/main/auction_room_", G, RoomName);
     ?joinedWsp(A,_,RoomName);
     quitWorkspace(A).

+!stay_or_leave.

+sold [artifact_id(GId)]
  : money(M) &
    price(P) &
    nSucesses(S)
  <- ?name(G);
    -+money(M - P);
     .print("I bought ", G, " for ", P, "$.");
     .print("Now I have ", M-P, "$.");
     .my_name(N);
      sold2(N) [artifact_id(GId)];
      +bought(G, P);
     -+nSucesses(S+1);
     -wantToBuy(G, _);
      stopFocus(GId);
     .print("Leaving the room");
     .concat("/main/auction_room_", G, RoomName);
     ?joinedWsp(A,_,RoomName);
     quitWorkspace(A);
     .