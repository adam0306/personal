import os
import pwd
import grp

all_groups = grp.getgrpall()
print(all_groups)

files = glob.glob('/data/*')
for f in files:
    os.remove(f)

if not os.path.exists(directory):
    os.makedirs(directory)

f = open("E:\\sample", "wb")
size = 1073741824 # bytes in 1 GiB
f.write("\0" * size)


folder = '/path/to/folder'
for the_file in os.listdir(folder):
    file_path = os.path.join(folder, the_file)
    try:
        if os.path.isfile(file_path):
            os.unlink(file_path)
        #elif os.path.isdir(file_path): shutil.rmtree(file_path)
    except Exception as e:
        print(e)
