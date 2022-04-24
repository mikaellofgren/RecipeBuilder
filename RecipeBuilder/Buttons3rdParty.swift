//
//  Buttons3rdParty.swift
//  RecipeBuilder
//
//  Created by Mikael Löfgren on 2022-02-27.
//  Copyright © 2022 Mikael Löfgren. All rights reserved.
//

import Cocoa
import AppKit
import Foundation
import Highlightr

func createAll3rdPartyButtons () {
    createButtonJamfCategoryUploader ()
    createButtonJamfComputerGroupUploader ()
    createButtonJamfComputerProfileUploader ()
    createButtonJamfDockItemUploader ()
    createButtonJamfExtensionAttributeUploader ()
    createButtonJamfMacAppUploader ()
    createButtonJamfPackageUploader ()
    createButtonJamfPatchUploader ()
    createButtonJamfPolicyDeleter ()
    createButtonJamfPolicyLogFlusher ()
    createButtonJamfPolicyUploader ()
    createButtonJamfScriptUploader ()
    createButtonJamfSoftwareRestrictionUploader ()
    createButtonJamfUploaderSlacker ()
    createButtonJamfUploaderTeamsNotifier ()
}

// https://github.com/autopkg/grahampugh-recipes/blob/main/JamfUploaderProcessors/READMEs/JamfCategoryUploader.md

func createButtonJamfCategoryUploader () {
let JamfCategoryUploader = NSButton(frame: NSRect(x: 17, y: 324, width: 191, height: 17))
    JamfCategoryUploader.title = "JamfCategoryUploader"
    JamfCategoryUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfCategoryUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfCategoryUploader.isBordered = true
    JamfCategoryUploader.font = .boldSystemFont(ofSize: 11)
    JamfCategoryUploader.toolTip = "Upload a category to Jamf"
    JamfCategoryUploader.action = #selector(appDelegate().JamfCategoryUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfCategoryUploader)
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

func createButtonJamfComputerGroupUploader () {
let JamfComputerGroupUploader = NSButton(frame: NSRect(x: 17, y: 303, width: 191, height: 17))
    JamfComputerGroupUploader.title = "JamfComputerGroupUploader"
    JamfComputerGroupUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfComputerGroupUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfComputerGroupUploader.isBordered = true
    JamfComputerGroupUploader.font = .boldSystemFont(ofSize: 11)
    JamfComputerGroupUploader.toolTip = "Upload a computer group to Jamf"
    JamfComputerGroupUploader.action = #selector(appDelegate().JamfComputerGroupUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfComputerGroupUploader)
}

func JamfComputerGroupUploader () {
    output = """
        <dict>
            <key>Arguments</key>
            <dict>
                <key>computergroup_name</key>
                <string>%GROUP_NAME%</string>
                <key>computergroup_template</key>
                <string>%GROUP_TEMPLATE%</string>
            </dict>
            <key>Processor</key>
            <string>com.github.grahampugh.jamf-upload.processors/JamfComputerGroupUploader</string>
        </dict>
"""
    writeOutput ()
}

func createButtonJamfComputerProfileUploader () {
let JamfComputerProfileUploader = NSButton(frame: NSRect(x: 17, y: 282, width: 191, height: 17))
    JamfComputerProfileUploader.title = "JamfComputerProfileUploader"
    JamfComputerProfileUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfComputerProfileUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfComputerProfileUploader.isBordered = true
    JamfComputerProfileUploader.font = .boldSystemFont(ofSize: 11)
    JamfComputerProfileUploader.toolTip = "Upload computer configuration profiles to Jamf"
    JamfComputerProfileUploader.action = #selector(appDelegate().JamfComputerProfileUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfComputerProfileUploader)
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
    </dict>
    <key>Processor</key>
    <string>com.github.grahampugh.jamf-upload.processors/JamfComputerProfileUploader</string>
</dict>
"""
    writeOutput ()
}

func createButtonJamfDockItemUploader () {
let JamfDockItemUploader = NSButton(frame: NSRect(x: 17, y: 261, width: 191, height: 17))
    JamfDockItemUploader.title = "JamfDockItemUploader"
    JamfDockItemUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfDockItemUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfDockItemUploader.isBordered = true
    JamfDockItemUploader.font = .boldSystemFont(ofSize: 11)
    JamfDockItemUploader.toolTip = "Upload a dock item to Jamf"
    JamfDockItemUploader.action = #selector(appDelegate().JamfDockItemUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfDockItemUploader)
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

func createButtonJamfExtensionAttributeUploader () {
let JamfExtensionAttributeUploader = NSButton(frame: NSRect(x: 17, y: 240, width: 191, height: 17))
    JamfExtensionAttributeUploader.title = "JamfExtensionAttributeUploader"
    JamfExtensionAttributeUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfExtensionAttributeUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfExtensionAttributeUploader.isBordered = true
    JamfExtensionAttributeUploader.font = .boldSystemFont(ofSize: 11)
    JamfExtensionAttributeUploader.toolTip = "Upload a extension attribute to Jamf"
    JamfExtensionAttributeUploader.action = #selector(appDelegate().JamfExtensionAttributeUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfExtensionAttributeUploader)
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

func createButtonJamfMacAppUploader () {
    let JamfMacAppUploader = NSButton(frame: NSRect(x: 17, y: 219, width: 191, height: 17))
        JamfMacAppUploader.title = "JamfMacAppUploader"
        JamfMacAppUploader.bezelStyle = NSButton.BezelStyle.inline
        JamfMacAppUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
        JamfMacAppUploader.isBordered = true
        JamfMacAppUploader.font = .boldSystemFont(ofSize: 11)
        JamfMacAppUploader.toolTip = "Upload a Mac App Store app to a Jamf"
        JamfMacAppUploader.action = #selector(appDelegate().JamfMacAppUploaderAction)
    appDelegate().processorsView3rdParty.addSubview(JamfMacAppUploader)
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



func createButtonJamfPackageUploader () {
let JamfPackageUploader = NSButton(frame: NSRect(x: 17, y: 198, width: 191, height: 17))
    JamfPackageUploader.title = "JamfPackageUploader"
    JamfPackageUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfPackageUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfPackageUploader.isBordered = true
    JamfPackageUploader.font = .boldSystemFont(ofSize: 11)
    JamfPackageUploader.toolTip = "Upload a package to Jamf"
    JamfPackageUploader.action = #selector(appDelegate().JamfPackageUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfPackageUploader)
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

func createButtonJamfPatchUploader () {
let JamfPatchUploader = NSButton(frame: NSRect(x: 17, y: 177, width: 191, height: 17))
    JamfPatchUploader.title = "JamfPatchUploader"
    JamfPatchUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfPatchUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfPatchUploader.isBordered = true
    JamfPatchUploader.font = .boldSystemFont(ofSize: 11)
    JamfPatchUploader.toolTip = "Upload a patch defination to Jamf"
    JamfPatchUploader.action = #selector(appDelegate().JamfPatchUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfPatchUploader)
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

func createButtonJamfPolicyDeleter () {
let JamfPolicyDeleter = NSButton(frame: NSRect(x: 17, y: 156, width: 191, height: 17))
    JamfPolicyDeleter.title = "JamfPolicyDeleter"
    JamfPolicyDeleter.bezelStyle = NSButton.BezelStyle.inline
    JamfPolicyDeleter.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfPolicyDeleter.isBordered = true
    JamfPolicyDeleter.font = .boldSystemFont(ofSize: 11)
    JamfPolicyDeleter.toolTip = "Delete a policy from Jamf"
    JamfPolicyDeleter.action = #selector(appDelegate().JamfPolicyDeleterAction)
appDelegate().processorsView3rdParty.addSubview(JamfPolicyDeleter)
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

func createButtonJamfPolicyLogFlusher () {
let JamfPolicyLogFlusher = NSButton(frame: NSRect(x: 17, y: 135, width: 191, height: 17))
    JamfPolicyLogFlusher.title = "JamfPolicyLogFlusher"
    JamfPolicyLogFlusher.bezelStyle = NSButton.BezelStyle.inline
    JamfPolicyLogFlusher.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfPolicyLogFlusher.isBordered = true
    JamfPolicyLogFlusher.font = .boldSystemFont(ofSize: 11)
    JamfPolicyLogFlusher.toolTip = "Flush a policy log from Jamf"
    JamfPolicyLogFlusher.action = #selector(appDelegate().JamfPolicyLogFlusherAction)
appDelegate().processorsView3rdParty.addSubview(JamfPolicyLogFlusher)
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

func createButtonJamfPolicyUploader () {
let JamfPolicyUploader = NSButton(frame: NSRect(x: 17, y: 114, width: 191, height: 17))
    JamfPolicyUploader.title = "JamfPolicyUploader"
    JamfPolicyUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfPolicyUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfPolicyUploader.isBordered = true
    JamfPolicyUploader.font = .boldSystemFont(ofSize: 11)
    JamfPolicyUploader.toolTip = "Upload a policy to Jamf"
    JamfPolicyUploader.action = #selector(appDelegate().JamfPolicyUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfPolicyUploader)
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

func createButtonJamfScriptUploader () {
let JamfScriptUploader = NSButton(frame: NSRect(x: 17, y: 93, width: 191, height: 17))
    JamfScriptUploader.title = "JamfScriptUploader"
    JamfScriptUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfScriptUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfScriptUploader.isBordered = true
    JamfScriptUploader.font = .boldSystemFont(ofSize: 11)
    JamfScriptUploader.toolTip = "Upload a script to Jamf"
    JamfScriptUploader.action = #selector(appDelegate().JamfScriptUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfScriptUploader)
}

func JamfScriptUploader () {
    output = """
<dict>
    <key>Arguments</key>
    <dict>
        <key>script_path</key>
        <string>/pat/to/script.sh</string>
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

func createButtonJamfSoftwareRestrictionUploader () {
let JamfSoftwareRestrictionUploader = NSButton(frame: NSRect(x: 17, y: 72, width: 191, height: 17))
    JamfSoftwareRestrictionUploader.title = "JamfSoftwareRestrictionUploader"
    JamfSoftwareRestrictionUploader.bezelStyle = NSButton.BezelStyle.inline
    JamfSoftwareRestrictionUploader.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfSoftwareRestrictionUploader.isBordered = true
    JamfSoftwareRestrictionUploader.font = .boldSystemFont(ofSize: 11)
    JamfSoftwareRestrictionUploader.toolTip = "Upload a software restriction to Jamf"
    JamfSoftwareRestrictionUploader.action = #selector(appDelegate().JamfSoftwareRestrictionUploaderAction)
appDelegate().processorsView3rdParty.addSubview(JamfSoftwareRestrictionUploader)
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

func createButtonJamfUploaderSlacker () {
let JamfUploaderSlacker = NSButton(frame: NSRect(x: 17, y: 51, width: 191, height: 17))
    JamfUploaderSlacker.title = "JamfUploaderSlacker"
    JamfUploaderSlacker.bezelStyle = NSButton.BezelStyle.inline
    JamfUploaderSlacker.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfUploaderSlacker.isBordered = true
    JamfUploaderSlacker.font = .boldSystemFont(ofSize: 11)
    JamfUploaderSlacker.toolTip = "Postprocessor for AutoPkg that will send details about a recipe run to a Slack webhook"
    JamfUploaderSlacker.action = #selector(appDelegate().JamfUploaderSlackerAction)
appDelegate().processorsView3rdParty.addSubview(JamfUploaderSlacker)
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

func createButtonJamfUploaderTeamsNotifier () {
let JamfUploaderTeamsNotifier = NSButton(frame: NSRect(x: 17, y: 30, width: 191, height: 17))
    JamfUploaderTeamsNotifier.title = "JamfUploaderTeamsNotifier"
    JamfUploaderTeamsNotifier.bezelStyle = NSButton.BezelStyle.inline
    JamfUploaderTeamsNotifier.setButtonType(NSButton.ButtonType.momentaryPushIn)
    JamfUploaderTeamsNotifier.isBordered = true
    JamfUploaderTeamsNotifier.font = .boldSystemFont(ofSize: 11)
    JamfUploaderTeamsNotifier.toolTip = "Postprocessor for AutoPkg that will send details about a recipe run to a Microsoft Teams webhook"
    JamfUploaderTeamsNotifier.action = #selector(appDelegate().JamfUploaderTeamsNotifierAction)
appDelegate().processorsView3rdParty.addSubview(JamfUploaderTeamsNotifier)
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
