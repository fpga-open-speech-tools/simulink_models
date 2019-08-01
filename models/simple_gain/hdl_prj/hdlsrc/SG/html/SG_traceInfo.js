function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S5>/avalon_sink_valid */
	this.urlHashMap["SG:235"] = "msg=rtwMsg_notTraceable&block=SG:235";
	/* <S5>/avalon_sink_error */
	this.urlHashMap["SG:237"] = "msg=rtwMsg_notTraceable&block=SG:237";
	/* <S5>/Avalon Data Processing */
	this.urlHashMap["SG:407"] = "msg=rtwMsg_notTraceable&block=SG:407";
	/* <S6>/Sink_Channel */
	this.urlHashMap["SG:416"] = "msg=rtwMsg_notTraceable&block=SG:416";
	/* <S6>/Left Channel Processing */
	this.urlHashMap["SG:434"] = "msg=rtwMsg_notTraceable&block=SG:434";
	/* <S6>/Multiport
Switch */
	this.urlHashMap["SG:453"] = "msg=rtwMsg_notTraceable&block=SG:453";
	/* <S6>/Right Channel Processing */
	this.urlHashMap["SG:446"] = "msg=rtwMsg_notTraceable&block=SG:446";
	/* <S7>/Compare */
	this.urlHashMap["SG:445:2"] = "msg=rtwMsg_notTraceable&block=SG:445:2";
	/* <S7>/Constant */
	this.urlHashMap["SG:445:3"] = "msg=rtwMsg_notTraceable&block=SG:445:3";
	/* <S8>/Compare */
	this.urlHashMap["SG:433:2"] = "msg=rtwMsg_notTraceable&block=SG:433:2";
	/* <S8>/Constant */
	this.urlHashMap["SG:433:3"] = "msg=rtwMsg_notTraceable&block=SG:433:3";
	/* <S9>/Data Type Conversion */
	this.urlHashMap["SG:1012"] = "msg=rtwMsg_notTraceable&block=SG:1012";
	/* <S9>/Product */
	this.urlHashMap["SG:1011"] = "msg=rtwMsg_notTraceable&block=SG:1011";
	/* <S10>/Data Type Conversion */
	this.urlHashMap["SG:1016"] = "msg=rtwMsg_notTraceable&block=SG:1016";
	/* <S10>/Product */
	this.urlHashMap["SG:1017"] = "msg=rtwMsg_notTraceable&block=SG:1017";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "SG"};
	this.sidHashMap["SG"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S5>/avalon_sink_valid"] = {sid: "SG:235"};
	this.sidHashMap["SG:235"] = {rtwname: "<S5>/avalon_sink_valid"};
	this.rtwnameHashMap["<S5>/avalon_sink_data"] = {sid: "SG:234"};
	this.sidHashMap["SG:234"] = {rtwname: "<S5>/avalon_sink_data"};
	this.rtwnameHashMap["<S5>/avalon_sink_channel"] = {sid: "SG:236"};
	this.sidHashMap["SG:236"] = {rtwname: "<S5>/avalon_sink_channel"};
	this.rtwnameHashMap["<S5>/avalon_sink_error"] = {sid: "SG:237"};
	this.sidHashMap["SG:237"] = {rtwname: "<S5>/avalon_sink_error"};
	this.rtwnameHashMap["<S5>/register_control_left_gain"] = {sid: "SG:1023"};
	this.sidHashMap["SG:1023"] = {rtwname: "<S5>/register_control_left_gain"};
	this.rtwnameHashMap["<S5>/register_control_right_gain"] = {sid: "SG:1024"};
	this.sidHashMap["SG:1024"] = {rtwname: "<S5>/register_control_right_gain"};
	this.rtwnameHashMap["<S5>/Avalon Data Processing"] = {sid: "SG:407"};
	this.sidHashMap["SG:407"] = {rtwname: "<S5>/Avalon Data Processing"};
	this.rtwnameHashMap["<S5>/avalon_source_valid"] = {sid: "SG:412"};
	this.sidHashMap["SG:412"] = {rtwname: "<S5>/avalon_source_valid"};
	this.rtwnameHashMap["<S5>/avalon_source_data"] = {sid: "SG:411"};
	this.sidHashMap["SG:411"] = {rtwname: "<S5>/avalon_source_data"};
	this.rtwnameHashMap["<S5>/avalon_source_channel"] = {sid: "SG:413"};
	this.sidHashMap["SG:413"] = {rtwname: "<S5>/avalon_source_channel"};
	this.rtwnameHashMap["<S5>/avalon_source_error"] = {sid: "SG:414"};
	this.sidHashMap["SG:414"] = {rtwname: "<S5>/avalon_source_error"};
	this.rtwnameHashMap["<S6>/Sink_Data"] = {sid: "SG:415"};
	this.sidHashMap["SG:415"] = {rtwname: "<S6>/Sink_Data"};
	this.rtwnameHashMap["<S6>/Sink_Channel"] = {sid: "SG:416"};
	this.sidHashMap["SG:416"] = {rtwname: "<S6>/Sink_Channel"};
	this.rtwnameHashMap["<S6>/Left_Gain"] = {sid: "SG:1021"};
	this.sidHashMap["SG:1021"] = {rtwname: "<S6>/Left_Gain"};
	this.rtwnameHashMap["<S6>/Right_Gain"] = {sid: "SG:1022"};
	this.sidHashMap["SG:1022"] = {rtwname: "<S6>/Right_Gain"};
	this.rtwnameHashMap["<S6>/Enable"] = {sid: "SG:409"};
	this.sidHashMap["SG:409"] = {rtwname: "<S6>/Enable"};
	this.rtwnameHashMap["<S6>/Compare To Constant1"] = {sid: "SG:445"};
	this.sidHashMap["SG:445"] = {rtwname: "<S6>/Compare To Constant1"};
	this.rtwnameHashMap["<S6>/Compare To Constant2"] = {sid: "SG:433"};
	this.sidHashMap["SG:433"] = {rtwname: "<S6>/Compare To Constant2"};
	this.rtwnameHashMap["<S6>/Left Channel Processing"] = {sid: "SG:434"};
	this.sidHashMap["SG:434"] = {rtwname: "<S6>/Left Channel Processing"};
	this.rtwnameHashMap["<S6>/Multiport Switch"] = {sid: "SG:453"};
	this.sidHashMap["SG:453"] = {rtwname: "<S6>/Multiport Switch"};
	this.rtwnameHashMap["<S6>/Right Channel Processing"] = {sid: "SG:446"};
	this.sidHashMap["SG:446"] = {rtwname: "<S6>/Right Channel Processing"};
	this.rtwnameHashMap["<S6>/Source_Data"] = {sid: "SG:417"};
	this.sidHashMap["SG:417"] = {rtwname: "<S6>/Source_Data"};
	this.rtwnameHashMap["<S6>/Source_Channel"] = {sid: "SG:418"};
	this.sidHashMap["SG:418"] = {rtwname: "<S6>/Source_Channel"};
	this.rtwnameHashMap["<S7>/u"] = {sid: "SG:445:1"};
	this.sidHashMap["SG:445:1"] = {rtwname: "<S7>/u"};
	this.rtwnameHashMap["<S7>/Compare"] = {sid: "SG:445:2"};
	this.sidHashMap["SG:445:2"] = {rtwname: "<S7>/Compare"};
	this.rtwnameHashMap["<S7>/Constant"] = {sid: "SG:445:3"};
	this.sidHashMap["SG:445:3"] = {rtwname: "<S7>/Constant"};
	this.rtwnameHashMap["<S7>/y"] = {sid: "SG:445:4"};
	this.sidHashMap["SG:445:4"] = {rtwname: "<S7>/y"};
	this.rtwnameHashMap["<S8>/u"] = {sid: "SG:433:1"};
	this.sidHashMap["SG:433:1"] = {rtwname: "<S8>/u"};
	this.rtwnameHashMap["<S8>/Compare"] = {sid: "SG:433:2"};
	this.sidHashMap["SG:433:2"] = {rtwname: "<S8>/Compare"};
	this.rtwnameHashMap["<S8>/Constant"] = {sid: "SG:433:3"};
	this.sidHashMap["SG:433:3"] = {rtwname: "<S8>/Constant"};
	this.rtwnameHashMap["<S8>/y"] = {sid: "SG:433:4"};
	this.sidHashMap["SG:433:4"] = {rtwname: "<S8>/y"};
	this.rtwnameHashMap["<S9>/Left_Data_In"] = {sid: "SG:435"};
	this.sidHashMap["SG:435"] = {rtwname: "<S9>/Left_Data_In"};
	this.rtwnameHashMap["<S9>/Left_Gain"] = {sid: "SG:1013"};
	this.sidHashMap["SG:1013"] = {rtwname: "<S9>/Left_Gain"};
	this.rtwnameHashMap["<S9>/Enable"] = {sid: "SG:436"};
	this.sidHashMap["SG:436"] = {rtwname: "<S9>/Enable"};
	this.rtwnameHashMap["<S9>/Data Type Conversion"] = {sid: "SG:1012"};
	this.sidHashMap["SG:1012"] = {rtwname: "<S9>/Data Type Conversion"};
	this.rtwnameHashMap["<S9>/Product"] = {sid: "SG:1011"};
	this.sidHashMap["SG:1011"] = {rtwname: "<S9>/Product"};
	this.rtwnameHashMap["<S9>/Left_Data_Out  "] = {sid: "SG:437"};
	this.sidHashMap["SG:437"] = {rtwname: "<S9>/Left_Data_Out  "};
	this.rtwnameHashMap["<S10>/Right_Data_In"] = {sid: "SG:457"};
	this.sidHashMap["SG:457"] = {rtwname: "<S10>/Right_Data_In"};
	this.rtwnameHashMap["<S10>/Right_Gain"] = {sid: "SG:1015"};
	this.sidHashMap["SG:1015"] = {rtwname: "<S10>/Right_Gain"};
	this.rtwnameHashMap["<S10>/Enable"] = {sid: "SG:448"};
	this.sidHashMap["SG:448"] = {rtwname: "<S10>/Enable"};
	this.rtwnameHashMap["<S10>/Data Type Conversion"] = {sid: "SG:1016"};
	this.sidHashMap["SG:1016"] = {rtwname: "<S10>/Data Type Conversion"};
	this.rtwnameHashMap["<S10>/Product"] = {sid: "SG:1017"};
	this.sidHashMap["SG:1017"] = {rtwname: "<S10>/Product"};
	this.rtwnameHashMap["<S10>/Right_Data_Out  "] = {sid: "SG:461"};
	this.sidHashMap["SG:461"] = {rtwname: "<S10>/Right_Data_Out  "};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
