test:={collision_array:{collision:"test",tval:"test"},collision:"test",tval:"test"}
test2:={collision_array:{collision:"test2",t2val:"test2"},collision:"test2",t2val:"test2"}

;Example of toString
msgbox % Lib.obj.Array.toString(test)

;Example of Combine
Lib.tshoot("Overwrite0= " Lib.obj.Array.toString(Lib.obj.Array.combine(test,test2,0)),"Overwrite1= " Lib.obj.Array.toString(Lib.obj.Array.combine(test,test2,1)),"Overwrite2= " Lib.obj.Array.toString(Lib.obj.Array.combine(test,test2,2)))