import Foundation
import Yams
import AppKit


// Function to parse XML into Dictionary
func xmlToDictionary(xmlString: String) -> [String: Any]? {
    guard let data = xmlString.data(using: .utf8) else {
        print("Error converting XML string to Data")
        outputToLogView(logString: "⚠️ Error converting XML string to Data\n")
        return nil
    }

    do {
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        if var dictionary = plist as? [String: Any] {
            // Handle Process array
            if let processArray = dictionary["Process"] as? [[String: Any]] {
                let modifiedProcessArray = processArray.map { processStep -> [String: Any] in
                    var modifiedStep = processStep
                    
                    // Only create Arguments if there's a Comment or if Arguments already exists
                    if let comment = modifiedStep["Comment"] as? String {
                        var arguments = modifiedStep["Arguments"] as? [String: Any] ?? [:]
                        arguments["Comment"] = comment
                        modifiedStep["Arguments"] = arguments
                        modifiedStep.removeValue(forKey: "Comment")
                    }
                    
                    return modifiedStep
                }
                dictionary["Process"] = modifiedProcessArray
            }
            return dictionary
        } else {
            print("Error: Expected dictionary but got something else")
            outputToLogView(logString: "⚠️ Error: Expected dictionary but got something else\n")
            return nil
        }
    } catch {
        print("Error parsing XML: \(error)")
        outputToLogView(logString: "⚠️ Error parsing XML: \(error)\n")
        return nil
    }
}


// Function to sanitize values for YAML compatibility
func sanitizeValueForYAML(_ value: Any, key: String? = nil) -> Any {
    if let number = value as? NSNumber {
        if number === kCFBooleanTrue || number === kCFBooleanFalse {
            return number.boolValue
        } else {
            return number.intValue
        }
    } else if let string = value as? String {
        let nameOfKey = key ?? ""

        // Sub function check if string most likely are a regex
        func isLikelyRegex(_ string: String) -> Bool {
            let regexIndicators = ["[", "]", "(", ")", "{", "}", "\\", ".", "+", "*", "?", "^", "$", "|"]
            return regexIndicators.contains { string.contains($0) }
        }

        // Single quote all regex
        if (nameOfKey == "re_pattern" || nameOfKey == "asset_regex") && isLikelyRegex(string) &&
            !(string.hasPrefix("'") && !string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) && !string.contains("'") {
            return "'\(string)'"
        }

        // Sub function check if string only number
        func onlyNumbers(_ string: String) -> Bool {
            return string.range(of: "^[0-9]+$", options: .regularExpression) != nil
        }

        // Single quote all numbers
        if onlyNumbers(string) &&
            !(string.hasPrefix("'") && string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) {
            return "'\(string)'"
        }

        // Single quote if requirement contains :
        if nameOfKey == "requirement" && string.contains(":") &&
            !(string.hasPrefix("'") && string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) {
            return "'\(string)'"
        }

        // Single quote if Developer ID Installer:
        if string.contains("Developer ID Installer:") &&
            !(string.hasPrefix("'") && string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) {
            return "'\(string)'"
        }

        // Single quote if empty string and key find
        if nameOfKey == "find" && string == " " || string == ":" &&
            !(string.hasPrefix("'") && string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) {
            return "'\(string)'"
        }
        
        // Single quote if empty string
        if string.isEmpty &&
            !(string.hasPrefix("'") && string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) {
            return "'\(string)'"
        }

        // Single quote if key is split_on
        if nameOfKey == "split_on" &&
            !(string.hasPrefix("'") && string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) {
            return "'\(string)'"
        }

        // If not key is 'requirement' single quote
        if nameOfKey != "requirement" && string.contains("%") &&
            !(string.hasPrefix("'") && string.hasSuffix("'") && !string.dropFirst().dropLast().contains("'")) &&
            !(string.hasPrefix("\"") && string.hasSuffix("\"") && !string.dropFirst().dropLast().contains("\"")) &&
            !(string.hasPrefix("(") && string.hasSuffix(")") && !string.dropFirst().dropLast().contains("()")) &&
            !string.contains("\n") && !string.contains("\r") {
            return "'\(string)'"
        }
        
        // Cleanup any warning messages or Comments messages
        if nameOfKey == "warning_message" || nameOfKey == "Comment" || nameOfKey == "comment" {
            let sanitizedString = string
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                .replacingOccurrences(of: ": ", with: " ", options: .regularExpression)
                .replacingOccurrences(of: "\"", with: "", options: .regularExpression)
            return sanitizedString
        }

        /* Warn if string contains : - Seems not needed
        if string.contains(":") &&
            !string.hasPrefix("\"") && !string.hasSuffix("\"") &&
            !string.hasPrefix("'") && !string.hasSuffix("'") &&
            !string.hasPrefix("(") && !string.hasSuffix(")") &&
            !string.contains("://") {
            outputToLogView(logString: "⚠️ String(s) contains : might need to be single quoted:\n")
            outputToLogView(logString: "\(string)\n")
        }

        // Warn if string contains "
        if string.contains("\"") &&
            !(string.hasPrefix("\"") && string.hasSuffix("\"")) &&
            !(string.hasPrefix("'") && string.hasSuffix("'")) {
            outputToLogView(logString: "⚠️ String(s) contains double quotes but may not be properly enclosed:\n")
            outputToLogView(logString: "\(string)\n")
        }
         */
       
        // If Codesignature values are empty, we set a empty requried array value []
        if (nameOfKey == "expected_authority_names" || nameOfKey == "codesign_additional_arguments") && string.isEmpty {
            outputToLogView(logString: "⚠️ Key '\(key!)' has an empty value, inserting default empty array []\n")
            return "[]"
        }

        // Fix multiline Description
        if nameOfKey == "Description" && (string.contains("\n") || string.contains("\r")) && !string.hasPrefix("    ") {
            let indentedString = string.split(separator: "\n").map { line in
                return "    \(line.trimmingCharacters(in: .whitespaces))"
            }.joined(separator: "\n")
            return indentedString
        }

        // Fix multiline file_content
        if nameOfKey == "file_content" || nameOfKey == "installcheck_script" || nameOfKey == "uninstall_script" || nameOfKey == "additional_install_actions" || nameOfKey == "postinstall_script" || nameOfKey == "postuninstall_script"{
            // Check if the first line starts with "|"
            let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedString.hasPrefix("|") {
                // Add "|" only if it doesn't already exist
                let lines = string.split(separator: "\n", omittingEmptySubsequences: false)
                let updatedString = "|" + (lines.isEmpty ? "" : "\n") + lines.map { "          \($0)" }.joined(separator: "\n")
                return updatedString
            } else if !string.hasPrefix("|") {
                // Ensure the first line starts with exactly " |"
                let lines = string.split(separator: "\n", omittingEmptySubsequences: false)
                let updatedString = "|" + (lines.count > 1 ? "\n" : "") + lines.dropFirst().map { "          \($0)" }.joined(separator: "\n")
                return updatedString
            }
        }
        
        return string
    } else if let array = value as? [Any] {
        // If arrays is empty
        if array.isEmpty {
            outputToLogView(logString: "⚠️ Key '\(key ?? "")' contains an empty array, ensuring default empty array []\n")
            return "[]" // Replace with default empty array
        }
        // End arrays is empty
        return array.map { sanitizeValueForYAML($0, key: key) }
    } else if value is NSNull {
        return ""
    } else if let dict = value as? [String: Any] {
        if dict.isEmpty {
            return "{}"
        }
        return sanitizeDictionaryForYAML(dict)
    } else {
        return "\(value)"
    }
}


// Function to reorder the keys in a Process dictionary
func reorderProcessKeys(_ processStep: [String: Any]) -> [String: Any] {
    var orderedStep = [String: Any]()
    
    // Always put Processor first
    if let processor = processStep["Processor"] {
        orderedStep["Processor"] = processor
    }
    
    // Only include Arguments if it exists and is not empty
    if let arguments = processStep["Arguments"] as? [String: Any], !arguments.isEmpty {
        orderedStep["Arguments"] = arguments
    }
    
    return orderedStep
}


// Function to sanitize and reorder the Process section for YAML
func formatProcessForYAML(dictionary: [String: Any]) -> [String: Any] {
    var modifiedDict = dictionary
    if let processArray = dictionary["Process"] as? [[String: Any]] {
        let formattedProcessArray = processArray.map { processStep -> [String: Any] in
            var sanitizedStep = sanitizeDictionaryForYAML(processStep)
            
            // Move any remaining Comments to Arguments
            if let comment = sanitizedStep["Comment"] as? String {
                var arguments = sanitizedStep["Arguments"] as? [String: Any] ?? [:]
                arguments["Comment"] = comment
                sanitizedStep["Arguments"] = arguments
                sanitizedStep.removeValue(forKey: "Comment")
            }
            
            // Remove Arguments if it's empty
            if let arguments = sanitizedStep["Arguments"] as? [String: Any], arguments.isEmpty {
                sanitizedStep.removeValue(forKey: "Arguments")
            }
            
            return reorderProcessKeys(sanitizedStep)
        }
        modifiedDict["Process"] = formattedProcessArray
    }
    return sanitizeDictionaryForYAML(modifiedDict)
}


// Function to sanitize an entire dictionary
func sanitizeDictionaryForYAML(_ dictionary: [String: Any]) -> [String: Any] {
    var sanitizedDict = [String: Any]()
    for (key, value) in dictionary {
        if let dictValue = value as? [String: Any] {
            sanitizedDict[key] = sanitizeDictionaryForYAML(dictValue)
        } else if let arrayValue = value as? [Any] {
            if arrayValue.isEmpty {
                outputToLogView(logString: "⚠️ Key '\(key)' contains an empty array, ensuring default empty array []\n")
                sanitizedDict[key] = [] // Replace with default empty array
            } else {
                sanitizedDict[key] = arrayValue.map { sanitizeValueForYAML($0, key: key) }
            }
        } else {
            sanitizedDict[key] = sanitizeValueForYAML(value, key: key)
        }
    }
    return sanitizedDict
}


// Custom function to convert Dictionary to YAML with specific key order
func dictionaryToOrderedYAML(dict: [String: Any]) -> String? {
    do {
        var yamlString = ""
       
        // Ensure these keys come first
        let orderedKeys = ["Comment", "Description", "Identifier", "ParentRecipe", "MinimumVersion", "Input"]

        for key in orderedKeys {
            if let value = dict[key], !(value is String && (value as! String).isEmpty) {
                if key == "Description", let descriptionValue = value as? String {
                    if descriptionValue.contains("\n") || descriptionValue.contains("\r") && !descriptionValue.contains(":") {
                        let descriptionValuetrimmed = descriptionValue.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        yamlString += "\(key): |\n\(descriptionValuetrimmed)\n"
                    } else {
                        let yamlFragment = try Yams.dump(object: [key: value])
                        yamlString += yamlFragment
                    }
                } else {
                    let yamlFragment = try Yams.dump(object: [key: value])
                    yamlString += yamlFragment.replacingOccurrences(of: "'''", with: "'")
                }
            }
        }

        // Add newline before Input section if it exists
        if yamlString.contains("Input:") {
            yamlString = yamlString.replacingOccurrences(of: "Input:", with: "\nInput:")
        }

        // Handle the Process key separately to ensure it comes last
        var processString = "\nProcess:\n"
        if let processArray = dict["Process"] as? [[String: Any]] {
            for processStep in processArray {
                if let processor = processStep["Processor"] as? String {
                    processString += "- Processor: \(processor)\n"
                }
              
                if let arguments = processStep["Arguments"] as? [String: Any] {
                    processString += "  Arguments:\n"
                    for (argKey, argValue) in arguments {
                        let sanitizedValue = sanitizeValueForYAML(argValue, key: argKey)
                        if argKey == "pkginfo", let pkginfoDict = argValue as? [String: Any] {
                            // Special handling for pkginfo section
                            processString += "    pkginfo:\n"
                            processString += formatPkginfoSection(pkginfoDict, indent: 6)
                        } else if let arrayValue = sanitizedValue as? [Any] {
                            processString += "    \(argKey):\n"
                            if arrayValue.isEmpty {
                                processString += "      []\n"
                            } else {
                                for item in arrayValue {
                                    if let str = item as? String {
                                        processString += "      - \(str)\n"
                                    } else if let nestedDict = item as? [String: Any] {
                                        processString += "      -\n"
                                        for (nestedKey, nestedValue) in nestedDict {
                                            processString += "        \(nestedKey): \(nestedValue)\n"
                                        }
                                    }
                                }
                            }
                        } else if let dictValue = sanitizedValue as? [String: Any] {
                            if dictValue.isEmpty {
                                processString += "    \(argKey): {}\n"
                            } else {
                                processString += "    \(argKey):\n"
                                for (dictKey, dictItem) in dictValue {
                                    if let nestedArray = dictItem as? [[String: Any]] {
                                        processString += "      \(dictKey):\n"
                                        if nestedArray.isEmpty {
                                            processString += "        []\n"
                                        } else {
                                            for item in nestedArray {
                                                processString += "        -\n"
                                                for (k, v) in item {
                                                    processString += "          \(k): \(v)\n"
                                                }
                                            }
                                        }
                                    } else {
                                        processString += "      \(dictKey): \(dictItem)\n"
                                    }
                                }
                            }
                        } else {
                            processString += "    \(argKey): \(sanitizedValue)\n"
                        }
                    }
                }
                processString += "\n"
            }
        } else {
            processString += "  []"
        }

        // Add any remaining keys that were not explicitly handled
        for (key, value) in dict {
            if !orderedKeys.contains(key) && key != "Process" && key != "TopComment" && !(value is String && (value as! String).isEmpty) {
                let yamlFragment = try Yams.dump(object: [key: value])
                yamlString += yamlFragment
            }
        }

        // Append the Process section at the end
        yamlString += processString

        return yamlString
    } catch {
        print("Error converting Dictionary to YAML: \(error)")
        outputToLogView(logString: "⚠️ Error converting Dictionary to YAML: \(error)\n")
        return nil
    }
}

// Helper function to format pkginfo sections
func formatPkginfoSection(_ pkginfo: [String: Any], indent: Int) -> String {
    var result = ""
    let indentStr = String(repeating: " ", count: indent)
    
    // Define the order of keys we want to process first
    let orderedKeys = ["name", "display_name", "description", "version", "catalogs", "category", "developer"]
    
    // Process ordered keys first
    for key in orderedKeys {
        if let value = pkginfo[key] {
            if let arrayValue = value as? [Any] {
                result += "\(indentStr)\(key):\n"
                if arrayValue.isEmpty {
                    result += "\(indentStr)  []\n"
                } else {
                    for item in arrayValue {
                        result += "\(indentStr)  - \(item)\n"
                    }
                }
            } else {
                result += "\(indentStr)\(key): \(value)\n"
            }
        }
    }
    
    // Process remaining keys
    for (key, value) in pkginfo {
        if !orderedKeys.contains(key) {
            if let arrayValue = value as? [Any] {
                result += "\(indentStr)\(key):\n"
                if arrayValue.isEmpty {
                    result += "\(indentStr)  []\n"
                } else {
                    for item in arrayValue {
                        result += "\(indentStr)  - \(item)\n"
                    }
                }
            } else {
                result += "\(indentStr)\(key): \(value)\n"
            }
        }
    }
    
    return result
}


// Function to process XML and output YAML
func xmlToFormattedYAML(xmlString: String) -> String? {
    guard let dictionary = xmlToDictionary(xmlString: xmlString) else {
        return nil
    }
    let formattedDict = formatProcessForYAML(dictionary: dictionary)
    return dictionaryToOrderedYAML(dict: formattedDict)
}


// Function to clean some remaining nested arrays
func cleanRemainingArrays(_ yamlString: String) -> String {
    let targetPatterns = [
        "catalogs:",
        "supported_architectures:",
        "requires:",
        "update_for:"
    ]
    
    let lines = yamlString.split(separator: "\n", omittingEmptySubsequences: false)
    var processedLines = [String]()

    for line in lines {
        var updatedLine = String(line)
        
        // Check if the line matches any of the target patterns
        if targetPatterns.contains(where: { updatedLine.trimmingCharacters(in: .whitespaces).hasPrefix($0) }) {
            // Remove escaped single quotes and create Yaml Array
            updatedLine = updatedLine.replacingOccurrences(of: "\\'", with: "")
            updatedLine = updatedLine.replacingOccurrences(of: "[", with: "\n      - ")
            updatedLine = updatedLine.replacingOccurrences(of: "]", with: "")
        }
        
        processedLines.append(updatedLine)
    }

    return processedLines.joined(separator: "\n")
}

// Main function to convert XML to YAML and output to UI
func XMLtoYaml() {
    let wholeDocument = (appDelegate().outputTextField.textStorage as NSAttributedString?)!.string
    if wholeDocument.isEmpty { return }

    // Clear Set of error message
    loggedMessages.removeAll()

    if var yamlOutput = xmlToFormattedYAML(xmlString: wholeDocument) {
        /*/ Ensure Process header exists even if empty
        if !yamlOutput.contains("Process:") {
            yamlOutput += "\nProcess:  []\n"
        }
        */
        
        // Workaround for some nested arrays that not get "real" YAML format
        yamlOutput = cleanRemainingArrays(yamlOutput)
       
        appDelegate().outputTextField.string = ""
        highlightr!.setTheme(to: "xcode")
        highlightr!.theme.codeFont = NSFont(name: "Menlo", size: 12)
        let highlightedCode = highlightr!.highlight(yamlOutput, as: "yaml")!
        appDelegate().outputTextField.textStorage?.insert(highlightedCode, at: 0)

        // Function to highlight logged messages in the text field
        func highlightLoggedMessages() {
            // Convert Set<String> to Array<String>
            let loggedMessagesArray = Array(loggedMessages)

            // Get the entire text in the NSTextView
            guard let wholeDocument = appDelegate().outputTextField.string as NSString? else { return }

            // Iterate over each logged message and apply the highlighting
            for string in loggedMessagesArray {
                let range = wholeDocument.range(of: string)

                // Ensure the identifier exists in the text
                if range.location != NSNotFound {
                    // Replace the matched text with attributed text
                    let attributedReplaceText = NSAttributedString(string: string, attributes: yellowBackgroundAttributes)
                    appDelegate().outputTextField.textStorage?.replaceCharacters(in: range, with: attributedReplaceText)
                }
            }
        }

        // Highlight the logged messages in the text view
        highlightLoggedMessages()

        // If we run multiple then we need a check for this
        if loggedMessages.isEmpty {
            outputToLogView(logString: "✅ No problems found\n")
        }
    }
}
