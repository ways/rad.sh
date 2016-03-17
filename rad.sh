#!/bin/bash -e

# Data from http://radnett.nrpa.no. Must be cached for 30 minutes.

#cities=( Halden* Kjeller* Oslo Trondheim Bergen )
cities=( Halden* Kjeller* Oslo Trondheim Bergen Bodø Vardø )

URL='http://radnett.nrpa.no/radnett.xml'
DIR='/tmp/rad'
FILE="${DIR}/radnett.xml"
bold="\033[1m"
normal="\033[0m"
stale_minutes=60
bold_limit='0.120'
danger_limit='2.000'
reactor_symbol='\u2622 '
danger_symbol='\u2620 '

which bc > /dev/null 2>&1; status=$?
[[ ${status} -ne 0 ]] && \
{
  echo "You need to install bc.";
  exit 1;
}
which wget > /dev/null 2>&1; status=$?
[[ ${status} -ne 0 ]] && \
{
  echo "You need to install wget.";
  exit 1;
}

mkdir -p ${DIR}
[[ "x$( find ${DIR} -type f -mmin -${stale_minutes}|wc -l )" == "x0" ]] && \
{
  echo "* Fetching data..."
  wget -qO ${FILE} ${URL};
}

echo
echo "  Radiation "$( stat --format=%y $FILE |cut -c 1-16 )
echo "  --------------------------"

[[ ! -s $FILE ]] && { echo "No data!"; exit 1; }

for city in ${cities[@]}; do
  # Check if city contains a reactor
  reactor='  '
  [[ "x$( echo ${city} | grep -c '*' )" == "x1" ]] && \
  {
	reactor=${reactor_symbol};
	city=$( echo ${city} | tr -d '*' );
  }

  # Parse citys data
  line=$( grep -si -R3 ${city} $FILE |tail -n1|cut -d '>' -f 2|cut -d '<' -f 1 )
  [[ "x${line}" == "x" ]] && \
  {
    printf "%-16b" "  ${city}"
    echo -e "   no data"
    continue;
  }

  # Check if value is abnormally high
  danger=' '
  [[ $(echo "${line}>${danger_limit}"|bc) -gt 0 ]] && danger=${danger_symbol}

  # Format values
  format=$normal; [[ $(echo "${line}>${bold_limit}"|bc) -gt 0 ]] && format=${bold}

  # Print resulting line
  echo -en "${reactor}"
  printf "%-16b" "${city}"
  echo -e "${format}${line}${normal} µSv/h ${danger}"
done

exit 0
