#!/bin/sh
#对运行在xx.xx.xx.xx机器上所有php脚本进行监控
for Script_process in {battery_discharge.php,collector_idc_tj-bh3.php,collector_idc.php,typhoon_dynamic_send.php,mib_problem_alarm.php,battery_alarm.php,mdc_quality_calculate.php,collector_typhoon_info.php,collector_mdc_sw-eb.php,collector_idc_sz-ps.php,super_power_calculate.php,collector_idc_sh-bx2.php,collector_mdc_sh-qp.php,collector_idc_sw-eb.php}
do
	ps -fe|grep ${Script_process} |grep -v grep  # grep -v grep指去除带grep字段 
	
	if [ $? -ne 0 ]
	then
	echo "警告:$(date "+%Y-%m-%d %H:%M:%S") ${Script_process}:脚本执行异常，请检查状态。"
	
	# 调用通知类插件，发送微信告警
	echo "[PLUGIN][NOTIFY]"
	echo "Receiver=angelawzhou&Content=$(date "+%Y-%m-%d %H:%M:%S")
	警告:脚本执行异常，请检查状态。
	ip：100.66.34.132 
	脚本名：${Script_process}"
	echo "[PLUGIN]"
	
	else
	echo "----------------------$(date "+%Y-%m-%d %H:%M:%S")，ip：xx.xx.xx.xx，${Script_process}:脚本正常执行中----------------------"
	fi
done