#!/bin/sh
echo "$CRON_SCHEDULE /root/start.sh > /root/backup.log" > /var/spool/cron/crontabs/root

function perform_cleanup () {
    echo "Cleaning Up"
    rm -rf /root/backups/*
    rm -rf /root/backups-temp/*
}

function test_first_run () {
    echo "Checking if marker exists"
    test -f /root/first_run_complete
    if [[ "$?" -ne "0" ]]; then
        echo "Marker does not exist. Creating one."
        echo "1" > /root/first_run_complete
        return 0
    else
        echo "Marker already exists"
        return 1
    fi
}

function do_backup () {
    flag=1
    while [[ $flag -eq 1 ]]
    do
        ./backup.sh
        if [[ "$?" -eq "0" ]]; then
            flag=0
        else
            perform_cleanup
            echo "Failed. Will retry in 5 minutes."
            sleep 300
        fi
    done
}

function check_is_running () {
    is_running=`ps -ea | grep -c '{start.sh} /bin/sh /root/start.sh'`
    if [[ "$is_running" -lt 4 ]]; then
        return 0;
    else
        return 1;
    fi
}

if test_first_run ; then
    if [[ ! "$START_NOW" ]]; then
        echo "Not running immediately"
        exit
    fi
    echo "Backup job will run now."
fi
if  check_is_running ; then
    echo "No other instance running. Starting backup"
    do_backup
else
    echo "Another instance running. Exiting this one."
    exit
fi

perform_cleanup
