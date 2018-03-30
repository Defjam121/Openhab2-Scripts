# Roomba980-Python

Diese Anleitung beschreibt die Installation und Konfiguration von Roomba980-Python auf einem Ubuntu-Server und die Steuerung mittels Openhab2 über MQTT. \\
\\
[Roomba980-Python Github](https///github.com/NickWaterton/Roomba980-Python)
\\
## Server vorbereiten

### Python, virtualenv und Ordner/Benutzer

System updaten und Python/Python-pip installieren.

        :::bash
        sudo apt-get update && sudo apt-get install python-pip python3-dev --yes
        sudo pip install --upgrade virtualenv


Ordner anlegen, Berechtigung setzen und Python mittels virtualenv im erstellten Ordner installieren.

        :::bash
        sudo mkdir /srv/roomba
        sudo chown helpi:helpi /srv/roomba
        sudo su -s /bin/bash
        virtualenv -p python3 /srv/roomba
        source /srv/roomba/bin/activate

## Roomba980-Python laden und installieren

In neuen Ordner wechseln, [Roomba980-Python Github](https///github.com/NickWaterton/Roomba980-Python) laden und installieren.

        :::bash
        cd /srv/roomba
        pip install git+https://github.com/NickWaterton/Roomba980-Python.git

anschließend kann die Installation mittels ''roomba -h'' getestet werden.

## Python-Datei erstellen und Daten anpassen

''nano roomba_mqtt.py'' \\
aufklappen
`<hidden>`
`<code python roomba_mqtt.py>`
from __future__ import print_function
from roomba import Roomba
import paho.mqtt.client as mqtt
import time
import json

#put your own values here

broker = '192.168.2.142'    #ip of mqtt broker
user = 'user'           #mqtt username
password = 'password'   #mqtt password
#broker = None if not using local mqtt broker

address = "192.168.2.121"
blid = "3143C91072035810"
roombaPassword = ":1:1507202717:y6peZqFZPdhy7wS9"

def broker_on_connect(client, userdata, flags, rc):
    print("Broker Connected with result code "+str(rc))
    #subscribe to roomba feedback
    if rc == 0:
        mqttc.subscribe(brokerCommand)
        mqttc.subscribe(brokerSetting)

def broker_on_message(mosq, obj, msg):
    #publish to roomba
    if "command" in msg.topic:
        print("Received COMMAND: %s" % str(msg.payload))
        myroomba.send_command(str(msg.payload))
    elif "setting" in msg.topic:
        print("Received SETTING: %s" % str(msg.payload))
        cmd = str(msg.payload).split()
        myroomba.set_preference(cmd[0], cmd[1])

def broker_on_publish(mosq, obj, mid):
    pass

def broker_on_subscribe(mosq, obj, mid, granted_qos):
    print("Broker Subscribed: %s %s" % (str(mid), str(granted_qos)))

def broker_on_disconnect(mosq, obj, rc):
    print("Broker disconnected")

def broker_on_log(mosq, obj, level, string):
    print(string)


mqttc = None
if broker is not None:
    brokerCommand = "/roomba/command"
    brokerSetting = "/roomba/setting"
    brokerFeedback = "/roomba/feedback"

    #connect to broker
    mqttc = mqtt.Client()
    #Assign event callbacks
    mqttc.on_message = broker_on_message
    mqttc.on_connect = broker_on_connect
    mqttc.on_disconnect = broker_on_disconnect
    mqttc.on_publish = broker_on_publish
    mqttc.on_subscribe = broker_on_subscribe

    try:
        mqttc.username_pw_set(user, password)  #put your own mqtt user and password here if you are using them, otherwise comment out
        mqttc.connect(broker, 1883, 60) #Ping MQTT broker every 60 seconds if no data is published from this script.

    except Exception as e:
        print("Unable to connect to MQTT Broker: %s" % e)
        mqttc = None

#myroomba = Roomba()  #minnimum required to connect on Linux Debian system, will read connection from config file

myroomba = Roomba(address, blid, roombaPassword, topic="#", continuous=True, clean=False)  #setting things manually

#all these are optional, if you don't include them, the defaults will work just fine

#if you are using maps
myroomba.enable_map(enable=False, mapSize="(800,1650,-300,-50,2,0)", mapPath="/srv/roomba/res", iconPath="/srv/roomba/res")  #enable live maps, class default is no maps
if broker is not None:
    myroomba.set_mqtt_client(mqttc, brokerFeedback) #if you want to publish Roomba data to your own mqtt broker (default is not to) if you have more than one roomba, and assign a roombaName, it is addded to this topic (ie brokerFeedback/roombaName)
#finally connect to Roomba - (required!)

myroomba.connect()

print("`<CMTRL C>` to exit")
print("Subscribe to /roomba/feedback/# to see published data")

try:
    if mqttc is not None:
        mqttc.loop_forever()
    else:
        while True:
            print("Roomba Data: %s" % json.dumps(myroomba.master_state, indent=2))
            time.sleep(5)

except (KeyboardInterrupt, SystemExit):
    print("System exit Received - Exiting program")
    myroomba.disconnect()
    if mqttc is not None:
        mqttc.disconnect()
`</code>`
`</hidden>`
## Openhab2 Konfigurationen

### Items

`<hidden>`

        :::java
        /* Roomba items */
        Group roomba_items  "Roomba"        `<roomba>`        (gGF)

        /* Roomba Commands */
        String roomba_command "Roomba" `<roomba>` (roomba_items) {mqtt=">[proliant:/roomba/command:command:*:default]"}
        /* Settings */
        Switch roomba_edgeClean    "Edge Clean [%s]" `<switch>` (roomba_items) {mqtt=">[proliant:/roomba/setting:command:ON:openOnly false],>[proliant:/roomba/setting:command:OFF:openOnly true],<[proliant:/roomba/feedback/openOnly:state:MAP(inverse_switch.map)]"}
        Switch roomba_carpetBoost  "Auto carpet Boost [%s]" `<switch>` (roomba_items) {mqtt=">[proliant:/roomba/setting:command:ON:carpetBoost true],>[proliant:/roomba/setting:command:OFF:carpetBoost false],<[proliant:/roomba/feedback/carpetBoost:state:MAP(switch.map)]"}
        Switch roomba_vacHigh      "Vacuum Boost [%s]" `<switch>` (roomba_items) {mqtt=">[proliant:/roomba/setting:command:ON:vacHigh true],>[proliant:/roomba/setting:command:OFF:vacHigh false],<[proliant:/roomba/feedback/vacHigh:state:MAP(switch.map)]", autoupdate=false}
        Switch roomba_noAutoPasses "Auto Passes [%s]" `<switch>` (roomba_items) {mqtt=">[proliant:/roomba/setting:command:ON:noAutoPasses false],>[proliant:/roomba/setting:command:OFF:noAutoPasses true],<[proliant:/roomba/feedback/noAutoPasses:state:MAP(inverse_switch.map)]"}
        Switch roomba_twoPass      "Two Passes [%s]" `<switch>` (roomba_items) {mqtt=">[proliant:/roomba/setting:command:ON:twoPass true],>[proliant:/roomba/setting:command:OFF:twoPass false],<[proliant:/roomba/feedback/twoPass:state:MAP(switch.map)]"}
        Switch roomba_binPause     "Always Complete (even if bin is full) [%s]" `<switch>` (roomba_items) {mqtt=">[proliant:/roomba/setting:command:ON:binPause false],>[proliant:/roomba/setting:command:OFF:binPause true],<[proliant:/roomba/feedback/binPause:state:MAP(inverse_switch.map)]"}
        /* Roomba Feedback */
        String roomba_softwareVer  "Software Version [%s]" `<text>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/softwareVer:state:default]"}
        Number roomba_batPct "Battery [%d%%]" `<battery>` (roomba_items, Battery)  {mqtt="<[proliant:/roomba/feedback/batPct:state:default]"}
        String roomba_lastcommand  "Last Command [%s]" `<roomba>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/lastCommand_command:state:default]"}
        Switch roomba_bin_present  "Bin Present [%s]" `<trashpresent>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/bin_present:state:MAP(switch.map)]"}
        Switch roomba_full   "Bin Full [%s]" `<trash>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/bin_full:state:MAP(switch.map)]"}
        /* Mission values */
        String roomba_mission  "Mission [%s]" `<msg>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_cycle:state:default]"}
        Number roomba_nMssn    "Cleaning Mission Number [%d]" `<number>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_nMssn:state:default]"}
        String roomba_phase    "Phase [%s]" `<msg>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_phase:state:default]"}
        String roomba_initiator  "Initiator [%s]" `<msg>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_initiator:state:default]"}
        Switch roomba_error "Error [%]" `<roombaerror>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_error:state:MAP(switchFromMqtt.map)]"}
        String roomba_errortext  "Error Message [%s]" `<msg>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/error_message:state:default]"}
        Number roomba_mssnM "Cleaning Elapsed Time [%d m]" `<clock>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_mssnM:state:default]"}
        Number roomba_sqft "Square Ft Cleaned [%d]" `<groundfloor>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_sqft:state:default]"}
        Number roomba_expireM "Mission Recharge Time [%d m]" `<clock>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_expireM:state:default]"}
        Number roomba_rechrgM "Remaining Time To Recharge [%d m]" `<clock>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/cleanMissionStatus_rechrgM:state:default]"}
        String roomba_status    "Status [%s]" `<msg>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/state:state:default]"}
        Dimmer roomba_percent_complete    "Mission % Completed [%d%%]" `<humidity>` (roomba_items)
        DateTime roomba_lastmissioncompleted "Last Mission Completed [%1$ta %1$tR]" `<calendar>`
        /* Schedule */
        String roomba_cycle   "Day of Week [%s]" `<calendar>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/cleanSchedule_cycle:state:default]"}
        String roomba_cleanSchedule_h   "Hour of Day [%s]" `<clock>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/cleanSchedule_h:state:default]"}
        String roomba_cleanSchedule_m   "Minute of Hour [%s]" `<clock>` (roomba_items) {mqtt="<[proliant:/roomba/feedback/cleanSchedule_m:state:default]"}
        String roomba_cleanSchedule "Schedule [%s]" `<calendar>` (roomba_items)
        /* General */
        Switch roomba_control "Roomba ON/OFF [%s]" `<switch>` (roomba_items)
        Number roomba_theta "Theta [%d]" `<angle>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/pose_theta:state:default]"}
        Number roomba_x "X [%d]" `<map>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/pose_point_x:state:default]"}
        Number roomba_y "Y [%d]" `<map>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/pose_point_y:state:default]"}
        Number roomba_rssi "RSSI [%d]" `<network>` (roomba_items)  {mqtt="<[proliant:/roomba/feedback/signal_rssi:state:default]"}
        DateTime roomba_lastheardfrom "Last Update [%1$ta %1$tR]" `<clock>`

`</hidden>`
### Map Files

`<hidden>`

        :::java
        /etc/openhab2/transform/switch.map
        ON=ON
        OFF=OFF
        0=OFF
        1=ON
        True=ON
        False=OFF
        true=ON
        false=OFF
        -=Unknown
        NULL=Unknown

        /etc/openhab2/transform/inverse_switch.map
        ON=OFF
        OFF=ON
        0=ON
        1=OFF
        True=OFF
        False=ON
        true=OFF
        false=ON
        -=Unknown
        NULL=Unknown

        /etc/openhab2/transform/switchFromMqtt.map
        -=Unknonwn
        NULL=Unknown
        OFF=OFF
        0=OFF
        1=ON
        2=ON
        3=ON
        4=ON
        5=ON
        6=ON
        7=ON
        8=ON
        9=ON
        10=ON
        11=ON
        12=ON
        13=ON
        14=ON
        15=ON
        16=ON
        17=ON
        18=ON
        19=ON
        20=ON
        21=ON
        22=ON
        23=ON
        24=ON
        25=ON
        26=ON
        27=ON
        28=ON
        29=ON
        30=ON
        31=ON
        32=ON
        33=ON
        34=ON
        35=ON
        36=ON
        37=ON
        38=ON
        39=ON
        40=ON
        41=ON
        42=ON
        43=ON
        44=ON
        45=ON
        46=ON
        47=ON
        48=ON
        49=ON
        50=ON
        51=ON
        52=ON
        53=ON
        54=ON
        55=ON
        56=ON
        57=ON
        58=ON
        59=ON
        60=ON
        61=ON
        62=ON
        63=ON
        64=ON
        65=ON
        66=ON
        67=ON
        68=ON
        69=ON
        70=ON
        71=ON
        72=ON
        73=ON
        74=ON
        75=ON
        76=ON
        77=ON
        78=ON
        79=ON
        80=ON
        81=ON
        82=ON
        83=ON
        84=ON
        85=ON
        86=ON
        87=ON
        88=ON
        89=ON
        90=ON
        91=ON
        92=ON
        93=ON
        94=ON
        95=ON
        96=ON
        97=ON
        98=ON
        99=ON
        100=ON
        101=ON
        102=ON
        103=ON
        104=ON
        105=ON
        106=ON
        107=ON
        108=ON
        109=ON
        110=ON
        111=ON
        112=ON
        113=ON
        114=ON
        115=ON
        116=ON
        117=ON
        118=ON
        119=ON
        120=ON
        121=ON
        122=ON
        123=ON
        124=ON
        125=ON
        126=ON
        127=ON
        128=ON
        129=ON
        130=ON
        131=ON
        132=ON
        133=ON
        134=ON
        135=ON
        136=ON
        137=ON
        138=ON
        139=ON
        140=ON
        141=ON
        142=ON
        143=ON
        144=ON
        145=ON
        146=ON
        147=ON
        148=ON
        149=ON
        150=ON
        151=ON
        152=ON
        153=ON
        154=ON
        155=ON
        156=ON
        157=ON
        158=ON
        159=ON
        160=ON
        161=ON
        162=ON
        163=ON
        164=ON
        165=ON
        166=ON
        167=ON
        168=ON
        169=ON
        170=ON
        171=ON
        172=ON
        173=ON
        174=ON
        175=ON
        176=ON
        177=ON
        178=ON
        179=ON
        180=ON
        181=ON
        182=ON
        183=ON
        184=ON
        185=ON
        186=ON
        187=ON
        188=ON
        189=ON
        190=ON
        191=ON
        192=ON
        193=ON
        194=ON
        195=ON
        196=ON
        197=ON
        198=ON
        199=ON
        200=ON
        201=ON
        202=ON
        203=ON
        204=ON
        205=ON
        206=ON
        207=ON
        208=ON
        209=ON
        210=ON
        211=ON
        212=ON
        213=ON
        214=ON
        215=ON
        216=ON
        217=ON
        218=ON
        219=ON
        220=ON
        221=ON
        222=ON
        223=ON
        224=ON
        225=ON
        226=ON
        227=ON
        228=ON
        229=ON
        230=ON
        231=ON
        232=ON
        233=ON
        234=ON
        235=ON
        236=ON
        237=ON
        238=ON
        239=ON
        240=ON
        241=ON
        242=ON
        243=ON
        244=ON
        245=ON
        246=ON
        247=ON
        248=ON
        249=ON
        250=ON
        251=ON
        252=ON
        253=ON
        254=ON
        255=ON
        256=ON
        ON=ON

`</hidden>`

### Rules

`<hidden>`

        :::java
        import java.util.Calendar

        import java.util.TimeZone
        var Timer roombaTimer = null
        val int waitMinutes = 25
        val Functions$Function2`<GenericItem, String, String>` getTimestamp = [  //function (lambda) to get a timestamp. Returns formatted string and optionally updates an item
            item,
            date_format |

            var date_time_format = date_format
            var local_time = java::util::Calendar::getInstance(TimeZone::getTimeZone("Europe/Berlin"))
            if(date_format == "" || date_format == null) date_time_format = "%1$ta %1$tT" //default format Day Hour:Minute:Seconds
            var String Timestamp = String::format( date_time_format, new DateTimeType(local_time))
            if(item != NULL && item != null) {
                var Long time = now().getMillis()    //current time (/1000?)
                var cal = new java.util.GregorianCalendar()
                cal.setTimeInMillis(time)  //timestamp in unix format
                var t = new DateTimeType(cal)

                if(item instanceof DateTimeItem) {
                    postUpdate(item, t)
                    logInfo("Last Update", item.name + " DateTimeItem updated at: " + Timestamp )
                    }
                else if(item instanceof StringItem) {
                    postUpdate(item, Timestamp)
                    logInfo("Last Update", item.name + " StringItem updated at: " + Timestamp )
                    }
                else
                    logWarn("Last Update", item.name + " is not DateTime or String - not updating")
            }
            Timestamp
            ]
        /*
        //------------------------------------------------------------------------
        //    Start saugen, wenn nicht zuhause
        //------------------------------------------------------------------------
        rule "Anwesenheit Kontrolle und Starten/stoppen von Reinigung"
        when
                Item marc_presence changed
        then
                if((roomba_auto_saugen.state == ON)&&(roomba_counter.state > 2)) {
                if(marc_presence.state == OFF) {
                        logInfo("Roomba", "Roomba Timer gestartet")
                        roombaTimer = createTimer(now.plusMinutes(waitMinutes)) [|
                                        logInfo("Roomba", "Roomba gestartet")
                                        pushNotification("Roomba", "Reinigung gestartet")
                                        sendCommand(roomba_control2, 1)
                                        postUpdate(roomba_counter, 0)
                                        ]
                }
                else {
                        if(waitMinutes == null) {
                                logInfo("Roomba", "Roomba gestoppt")
                        sendCommand(roomba_control2, 2)
                        Thread::sleep(8000);
                        sendCommand(roomba_control2, 2)
                        postUpdate(roomba_counter, 0)
                }
                else {
                        logInfo("Roomba", "waitTimer reset")
                        roombaTimer.cancel()
                }
                }
        }
        end

        *
        */

        /* Roomba Rules */
        rule "Roomba start and stop"
        when
            Item roomba_control received command
        then
            logInfo("Roomba", "Roomba ON/OFF received command: " + receivedCommand)
            if (receivedCommand == ON)
                sendCommand(roomba_command, "start")
            if (receivedCommand == OFF) {
                sendCommand(roomba_command, "stop")
                Thread::sleep(1000)
                sendCommand(roomba_command, "dock")
            }
        end

        rule "Roomba Auto Boost Control"
        when
            Item roomba_carpetBoost changed
        then
            logInfo("Roomba", "Roomba Boost changed to: Auto " + roomba_carpetBoost.state + " Manual: " + roomba_vacHigh.state)
            if (roomba_carpetBoost.state == ON && roomba_vacHigh.state == ON)
                sendCommand(roomba_vacHigh, OFF)
        end

        rule "Roomba Manual Boost Control"
        when
            Item roomba_vacHigh changed
        then
            logInfo("Roomba", "Roomba Boost changed to: Auto " + roomba_carpetBoost.state + " Manual: " + roomba_vacHigh.state)
            if (roomba_carpetBoost.state == ON && roomba_vacHigh.state == ON)
                sendCommand(roomba_carpetBoost, OFF)
        end

        rule "Roomba Auto Passes Control"
        when
            Item roomba_noAutoPasses changed or
            Item roomba_twoPass changed
        then
            logInfo("Roomba", "Roomba Passes changed to: Auto " + roomba_noAutoPasses.state + " Manual: " + roomba_twoPass.state)
            if (roomba_noAutoPasses.state == ON && roomba_twoPass.state == ON)
                sendCommand(roomba_twoPass, OFF)
        end

        rule "Roomba Last Update Timestamp"
        when
            Item roomba_rssi received update
        then
            getTimestamp.apply(roomba_lastheardfrom, "%1$ta %1$tR")
        end

        rule "Roomba Bin Full"
        when
            Item roomba_full changed from OFF to ON
        then
            val Timestamp = getTimestamp.apply(roomba_lastheardfrom, "%1$ta %1$tR")
            pushNotification("Roomba", "BIN FULL reported by Roomba at: " + Timestamp)
        end

        rule "Roomba Error"
        when
            Item roomba_error changed from OFF to ON
        then
            val Timestamp = getTimestamp.apply(roomba_lastheardfrom, "%1$ta %1$tR")
            pushNotification("Roomba", "ERROR reported by Roomba at: " + Timestamp)
            *sendMail(mailTo, "Roomba", "ERROR reported by Roomba at: " + Timestamp + "See attachment for details", "http:*your_OH_ip:port/static/map.png")
        end

        rule "Roomba percent completed"
        when
            Item roomba_sqft received update
        then
            var sqft_completed = roomba_sqft.state as Number

            var max_sqft = 470  //insert max square footage here
            var min_sqft = 0

            var Number completed_percent = 0

            if (sqft_completed < min_sqft) {completed_percent = 0}
            else if (sqft_completed > max_sqft) {completed_percent = 100}
            else {
                completed_percent = (((sqft_completed - min_sqft) * 100) / (max_sqft-min_sqft)).intValue
                }
            logInfo("Roomba", "Roomba percent complete "+roomba_sqft.state+" of "+max_sqft.toString+" calculated as " + completed_percent.toString + "%")
            postUpdate(roomba_percent_complete,completed_percent)
        end

        rule "Roomba update command"
        when
            Item roomba_phase received update
        then
            logInfo("Roomba", "Roomba phase received update: " + roomba_phase.state)
            switch(roomba_phase.state) {
                case "run"          : postUpdate(roomba_command,"start")
                case "hmUsrDock"    : postUpdate(roomba_command,"pause")
                case "hmMidMsn"     : postUpdate(roomba_command,"pause")
                case "hmPostMsn"    : {
                                      postUpdate(roomba_command,"dock")
                                      getTimestamp.apply(roomba_lastmissioncompleted, "%1$ta %1$tR")
                                      }
                case "charge"       : postUpdate(roomba_command,"dock")
                case "stop"         : postUpdate(roomba_command,"stop")
                case "pause"        : postUpdate(roomba_command,"pause")
                case "stuck"        : postUpdate(roomba_command,"stop")
            }
        end

        rule "Roomba Notifications"
        when
            Item roomba_status changed
        then
            logInfo("Roomba", "Roomba status is: " + roomba_status.state)
            val Timestamp = getTimestamp.apply(roomba_lastheardfrom, "%1$ta %1$tR")
            switch(roomba_status.state) {
                case "Running"                  : pushNotification("Roomba", "Roomba is RUNNING at: " + Timestamp)
                case "Docking - End Mission"    : {
                                                  createTimer(now.plusSeconds(2)) [|
                                                      pushNotification("Roomba", "Roomba has FINISHED cleaning at: " + Timestamp)
                                                      *sendMail(mailTo, "Roomba", "Roomba has FINISHED cleaning at: " + Timestamp + "See attachment for details", "http:*your_OH_ip:port/static/map.png")
                                                      ]
                                                  }
                case "Stuck"                    : {
                                                  pushNotification("Roomba", "HELP! Roomba is STUCK at: " + Timestamp)
                                                  *sendMail(mailTo, "Roomba", "HELP! Roomba is STUCK at: " + Timestamp + "See attachment for location", "http:*your_OH_ip:port/static/map.png")
                                                  }
            }
        end

`</hidden>`
