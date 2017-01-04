#!/bin/bash -xv
sudo mount -a
if grep -qs '/mnt' /proc/mounts; then
    echo "It's mounted."
    device=`grep '/mnt' /etc/fstab|cut -f1`
    echo $device
    sudo umount /mnt
    sudo mke2fs -j -F $device
    sudo mount $device /var/lib/cassandra
    sudo chown -R cassandra:cassandra /var/lib/cassandra
else
    echo "It's not mounted."
fi
