pyQt = pyimport("PyQt5.QtWidgets")
pyQtCore = pyimport("PyQt5.QtCore")

@pydef  mutable struct sd_QTTable <: pyQt.QTableWidget
    function  __init__(self,i1,i2,parent)
        pyQt.QTableWidget.__init__(self, 10,2 ,parent)
        self.setContextMenuPolicy(pyQtCore.Qt.ContextMenuPolicy.CustomContextMenu) 
        self.customContextMenuRequested.connect(self.contextMenuShow)
        self.setColumnWidth(0,300)
    end
    function contextMenuShow( self,pos)
        self.action1 = pyQt.QAction("新加拷贝的 源 或者 目标 文件夹")
        self.action1.setData(1)
        self.action2 = pyQt.QAction("删除拷贝的 源 或者 目标  文件夹")
        self.action2.setData(2)

        self.Menu1= pyQt.QMenu(self) 
        self.Menu1.addSeparator()
        self.Menu1.addAction(  self.action1 )
        self.Menu1.addAction(  self.action2 )

        self.action1.triggered.connect( self.menuSeleted_add ) 
        self.action2.triggered.connect( self.menuSeleted_Remove ) 

        a= self.Menu1.exec( self.mapToGlobal(pos)  )
    end
    function menuSeleted_add(self,idx)
        println( )
        dir1 = pyQt.QFileDialog.getExistingDirectory(self, "选择 源 文件夹",
                                                "/");
        dir2 = pyQt.QFileDialog.getExistingDirectory(self, "选择 目标 文件夹",
                "/") 
        self.addFIlePair(dir1,dir2)
     
    end
    function menuSeleted_Remove(self,idx)
        row= self.currentRow()
        self.removeRow(row)
    end

    function addFIlePair(self, from,to)
        row= self.currentRow()
        println(row)
        a = pyQt.QTableWidgetItem(""*from)
        self.setItem(row+0,0,a)
        a = pyQt.QTableWidgetItem(""*to)
        self.setItem(row+0,1,a)
    end


    function setFilePairs(self,pairs)
            row =0
            for (a1,a2) in pairs 
                a = pyQt.QTableWidgetItem(a1)
                self.setItem(row,0,a)
                a = pyQt.QTableWidgetItem(a2)
                self.setItem(row,1,a)
                row += 1
            end

    end

    function getFilePairs(self)
        a1=[]
        for row =0:self.rowCount()
            a= self.item( row,0)
            b= self.item( row,1)

            dir1=""
            dir2=""
            if !isnothing(a )
                dir1 =a.text() 
            end
            if !isnothing( b )
                dir2 = b.text() 
            end
          
            if  length(dir1) >0 || length( dir2 ) > 0 
                append!(a1, [dir1=>dir2] )
            end
        end
        return a1

    end


end

