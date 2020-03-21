###############################################################################
include("copyFolder.jl")
using Base.Filesystem
MAINFolder="---"
try 
	global MAINFolder
	MAINFolder = ENV["BACKUPDATAFOLDER"]
	# println( MAINFolder )
catch e
	println("请定义环境变量  BACKUPDATAFOLDER 为   本地主机硬盘存储数据文件的文件夹位置 ，比如： set BACKUPDATAFOLDER=e:\\data")
	exit()
end

println( "Local Machine Folder is:", MAINFolder)

function cpTOLocalDIsk(subfolders= ["b","tem","t"] ) 
 	srcRoot= "../"
	tgrRoot=MAINFolder
	for folder in subfolders
        proCopyFolder( "$srcRoot/$folder","$tgrRoot/$folder")
	end
end


function cpToUSBDIsk(subfolders= ["b","tem","t"]) 
	srcRoot=MAINFolder
	tgrRoot= "../"
	for folder in  subfolders
        proCopyFolder( "$srcRoot/$folder","$tgrRoot/$folder")
	end
end

###########################################################################################################################

subfolders= ["b","tem","t"]
try 
	global subfolders
	subfolders1 = ENV["SUBFOLDERS"]
	subfolders=split(subfolders1,":")
	println( "::",subfolders )
catch e
	println("请定义环境变量  SUBFOLDERS 为 从主机复制数据到本盘（toUSBDisk），还是从本盘复制数据到主机（fromUSBDisk） ，比如： set BACKUPDATAFOLDER=e:\\data")
end
cmd_STRING=""
try 
	global cmd_STRING
	cmd_STRING=ENV["CMD_STRING"] # toUSBDisk or fromUSBDisk
	# subfolders = ENV["SUBFOLDERS"].split(":")
	
catch e
	println("请定义环境变量  CMD_STRING 为 从主机复制数据到本盘（toUSBDisk），还是从本盘复制数据到主机（fromUSBDisk） ，比如： set BACKUPDATAFOLDER=e:\\data")
	exit()
end
println("--:", cmd_STRING )
if cmd_STRING=="toUSBDisk" 
	cpToUSBDIsk(subfolders)
else
	if cmd_STRING=="fromUSBDisk" 
		cpTOLocalDIsk(subfolders)
	else
		println( "::请定义环境变量的值 CMD_STRING 为 fromUSBDisk 或者 toUSBDisk ")
	end
end
#
#
