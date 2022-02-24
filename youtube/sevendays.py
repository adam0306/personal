#########################################################
#                                                       #
# First try at making a script to download all of my    #
# Youtube Subscriptions for the past 7 days at the best #
# quality available along with storing the downloaded   #
# video identifiers.                                    #
#                                                       #
#########################################################

Set root download path of /video/youtube/
Set list of channel IDs
Map channel IDs to Name

channel = 
/usr/bin/youtube-dl --dateafter now-7days --download-archive download.txt -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 ""


youtube-dl --dateafter now-7days --download-archive download.txt -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "https://www.youtube.com/user/SecurityWeeklyTV/videos"
youtube-dl --dateafter now-7days --download-archive download.txt -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "https://www.youtube.com/user/TWiTSecurityNow/videos"