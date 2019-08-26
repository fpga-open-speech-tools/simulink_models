function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S1>/Gain_left */
	this.urlHashMap["HA_sys8:683"] = "HA_LR.vhd:392,398,406,412";
	/* <S1>/Gain_right */
	this.urlHashMap["HA_sys8:702"] = "HA_LR.vhd:525,531,539,545";
	/* <S1>/HA_left */
	this.urlHashMap["HA_sys8:117"] = "HA_LR.vhd:263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282";
	/* <S1>/HA_right */
	this.urlHashMap["HA_sys8:703"] = "HA_LR.vhd:284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303";
	/* <S4>/Add1 */
	this.urlHashMap["HA_sys8:592"] = "HA_left.vhd:1131,1132,1133";
	/* <S4>/Add2 */
	this.urlHashMap["HA_sys8:600"] = "HA_left.vhd:1111,1112,1113";
	/* <S4>/Add3 */
	this.urlHashMap["HA_sys8:608"] = "HA_left.vhd:1091,1092,1093";
	/* <S4>/FIRBandPass1 */
	this.urlHashMap["HA_sys8:603"] = "HA_left.vhd:487,488,489,490,491,492,493";
	/* <S4>/FIRBandPass2 */
	this.urlHashMap["HA_sys8:595"] = "HA_left.vhd:471,472,473,474,475,476,477";
	/* <S4>/FIRBandPass3 */
	this.urlHashMap["HA_sys8:587"] = "HA_left.vhd:455,456,457,458,459,460,461";
	/* <S4>/FIRBandPass4 */
	this.urlHashMap["HA_sys8:383"] = "HA_left.vhd:439,440,441,442,443,444,445";
	/* <S4>/FIRDecimator1 */
	this.urlHashMap["HA_sys8:365"] = "HA_left.vhd:431,432,433,434,435,436,437";
	/* <S4>/FIRDecimator2 */
	this.urlHashMap["HA_sys8:588"] = "HA_left.vhd:447,448,449,450,451,452,453";
	/* <S4>/FIRDecimator3 */
	this.urlHashMap["HA_sys8:596"] = "HA_left.vhd:463,464,465,466,467,468,469";
	/* <S4>/FIRDecimator4 */
	this.urlHashMap["HA_sys8:604"] = "HA_left.vhd:479,480,481,482,483,484,485";
	/* <S4>/FIRInterpolator1 */
	this.urlHashMap["HA_sys8:367"] = "HA_left.vhd:519,520,521,522,523,524,525";
	/* <S4>/FIRInterpolator2 */
	this.urlHashMap["HA_sys8:589"] = "HA_left.vhd:511,512,513,514,515,516,517";
	/* <S4>/FIRInterpolator3 */
	this.urlHashMap["HA_sys8:597"] = "HA_left.vhd:503,504,505,506,507,508,509";
	/* <S4>/FIRInterpolator4 */
	this.urlHashMap["HA_sys8:605"] = "HA_left.vhd:495,496,497,498,499,500,501";
	/* <S4>/Product1 */
	this.urlHashMap["HA_sys8:501"] = "HA_left.vhd:616,622,630,636";
	/* <S4>/Product2 */
	this.urlHashMap["HA_sys8:590"] = "HA_left.vhd:763,769,777,783";
	/* <S4>/Product3 */
	this.urlHashMap["HA_sys8:598"] = "HA_left.vhd:898,904,912,918";
	/* <S4>/Product4 */
	this.urlHashMap["HA_sys8:606"] = "HA_left.vhd:1031,1037,1045,1051";
	/* <S5>/Add1 */
	this.urlHashMap["HA_sys8:709"] = "HA_right.vhd:1131,1132,1133";
	/* <S5>/Add2 */
	this.urlHashMap["HA_sys8:710"] = "HA_right.vhd:1111,1112,1113";
	/* <S5>/Add3 */
	this.urlHashMap["HA_sys8:711"] = "HA_right.vhd:1091,1092,1093";
	/* <S5>/FIRBandPass1 */
	this.urlHashMap["HA_sys8:715"] = "HA_right.vhd:487,488,489,490,491,492,493";
	/* <S5>/FIRBandPass2 */
	this.urlHashMap["HA_sys8:714"] = "HA_right.vhd:471,472,473,474,475,476,477";
	/* <S5>/FIRBandPass3 */
	this.urlHashMap["HA_sys8:713"] = "HA_right.vhd:455,456,457,458,459,460,461";
	/* <S5>/FIRBandPass4 */
	this.urlHashMap["HA_sys8:712"] = "HA_right.vhd:439,440,441,442,443,444,445";
	/* <S5>/FIRDecimator1 */
	this.urlHashMap["HA_sys8:716"] = "HA_right.vhd:431,432,433,434,435,436,437";
	/* <S5>/FIRDecimator2 */
	this.urlHashMap["HA_sys8:717"] = "HA_right.vhd:447,448,449,450,451,452,453";
	/* <S5>/FIRDecimator3 */
	this.urlHashMap["HA_sys8:718"] = "HA_right.vhd:463,464,465,466,467,468,469";
	/* <S5>/FIRDecimator4 */
	this.urlHashMap["HA_sys8:719"] = "HA_right.vhd:479,480,481,482,483,484,485";
	/* <S5>/FIRInterpolator1 */
	this.urlHashMap["HA_sys8:720"] = "HA_right.vhd:519,520,521,522,523,524,525";
	/* <S5>/FIRInterpolator2 */
	this.urlHashMap["HA_sys8:721"] = "HA_right.vhd:511,512,513,514,515,516,517";
	/* <S5>/FIRInterpolator3 */
	this.urlHashMap["HA_sys8:722"] = "HA_right.vhd:503,504,505,506,507,508,509";
	/* <S5>/FIRInterpolator4 */
	this.urlHashMap["HA_sys8:723"] = "HA_right.vhd:495,496,497,498,499,500,501";
	/* <S5>/Product1 */
	this.urlHashMap["HA_sys8:724"] = "HA_right.vhd:616,622,630,636";
	/* <S5>/Product2 */
	this.urlHashMap["HA_sys8:725"] = "HA_right.vhd:763,769,777,783";
	/* <S5>/Product3 */
	this.urlHashMap["HA_sys8:726"] = "HA_right.vhd:898,904,912,918";
	/* <S5>/Product4 */
	this.urlHashMap["HA_sys8:727"] = "HA_right.vhd:1031,1037,1045,1051";
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
	this.rtwnameHashMap["<S1>/Gain_B4_left"] = {sid: "HA_sys8:659"};
	this.sidHashMap["HA_sys8:659"] = {rtwname: "<S1>/Gain_B4_left"};
	this.rtwnameHashMap["<S1>/Gain_B3_left"] = {sid: "HA_sys8:660"};
	this.sidHashMap["HA_sys8:660"] = {rtwname: "<S1>/Gain_B3_left"};
	this.rtwnameHashMap["<S1>/Gain_B2_left"] = {sid: "HA_sys8:661"};
	this.sidHashMap["HA_sys8:661"] = {rtwname: "<S1>/Gain_B2_left"};
	this.rtwnameHashMap["<S1>/Gain_B1_left"] = {sid: "HA_sys8:662"};
	this.sidHashMap["HA_sys8:662"] = {rtwname: "<S1>/Gain_B1_left"};
	this.rtwnameHashMap["<S1>/Gain_all_left"] = {sid: "HA_sys8:684"};
	this.sidHashMap["HA_sys8:684"] = {rtwname: "<S1>/Gain_all_left"};
	this.rtwnameHashMap["<S1>/HA_right_data_in"] = {sid: "HA_sys8:696"};
	this.sidHashMap["HA_sys8:696"] = {rtwname: "<S1>/HA_right_data_in"};
	this.rtwnameHashMap["<S1>/Gain_B4_right"] = {sid: "HA_sys8:697"};
	this.sidHashMap["HA_sys8:697"] = {rtwname: "<S1>/Gain_B4_right"};
	this.rtwnameHashMap["<S1>/Gain_B3_right"] = {sid: "HA_sys8:698"};
	this.sidHashMap["HA_sys8:698"] = {rtwname: "<S1>/Gain_B3_right"};
	this.rtwnameHashMap["<S1>/Gain_B2_right"] = {sid: "HA_sys8:699"};
	this.sidHashMap["HA_sys8:699"] = {rtwname: "<S1>/Gain_B2_right"};
	this.rtwnameHashMap["<S1>/Gain_B1_right"] = {sid: "HA_sys8:700"};
	this.sidHashMap["HA_sys8:700"] = {rtwname: "<S1>/Gain_B1_right"};
	this.rtwnameHashMap["<S1>/Gain_all_right"] = {sid: "HA_sys8:701"};
	this.sidHashMap["HA_sys8:701"] = {rtwname: "<S1>/Gain_all_right"};
	this.rtwnameHashMap["<S1>/Gain_left"] = {sid: "HA_sys8:683"};
	this.sidHashMap["HA_sys8:683"] = {rtwname: "<S1>/Gain_left"};
	this.rtwnameHashMap["<S1>/Gain_right"] = {sid: "HA_sys8:702"};
	this.sidHashMap["HA_sys8:702"] = {rtwname: "<S1>/Gain_right"};
	this.rtwnameHashMap["<S1>/HA_left"] = {sid: "HA_sys8:117"};
	this.sidHashMap["HA_sys8:117"] = {rtwname: "<S1>/HA_left"};
	this.rtwnameHashMap["<S1>/HA_right"] = {sid: "HA_sys8:703"};
	this.sidHashMap["HA_sys8:703"] = {rtwname: "<S1>/HA_right"};
	this.rtwnameHashMap["<S1>/HA_left_data_out"] = {sid: "HA_sys8:670"};
	this.sidHashMap["HA_sys8:670"] = {rtwname: "<S1>/HA_left_data_out"};
	this.rtwnameHashMap["<S1>/HA_right_data_out"] = {sid: "HA_sys8:734"};
	this.sidHashMap["HA_sys8:734"] = {rtwname: "<S1>/HA_right_data_out"};
	this.rtwnameHashMap["<S4>/data_in"] = {sid: "HA_sys8:118"};
	this.sidHashMap["HA_sys8:118"] = {rtwname: "<S4>/data_in"};
	this.rtwnameHashMap["<S4>/Gain_B4"] = {sid: "HA_sys8:502"};
	this.sidHashMap["HA_sys8:502"] = {rtwname: "<S4>/Gain_B4"};
	this.rtwnameHashMap["<S4>/Gain_B3"] = {sid: "HA_sys8:586"};
	this.sidHashMap["HA_sys8:586"] = {rtwname: "<S4>/Gain_B3"};
	this.rtwnameHashMap["<S4>/Gain_B2"] = {sid: "HA_sys8:594"};
	this.sidHashMap["HA_sys8:594"] = {rtwname: "<S4>/Gain_B2"};
	this.rtwnameHashMap["<S4>/Gain_B1"] = {sid: "HA_sys8:602"};
	this.sidHashMap["HA_sys8:602"] = {rtwname: "<S4>/Gain_B1"};
	this.rtwnameHashMap["<S4>/Add1"] = {sid: "HA_sys8:592"};
	this.sidHashMap["HA_sys8:592"] = {rtwname: "<S4>/Add1"};
	this.rtwnameHashMap["<S4>/Add2"] = {sid: "HA_sys8:600"};
	this.sidHashMap["HA_sys8:600"] = {rtwname: "<S4>/Add2"};
	this.rtwnameHashMap["<S4>/Add3"] = {sid: "HA_sys8:608"};
	this.sidHashMap["HA_sys8:608"] = {rtwname: "<S4>/Add3"};
	this.rtwnameHashMap["<S4>/FIRBandPass1"] = {sid: "HA_sys8:603"};
	this.sidHashMap["HA_sys8:603"] = {rtwname: "<S4>/FIRBandPass1"};
	this.rtwnameHashMap["<S4>/FIRBandPass2"] = {sid: "HA_sys8:595"};
	this.sidHashMap["HA_sys8:595"] = {rtwname: "<S4>/FIRBandPass2"};
	this.rtwnameHashMap["<S4>/FIRBandPass3"] = {sid: "HA_sys8:587"};
	this.sidHashMap["HA_sys8:587"] = {rtwname: "<S4>/FIRBandPass3"};
	this.rtwnameHashMap["<S4>/FIRBandPass4"] = {sid: "HA_sys8:383"};
	this.sidHashMap["HA_sys8:383"] = {rtwname: "<S4>/FIRBandPass4"};
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
	this.rtwnameHashMap["<S5>/data_in"] = {sid: "HA_sys8:704"};
	this.sidHashMap["HA_sys8:704"] = {rtwname: "<S5>/data_in"};
	this.rtwnameHashMap["<S5>/Gain_B4"] = {sid: "HA_sys8:705"};
	this.sidHashMap["HA_sys8:705"] = {rtwname: "<S5>/Gain_B4"};
	this.rtwnameHashMap["<S5>/Gain_B3"] = {sid: "HA_sys8:706"};
	this.sidHashMap["HA_sys8:706"] = {rtwname: "<S5>/Gain_B3"};
	this.rtwnameHashMap["<S5>/Gain_B2"] = {sid: "HA_sys8:707"};
	this.sidHashMap["HA_sys8:707"] = {rtwname: "<S5>/Gain_B2"};
	this.rtwnameHashMap["<S5>/Gain_B1"] = {sid: "HA_sys8:708"};
	this.sidHashMap["HA_sys8:708"] = {rtwname: "<S5>/Gain_B1"};
	this.rtwnameHashMap["<S5>/Add1"] = {sid: "HA_sys8:709"};
	this.sidHashMap["HA_sys8:709"] = {rtwname: "<S5>/Add1"};
	this.rtwnameHashMap["<S5>/Add2"] = {sid: "HA_sys8:710"};
	this.sidHashMap["HA_sys8:710"] = {rtwname: "<S5>/Add2"};
	this.rtwnameHashMap["<S5>/Add3"] = {sid: "HA_sys8:711"};
	this.sidHashMap["HA_sys8:711"] = {rtwname: "<S5>/Add3"};
	this.rtwnameHashMap["<S5>/FIRBandPass1"] = {sid: "HA_sys8:715"};
	this.sidHashMap["HA_sys8:715"] = {rtwname: "<S5>/FIRBandPass1"};
	this.rtwnameHashMap["<S5>/FIRBandPass2"] = {sid: "HA_sys8:714"};
	this.sidHashMap["HA_sys8:714"] = {rtwname: "<S5>/FIRBandPass2"};
	this.rtwnameHashMap["<S5>/FIRBandPass3"] = {sid: "HA_sys8:713"};
	this.sidHashMap["HA_sys8:713"] = {rtwname: "<S5>/FIRBandPass3"};
	this.rtwnameHashMap["<S5>/FIRBandPass4"] = {sid: "HA_sys8:712"};
	this.sidHashMap["HA_sys8:712"] = {rtwname: "<S5>/FIRBandPass4"};
	this.rtwnameHashMap["<S5>/FIRDecimator1"] = {sid: "HA_sys8:716"};
	this.sidHashMap["HA_sys8:716"] = {rtwname: "<S5>/FIRDecimator1"};
	this.rtwnameHashMap["<S5>/FIRDecimator2"] = {sid: "HA_sys8:717"};
	this.sidHashMap["HA_sys8:717"] = {rtwname: "<S5>/FIRDecimator2"};
	this.rtwnameHashMap["<S5>/FIRDecimator3"] = {sid: "HA_sys8:718"};
	this.sidHashMap["HA_sys8:718"] = {rtwname: "<S5>/FIRDecimator3"};
	this.rtwnameHashMap["<S5>/FIRDecimator4"] = {sid: "HA_sys8:719"};
	this.sidHashMap["HA_sys8:719"] = {rtwname: "<S5>/FIRDecimator4"};
	this.rtwnameHashMap["<S5>/FIRInterpolator1"] = {sid: "HA_sys8:720"};
	this.sidHashMap["HA_sys8:720"] = {rtwname: "<S5>/FIRInterpolator1"};
	this.rtwnameHashMap["<S5>/FIRInterpolator2"] = {sid: "HA_sys8:721"};
	this.sidHashMap["HA_sys8:721"] = {rtwname: "<S5>/FIRInterpolator2"};
	this.rtwnameHashMap["<S5>/FIRInterpolator3"] = {sid: "HA_sys8:722"};
	this.sidHashMap["HA_sys8:722"] = {rtwname: "<S5>/FIRInterpolator3"};
	this.rtwnameHashMap["<S5>/FIRInterpolator4"] = {sid: "HA_sys8:723"};
	this.sidHashMap["HA_sys8:723"] = {rtwname: "<S5>/FIRInterpolator4"};
	this.rtwnameHashMap["<S5>/Product1"] = {sid: "HA_sys8:724"};
	this.sidHashMap["HA_sys8:724"] = {rtwname: "<S5>/Product1"};
	this.rtwnameHashMap["<S5>/Product2"] = {sid: "HA_sys8:725"};
	this.sidHashMap["HA_sys8:725"] = {rtwname: "<S5>/Product2"};
	this.rtwnameHashMap["<S5>/Product3"] = {sid: "HA_sys8:726"};
	this.sidHashMap["HA_sys8:726"] = {rtwname: "<S5>/Product3"};
	this.rtwnameHashMap["<S5>/Product4"] = {sid: "HA_sys8:727"};
	this.sidHashMap["HA_sys8:727"] = {rtwname: "<S5>/Product4"};
	this.rtwnameHashMap["<S5>/data_out"] = {sid: "HA_sys8:728"};
	this.sidHashMap["HA_sys8:728"] = {rtwname: "<S5>/data_out"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
