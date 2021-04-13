{ include("goods.asl") }

// Agent sample_agent in project versionA

/* Initial beliefs and rules */


/* Initial goals */

!start.



/* Plans */

+!start
    <- .wait(1000);
       !startAuctions.

+!startAuctions
    :  .findall(X, goods(X, _), GoodsList) &
       GoodsList \== []
    <- .nth(0, GoodsList, G)
       ?goods(G, P)
       .broadcast(tell, auctionStarted(G, P));
       .print("Auction for ", G, " started!");
       .wait(10);
       .print(G, "'s value is now ", P, "!");
       !checkParticipants(G).

+!startAuctions
    <- .print("All auctions have finished").

+!checkParticipants(G)
    :  .findall(A, joinedRoom(G)[source(A)], ParticipantsList) &
       .length(ParticipantsList) > 1
    <- !raisePrice(G, ParticipantsList).

+!checkParticipants(G)
    :  .findall(A, joinedRoom(G)[source(A)], ParticipantsList) &
       .length(ParticipantsList) == 1
    <- .nth(0, ParticipantsList, Winner);
       !annouceWinner(Winner, G).

+!checkParticipants(G)
    <- !annouceNoBidder(G).


+!raisePrice(G, ParticipantsList)
    : goods(G, P)
    <- NewPrice = P + 50;
      -+goods(G,NewPrice);
      .print(G, "'s value is now ", NewPrice, "!");
      .send(ParticipantsList, tell, raisedPrice(G, NewPrice));
      .wait(10);
      !checkParticipants(G).

+!annouceWinner(Winner, G)
    : goods(G, P)
    <- .print(Winner, " bought ", G, " for ", P, "$!");
       .send(Winner, tell, bought(G, P));
       -goods(G, P);
       !startAuctions.

+!annouceNoBidder(G)
    : goods(G, P)
    <- .print("No bidder for ", G, " for ", P, "$!");
       -goods(G, P);
       !startAuctions.

+leavedRoom(G)[source(A)]
    <- -joinedRoom(G)[source(A)];
       -leavedRoom(G)[source(A)];
       .print(A, " leaved ", G, "'s room").

