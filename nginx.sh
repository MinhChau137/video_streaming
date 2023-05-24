#!/bin/bash
echo "nginx: starting up nginx..."
/usr/local/nginx/sbin/nginx
echo "nginx is running..."
sourceVideoStreamWidth=3840
sourceVideoStreamHeight=2160
if [ -z "$RESOLUTION" ];
then
    resolution=$sourceVideoStreamWidth"x"$sourceVideoStreamHeight
    echo "Resolution value not found in setting. Using default setting "$resolution
ffmpeg -re -stream_loop -1 -i "video4k.mp4" -s "$resolution" -f flv "rtmp://localhost/live/stream"
else
    if [ "$sourceVideoStreamWidth" != "" ]; then
        widthStream=$(($sourceVideoStreamWidth*$RESOLUTION/$sourceVideoStreamHeight))
        echo $widthStream
        if [ $(($widthStream%2)) -ne 0 ];
        then
            widthStream=$((widthStream+1))
        fi
        resolution=$widthStream"x"$RESOLUTION
        echo "Setting resolution of streaming to" $resolution
    ffmpeg -re -stream_loop -1 -i "video4k.mp4" -s "$resolution" -f flv "rtmp://localhost/live/stream"
        fi
fi
# 1920x1080p(FHD) = 2200kb
# 1280x720p(HD) = 1100kb
# 854x480p(SD)= 700kb
# 640x360p=500kb
# Just a loop to keep the container running
# ffmpeg -re -stream_loop -1  -i "video4k.mp4"  -r 30 -s 3840x2160 -f flv rtmp://localhost/live/stream
