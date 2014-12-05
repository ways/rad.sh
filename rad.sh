#!/bin/bash                                                                                                                                          

URL=http://radnett.nrpa.no/radnett.xml
DIR=/tmp/rad
FILE=$DIR"/radnett.xml"
mkdir -p $DIR
#bold=`tput bold`                                                                                                                                    
#normal=`tput sgr0`                                                                                                                                  
bold="\033[1m"
normal="\033[0m"


wget -qO $FILE $URL

oslo=$( grep -si -R3 'Oslo' $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )
trondheim=$( grep -si -R3 'trondheim' $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )
bergen=$( grep -si -R3 'bergen' $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )
bodo=$( grep -si -R3 'bodø' $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )
vardo=$( grep -si -R3 'vardø' $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )
halden=$( grep -si -R3 'halden' $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )
kjeller=$( grep -si -R3 'kjeller' $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )

echo
echo "  Radiation "$( stat --format=%y $FILE |cut -c 1-16 )
echo "  --------------------------"

[[ ! -s $FILE ]] && { echo "No data!"; exit 1; }

format=$normal; [[ $(echo "$halden>0.099"|bc) -gt 0 ]] && format=${bold}
echo -e "  Halden \u2622       "${format}$halden${normal}" µSv/h"
format=$normal; [[ $(echo "$kjeller>0.099"|bc) -gt 0 ]] && format=$bold
echo -e "  Kjeller \u2622      "$format$kjeller${normal}" µSv/h"
echo
format=$normal; [[ $(echo "$oslo>0.099"|bc) -gt 0 ]] && format=$bold
echo -e "  Oslo           "$format$oslo$normal" µSv/h"
format=$normal; [[ $(echo "$bergen>0.099"|bc) -gt 0 ]] && format=$bold
echo -e "  Bergen         "${format}$bergen${normal}" µSv/h"
format=$normal; [[ $(echo "$trondheim>0.099"|bc) -gt 0 ]] && format=$bold
echo -e "  Trondheim      "$format$trondheim$normal" µSv/h"
format=$normal; [[ $(echo "$bodo>0.099"|bc) -gt 0 ]] && format=$bold
echo -e "  Bodø           "$format$bodo$normal" µSv/h"
format=$normal; [[ $(echo "$vardo>0.099"|bc) -gt 0 ]] && format=$bold
echo -e "  Vardø          "${format}${vardo}${normal}" µSv/h"
