//
//  Functions.swift
//
//  Created by Mikael Löfgren on 2024-12-27
//  Copyright © 2024 Mikael Löfgren. All rights reserved.
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
var insertionPointIndex = Int ()
var recipeRepoDir = ""
var allSearchArray = [String] ()
var externalEditorPath = "/Applications/BBEdit.app"
var searchString = ""
var wholeDocument = ""
var identifierManually = ""
var identifierMismatch = false
var xmlFormatOutput = ""
var yamlModeStatus = false
var processedFilesCount = 0 // Counter for processed files
var loggedMessages = Set<String>() // Global set to track logged messages
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
    guard let defaults = UserDefaults(suiteName: "com.github.autopkg") else { return }
    recipeRepoDir = defaults.string(forKey: "RECIPE_REPO_DIR") ?? ""
    if recipeRepoDir.isEmpty {
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
        return
        
    } else {
        runBackgroundSearch ()
    }
}


func writeOutput () {
    insertionPointIndex = (appDelegate().outputTextField.selectedRanges.first?.rangeValue.location)!
    highlightr!.setTheme(to: "xcode")
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    if yamlModeStatus == true {
        let yamlOutput = xmlDictSnippetToYAMLList(xmlSnippet: output)!
        let highlightedCode = highlightr!.highlight(yamlOutput, as: "yaml")!
        appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
    } else {
        let xmlFormatOutput = prettyFormat(xmlString: output)
        let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
        appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
    }
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
    highlightr!.setTheme(to: "xcode")
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
    if wholeDocument.hasPrefix("<?xml") && yamlModeStatus == false {
        identifierArrayTemp = regexFunc(for: "<key>Identifier<\\/key>(.*?[\r\n]){2}", in: wholeDocument)
    } else {
        identifierArrayTemp = regexFunc(for: "(?<=Identifier:\\s).*", in: wholeDocument)
    }
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
   identifier = identifier.replacingOccurrences(of: "Identifier:", with: "", options: [.regularExpression, .caseInsensitive])
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
        
        // Generate recipeFileName (used in save dialog as prefilled name)
        recipeFileName = "\(name)\(format)"
        
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


func openFileInExternalEditor(fileURL: URL) {
    // Ensure both the editor path and file URL are valid
    guard !appDelegate().selectedExternalEditor.isEmpty,
          !externalEditorPath.isEmpty else {
        print("External editor path or selected editor is empty.")
        return
    }

    // Check if the external editor exists at the specified path
    if !FileManager.default.fileExists(atPath: externalEditorPath) {
        let warning = NSAlert()
        warning.icon = NSImage(named: "Warning")
        warning.addButton(withTitle: "OK")
        warning.messageText = "Missing External Editor"
        warning.alertStyle = NSAlert.Style.warning
        warning.informativeText = """
        Can't find external editor at: \(externalEditorPath)
        Make sure the application exists at the specified path and try again.
        """
        warning.runModal()
        return
    }

    // Create URL for the external editor
    let editorURL = URL(fileURLWithPath: externalEditorPath)

    // Prepare configuration
    let configuration = NSWorkspace.OpenConfiguration()

    // Open the file in the external editor
    NSWorkspace.shared.open([fileURL], withApplicationAt: editorURL, configuration: configuration) { app, error in
        if let error = error {
            let warning = NSAlert()
            warning.icon = NSImage(named: "Warning")
            warning.addButton(withTitle: "OK")
            warning.messageText = "Failed to Open File"
            warning.alertStyle = NSAlert.Style.warning
            warning.informativeText = """
            Failed to open file with external editor at: \(externalEditorPath)
            Error: \(error.localizedDescription)
            """
            warning.runModal()
        }
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
        
    highlightr!.setTheme(to: "xcode")
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
    appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
        if yamlModeStatus == true {
            XMLtoYaml ()
        }
    
    // Clear recipePath
    recipePath = ""
    }
    
    if descriptionFormat == "download" {
        output = downloadOutput
        outputNewDocument()
        if yamlModeStatus == false {
            var range = (xmlFormatOutput as NSString).range(of: "INSERT_YOUR_DOWNLOAD_URL_HERE")
            var attributedReplaceText = NSAttributedString(string: "INSERT_YOUR_DOWNLOAD_URL_HERE", attributes: yellowBackgroundAttributes)
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
            
            range = (xmlFormatOutput as NSString).range(of: "<!--INSERT_YOUR_PROCESSORS_HERE-->")
            attributedReplaceText = NSAttributedString(string: "<!--INSERT_YOUR_PROCESSORS_HERE-->", attributes: yellowBackgroundAttributes)
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        }
    } else if descriptionFormat == "jamf" {
        output = jamfOutput
        outputNewDocument ()
        if yamlModeStatus == false {
            var range = (xmlFormatOutput as NSString).range(of: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE_OR_REMOVE")
            var attributedReplaceText = NSAttributedString(string: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE_OR_REMOVE", attributes: yellowBackgroundAttributes)
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
            
            
            range = (xmlFormatOutput as NSString).range(of: "<!--INSERT_YOUR_PROCESSORS_HERE-->")
            attributedReplaceText = NSAttributedString(string: "<!--INSERT_YOUR_PROCESSORS_HERE-->", attributes: yellowBackgroundAttributes)
            
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        }
    } else if descriptionFormat == "jss" {
            output = jssOutput
            outputNewDocument ()
        if yamlModeStatus == false {
            let range = (xmlFormatOutput as NSString).range(of: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE")
            let attributedReplaceText = NSAttributedString(string: "INSERT_YOUR_PARENT_RECIPE_IDENTIFIER_HERE", attributes: yellowBackgroundAttributes)
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        }
    } else if descriptionFormat == "munki" {
        output = munkiOutput
        outputNewDocument ()
        if yamlModeStatus == false {
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
        }
    } else {
        outputNewDocument ()
        if yamlModeStatus == false {
            let range = (xmlFormatOutput as NSString).range(of: "<!--INSERT_YOUR_PROCESSORS_HERE-->")
            let attributedReplaceText = NSAttributedString(string: "<!--INSERT_YOUR_PROCESSORS_HERE-->", attributes: yellowBackgroundAttributes)
            appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
        }
    }
    }


func finalizeDocument () {
    wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
    if wholeDocument == "" { return }
    if wholeDocument.hasPrefix("<?xml") && yamlModeStatus == false {
    getIdentifier ()
    if identifierMismatch == true {
        appDelegate().fileOptions.selectItem(at: 0)
        return}
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
                    
                        highlightr!.setTheme(to: "xcode")
                        highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                        let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
                        appDelegate().outputTextField.string = ""
                        appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: 0)
                        appDelegate().fileOptions.selectItem(at: 0)
                        deleteTmpFolder ()

                    }
    } else {
        // Not plist/XML - We can't verify
        
        highlightr!.setTheme(to: "xcode")
        highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
        let highlightedCode = highlightr!.highlight(wholeDocument, as: "yaml")!
        appDelegate().outputTextField.string = ""
        appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: 0)
        appDelegate().fileOptions.selectItem(at: 0)
        getIdentifier()
    }
}


func autoPkgRunner () {
    wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
    if wholeDocument == "" { return }
    let randomNumber = Int.random(in: 0 ..< 999)
    // If XML/plist or Yaml
    if wholeDocument.hasPrefix("<?xml") && yamlModeStatus == false {
        getIdentifier ()
        tmpRecipeFile = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeBuilder Output/\(recipeFileName).temp_\(randomNumber)").path
    } else {
        tmpRecipeFile = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/RecipeBuilder Output/\(recipeFileName).temp_\(randomNumber).yaml").path
    }
   
    if recipeFileName == "" { return }
    appDelegate().logWindow.orderFront(Any?.self)
    createRecipeBuilderFolders(createFolder: "")
    
    
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
                    highlightr!.setTheme(to: "xcode")
                    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                    let highlightedCode = highlightr!.highlight(recipeRun, as: "bash")!
                    appDelegate().logTextView.string = ""
                    appDelegate().logTextView.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: 0)
                    appDelegate().fileOptions.selectItem(at: 0)
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


func getTrustInfo() {
    // Function to set the FAIL_RECIPES_WITHOUT_TRUST_INFO value based on the input
    let defaults = UserDefaults(suiteName: "com.github.autopkg")
    if let currentValue = defaults?.object(forKey: "FAIL_RECIPES_WITHOUT_TRUST_INFO") as? Bool {
        // Get the value as String and call function to update the GUI
        appDelegate().trustInfo = String(currentValue)
        toggleTrustInfo ()
        }
}


func setTrustInfo(to value: Bool) {
    // Function to set the FAIL_RECIPES_WITHOUT_TRUST_INFO value based on the input
    let defaults = UserDefaults(suiteName: "com.github.autopkg")
    if let currentValue = defaults?.object(forKey: "FAIL_RECIPES_WITHOUT_TRUST_INFO") as? Bool {
        if currentValue != value {
            defaults?.set(value, forKey: "FAIL_RECIPES_WITHOUT_TRUST_INFO")
        }
    } else {
        defaults?.set(value, forKey: "FAIL_RECIPES_WITHOUT_TRUST_INFO")
    }
}


func toggleTrustInfo () {
    if appDelegate().trustInfo.lowercased() == "true" {
        appDelegate().trustInfoTrue.state = .on
        appDelegate().trustInfoFalse.state = .off
    }
    
    if appDelegate().trustInfo.lowercased() == "false" {
        appDelegate().trustInfoTrue.state = .off
        appDelegate().trustInfoFalse.state = .on
    }
}


func toggleExternalEditor () {   
    if appDelegate().selectedExternalEditor == "BBEdit" {
            externalEditorPath = "/Applications/BBEdit.app"
            appDelegate().bbedit.state = .on
            appDelegate().sublimeText.state = .off
            appDelegate().textMate.state = .off
            appDelegate().visualStudioCode.state = .off
        
    }
    
    if appDelegate().selectedExternalEditor == "Sublime Text" {
            externalEditorPath = "/Applications/Sublime Text.app"
            appDelegate().bbedit.state = .off
            appDelegate().sublimeText.state = .on
            appDelegate().textMate.state = .off
            appDelegate().visualStudioCode.state = .off
      }

    if appDelegate().selectedExternalEditor == "TextMate" {
            externalEditorPath = "/Applications/TextMate.app"
            appDelegate().bbedit.state = .off
            appDelegate().sublimeText.state = .off
            appDelegate().textMate.state = .on
            appDelegate().visualStudioCode.state = .off
         }
    
    if appDelegate().selectedExternalEditor == "Visual Studio Code" {
            externalEditorPath = "/Applications/Visual Studio Code.app"
            appDelegate().bbedit.state = .off
            appDelegate().sublimeText.state = .off
            appDelegate().textMate.state = .off
            appDelegate().visualStudioCode.state = .on
         }
}


// Toogle between the modes XML or Yaml
func yamlModeStatusSwitcher () {
    if yamlModeStatus == false {
        appDelegate().modeSwitch.state = .on
        yamlModeStatus = true
        XMLtoYaml ()
        getIdentifier()
        
        //Check if we still got XML (something went wrong)
        wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
        if wholeDocument.hasPrefix("<?xml") {
            yamlModeStatusSwitcher ()
        }
    } else {
        appDelegate().modeSwitch.state = .off
        yamlModeStatus = false
        YamlToXML()
        getIdentifier()
        
        //Check if we got XML
        wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
        if wholeDocument.hasPrefix("<?xml") {
            finalizeDocument ()
        } else {
            yamlModeStatusSwitcher ()
        }
        
    }
}


func selectFolderAndProcessRecipesToYaml() {
    let openPanel = NSOpenPanel()
    openPanel.canChooseFiles = false
    openPanel.canChooseDirectories = true
    openPanel.allowsMultipleSelection = false
    openPanel.prompt = "Select Folder"
    
    if openPanel.runModal() == .OK, let selectedFolder = openPanel.url {
        // Process the selected folder URL
        print("Selected folder: \(selectedFolder.path)")
 
        DispatchQueue.global(qos: .userInitiated).async {
            let startTime = Date() // Start timer
            processedFilesCount = 0 // Counter for processed files
            let dispatchGroup = DispatchGroup() // Group to track file processing
            
            do {
                let fileManager = FileManager.default
                let filePaths = try fileManager.contentsOfDirectory(at: selectedFolder, includingPropertiesForKeys: nil)
                
                for filePath in filePaths where filePath.pathExtension == "recipe" {
                    dispatchGroup.enter() // Enter the group for each file
                    
                    do {
                        let chosenFileContents = try String(contentsOf: filePath)
                        
                        // Ensure UI updates are performed on the main thread
                        DispatchQueue.main.async {
                            guard let appDelegate = NSApplication.shared.delegate as? AppDelegate,
                                  let textView = appDelegate.outputTextField else {
                                print("Output text field not found.")
                                dispatchGroup.leave() // Leave the group if no UI element is found
                                return
                            }
                            
                            // Ensure the app window is visible
                            appDelegate.window?.makeKeyAndOrderFront(nil)
                            
                            let path = filePath.path
                            outputToLogView(logString: "Validate file (.recipe): \(path)\n")
                            
                            // Append the content of the current file
                            textView.string += chosenFileContents
                            XMLtoYaml()
                            
                            // Get the converted YAML text from the text field
                            let convertedYaml = textView.string
                            
                            if convertedYaml.isEmpty || convertedYaml.hasPrefix("<?xml") {
                                print("❌ Error converting XML file \(path)")
                                outputToLogView(logString: "❌ Error converting XML file \(path)\n")
                                outputToLogView(logString: "-----------------------------------\n")
                                textView.string = "" // Clear previous content
                                dispatchGroup.leave() // Leave the group after processing
                            } else {
                                // Save the YAML file
                                let yamlFileName = "\(path).yaml"
                                do {
                                    try convertedYaml.write(toFile: yamlFileName, atomically: true, encoding: .utf8)
                                    outputToLogView(logString: "Saved YAML file: \(yamlFileName)\n")
                                    outputToLogView(logString: "-----------------------------------\n")
                                    processedFilesCount += 1 // Increment counter
                                } catch {
                                    print("Error saving YAML file \(yamlFileName): \(error.localizedDescription)")
                                    outputToLogView(logString: "Error saving YAML file \(yamlFileName): \(error.localizedDescription)\n")
                                }
                            }
                            
                            // Clear the text field contents if needed
                            textView.string = "" // Clear previous content
                            dispatchGroup.leave() // Leave the group after processing
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Error reading contents of file \(filePath): \(error.localizedDescription)")
                            outputToLogView(logString: "Error reading contents of file: \(error.localizedDescription)\n")
                            dispatchGroup.leave() // Leave the group on error
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error reading contents of folder: \(error.localizedDescription)")
                    outputToLogView(logString: "Error reading contents of folder: \(error.localizedDescription)\n")
                }
            }
            
            // Wait for all tasks to finish
            dispatchGroup.notify(queue: .main) {
                let endTime = Date() // End timer
                let totalTime = endTime.timeIntervalSince(startTime) // Calculate time
                let formattedTime = String(format: "%.2f", totalTime) // Format with two decimal places
                outputToLogView(logString: "Processed \(processedFilesCount) files in \(formattedTime) seconds.\n")
            }
        }
    }  else {
        print("No folder selected.")
    }
}


func selectFolderAndProcessRecipesToXML() {
    let openPanel = NSOpenPanel()
    openPanel.canChooseFiles = false
    openPanel.canChooseDirectories = true
    openPanel.allowsMultipleSelection = false
    openPanel.prompt = "Select Folder"

    if openPanel.runModal() == .OK, let selectedFolder = openPanel.url {
        // Process the selected folder URL
        print("Selected folder: \(selectedFolder.path)")

        DispatchQueue.global(qos: .userInitiated).async {
            let startTime = Date() // Start timer
            processedFilesCount = 0 // Counter for processed files
            let dispatchGroup = DispatchGroup() // Group to track file processing
            
            do {
                let fileManager = FileManager.default
                let filePaths = try fileManager.contentsOfDirectory(at: selectedFolder, includingPropertiesForKeys: nil)

                for filePath in filePaths where filePath.pathExtension == "yaml" {
                    dispatchGroup.enter() // Enter the group for each file
                    
                    do {
                        let chosenFileContents = try String(contentsOf: filePath)

                        // Ensure UI updates are performed on the main thread
                        DispatchQueue.main.async {
                            guard let appDelegate = NSApplication.shared.delegate as? AppDelegate,
                                  let textView = appDelegate.outputTextField else {
                                print("Output text field not found.")
                                dispatchGroup.leave() // Leave the group if no UI element is found
                                return
                            }

                            // Ensure the app window is visible
                            appDelegate.window?.makeKeyAndOrderFront(nil)
                            
                            let path = filePath.path
                            outputToLogView(logString: "Validate file (.yaml): \(path)\n")

                            // Append the content of the current file
                            textView.string += chosenFileContents
                            YamlToXML()
                            
                            // Get the converted XML text from the text field
                            let convertedXML = textView.string
                            
                            if convertedXML == "" || !convertedXML.hasPrefix("<?xml") {
                                print("❌ Error converting Yaml file \(path)")
                                outputToLogView(logString: "❌ Error converting Yaml file \(path)\n")
                                outputToLogView(logString: "-----------------------------------\n")
                                textView.string = "" // Clear previous content
                                dispatchGroup.leave() // Leave the group after processing
                            } else {
                                // Save the XML file
                                let xmlFileName = "\(path).recipe"
                                do {
                                    try convertedXML.write(toFile: xmlFileName, atomically: true, encoding: .utf8)
                                    outputToLogView(logString: "Saved XML file: \(xmlFileName)\n")
                                    outputToLogView(logString: "-----------------------------------\n")
                                    processedFilesCount += 1 // Increment counter
                                } catch {
                                    print("Error saving YXML file \(xmlFileName): \(error.localizedDescription)")
                                    outputToLogView(logString: "Error saving XML file \(xmlFileName): \(error.localizedDescription)\n")
                                }
                                
                                // Clear the text field contents if needed
                                textView.string = "" // Clear previous content
                                dispatchGroup.leave() // Leave the group after processing
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Error reading contents of file \(filePath): \(error.localizedDescription)")
                            outputToLogView(logString: "Error reading contents of file: \(error.localizedDescription)\n")
                            dispatchGroup.leave() // Leave the group on error
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error reading contents of folder: \(error.localizedDescription)")
                    outputToLogView(logString: "Error reading contents of folder: \(error.localizedDescription)\n")
                }
            }
            
            // Wait for all tasks to finish
            dispatchGroup.notify(queue: .main) {
                let endTime = Date() // End timer
                let totalTime = endTime.timeIntervalSince(startTime) // Calculate time
                let formattedTime = String(format: "%.2f", totalTime) // Format with two decimal places
                outputToLogView(logString: "Processed \(processedFilesCount) files in \(formattedTime) seconds.\n")
            }
        }
    }  else {
        print("No folder selected.")
    }
}


func openRecipe () {
    let dialog = NSOpenPanel();
      dialog.allowsMultipleSelection = false;
      dialog.showsHiddenFiles = true;
      dialog.canChooseFiles = true;
      dialog.allowedFileTypes = ["recipe", "yaml"]
    
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
              let fileExtension = result!.pathExtension.lowercased()
              
                
            // Set the recipePath for save dialog
                result = result!.deletingLastPathComponent()
                recipePath = result!.path
              
              if let choosenFileContents = try? String(contentsOfFile: path) {
                  appDelegate().window.makeKeyAndOrderFront(Any?.self)
                  appDelegate().outputTextField.string = ""
                  insertionPointIndex = (appDelegate().outputTextField.selectedRanges.first?.rangeValue.location)!
                  
                  if choosenFileContents.hasPrefix("<?xml") && yamlModeStatus == false && fileExtension == "recipe" {
                      let xmlFormatOutput = prettyFormatDocument(xmlString: choosenFileContents)
                      
                      highlightr!.setTheme(to: "xcode")
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
                  } else if choosenFileContents.hasPrefix("<?xml") && yamlModeStatus == true && fileExtension == "recipe" {
                      let xmlFormatOutput = prettyFormatDocument(xmlString: choosenFileContents)
                      
                      highlightr!.setTheme(to: "xcode")
                      highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                      let highlightedCode = highlightr!.highlight(xmlFormatOutput, as: "xml")!
                      
                      appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
                      
                      XMLtoYaml()
                      
                      // Clear identifier text fields
                      appDelegate().recipeIdentifierTextField.stringValue = ""
                      identififerTextField = ""
                      appDelegate().appPKGTextField.stringValue = ""
                      name = ""
                      appDelegate().recipeFormatPopup.selectItem(withTitle: "Recipe format")
                      getIdentifier ()
                  } else {
                      highlightr!.setTheme(to: "xcode")
                      highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                      let highlightedCode = highlightr!.highlight(choosenFileContents, as: "yaml")!
                      
                      appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
                      
                      // Clear identifier text fields
                      appDelegate().recipeIdentifierTextField.stringValue = ""
                      identififerTextField = ""
                      appDelegate().appPKGTextField.stringValue = ""
                      name = ""
                      appDelegate().recipeFormatPopup.selectItem(withTitle: "Recipe format")
                      getIdentifier ()
                      
                      // Enable Yaml mode
                      if yamlModeStatus == false {
                          appDelegate().modeSwitch.state = .on
                          yamlModeStatus = true
                      }
                  }
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
                      if choosenFileContents.hasPrefix("<?xml") && yamlModeStatus == false  {
                      let xmlFormatOutput = prettyFormatDocument(xmlString: choosenFileContents)
                      
                      highlightr!.setTheme(to: "xcode")
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
                  } else if choosenFileContents.hasPrefix("<?xml") && yamlModeStatus == true  {
                      let xmlFormatOutput = prettyFormatDocument(xmlString: choosenFileContents)
                      
                      highlightr!.setTheme(to: "xcode")
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
                      XMLtoYaml()
                  } else {
                      highlightr!.setTheme(to: "xcode")
                      highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
                      let highlightedCode = highlightr!.highlight(choosenFileContents, as: "yaml")!
                      
                      appDelegate().outputTextField.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: insertionPointIndex)
                      // Enable Yaml mode
                      if yamlModeStatus == false {
                          appDelegate().modeSwitch.state = .on
                          yamlModeStatus = true
                      }
                  }
              }
            
           //  Set the recipePath for save dialog
           recipePath = appDelegate().recipeDirectlyFileName
            
}


func saveRecipe () {
    wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
    if wholeDocument == "" { return }
    if wholeDocument.hasPrefix("<?xml") {
        finalizeDocument ()
    
        if identifierMismatch == true {
            return}
    }
    
                // Save Dialog
               let dialog = NSSavePanel();
                dialog.showsResizeIndicator  = true;
                dialog.showsHiddenFiles      = true;
                dialog.canCreateDirectories  = true;
                dialog.title = "Save as .recipe or .yaml"
    
      if recipePath != "" {
          dialog.directoryURL = NSURL.fileURL(withPath: recipePath, isDirectory: true)
      } else {
             if FileManager.default.fileExists(atPath: recipeBuilderFolder) {
                 dialog.directoryURL = NSURL.fileURL(withPath: recipeBuilderFolder, isDirectory: true)
        }
    }
    
    getIdentifier ()
   
    // Generate recipeFileName (used in save dialog as prefilled name add .recipe or yaml (that seems to be problem)
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
                        // Call function with the URL and open external editor
                        openFileInExternalEditor(fileURL: fileURL)
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


func outputToLogView(logString: String) {
    // Check if the message is already logged otherwise output to Logview
    if loggedMessages.contains(logString) {
        return // Skip logging if the message is already logged
    }
    
    // Log the message and add it to the set
    loggedMessages.insert(logString)
    appDelegate().logWindow.orderFront(Any?.self)
    highlightr!.setTheme(to: "xcode")
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    let highlightedCode = highlightr!.highlight(logString, as: "clean")!  //"basic" "bash" "clean"
    
    // Append the log to the text storage and scroll to the bottom
        if let textView = appDelegate().logTextView {
            if let textStorage = textView.textStorage {
                textStorage.append(NSAttributedString(attributedString: highlightedCode))
            }

            // Scroll to the bottom to show the latest log entry
            textView.scrollToEndOfDocument(nil)
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

