#!/bin/bash

logFiles=`find condorLog/ -maxdepth 1 -type f -name "condorLog*.log" | sort`

nOK=0
tEvts=0
s3list=s3_WA_aTGC_NLO_2016.list
rm -rf $s3list
for logFile in $logFiles
do
	a=`grep "^File" $logFile | grep "s3"`
	if [ "$a" == "" ]; then continue; fi
	s3file=`echo $a | awk '{print $2}'`
	nEvts=`echo $a | awk '{print $4}'`
	isOK=`ls -1 /xrootd/store/user/ycyang/WA_aTGC_NLO_2016/MINIAODSIM/$s3file | wc -l`
	isOK1=`ls -1 condorOut/$s3file | wc -l`
	if [ "$isOK" == "1" ]; then
		((nOK++))
		tEvts=`expr $tEvts + $nEvts`
		s1LogFile=${s3file/s3/s1}
		s1LogFile=${s1LogFile/.root/.log}
		rndN=`grep "random seed used for the run" condorOut/$s1LogFile | head -n 1 | awk '{print $9}' `
		s2LogFile=${s1LogFile/s1_/s2_1_}
		pileupFile=`grep "Successfully opened file" condorOut/$s2LogFile | grep Neutrino | head -n 1 | awk '{print $7}'` 
		echo "OK $nOK $nEvts $tEvts $s3file $rndN `basename $pileupFile`"
		echo "root://cms-xrdr.sdfarm.kr:1094//xrd/store/user/ycyang/WA_aTGC_NLO_2016/MINIAODSIM/$s3file" >> $s3list
	elif [ "$isOK1" == "1" ]; then
		((nOK++))
		tEvts=`expr $tEvts + $nEvts`
		s1LogFile=${s3file/s3/s1}
		s1LogFile=${s1LogFile/.root/.log}
		rndN=`grep "random seed used for the run" condorOut/$s1LogFile | head -n 1 | awk '{print $9}' `
		s2LogFile=${s1LogFile/s1_/s2_1_}
		pileupFile=`grep "Successfully opened file" condorOut/$s2LogFile | grep Neutrino | head -n 1 | awk '{print $7}'` 
		echo "OK $nOK $nEvts $tEvts $s3file $rndN `basename $pileupFile`"
		echo "condorOut/$s3file root://cms-xrdr.sdfarm.kr:1094//xrd/store/user/ycyang/WA_aTGC_NLO_2016/MINIAODSIM/$s3file" >> $s3list
	fi

done

