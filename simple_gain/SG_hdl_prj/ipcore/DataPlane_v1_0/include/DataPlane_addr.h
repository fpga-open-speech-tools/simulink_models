/*
 * File Name:         SG_hdl_prj\ipcore\DataPlane_v1_0\include\DataPlane_addr.h
 * Description:       C Header File
 * Created:           2019-06-13 13:16:18
*/

#ifndef DATAPLANE_H_
#define DATAPLANE_H_

#define  IPCore_Reset_DataPlane       0x0  //write 0x1 to bit 0 to reset IP core
#define  IPCore_Enable_DataPlane      0x4  //enabled (by default) when bit 0 is 0x1
#define  IPCore_Timestamp_DataPlane   0x8  //contains unique IP timestamp (yymmddHHMM): 1906131316

#endif /* DATAPLANE_H_ */
