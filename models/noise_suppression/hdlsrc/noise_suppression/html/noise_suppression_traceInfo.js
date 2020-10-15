function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S2>/Adaptive_Wiener_Filter
Sample Based Filtering */
	this.urlHashMap["noise_suppression:1038"] = "noise_suppression_dataplane.vhd:115,116,117,118,119,120,121,122,123,124,125";
	/* <S2>/Data Type Conversion */
	this.urlHashMap["noise_suppression:1682"] = "noise_suppression_dataplane.vhd:133,134";
	/* <S2>/Data Type Conversion1 */
	this.urlHashMap["noise_suppression:1660"] = "noise_suppression_dataplane.vhd:144,145";
	/* <S3>/Add */
	this.urlHashMap["noise_suppression:1639"] = "noise_suppression_streaming_partition_streamed.vhd:235,236,237";
	/* <S3>/Add1 */
	this.urlHashMap["noise_suppression:1666"] = "noise_suppression_streaming_partition_streamed_block.vhd:324,325,326";
	/* <S3>/Add2 */
	this.urlHashMap["noise_suppression:1667"] = "noise_suppression_streaming_partition_streamed.vhd:147,148,149";
	/* <S3>/Data Type Conversion */
	this.urlHashMap["noise_suppression:1640"] = "noise_suppression_streaming_partition_streamed_block.vhd:322";
	/* <S3>/Data Type Conversion2 */
	this.urlHashMap["noise_suppression:1661"] = "noise_suppression_streaming_partition_streamed.vhd:231";
	/* <S3>/Data Type Conversion3 */
	this.urlHashMap["noise_suppression:1664"] = "noise_suppression_streaming_partition_streamed.vhd:239";
	/* <S3>/Demux */
	this.urlHashMap["noise_suppression:1673"] = "noise_suppression_Adaptive_Wiener_Filter_Sample_Based_Filtering.vhd:278,279,280,281,282,283,284";
	/* <S3>/Product */
	this.urlHashMap["noise_suppression:1641"] = "noise_suppression_streaming_partition_streamed_block.vhd:291";
	/* <S3>/Product1 */
	this.urlHashMap["noise_suppression:1668"] = "noise_suppression_streaming_partition_streamed_block.vhd:340";
	/* <S3>/Reciprocal1 */
	this.urlHashMap["noise_suppression:1642"] = "noise_suppression_Adaptive_Wiener_Filter_Sample_Based_Filtering.vhd:278,279,280,281,282,283,284";
	/* <S3>/Reciprocal2 */
	this.urlHashMap["noise_suppression:1674"] = "noise_suppression_Adaptive_Wiener_Filter_Sample_Based_Filtering.vhd:312,313,314,315,316,317,318";
	/* <S3>/Switch */
	this.urlHashMap["noise_suppression:1676"] = "noise_suppression_streaming_partition_streamed_block.vhd:377,378";
	/* <S3>/compute statistics */
	this.urlHashMap["noise_suppression:1382"] = "noise_suppression_Adaptive_Wiener_Filter_Sample_Based_Filtering.vhd:240,241,242,243,244,245,246,247,248,249";
	/* <S4>/
 */
	this.urlHashMap["noise_suppression:1373"] = "noise_suppression_compute_statistics.vhd:889,890,891,892,893,894,895,896";
	/* <S4>/
1 */
	this.urlHashMap["noise_suppression:1482"] = "noise_suppression_compute_statistics.vhd:1047,1048,1049,1050,1051,1052,1053,1054";
	/* <S4>/Add */
	this.urlHashMap["noise_suppression:1371"] = "noise_suppression_compute_statistics.vhd:958,959,960,961,962,963";
	/* <S4>/Add1 */
	this.urlHashMap["noise_suppression:1376"] = "noise_suppression_compute_statistics.vhd:982,983";
	/* <S4>/Add2 */
	this.urlHashMap["noise_suppression:1378"] = "noise_suppression_compute_statistics.vhd:1199,1200";
	/* <S4>/Constant */
	this.urlHashMap["noise_suppression:1368"] = "noise_suppression_compute_statistics.vhd:316";
	/* <S4>/Constant1 */
	this.urlHashMap["noise_suppression:1369"] = "noise_suppression_compute_statistics.vhd:344";
	/* <S4>/Constant2 */
	this.urlHashMap["noise_suppression:1477"] = "noise_suppression_compute_statistics.vhd:738";
	/* <S4>/Constant3 */
	this.urlHashMap["noise_suppression:1478"] = "noise_suppression_compute_statistics.vhd:975";
	/* <S4>/Delay */
	this.urlHashMap["noise_suppression:1367"] = "msg=rtwMsg_notTraceable&block=noise_suppression:1367";
	/* <S4>/Delay1 */
	this.urlHashMap["noise_suppression:1372"] = "msg=rtwMsg_notTraceable&block=noise_suppression:1372";
	/* <S4>/Delay3 */
	this.urlHashMap["noise_suppression:1479"] = "msg=rtwMsg_notTraceable&block=noise_suppression:1479";
	/* <S4>/Delay4 */
	this.urlHashMap["noise_suppression:1499"] = "msg=rtwMsg_notTraceable&block=noise_suppression:1499";
	/* <S4>/Gain */
	this.urlHashMap["noise_suppression:1380"] = "noise_suppression_compute_statistics.vhd:1216,1217,1218,1219,1220,1221,1222,1223";
	/* <S4>/Product */
	this.urlHashMap["noise_suppression:1365"] = "noise_suppression_compute_statistics.vhd:532,533,554,555";
	/* <S4>/Product1 */
	this.urlHashMap["noise_suppression:1528"] = "noise_suppression_compute_statistics.vhd:1013,1014";
	/* <S4>/Switch1 */
	this.urlHashMap["noise_suppression:1366"] = "noise_suppression_compute_statistics.vhd:389,390";
	/* <S4>/Switch2 */
	this.urlHashMap["noise_suppression:1480"] = "noise_suppression_compute_statistics.vhd:1240,1241,1243,1244";
	/* <S4>/exponential moving average weight */
	this.urlHashMap["noise_suppression:1370"] = "noise_suppression_compute_statistics.vhd:366";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "noise_suppression"};
	this.sidHashMap["noise_suppression"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S2>/avalon_sink_data"] = {sid: "noise_suppression:234"};
	this.sidHashMap["noise_suppression:234"] = {rtwname: "<S2>/avalon_sink_data"};
	this.rtwnameHashMap["<S2>/register_control_enable"] = {sid: "noise_suppression:1024"};
	this.sidHashMap["noise_suppression:1024"] = {rtwname: "<S2>/register_control_enable"};
	this.rtwnameHashMap["<S2>/register_control_noise_variance"] = {sid: "noise_suppression:1486"};
	this.sidHashMap["noise_suppression:1486"] = {rtwname: "<S2>/register_control_noise_variance"};
	this.rtwnameHashMap["<S2>/Adaptive_Wiener_Filter Sample Based Filtering"] = {sid: "noise_suppression:1038"};
	this.sidHashMap["noise_suppression:1038"] = {rtwname: "<S2>/Adaptive_Wiener_Filter Sample Based Filtering"};
	this.rtwnameHashMap["<S2>/Data Type Conversion"] = {sid: "noise_suppression:1682"};
	this.sidHashMap["noise_suppression:1682"] = {rtwname: "<S2>/Data Type Conversion"};
	this.rtwnameHashMap["<S2>/Data Type Conversion1"] = {sid: "noise_suppression:1660"};
	this.sidHashMap["noise_suppression:1660"] = {rtwname: "<S2>/Data Type Conversion1"};
	this.rtwnameHashMap["<S2>/State Control"] = {sid: "noise_suppression:1542"};
	this.sidHashMap["noise_suppression:1542"] = {rtwname: "<S2>/State Control"};
	this.rtwnameHashMap["<S2>/avalon_source_data"] = {sid: "noise_suppression:411"};
	this.sidHashMap["noise_suppression:411"] = {rtwname: "<S2>/avalon_source_data"};
	this.rtwnameHashMap["<S3>/Sink_Data"] = {sid: "noise_suppression:1039"};
	this.sidHashMap["noise_suppression:1039"] = {rtwname: "<S3>/Sink_Data"};
	this.rtwnameHashMap["<S3>/noise_variance"] = {sid: "noise_suppression:1487"};
	this.sidHashMap["noise_suppression:1487"] = {rtwname: "<S3>/noise_variance"};
	this.rtwnameHashMap["<S3>/enable"] = {sid: "noise_suppression:1677"};
	this.sidHashMap["noise_suppression:1677"] = {rtwname: "<S3>/enable"};
	this.rtwnameHashMap["<S3>/Add"] = {sid: "noise_suppression:1639"};
	this.sidHashMap["noise_suppression:1639"] = {rtwname: "<S3>/Add"};
	this.rtwnameHashMap["<S3>/Add1"] = {sid: "noise_suppression:1666"};
	this.sidHashMap["noise_suppression:1666"] = {rtwname: "<S3>/Add1"};
	this.rtwnameHashMap["<S3>/Add2"] = {sid: "noise_suppression:1667"};
	this.sidHashMap["noise_suppression:1667"] = {rtwname: "<S3>/Add2"};
	this.rtwnameHashMap["<S3>/Data Type Conversion"] = {sid: "noise_suppression:1640"};
	this.sidHashMap["noise_suppression:1640"] = {rtwname: "<S3>/Data Type Conversion"};
	this.rtwnameHashMap["<S3>/Data Type Conversion2"] = {sid: "noise_suppression:1661"};
	this.sidHashMap["noise_suppression:1661"] = {rtwname: "<S3>/Data Type Conversion2"};
	this.rtwnameHashMap["<S3>/Data Type Conversion3"] = {sid: "noise_suppression:1664"};
	this.sidHashMap["noise_suppression:1664"] = {rtwname: "<S3>/Data Type Conversion3"};
	this.rtwnameHashMap["<S3>/Demux"] = {sid: "noise_suppression:1673"};
	this.sidHashMap["noise_suppression:1673"] = {rtwname: "<S3>/Demux"};
	this.rtwnameHashMap["<S3>/Mux"] = {sid: "noise_suppression:1675"};
	this.sidHashMap["noise_suppression:1675"] = {rtwname: "<S3>/Mux"};
	this.rtwnameHashMap["<S3>/Product"] = {sid: "noise_suppression:1641"};
	this.sidHashMap["noise_suppression:1641"] = {rtwname: "<S3>/Product"};
	this.rtwnameHashMap["<S3>/Product1"] = {sid: "noise_suppression:1668"};
	this.sidHashMap["noise_suppression:1668"] = {rtwname: "<S3>/Product1"};
	this.rtwnameHashMap["<S3>/Reciprocal1"] = {sid: "noise_suppression:1642"};
	this.sidHashMap["noise_suppression:1642"] = {rtwname: "<S3>/Reciprocal1"};
	this.rtwnameHashMap["<S3>/Reciprocal2"] = {sid: "noise_suppression:1674"};
	this.sidHashMap["noise_suppression:1674"] = {rtwname: "<S3>/Reciprocal2"};
	this.rtwnameHashMap["<S3>/Switch"] = {sid: "noise_suppression:1676"};
	this.sidHashMap["noise_suppression:1676"] = {rtwname: "<S3>/Switch"};
	this.rtwnameHashMap["<S3>/compute statistics"] = {sid: "noise_suppression:1382"};
	this.sidHashMap["noise_suppression:1382"] = {rtwname: "<S3>/compute statistics"};
	this.rtwnameHashMap["<S3>/data_out"] = {sid: "noise_suppression:1669"};
	this.sidHashMap["noise_suppression:1669"] = {rtwname: "<S3>/data_out"};
	this.rtwnameHashMap["<S4>/data"] = {sid: "noise_suppression:1383"};
	this.sidHashMap["noise_suppression:1383"] = {rtwname: "<S4>/data"};
	this.rtwnameHashMap["<S4>/ "] = {sid: "noise_suppression:1373"};
	this.sidHashMap["noise_suppression:1373"] = {rtwname: "<S4>/ "};
	this.rtwnameHashMap["<S4>/ 1"] = {sid: "noise_suppression:1482"};
	this.sidHashMap["noise_suppression:1482"] = {rtwname: "<S4>/ 1"};
	this.rtwnameHashMap["<S4>/Add"] = {sid: "noise_suppression:1371"};
	this.sidHashMap["noise_suppression:1371"] = {rtwname: "<S4>/Add"};
	this.rtwnameHashMap["<S4>/Add1"] = {sid: "noise_suppression:1376"};
	this.sidHashMap["noise_suppression:1376"] = {rtwname: "<S4>/Add1"};
	this.rtwnameHashMap["<S4>/Add2"] = {sid: "noise_suppression:1378"};
	this.sidHashMap["noise_suppression:1378"] = {rtwname: "<S4>/Add2"};
	this.rtwnameHashMap["<S4>/Constant"] = {sid: "noise_suppression:1368"};
	this.sidHashMap["noise_suppression:1368"] = {rtwname: "<S4>/Constant"};
	this.rtwnameHashMap["<S4>/Constant1"] = {sid: "noise_suppression:1369"};
	this.sidHashMap["noise_suppression:1369"] = {rtwname: "<S4>/Constant1"};
	this.rtwnameHashMap["<S4>/Constant2"] = {sid: "noise_suppression:1477"};
	this.sidHashMap["noise_suppression:1477"] = {rtwname: "<S4>/Constant2"};
	this.rtwnameHashMap["<S4>/Constant3"] = {sid: "noise_suppression:1478"};
	this.sidHashMap["noise_suppression:1478"] = {rtwname: "<S4>/Constant3"};
	this.rtwnameHashMap["<S4>/Delay"] = {sid: "noise_suppression:1367"};
	this.sidHashMap["noise_suppression:1367"] = {rtwname: "<S4>/Delay"};
	this.rtwnameHashMap["<S4>/Delay1"] = {sid: "noise_suppression:1372"};
	this.sidHashMap["noise_suppression:1372"] = {rtwname: "<S4>/Delay1"};
	this.rtwnameHashMap["<S4>/Delay3"] = {sid: "noise_suppression:1479"};
	this.sidHashMap["noise_suppression:1479"] = {rtwname: "<S4>/Delay3"};
	this.rtwnameHashMap["<S4>/Delay4"] = {sid: "noise_suppression:1499"};
	this.sidHashMap["noise_suppression:1499"] = {rtwname: "<S4>/Delay4"};
	this.rtwnameHashMap["<S4>/Gain"] = {sid: "noise_suppression:1380"};
	this.sidHashMap["noise_suppression:1380"] = {rtwname: "<S4>/Gain"};
	this.rtwnameHashMap["<S4>/Product"] = {sid: "noise_suppression:1365"};
	this.sidHashMap["noise_suppression:1365"] = {rtwname: "<S4>/Product"};
	this.rtwnameHashMap["<S4>/Product1"] = {sid: "noise_suppression:1528"};
	this.sidHashMap["noise_suppression:1528"] = {rtwname: "<S4>/Product1"};
	this.rtwnameHashMap["<S4>/Switch1"] = {sid: "noise_suppression:1366"};
	this.sidHashMap["noise_suppression:1366"] = {rtwname: "<S4>/Switch1"};
	this.rtwnameHashMap["<S4>/Switch2"] = {sid: "noise_suppression:1480"};
	this.sidHashMap["noise_suppression:1480"] = {rtwname: "<S4>/Switch2"};
	this.rtwnameHashMap["<S4>/exponential moving average weight"] = {sid: "noise_suppression:1370"};
	this.sidHashMap["noise_suppression:1370"] = {rtwname: "<S4>/exponential moving average weight"};
	this.rtwnameHashMap["<S4>/mean"] = {sid: "noise_suppression:1384"};
	this.sidHashMap["noise_suppression:1384"] = {rtwname: "<S4>/mean"};
	this.rtwnameHashMap["<S4>/variance"] = {sid: "noise_suppression:1385"};
	this.sidHashMap["noise_suppression:1385"] = {rtwname: "<S4>/variance"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
