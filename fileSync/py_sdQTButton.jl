pyQt = pyimport("PyQt5.QtWidgets")
@pydef  mutable struct sd_QTButton <: pyQt.QPushButton
    function  __init__(self,name,parent=nothing)
        name1 = string( name ,"Julia")
        pyQt.QPushButton.__init__(self, name1 ,parent)
    end

end


