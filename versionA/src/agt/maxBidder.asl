{ include("bidder.asl") }

/* Plans */
+!getMaxBid(G, InitialPrice)
  : money(M)
  <- +maxBid(G, M).

     
    

       