#/bin/bash
# This script generates images out of the Openhab RRD files.
# It runs async as the Pi is not powerful enough to handle this within Openhab iteself
PROGNAME=`basename $0`
LOGFILE="/tmp/${PROGNAME/.sh/.log}"
MY_IP="192.168.23.16"
RRDS_PATH="/var/lib/openhab/persistence/rrd4j"
PNG_DST_FOLDER="/usr/share/openhab/webapps/charts"

function to_logfile () {
    echo -e "$1" >> $LOGFILE
}

function get_chart () {
    local BASE_URL="http://${MY_IP}:8080/rrdchart.png?items="
    local ITEM="$1"
    local PERIOD="$2"
    case $PERIOD in 
        h)   local PERIOD_NAME="1hour";;
        4h)  local PERIOD_NAME="4hours";;
        8h)  local PERIOD_NAME="8hours";;
        12h) local PERIOD_NAME="12hours";;
        D)   local PERIOD_NAME="1day";;
        3D)  local PERIOD_NAME="3days";;
        W)   local PERIOD_NAME="1week";;
        2W)  local PERIOD_NAME="2weeks";;
        M)   local PERIOD_NAME="1month";;
        2M)  local PERIOD_NAME="2months";;
        4M)  local PERIOD_NAME="4months";;
        Y)   local PERIOD_NAME="1year";;
    esac
    to_logfile "Getting chart for item: $ITEM and period: $PERIOD ($PERIOD_NAME)"
    wget --timeout=10 "${BASE_URL}${ITEM}&period=${PERIOD}" -O ${PNG_DST_FOLDER}/${ITEM}.${PERIOD_NAME}.png > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        rm ${PNG_DST_FOLDER}/${ITEM}.${PERIOD_NAME}.png
        to_logfile "Error During download of image. Deliting broken image ${PNG_DST_FOLDER}/${ITEM}.${PERIOD_NAME}.png"
    fi
    # resize the default image
    #convert ${PNG_DST_FOLDER}/${ITEM}.${PERIOD_NAME}.png -resize 300 ${PNG_DST_FOLDER}/${ITEM}.${PERIOD_NAME}.png
}

# This cuntion creates the HTML page to be displayed
function create_html () {
    to_logfile "creating index.html now"
    CONTENT="<html>\n<head>\n\t<title>RRD graphs</title>\n</head>\n<body>\n"
    for CHART in `ls $PNG_DST_FOLDER/ |grep -v index`
    do
        CONTENT+="\t<a href=\"$CHART\">${CHART/.png}</a><br>\n"
    done
    CONTENT+="<a href=\"/tmp/create_rrd_charts.log\">Logfile</a><br>\n"
    CONTENT+="</body>\n</html>"
    echo -e "$CONTENT" > $PNG_DST_FOLDER/index.html
}


############################
# Main script
############################

# This is the list of items where charts should be created
if [ $# -gt 0 ]; then
    ITEMS="$1"
else
    ITEMS=`ls ${RRDS_PATH} | sed -e 's/.rrd//g'`
fi
to_logfile "Date run: `date +\"%Y%m%d-%H-%M-%S\"`"
to_logfile "Items: `echo $ITEMS | sed -e 's/\n//g'`"

for DEVICE in $ITEMS
do
    for PERIOD in D W M
    do
        get_chart $DEVICE $PERIOD
    done
done

# We also want the yearly Temperature
if [ "$DEVICE" == "Temperature" ]; then
    get_chart $DEVICE Y
fi

# Create the index.html now
create_html
to_logfile "All done @ `date +\"%Y%m%d-%H-%M-%S\"`\n\n"
exit 0
