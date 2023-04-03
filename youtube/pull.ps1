$channel= Get-Content .\youtube\videos.txt
$archive= Get-Content .\youtube\archive.txt

for each 

yt-dlp --downloadlast 7 days -download-archive youtube/archive.txt $uri
