#!/bin/bash

if [ "$1" = 'rundeck' ]
then
       
    mkdir -p /data/etc /data/ssh /data/projects /var/lib/rundeck/.ssh
    chown rundeck:rundeck /data/etc /data/ssh /data/projects /var/lib/rundeck/.ssh
    
    for FILE in `ls /etc/rundeck`
    do
      if [ ! -f /data/etc/$FILE ] && [ -f /root/rundeck-config/$FILE ]
      then
        cp /root/rundeck-config/$FILE /data/etc/$FILE
        chown rundeck:rundeck /data/etc/$FILE
        rm /etc/rundeck/$FILE
        ln -s /data/etc/$FILE /etc/rundeck/$FILE
      elif [ -f /data/etc/$FILE ]
      then 
        rm /etc/rundeck/$FILE
        ln -s /data/etc/$FILE /etc/rundeck/$FILE
      fi
    done

    if [ ! -L /var/rundeck/projects ] && [ ! "$(ls -A /var/rundeck/projects)" ]
    then
      rmdir /var/rundeck/projects
      ln -s /data/projects/ /var/rundeck/projects
    fi
  
    # Special case initial realm.properties
    if [ ! -f /data/etc/realm.properties ]
    then
      envtpl -o /data/etc/realm.properties --allow-missing --keep-template /root/rundeck-config-templates/realm.properties
      chown rundeck:rundeck /data/etc/realm.properties
    fi
    rm /etc/rundeck/realm.properties
    ln -s /data/etc/realm.properties /etc/rundeck/realm.properties

    # Configure rundeck via envtpl
    rm /etc/rundeck/rundeck-config.properties
    envtpl -o /etc/rundeck/rundeck-config.properties --allow-missing --keep-template /root/rundeck-config-templates/rundeck-config.properties
    chown rundeck:rundeck /etc/rundeck/rundeck-config.properties
    
    # Configure profile
    if [ -f /etc/default/rundeckd ]
    then
      rm /etc/default/rundeckd
    fi
    envtpl -o /etc/default/rundeckd --allow-missing --keep-template /root/rundeck-config-templates/rundeckd
    
    # Configure ssh
    cp /root/rundeck-config-templates/config_ssh /var/lib/rundeck/.ssh/config
    chown rundeck:rundeck /var/lib/rundeck/.ssh/config
    ln -s /data/ssh/id_rsa /var/lib/rundeck/.ssh/id_rsa

    echo "starting rundeck service..."
    service rundeckd start
    
    touch /var/log/rundeck/rundeck.log
    chown rundeck:adm /var/log/rundeck/rundeck.log
    
    sleep 10
    
    tail -f /var/log/rundeck/rundeck.log

    # stop service and clean up here
    echo "stopping rundeck service..."
    service rundeckd stop
    echo "exited $0"
else
    exec "$@"
fi
 
