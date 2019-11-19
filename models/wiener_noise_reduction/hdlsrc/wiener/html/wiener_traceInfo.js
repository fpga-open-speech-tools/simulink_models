function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S5>/avalon_sink_valid */
	this.urlHashMap["wiener:235"] = "msg=rtwMsg_notTraceable&block=wiener:235";
	/* <S5>/avalon_sink_error */
	this.urlHashMap["wiener:237"] = "msg=rtwMsg_notTraceable&block=wiener:237";
	/* <S5>/Adaptive_Wiener_Filter
Sample Based Filtering */
	this.urlHashMap["wiener:1038"] = "msg=rtwMsg_notTraceable&block=wiener:1038";
	/* <S6>/Sink_Channel */
	this.urlHashMap["wiener:1040"] = "msg=rtwMsg_notTraceable&block=wiener:1040";
	/* <S6>/Left Channel Processing */
	this.urlHashMap["wiener:1118"] = "msg=rtwMsg_notTraceable&block=wiener:1118";
	/* <S6>/Multiport
Switch */
	this.urlHashMap["wiener:1058"] = "msg=rtwMsg_notTraceable&block=wiener:1058";
	/* <S6>/Right Channel Processing */
	this.urlHashMap["wiener:1170"] = "msg=rtwMsg_notTraceable&block=wiener:1170";
	/* <S7>/Compare */
	this.urlHashMap["wiener:1044:2"] = "msg=rtwMsg_notTraceable&block=wiener:1044:2";
	/* <S7>/Constant */
	this.urlHashMap["wiener:1044:3"] = "msg=rtwMsg_notTraceable&block=wiener:1044:3";
	/* <S8>/Compare */
	this.urlHashMap["wiener:1045:2"] = "msg=rtwMsg_notTraceable&block=wiener:1045:2";
	/* <S8>/Constant */
	this.urlHashMap["wiener:1045:3"] = "msg=rtwMsg_notTraceable&block=wiener:1045:3";
	/* <S9>/Subsystem */
	this.urlHashMap["wiener:1122"] = "msg=rtwMsg_notTraceable&block=wiener:1122";
	/* <S10>/Wien Filter */
	this.urlHashMap["wiener:1174"] = "msg=rtwMsg_notTraceable&block=wiener:1174";
	/* <S11>/Constant */
	this.urlHashMap["wiener:1157"] = "msg=rtwMsg_notTraceable&block=wiener:1157";
	/* <S11>/Constant1 */
	this.urlHashMap["wiener:1158"] = "msg=rtwMsg_notTraceable&block=wiener:1158";
	/* <S11>/Delay32 */
	this.urlHashMap["wiener:1159"] = "msg=rtwMsg_notTraceable&block=wiener:1159";
	/* <S11>/Divide */
	this.urlHashMap["wiener:1160"] = "msg=rtwMsg_notTraceable&block=wiener:1160";
	/* <S11>/Sum */
	this.urlHashMap["wiener:1161"] = "msg=rtwMsg_notTraceable&block=wiener:1161";
	/* <S11>/Tapped Delay */
	this.urlHashMap["wiener:1162"] = "msg=rtwMsg_notTraceable&block=wiener:1162";
	/* <S12>/win_mean */
	this.urlHashMap["wiener:1126"] = "msg=rtwMsg_notTraceable&block=wiener:1126";
	/* <S14>/Constant */
	this.urlHashMap["wiener:1145"] = "msg=rtwMsg_notTraceable&block=wiener:1145";
	/* <S14>/Constant1 */
	this.urlHashMap["wiener:1146"] = "msg=rtwMsg_notTraceable&block=wiener:1146";
	/* <S14>/Product */
	this.urlHashMap["wiener:1147"] = "msg=rtwMsg_notTraceable&block=wiener:1147";
	/* <S14>/Product2 */
	this.urlHashMap["wiener:1148"] = "msg=rtwMsg_notTraceable&block=wiener:1148";
	/* <S14>/Relational
Operator */
	this.urlHashMap["wiener:1149"] = "msg=rtwMsg_notTraceable&block=wiener:1149";
	/* <S14>/Subtract */
	this.urlHashMap["wiener:1150"] = "msg=rtwMsg_notTraceable&block=wiener:1150";
	/* <S14>/Sum */
	this.urlHashMap["wiener:1151"] = "msg=rtwMsg_notTraceable&block=wiener:1151";
	/* <S14>/Switch */
	this.urlHashMap["wiener:1152"] = "msg=rtwMsg_notTraceable&block=wiener:1152";
	/* <S15>/Constant */
	this.urlHashMap["wiener:1209"] = "msg=rtwMsg_notTraceable&block=wiener:1209";
	/* <S15>/Constant1 */
	this.urlHashMap["wiener:1210"] = "msg=rtwMsg_notTraceable&block=wiener:1210";
	/* <S15>/Delay32 */
	this.urlHashMap["wiener:1211"] = "msg=rtwMsg_notTraceable&block=wiener:1211";
	/* <S15>/Divide */
	this.urlHashMap["wiener:1212"] = "msg=rtwMsg_notTraceable&block=wiener:1212";
	/* <S15>/Sum */
	this.urlHashMap["wiener:1213"] = "msg=rtwMsg_notTraceable&block=wiener:1213";
	/* <S15>/Tapped Delay */
	this.urlHashMap["wiener:1214"] = "msg=rtwMsg_notTraceable&block=wiener:1214";
	/* <S16>/win_mean */
	this.urlHashMap["wiener:1178"] = "msg=rtwMsg_notTraceable&block=wiener:1178";
	/* <S18>/Constant */
	this.urlHashMap["wiener:1197"] = "msg=rtwMsg_notTraceable&block=wiener:1197";
	/* <S18>/Constant1 */
	this.urlHashMap["wiener:1198"] = "msg=rtwMsg_notTraceable&block=wiener:1198";
	/* <S18>/Product */
	this.urlHashMap["wiener:1199"] = "msg=rtwMsg_notTraceable&block=wiener:1199";
	/* <S18>/Product2 */
	this.urlHashMap["wiener:1200"] = "msg=rtwMsg_notTraceable&block=wiener:1200";
	/* <S18>/Relational
Operator */
	this.urlHashMap["wiener:1201"] = "msg=rtwMsg_notTraceable&block=wiener:1201";
	/* <S18>/Subtract */
	this.urlHashMap["wiener:1202"] = "msg=rtwMsg_notTraceable&block=wiener:1202";
	/* <S18>/Sum */
	this.urlHashMap["wiener:1203"] = "msg=rtwMsg_notTraceable&block=wiener:1203";
	/* <S18>/Switch */
	this.urlHashMap["wiener:1204"] = "msg=rtwMsg_notTraceable&block=wiener:1204";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "wiener"};
	this.sidHashMap["wiener"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S5>/avalon_sink_valid"] = {sid: "wiener:235"};
	this.sidHashMap["wiener:235"] = {rtwname: "<S5>/avalon_sink_valid"};
	this.rtwnameHashMap["<S5>/avalon_sink_data"] = {sid: "wiener:234"};
	this.sidHashMap["wiener:234"] = {rtwname: "<S5>/avalon_sink_data"};
	this.rtwnameHashMap["<S5>/avalon_sink_channel"] = {sid: "wiener:236"};
	this.sidHashMap["wiener:236"] = {rtwname: "<S5>/avalon_sink_channel"};
	this.rtwnameHashMap["<S5>/avalon_sink_error"] = {sid: "wiener:237"};
	this.sidHashMap["wiener:237"] = {rtwname: "<S5>/avalon_sink_error"};
	this.rtwnameHashMap["<S5>/noise_std"] = {sid: "wiener:1024"};
	this.sidHashMap["wiener:1024"] = {rtwname: "<S5>/noise_std"};
	this.rtwnameHashMap["<S5>/Adaptive_Wiener_Filter Sample Based Filtering"] = {sid: "wiener:1038"};
	this.sidHashMap["wiener:1038"] = {rtwname: "<S5>/Adaptive_Wiener_Filter Sample Based Filtering"};
	this.rtwnameHashMap["<S5>/avalon_source_valid"] = {sid: "wiener:412"};
	this.sidHashMap["wiener:412"] = {rtwname: "<S5>/avalon_source_valid"};
	this.rtwnameHashMap["<S5>/avalon_source_data"] = {sid: "wiener:411"};
	this.sidHashMap["wiener:411"] = {rtwname: "<S5>/avalon_source_data"};
	this.rtwnameHashMap["<S5>/avalon_source_channel"] = {sid: "wiener:413"};
	this.sidHashMap["wiener:413"] = {rtwname: "<S5>/avalon_source_channel"};
	this.rtwnameHashMap["<S5>/avalon_source_error"] = {sid: "wiener:414"};
	this.sidHashMap["wiener:414"] = {rtwname: "<S5>/avalon_source_error"};
	this.rtwnameHashMap["<S6>/Sink_Data"] = {sid: "wiener:1039"};
	this.sidHashMap["wiener:1039"] = {rtwname: "<S6>/Sink_Data"};
	this.rtwnameHashMap["<S6>/Sink_Channel"] = {sid: "wiener:1040"};
	this.sidHashMap["wiener:1040"] = {rtwname: "<S6>/Sink_Channel"};
	this.rtwnameHashMap["<S6>/noise_std"] = {sid: "wiener:1042"};
	this.sidHashMap["wiener:1042"] = {rtwname: "<S6>/noise_std"};
	this.rtwnameHashMap["<S6>/Enable"] = {sid: "wiener:1043"};
	this.sidHashMap["wiener:1043"] = {rtwname: "<S6>/Enable"};
	this.rtwnameHashMap["<S6>/Compare To Constant1"] = {sid: "wiener:1044"};
	this.sidHashMap["wiener:1044"] = {rtwname: "<S6>/Compare To Constant1"};
	this.rtwnameHashMap["<S6>/Compare To Constant2"] = {sid: "wiener:1045"};
	this.sidHashMap["wiener:1045"] = {rtwname: "<S6>/Compare To Constant2"};
	this.rtwnameHashMap["<S6>/Left Channel Processing"] = {sid: "wiener:1118"};
	this.sidHashMap["wiener:1118"] = {rtwname: "<S6>/Left Channel Processing"};
	this.rtwnameHashMap["<S6>/Multiport Switch"] = {sid: "wiener:1058"};
	this.sidHashMap["wiener:1058"] = {rtwname: "<S6>/Multiport Switch"};
	this.rtwnameHashMap["<S6>/Right Channel Processing"] = {sid: "wiener:1170"};
	this.sidHashMap["wiener:1170"] = {rtwname: "<S6>/Right Channel Processing"};
	this.rtwnameHashMap["<S6>/Source_Data"] = {sid: "wiener:1110"};
	this.sidHashMap["wiener:1110"] = {rtwname: "<S6>/Source_Data"};
	this.rtwnameHashMap["<S6>/Source_Channel"] = {sid: "wiener:1111"};
	this.sidHashMap["wiener:1111"] = {rtwname: "<S6>/Source_Channel"};
	this.rtwnameHashMap["<S7>/u"] = {sid: "wiener:1044:1"};
	this.sidHashMap["wiener:1044:1"] = {rtwname: "<S7>/u"};
	this.rtwnameHashMap["<S7>/Compare"] = {sid: "wiener:1044:2"};
	this.sidHashMap["wiener:1044:2"] = {rtwname: "<S7>/Compare"};
	this.rtwnameHashMap["<S7>/Constant"] = {sid: "wiener:1044:3"};
	this.sidHashMap["wiener:1044:3"] = {rtwname: "<S7>/Constant"};
	this.rtwnameHashMap["<S7>/y"] = {sid: "wiener:1044:4"};
	this.sidHashMap["wiener:1044:4"] = {rtwname: "<S7>/y"};
	this.rtwnameHashMap["<S8>/u"] = {sid: "wiener:1045:1"};
	this.sidHashMap["wiener:1045:1"] = {rtwname: "<S8>/u"};
	this.rtwnameHashMap["<S8>/Compare"] = {sid: "wiener:1045:2"};
	this.sidHashMap["wiener:1045:2"] = {rtwname: "<S8>/Compare"};
	this.rtwnameHashMap["<S8>/Constant"] = {sid: "wiener:1045:3"};
	this.sidHashMap["wiener:1045:3"] = {rtwname: "<S8>/Constant"};
	this.rtwnameHashMap["<S8>/y"] = {sid: "wiener:1045:4"};
	this.sidHashMap["wiener:1045:4"] = {rtwname: "<S8>/y"};
	this.rtwnameHashMap["<S9>/Left_Data_Sink"] = {sid: "wiener:1119"};
	this.sidHashMap["wiener:1119"] = {rtwname: "<S9>/Left_Data_Sink"};
	this.rtwnameHashMap["<S9>/noise_std"] = {sid: "wiener:1120"};
	this.sidHashMap["wiener:1120"] = {rtwname: "<S9>/noise_std"};
	this.rtwnameHashMap["<S9>/Enable"] = {sid: "wiener:1121"};
	this.sidHashMap["wiener:1121"] = {rtwname: "<S9>/Enable"};
	this.rtwnameHashMap["<S9>/Grab the Look-behind Window and Calculate the Mean"] = {sid: "wiener:1155"};
	this.sidHashMap["wiener:1155"] = {rtwname: "<S9>/Grab the Look-behind Window and Calculate the Mean"};
	this.rtwnameHashMap["<S9>/Subsystem"] = {sid: "wiener:1122"};
	this.sidHashMap["wiener:1122"] = {rtwname: "<S9>/Subsystem"};
	this.rtwnameHashMap["<S9>/Left_Data_Out  "] = {sid: "wiener:1167"};
	this.sidHashMap["wiener:1167"] = {rtwname: "<S9>/Left_Data_Out  "};
	this.rtwnameHashMap["<S10>/Right_Data_Sink"] = {sid: "wiener:1171"};
	this.sidHashMap["wiener:1171"] = {rtwname: "<S10>/Right_Data_Sink"};
	this.rtwnameHashMap["<S10>/noise_std"] = {sid: "wiener:1172"};
	this.sidHashMap["wiener:1172"] = {rtwname: "<S10>/noise_std"};
	this.rtwnameHashMap["<S10>/Enable"] = {sid: "wiener:1173"};
	this.sidHashMap["wiener:1173"] = {rtwname: "<S10>/Enable"};
	this.rtwnameHashMap["<S10>/Grab the Look-behind Window and Calculate the Mean"] = {sid: "wiener:1207"};
	this.sidHashMap["wiener:1207"] = {rtwname: "<S10>/Grab the Look-behind Window and Calculate the Mean"};
	this.rtwnameHashMap["<S10>/Wien Filter"] = {sid: "wiener:1174"};
	this.sidHashMap["wiener:1174"] = {rtwname: "<S10>/Wien Filter"};
	this.rtwnameHashMap["<S10>/Left_Data_Out  "] = {sid: "wiener:1218"};
	this.sidHashMap["wiener:1218"] = {rtwname: "<S10>/Left_Data_Out  "};
	this.rtwnameHashMap["<S11>/left_data_sink"] = {sid: "wiener:1156"};
	this.sidHashMap["wiener:1156"] = {rtwname: "<S11>/left_data_sink"};
	this.rtwnameHashMap["<S11>/Constant"] = {sid: "wiener:1157"};
	this.sidHashMap["wiener:1157"] = {rtwname: "<S11>/Constant"};
	this.rtwnameHashMap["<S11>/Constant1"] = {sid: "wiener:1158"};
	this.sidHashMap["wiener:1158"] = {rtwname: "<S11>/Constant1"};
	this.rtwnameHashMap["<S11>/Delay32"] = {sid: "wiener:1159"};
	this.sidHashMap["wiener:1159"] = {rtwname: "<S11>/Delay32"};
	this.rtwnameHashMap["<S11>/Divide"] = {sid: "wiener:1160"};
	this.sidHashMap["wiener:1160"] = {rtwname: "<S11>/Divide"};
	this.rtwnameHashMap["<S11>/Sum"] = {sid: "wiener:1161"};
	this.sidHashMap["wiener:1161"] = {rtwname: "<S11>/Sum"};
	this.rtwnameHashMap["<S11>/Tapped Delay"] = {sid: "wiener:1162"};
	this.sidHashMap["wiener:1162"] = {rtwname: "<S11>/Tapped Delay"};
	this.rtwnameHashMap["<S11>/win_mean"] = {sid: "wiener:1164"};
	this.sidHashMap["wiener:1164"] = {rtwname: "<S11>/win_mean"};
	this.rtwnameHashMap["<S11>/win"] = {sid: "wiener:1165"};
	this.sidHashMap["wiener:1165"] = {rtwname: "<S11>/win"};
	this.rtwnameHashMap["<S11>/startup"] = {sid: "wiener:1166"};
	this.sidHashMap["wiener:1166"] = {rtwname: "<S11>/startup"};
	this.rtwnameHashMap["<S12>/left_data_sink"] = {sid: "wiener:1123"};
	this.sidHashMap["wiener:1123"] = {rtwname: "<S12>/left_data_sink"};
	this.rtwnameHashMap["<S12>/noise_std"] = {sid: "wiener:1124"};
	this.sidHashMap["wiener:1124"] = {rtwname: "<S12>/noise_std"};
	this.rtwnameHashMap["<S12>/win"] = {sid: "wiener:1125"};
	this.sidHashMap["wiener:1125"] = {rtwname: "<S12>/win"};
	this.rtwnameHashMap["<S12>/win_mean"] = {sid: "wiener:1126"};
	this.sidHashMap["wiener:1126"] = {rtwname: "<S12>/win_mean"};
	this.rtwnameHashMap["<S12>/Enable"] = {sid: "wiener:1127"};
	this.sidHashMap["wiener:1127"] = {rtwname: "<S12>/Enable"};
	this.rtwnameHashMap["<S12>/wienFilter1"] = {sid: "wiener:1259"};
	this.sidHashMap["wiener:1259"] = {rtwname: "<S12>/wienFilter1"};
	this.rtwnameHashMap["<S12>/wienStats"] = {sid: "wiener:1141"};
	this.sidHashMap["wiener:1141"] = {rtwname: "<S12>/wienStats"};
	this.rtwnameHashMap["<S12>/left_data_source"] = {sid: "wiener:1154"};
	this.sidHashMap["wiener:1154"] = {rtwname: "<S12>/left_data_source"};
	this.rtwnameHashMap["<S13>/left_sink_data"] = {sid: "wiener:1260"};
	this.sidHashMap["wiener:1260"] = {rtwname: "<S13>/left_sink_data"};
	this.rtwnameHashMap["<S13>/winMean"] = {sid: "wiener:1261"};
	this.sidHashMap["wiener:1261"] = {rtwname: "<S13>/winMean"};
	this.rtwnameHashMap["<S13>/winSTD"] = {sid: "wiener:1262"};
	this.sidHashMap["wiener:1262"] = {rtwname: "<S13>/winSTD"};
	this.rtwnameHashMap["<S13>/winNoise"] = {sid: "wiener:1263"};
	this.sidHashMap["wiener:1263"] = {rtwname: "<S13>/winNoise"};
	this.rtwnameHashMap["<S13>/Add"] = {sid: "wiener:1264"};
	this.sidHashMap["wiener:1264"] = {rtwname: "<S13>/Add"};
	this.rtwnameHashMap["<S13>/Add1"] = {sid: "wiener:1265"};
	this.sidHashMap["wiener:1265"] = {rtwname: "<S13>/Add1"};
	this.rtwnameHashMap["<S13>/Delay"] = {sid: "wiener:1266"};
	this.sidHashMap["wiener:1266"] = {rtwname: "<S13>/Delay"};
	this.rtwnameHashMap["<S13>/Delay1"] = {sid: "wiener:1267"};
	this.sidHashMap["wiener:1267"] = {rtwname: "<S13>/Delay1"};
	this.rtwnameHashMap["<S13>/Delay2"] = {sid: "wiener:1268"};
	this.sidHashMap["wiener:1268"] = {rtwname: "<S13>/Delay2"};
	this.rtwnameHashMap["<S13>/HDL Reciprocal"] = {sid: "wiener:1269"};
	this.sidHashMap["wiener:1269"] = {rtwname: "<S13>/HDL Reciprocal"};
	this.rtwnameHashMap["<S13>/Product"] = {sid: "wiener:1270"};
	this.sidHashMap["wiener:1270"] = {rtwname: "<S13>/Product"};
	this.rtwnameHashMap["<S13>/Product1"] = {sid: "wiener:1271"};
	this.sidHashMap["wiener:1271"] = {rtwname: "<S13>/Product1"};
	this.rtwnameHashMap["<S13>/Subtract"] = {sid: "wiener:1272"};
	this.sidHashMap["wiener:1272"] = {rtwname: "<S13>/Subtract"};
	this.rtwnameHashMap["<S13>/Terminator"] = {sid: "wiener:1273"};
	this.sidHashMap["wiener:1273"] = {rtwname: "<S13>/Terminator"};
	this.rtwnameHashMap["<S13>/Terminator1"] = {sid: "wiener:1274"};
	this.sidHashMap["wiener:1274"] = {rtwname: "<S13>/Terminator1"};
	this.rtwnameHashMap["<S13>/Terminator2"] = {sid: "wiener:1275"};
	this.sidHashMap["wiener:1275"] = {rtwname: "<S13>/Terminator2"};
	this.rtwnameHashMap["<S13>/left_source_data"] = {sid: "wiener:1276"};
	this.sidHashMap["wiener:1276"] = {rtwname: "<S13>/left_source_data"};
	this.rtwnameHashMap["<S14>/win_mean"] = {sid: "wiener:1142"};
	this.sidHashMap["wiener:1142"] = {rtwname: "<S14>/win_mean"};
	this.rtwnameHashMap["<S14>/noise_std"] = {sid: "wiener:1143"};
	this.sidHashMap["wiener:1143"] = {rtwname: "<S14>/noise_std"};
	this.rtwnameHashMap["<S14>/win"] = {sid: "wiener:1144"};
	this.sidHashMap["wiener:1144"] = {rtwname: "<S14>/win"};
	this.rtwnameHashMap["<S14>/Constant"] = {sid: "wiener:1145"};
	this.sidHashMap["wiener:1145"] = {rtwname: "<S14>/Constant"};
	this.rtwnameHashMap["<S14>/Constant1"] = {sid: "wiener:1146"};
	this.sidHashMap["wiener:1146"] = {rtwname: "<S14>/Constant1"};
	this.rtwnameHashMap["<S14>/Product"] = {sid: "wiener:1147"};
	this.sidHashMap["wiener:1147"] = {rtwname: "<S14>/Product"};
	this.rtwnameHashMap["<S14>/Product2"] = {sid: "wiener:1148"};
	this.sidHashMap["wiener:1148"] = {rtwname: "<S14>/Product2"};
	this.rtwnameHashMap["<S14>/Relational Operator"] = {sid: "wiener:1149"};
	this.sidHashMap["wiener:1149"] = {rtwname: "<S14>/Relational Operator"};
	this.rtwnameHashMap["<S14>/Subtract"] = {sid: "wiener:1150"};
	this.sidHashMap["wiener:1150"] = {rtwname: "<S14>/Subtract"};
	this.rtwnameHashMap["<S14>/Sum"] = {sid: "wiener:1151"};
	this.sidHashMap["wiener:1151"] = {rtwname: "<S14>/Sum"};
	this.rtwnameHashMap["<S14>/Switch"] = {sid: "wiener:1152"};
	this.sidHashMap["wiener:1152"] = {rtwname: "<S14>/Switch"};
	this.rtwnameHashMap["<S14>/winNoise"] = {sid: "wiener:1153"};
	this.sidHashMap["wiener:1153"] = {rtwname: "<S14>/winNoise"};
	this.rtwnameHashMap["<S15>/right_data_sink"] = {sid: "wiener:1208"};
	this.sidHashMap["wiener:1208"] = {rtwname: "<S15>/right_data_sink"};
	this.rtwnameHashMap["<S15>/Constant"] = {sid: "wiener:1209"};
	this.sidHashMap["wiener:1209"] = {rtwname: "<S15>/Constant"};
	this.rtwnameHashMap["<S15>/Constant1"] = {sid: "wiener:1210"};
	this.sidHashMap["wiener:1210"] = {rtwname: "<S15>/Constant1"};
	this.rtwnameHashMap["<S15>/Delay32"] = {sid: "wiener:1211"};
	this.sidHashMap["wiener:1211"] = {rtwname: "<S15>/Delay32"};
	this.rtwnameHashMap["<S15>/Divide"] = {sid: "wiener:1212"};
	this.sidHashMap["wiener:1212"] = {rtwname: "<S15>/Divide"};
	this.rtwnameHashMap["<S15>/Sum"] = {sid: "wiener:1213"};
	this.sidHashMap["wiener:1213"] = {rtwname: "<S15>/Sum"};
	this.rtwnameHashMap["<S15>/Tapped Delay"] = {sid: "wiener:1214"};
	this.sidHashMap["wiener:1214"] = {rtwname: "<S15>/Tapped Delay"};
	this.rtwnameHashMap["<S15>/win_mean"] = {sid: "wiener:1215"};
	this.sidHashMap["wiener:1215"] = {rtwname: "<S15>/win_mean"};
	this.rtwnameHashMap["<S15>/win"] = {sid: "wiener:1216"};
	this.sidHashMap["wiener:1216"] = {rtwname: "<S15>/win"};
	this.rtwnameHashMap["<S15>/startup"] = {sid: "wiener:1217"};
	this.sidHashMap["wiener:1217"] = {rtwname: "<S15>/startup"};
	this.rtwnameHashMap["<S16>/right_data_sink"] = {sid: "wiener:1175"};
	this.sidHashMap["wiener:1175"] = {rtwname: "<S16>/right_data_sink"};
	this.rtwnameHashMap["<S16>/noise_std"] = {sid: "wiener:1176"};
	this.sidHashMap["wiener:1176"] = {rtwname: "<S16>/noise_std"};
	this.rtwnameHashMap["<S16>/win"] = {sid: "wiener:1177"};
	this.sidHashMap["wiener:1177"] = {rtwname: "<S16>/win"};
	this.rtwnameHashMap["<S16>/win_mean"] = {sid: "wiener:1178"};
	this.sidHashMap["wiener:1178"] = {rtwname: "<S16>/win_mean"};
	this.rtwnameHashMap["<S16>/Enable"] = {sid: "wiener:1179"};
	this.sidHashMap["wiener:1179"] = {rtwname: "<S16>/Enable"};
	this.rtwnameHashMap["<S16>/wienFilter"] = {sid: "wiener:1180"};
	this.sidHashMap["wiener:1180"] = {rtwname: "<S16>/wienFilter"};
	this.rtwnameHashMap["<S16>/wienStats"] = {sid: "wiener:1193"};
	this.sidHashMap["wiener:1193"] = {rtwname: "<S16>/wienStats"};
	this.rtwnameHashMap["<S16>/right_data_source"] = {sid: "wiener:1206"};
	this.sidHashMap["wiener:1206"] = {rtwname: "<S16>/right_data_source"};
	this.rtwnameHashMap["<S17>/right_sink_data"] = {sid: "wiener:1181"};
	this.sidHashMap["wiener:1181"] = {rtwname: "<S17>/right_sink_data"};
	this.rtwnameHashMap["<S17>/winMean"] = {sid: "wiener:1182"};
	this.sidHashMap["wiener:1182"] = {rtwname: "<S17>/winMean"};
	this.rtwnameHashMap["<S17>/winSTD"] = {sid: "wiener:1183"};
	this.sidHashMap["wiener:1183"] = {rtwname: "<S17>/winSTD"};
	this.rtwnameHashMap["<S17>/winNoise"] = {sid: "wiener:1184"};
	this.sidHashMap["wiener:1184"] = {rtwname: "<S17>/winNoise"};
	this.rtwnameHashMap["<S17>/Add"] = {sid: "wiener:1185"};
	this.sidHashMap["wiener:1185"] = {rtwname: "<S17>/Add"};
	this.rtwnameHashMap["<S17>/Add1"] = {sid: "wiener:1186"};
	this.sidHashMap["wiener:1186"] = {rtwname: "<S17>/Add1"};
	this.rtwnameHashMap["<S17>/Delay"] = {sid: "wiener:1225"};
	this.sidHashMap["wiener:1225"] = {rtwname: "<S17>/Delay"};
	this.rtwnameHashMap["<S17>/Delay1"] = {sid: "wiener:1226"};
	this.sidHashMap["wiener:1226"] = {rtwname: "<S17>/Delay1"};
	this.rtwnameHashMap["<S17>/Delay2"] = {sid: "wiener:1228"};
	this.sidHashMap["wiener:1228"] = {rtwname: "<S17>/Delay2"};
	this.rtwnameHashMap["<S17>/HDL Reciprocal"] = {sid: "wiener:1224"};
	this.sidHashMap["wiener:1224"] = {rtwname: "<S17>/HDL Reciprocal"};
	this.rtwnameHashMap["<S17>/Product"] = {sid: "wiener:1188"};
	this.sidHashMap["wiener:1188"] = {rtwname: "<S17>/Product"};
	this.rtwnameHashMap["<S17>/Product1"] = {sid: "wiener:1189"};
	this.sidHashMap["wiener:1189"] = {rtwname: "<S17>/Product1"};
	this.rtwnameHashMap["<S17>/Subtract"] = {sid: "wiener:1190"};
	this.sidHashMap["wiener:1190"] = {rtwname: "<S17>/Subtract"};
	this.rtwnameHashMap["<S17>/Terminator"] = {sid: "wiener:1237"};
	this.sidHashMap["wiener:1237"] = {rtwname: "<S17>/Terminator"};
	this.rtwnameHashMap["<S17>/Terminator1"] = {sid: "wiener:1238"};
	this.sidHashMap["wiener:1238"] = {rtwname: "<S17>/Terminator1"};
	this.rtwnameHashMap["<S17>/Terminator2"] = {sid: "wiener:1239"};
	this.sidHashMap["wiener:1239"] = {rtwname: "<S17>/Terminator2"};
	this.rtwnameHashMap["<S17>/right_source_data"] = {sid: "wiener:1191"};
	this.sidHashMap["wiener:1191"] = {rtwname: "<S17>/right_source_data"};
	this.rtwnameHashMap["<S18>/win_mean"] = {sid: "wiener:1194"};
	this.sidHashMap["wiener:1194"] = {rtwname: "<S18>/win_mean"};
	this.rtwnameHashMap["<S18>/noise_std"] = {sid: "wiener:1195"};
	this.sidHashMap["wiener:1195"] = {rtwname: "<S18>/noise_std"};
	this.rtwnameHashMap["<S18>/win"] = {sid: "wiener:1196"};
	this.sidHashMap["wiener:1196"] = {rtwname: "<S18>/win"};
	this.rtwnameHashMap["<S18>/Constant"] = {sid: "wiener:1197"};
	this.sidHashMap["wiener:1197"] = {rtwname: "<S18>/Constant"};
	this.rtwnameHashMap["<S18>/Constant1"] = {sid: "wiener:1198"};
	this.sidHashMap["wiener:1198"] = {rtwname: "<S18>/Constant1"};
	this.rtwnameHashMap["<S18>/Product"] = {sid: "wiener:1199"};
	this.sidHashMap["wiener:1199"] = {rtwname: "<S18>/Product"};
	this.rtwnameHashMap["<S18>/Product2"] = {sid: "wiener:1200"};
	this.sidHashMap["wiener:1200"] = {rtwname: "<S18>/Product2"};
	this.rtwnameHashMap["<S18>/Relational Operator"] = {sid: "wiener:1201"};
	this.sidHashMap["wiener:1201"] = {rtwname: "<S18>/Relational Operator"};
	this.rtwnameHashMap["<S18>/Subtract"] = {sid: "wiener:1202"};
	this.sidHashMap["wiener:1202"] = {rtwname: "<S18>/Subtract"};
	this.rtwnameHashMap["<S18>/Sum"] = {sid: "wiener:1203"};
	this.sidHashMap["wiener:1203"] = {rtwname: "<S18>/Sum"};
	this.rtwnameHashMap["<S18>/Switch"] = {sid: "wiener:1204"};
	this.sidHashMap["wiener:1204"] = {rtwname: "<S18>/Switch"};
	this.rtwnameHashMap["<S18>/winNoise"] = {sid: "wiener:1205"};
	this.sidHashMap["wiener:1205"] = {rtwname: "<S18>/winNoise"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
