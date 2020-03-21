
$src="/media/wang/41D0E098026AF140/desk/c/"
$tgr="/media/wang/41D0E098026AF140/desk/d/"

$roots="backup/" #b/at/linuxtool/clang-deepin/"
$src="/media/wang/ext4/"+$roots
$tgr="/media/wang/41D0E098026AF140/"+$roots



function proclink( $linkobj){
	$d1= ($linkobj.fullname).replace( $src ,  $tgr)
	$actualFIle = $linkobj.Target
	$g = new-item -path  $d1 -target $actualFIle -ItemType symboliclink
	#$B=$linkobj.copyto(  $d1,$true  )
}
function copyfile($fileObj) {
			$d1= ($fileObj.fullname).replace( $src ,  $tgr)
#			out-host -inputobject $d1
			$ST1=$fileObj.LastWriteTime
			
			if ( test-path -path  $d1 ) {
							$dobj = get-Item -path $d1
							$dt1=$dobj.LastWriteTime
							if( $ST1 -gt $dt1 ){
								out-host -inputobject " newer file found"
								$B=$fileObj.copyto(  $d1,$true  )
							}
							if ( $ST1 -eq $dt1 ){
									#out-host -inputobject "orgfile found"
							}else{
									out-host -inputobject "Older file "
							}	 
			}else  {
				#OUT-HOST -inputobject "not found"
				$B=$fileObj.copyto(  $d1,$true )
			}
}




function walkfolders( $root,$tgrroot){
   $items = Get-childItem -Path $root
   foreach ( $i in $items ) {	
				if ($i.	 linktype -eq "SymbolicLink"	 ){
				proclink  $i	
					continue		
				}		


					if ($i -is [IO.fileinfo]){
							continue
							copyfile  $i  
							continue
					}
					if ($i -is [IO.Directoryinfo]){
									$d= $i.fullname.replace($src ,  $tgr)
									out-host -inputobject $d
									if ( test-path -path  $d ){
												out-host -inputobject "Path exist"
									}else{
											out-host -inputobject "Path will be created"
											 $newi = new-item -path $d  -ItemType  "directory"
									}
								$a= $i.fullname+"/*"  
								$d= $d+"/"
								walkfolders  $a   $d
					}
	}
}

walkfolders $src $tgr
