function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S5>/avalon_sink_valid */
	this.urlHashMap["mean_noise_reduction:235"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:235";
	/* <S5>/avalon_sink_error */
	this.urlHashMap["mean_noise_reduction:237"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:237";
	/* <S5>/Adaptive_Wiener_Filter
Sample Based Filtering */
	this.urlHashMap["mean_noise_reduction:1038"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1038";
	/* <S6>/Sink_Channel */
	this.urlHashMap["mean_noise_reduction:1040"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1040";
	/* <S6>/Multiport
Switch */
	this.urlHashMap["mean_noise_reduction:1058"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1058";
	/* <S6>/Right Channel Processing */
	this.urlHashMap["mean_noise_reduction:1170"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1170";
	/* <S6>/Right Channel Processing1 */
	this.urlHashMap["mean_noise_reduction:1345"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1345";
	/* <S7>/Compare */
	this.urlHashMap["mean_noise_reduction:1044:2"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1044:2";
	/* <S7>/Constant */
	this.urlHashMap["mean_noise_reduction:1044:3"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1044:3";
	/* <S8>/Compare */
	this.urlHashMap["mean_noise_reduction:1045:2"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1045:2";
	/* <S8>/Constant */
	this.urlHashMap["mean_noise_reduction:1045:3"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1045:3";
	/* <S9>/Switch */
	this.urlHashMap["mean_noise_reduction:1285"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1285";
	/* <S10>/Switch */
	this.urlHashMap["mean_noise_reduction:1359"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1359";
	/* <S11>/Constant */
	this.urlHashMap["mean_noise_reduction:1209"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1209";
	/* <S11>/Constant1 */
	this.urlHashMap["mean_noise_reduction:1210"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1210";
	/* <S11>/Delay32 */
	this.urlHashMap["mean_noise_reduction:1211"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1211";
	/* <S11>/Divide */
	this.urlHashMap["mean_noise_reduction:1212"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1212";
	/* <S11>/Sum */
	this.urlHashMap["mean_noise_reduction:1213"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1213";
	/* <S11>/Switch */
	this.urlHashMap["mean_noise_reduction:1344"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1344";
	/* <S11>/Tapped Delay */
	this.urlHashMap["mean_noise_reduction:1214"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1214";
	/* <S12>/Constant */
	this.urlHashMap["mean_noise_reduction:1351"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1351";
	/* <S12>/Constant1 */
	this.urlHashMap["mean_noise_reduction:1352"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1352";
	/* <S12>/Delay32 */
	this.urlHashMap["mean_noise_reduction:1353"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1353";
	/* <S12>/Divide */
	this.urlHashMap["mean_noise_reduction:1354"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1354";
	/* <S12>/Sum */
	this.urlHashMap["mean_noise_reduction:1355"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1355";
	/* <S12>/Switch */
	this.urlHashMap["mean_noise_reduction:1356"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1356";
	/* <S12>/Tapped Delay */
	this.urlHashMap["mean_noise_reduction:1357"] = "msg=rtwMsg_notTraceable&block=mean_noise_reduction:1357";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "mean_noise_reduction"};
	this.sidHashMap["mean_noise_reduction"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S5>/avalon_sink_valid"] = {sid: "mean_noise_reduction:235"};
	this.sidHashMap["mean_noise_reduction:235"] = {rtwname: "<S5>/avalon_sink_valid"};
	this.rtwnameHashMap["<S5>/avalon_sink_data"] = {sid: "mean_noise_reduction:234"};
	this.sidHashMap["mean_noise_reduction:234"] = {rtwname: "<S5>/avalon_sink_data"};
	this.rtwnameHashMap["<S5>/avalon_sink_channel"] = {sid: "mean_noise_reduction:236"};
	this.sidHashMap["mean_noise_reduction:236"] = {rtwname: "<S5>/avalon_sink_channel"};
	this.rtwnameHashMap["<S5>/avalon_sink_error"] = {sid: "mean_noise_reduction:237"};
	this.sidHashMap["mean_noise_reduction:237"] = {rtwname: "<S5>/avalon_sink_error"};
	this.rtwnameHashMap["<S5>/register_control_enable"] = {sid: "mean_noise_reduction:1024"};
	this.sidHashMap["mean_noise_reduction:1024"] = {rtwname: "<S5>/register_control_enable"};
	this.rtwnameHashMap["<S5>/Adaptive_Wiener_Filter Sample Based Filtering"] = {sid: "mean_noise_reduction:1038"};
	this.sidHashMap["mean_noise_reduction:1038"] = {rtwname: "<S5>/Adaptive_Wiener_Filter Sample Based Filtering"};
	this.rtwnameHashMap["<S5>/avalon_source_valid"] = {sid: "mean_noise_reduction:412"};
	this.sidHashMap["mean_noise_reduction:412"] = {rtwname: "<S5>/avalon_source_valid"};
	this.rtwnameHashMap["<S5>/avalon_source_data"] = {sid: "mean_noise_reduction:411"};
	this.sidHashMap["mean_noise_reduction:411"] = {rtwname: "<S5>/avalon_source_data"};
	this.rtwnameHashMap["<S5>/avalon_source_channel"] = {sid: "mean_noise_reduction:413"};
	this.sidHashMap["mean_noise_reduction:413"] = {rtwname: "<S5>/avalon_source_channel"};
	this.rtwnameHashMap["<S5>/avalon_source_error"] = {sid: "mean_noise_reduction:414"};
	this.sidHashMap["mean_noise_reduction:414"] = {rtwname: "<S5>/avalon_source_error"};
	this.rtwnameHashMap["<S6>/Sink_Data"] = {sid: "mean_noise_reduction:1039"};
	this.sidHashMap["mean_noise_reduction:1039"] = {rtwname: "<S6>/Sink_Data"};
	this.rtwnameHashMap["<S6>/Sink_Channel"] = {sid: "mean_noise_reduction:1040"};
	this.sidHashMap["mean_noise_reduction:1040"] = {rtwname: "<S6>/Sink_Channel"};
	this.rtwnameHashMap["<S6>/register_control_enable"] = {sid: "mean_noise_reduction:1042"};
	this.sidHashMap["mean_noise_reduction:1042"] = {rtwname: "<S6>/register_control_enable"};
	this.rtwnameHashMap["<S6>/Enable"] = {sid: "mean_noise_reduction:1043"};
	this.sidHashMap["mean_noise_reduction:1043"] = {rtwname: "<S6>/Enable"};
	this.rtwnameHashMap["<S6>/Compare To Constant1"] = {sid: "mean_noise_reduction:1044"};
	this.sidHashMap["mean_noise_reduction:1044"] = {rtwname: "<S6>/Compare To Constant1"};
	this.rtwnameHashMap["<S6>/Compare To Constant2"] = {sid: "mean_noise_reduction:1045"};
	this.sidHashMap["mean_noise_reduction:1045"] = {rtwname: "<S6>/Compare To Constant2"};
	this.rtwnameHashMap["<S6>/Multiport Switch"] = {sid: "mean_noise_reduction:1058"};
	this.sidHashMap["mean_noise_reduction:1058"] = {rtwname: "<S6>/Multiport Switch"};
	this.rtwnameHashMap["<S6>/Right Channel Processing"] = {sid: "mean_noise_reduction:1170"};
	this.sidHashMap["mean_noise_reduction:1170"] = {rtwname: "<S6>/Right Channel Processing"};
	this.rtwnameHashMap["<S6>/Right Channel Processing1"] = {sid: "mean_noise_reduction:1345"};
	this.sidHashMap["mean_noise_reduction:1345"] = {rtwname: "<S6>/Right Channel Processing1"};
	this.rtwnameHashMap["<S6>/Source_Data"] = {sid: "mean_noise_reduction:1110"};
	this.sidHashMap["mean_noise_reduction:1110"] = {rtwname: "<S6>/Source_Data"};
	this.rtwnameHashMap["<S6>/Source_Channel"] = {sid: "mean_noise_reduction:1111"};
	this.sidHashMap["mean_noise_reduction:1111"] = {rtwname: "<S6>/Source_Channel"};
	this.rtwnameHashMap["<S7>/u"] = {sid: "mean_noise_reduction:1044:1"};
	this.sidHashMap["mean_noise_reduction:1044:1"] = {rtwname: "<S7>/u"};
	this.rtwnameHashMap["<S7>/Compare"] = {sid: "mean_noise_reduction:1044:2"};
	this.sidHashMap["mean_noise_reduction:1044:2"] = {rtwname: "<S7>/Compare"};
	this.rtwnameHashMap["<S7>/Constant"] = {sid: "mean_noise_reduction:1044:3"};
	this.sidHashMap["mean_noise_reduction:1044:3"] = {rtwname: "<S7>/Constant"};
	this.rtwnameHashMap["<S7>/y"] = {sid: "mean_noise_reduction:1044:4"};
	this.sidHashMap["mean_noise_reduction:1044:4"] = {rtwname: "<S7>/y"};
	this.rtwnameHashMap["<S8>/u"] = {sid: "mean_noise_reduction:1045:1"};
	this.sidHashMap["mean_noise_reduction:1045:1"] = {rtwname: "<S8>/u"};
	this.rtwnameHashMap["<S8>/Compare"] = {sid: "mean_noise_reduction:1045:2"};
	this.sidHashMap["mean_noise_reduction:1045:2"] = {rtwname: "<S8>/Compare"};
	this.rtwnameHashMap["<S8>/Constant"] = {sid: "mean_noise_reduction:1045:3"};
	this.sidHashMap["mean_noise_reduction:1045:3"] = {rtwname: "<S8>/Constant"};
	this.rtwnameHashMap["<S8>/y"] = {sid: "mean_noise_reduction:1045:4"};
	this.sidHashMap["mean_noise_reduction:1045:4"] = {rtwname: "<S8>/y"};
	this.rtwnameHashMap["<S9>/Right_Data_Sink"] = {sid: "mean_noise_reduction:1171"};
	this.sidHashMap["mean_noise_reduction:1171"] = {rtwname: "<S9>/Right_Data_Sink"};
	this.rtwnameHashMap["<S9>/register_control_bypass"] = {sid: "mean_noise_reduction:1284"};
	this.sidHashMap["mean_noise_reduction:1284"] = {rtwname: "<S9>/register_control_bypass"};
	this.rtwnameHashMap["<S9>/Enable"] = {sid: "mean_noise_reduction:1173"};
	this.sidHashMap["mean_noise_reduction:1173"] = {rtwname: "<S9>/Enable"};
	this.rtwnameHashMap["<S9>/Grab the Look-behind Window and Calculate the Mean"] = {sid: "mean_noise_reduction:1207"};
	this.sidHashMap["mean_noise_reduction:1207"] = {rtwname: "<S9>/Grab the Look-behind Window and Calculate the Mean"};
	this.rtwnameHashMap["<S9>/Switch"] = {sid: "mean_noise_reduction:1285"};
	this.sidHashMap["mean_noise_reduction:1285"] = {rtwname: "<S9>/Switch"};
	this.rtwnameHashMap["<S9>/Right_Data_Source  "] = {sid: "mean_noise_reduction:1218"};
	this.sidHashMap["mean_noise_reduction:1218"] = {rtwname: "<S9>/Right_Data_Source  "};
	this.rtwnameHashMap["<S10>/Left_Data_sink"] = {sid: "mean_noise_reduction:1346"};
	this.sidHashMap["mean_noise_reduction:1346"] = {rtwname: "<S10>/Left_Data_sink"};
	this.rtwnameHashMap["<S10>/register_control_bypass"] = {sid: "mean_noise_reduction:1347"};
	this.sidHashMap["mean_noise_reduction:1347"] = {rtwname: "<S10>/register_control_bypass"};
	this.rtwnameHashMap["<S10>/Enable"] = {sid: "mean_noise_reduction:1348"};
	this.sidHashMap["mean_noise_reduction:1348"] = {rtwname: "<S10>/Enable"};
	this.rtwnameHashMap["<S10>/Grab the Look-behind Window and Calculate the Mean"] = {sid: "mean_noise_reduction:1349"};
	this.sidHashMap["mean_noise_reduction:1349"] = {rtwname: "<S10>/Grab the Look-behind Window and Calculate the Mean"};
	this.rtwnameHashMap["<S10>/Switch"] = {sid: "mean_noise_reduction:1359"};
	this.sidHashMap["mean_noise_reduction:1359"] = {rtwname: "<S10>/Switch"};
	this.rtwnameHashMap["<S10>/Left_Data_Source  "] = {sid: "mean_noise_reduction:1360"};
	this.sidHashMap["mean_noise_reduction:1360"] = {rtwname: "<S10>/Left_Data_Source  "};
	this.rtwnameHashMap["<S11>/right_data_sink"] = {sid: "mean_noise_reduction:1208"};
	this.sidHashMap["mean_noise_reduction:1208"] = {rtwname: "<S11>/right_data_sink"};
	this.rtwnameHashMap["<S11>/Constant"] = {sid: "mean_noise_reduction:1209"};
	this.sidHashMap["mean_noise_reduction:1209"] = {rtwname: "<S11>/Constant"};
	this.rtwnameHashMap["<S11>/Constant1"] = {sid: "mean_noise_reduction:1210"};
	this.sidHashMap["mean_noise_reduction:1210"] = {rtwname: "<S11>/Constant1"};
	this.rtwnameHashMap["<S11>/Delay32"] = {sid: "mean_noise_reduction:1211"};
	this.sidHashMap["mean_noise_reduction:1211"] = {rtwname: "<S11>/Delay32"};
	this.rtwnameHashMap["<S11>/Divide"] = {sid: "mean_noise_reduction:1212"};
	this.sidHashMap["mean_noise_reduction:1212"] = {rtwname: "<S11>/Divide"};
	this.rtwnameHashMap["<S11>/Sum"] = {sid: "mean_noise_reduction:1213"};
	this.sidHashMap["mean_noise_reduction:1213"] = {rtwname: "<S11>/Sum"};
	this.rtwnameHashMap["<S11>/Switch"] = {sid: "mean_noise_reduction:1344"};
	this.sidHashMap["mean_noise_reduction:1344"] = {rtwname: "<S11>/Switch"};
	this.rtwnameHashMap["<S11>/Tapped Delay"] = {sid: "mean_noise_reduction:1214"};
	this.sidHashMap["mean_noise_reduction:1214"] = {rtwname: "<S11>/Tapped Delay"};
	this.rtwnameHashMap["<S11>/right_channel_source"] = {sid: "mean_noise_reduction:1215"};
	this.sidHashMap["mean_noise_reduction:1215"] = {rtwname: "<S11>/right_channel_source"};
	this.rtwnameHashMap["<S12>/left_data_sink"] = {sid: "mean_noise_reduction:1350"};
	this.sidHashMap["mean_noise_reduction:1350"] = {rtwname: "<S12>/left_data_sink"};
	this.rtwnameHashMap["<S12>/Constant"] = {sid: "mean_noise_reduction:1351"};
	this.sidHashMap["mean_noise_reduction:1351"] = {rtwname: "<S12>/Constant"};
	this.rtwnameHashMap["<S12>/Constant1"] = {sid: "mean_noise_reduction:1352"};
	this.sidHashMap["mean_noise_reduction:1352"] = {rtwname: "<S12>/Constant1"};
	this.rtwnameHashMap["<S12>/Delay32"] = {sid: "mean_noise_reduction:1353"};
	this.sidHashMap["mean_noise_reduction:1353"] = {rtwname: "<S12>/Delay32"};
	this.rtwnameHashMap["<S12>/Divide"] = {sid: "mean_noise_reduction:1354"};
	this.sidHashMap["mean_noise_reduction:1354"] = {rtwname: "<S12>/Divide"};
	this.rtwnameHashMap["<S12>/Sum"] = {sid: "mean_noise_reduction:1355"};
	this.sidHashMap["mean_noise_reduction:1355"] = {rtwname: "<S12>/Sum"};
	this.rtwnameHashMap["<S12>/Switch"] = {sid: "mean_noise_reduction:1356"};
	this.sidHashMap["mean_noise_reduction:1356"] = {rtwname: "<S12>/Switch"};
	this.rtwnameHashMap["<S12>/Tapped Delay"] = {sid: "mean_noise_reduction:1357"};
	this.sidHashMap["mean_noise_reduction:1357"] = {rtwname: "<S12>/Tapped Delay"};
	this.rtwnameHashMap["<S12>/left_channel_source"] = {sid: "mean_noise_reduction:1358"};
	this.sidHashMap["mean_noise_reduction:1358"] = {rtwname: "<S12>/left_channel_source"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
