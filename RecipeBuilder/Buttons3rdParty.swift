//
//  Buttons3rdParty.swift
//
//  Created by Mikael Löfgren on 2024-12-27
//  Copyright © 2024 Mikael Löfgren. All rights reserved.
//

import Cocoa
import AppKit
import Foundation
import Highlightr

func createAll3rdPartyButtons () {
        createButtonJamfAccountUploader()
        createButtonJamfCategoryUploader()
        createButtonJamfClassicAPIObjectUploader()
        createButtonJamfComputerGroupDeleter()
        createButtonJamfComputerGroupUploader()
        createButtonJamfComputerProfileUploader()
        createButtonJamfDockItemUploader()
        createButtonJamfExtensionAttributeUploader()
        createButtonJamfIconUploader()
        createButtonJamfMacAppUploader()
        createButtonJamfMobileDeviceGroupUploader()
        createButtonJamfMobileDeviceProfileUploader()
        createButtonJamfPackageCleaner()
        createButtonJamfPackageRecalculator()
        createButtonJamfPackageUploader()
        createButtonJamfPatchChecker()
        createButtonJamfPatchUploader()
        createButtonJamfPkgMetadataUploader()
        createButtonJamfPolicyDeleter()
        createButtonJamfPolicyLogFlusher()
        createButtonJamfPolicyUploader()
        createButtonJamfScriptUploader()
        createButtonJamfSoftwareRestrictionUploader()
        createButtonJamfUploaderSlacker()
        createButtonJamfUploaderTeamsNotifier()
}

// Functions to create the buttons
// 21 pixels between every button
// https://github.com/autopkg/grahampugh-recipes/blob/main/JamfUploaderProcessors/READMEs/JamfCategoryUploader.md
func createButtonJamfAccountUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 855, width: 191, height: 17))
    button.title = "JamfAccountUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload an account to Jamf"
    button.action = #selector(appDelegate().JamfAccountUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfCategoryUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 834, width: 191, height: 17))
    button.title = "JamfCategoryUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a category to Jamf"
    button.action = #selector(appDelegate().JamfCategoryUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfClassicAPIObjectUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 813, width: 191, height: 17))
    button.title = "JamfClassicAPIObjectUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload Classic API objects to Jamf"
    button.action = #selector(appDelegate().JamfClassicAPIObjectUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfComputerGroupDeleter() {
    let button = NSButton(frame: NSRect(x: 17, y: 792, width: 191, height: 17))
    button.title = "JamfComputerGroupDeleter"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Delete a computer group in Jamf"
    button.action = #selector(appDelegate().JamfComputerGroupDeleterAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfComputerGroupUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 771, width: 191, height: 17))
    button.title = "JamfComputerGroupUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a computer group to Jamf"
    button.action = #selector(appDelegate().JamfComputerGroupUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfComputerProfileUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 750, width: 191, height: 17))
    button.title = "JamfComputerProfileUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a computer profile to Jamf"
    button.action = #selector(appDelegate().JamfComputerProfileUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfDockItemUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 729, width: 191, height: 17))
    button.title = "JamfDockItemUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a dock item to Jamf"
    button.action = #selector(appDelegate().JamfDockItemUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfExtensionAttributeUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 708, width: 191, height: 17))
    button.title = "JamfExtensionAttributeUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload an extension attribute to Jamf"
    button.action = #selector(appDelegate().JamfExtensionAttributeUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfIconUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 687, width: 191, height: 17))
    button.title = "JamfIconUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload an icon to Jamf"
    button.action = #selector(appDelegate().JamfIconUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfMacAppUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 666, width: 191, height: 17))
    button.title = "JamfMacAppUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a Mac app to Jamf"
    button.action = #selector(appDelegate().JamfMacAppUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfMobileDeviceGroupUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 645, width: 191, height: 17))
    button.title = "JamfMobileDeviceGroupUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a mobile device group to Jamf"
    button.action = #selector(appDelegate().JamfMobileDeviceGroupUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfMobileDeviceProfileUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 624, width: 191, height: 17))
    button.title = "JamfMobileDeviceProfileUpload"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a mobile device profile to Jamf"
    button.action = #selector(appDelegate().JamfMobileDeviceProfileUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPackageCleaner() {
    let button = NSButton(frame: NSRect(x: 17, y: 603, width: 191, height: 17))
    button.title = "JamfPackageCleaner"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Clean up old packages in Jamf"
    button.action = #selector(appDelegate().JamfPackageCleanerAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPackageRecalculator() {
    let button = NSButton(frame: NSRect(x: 17, y: 582, width: 191, height: 17))
    button.title = "JamfPackageRecalculator"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Recalculate package information in Jamf"
    button.action = #selector(appDelegate().JamfPackageRecalculatorAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPackageUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 561, width: 191, height: 17))
    button.title = "JamfPackageUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a package to Jamf"
    button.action = #selector(appDelegate().JamfPackageUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPatchChecker() {
    let button = NSButton(frame: NSRect(x: 17, y: 540, width: 191, height: 17))
    button.title = "JamfPatchChecker"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Check for patch updates in Jamf"
    button.action = #selector(appDelegate().JamfPatchCheckerAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPatchUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 519, width: 191, height: 17))
    button.title = "JamfPatchUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload patch definitions to Jamf"
    button.action = #selector(appDelegate().JamfPatchUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPkgMetadataUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 498, width: 191, height: 17))
    button.title = "JamfPkgMetadataUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload pkg Metadata to Jamf"
    button.action = #selector(appDelegate().JamfPkgMetadataUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPolicyDeleter() {
    let button = NSButton(frame: NSRect(x: 17, y: 477, width: 191, height: 17))
    button.title = "JamfPolicyDeleter"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Delete policies in Jamf"
    button.action = #selector(appDelegate().JamfPolicyDeleterAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPolicyLogFlusher() {
    let button = NSButton(frame: NSRect(x: 17, y: 456, width: 191, height: 17))
    button.title = "JamfPolicyLogFlusher"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Flush policy logs in Jamf"
    button.action = #selector(appDelegate().JamfPolicyLogFlusherAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfPolicyUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 435, width: 191, height: 17))
    button.title = "JamfPolicyUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a policy to Jamf"
    button.action = #selector(appDelegate().JamfPolicyUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfScriptUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 414, width: 191, height: 17))
    button.title = "JamfScriptUploader"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload a script to Jamf"
    button.action = #selector(appDelegate().JamfScriptUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfSoftwareRestrictionUploader() {
    let button = NSButton(frame: NSRect(x: 17, y: 393, width: 191, height: 17))
    button.title = "JamfSoftwareRestrictionUpload"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Upload software restrictions to Jamf"
    button.action = #selector(appDelegate().JamfSoftwareRestrictionUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfUploaderSlacker() {
    let button = NSButton(frame: NSRect(x: 17, y: 372, width: 191, height: 17))
    button.title = "JamfUploaderSlacker"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Send notifications to Slack"
    button.action = #selector(appDelegate().JamfUploaderSlackerAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}

func createButtonJamfUploaderTeamsNotifier() {
    let button = NSButton(frame: NSRect(x: 17, y: 351, width: 191, height: 17))
    button.title = "JamfUploaderTeamsNotifier"
    button.bezelStyle = .inline
    button.setButtonType(.momentaryPushIn)
    button.isBordered = true
    button.font = .boldSystemFont(ofSize: 11)
    button.toolTip = "Send notifications to Microsoft Teams"
    button.action = #selector(appDelegate().JamfUploaderTeamsNotifierAction)
    appDelegate().processorsView3rdParty.addSubview(button)
}


// Functions called from button trigger/action (write output etc)
func JamfAccountUploader() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>account_name</key>
        <string>%ACCOUNT_NAME%</string>
        <key>account_type</key>
        <string>user</string>
        <key>account_template</key>
        <string>/path/to/XML</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfAccountUploader</string>
</dict>
"""
    writeOutput()
}

func JamfCategoryUploader () {
    output = """
    <dict>
        <key>Arguments</key>
        <dict>
            <key>category_name</key>
            <string>%CATEGORY%</string>
        </dict>
        <key>Processor</key>
        <string>com.github.grahampugh.jamf-upload.processors/JamfCategoryUploader</string>
    </dict>
"""
    writeOutput ()
    }

func JamfClassicAPIObjectUploader() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>object_name</key>
        <string>%OBJECT_NAME%</string>
        <key>object_type</key>
        <string>%OBJECT_TYPE%</string>
        <key>object_template</key>
        <string>/path/to/template.xml</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfClassicAPIObjectUploader</string>
</dict>
"""
    writeOutput()
}

func JamfComputerGroupDeleter() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>computergroup_name</key>
        <string>%GROUP_NAME%</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfComputerGroupDeleter</string>
</dict>
"""
    writeOutput()
}

func JamfComputerGroupUploader () {
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>computergroup_name</key>
                <string>%GROUP_NAME%</string>
                <key>computergroup_template</key>
                <string>/path/to/template.xml</string>
            </dict>
            <key>Processor</key>
            <string>com.github.grahampugh.jamf-upload.processors/JamfComputerGroupUploader</string>
        </dict>
"""
    writeOutput ()
}

func JamfComputerProfileUploader () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>profile_name</key>
        <string>%PROFILE_NAME%</string>
        <key>mobileconfig</key>
        <string>/path/to/mobileconfig</string>
        <key>identifier</key>
        <string>Configuration Profile payload identifier</string>
        <key>profile_category</key>
        <string>Category to assign to the profile</string>
        <key>organization</key>
        <string>Organization to assign to the profile</string>
        <key>profile_description</key>
        <string>Description to assign to the profile</string>
        <key>profile_computergroup</key>
        <string>Device group that will be scoped to the profile</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfComputerProfileUploader</string>
</dict>
"""
    writeOutput ()
}

func JamfDockItemUploader () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>dock_item_name</key>
        <string>%NAME%</string>
        <key>dock_item_type</key>
        <string>App</string>
        <key>dock_item_path</key>
        <string>file:///Applications/AppName.app/</string>
        <key>replace_dock_item</key>
        <string>False</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfDockItemUploader</string>
</dict>
"""
    writeOutput ()
}

func JamfExtensionAttributeUploader () {
    output = """
    <dict>
         <key>Arguments</key>
         <dict>
             <key>ea_name</key>
             <string>%EXTENSION_ATTRIBUTE_NAME%</string>
             <key>ea_script_path</key>
             <string>%EXTENSION_ATTRIBUTE_SCRIPT%</string>
         </dict>
         <key>Processor</key>
         <string>com.github.grahampugh.jamf-upload.processors/JamfExtensionAttributeUploader</string>
     </dict>
"""
    writeOutput ()
}

func JamfIconUploader() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>icon_file</key>
        <string>/path/to/icon.png</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfIconUploader</string>
</dict>
"""
    writeOutput()
}

func JamfMacAppUploader () {
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>macapp_name</key>
                <string>Mac App Store app name</string>
                <key>macapp_template</key>
                <string>/path/to/template.xml</string>
            </dict>
            <key>Processor</key>
            <string>com.github.grahampugh.jamf-upload.processors/JamfMacAppUploader</string>
        </dict>
"""
    writeOutput ()
}


func JamfMobileDeviceGroupUploader() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>mobiledevicegroup_name</key>
        <string>%GROUP_NAME%</string>
        <key>mobiledevicegroup_template</key>
        <string>/path/to/template.xml</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfMobileDeviceGroupUploader</string>
</dict>
"""
    writeOutput()
}

func JamfMobileDeviceProfileUploader() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>profile_name</key>
        <string>%PROFILE_NAME%</string>
        <key>mobileconfig</key>
        <string>/path/to/mobileconfig</string>
        <key>identifier</key>
        <string>Configuration Profile payload identifier</string>
        <key>profile_category</key>
        <string>Category to assign to the profile</string>
        <key>organization</key>
        <string>Organization to assign to the profile</string>
        <key>profile_description</key>
        <string>Description to assign to the profile</string>
        <key>profile_mobiledevicegroup</key>
        <string>Device group that will be scoped to the profile</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfMobileDeviceProfileUploader</string>
</dict>
"""
    writeOutput()
}

func JamfPackageCleaner() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>pkg_name_match</key>
        <string>%NAME%-</string>
        <key>versions_to_keep</key>
        <string>5</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfPackageCleaner</string>
</dict>
"""
    writeOutput()
}

func JamfPackageRecalculator() {
    output = """
<dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfPackageRecalculator</string>
</dict>
"""
    writeOutput()
}

func JamfPackageUploader () {
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>pkg_category</key>
                <string>%CATEGORY%</string>
            </dict>
            <key>Processor</key>
            <string>com.github.grahampugh.jamf-upload.processors/JamfPackageUploader</string>
        </dict>
"""
    writeOutput ()
}

func JamfPatchChecker() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>patch_softwaretitle</key>
        <string>Name of the patch softwaretitle (e.g. 'Mozilla Firefox') used in Jamf.</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfPatchChecker</string>
</dict>
"""
    writeOutput()
}


func JamfPatchUploader () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>patch_softwaretitle</key>
        <string>%NAME%</string>
        <key>patch_name</key>
        <string>%PATCH_NAME%</string>
        <key>patch_template</key>
        <string>PatchTemplate-selfservice.xml</string>
        <key>patch_icon_policy_name</key>
        <string>Install Latest %NAME%</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfPatchUploader</string>
</dict>
"""
    writeOutput ()
}


func JamfPkgMetadataUploader() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>pkg_display_name</key>
        <string>Package display name</string>
        <key>pkg_category</key>
        <string>Package category</string>
        <key>pkg_info</key>
        <string>Package info field</string>
        <key>pkg_notes</key>
        <string>Package notes field</string>
        <key>pkg_priority</key>
        <string>Package priority. Default=10</string>
        <key>reboot_required</key>
        <string>Default='False'</string>
        <key>os_requirements</key>
        <string>Package OS requirement</string>
        <key>required_processor</key>
        <string>Package required processor. Acceptable values are 'x86' or 'None'</string>
        <key>send_notification</key>
        <string>Whether to send a notification when a package is installed. Default='False'</string>
        <key>replace_pkg_metadata</key>
        <string>Overwrite existing package metadata and continue if True</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfPkgMetadataUploader</string>
</dict>
"""
    writeOutput()
}

func JamfPolicyDeleter() {
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>policy_name</key>
                <string>%POLICY_NAME%</string>
            </dict>
            <key>Processor</key>
            <string>com.github.grahampugh.jamf-upload.processors/JamfPolicyDeleter</string>
        </dict>
"""
    writeOutput ()
}

func JamfPolicyLogFlusher() {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>policy_name</key>
        <string>%POLICY_NAME%</string>
        <key>logflush_interval</key>
        <string>Zero Days</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfPolicyLogFlusher</string>
</dict>
"""
    writeOutput ()
}


func JamfPolicyUploader () {
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>icon</key>
                <string>%SELF_SERVICE_ICON%</string>
                <key>policy_name</key>
                <string>%POLICY_NAME%</string>
                <key>policy_template</key>
                <string>%POLICY_TEMPLATE%</string>
            </dict>
            <key>Processor</key>
            <string>com.github.grahampugh.jamf-upload.processors/JamfPolicyUploader</string>
        </dict>
"""
    writeOutput ()
}

func JamfScriptUploader () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>script_path</key>
        <string>/path/to/script.sh</string>
        <key>script_category</key>
        <string>%SCRIPT_CATEGORY%</string>
        <key>script_priority</key>
        <string>After</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfScriptUploader</string>
</dict>
"""
    writeOutput ()
}

func JamfSoftwareRestrictionUploader () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>restriction_name</key>
        <string>Name of Restriction</string>
        <key>restriction_template</key>
        <string>/path/to/template.xml</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfSoftwareRestrictionUploader</string>
</dict>
"""
    writeOutput ()
}

func JamfUploaderSlacker () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>NAME</key>
        <string>Name of the application</string>
        <key>slack_webhook_url</key>
        <string>https://slack.webhook.url</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfUploaderSlacker</string>
</dict>
"""
    writeOutput ()
}

func JamfUploaderTeamsNotifier () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>NAME</key>
        <string>Name of the application</string>
        <key>teams_webhook_url</key>
        <string>https://teams.webhook.url</string>
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfUploaderTeamsNotifier</string>
</dict>
"""
    writeOutput ()
}
