pyQt = pyimport("PyQt5.QtWidgets")
pyQtCore = pyimport("PyQt5.QtCore")
include("py_sdQTTable.jl") #sd_QTTable
include("py_sdQTButton.jl") #sd_QTButton
include("copyFolder.jl")

include("py_messageBox.jl")
@pydef  mutable struct sd_mainForm <: pyQt.QDialog
    function  __init__(self,parent = nothing )
        # name1 = string( name ,"Julia")
        pyQt.QDialog.__init__(self,parent)
        # self.setContextMenuPolicy(pyQtCore.ContextMenuPolicy.CustomContextMenu) 
        # self.customContextMenuRequested.connect(self.contextMenuShow)
        # super(WidgetGallery, self).__init__(parent)

        self.originalPalette = pyQt.QApplication.palette()
        self.taskcp =nothing

        self.createTopLeftGroupBox()
        self.createBottomLeftTabWidget()
        topLayout = pyQt.QHBoxLayout()

        mainLayout = pyQt.QGridLayout()
        mainLayout.addLayout(topLayout, 2, 1,-1,-1)
        mainLayout.addWidget(self.topLeftGroupBox, 1, 1)
        # mainLayout.addWidget(self.topRightGroupBox, 1, 1)
        mainLayout.addWidget(self.bottomLeftTabWidget, 2, 1,-1,-1)
        mainLayout.setRowStretch(1, 1)
        mainLayout.setRowStretch(2, 10)
        mainLayout.setRowMinimumHeight(2,300)
        mainLayout.setColumnMinimumWidth(1,200)
        # mainLayout.setColumnStretch(2, 1)
        mainLayout.setColumnStretch(1, 1)
        self.setLayout(mainLayout)

        self.changeStyle("Windows")

        self.loadPairs()
    end

    function readinPairs(self)
        pairs=[]
        open("folderpairs.his","r") do file
              while !eof(file)
                 !eof(file) && (a1=readline(file))
               !eof(file) && (a2=readline(file))
            #    println(a1=>a2)
               push!(pairs ,a1 => a2)
              end
        end
        return pairs 
    end
    function loadPairs(self)
        pairs =self.readinPairs()
        # println( pairs)
        self.tableWidget.setFilePairs(pairs)
    end
    function changeStyle(self, styleName)
        print( styleName)
        pyQt.QApplication.setStyle(pyQt.QStyleFactory.create(styleName))
        self.changePalette()
    end

    function changePalette(self)
        pyQt.QApplication.setPalette(pyQt.QApplication.style().standardPalette())
    end

    function showFolderLst(self)
        self.bottomLeftTabWidget.setTabPosition(1)
    end

    function showCpResult(self)
        
        self.bottomLeftTabWidget.setCurrentWidget( self.tab2 )
        self.textEdit.setReadOnly(true )
    end

    function appendText(self,text)
        self.textEdit.insertPlainText( text )
    end
    function clearResultText(self)
        self.textEdit.setText("")
    end
    function createTopLeftGroupBox(self)
        self.bottomLeftTabWidget = pyQt.QTabWidget()
        self.bottomLeftTabWidget.setSizePolicy(pyQt.QSizePolicy.Preferred,
                pyQt.QSizePolicy.Ignored)

        tab1 = pyQt.QWidget()
        self.tableWidget = sd_QTTable(10, 1,self)

        tab1hbox = pyQt.QHBoxLayout()
        tab1hbox.setContentsMargins(5, 5, 5, 5)
        tab1hbox.addWidget(self.tableWidget)
        tab1.setLayout(tab1hbox)

        self.tab2 = pyQt.QWidget()
        self.textEdit = pyQt.QTextEdit()

        self.textEdit.setPlainText("\n\n\n\n")

        tab2hbox = pyQt.QHBoxLayout()
        tab2hbox.setContentsMargins(5, 5, 5, 5)
        tab2hbox.addWidget(self.textEdit)
        self.tab2.setLayout(tab2hbox)

        self.bottomLeftTabWidget.addTab(tab1, "源、目标文件对照表")
        self.bottomLeftTabWidget.addTab(self.tab2, "执行结果：")
    end

    function getfolderPairs(self)
        pairs= self.tableWidget.getFilePairs()
        return pairs
        # pairs= self.getFilePairs()
    end
    function createBottomLeftTabWidget(self)
        self.topLeftGroupBox = pyQt.QGroupBox("")

        button1 = sd_QTButton("开始拷贝")
        button2 = sd_QTButton("保存对照表")
        button3 = sd_QTButton("退出")
        layout = pyQt.QHBoxLayout()
        layout.addWidget(button1)
        layout.addWidget(button2)
        layout.addWidget(button3)
        # layout.addWidget(checkBox)
        layout.addStretch(1)
        self.topLeftGroupBox.setLayout(layout)   
        
        button3.clicked.connect( self.exitOutEventProc )
        button2.clicked.connect( self.save2logEventProc )
        button1.clicked.connect( self.cpFoldersEventProc )
    end

    function exitOutEventProc( self,idx)#退出
        self.save2logEventProc( idx) 
        self.close()
    end

    function save2logEventProc( self,idx) #开始拷贝 
        pairs= self.tableWidget.getFilePairs()
        length(pairs ) < 1 && return 

        open("folderpairs.his","w") do file
            for idx =1:length( pairs )
                write(file,pairs[idx][1] *"\n")
                write(file,pairs[idx][2] *"\n" )
            end
        end
        # close(file)
    end
    function cpFoldersEventProc( self,idx)#保存对照表+
        if !isnothing( self.taskcp )
                println( "have task running")
                return 
        end
        self.showCpResult()
        self.clearResultText()
        pairs= self.tableWidget.getFilePairs()
        # println(pairs )
        for (a1,a2 ) in pairs
          self.taskcp =  @async proCopyFolder( a1,a2)
            while !istaskdone( self.taskcp )
                a= getProgress()
                # println(a )
                self.appendText( a )
                sleep(0.01)
            end 
            self.appendText( "!!!! " )
            # println("Copy Completed!!!! ")
        end
        showresult()
        self.taskcp  = nothing
    end
end