#!/usr/bin/env python
import psutil
# gives a single float value
psutil.cpu_percent()
# gives an object with many fields
psutil.virtual_memory()
# you can convert that object to a dictionary
dict(psutil.virtual_memory()._asdict())
# you can have the percentage of used RAM
psutil.virtual_memory().percent
79.2
# you can calculate percentage of available memory
psutil.virtual_memory().available * 100 / psutil.virtual_memory().total
20.8



get average cpu usage
get average ram usage
get disk space usage
get psm health

import shutil
print(shutil.disk_usage("F:\\"))
usage(total=128857235456, used=113601175552, free=15256059904)
shutil.disk_usage(path)
    def formatSize(bytes):
        try:
            bytes = float(bytes)
            kb = bytes / 1024
        except:
            return "Error"
        if kb >= 1024:
            M = kb / 1024
            if M >= 1024:
                G = M / 1024
                return "%.2fG" % (G)
            else:
                return "%.2fM" % (M)
        else:
            return "%.2fkb" % (kb)
usage = shutil.disk_usage("F:\\")
free_space = formatSize(usage[2])
print(free_space)
