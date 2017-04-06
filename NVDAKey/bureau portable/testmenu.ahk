
#Persistent  ; Keep the script running until the user exits it.

Menu, tray, add  ; Creates a separator line.
Menu, tray, add, Item1, MenuHandler  ; Creates a new menu item.
Menu, 1, add, Editpad, MenuHandler
Menu, 1, add, Firefox, MenuHandler
Menu, 1, add, NVDA, MenuHandler
Menu, 2, add, test1, MenuHandler
Menu, 2, add, test2, MenuHandler
Menu, 2, add, test3, MenuHandler
Menu, 1, add, Tests, :2
Menu, tray, add, Programmes, :1
 

return

MenuHandler:
MsgBox You selected %A_ThisMenuItemPos% from menu %A_ThisMenu%.
return

