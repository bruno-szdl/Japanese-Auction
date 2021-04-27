// CArtAgO artifact code for project versionAE
package auction_tools;

import cartago.*;
import java.lang.Object;

public class AuctionGoods extends Artifact {

	void init() {
		defineObsProperty("name", "none");
		defineObsProperty("price", 0);
		defineObsProperty("bidders", 0);
		defineObsProperty("winner", "none");
	}

	@OPERATION
	void setGood(String G, int P) {
		ObsProperty g = getObsProperty("name");
		g.updateValue(G);
		ObsProperty p = getObsProperty("price");
		p.updateValue(P);
	}

	@OPERATION
	void startAuction() {
		checkParticipants();
	}	

	@OPERATION
	void checkParticipants() {
		ObsProperty g = getObsProperty("name");
		ObsProperty b = getObsProperty("bidders");
		if (b.intValue() == 0){
			notSold();
			System.out.printf(" There is no bidder left, %s was not sold\n", g);
		}
		else if (b.intValue() == 1){
			sold();
			System.out.printf(" There is only one bidder left, selling %s\n", g);
		}
		else{
			raisePrice();
			System.out.printf(" There are %s bidders, raising price\n", b);

		}
	}	

	@OPERATION
	void addBidder() {
		ObsProperty b = getObsProperty("bidders");
		b.updateValue(b.intValue()+1);
		System.out.printf(" Adding one bidder. Total: %s\n", b);
	}

	@OPERATION
	void removeBidder() {
		ObsProperty b = getObsProperty("bidders");
		b.updateValue(b.intValue()-1);
		System.out.printf(" Adding one bidder. Total: %s\n", b);
	}

	@OPERATION
	void raisePrice() {
		ObsProperty g = getObsProperty("name");
		ObsProperty p = getObsProperty("price");
		ObsProperty b = getObsProperty("bidders");
		p.updateValue(p.intValue()+100);
		System.out.printf(" %s's value is now %s with %s bidder(s)!\n", g, p, b);
		signal("raisedPrice");
	}

	@OPERATION
	void sold() {
		signal("sold");
	}

	@OPERATION
	void sold2(String B) {
		ObsProperty w = getObsProperty("winner");
		w.updateValue(B);
	}

	@OPERATION
	void notSold() {
		ObsProperty w = getObsProperty("winner");
		w.updateValue("Not sold");
	}
}

