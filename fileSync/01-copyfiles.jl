include("copyFolder.jl")
using Base.Filesystem


ElementsSEB="/media/wang/ElementsSEB"
LinuxData_1T="/media/wang/LinuxData_1T"
Ex4= "/media/wang/ext4"
TwoTData = "/media/wang/2TData"

BackuRoot="backup"



srcRoot=Base.Filesystem.joinpath(  ElementsSEB ,BackuRoot )
tgrRoot=Base.Filesystem.joinpath(  TwoTData ,BackuRoot )


proCopyFolder( "$srcRoot","$tgrRoot")

