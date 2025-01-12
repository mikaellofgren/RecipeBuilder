//
//  Buttons.swift
//
//  Created by Mikael Löfgren on 2024-12-27
//  Copyright © 2024 Mikael Löfgren. All rights reserved.
//

import Cocoa
import AppKit
import Foundation
import Highlightr


// Create a subclass of AppDelegate
func appDelegate() -> AppDelegate {
      return NSApplication.shared.delegate as! AppDelegate
      }

// Function calling every button function to create defaults buttons
func createAllDefaultButtons () {
    createButtonAppDMGVersioner ()
    createButtonAppPkgCreator ()
    createButtonCodeSignatureVerifierApp ()
    createButtonCodeSignatureVerifierPKG ()
    createButtonCopier ()
    createButtonDeprecationWarning ()
    createButtonDmgCreator ()
    createButtonEndOfCheckPhase ()
    createButtonFileCreator ()
    createButtonFileFinder ()
    createButtonFileMover ()
    createButtonFlatPkgPacker ()
    createButtonFlatPkgUnpacker ()
    createButtonGitHubReleasesInfoProvider ()
    createButtonInstaller ()
    createButtonInstallFromDMG ()
    createButtonMunkiCatalogBuilder ()
    createButtonMunkiImporter ()
    createButtonMunkiInfoCreator ()
    createButtonMunkiInstallsItemsCreator ()
    createButtonMunkiPkginfoMerger ()
    createButtonPackageRequired ()
    createButtonpathDeleter ()
    createButtonPkgCopier ()
    createButtonPkgCreator ()
    createButtonPkgExtractor ()
    createButtonPkgInfoCreator ()
    createButtonPkgPayloadUnpacker ()
    createButtonPkgRootCreator ()
    createButtonPlistEditor ()
    createButtonPlistReader ()
    createButtonSparkleUpdateInfoProvider ()
    createButtonStopProcessingIf ()
    createButtonSymlinker ()
    createButtonUnarchiver ()
    createButtonUrlDownloader ()
    createButtonUrlTextSearcher ()
    createButtonVersioner ()
}

// Functions to create the buttons
// 21 pixels between every button
func createButtonAppDMGVersioner () {
let appDMGVersioner = NSButton(frame: NSRect(x: 17, y: 855, width: 191, height: 17))
    appDMGVersioner.title = "AppDmgVersioner"
    appDMGVersioner.bezelStyle = NSButton.BezelStyle.inline
    appDMGVersioner.setButtonType(NSButton.ButtonType.momentaryPushIn)
    appDMGVersioner.isBordered = true
    appDMGVersioner.font = .boldSystemFont(ofSize: 11)
    appDMGVersioner.toolTip = "Extracts bundle ID and version of app inside a dmg"
    appDMGVersioner.action = #selector(appDelegate().appDMGVersionerAction)
    appDelegate().processorsView.addSubview(appDMGVersioner)
}


func createButtonAppPkgCreator () {
let appPkgCreator = NSButton(frame: NSRect(x: 17, y: 834, width: 191, height: 17))
    appPkgCreator.title = "AppPkgCreator"
    appPkgCreator.bezelStyle = NSButton.BezelStyle.inline
    appPkgCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    appPkgCreator.isBordered = true
    appPkgCreator.font = .boldSystemFont(ofSize: 11)
    appPkgCreator.toolTip = "Calls autopkgserver to create a package from an application"
    appPkgCreator.action = #selector(appDelegate().appPkgCreatorAction)
    appDelegate().processorsView.addSubview(appPkgCreator)
}


func createButtonCodeSignatureVerifierApp () {
let codeSignatureVerifierApp = NSButton(frame: NSRect(x: 17, y: 813, width: 191, height: 17))
    codeSignatureVerifierApp.title = "CodeSignatureVerifier App "
    codeSignatureVerifierApp.bezelStyle = NSButton.BezelStyle.inline
    codeSignatureVerifierApp.setButtonType(NSButton.ButtonType.momentaryPushIn)
    codeSignatureVerifierApp.isBordered = true
    codeSignatureVerifierApp.font = .boldSystemFont(ofSize: 11)
    codeSignatureVerifierApp.toolTip = "Verifies application bundle signature"
    codeSignatureVerifierApp.action = #selector(appDelegate().codeSignatureVerifierAppAction)
    appDelegate().processorsView.addSubview(codeSignatureVerifierApp)
}


func createButtonCodeSignatureVerifierPKG () {
let codeSignatureVerifierPKG = NSButton(frame: NSRect(x: 17, y: 792, width: 191, height: 17))
    codeSignatureVerifierPKG.title = "CodeSignatureVerifier PKG"
    codeSignatureVerifierPKG.bezelStyle = NSButton.BezelStyle.inline
    codeSignatureVerifierPKG.setButtonType(NSButton.ButtonType.momentaryPushIn)
    codeSignatureVerifierPKG.isBordered = true
    codeSignatureVerifierPKG.font = .boldSystemFont(ofSize: 11)
    codeSignatureVerifierPKG.toolTip = "Verifies installer package signature"
    codeSignatureVerifierPKG.action = #selector(appDelegate().codeSignatureVerifierPkgAction)
    appDelegate().processorsView.addSubview(codeSignatureVerifierPKG)
}


func createButtonCopier () {
let copier = NSButton(frame: NSRect(x: 17, y: 771, width: 191, height: 17))
    copier.title = "Copier"
    copier.bezelStyle = NSButton.BezelStyle.inline
    copier.setButtonType(NSButton.ButtonType.momentaryPushIn)
    copier.isBordered = true
    copier.font = .boldSystemFont(ofSize: 11)
    copier.toolTip = "Copies source_path to destination_path"
    copier.action = #selector(appDelegate().copierAction)
    appDelegate().processorsView.addSubview(copier)
}


func createButtonDeprecationWarning () {
let deprecationWarning = NSButton(frame: NSRect(x: 17, y: 750, width: 191, height: 17))
    deprecationWarning.title = "DeprecationWarning"
    deprecationWarning.bezelStyle = NSButton.BezelStyle.inline
    deprecationWarning.setButtonType(NSButton.ButtonType.momentaryPushIn)
    deprecationWarning.isBordered = true
    deprecationWarning.font = .boldSystemFont(ofSize: 11)
    deprecationWarning.toolTip = "This processor outputs a warning that the recipe has been deprecated"
    deprecationWarning.action = #selector(appDelegate().deprecationWarningAction)
    appDelegate().processorsView.addSubview(deprecationWarning)
}


func createButtonDmgCreator () {
let dmgCreator = NSButton(frame: NSRect(x: 17, y: 729, width: 191, height: 17))
    dmgCreator.title = "DmgCreator"
    dmgCreator.bezelStyle = NSButton.BezelStyle.inline
    dmgCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    dmgCreator.isBordered = true
    dmgCreator.font = .boldSystemFont(ofSize: 11)
    dmgCreator.toolTip = "Creates a disk image from a directory"
    dmgCreator.action = #selector(appDelegate().dmgCreatorAction)
    appDelegate().processorsView.addSubview(dmgCreator)
}


func createButtonEndOfCheckPhase () {
let endOfCheckPhase = NSButton(frame: NSRect(x: 17, y: 708, width: 191, height: 17))
    endOfCheckPhase.title = "EndOfCheckPhase"
    endOfCheckPhase.bezelStyle = NSButton.BezelStyle.inline
    endOfCheckPhase.setButtonType(NSButton.ButtonType.momentaryPushIn)
    endOfCheckPhase.isBordered = true
    endOfCheckPhase.font = .boldSystemFont(ofSize: 11)
    endOfCheckPhase.toolTip = "This processor does nothing at all"
    endOfCheckPhase.action = #selector(appDelegate().endOfCheckPhaseAction)
    appDelegate().processorsView.addSubview(endOfCheckPhase)
}


func createButtonFileCreator () {
let fileCreator = NSButton(frame: NSRect(x: 17, y: 687, width: 191, height: 17))
    fileCreator.title = "FileCreator"
    fileCreator.bezelStyle = NSButton.BezelStyle.inline
    fileCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    fileCreator.isBordered = true
    fileCreator.font = .boldSystemFont(ofSize: 11)
    fileCreator.toolTip = "Create a file"
    fileCreator.action = #selector(appDelegate().fileCreatorAction)
    appDelegate().processorsView.addSubview(fileCreator)
}

func createButtonFileFinder () {
let fileFinder = NSButton(frame: NSRect(x: 17, y: 666, width: 191, height: 17))
    fileFinder.title = "FileFinder"
    fileFinder.bezelStyle = NSButton.BezelStyle.inline
    fileFinder.setButtonType(NSButton.ButtonType.momentaryPushIn)
    fileFinder.isBordered = true
    fileFinder.font = .boldSystemFont(ofSize: 11)
    fileFinder.toolTip = "Finds a filename for use in other Processors"
    fileFinder.action = #selector(appDelegate().fileFinderAction)
    appDelegate().processorsView.addSubview(fileFinder)
}


func createButtonFileMover () {
let fileMover = NSButton(frame: NSRect(x: 17, y: 645, width: 191, height: 17))
    fileMover.title = "FileMover"
    fileMover.bezelStyle = NSButton.BezelStyle.inline
    fileMover.setButtonType(NSButton.ButtonType.momentaryPushIn)
    fileMover.isBordered = true
    fileMover.font = .boldSystemFont(ofSize: 11)
    fileMover.toolTip = "Moves/renames a file"
    fileMover.action = #selector(appDelegate().fileMoverAction)
    appDelegate().processorsView.addSubview(fileMover)
}


func createButtonFlatPkgPacker () {
let flatPkgPacker = NSButton(frame: NSRect(x: 17, y: 624, width: 191, height: 17))
    flatPkgPacker.title = "FlatPkgPacker"
    flatPkgPacker.bezelStyle = NSButton.BezelStyle.inline
    flatPkgPacker.setButtonType(NSButton.ButtonType.momentaryPushIn)
    flatPkgPacker.isBordered = true
    flatPkgPacker.font = .boldSystemFont(ofSize: 11)
    flatPkgPacker.toolTip = "Flatten an expanded package using pkgutil"
    flatPkgPacker.action = #selector(appDelegate().flatPkgPackerAction)
    appDelegate().processorsView.addSubview(flatPkgPacker)
}


func createButtonFlatPkgUnpacker () {
let flatPkgUnpacker = NSButton(frame: NSRect(x: 17, y: 603, width: 191, height: 17))
    flatPkgUnpacker.title = "FlatPkgUnpacker"
    flatPkgUnpacker.bezelStyle = NSButton.BezelStyle.inline
    flatPkgUnpacker.setButtonType(NSButton.ButtonType.momentaryPushIn)
    flatPkgUnpacker.isBordered = true
    flatPkgUnpacker.font = .boldSystemFont(ofSize: 11)
    flatPkgUnpacker.toolTip = "Expands a flat package using pkgutil or xar. For xar it also optionally skips extracting the payload"
    flatPkgUnpacker.action = #selector(appDelegate().flatPkgUnpackerAction)
    appDelegate().processorsView.addSubview(flatPkgUnpacker)
}


func createButtonGitHubReleasesInfoProvider () {
let gitHubReleasesInfoProvider = NSButton(frame: NSRect(x: 17, y: 582, width: 191, height: 17))
    gitHubReleasesInfoProvider.title = "GitHubReleasesInfoProvider"
    gitHubReleasesInfoProvider.bezelStyle = NSButton.BezelStyle.inline
    gitHubReleasesInfoProvider.setButtonType(NSButton.ButtonType.momentaryPushIn)
    gitHubReleasesInfoProvider.isBordered = true
    gitHubReleasesInfoProvider.font = .boldSystemFont(ofSize: 11)
    gitHubReleasesInfoProvider.toolTip = "Get metadata from the latest release from a GitHub project using the GitHub Releases API. Requires version 0.5.0"
    gitHubReleasesInfoProvider.action = #selector(appDelegate().gitHubReleasesInfoProviderAction)
    appDelegate().processorsView.addSubview(gitHubReleasesInfoProvider)
}


func createButtonInstallFromDMG () {
let installFromDMG = NSButton(frame: NSRect(x: 17, y: 561, width: 191, height: 17))
    installFromDMG.title = "InstallFromDMG"
    installFromDMG.bezelStyle = NSButton.BezelStyle.inline
    installFromDMG.setButtonType(NSButton.ButtonType.momentaryPushIn)
    installFromDMG.isBordered = true
    installFromDMG.font = .boldSystemFont(ofSize: 11)
    installFromDMG.toolTip = "Calls autopkginstalld to copy items from a disk image to the root filesystem"
    installFromDMG.action = #selector(appDelegate().installFromDMGAction)
    appDelegate().processorsView.addSubview(installFromDMG)
}


func createButtonInstaller () {
let installer = NSButton(frame: NSRect(x: 17, y: 540, width: 191, height: 17))
    installer.title = "Installer"
    installer.bezelStyle = NSButton.BezelStyle.inline
    installer.setButtonType(NSButton.ButtonType.momentaryPushIn)
    installer.isBordered = true
    installer.font = .boldSystemFont(ofSize: 11)
    installer.toolTip = "Calls autopkginstalld to install a package"
    installer.action = #selector(appDelegate().installerAction)
    appDelegate().processorsView.addSubview(installer)
}


func createButtonMunkiCatalogBuilder () {
let munkiCatalogBuilder = NSButton(frame: NSRect(x: 17, y: 519, width: 191, height: 17))
    munkiCatalogBuilder.title = "MunkiCatalogBuilder"
    munkiCatalogBuilder.bezelStyle = NSButton.BezelStyle.inline
    munkiCatalogBuilder.setButtonType(NSButton.ButtonType.momentaryPushIn)
    munkiCatalogBuilder.isBordered = true
    munkiCatalogBuilder.font = .boldSystemFont(ofSize: 11)
    munkiCatalogBuilder.toolTip = "Rebuilds Munki catalogs"
    munkiCatalogBuilder.action = #selector(appDelegate().munkiCatalogBuilderAction)
    appDelegate().processorsView.addSubview(munkiCatalogBuilder)
}


func createButtonMunkiImporter () {
let munkiImporter = NSButton(frame: NSRect(x: 17, y: 498, width: 191, height: 17))
    munkiImporter.title = "MunkiImporter"
    munkiImporter.bezelStyle = NSButton.BezelStyle.inline
    munkiImporter.setButtonType(NSButton.ButtonType.momentaryPushIn)
    munkiImporter.isBordered = true
    munkiImporter.font = .boldSystemFont(ofSize: 11)
    munkiImporter.toolTip = "Imports a pkg or dmg to the Munki repo"
    munkiImporter.action = #selector(appDelegate().munkiImporterAction)
    appDelegate().processorsView.addSubview(munkiImporter)
}


func createButtonMunkiInfoCreator () {
let munkiInfoCreator = NSButton(frame: NSRect(x: 17, y: 477, width: 191, height: 17))
    munkiInfoCreator.title = "MunkiInfoCreator"
    munkiInfoCreator.bezelStyle = NSButton.BezelStyle.inline
    munkiInfoCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    munkiInfoCreator.isBordered = true
    munkiInfoCreator.font = .boldSystemFont(ofSize: 11)
    munkiInfoCreator.toolTip = "Creates a pkginfo file for a munki package"
    munkiInfoCreator.action = #selector(appDelegate().munkiInfoCreatorAction)
    appDelegate().processorsView.addSubview(munkiInfoCreator)
}


func createButtonMunkiInstallsItemsCreator () {
let munkiInstallsItemsCreator = NSButton(frame: NSRect(x: 17, y: 456, width: 191, height: 17))
    munkiInstallsItemsCreator.title = "MunkiInstallsItemsCreator"
    munkiInstallsItemsCreator.bezelStyle = NSButton.BezelStyle.inline
    munkiInstallsItemsCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    munkiInstallsItemsCreator.isBordered = true
    munkiInstallsItemsCreator.font = .boldSystemFont(ofSize: 11)
    munkiInstallsItemsCreator.toolTip = "Generates an installs array for a pkginfo file"
    munkiInstallsItemsCreator.action = #selector(appDelegate().MunkiInstallsItemsCreatorAction)
    appDelegate().processorsView.addSubview(munkiInstallsItemsCreator)
}


func createButtonMunkiPkginfoMerger () {
let munkiPkginfoMerger = NSButton(frame: NSRect(x: 17, y: 435, width: 191, height: 17))
    munkiPkginfoMerger.title = "MunkiPkginfoMerger"
    munkiPkginfoMerger.bezelStyle = NSButton.BezelStyle.inline
    munkiPkginfoMerger.setButtonType(NSButton.ButtonType.momentaryPushIn)
    munkiPkginfoMerger.isBordered = true
    munkiPkginfoMerger.font = .boldSystemFont(ofSize: 11)
    munkiPkginfoMerger.toolTip = "Merges two pkginfo dictionaries"
    munkiPkginfoMerger.action = #selector(appDelegate().munkiPkginfoMergerAction)
    appDelegate().processorsView.addSubview(munkiPkginfoMerger)
}

func createButtonPackageRequired () {
let packageRequired = NSButton(frame: NSRect(x: 17, y: 414, width: 191, height: 17))
    packageRequired.title = "PackageRequired"
    packageRequired.bezelStyle = NSButton.BezelStyle.inline
    packageRequired.setButtonType(NSButton.ButtonType.momentaryPushIn)
    packageRequired.isBordered = true
    packageRequired.font = .boldSystemFont(ofSize: 11)
    packageRequired.toolTip = "Raises a ProcessorError if the PKG variable doesn't exist"
    packageRequired.action = #selector(appDelegate().packageRequiredAction)
    appDelegate().processorsView.addSubview(packageRequired)
}


func createButtonpathDeleter () {
let pathDeleter = NSButton(frame: NSRect(x: 17, y: 393, width: 191, height: 17))
    pathDeleter.title = "PathDeleter"
    pathDeleter.bezelStyle = NSButton.BezelStyle.inline
    pathDeleter.setButtonType(NSButton.ButtonType.momentaryPushIn)
    pathDeleter.isBordered = true
    pathDeleter.font = .boldSystemFont(ofSize: 11)
    pathDeleter.toolTip = "Deletes file paths"
    pathDeleter.action = #selector(appDelegate().pathDeleterAction)
    appDelegate().processorsView.addSubview(pathDeleter)
}


func createButtonPkgCopier () {
let pkgCopier = NSButton(frame: NSRect(x: 17, y: 372, width: 191, height: 17))
    pkgCopier.title = "PkgCopier"
    pkgCopier.bezelStyle = NSButton.BezelStyle.inline
    pkgCopier.setButtonType(NSButton.ButtonType.momentaryPushIn)
    pkgCopier.isBordered = true
    pkgCopier.font = .boldSystemFont(ofSize: 11)
    pkgCopier.toolTip = "Copies source_pkg to pkg_path"
    pkgCopier.action = #selector(appDelegate().pkgCopierAction)
    appDelegate().processorsView.addSubview(pkgCopier)
}


func createButtonPkgCreator () {
let pkgCreator = NSButton(frame: NSRect(x: 17, y: 351, width: 191, height: 17))
    pkgCreator.title = "PkgCreator"
    pkgCreator.bezelStyle = NSButton.BezelStyle.inline
    pkgCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    pkgCreator.isBordered = true
    pkgCreator.font = .boldSystemFont(ofSize: 11)
    pkgCreator.toolTip = "Calls autopkgserver to create a package"
    pkgCreator.action = #selector(appDelegate().pkgCreatorAction)
    appDelegate().processorsView.addSubview(pkgCreator)
}


func createButtonPkgExtractor () {
let pkgExtractor = NSButton(frame: NSRect(x: 17, y: 330, width: 191, height: 17))
    pkgExtractor.title = "PkgExtractor"
    pkgExtractor.bezelStyle = NSButton.BezelStyle.inline
    pkgExtractor.setButtonType(NSButton.ButtonType.momentaryPushIn)
    pkgExtractor.isBordered = true
    pkgExtractor.font = .boldSystemFont(ofSize: 11)
    pkgExtractor.toolTip = "Extracts the contents of a bundle-style pkg (possibly on a disk image) to pkgroot"
    pkgExtractor.action = #selector(appDelegate().pkgExtractorAction)
    appDelegate().processorsView.addSubview(pkgExtractor)
}


func createButtonPkgInfoCreator () {
let pkgInfoCreator = NSButton(frame: NSRect(x: 17, y: 309, width: 191, height: 17))
    pkgInfoCreator.title = "PkgInfoCreator"
    pkgInfoCreator.bezelStyle = NSButton.BezelStyle.inline
    pkgInfoCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    pkgInfoCreator.isBordered = true
    pkgInfoCreator.font = .boldSystemFont(ofSize: 11)
    pkgInfoCreator.toolTip = "Creates an PackageInfo file for a package"
    pkgInfoCreator.action = #selector(appDelegate().pkgInfoCreatorAction)
    appDelegate().processorsView.addSubview(pkgInfoCreator)
}


func createButtonPkgPayloadUnpacker () {
let pkgPayloadUnpacker = NSButton(frame: NSRect(x: 17, y: 288, width: 191, height: 17))
    pkgPayloadUnpacker.title = "PkgPayloadUnpacker"
    pkgPayloadUnpacker.bezelStyle = NSButton.BezelStyle.inline
    pkgPayloadUnpacker.setButtonType(NSButton.ButtonType.momentaryPushIn)
    pkgPayloadUnpacker.isBordered = true
    pkgPayloadUnpacker.font = .boldSystemFont(ofSize: 11)
    pkgPayloadUnpacker.toolTip = "Unpacks a package payload"
    pkgPayloadUnpacker.action = #selector(appDelegate().pkgPayloadUnpackerAction)
    appDelegate().processorsView.addSubview(pkgPayloadUnpacker)
}


func createButtonPkgRootCreator () {
let pkgRootCreator = NSButton(frame: NSRect(x: 17, y: 267, width: 191, height: 17))
    pkgRootCreator.title = "PkgRootCreator"
    pkgRootCreator.bezelStyle = NSButton.BezelStyle.inline
    pkgRootCreator.setButtonType(NSButton.ButtonType.momentaryPushIn)
    pkgRootCreator.isBordered = true
    pkgRootCreator.font = .boldSystemFont(ofSize: 11)
    pkgRootCreator.toolTip = "Creates a package root and a directory structure. (Can also be used to create directory structures for other purposes.)"
    pkgRootCreator.action = #selector(appDelegate().pkgRootCreatorAction)
    appDelegate().processorsView.addSubview(pkgRootCreator)
}


func createButtonPlistEditor () {
let plistEditor = NSButton(frame: NSRect(x: 17, y: 246, width: 191, height: 17))
    plistEditor.title = "PlistEditor"
    plistEditor.bezelStyle = NSButton.BezelStyle.inline
    plistEditor.setButtonType(NSButton.ButtonType.momentaryPushIn)
    plistEditor.isBordered = true
    plistEditor.font = .boldSystemFont(ofSize: 11)
    plistEditor.toolTip = "Merges data with an input plist (which can be empty) and writes a new plist"
    plistEditor.action = #selector(appDelegate().plistEditorAction)
    appDelegate().processorsView.addSubview(plistEditor)
}


func createButtonPlistReader () {
let plistReader = NSButton(frame: NSRect(x: 17, y: 225, width: 191, height: 17))
    plistReader.title = "PlistReader"
    plistReader.bezelStyle = NSButton.BezelStyle.inline
    plistReader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    plistReader.isBordered = true
    plistReader.font = .boldSystemFont(ofSize: 11)
    plistReader.toolTip = "Extracts values from top-level keys in a plist file, and assigns to arbitrary output variables. This behavior is different from other processors that pre-define all their possible output variables. As it is often used for versioning, it defaults to extracting 'CFBundleShortVersionString' to 'version'. This can be used as a replacement for both the AppDmgVersioner and Versioner processors"
    plistReader.action = #selector(appDelegate().plistReaderAction)
    appDelegate().processorsView.addSubview(plistReader)
}


func createButtonSparkleUpdateInfoProvider () {
let sparkleUpdateInfoProvider = NSButton(frame: NSRect(x: 17, y: 204, width: 191, height: 17))
    sparkleUpdateInfoProvider.title = "SparkleUpdateInfoProvider"
    sparkleUpdateInfoProvider.bezelStyle = NSButton.BezelStyle.inline
    sparkleUpdateInfoProvider.setButtonType(NSButton.ButtonType.momentaryPushIn)
    sparkleUpdateInfoProvider.isBordered = true
    sparkleUpdateInfoProvider.font = .boldSystemFont(ofSize: 11)
    sparkleUpdateInfoProvider.toolTip = "Provides URL to the highest version number or latest update"
    sparkleUpdateInfoProvider.action = #selector(appDelegate().sparkleUpdateInfoProviderAction)
    appDelegate().processorsView.addSubview(sparkleUpdateInfoProvider)
}


func createButtonStopProcessingIf () {
let stopProcessingIf = NSButton(frame: NSRect(x: 17, y: 183, width: 191, height: 17))
    stopProcessingIf.title = "StopProcessingIf"
    stopProcessingIf.bezelStyle = NSButton.BezelStyle.inline
    stopProcessingIf.setButtonType(NSButton.ButtonType.momentaryPushIn)
    stopProcessingIf.isBordered = true
    stopProcessingIf.font = .boldSystemFont(ofSize: 11)
    stopProcessingIf.toolTip = "Sets a variable to tell AutoPackager to stop processing a recipe if a predicate comparison evaluates to true"
    stopProcessingIf.action = #selector(appDelegate().stopProcessingIfAction)
    appDelegate().processorsView.addSubview(stopProcessingIf)
}


func createButtonSymlinker () {
let symlinker = NSButton(frame: NSRect(x: 17, y: 162, width: 191, height: 17))
    symlinker.title = "Symlinker"
    symlinker.bezelStyle = NSButton.BezelStyle.inline
    symlinker.setButtonType(NSButton.ButtonType.momentaryPushIn)
    symlinker.isBordered = true
    symlinker.font = .boldSystemFont(ofSize: 11)
    symlinker.toolTip = "Copies source_path to destination_path"
    symlinker.action = #selector(appDelegate().symlinkerAction)
    appDelegate().processorsView.addSubview(symlinker)
}


func createButtonUnarchiver () {
let unarchiver = NSButton(frame: NSRect(x: 17, y: 141, width: 191, height: 17))
    unarchiver.title = "Unarchiver"
    unarchiver.bezelStyle = NSButton.BezelStyle.inline
    unarchiver.setButtonType(NSButton.ButtonType.momentaryPushIn)
    unarchiver.isBordered = true
    unarchiver.font = .boldSystemFont(ofSize: 11)
    unarchiver.toolTip = "Archive decompressor for zip and common tar-compressed formats"
    unarchiver.action = #selector(appDelegate().unarchiverAction)
    appDelegate().processorsView.addSubview(unarchiver)
}


func createButtonUrlDownloader () {
let urlDownloader = NSButton(frame: NSRect(x: 17, y: 120, width: 191, height: 17))
    urlDownloader.title = "URLDownloader"
    urlDownloader.bezelStyle = NSButton.BezelStyle.inline
    urlDownloader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    urlDownloader.isBordered = true
    urlDownloader.font = .boldSystemFont(ofSize: 11)
    urlDownloader.toolTip = "Downloads a URL to the specified download_dir using curl"
    urlDownloader.action = #selector(appDelegate().urlDownloaderAction)
    appDelegate().processorsView.addSubview(urlDownloader)
}


func createButtonUrlTextSearcher () {
let urlTextSearcher = NSButton(frame: NSRect(x: 17, y: 99, width: 191, height: 17))
    urlTextSearcher.title = "URLTextSearcher"
    urlTextSearcher.bezelStyle = NSButton.BezelStyle.inline
    urlTextSearcher.setButtonType(NSButton.ButtonType.momentaryPushIn)
    urlTextSearcher.isBordered = true
    urlTextSearcher.font = .boldSystemFont(ofSize: 11)
    urlTextSearcher.toolTip = "Downloads a URL using curl and performs a regular expression match on the text"
    urlTextSearcher.action = #selector(appDelegate().urlTextSearcherAction)
    appDelegate().processorsView.addSubview(urlTextSearcher)
}


func createButtonVersioner () {
let versioner = NSButton(frame: NSRect(x: 17, y: 78, width: 191, height: 17))
    versioner.title = "Versioner"
    versioner.bezelStyle = NSButton.BezelStyle.inline
    versioner.setButtonType(NSButton.ButtonType.momentaryPushIn)
    versioner.isBordered = true
    versioner.font = .boldSystemFont(ofSize: 11)
    versioner.toolTip = "Returns version information from a plist"
    versioner.action = #selector(appDelegate().versionerAction)
    appDelegate().processorsView.addSubview(versioner)
}


// Functions called from button trigger/action (write output etc)
func appDMGVersioner () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>dmg_path</key>
            <string>%pathname%</string>
        </dict>
        <key>Processor</key>
        <string>AppDmgVersioner</string>
    </dict>
    """
    writeOutput ()
    }


func appPkgCreator () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>pkg_path</key>
            <string>%RECIPE_CACHE_DIR%/%app_name%-%version%.pkg</string>
            <key>app_path</key>
            <string>%RECIPE_CACHE_DIR%/%pathname%/*.app</string>
        </dict>
        <key>Processor</key>
        <string>AppPkgCreator</string>
    </dict>
    """
    
    writeOutput ()
    }


func codeSignatureVerifierApp () {
    
    let dialog = NSOpenPanel();
           dialog.showsHiddenFiles = true;
           dialog.allowsMultipleSelection = false;
           dialog.canChooseFiles = true;
           dialog.message = "Choose a .app to get the codesigning from";
           dialog.allowedFileTypes = ["app"]
      
           if FileManager.default.fileExists(atPath: "/Applications") {
               dialog.directoryURL = NSURL.fileURL(withPath: "/Applications", isDirectory: true)

      }
    
if (dialog.runModal() == NSApplication.ModalResponse.OK) {
          let result = dialog.url // Pathname of the file
               if (result != nil) {
                path = result!.path
                fileName = dialog.url!.lastPathComponent
                print(fileName)
               } else {
                dialog.close()
                return
                }
                } else {
                 dialog.close()
                 return
                  }
    
   var codeSignApp = shell("codesign --display -r- --deep -v '\(path)'")

   if codeSignApp.contains("designated") {
       let codeSignAppArrayTemp = regexFunc(for: "(=>*.*)", in: codeSignApp)
       if codeSignAppArrayTemp.isEmpty {
           
       } else {
      codeSignApp = codeSignAppArrayTemp[0].replacingOccurrences(of: "=> ", with: "", options: [.regularExpression, .caseInsensitive])
   }
   } else {
   }
    
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>input_path</key>
                <string>%pathname%/%NAME%/</string>
                <key>requirement</key>
                <string>\(codeSignApp)</string>
            </dict>
            <key>Processor</key>
            <string>CodeSignatureVerifier</string>
        </dict>
    """
    
    writeOutput ()
    }


func codeSignatureVerifierPKG () {

    let dialog = NSOpenPanel();
           dialog.showsHiddenFiles = true;
           dialog.allowsMultipleSelection = false;
           dialog.canChooseFiles = true;
           dialog.message = "Choose a pkg to get the certificate signature from";
           dialog.allowedFileTypes = ["pkg", "mpkg"]

        let downloadsFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads").path
              if FileManager.default.fileExists(atPath: downloadsFolder) {
                  dialog.directoryURL = NSURL.fileURL(withPath: downloadsFolder, isDirectory: true)
         }

         if (dialog.runModal() == NSApplication.ModalResponse.OK) {
          let result = dialog.url // Pathname of the file
               if (result != nil) {
                path = result!.path
                fileName = dialog.url!.lastPathComponent
               } else {
                dialog.close()
                return
                }
                } else {
                 dialog.close()
                 return
                  }
    
 var codeSignPkg = shell("pkgutil --check-signature '\(path)'")
        var codeSignPkgArrayTemp = codeSignPkg.components(separatedBy: CharacterSet.newlines)
            codeSignPkgArrayTemp = codeSignPkgArrayTemp.map { $0.trimmingCharacters(in: .whitespaces) }
            // Get only matching line 1.
            codeSignPkgArrayTemp = codeSignPkgArrayTemp.filter({ $0.hasPrefix("1. ") })
            
       
    if codeSignPkgArrayTemp.isEmpty {
           } else {
        codeSignPkg = codeSignPkgArrayTemp.joined(separator: "")
        codeSignPkg =  codeSignPkg.replacingOccurrences(of: "1. ", with: "", options: [.regularExpression, .caseInsensitive])
       //codeSignPkg = codeSignPkg.trimmingCharacters(in: .whitespacesAndNewlines)

       }
    
    output = """
    <dict>
    <key>Arguments</key>
    <dict>
      <key>input_path</key>
      <string>%pathname%</string>
      <key>expected_authority_names</key>
      <array>
         <string>\(codeSignPkg)</string>
         <string>Developer ID Certification Authority</string>
         <string>Apple Root CA</string>
      </array>
    </dict>
    <key>Processor</key>
    <string>CodeSignatureVerifier</string>
    </dict>
    """
    
    writeOutput ()
    }


func copier () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>destination_path</key>
            <string>%pkgroot%/Applications/%NAME%.app</string>
            <key>source_path</key>
            <string>%pathname%/%NAME%.app</string>
        </dict>
        <key>Processor</key>
        <string>Copier</string>
    </dict>
    """
    
    writeOutput ()
    }


func deprecationWarning () {
   output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>warning_message</key>
            <string>This recipe has been deprecated</string>
        </dict>
        <key>Processor</key>
        <string>DeprecationWarning</string>
    </dict>
    """
    
    writeOutput ()
    }


func dmgCreator () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>dmg_path</key>
            <string>%RECIPE_CACHE_DIR%/%NAME%.dmg</string>
            <key>dmg_root</key>
            <string>%RECIPE_CACHE_DIR%/%NAME%/Applications</string>
        </dict>
        <key>Processor</key>
        <string>DmgCreator</string>
    </dict>
    """
    
    writeOutput ()
    }


func dmgMounter () {
    }


func endOfCheckPhase () {
   output = """
    <dict>
        <key>Processor</key>
        <string>EndOfCheckPhase</string>
    </dict>
    """
    
    writeOutput ()
    }


func fileCreator () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>file_content</key>
            <string></string>
            <key>file_mode</key>
            <string>0755</string>
            <key>file_path</key>
            <string>%RECIPE_CACHE_DIR%/%NAME%/Scripts/postinstall</string>
        </dict>
        <key>Processor</key>
        <string>FileCreator</string>
    </dict>
    """
    
    writeOutput ()
    }


func fileFinder () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>pattern</key>
        <string>%pathname%/*.pkg</string>
    </dict>
    <key>Processor</key>
    <string>FileFinder</string>
</dict>
"""
    
    writeOutput ()
    }


func fileMover () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>overwrite</key>
            <string>true</string>
            <key>source</key>
            <string>%RECIPE_CACHE_DIR%/unpacked/</string>
            <key>target</key>
            <string>%RECIPE_CACHE_DIR%/</string>
        </dict>
        <key>Processor</key>
        <string>FileMover</string>
    </dict>
    """
    
    writeOutput ()
    }


func flatPkgPacker () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>source_flatpkg_dir</key>
            <string>%RECIPE_CACHE_DIR%/unpacked</string>
            <key>destination_pkg</key>
            <string>%RECIPE_CACHE_DIR%/repack/%NAME%.pkg</string>
        </dict>
        <key>Processor</key>
        <string>FlatPkgPacker</string>
    </dict>
    """
    
   writeOutput ()
    }


func flatPkgUnpacker () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>destination_path</key>
            <string>%RECIPE_CACHE_DIR%/unpacked</string>
            <key>flat_pkg_path</key>
            <string>%pathname%</string>
            <key>purge_destination</key>
            <true></true>
        </dict>
        <key>Processor</key>
        <string>FlatPkgUnpacker</string>
    </dict>
    """
    
   writeOutput ()
    }


func gitHubReleasesInfoProvider () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>github_repo</key>
            <string>%GITHUB_REPO%</string>
        </dict>
        <key>Processor</key>
        <string>GitHubReleasesInfoProvider</string>
    </dict>
    """
    
    writeOutput ()
    }


func installFromDMG () {
   output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>dmg_path</key>
            <string>%dmg_path%</string>
            <key>items_to_copy</key>
            <array>
                <dict>
                    <key>destination_path</key>
                    <string>/Applications</string>
                    <key>source_item</key>
                    <string>%NAME%.app</string>
                </dict>
            </array>
        </dict>
        <key>Processor</key>
        <string>InstallFromDMG</string>
    </dict>
    """
    
    writeOutput ()
    }


func installer () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>pkg_path</key>
            <string>%RECIPE_CACHE_DIR%/%NAME%.pkg</string>
        </dict>
        <key>Processor</key>
        <string>Installer</string>
    </dict>
    """
    
    writeOutput ()
    }


func munkiCatalogBuilder () {
    output = """
      <dict>
          <key>Arguments</key>
          <dict>
              <key>MUNKI_REPO</key>
              <string>/path/to/munki/repo</string>
          </dict>
          <key>Processor</key>
          <string>MunkiCatalogBuilder</string>
      </dict>
      """
      
      writeOutput ()
}


func munkiImporter () {
  output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>pkg_path</key>
            <string>%pathname%</string>
            <key>repo_subdirectory</key>
            <string>%MUNKI_REPO_SUBDIR%</string>
        </dict>
        <key>Processor</key>
        <string>MunkiImporter</string>
    </dict>
    """
    
    writeOutput ()
    }


func munkiInfoCreator () {
    output = """
    <dict>
       <key>Arguments</key>
       <dict>
          <key>pkg_path</key>
          <string>%pathname%</string>
       </dict>
       <key>Processor</key>
       <string>MunkiInfoCreator</string>
    </dict>
    """
    
    writeOutput ()
    }


func munkiInstallsItemsCreator () {
    output = """
   <dict>
       <key>Arguments</key>
       <dict>
           <key>faux_root</key>
           <string>%RECIPE_CACHE_DIR%</string>
           <key>installs_item_paths</key>
           <array>
               <string>/Applications/%NAME%.app</string>
           </array>
       </dict>
       <key>Processor</key>
       <string>MunkiInstallsItemsCreator</string>
   </dict>
   """
   
    writeOutput ()
    }


func munkiPkginfoMerger () {
   output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>additional_pkginfo</key>
            <dict>
                <key>minimum_os_version</key>
                <string>10.13</string>
            </dict>
        </dict>
        <key>Processor</key>
        <string>MunkiPkginfoMerger</string>
    </dict>
    """
    
    writeOutput ()
    }


func packageRequired () {
    output = """
    <dict>
        <key>Processor</key>
        <string>PackageRequired</string>
    </dict>
    """
    
    writeOutput ()
    }


func pathDeleter () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>path_list</key>
            <array>
                <string>%RECIPE_CACHE_DIR%/unpack</string>
            </array>
        </dict>
        <key>Processor</key>
        <string>PathDeleter</string>
    </dict>
    """
    
    writeOutput ()
    }


func pkgCopier () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>pkg_path</key>
            <string>%RECIPE_CACHE_DIR%/%NAME%-%version%.pkg</string>
            <key>source_pkg</key>
            <string>%pathname%/%NAME%.pkg</string>
        </dict>
        <key>Processor</key>
        <string>PkgCopier</string>
    </dict>
    """
    
    writeOutput ()
    }


func pkgCreator () {
    output = """
            <dict>
                <key>Arguments</key>
                <dict>
                    <key>pkg_request</key>
                    <dict>
                        <key>pkgname</key>
                        <string>%NAME%-%version%</string>
                        <key>pkgdir</key>
                        <string>%RECIPE_CACHE_DIR%/%NAME%</string>
                        <key>id</key>
                        <string>com.yourdomain.%NAME%</string>
                        <key>options</key>
                        <string>purge_ds_store</string>
                        <key>chown</key>
                        <array>
                            <dict>
                                <key>path</key>
                                <string>Applications</string>
                                <key>user</key>
                                <string>root</string>
                                <key>group</key>
                                <string>admin</string>
                            </dict>
                        </array>
                    </dict>
                </dict>
                <key>Processor</key>
                <string>PkgCreator</string>
            </dict>
    """
    
    writeOutput ()
    }


func pkgExtractor () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>extract_root</key>
            <string>%RECIPE_CACHE_DIR%/pkgroot</string>
            <key>pkg_path</key>
            <string>%pathname%/%NAME%.pkg</string>
        </dict>
        <key>Processor</key>
        <string>PkgExtractor</string>
    </dict>
    """
    
    writeOutput ()
    }


func pkgInfoCreator () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>template_path</key>
            <string>PackageInfoTemplate</string>
            <key>infofile</key>
            <string>%RECIPE_CACHE_DIR%/PackageInfo</string>
            <key>pkgtype</key>
            <string>flat</string>
        </dict>
        <key>Processor</key>
        <string>PkgInfoCreator</string>
    </dict>
    """
    
    writeOutput ()
    }


func pkgPayloadUnpacker () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>destination_path</key>
            <string>%RECIPE_CACHE_DIR%/payload</string>
            <key>pkg_payload_path</key>
            <string>%RECIPE_CACHE_DIR%/unpacked/%NAME%.pkg/Payload</string>
            <key>purge_destination</key>
            <true></true>
        </dict>
        <key>Processor</key>
        <string>PkgPayloadUnpacker</string>
    </dict>
    """
    
    writeOutput ()
    }


func pkgRootCreator () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>pkgdirs</key>
            <dict>
                <key>Applications</key>
                <string>0755</string>
            </dict>
            <key>pkgroot</key>
            <string>%RECIPE_CACHE_DIR%/%NAME%</string>
        </dict>
        <key>Processor</key>
        <string>PkgRootCreator</string>
    </dict>
    """
    
    writeOutput ()
    }


func plistEditor () {
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>input_plist_path</key>
                <string>'%pkgroot%/%NAME%.app/Contents/Info.plist'</string>
                <key>output_plist_path</key>
                <string>'%pkgroot%/%NAME%.app/Contents/Info.plist'</string>
                <key>plist_data</key>
                <dict>
                    <key>CFBundleShortVersionString</key>
                    <string>'%version%'</string>
                </dict>
            </dict>
            <key>Process</key>
            <dict></dict>
            <key>Processor</key>
            <string>PlistEditor</string>
        </dict>
    """
    
    writeOutput ()
    }


func plistReader () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>info_path</key>
            <string>%destination_path%/%NAME%.app</string>
            <key>plist_keys</key>
            <dict>
                <key>CFBundleIdentifier</key>
                <string>bundleid</string>
                <key>CFBundleShortVersionString</key>
                <string>version</string>
            </dict>
        </dict>
        <key>Processor</key>
        <string>PlistReader</string>
    </dict>
    """
    
    writeOutput ()
    }


func sparkleUpdateInfoProvider () {
    output = """
     <dict>
         <key>Arguments</key>
         <dict>
             <key>appcast_url</key>
             <string>%SPARKLE_FEED_URL%</string>
         </dict>
         <key>Processor</key>
         <string>SparkleUpdateInfoProvider</string>
     </dict>
    """
    
    writeOutput ()
    }


func stopProcessingIf () {
    output = """
     <dict>
         <key>Arguments</key>
         <dict>
             <key>predicate</key>
             <string>TRUEPREDICATE</string>
         </dict>
         <key>Processor</key>
         <string>StopProcessingIf</string>
     </dict>
    """
    
    writeOutput ()
    }

func symlinker () {
    output = """
     <dict>
         <key>Arguments</key>
         <dict>
             <key>source_path</key>
             <string>/a/path</string>
             <key>destination_path</key>
             <string>/b/path</string>
         </dict>
         <key>Processor</key>
         <string>Symlinker</string>
     </dict>
    """
    
    writeOutput ()
    }


func unarchiver () {
    output = """
     <dict>
         <key>Arguments</key>
         <dict>
             <key>archive_path</key>
             <string>%pathname%</string>
             <key>destination_path</key>
             <string>%RECIPE_CACHE_DIR%/%NAME%</string>
             <key>purge_destination</key>
             <true></true>
         </dict>
         <key>Processor</key>
         <string>Unarchiver</string>
     </dict>
    """
    
    writeOutput ()
    }


func urlDownloader () {
    output = """
     <dict>
         <key>Arguments</key>
         <dict>
             <key>filename</key>
             <string>%NAME%.dmg</string>
             <key>url</key>
             <string>%DOWNLOAD_URL%</string>
         </dict>
         <key>Processor</key>
         <string>URLDownloader</string>
     </dict>
    """
    
    writeOutput ()
    }


func urlTextSearcher () {
    output = """
     <dict>
         <key>Arguments</key>
         <dict>
             <key>re_pattern</key>
             <string>(\\d)</string>
             <key>result_output_var_name</key>
             <string>version</string>
             <key>url</key>
             <string>INSERT_YOUR_DOWNLOAD_URL_HERE</string>
         </dict>
         <key>Processor</key>
         <string>URLTextSearcher</string>
     </dict>
    """
    
    writeOutput ()
    }


func versioner () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>input_plist_path</key>
            <string>%RECIPE_CACHE_DIR%/%NAME%.app/Contents/Info.plist</string>
            <key>plist_version_key</key>
            <string>CFBundleVersion</string>
        </dict>
        <key>Processor</key>
        <string>Versioner</string>
    </dict>
    """
    
    writeOutput ()
    }
