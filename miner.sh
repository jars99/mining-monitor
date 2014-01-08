cd /home/jars99/mine/
export DISPLAY=:0
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
screen -dmS miner ./cgminer --scrypt --url=stratum+tcp://coinotron.com:3334 -u jars99.lack -p x -w 256 -v 1 -g 1 -l 1 -d 0,1,2,3 --thread-concurrency 17920 --temp-target 75 --gpu-memclock 1250,1250,1250,1250 --gpu-engine 900,925,880,880 --gpu-fan 100 -I 16,20,14,14 2>&1 > log1
exit 0
