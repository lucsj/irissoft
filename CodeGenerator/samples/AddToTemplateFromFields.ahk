#NoEnv

AddToTemplateFromVar("output.html")

Return

AddToTemplateFromVar(outputfile)
{
    
    topHTML =
    (
    <html><head></head><body><table>
    )
    
    ; Ajouter l'en-tête au template
    FileAppend, %topHTML%, %outputfile%
      
	; déclaration et affectation des variables à envoyé en paramètre
	itemid = 1001
	itemname = widgit
	amount = $1.00
	shipping = 1
	option1 = Red
	itemimg = http://www.website.com/widgit1.jpg
	description := "For sale we have widgets, this is widget 1"
	

    ; Add this item to the template
    AddItemToTemplate(outputfile, itemid, itemname, amount, shipping, option1, itemimg, description)


    bottomHTML =
    (
    </table></body></html>
    )

    ; Add to template
    FileAppend, %bottomHTML%, %outputfile%
    
    Return 0
}


AddItemToTemplate(outputfile, itemid, itemname, amount, shipping, option1, itemimg, description)
{
    
    ; some fixed variables
    email := "test@test.com"
    taxrate = 10
    

    newHTML =
    (LTrim Join`n
    <tr><td> 
    Item ID: %itemid%<br> 
    Item Name: %itemname%<br> 
    Amount: %amount%<br> 
    Shipping : %shipping%<br> 
    Option 1 %option1%<br> 
    Description: %description%<br> 
    <br> 
    <img src="%_itemimg%"> 
    </td><td> 
    <form target="paypal" action="https://www.paypal.com/cgi-bin/webscr" method="post"> 
    <input type="hidden" name="cmd" value="_cart"> 
    <input type="hidden" name="business" value="%email%"> 
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


