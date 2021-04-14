{ include("goods.asl") }

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
!join_workspace.

/* Plans */

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
  <- .findall(X, wantToBuy(X, _), L);
     .print("I want to buy ", L);
     .abolish(goods(_,_));
     +goodsList(L);
     -counter(_).

+!join_workspace
  <- joinWorkspace("/main/auction_wsp", AuctionWSPId);
     .print("Entered auction_wsp");
     .wait(100)
     !focusScreen.

+!focusScreen
  <- lookupArtifact("screen",ScreenId);
     focus(ScreenId);
    .print("Focused screen").
     

+screenStatus(G)[artifact_id(ScreenId)]
  : wantToBuy(G, I) &
    money(M) & 
    I < M 
  <- !getMaxBid(G, I);
     joinWorkspace("/main/auction_room", AuctionRoomId);
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

+raisedPrice [artifact_id(GId)]
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
     ?joinedWsp(A,_,_);
     quitWorkspace(A).

+raisedPrice [artifact_id(GId)]
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
     ?joinedWsp(A,_,_);
     quitWorkspace(A).

+raisedPrice [artifact_id(GId)].

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
     -+nSucesses(S+1);
     -wantToBuy(G, _);
      stopFocus(GId);
    .print("Leaving the room");
     ?joinedWsp(A,_,_);
     quitWorkspace(A).
    

       