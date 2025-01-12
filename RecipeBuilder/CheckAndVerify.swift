//
//  CheckAndVerify.swift
//
//  Created by Mikael Löfgren on 2024-12-27
//  Copyright © 2024 Mikael Löfgren. All rights reserved.
//

import Foundation
import Cocoa

// Inspired by: https://github.com/homebysix/pre-commit-macadmin/blob/main/pre_commit_hooks/check_autopkg_recipes.py

func returnProcessVersion (processName: String) -> String {
    var returnVersion = ""
    
    struct ProcessVersions {
        var name: String
        var version: String
}

var processandversions: [ProcessVersions]
processandversions = [
ProcessVersions(name:"AppDmgVersioner", version:"0"), // no version needed?
ProcessVersions(name:"AppPkgCreator", version:"1.0"),
ProcessVersions(name:"CodeSignatureVerifier", version:"0.3.1"),
ProcessVersions(name:"Copier", version:"0"), // no version needed?
ProcessVersions(name:"CURLTextSearcher", version:"0.5.1"),
ProcessVersions(name:"DeprecationWarning", version:"1.1"),
ProcessVersions(name:"DmgCreator", version:"0"), // no version needed?
ProcessVersions(name:"EndOfCheckPhase", version:"0.1.0"),
ProcessVersions(name:"FileCreator", version:"0"), // no version needed?
ProcessVersions(name:"FileFinder", version:"0.2.3"),
ProcessVersions(name:"FileMover", version:"0.2.9"),
ProcessVersions(name:"FlatPkgPacker", version:"0.2.4"),
ProcessVersions(name:"FlatPkgUnpacker", version:"0.1.0"),
ProcessVersions(name:"GitHubReleasesInfoProvider", version:"0.5.0"),
ProcessVersions(name:"Installer", version:"0.4.0"),
ProcessVersions(name:"InstallFromDMG", version:"0.4.0"),
ProcessVersions(name:"MunkiCatalogBuilder", version:"0.1.0"),
ProcessVersions(name:"MunkiImporter", version:"0.1.0"),
ProcessVersions(name:"MunkiInfoCreator", version:"0"), // no version needed?
ProcessVersions(name:"MunkiInstallsItemsCreator", version:"0.1.0"),
ProcessVersions(name:"MunkiPkginfoMerger", version:"0.1.0"),
ProcessVersions(name:"MunkiSetDefaultCatalog", version:"0.4.2"),
ProcessVersions(name:"PackageRequired", version:"0.5.1"),
ProcessVersions(name:"PathDeleter", version:"0.1.0"),
ProcessVersions(name:"PkgCopier", version:"0.1.0"),
ProcessVersions(name:"PkgCreator", version:"0"),// no version needed?
ProcessVersions(name:"PkgExtractor", version:"0.1.0"),
ProcessVersions(name:"PkgInfoCreator", version:"0"),// no version needed?
ProcessVersions(name:"PkgPayloadUnpacker", version:"0.1.0"),
ProcessVersions(name:"PkgRootCreator", version:"0"),// no version needed?
ProcessVersions(name:"PlistEditor", version:"0.1.0"),
ProcessVersions(name:"PlistReader", version:"0.2.5"),
ProcessVersions(name:"SparkleUpdateInfoProvider", version:"0.1.0"),
ProcessVersions(name:"StopProcessingIf", version:"0.1.0"),
ProcessVersions(name:"Symlinker", version:"0.1.0"),
ProcessVersions(name:"Unarchiver", version:"0.1.0"),
ProcessVersions(name:"URLDownloader", version:"0"), // no version needed?
ProcessVersions(name:"URLTextSearcher", version:"0.2.9"),
ProcessVersions(name:"Versioner", version:"0.1.0")
]

    let nameArray = processandversions.filter{$0.name.hasPrefix("\(processName)")}.map{$0.version}
     
    if !nameArray.isEmpty {
        returnVersion = nameArray[0]
    }
    return returnVersion
}

// Not in use
//struct InputValues:Codable {
//var Name:String
//private enum CodingKeys : String, CodingKey {
//          case Name = "NAME"
//}
//}

struct ProcessValues:Codable {
    var Processor:String
    private enum CodingKeys : String, CodingKey {
              case Processor
    }
}

struct RecipePlistConfig:Codable {
var Description: String?
var Identifier: String
var MinimumVersion: String?
var ParentRecipe: String?
//var Input: InputValues?
var Process: [ProcessValues]?

private enum CodingKeys : String, CodingKey {
       case Description = "Description"
       case Identifier = "Identifier"
       case MinimumVersion = "MinimumVersion"
       case ParentRecipe = "ParentRecipe"
       //case Input = "Input"
       case Process
}
}


struct Recipe {
    let identifier: String
    let path: String
}

var recipesArraySet: [Recipe] = []
var recipesArray: [String] = []
var checkResults = ""

func checkDuplicates(array: [String]) -> String {
    var encountered = Set<String>()
    var duplicate = Set<String>()
    var result = ""
   
    for value in array {
        if encountered.contains(value) {
            // Add duplicate to the set
            duplicate.insert(value)
        }
        else {
            // Add value to the set
            encountered.insert(value)
        }
    }
    
    for all in duplicate {
        result += "\n⚠️ Duplicated identifier\nIdentifier: \(all)\n"
    for recipePath in recipesArraySet {
           if recipePath.identifier == all {
               // Append the filepath to results
                result += "File: \(recipePath.path)\n"
           }
           }
       }
    return result
}



func startCheckAndVerify () {

  var defaultPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/AutoPkg/").path
                    
    if !FileManager.default.fileExists(atPath: defaultPath) { defaultPath = FileManager.default.homeDirectoryForCurrentUser.path }

    let dialog = NSOpenPanel();
    dialog.message = "Choose a folder to verify .recipes files from"
    dialog.directoryURL = NSURL.fileURL(withPath: defaultPath, isDirectory: true)
    dialog.showsResizeIndicator  = true;
    dialog.showsHiddenFiles      = true;
    dialog.canCreateDirectories  = false;
    dialog.canChooseDirectories = true;
    dialog.canChooseFiles       = false;
    dialog.allowsMultipleSelection = false;
    
   
   
    
    if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
        let result = dialog.url

        if (result != nil) {
            defaultPath = result!.path
        }
    } else {
        // User clicked on "Cancel"
        appDelegate().fileOptions.selectItem(at: 0)
        appDelegate().spinner.isHidden=true
        return
    }
    
    let recipeRepoDir = defaultPath
    if !FileManager.default.fileExists(atPath: recipeRepoDir) {
         print("Path doesnt exist at: \(recipeRepoDir)")
         appDelegate().fileOptions.selectItem(at: 0)
         appDelegate().spinner.isHidden=true
         return }
     
     
    let enumerator = FileManager.default.enumerator(atPath: recipeRepoDir)
    let filePaths = enumerator?.allObjects as! [String]
    var recipeFilePaths = filePaths.filter{$0.hasSuffix(".recipe")}
    var recipeYamlFilePaths = filePaths.filter{$0.hasSuffix(".recipe.yaml")}
    let totalRecipes = recipeFilePaths.count + recipeYamlFilePaths.count
    
    if recipeFilePaths.isEmpty {
        appDelegate().fileOptions.selectItem(at: 0)
        appDelegate().spinner.isHidden=true
        return
    }
    
    let startText = "Start checking \(totalRecipes) recipes files..."
    appDelegate().spinner.isHidden=false
    appDelegate().spinner.startAnimation(appDelegate)
    appDelegate().logWindow.orderFront(Any?.self)
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    let highlightedCode = highlightr!.highlight(startText, as: "bash")!
    appDelegate().logTextView.string = ""
    appDelegate().logTextView.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: 0)

    DispatchQueue.global(qos: .userInteractive).async {
       
        
    for recipes in recipeFilePaths {
            let path = "\(recipeRepoDir)/\(recipes)"
            
            func parseRecipe() -> RecipePlistConfig {
                let url = URL(fileURLWithPath: path)
                guard let data = try? Data(contentsOf: url),
                      let preferences = try? PropertyListDecoder().decode(RecipePlistConfig.self, from: data)
                      else {
                          // If problem parsing file set Identifier to Empty
                          return RecipePlistConfig(Identifier: "Empty")
                      }

                    return preferences
                  }
        var minimumVersion = "MISSING"
        if parseRecipe().MinimumVersion != nil {
            // Value from plist
            minimumVersion = parseRecipe().MinimumVersion!
        }
        
        func checkProcessors () {
        var processArray: [String] = []
        if parseRecipe().Process != nil {
            for all in parseRecipe().Process! {
                
                // Value of process minimum (minimum version of autopkg required to run this recipe)
                // and value from plist should be higher or equal
                let processVersion = returnProcessVersion(processName: all.Processor)
                
                // if the vaules are Ascending 1..2..3 or same then ok
                let versionCheck = processVersion.compare(minimumVersion, options: .numeric)
                let ascending = versionCheck  == ComparisonResult.orderedAscending
                let orderedSame = versionCheck == ComparisonResult.orderedSame
                //var descending = versionCheck == ComparisonResult.orderedDescending
               
                if ascending == false && orderedSame == false {
                    checkResults += "\n⚠️ Processor: \(all.Processor) needs MinimumVersion: \(processVersion), now version: \(minimumVersion) is set in:\nFile: \(path)\n"
                    
//                    print(all.Processor)
//                    print("Processor version:\(processVersion)")
//                    print("Plist version:\(minimumVersion)")
                }
                
                // Check deprecated processors
                if all.Processor == "CURLDownloader" {
                checkResults += "\n⚠️ Processor: \(all.Processor) is deprecated\nFile: \(path)\n"
            }
                if all.Processor == "BrewCaskInfoProvider" {
                checkResults += "\n⚠️ Processor: \(all.Processor) is deprecated\nFile: \(path)\n"
            }
                // Warn if any superclass processors
                if all.Processor == "URLGetter" {
                    checkResults += "\n⚠️ Processor: \(all.Processor) is a superclass processor\nFile: \(path)\n"
            }
                processArray.append(all.Processor)
            }
        }
            
        
        // Check EndofCheckPhase is after URLDownloader using Array with Index
        let urlDownloader = processArray.firstIndex(where: {$0 == "URLDownloader"})
        let endOfCheckPhase = processArray.firstIndex(where: {$0 == "EndOfCheckPhase"})
        if urlDownloader != nil && endOfCheckPhase != nil {
            // Convert to Int
            let urlDownloaderInt = Int(urlDownloader!)
            let endOfCheckPhaseInt = Int(endOfCheckPhase!)
            
            if urlDownloaderInt > endOfCheckPhaseInt {
                checkResults += "\n⚠️ Processor: URLDownloader should be used before Processor: EndOfCheckPhase\nFile: \(path)\n"
            }
            
            if urlDownloaderInt + 1 < endOfCheckPhaseInt  {
                checkResults += "\n⚠️ Processor: EndOfCheckPhase is recommended to be directly after Processor: URLDownloader\nFile: \(path)\n"
            }
            
        } else {
            if urlDownloader != nil && endOfCheckPhase == nil {
                checkResults += "\n⚠️ Processor: URLDownloader exist but missing Processor: EndOfCheckPhase\nFile: \(path)\n"
            }
            
        }
        }
        
        checkProcessors ()
        
            if parseRecipe().Identifier != "Empty" {
                // Add Identifier to Array so we can check for duplicates
                recipesArraySet.append(Recipe(identifier: parseRecipe().Identifier, path: path))
                                       
                 if parseRecipe().ParentRecipe != nil {
                     // If ParentRecipe is the same as Identifier then show warning
                     if parseRecipe().ParentRecipe == parseRecipe().Identifier {
                        checkResults += "\n🛑 ParentRecipe is the same as Identifier\nFile: \(path)\n"
                     }
                 }
             } else {
                 // We get this error: Failed to set posix_spawn_file_actions for fd -1 at index 0 with errno 9
                 // if we process to many files like ~3000 with a shell command
                 let plutil = shell("/usr/bin/plutil \"\(path)\"").replacingOccurrences(of: ":", with: "\nError:", options: [.regularExpression, .caseInsensitive])
                  checkResults += "\n🛑 Error reading file\nFile: \(plutil)\n"
             }
        }
        
if !recipeYamlFilePaths.isEmpty {
    for yamlRecipes in recipeYamlFilePaths {
        let path = "\(recipeRepoDir)/\(yamlRecipes)"
        var yamlID = ""
           if freopen(path, "r", stdin) == nil {
                  perror(path)
              }
              while let line = readLine() {
                  if line.contains("Identifier:") {
                      yamlID = line.replacingOccurrences(of: "Identifier: ", with: "", options: [.regularExpression, .caseInsensitive])
                     recipesArraySet.append(Recipe(identifier: yamlID, path: path))
                  }
                  
                      if line.contains("ParentRecipe:") {
                          let yamlParentRecipe = line.replacingOccurrences(of: "ParentRecipe: ", with: "", options: [.regularExpression, .caseInsensitive])
                                
                          if yamlParentRecipe == yamlID {
                              checkResults += "\n🛑 ParentRecipe is the same as Identifier\nFile: \(path)\n"
                          }
                      }
       
                      if line.contains("MinimumVersion:") {
                      var yamlMinimumVersion: String
                          yamlMinimumVersion = line.replacingOccurrences(of: "MinimumVersion: ", with: "", options: [.regularExpression, .caseInsensitive])
                          yamlMinimumVersion = yamlMinimumVersion.replacingOccurrences(of: "\"", with: "", options: [.regularExpression, .caseInsensitive])
                          yamlMinimumVersion = yamlMinimumVersion.replacingOccurrences(of: "'", with: "", options: [.regularExpression, .caseInsensitive])
                          let yamlMinimumVersionDouble = Double(yamlMinimumVersion) ?? 0
                          
                          if yamlMinimumVersionDouble < 2.3 {
                              checkResults += "\n⚠️ MinimumVersion is lower then 2.3\nFile: \(path)\n"
                        }
                  }
                  }
            }
        }
      
        DispatchQueue.main.async {
            // Back on the main thread
    recipesArray = recipesArraySet.map({ $0.identifier })
           
    checkResults += checkDuplicates(array: recipesArray)
    
    if checkResults.isEmpty {
        checkResults += ("✅ No problems found\n")
    }
    
    checkResults += """
--------------------------------------------
Done checking \(totalRecipes) recipes files\n
"""
    appDelegate().logWindow.orderFront(Any?.self)
    highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
    let highlightedCode = highlightr!.highlight(checkResults, as: "bash")!
    appDelegate().logTextView.string = ""
    appDelegate().logTextView.textStorage?.insert(NSAttributedString(attributedString: highlightedCode), at: 0)
    appDelegate().fileOptions.selectItem(at: 0)
    appDelegate().spinner.isHidden=true
    // Reset all values
    recipeFilePaths.removeAll()
    recipeYamlFilePaths.removeAll()
    recipesArray.removeAll()
    recipesArraySet.removeAll()
    checkResults = ""

}
    }
}
