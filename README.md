<img src="https://github.com/mikaellofgren/RecipeBuilder/blob/master/images/recipeBuildericon.png" width="50%"></img><br>
# RecipeBuilder<br>
 - Click and create recipes (Choose File - New to get started)
 - Open recipes for editing (it always open recipes as a copy, so save and replace when done)
 - Shows processor-info as helptext when you click a processor button, sometimes with additional extra note
 - Finalize, lint xml and remove XML comments
 - Save and auto-pkg run from app
 - Save and open in external editor
 - Search recipes content to find processors usage
 - Open autopkg cache folder
 - Create your own buttons
 - Check and verify recipes files
 - Switch mode between XML and YAML
 - Batch convert XML to YAML or YAML to XML
 - Set Autopkg Trustinfo
 

System requirements: macOS 11 or later<br>
Dependencies: Highlightr and Yams<br>
Icon: vecteezy.com<br>

Download: https://github.com/mikaellofgren/RecipeBuilder/releases

<img src="https://github.com/mikaellofgren/RecipeBuilder/blob/master/images/intro.mov" width="50%"></img><br>
[![Click to view intro video](https://github.com/mikaellofgren/RecipeBuilder/blob/master/images/intro.mov)](intro.mov)

# User buttons<br>
In folder "~/Library/Application Support/RecipeBuilder"
you create folders with name 1,2,3..up to 10. You can skip folders, but folder 1 is required if you
want buttons to autostart, otherwise you have to enable them.
In every folder create title.txt and add text to the file for the button name.
Keep it below 26 characters for best result.

Add output.txt for the output text.

And help.txt for the Note text your reading right now (optional).
To easy open "~/Library/Application Support/RecipeBuilder", choose File options - Open user buttons folder
Click the Enable and Reload button to create the first "demo" button.
Use that button to reload if you trying out your new buttons.