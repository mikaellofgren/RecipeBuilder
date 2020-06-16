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
    
    @IBOutlet var spinner: NSProgressIndicator!
    @IBOutlet var logWindow: NSPanel!
    @IBOutlet var logTextView: NSTextView!
    @IBOutlet var helpPopover: NSPopover!
    @IBOutlet var helpPopoverText: NSTextView!
    @IBOutlet weak var appDMGVersionerButton: NSButton!
    @IBOutlet weak var appPkgCreatorButton: NSButton!
    @IBOutlet weak var codeSignatureVerifierButtonPkg: NSButton!
    @IBOutlet weak var codeSignatureVerifierButtonApp: NSButton!
    @IBOutlet weak var copierButton: NSButton!
    @IBOutlet weak var deprecationWarningButton: NSButton!
    @IBOutlet weak var dmgCreatorButton: NSButton!
    @IBOutlet weak var endOfCheckPhaseButton: NSButton!
    @IBOutlet weak var fileCreatorButton: NSButton!
    @IBOutlet weak var fileFinderButton: NSButton!
    @IBOutlet weak var fileMoverButton: NSButton!
    @IBOutlet weak var flatPkgPackerButton: NSButton!
    @IBOutlet weak var flatPkgUnpackerButton: NSButton!
    @IBOutlet weak var gitHubReleasesInfoProviderButton: NSButton!
    @IBOutlet weak var installerButton: NSButton!
    @IBOutlet weak var installFromDMGButton: NSButton!
    @IBOutlet weak var munkiImporterButton: NSButton!
    @IBOutlet weak var munkiInfoCreatorButton: NSButton!
    @IBOutlet weak var MunkiInstallsItemsCreatorButton: NSButton!
    @IBOutlet weak var munkiPkginfoMergerButton: NSButton!
    @IBOutlet weak var packageRequiredButton: NSButton!
    @IBOutlet weak var pathDeleterButton: NSButton!
    @IBOutlet weak var pkgCopierButton: NSButton!
    @IBOutlet weak var pkgExtractorButton: NSButton!
    @IBOutlet weak var pkgInfoCreatorButton: NSButton!
    @IBOutlet weak var pkgPayloadUnpackerButton: NSButton!
    @IBOutlet weak var pkgRootCreatorButton: NSButton!
    @IBOutlet weak var plistEditorButton: NSButton!
    @IBOutlet weak var plistReaderButton: NSButton!
    @IBOutlet weak var sparkleUpdateInfoProviderButton: NSButton!
    @IBOutlet weak var stopProcessingIfButton: NSButton!
    @IBOutlet weak var symlinkerButton: NSButton!
    @IBOutlet weak var unarchiverButton: NSButton!
    @IBOutlet weak var urlDownloaderButton: NSButton!
    @IBOutlet weak var urlTextSearcherButton: NSButton!
    @IBOutlet weak var versionerButton: NSButton!

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
    
    @IBAction func autopkgRun(_ sender: NSMenuItem) {
        appDelegate().spinner.isHidden=false
        self.spinner.startAnimation(self)
        autoPkgRunner ()
        }
    
    @IBAction func openAutoPkgCacheFolder(_ sender: NSMenuItem) {
        openAutoPkgCache ()
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
    
@IBAction func appDMGVersionerAction(_ sender: NSButton) {
        appDMGVersioner ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "AppDmgVersioner", extraHelpText: "Name of app found at the root of the disk image. This does not search recursively for a matching app. If you need to specify a path, use Versioner instead.")
      }
    
    @IBAction func appPkgCreatorAction(_ sender: NSButton) {
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
    
    @IBAction func codeSignatureVerifierActionPkg(_ sender: NSButton) {
        codeSignatureVerifierPKG ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "CodeSignatureVerifier", extraHelpText: "Used with download.recipes")
    }
    
    @IBAction func codeSignatureVerifierActionApp(_ sender: NSButton) {
        codeSignatureVerifierApp ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "CodeSignatureVerifier", extraHelpText: "Used with download.recipes")
    }
    
    
    @IBAction func copierAction(_ sender: NSButton) {
        copier ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Copier", extraHelpText: "")
    }
    
    @IBAction func deprecationWarningAction(_ sender: NSButton) {
        deprecationWarning ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "DeprecationWarning", extraHelpText: "This processor outputs a warning that the recipe has been deprecated.")
    }
    
    @IBAction func dmgCreatorAction(_ sender: NSButton) {
        dmgCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "DmgCreator", extraHelpText: "")
    }
    
    @IBAction func endOfCheckPhaseAction(_ sender: NSButton) {
        endOfCheckPhase ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "EndOfCheckPhase", extraHelpText: "")
    }
    
    @IBAction func fileCreatorAction(_ sender: NSButton) {
        fileCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FileCreator", extraHelpText: "")
    }
    
    @IBAction func fileFinderAction(_ sender: NSButton) {
        fileFinder ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FileFinder", extraHelpText: "")
    }
    
    @IBAction func fileMoverAction(_ sender: NSButton) {
        fileMover ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FileMover", extraHelpText: "")
    }
    
    @IBAction func flatPkgPackerAction(_ sender: NSButton) {
        flatPkgPacker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FlatPkgPacker", extraHelpText: "")
    }
    
    @IBAction func flatPkgUnpackerAction(_ sender: NSButton) {
        flatPkgUnpacker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "FlatPkgUnpacker", extraHelpText: "")
    }
    
    @IBAction func gitHubReleasesInfoProviderAction(_ sender: NSButton) {
        gitHubReleasesInfoProvider ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "GitHubReleasesInfoProvider", extraHelpText: """
Add as Input key to use the %GITHUB_REPO% variable
<key>GITHUB_REPO</key>
<string>MagerValp/AutoDMG</string>
""")
    }
    
    @IBAction func installerAction(_ sender: NSButton) {
        installer ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Installer", extraHelpText: "Used with install.recipes")
    }
    
    @IBAction func installFromDMGAction(_ sender: NSButton) {
        installFromDMG ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "InstallFromDMG", extraHelpText: "Used with install.recipes")
    }
    
    @IBAction func munkiImporterAction(_ sender: NSButton) {
        munkiImporter ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiImporter", extraHelpText: "")
    }
    
    @IBAction func munkiInfoCreatorAction(_ sender: NSButton) {
        munkiInfoCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiInfoCreator", extraHelpText: "")
    }
    
    @IBAction func MunkiInstallsItemsCreatorAction(_ sender: NSButton) {
        munkiInstallsItemsCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiInstallsItemsCreator", extraHelpText: "The faux_root path must include the installs_items_path %RECIPE_CACHE_DIR%/Applications/%NAME%.app. MunkiPkginfoMerger needed afterwards")
    }
    
    @IBAction func munkiPkginfoMergerAction(_ sender: NSButton) {
        munkiPkginfoMerger ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "MunkiPkginfoMerger", extraHelpText: "")
    }
    
    @IBAction func packageRequiredAction(_ sender: NSButton) {
        packageRequired ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PackageRequired", extraHelpText: "")
    }
    
    @IBAction func pathDeleterAction(_ sender: NSButton) {
        pathDeleter ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PathDeleter", extraHelpText: "")
    }
    
    @IBAction func pkgCopierAction(_ sender: NSButton) {
        pkgCopier ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgCopier", extraHelpText: "")
    }
    
    @IBAction func pkgExtractorAction(_ sender: NSButton) {
        pkgExtractor ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgExtractor", extraHelpText: """
You probably should use FlatPkgUnpacker instead.
Bundle-style pkg is the old pkg format and rare.
""")
    }
    
    @IBAction func pkgInfoCreatorAction(_ sender: NSButton) {
        pkgInfoCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgInfoCreator", extraHelpText: """
pkgroot and version are required, but likely they are set earlier from another processor like PkgRootCreator
""")
    }
    
    @IBAction func pkgPayloadUnpackerAction(_ sender: NSButton) {
        pkgPayloadUnpacker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgPayloadUnpacker", extraHelpText: "")
    }
    
    @IBAction func pkgRootCreatorAction(_ sender: NSButton) {
        pkgRootCreator ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PkgRootCreator", extraHelpText: "")
    }
    
    @IBAction func plistEditorAction(_ sender: NSButton) {
        plistEditor ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PlistEditor", extraHelpText: "")
    }
    
    @IBAction func plistReaderAction(_ sender: NSButton) {
        plistReader ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "PlistReader", extraHelpText: "")
    }
    
    @IBAction func sparkleUpdateInfoProviderAction(_ sender: NSButton) {
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
    
    @IBAction func stopProcessingIfAction(_ sender: NSButton) {
        stopProcessingIf ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "StopProcessingIf", extraHelpText: "")
    }
    
    @IBAction func symlinkerAction(_ sender: NSButton) {
        symlinker ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Symlinker", extraHelpText: "")
    }
    
    @IBAction func unarchiverAction(_ sender: NSButton) {
        unarchiver ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "Unarchiver", extraHelpText: "")
    }
    
    @IBAction func urlDownloaderAction(_ sender: NSButton) {
        urlDownloader ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "URLDownloader", extraHelpText: "")
    }
    
    @IBAction func urlTextSearcherAction(_ sender: NSButton) {
        urlTextSearcher ()
        helpPopover.close()
        helpPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        writePopOvertext(processor: "URLTextSearcher", extraHelpText: "Often used before URLDownloader get the \"real\" download URL thats passed to URLDownloader")
    }
    
    @IBAction func versionerAction(_ sender: NSButton) {
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
    
   
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        outputTextField.font = NSFont(name: "Menlo", size: 12)
        checkThatAutopkgExist ()
   }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
      
}

}
