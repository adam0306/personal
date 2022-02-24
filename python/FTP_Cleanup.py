import grp
import pwd
import


every sunday night

check if dir exists
	check users group
	compare users to /data/ dir
	if no exists, create dir
clear all files
create files


os.makedirs(<directory>)

if not os.path.exists(directory):
    os.makedirs(directory)

f = open("E:\\sample", "wb")
size = 1073741824 # bytes in 1 GiB
f.write("\0" * size)


all_groups = grp.getgrpall()
print(all_groups)


import os
import path
import grp
import glob

files = glob.glob('/YOUR/PATH/*')
for f in files:
    os.remove(f)

import os, shutil
folder = '/path/to/folder'
for the_file in os.listdir(folder):
    file_path = os.path.join(folder, the_file)
    try:
        if os.path.isfile(file_path):
            os.unlink(file_path)
        #elif os.path.isdir(file_path): shutil.rmtree(file_path)
    except Exception as e:
        print(e)

rm -f /data/*
mkdir /data/chbain/
mkdir /data/ebudinic/
mkdir /data/mswoods/
mkdir /data/tejohnso/
mkdir /data/wdaberco/
dd if=/dev/zero of=/data/chbain/10MB.bin count=1 bs=10M
dd if=/dev/zero of=/data/chbain/100MB.bin count=1 bs=100M
dd if=/dev/zero of=/data/chbain/50MB.bin count=1 bs=50M
dd if=/dev/zero of=/data/chbain/1G.bin count=1 bs=1G
dd if=/dev/zero of=/data/ebudinic/10MB.bin count=1 bs=10M
dd if=/dev/zero of=/data/ebudinic/100MB.bin count=1 bs=100M
dd if=/dev/zero of=/data/ebudinic/50MB.bin count=1 bs=50M
dd if=/dev/zero of=/data/ebudinic/1G.bin count=1 bs=1G
dd if=/dev/zero of=/data/mswoods/10MB.bin count=1 bs=10M
dd if=/dev/zero of=/data/mswoods/100MB.bin count=1 bs=100M
dd if=/dev/zero of=/data/mswoods/50MB.bin count=1 bs=50M
dd if=/dev/zero of=/data/mswoods/1G.bin count=1 bs=1G
dd if=/dev/zero of=/data/tejohnso/10MB.bin count=1 bs=10M
dd if=/dev/zero of=/data/tejohnso/100MB.bin count=1 bs=100M
dd if=/dev/zero of=/data/tejohnso/50MB.bin count=1 bs=50M
dd if=/dev/zero of=/data/tejohnso/1G.bin count=1 bs=1G
dd if=/dev/zero of=/data/wdaberco/10MB.bin count=1 bs=10M
dd if=/dev/zero of=/data/wdaberco/100MB.bin count=1 bs=100M
dd if=/dev/zero of=/data/wdaberco/50MB.bin count=1 bs=50M
dd if=/dev/zero of=/data/wdaberco/1G.bin count=1 bs=1G
