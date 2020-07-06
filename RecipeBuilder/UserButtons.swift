//
//  Functions.swift
//  testButton
//
//  Created by Mikael Löfgren on 2020-07-04.
//  Copyright © 2020 Mikael Löfgren. All rights reserved.
//


import Cocoa
import AppKit
import Foundation


var allButtonsFolders = ""
let recipeBuilderButtonsFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support/RecipeBuilder/").path
var titleFileString = ""
var outputFileString = ""
var helpFileString = ""
var titleFile = URL(fileURLWithPath: "")
var outputFile = URL(fileURLWithPath: "")
var helpFile = URL(fileURLWithPath: "")
var title1 = ""
var output1 = ""
var help1 = ""

var title2 = ""
var output2 = ""
var help2 = ""

var title3 = ""
var output3 = ""
var help3 = ""

var title4 = ""
var output4 = ""
var help4 = ""

var title5 = ""
var output5 = ""
var help5 = ""

var title6 = ""
var output6 = ""
var help6 = ""

var title7 = ""
var output7 = ""
var help7 = ""

var title8 = ""
var output8 = ""
var help8 = ""

var title9 = ""
var output9 = ""
var help9 = ""

var title10 = ""
var output10 = ""
var help10 = ""

func createButton1 (title: String) {
let button1 = NSButton(frame: NSRect(x: 17, y: 255, width: 195, height: 17))
button1.title = title
button1.bezelStyle = NSButton.BezelStyle.inline
button1.setButtonType(NSButton.ButtonType.momentaryPushIn)
button1.isBordered = true
button1.font = .boldSystemFont(ofSize: 11)
button1.action = #selector(appDelegate().buttonAction1)
appDelegate().buttonView.addSubview(button1)
}

func createButton2 (title: String) {
let button2 = NSButton(frame: NSRect(x: 17, y: 234, width: 195, height: 17))
button2.title = title
button2.bezelStyle = NSButton.BezelStyle.inline
button2.setButtonType(NSButton.ButtonType.momentaryPushIn)
button2.isBordered = true
button2.font = .boldSystemFont(ofSize: 11)
button2.action = #selector(appDelegate().buttonAction2)
appDelegate().buttonView.addSubview(button2)
}

func createButton3 (title: String) {
let button3 = NSButton(frame: NSRect(x: 17, y: 213, width: 195, height: 17))
button3.title = title
button3.bezelStyle = NSButton.BezelStyle.inline
button3.setButtonType(NSButton.ButtonType.momentaryPushIn)
button3.isBordered = true
button3.font = .boldSystemFont(ofSize: 11)
button3.action = #selector(appDelegate().buttonAction3)
appDelegate().buttonView.addSubview(button3)
}

func createButton4 (title: String) {
let button4 = NSButton(frame: NSRect(x: 17, y: 192, width: 195, height: 17))
button4.title = title
button4.bezelStyle = NSButton.BezelStyle.inline
button4.setButtonType(NSButton.ButtonType.momentaryPushIn)
button4.isBordered = true
button4.font = .boldSystemFont(ofSize: 11)
button4.action = #selector(appDelegate().buttonAction4)
appDelegate().buttonView.addSubview(button4)
}

func createButton5 (title: String) {
let button5 = NSButton(frame: NSRect(x: 17, y: 171, width: 195, height: 17))
button5.title = title
button5.bezelStyle = NSButton.BezelStyle.inline
button5.setButtonType(NSButton.ButtonType.momentaryPushIn)
button5.isBordered = true
button5.font = .boldSystemFont(ofSize: 11)
button5.action = #selector(appDelegate().buttonAction5)
appDelegate().buttonView.addSubview(button5)
}

func createButton6 (title: String) {
let button6 = NSButton(frame: NSRect(x: 17, y: 150, width: 195, height: 17))
button6.title = title
button6.bezelStyle = NSButton.BezelStyle.inline
button6.setButtonType(NSButton.ButtonType.momentaryPushIn)
button6.isBordered = true
button6.font = .boldSystemFont(ofSize: 11)
button6.action = #selector(appDelegate().buttonAction6)
appDelegate().buttonView.addSubview(button6)
}

func createButton7 (title: String) {
let button7 = NSButton(frame: NSRect(x: 17, y: 129, width: 195, height: 17))
button7.title = title
button7.bezelStyle = NSButton.BezelStyle.inline
button7.setButtonType(NSButton.ButtonType.momentaryPushIn)
button7.isBordered = true
button7.font = .boldSystemFont(ofSize: 11)
button7.action = #selector(appDelegate().buttonAction7)
    appDelegate().buttonView.addSubview(button7)
}

func createButton8 (title: String) {
let button8 = NSButton(frame: NSRect(x: 17, y: 108, width: 195, height: 17))
button8.title = title
button8.bezelStyle = NSButton.BezelStyle.inline
button8.setButtonType(NSButton.ButtonType.momentaryPushIn)
button8.isBordered = true
button8.font = .boldSystemFont(ofSize: 11)
button8.action = #selector(appDelegate().buttonAction8)
appDelegate().buttonView.addSubview(button8)
}

func createButton9 (title: String) {
let button9 = NSButton(frame: NSRect(x: 17, y: 87, width: 195, height: 17))
button9.title = title
button9.bezelStyle = NSButton.BezelStyle.inline
button9.setButtonType(NSButton.ButtonType.momentaryPushIn)
button9.isBordered = true
button9.font = .boldSystemFont(ofSize: 11)
button9.action = #selector(appDelegate().buttonAction9)
appDelegate().buttonView.addSubview(button9)
}

func createButton10 (title: String) {
let button10 = NSButton(frame: NSRect(x: 17, y: 66, width: 195, height: 17))
button10.title = title
button10.bezelStyle = NSButton.BezelStyle.inline
button10.setButtonType(NSButton.ButtonType.momentaryPushIn)
button10.isBordered = true
button10.font = .boldSystemFont(ofSize: 11)
button10.action = #selector(appDelegate().buttonAction10)
appDelegate().buttonView.addSubview(button10)
}


func buttonWarning (infomessage: String) {
let warning = NSAlert()
           warning.icon = NSImage(named: "Warning")
           warning.addButton(withTitle: "OK")
           warning.messageText = "Button is missing required info"
           warning.alertStyle = NSAlert.Style.warning
           warning.informativeText = """
           \(infomessage)
           """
           warning.runModal()
}

func checkForUserButtonsAndEnable () {
    titleFileString = "\(recipeBuilderButtonsFolder)/1/title.txt"
    outputFileString = "\(recipeBuilderButtonsFolder)/1/output.txt"
    helpFileString = "\(recipeBuilderButtonsFolder)/1/help.txt"
    
    // If folder one is missing file, dont enable
    if FileManager.default.fileExists(atPath: titleFileString ) && FileManager.default.fileExists(atPath: outputFileString ) {
        getAllUserButtons ()
    }
    
}


func openUserButtons () {
    if FileManager.default.fileExists(atPath: recipeBuilderButtonsFolder) {
          NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: recipeBuilderButtonsFolder)
       } else {
           return }
          appDelegate().fileOptions.selectItem(at: 0)
}



func getAllUserButtons () {
    
   if FileManager.default.fileExists(atPath: recipeBuilderButtonsFolder) {
    } else {
    do {
     try FileManager.default.createDirectory(atPath: recipeBuilderButtonsFolder, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print(error)
    }
    }
    
    if FileManager.default.fileExists(atPath: "\(recipeBuilderButtonsFolder)/1") {
    } else {
    do {
     try FileManager.default.createDirectory(atPath: "\(recipeBuilderButtonsFolder)/1", withIntermediateDirectories: true, attributes: nil)
        let writeTitle = "Insert empty key and string"
        let writeOutput = """
<key></key>
<string></string>
"""
        let writeHelp = """
Welcome to UserButtons!

In folder \"\(recipeBuilderButtonsFolder)\"
you create folders with name 1,2,3..up to 10. You can skip folders, but folder 1 is required if you
want buttons to autostart, otherwise you have to enable them.
In every folder create title.txt and add text to the file for the button name.
Keep it below 26 characters for best result.

Add output.txt for the output text.

And help.txt for the Note text your reading right now (optional).
To easy open \"\(recipeBuilderButtonsFolder)\", choose File options - Open user buttons folder
Click the Enable and reload button to create the first "demo" button.
Use that button to reload if you trying out your new buttons.
"""
        titleFile = URL(fileURLWithPath: "\(recipeBuilderButtonsFolder)/1/title.txt")
        outputFile = URL(fileURLWithPath: "\(recipeBuilderButtonsFolder)/1/output.txt")
        helpFile = URL(fileURLWithPath: "\(recipeBuilderButtonsFolder)/1/help.txt")
        try writeTitle.write(to: titleFile, atomically: true, encoding: String.Encoding.utf8)
        try writeOutput.write(to: outputFile, atomically: true, encoding: String.Encoding.utf8)
        try writeHelp.write(to: helpFile, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print(error)
    }
    }
   
    // Remove all the buttons and add them again if they exist
     for subview in appDelegate().buttonView.subviews {
         if subview is NSButton {
            subview.removeFromSuperview()
            appDelegate().buttonView.addSubview(appDelegate().enableAndReloadButton)
         }
     }
     
    
let documentsPath = recipeBuilderButtonsFolder
let url = URL(fileURLWithPath: documentsPath)
let fileManager = FileManager.default
let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: url.path)!
while let subFolders = enumerator.nextObject() as? String {
    
       let folderName = subFolders
       
      switch folderName {
            case let folderName where folderName == "1":
                titleFileString = "\(recipeBuilderButtonsFolder)/1/title.txt"
                outputFileString = "\(recipeBuilderButtonsFolder)/1/output.txt"
                helpFileString = "\(recipeBuilderButtonsFolder)/1/help.txt"
                titleFile = URL(fileURLWithPath: titleFileString)
                outputFile = URL(fileURLWithPath: outputFileString)
                helpFile = URL(fileURLWithPath: helpFileString)
                
                if FileManager.default.fileExists(atPath: titleFileString ) {
                    do {
                    let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                        if title != "" {
                        title1 = title
                        createButton1(title: title1)
                        } else {
                            buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                        }
                        } catch  {
                            print(error)
                        }
                }
                
                if FileManager.default.fileExists(atPath: outputFileString) {
                    do {
                    let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                        if output != "" {
                        output1 = output
                        } else {
                             buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                        }
                        } catch  {
                            print(error)
                        }
                }
                
                if FileManager.default.fileExists(atPath: helpFileString) {
                                   do {
                                   let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                      help1 = help
                                       } catch  {
                                           print(error)
                                       }
                               }
                
            
            case let folderName where folderName == "2":
                 titleFileString = "\(recipeBuilderButtonsFolder)/2/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/2/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/2/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title2 = title
                         createButton2(title: title2)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output2 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help2 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
            
            case let folderName where folderName == "3":
                 titleFileString = "\(recipeBuilderButtonsFolder)/3/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/3/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/3/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title3 = title
                         createButton3(title: title3)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output3 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help3 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
            
            case let folderName where folderName == "4":
                 titleFileString = "\(recipeBuilderButtonsFolder)/4/title.txt"
                                 outputFileString = "\(recipeBuilderButtonsFolder)/4/output.txt"
                                 helpFileString = "\(recipeBuilderButtonsFolder)/4/help.txt"
                                 titleFile = URL(fileURLWithPath: titleFileString)
                                 outputFile = URL(fileURLWithPath: outputFileString)
                                 helpFile = URL(fileURLWithPath: helpFileString)
                                 
                                 if FileManager.default.fileExists(atPath: titleFileString ) {
                                     do {
                                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                                         if title != "" {
                                         title4 = title
                                         createButton4(title: title4)
                                         } else {
                                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                                         }
                                         } catch  {
                                             print(error)
                                         }
                                 }
                                 
                                 if FileManager.default.fileExists(atPath: outputFileString) {
                                     do {
                                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                                         if output != "" {
                                         output4 = output
                                         } else {
                                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                                         }
                                         } catch  {
                                             print(error)
                                         }
                                 }
                                 
                                 if FileManager.default.fileExists(atPath: helpFileString) {
                                                    do {
                                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                                       help4 = help
                                                        } catch  {
                                                            print(error)
                                                        }
                                                }
           
            case let folderName where folderName == "5":
                 titleFileString = "\(recipeBuilderButtonsFolder)/5/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/5/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/5/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title5 = title
                         createButton5(title: title5)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output5 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help5 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
           
            case let folderName where folderName == "6":
                 titleFileString = "\(recipeBuilderButtonsFolder)/6/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/6/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/6/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title6 = title
                         createButton6(title: title6)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output6 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help6 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
            
            case let folderName where folderName == "7":
                 titleFileString = "\(recipeBuilderButtonsFolder)/7/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/7/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/7/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title7 = title
                         createButton7(title: title7)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output7 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help7 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
            
            case let folderName where folderName == "8":
                titleFileString = "\(recipeBuilderButtonsFolder)/8/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/8/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/8/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title8 = title
                         createButton8(title: title8)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output8 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help8 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
            
            case let folderName where folderName == "9":
                 titleFileString = "\(recipeBuilderButtonsFolder)/9/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/9/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/9/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title9 = title
                         createButton9(title: title9)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output9 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help9 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
           
            case let folderName where folderName == "10":
                titleFileString = "\(recipeBuilderButtonsFolder)/10/title.txt"
                 outputFileString = "\(recipeBuilderButtonsFolder)/10/output.txt"
                 helpFileString = "\(recipeBuilderButtonsFolder)/10/help.txt"
                 titleFile = URL(fileURLWithPath: titleFileString)
                 outputFile = URL(fileURLWithPath: outputFileString)
                 helpFile = URL(fileURLWithPath: helpFileString)
                 
                 if FileManager.default.fileExists(atPath: titleFileString ) {
                     do {
                     let title = try String(contentsOf: titleFile, encoding: String.Encoding.utf8)
                         if title != "" {
                         title10 = title
                         createButton10(title: title10)
                         } else {
                             buttonWarning (infomessage: "File: \"\(titleFileString)\" seems empty")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: outputFileString) {
                     do {
                     let output = try String(contentsOf: outputFile, encoding: String.Encoding.utf8)
                         if output != "" {
                         output10 = output
                         } else {
                              buttonWarning (infomessage: "File: \"\(outputFileString)\" seems empty.\nThis want output anything.")
                         }
                         } catch  {
                             print(error)
                         }
                 }
                 
                 if FileManager.default.fileExists(atPath: helpFileString) {
                                    do {
                                    let help = try String(contentsOf: helpFile, encoding: String.Encoding.utf8)
                                       help10 = help
                                        } catch  {
                                            print(error)
                                        }
                                }
                  default: break
          }
    }
   
}
