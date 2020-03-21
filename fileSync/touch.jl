using Base.Filesystem

 import .Base: 
     IOError, _UVError, _sizeof_uv_fs, check_open, close, eof, eventloop, fd, isopen, 
     bytesavailable, position, read, read!, readavailable, seek, seekend, show, 
     skip, stat, unsafe_read, unsafe_write, write, transcode, uv_error, 
     rawhandle, OS_HANDLE, INVALID_OS_HANDLE, windowserror 
  

# We can see the [`mtime`](@ref) has been modified by `touch`.
function futime1(f::File, atime::Float64, mtime::Float64) 
            check_open(f) 
             req = Libc.malloc(_sizeof_uv_fs) 
            err = ccall(:uv_fs_futime, Int32, 
                        (Ptr{Cvoid}, Ptr{Cvoid}, OS_HANDLE, Float64, Float64, Ptr{Cvoid}), 
                        C_NULL, req, f.handle, atime, mtime, C_NULL) 
                Libc.free(req) 
            uv_error("futime", err) 
            return f 
         end 
        
function Filesystem.touch(path::AbstractString,newtime::Float64)
        f = Filesystem.open(path, JL_O_WRONLY | JL_O_CREAT, 0o0666)
        # f = open(path, "r")
        try
                if Sys.isunix()
                    tv_sec =trunc(Int,newtime)
                    tv_usec=trunc(  Int ,(newtime- tv_sec )*1000000 )
                    tv=[tv_sec,tv_usec,tv_sec,tv_usec]
                    # println(  timevals[0], timevals[1])
                    ret = ccall(:futimes, Cint, (Cint, Ptr{Cvoid}), fd(f), tv)
                    systemerror(:futimes, ret != 0, extrainfo=path)
                else
                        t = newtime #time() 
                        # println( typeof( t ))
                        Filesystem.futime(f,t,t) 
                end
        finally
           close(f)
        end
end

function touchfile( srcfile::String,tgrfile::String)
        newtime = mtime(srcfile)
        # println("$s1,$s2,$(s2-s1)")

        # newtime =s1
        touch(tgrfile,newtime)
        # s2=mtime(tgrfile)
end
function TestMain()
            srcfile ="LICENSE.md"
            tgrfile="test.tgr"


            cp(srcfile,tgrfile,force=true)
            s1=mtime( srcfile)
            s2=mtime(tgrfile)
            println("$s1,$s2,$(s2-s1)")

            newtime =s1
            touch(tgrfile,newtime::Float64)
            s2=mtime(tgrfile)
            println(":::: $s1,$s2,$(s2-s1)")
end


# TestMain()


# #include <sys/time.h>
# #include <stdio.h>

# int
# main(void)
# {
# int i;
# struct timeval tv;

# for(i = 0; i < 4; i++){
#      gettimeofday(&tv, NULL);
#      printf("%d\t%d\n", tv.tv_usec, tv.tv_sec);
#      sleep(1);
# }

# return 0;
# }