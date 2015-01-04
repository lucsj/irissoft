#NoEnv

AddToTemplateFromFile("test.csv", "output.html")

Return

AddToTemplateFromFile(inputfile, outputfile)
{
    IfNotExist, %inputfile%
        Return 1
    
    topHTML =
    (
    <html><head></head><body><table>
    )
    
    ; Add to template
    FileAppend, %topHTML%, %outputfile%
      
    ; Read the inputfile, line-by-line
    Loop, Read, %inputfile%
    {
        ; Parse this line
        Loop, Parse, A_LoopReadLine, CSV
        {
            i := A_Index

            ; Set the variables for this line
            IfEqual, i, 1, SetEnv, _itemid, %A_LoopField%
            IfEqual, i, 2, SetEnv, _itemname, %A_LoopField%
            IfEqual, i, 3, SetEnv, _amount, %A_LoopField%
            IfEqual, i, 4, SetEnv, _shipping, %A_LoopField%
            IfEqual, i, 5, SetEnv, _option1, %A_LoopField%
            IfEqual, i, 6, SetEnv, _itemimg, %A_LoopField%
            IfEqual, i, 7, SetEnv, _description, %A_LoopField%

        }   

        ; Add this item to the template
        AddItemToTemplate(outputfile, _itemid, _itemname, _amount, _shipping, _option1, _itemimg, _description)

        ; next line
    }


    bottomHTML =
    (
    </table></body></html>
    )

    ; Add to template
    FileAppend, %bottomHTML%, %outputfile%
    
    Return 0
}


AddItemToTemplate(outputfile, _itemid, _itemname, _amount, _shipping, _option1, _itemimg, _description)
{
    
    ; some fixed variables
    _email := "test@test.com"
    _taxrate = 10
    

    newHTML =
    (LTrim Join`n
    <tr><td> 
    Item ID: %_itemid%<br> 
    Item Name: %_itemname%<br> 
    Amount: %_amount%<br> 
    Shipping : %_shipping%<br> 
    Option 1 %_option1%<br> 
    Description: %_description%<br> 
    <br> 
    <img src="%_itemimg%"> 
    </td><td> 
    <form target="paypal" action="https://www.paypal.com/cgi-bin/webscr" method="post"> 
    <input type="hidden" name="cmd" value="_cart"> 
    <input type="hidden" name="business" value="%_email%"> 
    <input type="hidden" name="lc" value="US"> 
    <input type="hidden" name="item_name" value="%_itemname%"> 
    <input type="hidden" name="item_number" value="%_itemid%"> 
    <input type="hidden" name="amount" value="%_itemname%"> 
    <input type="hidden" name="currency_code" value="USD"> 
    <input type="hidden" name="button_subtype" value="products"> 
    <input type="hidden" name="tax_rate" value="%_taxrate%"> 
    <input type="hidden" name="shipping" value="%_shipping%"> 
    <input type="hidden" name="add" value="1"> 
    <input type="hidden" name="bn" value="PP-ShopCartBF:btn_cart_LG.gif:NonHostedGuest"> 
    <input type="image" src="https://www.paypal.com/en_US/i/btn/btn_cart_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!"> 
    <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1"> 
    </form> 
    </td></tr>
    )
    
    ; Add this item to the template
    FileAppend, %newHTML%, %outputfile%
    
}