include("copyFolder.jl")
using Base.Filesystem


ElementsSEB="/media/wang/ElementsSEB"
LinuxData_1T="/media/wang/LinuxData_1T"
Ex4= "/media/wang/ext4"
TwoTData = "/media/wang/2TData"
########################################

USB_64G ="/media/wang/64G-USB"
JXDocs = "/media/wang/JXdocs/USB_64G"
BackuRoot="backup"



BRIX8250Root=Base.Filesystem.joinpath(  JXDocs )
USB64GRoot=Base.Filesystem.joinpath(  USB_64G ,"" )

srcRoot= BRIX8250Root
tgrRoot=USB64GRoot
for folder in ["a","tem"]
        proCopyFolder( "$srcRoot/$folder","$tgrRoot/$folder")
end




