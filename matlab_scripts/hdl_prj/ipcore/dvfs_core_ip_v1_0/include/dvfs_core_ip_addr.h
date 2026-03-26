/*
 * File Name:         hdl_prj\ipcore\dvfs_core_ip_v1_0\include\dvfs_core_ip_addr.h
 * Description:       C Header File
 * Created:           2025-11-20 11:40:31
*/

#ifndef DVFS_CORE_IP_H_
#define DVFS_CORE_IP_H_

#define  IPCore_Reset_dvfs_core_ip       0x0  //write 0x1 to bit 0 to reset IP core
#define  IPCore_Enable_dvfs_core_ip      0x4  //enabled (by default) when bit 0 is 0x1
#define  IPCore_Timestamp_dvfs_core_ip   0x8  //contains unique IP timestamp (yymmddHHMM): 2511201140
#define  u_Data_dvfs_core_ip             0x100  //data register for Inport u. Data width is wider than the register width, so data is split into 2 32-bit sections.. Register is split across a total of 2 addresses, last address is 0x104.
#define  u_Strobe_dvfs_core_ip           0x108  //strobe register for port u
#define  p_state_Data_dvfs_core_ip       0x10C  //data register for Outport p_state
#define  W_log_Data_dvfs_core_ip         0x110  //data register for Outport W_log. Data width is wider than the register width, so data is split into 2 32-bit sections.. Register is split across a total of 2 addresses, last address is 0x114.
#define  W_log_Strobe_dvfs_core_ip       0x118  //strobe register for port W_log

#endif /* DVFS_CORE_IP_H_ */
