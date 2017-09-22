### Varg
#!/usr/bin/env bash
#Variables
DFILE="/tmp/z.disk.pres.discovery.txt"
IFILE="/tmp/z.disk.pres.items.txt"

touch ${IFILE}
touch ${DFILE}
cp /dev/null ${IFILE}
chmod 664 ${IFILE}
chmod 664 ${DFILE}

#Make file with items
##Non-RAID values
DISKS=$(lsblk -S | grep "disk" | grep "ATA" | awk '{print $1}')

    for label in $DISKS
    do
    echo -n "$label " >> ${IFILE} && smartctl -i /dev/$label | grep "Device Model" >> ${IFILE}
    echo -n "$label " >> ${IFILE} && smartctl -i /dev/$label | grep "Serial Number" >> ${IFILE}
    done

##RAID values
DISKS_RAID=$(lsblk -S | grep "disk" | grep -v "ATA" | awk '{print $1}')

    if [ -n "$DISKS_RAID" ]
    then
    DISKS_RAID_ID=$(megacli -pdlist -a0| grep 'Device Id' | awk -F ': ' '{print $2}')
    for raid_label in $DISKS_RAID
    do
        for megaraid_id in $DISKS_RAID_ID
        do
        echo -n "${raid_label}.megaraid.$megaraid_id " >> ${IFILE} && smartctl -i -d sat+megaraid,$megaraid_id /dev/$raid_label | grep "Device Model" >> ${IFILE}
        echo -n "${raid_label}.megaraid.$megaraid_id " >> ${IFILE} && smartctl -i -d sat+megaraid,$megaraid_id /dev/$raid_label | grep "Serial Number" >> ${IFILE}
        done
    done
    fi

#Make file for discovery
echo '{ "data": [' > ${DFILE}

cat ${IFILE} | grep "Device Model" | awk '{print $1}' | while read LINE
    do
    echo "{\"{#DISK}\":\"$LINE\"}," >> ${DFILE}
    done

echo ']}' >> ${DFILE}

OMMALINE=$(cat ${DFILE} | wc -l)
OMMA=$(echo "${OMMALINE} - 1" | bc)
NEWDFILE=$(sed "${OMMA}s/,//" ${DFILE})
echo "${NEWDFILE}" > ${DFILE}

exit 0
