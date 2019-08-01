/*
 * File Name:         hdl_prj\ipcore\SG_DataPlane_v1_0\include\SG_DataPlane_addr.h
 * Description:       C Header File
 * Created:           2019-08-01 13:14:28
*/

#ifndef SG_DATAPLANE_H_
#define SG_DATAPLANE_H_

#define  IPCore_Reset_SG_DataPlane       0x0  //write 0x1 to bit 0 to reset IP core
#define  IPCore_Enable_SG_DataPlane      0x4  //enabled (by default) when bit 0 is 0x1
#define  IPCore_Timestamp_SG_DataPlane   0x8  //contains unique IP timestamp (yymmddHHMM): 1908011314

#endif /* SG_DATAPLANE_H_ */
