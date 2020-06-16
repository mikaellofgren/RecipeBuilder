//
//  buttons.swift
//  autopkgRecipeBuilder
//
//  Created by Mikael Löfgren on 2020-04-24.
//  Copyright © 2020 Mikael Löfgren. All rights reserved.
//

import Cocoa
import AppKit
import Foundation
import Highlightr


// Create a subclass of AppDelegate
func appDelegate() -> AppDelegate {
      return NSApplication.shared.delegate as! AppDelegate
      }

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

    if downloadPath != "" {
        dialog.directoryURL = NSURL.fileURL(withPath: downloadPath, isDirectory: true)
    } else {
      
           if FileManager.default.fileExists(atPath: "/Applications") {
               dialog.directoryURL = NSURL.fileURL(withPath: "/Applications", isDirectory: true)
      }
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
    
    if downloadPath != "" {
           dialog.directoryURL = NSURL.fileURL(withPath: downloadPath, isDirectory: true)
       } else {
        let downloadsFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads").path
              if FileManager.default.fileExists(atPath: downloadsFolder) {
                  dialog.directoryURL = NSURL.fileURL(withPath: downloadsFolder, isDirectory: true)
         }
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
       let codeSignPkgArrayTemp = codeSignPkg.components(separatedBy: CharacterSet.newlines)
       if codeSignPkgArrayTemp.isEmpty {
           } else {
        codeSignPkg = codeSignPkgArrayTemp[3].replacingOccurrences(of: "1. ", with: "", options: [.regularExpression, .caseInsensitive])
       codeSignPkg = codeSignPkg.trimmingCharacters(in: .whitespacesAndNewlines)

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
            <string>%RECIPE_CACHE_DIR%/</string>
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
            <string>%pkgroot%/%NAME%.app/Contents/Info.plist</string>
            <key>output_plist_path</key>
            <string>%pkgroot%/%NAME%.app/Contents/Info.plist</string>
            <key>plist_data</key>
            <dict>
                <key></key>
                <string></string>
            </dict>
            <key>Processor</key>
            <string>PlistEditor</string>
        </dict>
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
    
  
