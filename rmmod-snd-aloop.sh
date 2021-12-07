cd /root/force_rmmod \
    && insmod force_rmmod.ko modname=snd_aloop \
    && rmmod snd_aloop \
    && rmmod force_rmmod
