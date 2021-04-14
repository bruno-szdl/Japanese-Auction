{ include("bidder.asl") }

/* Plans */
+!getMaxBid(G, InitialPrice)
  : .random(R)
  <- MaxBid = math.round(InitialPrice*((R*10)+1));
     -+maxBid(MaxBid).

     
    

       