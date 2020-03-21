#!/usr/bin/env  julia
using PyCall


pyQt = pyimport("PyQt5.QtWidgets")
pyQtCore = pyimport("PyQt5.QtCore")


include("py_sd_MainForm.jl") #sd_mainForm
app = pyQt.QApplication([""])
mainWidgetObj = sd_mainForm()

# w = pyQt.QWidget()		
# w.setWindowTitle("Hello world example" )

# lyt = pyQt.QVBoxLayout(w)
# w.setLayout(lyt)

# btn = sd_QTButton("成功", w)
# lyt.addWidget(btn)
# @pydef  mutable struct msgObj <: pyQtCore.QObject
#       function a( self,checked::Bool) 
#             msg = pyQt.QMessageBox(btn)
#             msg.setWindowTitle("提示消息：")
#             msg.setText("您好，")
#             msg.setInformativeText("感谢使用Julia QT5.")
#             msg.setIcon(pyQt.QMessageBox.Information )   
#             a1= msg.exec()       
#             println( "Ok ",a1 ,b.sender().text())
#       end
# end

# b=msgObj()
# btn.clicked.connect( b.a )
# w.show()	
mainWidgetObj.show()	
app.exec()
pygui_start(:qt)

