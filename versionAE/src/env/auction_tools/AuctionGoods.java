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
	void addBidder() {
		ObsProperty b = getObsProperty("bidders");
		b.updateValue(b.intValue()+1);
	}

	@OPERATION
	void removeBidder() {
		ObsProperty b = getObsProperty("bidders");
		b.updateValue(b.intValue()-1);
	}

	@OPERATION
	void raisePrice() {
		ObsProperty p = getObsProperty("price");
		p.updateValue(p.intValue()+50);
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

