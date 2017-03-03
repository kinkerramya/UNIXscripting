#!/bin/sh
while [ 1 -ne 0 ]
do
 while read p;
 do
  folder_1=`echo $p|awk -F"," '{print $1}'`
  folder_2=`echo $p|awk -F"," '{print $2}'`
  threshhold=`echo $p|awk -F"," '{print $3}'`
  lastcreated_1=`ls -ltr $folder_1|tail -n 1`
  lastcreated_2=`ls -ltr $folder_2|tail -n 1`
  lastfile_1=`ls -ltr $folder_1|tail -n 1|awk -F" " '{print $8}'`
  lastfile_2=`ls -ltr $folder_2|tail -n 1|awk -F" " '{print $8}'`
  filename_1=`ls -ltr $folder_1|tail -n 1|awk -F" " '{print $9}'`
  filemonth_1=`ls -ltr $folder_1|tail -n 1|awk -F" " '{print $6}'`
  filedate_1=`ls -ltr $folder_1|tail -n 1|awk -F" " '{print $7}'`
  filehr_1=`echo $lastfile_1|awk -F":" '{print $1}'`
  filemin_1=`echo $lastfile_1|awk -F":" '{print $2}'`
  fileseconds_1=`expr \( \( $filehr_1 \* 60 \) + $filemin_1 \) \* 60`
  filename_2=`ls -ltr $folder_2|tail -n 1|awk -F" " '{print $9}'`
  filemonth_2=`ls -ltr $folder_2|tail -n 1|awk -F" " '{print $6}'`
  filedate_2=`ls -ltr $folder_2|tail -n 1|awk -F" " '{print $7}'`
  filehr_2=`echo $lastfile_2|awk -F":" '{print $1}'`
  filemin_2=`echo $lastfile_2|awk -F":" '{print $2}'`
  fileseconds_2=`expr \( \( $filehr_2 \* 60 \) + $filemin_2 \) \* 60`
  if [ filemonth_1 == filemonth_2 ]
  	then
  	if [ filedate_1 == filedate_2 ]
  		then
  		if [ fileseconds_1 -gt fileseconds_2 ]
  			then
  			folder=$folder_1
  			filedate=$filedate_1
  			fileseconds=$fileseconds_1
  			lastcreated=$lastcreated_1
  		else
  			folder=$folder_2
  			filedate=$filedate_2
  			fileseconds=$fileseconds_2
  			lastcreated=$lastcreated_2
  		fi
  	else 
  		if [ filedate_1 -gt filedate_2 ]
  			then
  			folder=$folder_1
  			filedate=$filedate_1
  			fileseconds=$fileseconds_1
  			lastcreated=$lastcreated_1
  		else
  			folder=$folder_2
  			filedate=$filedate_2
  			fileseconds=$fileseconds_2
  			lastcreated=$lastcreated_2
  	    fi
  	fi
  else
  	if [ filedate_1 -gt filedate_2 ]
  		then
  		folder=$folder_2
  		filedate=$filedate_2
  		fileseconds=$fileseconds_2
  		lastcreated=$lastcreated_2
  	else
  		folder=$folder_1
  		filedate=$filedate_1
  		fileseconds=$fileseconds_1
  		lastcreated=$lastcreated_1
  	fi
  fi
  currtime=`date`
  currmonth=`echo $currtime|awk -F" " '{print $2}'`
  currdate=`echo $currtime|awk -F" " '{print $3}'`
  currhr=`echo \`echo $currtime|awk -F" " '{print $4}'\`|awk -F":" '{print $1}'`
  currmin=`echo \`echo $currtime|awk -F" " '{print $4}'\`|awk -F":" '{print $2}'`
  currseconds=`expr \( \( $currhr \* 60 \) + $currmin \) \* 60`
  datediff=`expr $currdate - $filedate`
  if [ $datediff == 1 -o $datediff == -30 -o $datediff == -29 -o $datediff == -27 ]
  then
   currseconds=`expr $currseconds + \( 24 \* 60 \* 60 \)`
  fi
  diff=`expr $currseconds - $fileseconds`
  if [ $diff -gt $threshhold -o $diff -lt 0 ]
  then
   export from="ggsalerts@visa.com"
   export to="rkinkiri@visa.com satnandi@visa.com"
   export subject="Alert!! File not created at ggs folders"
   export message="Last file created is: </br></br> <b><span style='color:blue'> $lastcreated at $folder </span></b></br></br> A lag of: `expr $diff / 60` Minutes </br> Current System time: $currtime"
   `./sendmail.sh`
  else
   export from="ggsalerts@visa.com"
   export to="rkinkiri@visa.com"
   export subject="File Creation for $folder"
   export message="<span style='color:green'> File created at $folder : </br></br> $lastcreated <Span>"
   `./sendmail.sh`
  fi
 done < ggscheck.txt
 sleep 900
done
