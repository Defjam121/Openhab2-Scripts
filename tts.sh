#!/bin/bash
/usr/bin/amixer cset numid=1 $2%

if [ -n "$3" ] ; then
    /usr/bin/aplay /scripts/audio/$3.wav &> /dev/null
fi

INPUT=$1
STRINGNUM=0
ary=($INPUT)

for key in "${!ary[@]}" ; do
    SHORTTMP[$STRINGNUM]="${SHORTTMP[$STRINGNUM]} ${ary[$key]}"
    LENGTH=$(echo ${#SHORTTMP[$STRINGNUM]})

    if [[ "$LENGTH" -lt "100" ]]; then
        SHORT[$STRINGNUM]=${SHORTTMP[$STRINGNUM]}
    else
        STRINGNUM=$(($STRINGNUM+1))
        SHORTTMP[$STRINGNUM]="${ary[$key]}"
        SHORT[$STRINGNUM]="${ary[$key]}"
    fi
done

for key in "${!SHORT[@]}" ; do
    say() { local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://api.voicerss.org/?key6d422973476c42649c6a69b01ebbdd78&f=22khz_16bit_mono&hl=de-de&src=${SHORT[$key]}"; }
    say $*
done
