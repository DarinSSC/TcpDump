#!/bin/bash

#get the list of ports used by a specified pid which is a parameter as $1, a specified protocal as paremeter $2
sudo netstat -npa|grep $1|grep $2|awk '{if($1 != "unix"){print $4}else if($4!="]"){print $8}else{print $7}}'|cut -d':' -f 2|sort|uniq > port_list.txt

cat /dev/null > packet.pcap

#call python file to handle the port and do Tcpdump
cat port_list.txt|while read line
do
	sudo timeout 100 tcpdump -nn -s 256 -vnn $2 port $line -w tmp_packet.pcap 
	#timeout 10 sh set_time.sh $line
	echo "Appending temp file to packet.pcap"
	cat tmp_packet.pcap >> packet.pcap
done < port_list.txt
