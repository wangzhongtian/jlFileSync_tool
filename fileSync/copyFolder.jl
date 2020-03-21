using Base.Filesystem
include( "touch.jl")

mutable struct folder
	baseSrcroot::String
	baseTgrroot::String

	cursrcroot::String
	curtgrroot::String

	curSUBname::String #,maybe folder or file or link
	nextFullSrcName::String
	nextFullTgrName::String
	folder() =new() #new(baseSrcroot, baseTgrRoot,cursrcroot,curtgrroot,curSUBname,curfullsrc, curfulltgr)
	
end
const channelOut=Channel( 10 )
function getProgress( )
	global channelOut
	isready(channelOut )
	a = take!(channelOut)
	return a
end	
function showProgress(args...)
	global channelOut
	s1 =""
	for a in args
		s1 =string(s1, a,"\n" )
	end
	put!(channelOut,s1)
end

function procdir(folderobj::folder)
	if ispath( folderobj.nextFullTgrName ) 
			;
	else
		mkdir(folderobj.nextFullTgrName) 
	end 
end
function procfile(folderobj::folder)
	# return
		if Filesystem.ispath(folderobj.nextFullTgrName )
			srcfileDT = Filesystem.mtime(folderobj.nextFullSrcName )
			tgrfileDT=  Filesystem.mtime(folderobj.nextFullTgrName )
			delta = abs(srcfileDT - tgrfileDT)*1000
			if  delta > 1.0
						if srcfileDT  >  tgrfileDT
							showProgress("Newer file found: ,copying....:",folderobj.nextFullTgrName )
								Filesystem.cp( folderobj.nextFullSrcName,folderobj.nextFullTgrName,force=true )
								touchfile( folderobj.nextFullSrcName,folderobj.nextFullTgrName )
					    else
								#println("Older  file found: ",folderobj.nextFullTgrName )
								#### Filesystem.cp( folderobj.nextFullSrcName,folderobj.nextFullTgrName,force=true )
								#touchfile( folderobj.nextFullSrcName,folderobj.nextFullTgrName )
						end
			else
				 #println("Same File ....")
			end

		else
			showProgress("LOST  file found,copying:",folderobj.nextFullSrcName , " \nCopying ...:" , folderobj.nextFullTgrName )
			try
				Filesystem.cp( folderobj.nextFullSrcName,folderobj.nextFullTgrName )
				touchfile( folderobj.nextFullSrcName,folderobj.nextFullTgrName )
			catch ex1 
				showProgress( ex1)
			end
		end
end

function procLink(folderobj::folder)
	#println("linkname:$(folderobj.nextFullTgrName)\r\n" )
	#if   true #ispath(folderobj.nextFullTgrName)
		rm(folderobj.nextFullTgrName, force=true, recursive=true)
	#end
		#Filesystem.cp( folderobj.nextFullSrcName,folderobj.nextFullTgrName,follow_symlinks=false,force=true )

		src_LinkTgr =readlink(  folderobj.nextFullSrcName )
		tgr_LinkTgr = replace( src_LinkTgr ,folderobj.baseSrcroot =>folderobj.baseTgrroot )
		symlink( tgr_LinkTgr , folderobj.nextFullTgrName );
		#println("    Link created! Link Tgr name : $tgr_LinkTgr"   )
		#touchfile( folderobj.nextFullSrcName,folderobj.nextFullTgrName )	

end

function doprocFolder( folderobj::folder )
	subfolderObj =folder()
	subfolderObj.baseSrcroot=folderobj.baseSrcroot
	subfolderObj.baseTgrroot=folderobj.baseTgrroot
	subfolderObj.cursrcroot=folderobj.nextFullSrcName
	subfolderObj.curtgrroot= folderobj.nextFullTgrName 

	if ispath( subfolderObj.baseTgrroot) 
					;
					#return ;
	else
		mkdir(subfolderObj.baseTgrroot) 
	end


	for file in  readdir( subfolderObj.cursrcroot )#,topdown=true,follow_symlinks=false )
		#for file in files
			subfolderObj.curSUBname= file
			# println("---",file ,"  ")
			subfolderObj.nextFullSrcName = Filesystem.joinpath(  subfolderObj.cursrcroot ,file)
			subfolderObj.nextFullTgrName = Filesystem.joinpath(  subfolderObj.curtgrroot ,file)
					
			if islink( subfolderObj.nextFullSrcName)
				procLink(subfolderObj)
			elseif isfile(subfolderObj.nextFullSrcName)
				procfile(subfolderObj)
			elseif isdir(subfolderObj.nextFullSrcName) 
				procdir(subfolderObj)
				doprocFolder(subfolderObj)				
			end
		#end
	end


end
function proCopyFolder( srcfolder,tgrfolder)
	folderobj=folder()
	folderobj.baseSrcroot =abspath( srcfolder)
	folderobj.baseTgrroot =abspath(tgrfolder)
	folderobj.cursrcroot=  folderobj.baseSrcroot 
	folderobj.curtgrroot=  folderobj.baseTgrroot 
	folderobj.nextFullSrcName =    folderobj.cursrcroot  
	folderobj.nextFullTgrName =    folderobj.curtgrroot 
	doprocFolder(folderobj)
end	
