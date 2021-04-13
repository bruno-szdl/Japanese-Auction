{ include("goods.asl") }

// Agent in project versionA

/* Initial beliefs and rules */
nSucesses(0).
nFailures(0).
money(0).
counter(0).

/* Initial goals */

!getMoney.
!chooseGoodsQuantity.

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
     +wantToBuy(G);
     -goods(G, _);
     -+counter(C+1);
     !chooseGoods.

+!chooseGoods 
  <- .findall(X, wantToBuy(X), L);
     .print("I want to buy ", L);
     .abolish(goods(_,_));
     -counter(_).

+auctionStarted(G, InitialPrice)[source(A)]
  : wantToBuy(G) &
    money(M) & 
    InitialPrice < M
  <- !getMaxBid(G, InitialPrice);
     .send(A, tell, joinedRoom(G));
     .print("Joined ", G, "'s room");
     +room(G);
     -auctionStarted.

+auctionStarted(G, InitialPrice)[source(A)]
  : wantToBuy(G)
  <- .print("I don't have enough money for ", G, ".");
     -wantToBuy(G);
     +didNotBuy(G);
     -+nFailures(F+1);
     -auctionStarted.

+auctionStarted(G, InitialPrice)[source(A)]
  <- -auctionStarted.

+raisedPrice(G, NewPrice)[source(A)]
  : maxBid(G, M) &
    M < NewPrice &
    nFailures(F)
  <- .print("Max bid is less than new price. I am leaving ", G, "'s room");
     .send(A, tell, leavedRoom(G));
     -+nFailures(F+1);
     -room(G);
     -wantToBuy(G);
     -raisedPrice(G, NewPrice)[source(A)];
     +didNotBuy(G).

+raisedPrice(G, NewPrice)[source(A)]
  : money(M) &
    M < NewPrice &
    nFailures(F)
  <- .print("Money is less than new price. I am leaving ", G, "'s room");
     .send(A, tell, leavedRoom(G));
     -+nFailures(F+1);
     -room(G);
     -wantToBuy(G);
     -raisedPrice(G, NewPrice)[source(A)];
     +didNotBuy(G).

+raisedPrice(G, NewPrice)[source(A)]
  <- -raisedPrice(G, NewPrice)[source(A)].

+bought(G, Price)
  : money(M) &
    nSucesses(S)
  <- -+money(M - Price);
     .print("I bought ", G, " for ", Price, "$.");
     .print("Now I have ", M-Price, "$.");
     -+nSucesses(S+1);
     -wantToBuy(G);
     -room(G).
     
    

       