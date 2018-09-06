#!/bin/bash

FirstDir=`pwd`
export SCRAM_ARCH=slc6_amd64_gcc530
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source ${VO_CMS_SW_DIR}/cmsset_default.sh
cd /hcp/data/data02/ycyang/ZGammaVBS/20170425/CMSSW_8_0_26_patch1/src
eval `scramv1 runtime -sh`

cd $FirstDir

export MG5Dir=/hcp/home/jwkim2/MG5/MG5_aMC_v2_3_3 
LHEDir=`readlink -f $1`
echo "### Using $LHEDir/unweighted_events.lhe.gz "

if [ ! -f $LHEDir/unweighted_events.lhe.gz ]; then echo "### Error NotFound $LHEDir/unweighted_events.lhe.gz"; exit; fi

tempDir="saPythiaDelphes${RANDOM}_${RANDOM}"
mkdir -p $tempDir/Cards
mkdir -p $tempDir/Events
cd $tempDir/Events
echo "### Working Dir `pwd` "

cp $LHEDir/unweighted_events.lhe.gz .
gzip -d unweighted_events.lhe.gz 
ls -al unweighted_events.lhe

if [ -f $LHEDir/../../Cards/pythia_card.dat ]; then
	echo "### Using $LHEDir/../../Cards/pythia_card.dat"
	cp $LHEDir/../../Cards/pythia_card.dat ../Cards/pythia_card.dat
else
	echo "### Using $MG5Dir/Template/LO/Cards/pythia_card_default.dat"
	cp $MG5Dir/Template/LO/Cards/pythia_card_default.dat ../Cards/pythia_card.dat
	ls -al $MG5Dir/Template/LO/Cards/pythia_card_default.dat
	ls -al ../Cards/
fi

if [ ! -f ../Cards/pythia_card.dat ]; then echo "### Error Not Found ../Cards/pythia_card.dat"; exit; fi
echo "$MG5Dir/Template/Common/bin/internal/run_pythia $MG5Dir/pythia-pgs/src"
$MG5Dir/Template/Common/bin/internal/run_pythia $MG5Dir/pythia-pgs/src 
ls -al


echo "$MG5Dir/Delphes/DelphesSTDHEP $MG5Dir/Delphes/cards/delphes_card_CMS.tcl tag_s_delphes_events.root pythia_events.hep"
$MG5Dir/Delphes/DelphesSTDHEP $MG5Dir/Delphes/cards/delphes_card_CMS.tcl tag_s_delphes_events.root pythia_events.hep >& /dev/null

mv unweighted_events.lhe     $LHEDir/  
mv beforeveto.tree           $LHEDir/  
mv xsecs.tree                $LHEDir/  
mv pythia_events.hep         $LHEDir/  
mv fort.0                    $LHEDir/  
mv events.tree               $LHEDir/  
mv pythia.done               $LHEDir/  
mv tag_s_delphes_events.root $LHEDir/  

ls -al $LHEDir/tag_s_delphes_events.root
cd $FirstDir
#rm -rf $tempDir
echo "Done $LHEDir/unweighted_events.lhe.gz To $LHEDir/tag_s_delphes_events.root"



