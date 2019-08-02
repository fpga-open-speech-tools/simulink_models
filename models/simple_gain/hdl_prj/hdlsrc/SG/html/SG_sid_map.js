function RTW_SidParentMap() {
    this.sidParentMap = new Array();
    this.getParentSid = function(sid) { return this.sidParentMap[sid];}
}
    RTW_SidParentMap.instance = new RTW_SidParentMap();
