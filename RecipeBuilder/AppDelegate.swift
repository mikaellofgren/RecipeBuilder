//
//  AppDelegate.swift
//  autopkgRecipeBuilder
//
//  Created by Mikael Löfgren on 2020-04-24.
//  Copyright © 2020 Mikael Löfgren. All rights reserved.
//

import Cocoa
import AppKit
import Highlightr
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    var searchSelectedRecipe = ""
    var saveAndOpenExternalEditor = "false"
    var selectedExternalEditor = "BBEdit"
    var recipeDirectlyFileName: String = ""
    
    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet var processorsView: NSView!
    @IBOutlet var processorsView3rdParty: NSView!
    @IBOutlet weak var buttonView: NSView!
    @IBOutlet var recipeIdentifierTextField: NSTextField!
    @IBOutlet var appPKGTextField: NSTextField!
    @IBOutlet var outputTextField: NSTextView!
    @IBOutlet var recipeFormatPopup: NSPopUpButton!
    @IBOutlet var openFile: NSMenuItem!
    @IBOutlet var saveDocument: NSMenuItem!
    @IBOutlet var newDocument: NSMenuItem!
    @IBOutlet var matchingRecipes: NSPopUpButton!
    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var fileOptions: NSPopUpButton!
    @IBOutlet var atom: NSMenuItem!
    @IBOutlet var bbedit: NSMenuItem!
    @IBOutlet var sublimeText: NSMenuItem!
    @IBOutlet var textMate: NSMenuItem!
    @IBOutlet var visualStudioCode: NSMenuItem!
    
    @IBOutlet var spinner: NSProgressIndicator!
    @IBOutlet var logWindow: NSPanel!
    @IBOutlet var logTextView: NSTextView!
    @IBOutlet var helpPopover: NSPopover!
    @IBOutlet var helpPopoverText: NSTextView!
    @IBOutlet weak var enableAndReloadButton: NSButton!
    
    @IBAction func getIdentifierTextValue(_ sender: NSTextField) {
             getIdentifierTextFieldsValues ()
         }
    
    @IBAction func setAppPKGvalue(_ sender: NSTextField) {
          getAppPkgTextFieldsValues ()
      }
      
    @IBAction func startSearch(_ sender: NSSearchField) {
         searchString = sender.stringValue
         
         if searchString == "" {
             appDelegate().matchingRecipes.removeAllItems()
             appDelegate().matchingRecipes.addItem(withTitle: "Matching recipes")
             appDelegate().matchingRecipes.selectItem(at: 0)
             return
             } else {
           getAutopkgPlistValues ()
                 appDelegate().matchingRecipes.removeAllItems()
                 appDelegate().matchingRecipes.addItem(withTitle: "Searching...")
                 appDelegate().matchingRecipes.selectItem(at: 0)
                 appDelegate().spinner.isHidden=false
                 self.spinner.startAnimation(self)
         }
         
     }
     
    @IBAction func selectedRecipe(_ sender: NSPopUpButton) {
        searchSelectedRecipe = matchingRecipes.titleOfSelectedItem!
        openSearchInExternalEditor ()
    }
     
    @IBAction func newDocumentAction(_ sender: NSMenuItem) {
        createNewDocument ()
    }
     
    @IBAction func openFileAction(_ sender: NSMenuItem) {
        openRecipe ()
    }
    
    func application(_ sender: NSApplication, openFile recipeDirectlyFileName: String) -> Bool {
        self.recipeDirectlyFileName = recipeDirectlyFileName
        openRecipeDirectly ()
        return true
    }
     
     @IBAction func saveDocumentAction(_ sender: NSMenuItem) {
         saveRecipe ()
     }
    
    @IBAction func finalizeDoc(_ sender: NSMenuItem) {
        finaliseDocument ()
    }
    
    @IBAction func verifyRecipes(_ sender: NSMenuItem) {
        startCheckAndVerify ()
    }
    
    @IBAction func autopkgRun(_ sender: NSMenuItem) {
        appDelegate().spinner.isHidden=false
        self.spinner.startAnimation(self)
        autoPkgRunner ()
        }
    
    @IBAction func openAutoPkgCacheFolder(_ sender: NSMenuItem) {
        openAutoPkgCache ()
    }
    
    
    @IBAction func openUserButtonsFolder(_ sender: NSMenuItem) {
        openUserButtons ()
    }
     
   
    
    
    @IBAction func openExternalAtom(_ sender: NSMenuItem) {
        saveAndOpenExternalEditor = "true"
        selectedExternalEditor = sender.title
        toggleExternalEditor ()
        saveRecipe ()
}
    
    @IBAction func openExternalBBEdit(_ sender: NSMenuItem) {
        saveAndOpenExternalEditor = "true"
        selectedExternalEditor = sender.title
        toggleExternalEditor ()
        saveRecipe ()
    }
    
    @IBAction func openExternalSublime(_ sender: NSMenuItem) {
        saveAndOpenExternalEditor = "true"
        selectedExternalEditor = sender.title
        toggleExternalEditor ()
        saveRecipe ()
    }
    
    @IBAction func openExternalTextMate(_ sender: NSMenuItem) {
        saveAndOpenExternalEditor = "true"
        selectedExternalEditor = sender.title
        toggleExternalEditor ()
        saveRecipe ()
    }
    
    @IBAction func openExternalVisualStudioCode (_ sender: NSMenuItem) {
        saveAndOpenExternalEditor = "true"
        selectedExternalEditor = sender.title
        toggleExternalEditor ()
        saveRecipe ()
    }
    

    @objc func appDMGVersionerAction (sender: NSButton) {
            appDMGVersioner ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertext(processor: "AppDmgVersioner", extraHelpText: "Name of app found at the root of the disk image. This does not search recursively for a matching app. If you need to specify a path, use Versioner instead.")
          }
    
    @objc func appPkgCreatorAction (sender: NSButton) {
        appPkgCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "AppPkgCreator", extraHelpText: """
This is defaults values that can be removed, unless you want another paths
<key>Arguments</key>
<dict>
    <key>pkg_path</key>
    <string>%RECIPE_CACHE_DIR%/%app_name%-%version%.pkg</string>
    <key>app_path</key>
    <string>%RECIPE_CACHE_DIR%/%pathname%/*.app</string>
</dict>

Often used in pkg.recipe
""")
   }
    
    @objc func codeSignatureVerifierAppAction(sender: NSButton) {
        codeSignatureVerifierApp ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "CodeSignatureVerifier", extraHelpText: "Used with download.recipes")
    }

    @objc func codeSignatureVerifierPkgAction(sender: NSButton) {
        codeSignatureVerifierPKG ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "CodeSignatureVerifier", extraHelpText: "Used with download.recipes")
    }
    
    @objc func copierAction(sender: NSButton) {
        copier ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Copier", extraHelpText: "")
    }
    
    @objc func deprecationWarningAction(sender: NSButton) {
        deprecationWarning ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "DeprecationWarning", extraHelpText: "This processor outputs a warning that the recipe has been deprecated.")
    }
    
    @objc func dmgCreatorAction(sender: NSButton) {
        dmgCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "DmgCreator", extraHelpText: "")
    }
    
    @objc func endOfCheckPhaseAction(sender: NSButton) {
        endOfCheckPhase ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "EndOfCheckPhase", extraHelpText: "Recommended to be used directly after processsor URLDownloader")
    }
    
    @objc func fileCreatorAction(sender: NSButton) {
        fileCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FileCreator", extraHelpText: "")
    }
    
    @objc func fileFinderAction(sender: NSButton) {
        fileFinder ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FileFinder", extraHelpText: "")
    }
    
    @objc func fileMoverAction(sender: NSButton) {
        fileMover ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FileMover", extraHelpText: "")
    }
    
    @objc func flatPkgPackerAction(sender: NSButton) {
        flatPkgPacker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FlatPkgPacker", extraHelpText: "")
    }
    
    @objc func flatPkgUnpackerAction(sender: NSButton) {
        flatPkgUnpacker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FlatPkgUnpacker", extraHelpText: "")
    }
    
    @objc func gitHubReleasesInfoProviderAction(sender: NSButton) {
        gitHubReleasesInfoProvider ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "GitHubReleasesInfoProvider", extraHelpText: """
Add as Input key to use the %GITHUB_REPO% variable
<key>GITHUB_REPO</key>
<string>MagerValp/AutoDMG</string>
""")
    }
    
    @objc func installerAction(sender: NSButton) {
        installer ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Installer", extraHelpText: "Used with install.recipes")
    }
    
    @objc func installFromDMGAction(sender: NSButton) {
        installFromDMG ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "InstallFromDMG", extraHelpText: "Used with install.recipes")
    }
    
    @objc func munkiCatalogBuilderAction(sender: NSButton) {
        munkiCatalogBuilder ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiCatalogBuilder", extraHelpText: "")
    }
    
    @objc func munkiImporterAction(sender: NSButton) {
        munkiImporter ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiImporter", extraHelpText: "")
    }
    
    @objc func munkiInfoCreatorAction(sender: NSButton) {
        munkiInfoCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiInfoCreator", extraHelpText: "")
    }
    
    @objc func MunkiInstallsItemsCreatorAction(sender: NSButton) {
        munkiInstallsItemsCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiInstallsItemsCreator", extraHelpText: "The faux_root path must include the installs_items_path %RECIPE_CACHE_DIR%/Applications/%NAME%.app. MunkiPkginfoMerger needed afterwards")
    }
    
    @objc func munkiPkginfoMergerAction(sender: NSButton) {
        munkiPkginfoMerger ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiPkginfoMerger", extraHelpText: "")
    }
    
    @IBAction func packageRequiredAction(sender: NSButton) {
        packageRequired ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PackageRequired", extraHelpText: "")
    }
    
    @objc func pathDeleterAction(sender: NSButton) {
        pathDeleter ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PathDeleter", extraHelpText: "")
    }
    
    @objc func pkgCopierAction(sender: NSButton) {
        pkgCopier ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgCopier", extraHelpText: "")
    }
    
    @objc func pkgCreatorAction(sender: NSButton) {
        pkgCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgCreator", extraHelpText: "Add your reverse domain for the id key")
    }
    
    @objc func pkgExtractorAction(sender: NSButton) {
        pkgExtractor ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgExtractor", extraHelpText: """
You probably should use FlatPkgUnpacker instead.
Bundle-style pkg is the old pkg format and rare.
""")
    }
    
    @objc func pkgInfoCreatorAction(sender: NSButton) {
        pkgInfoCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgInfoCreator", extraHelpText: """
pkgroot and version are required, but likely they are set earlier from another processor like PkgRootCreator
""")
    }
    
    @objc func pkgPayloadUnpackerAction(sender: NSButton) {
        pkgPayloadUnpacker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgPayloadUnpacker", extraHelpText: "")
    }
    
    @objc func pkgRootCreatorAction(sender: NSButton) {
        pkgRootCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgRootCreator", extraHelpText: "Deletes whole directory don't use %RECIPE_CACHE_DIR% instead use %RECIPE_CACHE_DIR%/%NAME%")
    }
    
    @objc func plistEditorAction(sender: NSButton) {
        plistEditor ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PlistEditor", extraHelpText: "")
    }
    
    @objc func plistReaderAction(sender: NSButton) {
        plistReader ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PlistReader", extraHelpText: "")
    }
    
    @objc func sparkleUpdateInfoProviderAction(sender: NSButton) {
        sparkleUpdateInfoProvider ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "SparkleUpdateInfoProvider", extraHelpText: """
Use before URLDownloader to get the %DOWNLOAD_URL% thats passed to URLDownloader
Replace the input key
<key>DOWNLOAD_URL</key>
with
<key>SPARKLE_FEED_URL</key>
and provide the the Sparkle feed URL as the string instead
""")
    }
    
    @objc func stopProcessingIfAction(sender: NSButton) {
        stopProcessingIf ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "StopProcessingIf", extraHelpText: "")
    }
    
    @objc func symlinkerAction(sender: NSButton) {
        symlinker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Symlinker", extraHelpText: "")
    }
    
    @objc func unarchiverAction(sender: NSButton) {
        unarchiver ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Unarchiver", extraHelpText: "")
    }
    
    @objc func urlDownloaderAction(sender: NSButton) {
        urlDownloader ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "URLDownloader", extraHelpText: "")
    }
    
    @objc func urlTextSearcherAction(sender: NSButton) {
        urlTextSearcher ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "URLTextSearcher", extraHelpText: "Often used before URLDownloader get the \"real\" download URL thats passed to URLDownloader")
    }
    
    @objc func versionerAction(sender: NSButton) {
        versioner ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Versioner", extraHelpText: """
Remove
<key>plist_version_key</key>
<string>CFBundleVersion</string>
if you only want CFBundleShortVersionString
""")
    }
    
    // 3rd party buttons
    @objc func JamfCategoryUploaderAction(sender: NSButton) {
        JamfCategoryUploader ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertextJamfUploader(processor: "JamfCategoryUploader", extraHelpText: JamfCategoryUploaderHelp)
        //writePopOvertext(processor: "", extraHelpText: JamfCategoryUploaderHelp)
    }
    
    @objc func JamfComputerGroupUploaderAction(sender: NSButton) {
            JamfComputerGroupUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfComputerGroupUploader", extraHelpText: JamfComputerGroupUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfComputerGroupUploaderHelp)
        }

    @objc func JamfComputerProfileUploaderAction(sender: NSButton) {
            JamfComputerProfileUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfComputerProfileUploader", extraHelpText: JamfComputerProfileUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfComputerProfileUploaderHelp)
        }
        
        @objc func JamfDockItemUploaderAction(sender: NSButton) {
            JamfDockItemUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfDockItemUploader", extraHelpText: JamfDockItemUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfDockItemUploaderHelp)
        }
        
         @objc func JamfExtensionAttributeUploaderAction(sender: NSButton) {
            JamfExtensionAttributeUploader () 
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfExtensionAttributeUploader", extraHelpText: JamfExtensionAttributeUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfExtensionAttributeUploaderHelp)
        }
    
        @objc func JamfMacAppUploaderAction(sender: NSButton) {
            JamfMacAppUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfMacAppUploader", extraHelpText: JamfMacAppUploaderHelp)
        }

        @objc func JamfPackageUploaderAction(sender: NSButton) {
            JamfPackageUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfPackageUploader", extraHelpText: JamfPackageUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfPackageUploaderHelp)
        }
        
         @objc func JamfPatchUploaderAction(sender: NSButton) {
            JamfPatchUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfPatchUploader", extraHelpText: JamfPatchUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfPatchUploaderHelp)
        }
        
        @objc func JamfPolicyDeleterAction(sender: NSButton) {
            JamfPolicyDeleter ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfPolicyDeleter", extraHelpText: JamfPolicyDeleterHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfPolicyDeleterHelp)
        }
        
        @objc func JamfPolicyLogFlusherAction(sender: NSButton) {
            JamfPolicyLogFlusher ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfPolicyLogFlusher", extraHelpText: JamfPolicyLogFlusherHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfPolicyLogFlusherHelp)
        }
        
        @objc func JamfPolicyUploaderAction(sender: NSButton) {
            JamfPolicyUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfPolicyUploader", extraHelpText: JamfPolicyUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfPolicyUploaderHelp)
        }
        
        @objc func JamfScriptUploaderAction(sender: NSButton) {
            JamfScriptUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfScriptUploader", extraHelpText: JamfScriptUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfScriptUploaderHelp)
        }
        
        @objc func JamfSoftwareRestrictionUploaderAction(sender: NSButton) {
            JamfSoftwareRestrictionUploader ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfSoftwareRestrictionUploader", extraHelpText: JamfSoftwareRestrictionUploaderHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfSoftwareRestrictionUploaderHelp)
        }
        
         @objc func JamfUploaderSlackerAction(sender: NSButton) {
            JamfUploaderSlacker ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfUploaderSlacker", extraHelpText: JamfUploaderSlackerHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfUploaderSlackerHelp)
        }
        
         @objc func JamfUploaderTeamsNotifierAction(sender: NSButton) {
            JamfUploaderTeamsNotifier ()
            helpPopover.close()
            helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
            writePopOvertextJamfUploader(processor: "JamfUploaderTeamsNotifier", extraHelpText: JamfUploaderTeamsNotifierHelp)
            //writePopOvertext(processor: "", extraHelpText: JamfUploaderTeamsNotifierHelp)
        }
    
    
    @IBAction func enableAndReloadAction(_ sender: NSButton) {
        getAllUserButtons ()
    }
    
    @objc func buttonAction1(sender: NSButton!) {
        output = output1
        writeOutputUserButtons ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertextUserButtons (helpText: help1)
    }
    
    @objc func buttonAction2(sender: NSButton!) {
       output = output2
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help2)
    }
    
    @objc func buttonAction3(sender: NSButton!) {
       output = output3
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help3)
    }
    
    @objc func buttonAction4(sender: NSButton!) {
       output = output4
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help4)
    }
    
    @objc func buttonAction5(sender: NSButton!) {
       output = output5
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help5)
    }
    
    @objc func buttonAction6(sender: NSButton!) {
       output = output6
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help6)
    }
    
    @objc func buttonAction7(sender: NSButton!) {
       output = output7
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help7)
    }
    
    @objc func buttonAction8(sender: NSButton!) {
       output = output8
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help8)
    }
    
    @objc func buttonAction9(sender: NSButton!) {
       output = output9
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help9)
        
    }
    
    @objc func buttonAction10(sender: NSButton!) {
       output = output10
       writeOutputUserButtons ()
       helpPopover.close()
       helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
       writePopOvertextUserButtons (helpText: help10)
    }
   
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        outputTextField.font = NSFont(name: "Menlo", size: 12)
        createAllDefaultButtons ()
        createAll3rdPartyButtons ()
        checkThatAutopkgExist ()
        checkForUserButtonsAndEnable ()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
      
    }

}
