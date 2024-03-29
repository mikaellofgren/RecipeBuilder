//
//  Functions.swift
//  RecipeBuilder
//
//  Created by Mikael Löfgren on 2020-05-24.
//  Copyright © 2020 Mikael Löfgren. All rights reserved.
//

import Cocoa
import AppKit
import Foundation
import Highlightr

let highlightr = Highlightr()
var path = ""
var fileName = ""
var output = ""
var recipePath = ""
var name = String ()
var identififerTextField = String ()
var format = ""
var recipeFileName = ""
var tmpRecipeFile = ""
let recipeBuilderFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeBuilder Output/").path
var recipeBuilderOutputFolderCreate = ""
var downloadPath = ""
var insertionPointIndex = Int ()
var recipeRepoDir = ""
var allSearchArray = [String] ()
var searchString = ""
var wholeDocument = ""
var identifierManually = ""
var identifierMismatch = false
var xmlFormatOutput = ""
let font = NSFont(name: "Menlo", size: 12)
let yellowBackgroundAttributes: [NSAttributedString.Key: Any] = [
    .font: font!,
    .backgroundColor: NSColor.yellow
]

func checkThatAutopkgExist () {
if FileManager.default.fileExists(atPath: "/usr/local/bin/autopkg"){
} else {
    let warning = NSAlert()
    warning.icon = NSImage(named: "Warning")
    warning.addButton(withTitle: "OK")
    warning.messageText = "Autopkg not found"
    warning.alertStyle = NSAlert.Style.warning
    warning.informativeText = """
    Autopkg not found at: /usr/local/bin/autopkg
    App will run with limited functionality.\n
    Please install Autopkg by downloading from:
    https://github.com/autopkg/autopkg/releases
    """
    warning.runModal()
    }
}


func getAutopkgPlistValues () {
    let plistFile  = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Preferences/com.github.autopkg.plist").path
       let plistPath = URL(fileURLWithPath: plistFile)
           
           struct PreferencesRead: Decodable {
           private enum CodingKeys: String, CodingKey {
               case RECIPE_REPO_DIR
           }
           var RECIPE_REPO_DIR: String? = nil
            }

       if FileManager.default.fileExists(atPath: plistFile){
           
           func parsePlist() -> PreferencesRead {
               let data = try! Data(contentsOf: plistPath)
               let decoder = PropertyListDecoder()
               return try! decoder.decode(PreferencesRead.self, from: data)
           }

           let readPlistValues = parsePlist()
           
           if readPlistValues.RECIPE_REPO_DIR != nil {
                  recipeRepoDir = readPlistValues.RECIPE_REPO_DIR!
                    // Call the search as background service
                    runBackgroundSearch ()
           } else {
                let warning = NSAlert()
                warning.icon = NSImage(named: "Warning")
                warning.addButton(withTitle: "OK")
                warning.messageText = "Value not found in plist"
                warning.alertStyle = NSAlert.Style.warning
                warning.informativeText = """
                Try this command in Terminal.app:
                defaults read com.github.autopkg RECIPE_REPO_DIR
                And if its missing add it with this command:
                defaults write com.github.autopkg RECIPE_REPO_DIR ~/Library/AutoPkg/RecipeRepos
                """
                warning.runModal()
                print("Value RECIPE_REPO_DIR not found in \(plistFile)")
                // We try to search standard path
                recipeRepoDir = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeRepos").path
                runBackgroundSearch ()
                }
           } else {
                print("\(plistFile) not found.")
           return
       }
    }


func writeOutput () {
    insertionPointIndex = (appDelegate().outputTextField.selectedRanges.first?.rangeValue.location)!
    let xmlFormatOutput = prettyFormat(xmlString: output)
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
    
    appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
}


func writePopOvertext (processor: String, extraHelpText: String) {
    var processorInfo = ""
    if !processor.isEmpty {
        processorInfo = shell("/usr/local/bin/autopkg processor-info \(processor)")
        processorInfo = processorInfo+"\nExtra Note:\n\(extraHelpText)"
    } else {
        processorInfo = extraHelpText
    }
         
         let attributedText = [ NSAttributedString.Key.font: NSFont(name: "Menlo", size: 10.0)! ]
         let processorInfoAttributed = NSAttributedString(string: processorInfo, attributes: attributedText)
         appDelegate().helpPopoverText.string = ""
         appDelegate().helpPopoverText.textStorage?.insert(NSAttributedString(attributedString: processorInfoAttributed), at: 0)
}

func writePopOvertextJamfUploader (processor: String, extraHelpText: String) {
    var processorInfo = ""
    if !processor.isEmpty {
        processorInfo = shell("/usr/local/bin/autopkg processor-info -r com.github.grahampugh.jamf-upload.processors \(processor)")
        processorInfo = processorInfo+"\nExtra Note:\n\(extraHelpText)"
    } else {
        processorInfo = extraHelpText
    }
         
         let attributedText = [ NSAttributedString.Key.font: NSFont(name: "Menlo", size: 10.0)! ]
         let processorInfoAttributed = NSAttributedString(string: processorInfo, attributes: attributedText)
         appDelegate().helpPopoverText.string = ""
         appDelegate().helpPopoverText.textStorage?.insert(NSAttributedString(attributedString: processorInfoAttributed), at: 0)
}



func writeOutputUserButtons () {
    insertionPointIndex = (appDelegate().outputTextField.selectedRanges.first?.rangeValue.location)!
    //let xmlFormatOutput = prettyFormat(xmlString: output)
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    let highlightedCode = highlightr!.highlight(output, as: "xml")!
    
    appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
}

func writePopOvertextUserButtons (helpText: String) {
        let buttonInfo = "\nNote:\n\(helpText)"
        let attributedText = [ NSAttributedString.Key.font: NSFont(name: "Menlo", size: 10.0)! ]
        let buttonInfoAttributed = NSAttributedString(string: buttonInfo, attributes: attributedText)
        appDelegate().helpPopoverText.string = ""
        appDelegate().helpPopoverText.textStorage?.insert(NSAttributedString(attributedString: buttonInfoAttributed), at: 0)
}


func getIdentifierTextFieldsValues () {
if appDelegate().recipeIdentifierTextField.stringValue != "" {
identififerTextField = appDelegate().recipeIdentifierTextField.stringValue
}
}


func getAppPkgTextFieldsValues () {
if appDelegate().appPKGTextField.stringValue != "" {
name = appDelegate().appPKGTextField.stringValue
}
}


func getIdentifier () {
wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
   if wholeDocument == "" { return }
   var identifierArrayTemp = [String] ()
   identifierArrayTemp.removeAll()
   var identifier = ""
   identifierMismatch = false
   identifierArrayTemp = regexFunc(for: "<key>Identifier<\\/key>(.*?[\r\n]){2}", in: wholeDocument)
   if identifierArrayTemp.isEmpty {
       let warning = NSAlert()
       warning.icon = NSImage(named: "Warning")
       warning.addButton(withTitle: "OK")
       warning.messageText = "Identifier is missing in document"
       warning.alertStyle = NSAlert.Style.warning
       warning.informativeText = """
Add Identifier key and string to the document for example:
<key>Identifier</key>
<string>com.github.name.download.app</string>
"""
       warning.runModal()
       return
       
   } else {
   identifier = identifierArrayTemp[0].replacingOccurrences(of: "<key>Identifier</key>", with: "", options: [.regularExpression, .caseInsensitive])
   identifier = identifier.replacingOccurrences(of: "</string>", with: "", options: [.regularExpression, .caseInsensitive])
   identifier = identifier.replacingOccurrences(of: "<string>", with: "", options: [.regularExpression, .caseInsensitive])
   identifier = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
       
    var formatTitle = ""
    let identifierFormat = identifier
    
   
    
          switch identifierFormat {
           case let identifierFormat where identifierFormat.contains(".download."):
               formatTitle = "download"
               format = ".download."
           case let identifierFormat where identifierFormat.contains(".munki."):
               formatTitle = "munki"
               format = ".munki."
           case let identifierFormat where identifierFormat.contains(".pkg."):
               formatTitle = "pkg"
               format = ".pkg."
           case let identifierFormat where identifierFormat.contains(".install."):
               formatTitle = "install"
               format = ".install."
          case let identifierFormat where identifierFormat.contains(".jamf."):
              formatTitle = "jamf"
              format = ".jamf."
           case let identifierFormat where identifierFormat.contains(".jss."):
               formatTitle = "jss"
               format = ".jss."
           case let identifierFormat where identifierFormat.contains(".lanrev."):
               formatTitle = "lanrev"
               format = ".lanrev."
           case let identifierFormat where identifierFormat.contains(".sccm."):
               formatTitle = "sccm"
               format = ".sccm."
           case let identifierFormat where identifierFormat.contains(".ds."):
               formatTitle = "ds"
               format = ".ds."
           case let identifierFormat where identifierFormat.contains(".filewave."):
               formatTitle = "filewave"
               format = ".filewave."
           case let identifierFormat where identifierFormat.contains(".bigfix."):
               formatTitle = "bigfix"
               format = ".bigfix."
           default:
               appDelegate().recipeFormatPopup.selectItem(withTitle: "Recipe format")
               format = ""
               print("no matching recipe format")
       }
    
    
    if format != "" {
    let appPkgClean = identifier.range(of: format)!.upperBound
    let appPkg = String(identifier.suffix(from: appPkgClean))
    let identifierClean = identifier.range(of: format)!.lowerBound
    let identifierName = String(identifier.prefix(upTo: identifierClean))
    
        getIdentifierTextFieldsValues ()
        getAppPkgTextFieldsValues ()
        
        if identififerTextField == "" {
            appDelegate().recipeIdentifierTextField.stringValue = identifierName
            getIdentifierTextFieldsValues ()
        }
        
       
        if name == "" {
            appDelegate().appPKGTextField.stringValue = appPkg
            getAppPkgTextFieldsValues ()
        }
        
            if appDelegate().recipeFormatPopup.titleOfSelectedItem == "Recipe format" {
                appDelegate().recipeFormatPopup.selectItem(withTitle: formatTitle)
            }
        
        if appDelegate().recipeFormatPopup.titleOfSelectedItem != "Recipe format" {
            format = ".\(appDelegate().recipeFormatPopup.titleOfSelectedItem!)."
        }
        
        // Generate recipeFileName needed when saving
        recipeFileName = "\(name)\(format)recipe"
        
        identifierManually = identififerTextField
        identifierManually += "\(format)\(name)"
        
        if identifier != identifierManually {
            let range = (wholeDocument as NSString).range(of: identifier)
            
            let attributedReplaceText = NSAttributedString(string: identifier, attributes: yellowBackgroundAttributes)
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
            
            let warning = NSAlert()
            warning.icon = NSImage(named: "Warning")
            warning.addButton(withTitle: "OK")
            warning.messageText = "Recipe identifier mismatch"
            warning.alertStyle = NSAlert.Style.warning
            warning.informativeText = """
            Update document identifier string
            and Finalize again
            """
            warning.runModal()
            identifierMismatch = true
            return
            }
        
    } else {
        let warning = NSAlert()
        warning.icon = NSImage(named: "Warning")
        warning.addButton(withTitle: "OK")
        warning.messageText = "Recipe format"
        warning.alertStyle = NSAlert.Style.warning
        warning.informativeText = """
        Recipe format is empty or doesnt match default values
        """
        warning.runModal()
        return
    }
   }
   
  if identifier == "" {
      let warning = NSAlert()
       warning.icon = NSImage(named: "Warning")
       warning.addButton(withTitle: "OK")
       warning.messageText = "Identifier is missing"
       warning.alertStyle = NSAlert.Style.warning
       warning.informativeText = """
       Add Identifier string to document
       """
       warning.runModal()
       return
   }
   }


func startSearching () {
    allSearchArray.removeAll()

    if FileManager.default.fileExists(atPath: recipeRepoDir) {
         print("Path exist at: \(recipeRepoDir)")
     } else {
          print("Path doesnt exist at: \(recipeRepoDir)")
         return }
     
     
     let enumerator = FileManager.default.enumerator(atPath: recipeRepoDir)
     let filePaths = enumerator?.allObjects as! [String]
     let recipeFilePaths = filePaths.filter{$0.hasSuffix(".recipe")}
     if recipeFilePaths.isEmpty {
         return
     } else {
     for recipes in recipeFilePaths {
        let path = "\(recipeRepoDir)/\(recipes)"
        if freopen(path, "r", stdin) == nil {
               perror(path)
           }
           while let line = readLine() {
             if line.contains(searchString) {
                  allSearchArray.append(path)
                break
              }
               }
         }
     }
     }


func runBackgroundSearch () {
DispatchQueue.global(qos: .userInteractive).async {
    startSearching ()
   
   DispatchQueue.main.async {
        // Back on the main thread
                   appDelegate().matchingRecipes.removeAllItems()
                   appDelegate().matchingRecipes.addItem(withTitle: "Matching recipes [\(allSearchArray.count)]")
                   appDelegate().matchingRecipes.addItems(withTitles: allSearchArray)
                   appDelegate().matchingRecipes.selectItem(at: 0)
                   appDelegate().spinner.isHidden=true
        
    }
}
}


func openSearchInExternalEditor () {
// Open selected .recipe in preferd app
// Need to use NSURL otherwise files with spaces will fail
    let fileURL = NSURL.fileURL(withPath: appDelegate().searchSelectedRecipe)
    if appDelegate().selectedExternalEditor != "" && appDelegate().searchSelectedRecipe != "" {
        NSWorkspace.shared.openFile(fileURL.path, withApplication: appDelegate().selectedExternalEditor)
         }
}


func createNewDocument () {
    appDelegate().window.makeKeyAndOrderFront(Any?.self)
        getIdentifierTextFieldsValues ()
        getAppPkgTextFieldsValues ()
      
        if identififerTextField == "" {
          let warning = NSAlert()
          warning.icon = NSImage(named: "Warning")
          warning.addButton(withTitle: "OK")
          warning.messageText = "Identifier is empty"
          warning.alertStyle = NSAlert.Style.warning
          warning.informativeText = """
          Fill out identifier textfield and try again
          """
          warning.runModal()
          return
        }
      
        if appDelegate().recipeFormatPopup.titleOfSelectedItem == "Recipe format" {
            let warning = NSAlert()
            warning.icon = NSImage(named: "Warning")
            warning.addButton(withTitle: "OK")
            warning.messageText = "Recipe format is not choosen"
            warning.alertStyle = NSAlert.Style.warning
            warning.informativeText = """
            Choose a recipe format and try again
            """
            warning.runModal()
            return
        } else {
            format = ".\(appDelegate().recipeFormatPopup.titleOfSelectedItem!)."
            }
    
        if name == "" {
            let warning = NSAlert()
            warning.icon = NSImage(named: "Warning")
            warning.addButton(withTitle: "OK")
            warning.messageText = "App/pkg name is empty"
            warning.alertStyle = NSAlert.Style.warning
            warning.informativeText = """
            Fill out App/pkg name textfield and try again
            """
            warning.runModal()
            return
        }
      
      identifierManually = identififerTextField
      identifierManually += "\(format)\(name)"

    let descriptionFormat = appDelegate().recipeFormatPopup.titleOfSelectedItem
       var description = ""
       switch descriptionFormat {
        case "download":
            description = "Downloads the latest version of \(name)"
        case "munki":
            description = "Downloads the latest version of \(name) and imports into Munki"
        case "pkg":
            description = "Downloads the latest version of \(name) and creates a package"
        case "install":
            description = "Installs the latest version of \(name)"
        case "jamf":
           description = "Downloads the latest version of \(name) and then uploads to Jamf"
        case "jss":
            description = "Downloads the latest version of \(name) and then uploads to the JSS"
        case "lanrev":
            description = "Downloads the latest version of \(name) and then uploads to LANrev"
        case "sccm":
            description = "Downloads the latest version of \(name) and then uploads to SCCM"
        case "ds":
            description = "Downloads the latest version of \(name) and then uploads to DeployStudio"
        case "filewave":
            description = "Downloads the latest version of \(name) and then uploads to Filewave"
        case "bigfix":
            description = "Downloads the latest version of \(name) and then uploads to Bigfix"
        default:
            print("no matching recipe format")
            description = "Downloads the latest version of \(name)"
    }
    
        
output = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Description</key>
        <string>\(description)</string>
        <key>Identifier</key>
        <string>\(identifierManually)</string>
        <key>Input</key>
        <dict>
            <key>NAME</key>
            <string>\(name)</string>
        </dict>
        <key>MinimumVersion</key>
        <string>0.5.0</string>
        <key>Process</key>
        <array>
            <!--INSERT_YOUR_PROCESSORS_HERE-->
    </array>
    </dict>
</plist>
"""
    
let munkiOutput = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Description</key>
        <string>\(description)</string>
        <key>Identifier</key>
        <string>\(identifierManually)</string>
        <key>Input</key>
        <dict>
            <key>NAME</key>
            <string>\(name)</string>
            <key>MUNKI_REPO_SUBDIR</key>
            <string>apps/%NAME%</string>
            <key>pkginfo</key>
            <dict>
                <key>catalogs</key>
                <array>
                    <string>testing</string>
                </array>
                <key>description</key>
                <string>INSERT_DESCRIPTION_HERE</string>
                <key>category</key>
                <string>INSERT_CATEGORY_HERE</string>
                <key>developer</key>
                <string>INSERT_DEVELOPER_HERE</string>
                <key>display_name</key>
                <string>INSERT_DISPLAY_NAME_HERE</string>
                <key>name</key>
                <string>%NAME%</string>
                <key>unattended_install</key>
                <true></true>
            </dict>
        </dict>
        <key>MinimumVersion</key>
        <string>0.5.0</string>
        <key>ParentRecipe</key>
        <string>INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE</string>
        <key>Process</key>
        <array>
            <!--INSERT_YOUR_PROCESSORS_HERE-->
        </array>
    </dict>
</plist>
"""

let downloadOutput = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Description</key>
        <string>\(description)</string>
        <key>Identifier</key>
        <string>\(identifierManually)</string>
        <key>Input</key>
        <dict>
            <key>NAME</key>
            <string>\(name)</string>
            <key>DOWNLOAD_URL</key>
            <string>INSERT_YOUR_DOWNLOAD_URL_HERE</string>
        </dict>
        <key>MinimumVersion</key>
        <string>0.5.0</string>
        <key>Process</key>
        <array>
            <!--INSERT_YOUR_PROCESSORS_HERE-->
    </array>
    </dict>
</plist>
"""
    let jamfOutput = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
        <dict>
            <key>Description</key>
            <string>\(description)</string>
            <key>Identifier</key>
            <string>\(identifierManually)</string>
            <key>Input</key>
            <dict>
                <key>CATEGORY</key>
                <string>Applications</string>
                <key>GROUP_NAME</key>
                <string>%NAME%-update-smart</string>
                <key>GROUP_TEMPLATE</key>
                <string>SmartGroupTemplate.xml</string>
                <key>NAME</key>
                <string>\(name)</string>
                <key>PATCH_SOFTWARETITLE</key>
                <string>Name of the patch softwaretitle (e.g. 'Mozilla Firefox') used in Jamf</string>
                <key>PATCH_NAME</key>
                <string>Name of the patch policy (e.g. 'Mozilla Firefox - 93.02.10')</string>
                <key>PATCH_TEMPLATE</key>
                <string>PatchTemplate-selfservice.xml</string>
                <key>PATCH_ICON_POLICY_NAME</key>
                <string>Name of an already existing (!) policy (not a patch policy)</string>
                <key>POLICY_CATEGORY</key>
                <string>Testing</string>
                <key>POLICY_NAME</key>
                <string>Install Latest %NAME%</string>
                <key>POLICY_TEMPLATE</key>
                <string>PolicyTemplate.xml</string>
                <key>SELF_SERVICE_DESCRIPTION</key>
                <string>Install Latest %NAME%</string>
                <key>SELF_SERVICE_DISPLAY_NAME</key>
                <string>Install Latest %NAME%</string>
                <key>SELF_SERVICE_ICON</key>
                <string>\(name).png</string>
                <key>TESTING_GROUP_NAME</key>
                <string>Testing</string>
                <key>UPDATE_PREDICATE</key>
                <string>pkg_uploaded == False</string>
                <key>SLACK_WEBHOOK_URL</key>
                <string>https://url.to.slack.com</string>
                <key>TEAMS_WEBHOOK_URL</key>
                <string>https://url.to.teams.com</string>
            </dict>
            <key>MinimumVersion</key>
            <string>2.3</string>
            <key>ParentRecipe</key>
            <string>INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE_OR_REMOVE</string>
            <key>Process</key>
            <array>
                <!--INSERT_YOUR_PROCESSORS_HERE-->
            </array>
        </dict>
    </plist>
    """
    
let jssOutput = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Description</key>
        <string>\(description)</string>
        <key>Identifier</key>
        <string>\(identifierManually)</string>
        <key>Input</key>
        <dict>
            <key>CATEGORY</key>
            <string>Applications</string>
            <key>GROUP_NAME</key>
            <string>%NAME%-update-smart</string>
            <key>GROUP_TEMPLATE</key>
            <string>SmartGroupTemplate.xml</string>
            <key>NAME</key>
            <string>\(name)</string>
            <key>POLICY_CATEGORY</key>
            <string>Testing</string>
            <key>POLICY_TEMPLATE</key>
            <string>PolicyTemplate.xml</string>
            <key>SELF_SERVICE_DESCRIPTION</key>
            <string>\(name)</string>
            <key>SELF_SERVICE_ICON</key>
            <string>\(name).png</string>
        </dict>
        <key>MinimumVersion</key>
        <string>0.6.1</string>
        <key>ParentRecipe</key>
        <string>INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE</string>
        <key>Process</key>
        <array>
            <dict>
                <key>Arguments</key>
                <dict>
                    <key>category</key>
                    <string>%CATEGORY%</string>
                    <key>groups</key>
                    <array>
                        <dict>
                            <key>name</key>
                            <string>%GROUP_NAME%</string>
                            <key>smart</key>
                            <true></true>
                            <key>template_path</key>
                            <string>%GROUP_TEMPLATE%</string>
                        </dict>
                    </array>
                    <key>policy_category</key>
                    <string>%POLICY_CATEGORY%</string>
                    <key>policy_template</key>
                    <string>%POLICY_TEMPLATE%</string>
                    <key>prod_name</key>
                    <string>%NAME%</string>
                    <key>self_service_description</key>
                    <string>%SELF_SERVICE_DESCRIPTION%</string>
                    <key>self_service_icon</key>
                    <string>%SELF_SERVICE_ICON%</string>
                    <key>version</key>
                    <string>%version%</string>
                </dict>
                <key>Processor</key>
                <string>JSSImporter</string>
            </dict>
        </array>
    </dict>
</plist>
"""
    
    func outputNewDocument () {
    appDelegate().outputTextField.string = ""
    insertionPointIndex = (appDelegate().outputTextField.selectedRanges.first?.rangeValue.location)!
    xmlFormatOutput = prettyFormatDocument(xmlString: output)
    
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
    appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
    
    // Clear recipePath
    recipePath = ""
    }
    
    if descriptionFormat == "download" {
        output = downloadOutput
        outputNewDocument()
        var range = (xmlFormatOutput as NSString).range(of: "INSERT_YOUR_DOWNLOAD_URL_HERE")
        var attributedReplaceText = NSAttributedString(string: "INSERT_YOUR_DOWNLOAD_URL_HERE", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
        range = (xmlFormatOutput as NSString).range(of: "<!--INSERT_YOUR_PROCESSORS_HERE-->")
        attributedReplaceText = NSAttributedString(string: "<!--INSERT_YOUR_PROCESSORS_HERE-->", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
    } else if descriptionFormat == "jamf" {
        output = jamfOutput
        outputNewDocument ()
        var range = (xmlFormatOutput as NSString).range(of: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE_OR_REMOVE")
        var attributedReplaceText = NSAttributedString(string: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE_OR_REMOVE", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
        
        range = (xmlFormatOutput as NSString).range(of: "<!--INSERT_YOUR_PROCESSORS_HERE-->")
        attributedReplaceText = NSAttributedString(string: "<!--INSERT_YOUR_PROCESSORS_HERE-->", attributes: yellowBackgroundAttributes)
        
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
    } else if descriptionFormat == "jss" {
            output = jssOutput
            outputNewDocument ()
            let range = (xmlFormatOutput as NSString).range(of: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE")
            let attributedReplaceText = NSAttributedString(string: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE", attributes: yellowBackgroundAttributes)
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
    } else if descriptionFormat == "munki" {
        output = munkiOutput
        outputNewDocument ()
        var range = (xmlFormatOutput as NSString).range(of: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE")
        var attributedReplaceText = NSAttributedString(string: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
        range = (xmlFormatOutput as NSString).range(of: "INSERT_DESCRIPTION_HERE")
        attributedReplaceText = NSAttributedString(string: "INSERT_DESCRIPTION_HERE", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
        range = (xmlFormatOutput as NSString).range(of: "INSERT_CATEGORY_HERE")
        attributedReplaceText = NSAttributedString(string: "INSERT_CATEGORY_HERE", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
        range = (xmlFormatOutput as NSString).range(of: "INSERT_DEVELOPER_HERE")
        attributedReplaceText = NSAttributedString(string: "INSERT_DEVELOPER_HERE", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
        range = (xmlFormatOutput as NSString).range(of: "INSERT_DISPLAY_NAME_HERE")
        attributedReplaceText = NSAttributedString(string: "INSERT_DISPLAY_NAME_HERE", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
        range = (xmlFormatOutput as NSString).range(of: "<!--INSERT_YOUR_PROCESSORS_HERE-->")
        attributedReplaceText = NSAttributedString(string: "<!--INSERT_YOUR_PROCESSORS_HERE-->", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        
    } else {
        outputNewDocument ()
        let range = (xmlFormatOutput as NSString).range(of: "<!--INSERT_YOUR_PROCESSORS_HERE-->")
        let attributedReplaceText = NSAttributedString(string: "<!--INSERT_YOUR_PROCESSORS_HERE-->", attributes: yellowBackgroundAttributes)
        appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
       
    }
}





func finaliseDocument () {
    wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
    if wholeDocument == "" { return }
    getIdentifier ()
    if identifierMismatch == true {return}
    if recipeFileName == "" { return }
    createRecipeBuilderFolders(createFolder: "tmp")
    tmpRecipeFile = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeBuilder Output/tmp/\(recipeFileName)").path
    let documentDirURL = URL(fileURLWithPath: tmpRecipeFile)
                      // Save data to file
                      let fileURL = documentDirURL
                      let writeString = wholeDocument
                      do {
                          // Write to the file
                          try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                      } catch let error as NSError {
                          print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                        return
                      }
                      
                    // plutil
                   let plutilCheck = shell("/usr/bin/plutil -lint -s '\(fileURL.path)'")
                   if plutilCheck != "" {
                       let warning = NSAlert()
                        warning.icon = NSImage(named: "Warning")
                        warning.addButton(withTitle: "OK")
                        warning.messageText = "Something went wrong"
                        warning.alertStyle = NSAlert.Style.warning
                        warning.informativeText = """
                        \(plutilCheck)
                        Try this command in Terminal.app:
                        /usr/bin/plutil -lint "\(fileURL.path)"
                        """
                        warning.runModal()
                       return
                   } else {
                     
                   // Remove XML comments and print pretty
                    wholeDocument = wholeDocument.replacingOccurrences(of: "\\s*\\<\\!\\-\\-((?!\\-\\-\\>)[\\s\\S])*\\-\\-\\>\\s*", with: "", options: [.regularExpression, .caseInsensitive])
                    
                    var xmlFormatOutput = prettyFormatDocument(xmlString: wholeDocument)
                        
                        if xmlFormatOutput.starts(with: "#error#") {
                            xmlFormatOutput.removeSubrange(xmlFormatOutput.startIndex..<xmlFormatOutput.index(xmlFormatOutput.startIndex, offsetBy: 7))
                         let warning = NSAlert()
                            warning.icon = NSImage(named: "Warning")
                            warning.addButton(withTitle: "OK")
                            warning.messageText = "Something went wrong"
                            warning.alertStyle = NSAlert.Style.warning
                            warning.informativeText = """
                            \(xmlFormatOutput)
                            Check the xml and try again.
                            """
                            warning.runModal()
                            return
                    }
                    
                        highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                        let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
                        appDelegate().outputTextField.string = ""
                        appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: 0)
                        appDelegate().fileOptions.selectItem(at: 0)
                        deleteTmpFolder ()

                    }

}


func autoPkgRunner () {
    wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
    if wholeDocument == "" { return }
    getIdentifier ()
    if recipeFileName == "" { return }
    appDelegate().logWindow.orderFront(Any?.self)
    createRecipeBuilderFolders(createFolder: "")
    let randomNumber = Int.random(in: 0 ..< 999)
    tmpRecipeFile = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeBuilder Output/\(recipeFileName).temp_\(randomNumber)").path
    let documentDirURL = URL(fileURLWithPath: tmpRecipeFile)
                      // Save data to file
                      let fileURL = documentDirURL
                      let writeString = wholeDocument
                      do {
                          // Write to the file
                          try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                      } catch let error as NSError {
                          print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                        return
                      }
    
    DispatchQueue.global(qos: .userInteractive).async {
        let recipeRun = shell("yes n | /usr/local/bin/autopkg run -v '\(tmpRecipeFile)' 2>&1")
      
        DispatchQueue.main.async {
            // Back on the main thread
                    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                    let highlightedCode = highlightr!.highlight(recipeRun, as: "bash")!
                    appDelegate().logTextView.string = ""
                    appDelegate().logTextView.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: 0)
                    appDelegate().fileOptions.selectItem(at: 0)
                    downloadPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/Cache/\(identifierManually)/downloads").path
                    appDelegate().spinner.isHidden=true
                    deleteTmpFolder ()
            
            if recipeRun.contains("Search GitHub AutoPkg") {
                var runErrorArrayTemp = [String] ()
                runErrorArrayTemp.removeAll()
                runErrorArrayTemp = regexFunc(for: "\\:(.*)", in: recipeRun)
                let runError = runErrorArrayTemp[0].replacingOccurrences(of: ": ", with: "", options: [.regularExpression, .caseInsensitive])
                let warning = NSAlert()
                warning.icon = NSImage(named: "Warning")
                warning.addButton(withTitle: "OK")
                warning.messageText = "Something went wrong"
                warning.alertStyle = NSAlert.Style.warning
                warning.informativeText = """
                \(runError)
                """
                warning.runModal()
            }
            
        }
    }
    
}


func openAutoPkgCache () {
    let autopkgCache = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/Cache").path
                
if FileManager.default.fileExists(atPath: autopkgCache) {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: autopkgCache)
     } else {
         return }
        appDelegate().fileOptions.selectItem(at: 0)
}


func toggleExternalEditor () {
    if appDelegate().selectedExternalEditor == "Atom" {
            appDelegate().atom.state = .on
            appDelegate().bbedit.state = .off
            appDelegate().sublimeText.state = .off
            appDelegate().textMate.state = .off
            appDelegate().visualStudioCode.state = .off
    }
    
    if appDelegate().selectedExternalEditor == "BBEdit" {
            appDelegate().atom.state = .off
            appDelegate().bbedit.state = .on
            appDelegate().sublimeText.state = .off
            appDelegate().textMate.state = .off
            appDelegate().visualStudioCode.state = .off
    }
    
    if appDelegate().selectedExternalEditor == "Sublime Text" {
              appDelegate().atom.state = .off
              appDelegate().bbedit.state = .off
              appDelegate().sublimeText.state = .on
              appDelegate().textMate.state = .off
              appDelegate().visualStudioCode.state = .off
      }

    if appDelegate().selectedExternalEditor == "TextMate" {
                 appDelegate().atom.state = .off
                 appDelegate().bbedit.state = .off
                 appDelegate().sublimeText.state = .off
                 appDelegate().textMate.state = .on
                 appDelegate().visualStudioCode.state = .off
         }
    
    if appDelegate().selectedExternalEditor == "Visual Studio Code" {
                 appDelegate().atom.state = .off
                 appDelegate().bbedit.state = .off
                 appDelegate().sublimeText.state = .off
                 appDelegate().textMate.state = .off
                 appDelegate().visualStudioCode.state = .on
         }
}







func openRecipe () {
    let dialog = NSOpenPanel();
      dialog.allowsMultipleSelection = false;
      dialog.showsHiddenFiles = true;
      dialog.canChooseFiles = true;
      dialog.allowedFileTypes = ["recipe"]
    
    if recipePath != "" {
             dialog.directoryURL = NSURL.fileURL(withPath: recipePath, isDirectory: true)
         } else {
           
                if FileManager.default.fileExists(atPath: recipeBuilderFolder) {
                    dialog.directoryURL = NSURL.fileURL(withPath: recipeBuilderFolder, isDirectory: true)
           }
           }
    

    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
     var result = dialog.url // Pathname of the file
          if (result != nil) {
              let path = result!.path
                
            // Set the recipePath for save dialog
                result = result!.deletingLastPathComponent()
                recipePath = result!.path

              
              if let choosenFileContents = try? String(contentsOfFile: path) {
                 appDelegate().window.makeKeyAndOrderFront(Any?.self)
                  appDelegate().outputTextField.string = ""
                  insertionPointIndex = (appDelegate().outputTextField.selectedRanges.first?.rangeValue.location)!
                  let xmlFormatOutput = prettyFormatDocument(xmlString: choosenFileContents)
                  
                  highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                  let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
                  
                  appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
                
                // Clear identifier text fields
                appDelegate().recipeIdentifierTextField.stringValue = ""
                identififerTextField = ""
                appDelegate().appPKGTextField.stringValue = ""
                name = ""
                appDelegate().recipeFormatPopup.selectItem(withTitle: "Recipe format")
                
                getIdentifier ()
              }
             dialog.close()
              
          }
      } else {
          print("Cancel")
          return
      }
    
}


func openRecipeDirectly () {
    if let choosenFileContents = try? String(contentsOfFile: appDelegate().recipeDirectlyFileName) {
            appDelegate().window.makeKeyAndOrderFront(Any?.self)
            appDelegate().outputTextField.string = ""
                      insertionPointIndex = (appDelegate().outputTextField.selectedRanges.first?.rangeValue.location)!
                      let xmlFormatOutput = prettyFormatDocument(xmlString: choosenFileContents)
                      
                      highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                      let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
                      
                      appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
                     
                    // Clear identifier text fields
                    appDelegate().recipeIdentifierTextField.stringValue = ""
                    identififerTextField = ""
                    appDelegate().appPKGTextField.stringValue = ""
                    name = ""
                    appDelegate().recipeFormatPopup.selectItem(withTitle: "Recipe format")
                    
                    getIdentifier ()
            
           //  Set the recipePath for save dialog
           recipePath = appDelegate().recipeDirectlyFileName
            
           
            }
    
      }



func saveRecipe () {
    wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
          if wholeDocument == "" { return }
          if recipeFileName == "" { return }
          finaliseDocument ()
          if identifierMismatch == true {return}
   
// Save Dialog
               let dialog = NSSavePanel();
               dialog.showsResizeIndicator  = true;
               dialog.showsHiddenFiles      = true;
               dialog.canCreateDirectories  = true;
    
      if recipePath != "" {
          dialog.directoryURL = NSURL.fileURL(withPath: recipePath, isDirectory: true)
      } else {
             if FileManager.default.fileExists(atPath: recipeBuilderFolder) {
                 dialog.directoryURL = NSURL.fileURL(withPath: recipeBuilderFolder, isDirectory: true)
        }
        
    }
    
            // Default Save value, add .recipe
             dialog.nameFieldStringValue = "\(recipeFileName)"
              
               
               if (dialog.runModal() == NSApplication.ModalResponse.OK) {
                   let result = dialog.url // Pathname of the file
                   if (result != nil) {
                       let path = result!.path
                       
                        let documentDirURL = URL(fileURLWithPath: path)
                       // Save data to file
                       let fileURL = documentDirURL
                   
                       let writeString = wholeDocument
                       do {
                           // Write to the file
                           try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                        
                       
                        
                       } catch let error as NSError {
                           print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                       }
                       
                    if appDelegate().saveAndOpenExternalEditor == "true" {
                     NSWorkspace.shared.openFile(fileURL.path, withApplication: appDelegate().selectedExternalEditor)
                        appDelegate().saveAndOpenExternalEditor = "false"
                        appDelegate().fileOptions.selectItem(at: 0)
                                                          }
                    
                  
               } else {
                // User clicked on "Cancel"
                   return
               }
               // End Save Dialog
               
        }
}


func shell(_ command: String) -> String {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
  
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

    return output
    }


func regexFunc (for regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}


func prettyFormat(xmlString:String) -> String {
    var noFirstLine = ""
  do {
    let xml = try XMLDocument.init(xmlString: xmlString)
    let data = xml.xmlData(options: [.nodePrettyPrint])
    let str:String? = String(data: data, encoding: .utf8)
    
    noFirstLine = str ?? "?"
    noFirstLine = noFirstLine.replacingOccurrences(of: "<\\?xml.*\\?>\n", with: "", options: [.regularExpression, .caseInsensitive])
  }
  catch {
    print (error.localizedDescription)
  }
  return noFirstLine
}


func prettyFormatDocument(xmlString:String) -> String {
    var formatDocument = ""
  do {
    let xml = try XMLDocument.init(xmlString: xmlString)
    xml.isStandalone = false;
    let data = xml.xmlData(options: [.nodePrettyPrint])
    let str:String? = String(data: data, encoding: .utf8)
    
    formatDocument = str ?? "?"
    formatDocument = formatDocument.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
  }
  catch {
    print (error.localizedDescription)
    formatDocument = "#error#"
    formatDocument += error.localizedDescription
    return formatDocument
    
  }
  return formatDocument
}




func createRecipeBuilderFolders (createFolder: String)  {
// Create Dir
do {
    recipeBuilderOutputFolderCreate = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeBuilder Output/\(createFolder)").path
    if FileManager.default.fileExists(atPath: recipeBuilderOutputFolderCreate) {
        return  } else {
try FileManager.default.createDirectory(atPath: recipeBuilderOutputFolderCreate, withIntermediateDirectories: true, attributes: nil)
 }
    } catch {
    print(error)
}
  return
}

func deleteTmpFolder () {
    let tmpRecipeFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeBuilder Output/tmp/").path
        // If tempfolder exist
        if FileManager.default.fileExists(atPath: tmpRecipeFolder) {
            // Delete tempfolder
            try? FileManager.default.removeItem(atPath: tmpRecipeFolder)
        }
        // If tempfile exist
        if FileManager.default.fileExists(atPath: tmpRecipeFile) {
            // Delete tempfile
            try? FileManager.default.removeItem(atPath: tmpRecipeFile)
        }
}

