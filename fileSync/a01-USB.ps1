# $env:BACKUPDATAFOLDER="/media/wang/705fc396-8c76-4812-9d0b-d17382d9dfc7/backup"
# $env:BACKUPDATAFOLDER="E:/data"
#$env:BACKUPDATAFOLDER="d:/data"

$env:SUBFOLDERS="b:tem:t" # : 分割的subfolder'name

$env:CMD_STRING="toUSBDisk"
# $env:CMD_STRING="fromUSBDisk"





#################
.  "00-envset.ps1"
julia  Entrybackup.jl
