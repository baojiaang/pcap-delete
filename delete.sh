#!/bin/bash
#获取文件夹下所有文件
deletefolder="/home/bao/Documents/delete/data2/node3/in/"
pcapfolder="/home/bao/Documents/all/data2/node3/in/"
outputfolder="/home/bao/Documents/newdata2/node3/in/"
files=$(ls $deletefolder)
for sfile in ${files}
do
    OLD_IFS="$IFS"
    IFS="."
    array=($sfile)
    IFS="$OLD_IFS"
    pcapname=${array[0]}
    pcaptail=".pcap"
    pcapfilename=$pcapfolder$pcapname$pcaptail
    echo $pcapfilename
    #tcpdump -A -r "$pcapfilename" !\(src host  223.3.71.76 and dst host  224.0.0.251 and src port  5353 and dst port 5353 \)
    filter="tcpdump -r ${pcapfilename}"
    while read line
    do
        OLD_IFS="$IFS"
        IFS=" "
		array=($line)
		IFS="$OLD_IFS"
		newline=${array[0]}
		OLD_IFS="$IFS"
        IFS="-"
		array=($line)
		IFS="$OLD_IFS"
		srcip=${array[0]}
		dstip=${array[1]}
		srcport=${array[2]}
		dstport=${array[3]}
		str=" \!\(src host  ${srcip} and dst host  ${dstip} and src port  ${srcport} and dst port  ${dstport}\)" 
		strr=" !(src port  ${srcport} and dst port  ${dstport}) and !(src port  ${dstport} and dst port  ${srcport})"
		#strr=" !(src host  ${srcip} and dst host  ${dstip} and src port  ${srcport} and dst port  ${dstport}) or !(src host  ${dstip} and dst host  ${srcip} and src port  ${dstport} and dst port  ${srcport}) or !(src host  ${srcip} and dst host  ${dstip} and src port  ${dstport} and dst port  ${srcport}) or !(src host  ${dstip} and dst host  ${srcip} and src port  ${srcport} and dst port  ${dstport}) "
		str1=" and"
		filter="$filter$strr$str1"
    done < $deletefolder$sfile
    tail=${filter:0-1:1}
    taildel="p"
    if [ $tail != $taildel ]
    then
    	filter=${filter::-4}
    fi
    out=" -w ${outputfolder}${pcapname}${pcaptail}"
    allcommond="${filter}${out}"
    echo $allcommond
    $allcommond
	#tcpdump -r ${pcapfilename} ${filter1} -w ${outputfolder}${pcapname}${pcaptail}
done
echo "finish"
