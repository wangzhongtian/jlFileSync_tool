using PyCall


pyQt = pyimport("PyQt5.QtWidgets")
pyQtCore = pyimport("PyQt5.QtCore")

# @pydef  mutable struct msgCpResultShowCls <: pyQtCore.QObject
#       function a( self,checked::Bool) 
#             msg = pyQt.QMessageBox(btn)
#             msg.setWindowTitle("提示消息：")
#             msg.setText("Copy Completed")
#             msg.setInformativeText("")
#             msg.setIcon(pyQt.QMessageBox.Information )   
#             a1= msg.exec()       
#             println( "Ok ",a1 ,b.sender().text())
#       end
# end

function showresult()
        msg = pyQt.QMessageBox(nothing)
        msg.setWindowTitle("提示消息：")
        msg.setText("拷贝完毕")
        msg.setInformativeText(" ")
        msg.setIcon(pyQt.QMessageBox.Information )   
        a1= msg.exec()     
end

