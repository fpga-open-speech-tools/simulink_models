function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S1>/Gain_left */
	this.urlHashMap["HA_sys8:683"] = "HA_LR.vhd:247,254,263,270";
	/* <S1>/HA_left */
	this.urlHashMap["HA_sys8:117"] = "HA_LR.vhd:180";
	/* <S4>/Add1 */
	this.urlHashMap["HA_sys8:592"] = "HA_left.vhd:1076";
	/* <S4>/Add2 */
	this.urlHashMap["HA_sys8:600"] = "HA_left.vhd:1055";
	/* <S4>/Add3 */
	this.urlHashMap["HA_sys8:608"] = "HA_left.vhd:1034";
	/* <S4>/FIRBandPass1 */
	this.urlHashMap["HA_sys8:383"] = "HA_left.vhd:429";
	/* <S4>/FIRBandPass2 */
	this.urlHashMap["HA_sys8:587"] = "HA_left.vhd:447";
	/* <S4>/FIRBandPass3 */
	this.urlHashMap["HA_sys8:595"] = "HA_left.vhd:465";
	/* <S4>/FIRBandPass4 */
	this.urlHashMap["HA_sys8:603"] = "HA_left.vhd:483";
	/* <S4>/FIRDecimator1 */
	this.urlHashMap["HA_sys8:365"] = "HA_left.vhd:420";
	/* <S4>/FIRDecimator2 */
	this.urlHashMap["HA_sys8:588"] = "HA_left.vhd:438";
	/* <S4>/FIRDecimator3 */
	this.urlHashMap["HA_sys8:596"] = "HA_left.vhd:456";
	/* <S4>/FIRDecimator4 */
	this.urlHashMap["HA_sys8:604"] = "HA_left.vhd:474";
	/* <S4>/FIRInterpolator1 */
	this.urlHashMap["HA_sys8:367"] = "HA_left.vhd:519";
	/* <S4>/FIRInterpolator2 */
	this.urlHashMap["HA_sys8:589"] = "HA_left.vhd:510";
	/* <S4>/FIRInterpolator3 */
	this.urlHashMap["HA_sys8:597"] = "HA_left.vhd:501";
	/* <S4>/FIRInterpolator4 */
	this.urlHashMap["HA_sys8:605"] = "HA_left.vhd:492";
	/* <S4>/Product1 */
	this.urlHashMap["HA_sys8:501"] = "HA_left.vhd:601,608,617,624";
	/* <S4>/Product2 */
	this.urlHashMap["HA_sys8:590"] = "HA_left.vhd:724,731,740,747";
	/* <S4>/Product3 */
	this.urlHashMap["HA_sys8:598"] = "HA_left.vhd:847,854,863,870";
	/* <S4>/Product4 */
	this.urlHashMap["HA_sys8:606"] = "HA_left.vhd:970,977,986,993";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "HA_sys8"};
	this.sidHashMap["HA_sys8"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S1>/HA_left_data_in"] = {sid: "HA_sys8:658"};
	this.sidHashMap["HA_sys8:658"] = {rtwname: "<S1>/HA_left_data_in"};
	this.rtwnameHashMap["<S1>/Gain_B1_left"] = {sid: "HA_sys8:659"};
	this.sidHashMap["HA_sys8:659"] = {rtwname: "<S1>/Gain_B1_left"};
	this.rtwnameHashMap["<S1>/Gain_B2_left"] = {sid: "HA_sys8:660"};
	this.sidHashMap["HA_sys8:660"] = {rtwname: "<S1>/Gain_B2_left"};
	this.rtwnameHashMap["<S1>/Gain_B3_left"] = {sid: "HA_sys8:661"};
	this.sidHashMap["HA_sys8:661"] = {rtwname: "<S1>/Gain_B3_left"};
	this.rtwnameHashMap["<S1>/Gain_B4_left"] = {sid: "HA_sys8:662"};
	this.sidHashMap["HA_sys8:662"] = {rtwname: "<S1>/Gain_B4_left"};
	this.rtwnameHashMap["<S1>/Gain_left_all"] = {sid: "HA_sys8:684"};
	this.sidHashMap["HA_sys8:684"] = {rtwname: "<S1>/Gain_left_all"};
	this.rtwnameHashMap["<S1>/HA_right_data_in"] = {sid: "HA_sys8:664"};
	this.sidHashMap["HA_sys8:664"] = {rtwname: "<S1>/HA_right_data_in"};
	this.rtwnameHashMap["<S1>/Gain_left"] = {sid: "HA_sys8:683"};
	this.sidHashMap["HA_sys8:683"] = {rtwname: "<S1>/Gain_left"};
	this.rtwnameHashMap["<S1>/HA_left"] = {sid: "HA_sys8:117"};
	this.sidHashMap["HA_sys8:117"] = {rtwname: "<S1>/HA_left"};
	this.rtwnameHashMap["<S1>/HA_left_data_out"] = {sid: "HA_sys8:670"};
	this.sidHashMap["HA_sys8:670"] = {rtwname: "<S1>/HA_left_data_out"};
	this.rtwnameHashMap["<S1>/HA_right_data_out"] = {sid: "HA_sys8:671"};
	this.sidHashMap["HA_sys8:671"] = {rtwname: "<S1>/HA_right_data_out"};
	this.rtwnameHashMap["<S4>/data_in"] = {sid: "HA_sys8:118"};
	this.sidHashMap["HA_sys8:118"] = {rtwname: "<S4>/data_in"};
	this.rtwnameHashMap["<S4>/Gain_B1"] = {sid: "HA_sys8:502"};
	this.sidHashMap["HA_sys8:502"] = {rtwname: "<S4>/Gain_B1"};
	this.rtwnameHashMap["<S4>/Gain_B2"] = {sid: "HA_sys8:586"};
	this.sidHashMap["HA_sys8:586"] = {rtwname: "<S4>/Gain_B2"};
	this.rtwnameHashMap["<S4>/Gain_B3"] = {sid: "HA_sys8:594"};
	this.sidHashMap["HA_sys8:594"] = {rtwname: "<S4>/Gain_B3"};
	this.rtwnameHashMap["<S4>/Gain_B4"] = {sid: "HA_sys8:602"};
	this.sidHashMap["HA_sys8:602"] = {rtwname: "<S4>/Gain_B4"};
	this.rtwnameHashMap["<S4>/Add1"] = {sid: "HA_sys8:592"};
	this.sidHashMap["HA_sys8:592"] = {rtwname: "<S4>/Add1"};
	this.rtwnameHashMap["<S4>/Add2"] = {sid: "HA_sys8:600"};
	this.sidHashMap["HA_sys8:600"] = {rtwname: "<S4>/Add2"};
	this.rtwnameHashMap["<S4>/Add3"] = {sid: "HA_sys8:608"};
	this.sidHashMap["HA_sys8:608"] = {rtwname: "<S4>/Add3"};
	this.rtwnameHashMap["<S4>/FIRBandPass1"] = {sid: "HA_sys8:383"};
	this.sidHashMap["HA_sys8:383"] = {rtwname: "<S4>/FIRBandPass1"};
	this.rtwnameHashMap["<S4>/FIRBandPass2"] = {sid: "HA_sys8:587"};
	this.sidHashMap["HA_sys8:587"] = {rtwname: "<S4>/FIRBandPass2"};
	this.rtwnameHashMap["<S4>/FIRBandPass3"] = {sid: "HA_sys8:595"};
	this.sidHashMap["HA_sys8:595"] = {rtwname: "<S4>/FIRBandPass3"};
	this.rtwnameHashMap["<S4>/FIRBandPass4"] = {sid: "HA_sys8:603"};
	this.sidHashMap["HA_sys8:603"] = {rtwname: "<S4>/FIRBandPass4"};
	this.rtwnameHashMap["<S4>/FIRDecimator1"] = {sid: "HA_sys8:365"};
	this.sidHashMap["HA_sys8:365"] = {rtwname: "<S4>/FIRDecimator1"};
	this.rtwnameHashMap["<S4>/FIRDecimator2"] = {sid: "HA_sys8:588"};
	this.sidHashMap["HA_sys8:588"] = {rtwname: "<S4>/FIRDecimator2"};
	this.rtwnameHashMap["<S4>/FIRDecimator3"] = {sid: "HA_sys8:596"};
	this.sidHashMap["HA_sys8:596"] = {rtwname: "<S4>/FIRDecimator3"};
	this.rtwnameHashMap["<S4>/FIRDecimator4"] = {sid: "HA_sys8:604"};
	this.sidHashMap["HA_sys8:604"] = {rtwname: "<S4>/FIRDecimator4"};
	this.rtwnameHashMap["<S4>/FIRInterpolator1"] = {sid: "HA_sys8:367"};
	this.sidHashMap["HA_sys8:367"] = {rtwname: "<S4>/FIRInterpolator1"};
	this.rtwnameHashMap["<S4>/FIRInterpolator2"] = {sid: "HA_sys8:589"};
	this.sidHashMap["HA_sys8:589"] = {rtwname: "<S4>/FIRInterpolator2"};
	this.rtwnameHashMap["<S4>/FIRInterpolator3"] = {sid: "HA_sys8:597"};
	this.sidHashMap["HA_sys8:597"] = {rtwname: "<S4>/FIRInterpolator3"};
	this.rtwnameHashMap["<S4>/FIRInterpolator4"] = {sid: "HA_sys8:605"};
	this.sidHashMap["HA_sys8:605"] = {rtwname: "<S4>/FIRInterpolator4"};
	this.rtwnameHashMap["<S4>/Product1"] = {sid: "HA_sys8:501"};
	this.sidHashMap["HA_sys8:501"] = {rtwname: "<S4>/Product1"};
	this.rtwnameHashMap["<S4>/Product2"] = {sid: "HA_sys8:590"};
	this.sidHashMap["HA_sys8:590"] = {rtwname: "<S4>/Product2"};
	this.rtwnameHashMap["<S4>/Product3"] = {sid: "HA_sys8:598"};
	this.sidHashMap["HA_sys8:598"] = {rtwname: "<S4>/Product3"};
	this.rtwnameHashMap["<S4>/Product4"] = {sid: "HA_sys8:606"};
	this.sidHashMap["HA_sys8:606"] = {rtwname: "<S4>/Product4"};
	this.rtwnameHashMap["<S4>/data_out"] = {sid: "HA_sys8:120"};
	this.sidHashMap["HA_sys8:120"] = {rtwname: "<S4>/data_out"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
