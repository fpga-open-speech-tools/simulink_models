function RTW_SidParentMap() {
    this.sidParentMap = new Array();
    this.sidParentMap["SG:235"] = "SG:233";
    this.sidParentMap["SG:234"] = "SG:233";
    this.sidParentMap["SG:236"] = "SG:233";
    this.sidParentMap["SG:237"] = "SG:233";
    this.sidParentMap["SG:1023"] = "SG:233";
    this.sidParentMap["SG:1024"] = "SG:233";
    this.sidParentMap["SG:407"] = "SG:233";
    this.sidParentMap["SG:412"] = "SG:233";
    this.sidParentMap["SG:411"] = "SG:233";
    this.sidParentMap["SG:413"] = "SG:233";
    this.sidParentMap["SG:414"] = "SG:233";
    this.sidParentMap["SG:415"] = "SG:407";
    this.sidParentMap["SG:416"] = "SG:407";
    this.sidParentMap["SG:1021"] = "SG:407";
    this.sidParentMap["SG:1022"] = "SG:407";
    this.sidParentMap["SG:409"] = "SG:407";
    this.sidParentMap["SG:445"] = "SG:407";
    this.sidParentMap["SG:433"] = "SG:407";
    this.sidParentMap["SG:434"] = "SG:407";
    this.sidParentMap["SG:453"] = "SG:407";
    this.sidParentMap["SG:446"] = "SG:407";
    this.sidParentMap["SG:417"] = "SG:407";
    this.sidParentMap["SG:418"] = "SG:407";
    this.sidParentMap["SG:445:1"] = "SG:445";
    this.sidParentMap["SG:445:2"] = "SG:445";
    this.sidParentMap["SG:445:3"] = "SG:445";
    this.sidParentMap["SG:445:4"] = "SG:445";
    this.sidParentMap["SG:433:1"] = "SG:433";
    this.sidParentMap["SG:433:2"] = "SG:433";
    this.sidParentMap["SG:433:3"] = "SG:433";
    this.sidParentMap["SG:433:4"] = "SG:433";
    this.sidParentMap["SG:435"] = "SG:434";
    this.sidParentMap["SG:1013"] = "SG:434";
    this.sidParentMap["SG:436"] = "SG:434";
    this.sidParentMap["SG:1012"] = "SG:434";
    this.sidParentMap["SG:1011"] = "SG:434";
    this.sidParentMap["SG:437"] = "SG:434";
    this.sidParentMap["SG:457"] = "SG:446";
    this.sidParentMap["SG:1015"] = "SG:446";
    this.sidParentMap["SG:448"] = "SG:446";
    this.sidParentMap["SG:1016"] = "SG:446";
    this.sidParentMap["SG:1017"] = "SG:446";
    this.sidParentMap["SG:461"] = "SG:446";
    this.getParentSid = function(sid) { return this.sidParentMap[sid];}
}
    RTW_SidParentMap.instance = new RTW_SidParentMap();
