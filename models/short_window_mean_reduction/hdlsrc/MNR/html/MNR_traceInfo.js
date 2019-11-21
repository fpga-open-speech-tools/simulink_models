function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S5>/avalon_sink_valid */
	this.urlHashMap["MNR:235"] = "msg=rtwMsg_notTraceable&block=MNR:235";
	/* <S5>/avalon_sink_error */
	this.urlHashMap["MNR:237"] = "msg=rtwMsg_notTraceable&block=MNR:237";
	/* <S5>/Adaptive_Wiener_Filter
Sample Based Filtering */
	this.urlHashMap["MNR:1038"] = "msg=rtwMsg_notTraceable&block=MNR:1038";
	/* <S6>/Sink_Channel */
	this.urlHashMap["MNR:1040"] = "msg=rtwMsg_notTraceable&block=MNR:1040";
	/* <S6>/Multiport
Switch */
	this.urlHashMap["MNR:1058"] = "msg=rtwMsg_notTraceable&block=MNR:1058";
	/* <S6>/Right Channel Processing */
	this.urlHashMap["MNR:1170"] = "msg=rtwMsg_notTraceable&block=MNR:1170";
	/* <S6>/Right Channel Processing1 */
	this.urlHashMap["MNR:1345"] = "msg=rtwMsg_notTraceable&block=MNR:1345";
	/* <S7>/Compare */
	this.urlHashMap["MNR:1044:2"] = "msg=rtwMsg_notTraceable&block=MNR:1044:2";
	/* <S7>/Constant */
	this.urlHashMap["MNR:1044:3"] = "msg=rtwMsg_notTraceable&block=MNR:1044:3";
	/* <S8>/Compare */
	this.urlHashMap["MNR:1045:2"] = "msg=rtwMsg_notTraceable&block=MNR:1045:2";
	/* <S8>/Constant */
	this.urlHashMap["MNR:1045:3"] = "msg=rtwMsg_notTraceable&block=MNR:1045:3";
	/* <S9>/Switch */
	this.urlHashMap["MNR:1285"] = "msg=rtwMsg_notTraceable&block=MNR:1285";
	/* <S10>/Switch */
	this.urlHashMap["MNR:1359"] = "msg=rtwMsg_notTraceable&block=MNR:1359";
	/* <S11>/Constant */
	this.urlHashMap["MNR:1209"] = "msg=rtwMsg_notTraceable&block=MNR:1209";
	/* <S11>/Constant1 */
	this.urlHashMap["MNR:1210"] = "msg=rtwMsg_notTraceable&block=MNR:1210";
	/* <S11>/Delay32 */
	this.urlHashMap["MNR:1211"] = "msg=rtwMsg_notTraceable&block=MNR:1211";
	/* <S11>/Divide */
	this.urlHashMap["MNR:1212"] = "msg=rtwMsg_notTraceable&block=MNR:1212";
	/* <S11>/Sum */
	this.urlHashMap["MNR:1213"] = "msg=rtwMsg_notTraceable&block=MNR:1213";
	/* <S11>/Switch */
	this.urlHashMap["MNR:1344"] = "msg=rtwMsg_notTraceable&block=MNR:1344";
	/* <S11>/Tapped Delay */
	this.urlHashMap["MNR:1214"] = "msg=rtwMsg_notTraceable&block=MNR:1214";
	/* <S12>/Constant */
	this.urlHashMap["MNR:1351"] = "msg=rtwMsg_notTraceable&block=MNR:1351";
	/* <S12>/Constant1 */
	this.urlHashMap["MNR:1352"] = "msg=rtwMsg_notTraceable&block=MNR:1352";
	/* <S12>/Delay32 */
	this.urlHashMap["MNR:1353"] = "msg=rtwMsg_notTraceable&block=MNR:1353";
	/* <S12>/Divide */
	this.urlHashMap["MNR:1354"] = "msg=rtwMsg_notTraceable&block=MNR:1354";
	/* <S12>/Sum */
	this.urlHashMap["MNR:1355"] = "msg=rtwMsg_notTraceable&block=MNR:1355";
	/* <S12>/Switch */
	this.urlHashMap["MNR:1356"] = "msg=rtwMsg_notTraceable&block=MNR:1356";
	/* <S12>/Tapped Delay */
	this.urlHashMap["MNR:1357"] = "msg=rtwMsg_notTraceable&block=MNR:1357";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "MNR"};
	this.sidHashMap["MNR"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S5>/avalon_sink_valid"] = {sid: "MNR:235"};
	this.sidHashMap["MNR:235"] = {rtwname: "<S5>/avalon_sink_valid"};
	this.rtwnameHashMap["<S5>/avalon_sink_data"] = {sid: "MNR:234"};
	this.sidHashMap["MNR:234"] = {rtwname: "<S5>/avalon_sink_data"};
	this.rtwnameHashMap["<S5>/avalon_sink_channel"] = {sid: "MNR:236"};
	this.sidHashMap["MNR:236"] = {rtwname: "<S5>/avalon_sink_channel"};
	this.rtwnameHashMap["<S5>/avalon_sink_error"] = {sid: "MNR:237"};
	this.sidHashMap["MNR:237"] = {rtwname: "<S5>/avalon_sink_error"};
	this.rtwnameHashMap["<S5>/register_control_enable"] = {sid: "MNR:1024"};
	this.sidHashMap["MNR:1024"] = {rtwname: "<S5>/register_control_enable"};
	this.rtwnameHashMap["<S5>/Adaptive_Wiener_Filter Sample Based Filtering"] = {sid: "MNR:1038"};
	this.sidHashMap["MNR:1038"] = {rtwname: "<S5>/Adaptive_Wiener_Filter Sample Based Filtering"};
	this.rtwnameHashMap["<S5>/avalon_source_valid"] = {sid: "MNR:412"};
	this.sidHashMap["MNR:412"] = {rtwname: "<S5>/avalon_source_valid"};
	this.rtwnameHashMap["<S5>/avalon_source_data"] = {sid: "MNR:411"};
	this.sidHashMap["MNR:411"] = {rtwname: "<S5>/avalon_source_data"};
	this.rtwnameHashMap["<S5>/avalon_source_channel"] = {sid: "MNR:413"};
	this.sidHashMap["MNR:413"] = {rtwname: "<S5>/avalon_source_channel"};
	this.rtwnameHashMap["<S5>/avalon_source_error"] = {sid: "MNR:414"};
	this.sidHashMap["MNR:414"] = {rtwname: "<S5>/avalon_source_error"};
	this.rtwnameHashMap["<S6>/Sink_Data"] = {sid: "MNR:1039"};
	this.sidHashMap["MNR:1039"] = {rtwname: "<S6>/Sink_Data"};
	this.rtwnameHashMap["<S6>/Sink_Channel"] = {sid: "MNR:1040"};
	this.sidHashMap["MNR:1040"] = {rtwname: "<S6>/Sink_Channel"};
	this.rtwnameHashMap["<S6>/register_control_enable"] = {sid: "MNR:1042"};
	this.sidHashMap["MNR:1042"] = {rtwname: "<S6>/register_control_enable"};
	this.rtwnameHashMap["<S6>/Enable"] = {sid: "MNR:1043"};
	this.sidHashMap["MNR:1043"] = {rtwname: "<S6>/Enable"};
	this.rtwnameHashMap["<S6>/Compare To Constant1"] = {sid: "MNR:1044"};
	this.sidHashMap["MNR:1044"] = {rtwname: "<S6>/Compare To Constant1"};
	this.rtwnameHashMap["<S6>/Compare To Constant2"] = {sid: "MNR:1045"};
	this.sidHashMap["MNR:1045"] = {rtwname: "<S6>/Compare To Constant2"};
	this.rtwnameHashMap["<S6>/Multiport Switch"] = {sid: "MNR:1058"};
	this.sidHashMap["MNR:1058"] = {rtwname: "<S6>/Multiport Switch"};
	this.rtwnameHashMap["<S6>/Right Channel Processing"] = {sid: "MNR:1170"};
	this.sidHashMap["MNR:1170"] = {rtwname: "<S6>/Right Channel Processing"};
	this.rtwnameHashMap["<S6>/Right Channel Processing1"] = {sid: "MNR:1345"};
	this.sidHashMap["MNR:1345"] = {rtwname: "<S6>/Right Channel Processing1"};
	this.rtwnameHashMap["<S6>/Source_Data"] = {sid: "MNR:1110"};
	this.sidHashMap["MNR:1110"] = {rtwname: "<S6>/Source_Data"};
	this.rtwnameHashMap["<S6>/Source_Channel"] = {sid: "MNR:1111"};
	this.sidHashMap["MNR:1111"] = {rtwname: "<S6>/Source_Channel"};
	this.rtwnameHashMap["<S7>/u"] = {sid: "MNR:1044:1"};
	this.sidHashMap["MNR:1044:1"] = {rtwname: "<S7>/u"};
	this.rtwnameHashMap["<S7>/Compare"] = {sid: "MNR:1044:2"};
	this.sidHashMap["MNR:1044:2"] = {rtwname: "<S7>/Compare"};
	this.rtwnameHashMap["<S7>/Constant"] = {sid: "MNR:1044:3"};
	this.sidHashMap["MNR:1044:3"] = {rtwname: "<S7>/Constant"};
	this.rtwnameHashMap["<S7>/y"] = {sid: "MNR:1044:4"};
	this.sidHashMap["MNR:1044:4"] = {rtwname: "<S7>/y"};
	this.rtwnameHashMap["<S8>/u"] = {sid: "MNR:1045:1"};
	this.sidHashMap["MNR:1045:1"] = {rtwname: "<S8>/u"};
	this.rtwnameHashMap["<S8>/Compare"] = {sid: "MNR:1045:2"};
	this.sidHashMap["MNR:1045:2"] = {rtwname: "<S8>/Compare"};
	this.rtwnameHashMap["<S8>/Constant"] = {sid: "MNR:1045:3"};
	this.sidHashMap["MNR:1045:3"] = {rtwname: "<S8>/Constant"};
	this.rtwnameHashMap["<S8>/y"] = {sid: "MNR:1045:4"};
	this.sidHashMap["MNR:1045:4"] = {rtwname: "<S8>/y"};
	this.rtwnameHashMap["<S9>/Right_Data_Sink"] = {sid: "MNR:1171"};
	this.sidHashMap["MNR:1171"] = {rtwname: "<S9>/Right_Data_Sink"};
	this.rtwnameHashMap["<S9>/register_control_bypass"] = {sid: "MNR:1284"};
	this.sidHashMap["MNR:1284"] = {rtwname: "<S9>/register_control_bypass"};
	this.rtwnameHashMap["<S9>/Enable"] = {sid: "MNR:1173"};
	this.sidHashMap["MNR:1173"] = {rtwname: "<S9>/Enable"};
	this.rtwnameHashMap["<S9>/Grab the Look-behind Window and Calculate the Mean"] = {sid: "MNR:1207"};
	this.sidHashMap["MNR:1207"] = {rtwname: "<S9>/Grab the Look-behind Window and Calculate the Mean"};
	this.rtwnameHashMap["<S9>/Switch"] = {sid: "MNR:1285"};
	this.sidHashMap["MNR:1285"] = {rtwname: "<S9>/Switch"};
	this.rtwnameHashMap["<S9>/Right_Data_Source  "] = {sid: "MNR:1218"};
	this.sidHashMap["MNR:1218"] = {rtwname: "<S9>/Right_Data_Source  "};
	this.rtwnameHashMap["<S10>/Left_Data_sink"] = {sid: "MNR:1346"};
	this.sidHashMap["MNR:1346"] = {rtwname: "<S10>/Left_Data_sink"};
	this.rtwnameHashMap["<S10>/register_control_bypass"] = {sid: "MNR:1347"};
	this.sidHashMap["MNR:1347"] = {rtwname: "<S10>/register_control_bypass"};
	this.rtwnameHashMap["<S10>/Enable"] = {sid: "MNR:1348"};
	this.sidHashMap["MNR:1348"] = {rtwname: "<S10>/Enable"};
	this.rtwnameHashMap["<S10>/Grab the Look-behind Window and Calculate the Mean"] = {sid: "MNR:1349"};
	this.sidHashMap["MNR:1349"] = {rtwname: "<S10>/Grab the Look-behind Window and Calculate the Mean"};
	this.rtwnameHashMap["<S10>/Switch"] = {sid: "MNR:1359"};
	this.sidHashMap["MNR:1359"] = {rtwname: "<S10>/Switch"};
	this.rtwnameHashMap["<S10>/Left_Data_Source  "] = {sid: "MNR:1360"};
	this.sidHashMap["MNR:1360"] = {rtwname: "<S10>/Left_Data_Source  "};
	this.rtwnameHashMap["<S11>/right_data_sink"] = {sid: "MNR:1208"};
	this.sidHashMap["MNR:1208"] = {rtwname: "<S11>/right_data_sink"};
	this.rtwnameHashMap["<S11>/Constant"] = {sid: "MNR:1209"};
	this.sidHashMap["MNR:1209"] = {rtwname: "<S11>/Constant"};
	this.rtwnameHashMap["<S11>/Constant1"] = {sid: "MNR:1210"};
	this.sidHashMap["MNR:1210"] = {rtwname: "<S11>/Constant1"};
	this.rtwnameHashMap["<S11>/Delay32"] = {sid: "MNR:1211"};
	this.sidHashMap["MNR:1211"] = {rtwname: "<S11>/Delay32"};
	this.rtwnameHashMap["<S11>/Divide"] = {sid: "MNR:1212"};
	this.sidHashMap["MNR:1212"] = {rtwname: "<S11>/Divide"};
	this.rtwnameHashMap["<S11>/Sum"] = {sid: "MNR:1213"};
	this.sidHashMap["MNR:1213"] = {rtwname: "<S11>/Sum"};
	this.rtwnameHashMap["<S11>/Switch"] = {sid: "MNR:1344"};
	this.sidHashMap["MNR:1344"] = {rtwname: "<S11>/Switch"};
	this.rtwnameHashMap["<S11>/Tapped Delay"] = {sid: "MNR:1214"};
	this.sidHashMap["MNR:1214"] = {rtwname: "<S11>/Tapped Delay"};
	this.rtwnameHashMap["<S11>/right_channel_source"] = {sid: "MNR:1215"};
	this.sidHashMap["MNR:1215"] = {rtwname: "<S11>/right_channel_source"};
	this.rtwnameHashMap["<S12>/left_data_sink"] = {sid: "MNR:1350"};
	this.sidHashMap["MNR:1350"] = {rtwname: "<S12>/left_data_sink"};
	this.rtwnameHashMap["<S12>/Constant"] = {sid: "MNR:1351"};
	this.sidHashMap["MNR:1351"] = {rtwname: "<S12>/Constant"};
	this.rtwnameHashMap["<S12>/Constant1"] = {sid: "MNR:1352"};
	this.sidHashMap["MNR:1352"] = {rtwname: "<S12>/Constant1"};
	this.rtwnameHashMap["<S12>/Delay32"] = {sid: "MNR:1353"};
	this.sidHashMap["MNR:1353"] = {rtwname: "<S12>/Delay32"};
	this.rtwnameHashMap["<S12>/Divide"] = {sid: "MNR:1354"};
	this.sidHashMap["MNR:1354"] = {rtwname: "<S12>/Divide"};
	this.rtwnameHashMap["<S12>/Sum"] = {sid: "MNR:1355"};
	this.sidHashMap["MNR:1355"] = {rtwname: "<S12>/Sum"};
	this.rtwnameHashMap["<S12>/Switch"] = {sid: "MNR:1356"};
	this.sidHashMap["MNR:1356"] = {rtwname: "<S12>/Switch"};
	this.rtwnameHashMap["<S12>/Tapped Delay"] = {sid: "MNR:1357"};
	this.sidHashMap["MNR:1357"] = {rtwname: "<S12>/Tapped Delay"};
	this.rtwnameHashMap["<S12>/left_channel_source"] = {sid: "MNR:1358"};
	this.sidHashMap["MNR:1358"] = {rtwname: "<S12>/left_channel_source"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
