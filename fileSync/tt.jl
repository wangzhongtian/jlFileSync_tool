using Base.Filesystem
lnname ="oho.ln"
ln=Base.Filesystem.readlink(lnname)
println(ln)
lnisdir = Base.Filesystem.isdir( lnname )
tgrisdir = Base.Filesystem.isdir( ln)
println( lnisdir,tgrisdir)

println( "-----",Base.Filesystem.readlink(lnname) )

lnisdir = Base.Filesystem.islink( lnname )
tgrisdir = Base.Filesystem.islink( ln)
println( lnisdir,tgrisdir)

lnisdir = Base.Filesystem.ispath( lnname )
tgrisdir = Base.Filesystem.ispath( ln)
println( lnisdir,tgrisdir)

println(Base.Filesystem.homedir() )



mtime= Base.Filesystem.mtime(lnname)

println(mtime)

using Dates
a=Dates.unix2datetime( mtime)
println(a)

