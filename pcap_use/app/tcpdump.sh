#!/bin/sh
LOG_ROOT=/root/log
LOG_DIR=`date +%F`
LOG_NAME=`date +%F"@"%H%M%S`
INTERVAL=5 #second tcpdump生成日志文件的间隔
USESPACE=60 #当日志存储路径的使用空间超过此值时 删除最旧的记录


DATE_DIR=`date +%F`           #抓取抓包文件夹日期
LOG_PATH=$LOG_ROOT/$LOG_DIR
if [ ! -d $LOG_PATH ];then
mkdir -p $LOG_PATH     #判断目标文件夹下是否有该日期的目录,有则忽略,无则创建
fi

killall tcpdump
tcpdump -n -i eth0 -s0 -G $INTERVAL -w $LOG_PATH/%Y%m%d_%H%M%S.pcap &     #后台抓包，监控eth1端口，每次自动抓包3w个自动停止并保存到相应目录，这个值可以根据需要来修改
#tcpdump -i eth0 -G 5 -w /data/$DATE_DIR/$STIME.pcap > /dev/null 2>&1 &      #后台抓包，监控eth1端口，每次自动抓包3w个自动停止并保存到相应目录，这个值可以根据需要来修改



while [ 1 ]
do
sleep 5s
DIR_TMP=`date +%F`
echo LOG_DIR= $LOG_DIR
echo DIR_TMP= $DIR_TMP
if [ "$DIR_TMP" != "$LOG_DIR" ];then
    LOG_DIR=$DIR_TMP
    echo $LOG_DIR
    LOG_PATH=$LOG_ROOT/$LOG_DIR

    if [ ! -d $LOG_PATH ];then
	mkdir -p $LOG_PATH     #判断目标文件夹下是否有该日期的目录,有则忽略,无则创建
    fi
    echo kill tcpdump
    killall tcpdump

    echo start tcpdump
    tcpdump -n -i eth0 -s0 -G $INTERVAL -w $LOG_PATH/%Y%m%d_%H%M%S.pcap &


    # USEDISK=`df $LOG_ROOT|grep "/"|awk '{print $5}'|awk -F % '{print $1}'`
    # echo $LOG_ROOT used $USEDISK%
    # if [ "$USEDISK" -ge "$USESPACE" ];then
    # 	HEADDIR=`ls -l $LOG_ROOT|grep ^d|awk '{print $NF}'|sort|head -n 1`
    # 	echo pre del $HEADDIR
    # 	if [ $LOG_DIR != $HEADDIR ];then
    # 	    echo rm $LOG_ROOT/$HEADDIR
    # 	    rm -rf $LOG_ROOT/$HEADDIR
    # 	fi
    # fi

else
    echo running...
    USEDISK=`df $LOG_ROOT|grep "/"|awk '{print $5}'|awk -F % '{print $1}'`
    echo $LOG_ROOT used $USEDISK%
    if [ "$USEDISK" -ge "$USESPACE" ];then
	HEADDIR=`ls -l $LOG_ROOT|grep ^d|awk '{print $NF}'|sort|head -n 1`
	echo usespace ge $USEDISK% pre del $HEADDIR
	if [ $LOG_DIR != $HEADDIR ];then
	    echo rm $LOG_ROOT/$HEADDIR
	    rm -rf $LOG_ROOT/$HEADDIR
	fi
    fi
fi

#sleep 10s



done
