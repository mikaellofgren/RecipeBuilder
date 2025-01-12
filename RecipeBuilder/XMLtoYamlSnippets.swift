import Foundation
import Yams
import AppKit

// Snippets functions
// Function to convert XML snippet to Dictionary
func xmlSnippetToDictionary(xmlString: String) -> [String: Any]? {
    guard let data = xmlString.data(using: .utf8) else {
        print("Error converting XML string to Data")
        outputToLogView (logString: "\n⚠️ Error converting XML string to Data\n")
        return nil
    }

    do {
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        if let dictionary = plist as? [String: Any] {
            return dictionary
        } else {
            print("Error: Expected dictionary but got something else")
            outputToLogView (logString: "\n⚠️ Error: Expected dictionary but got something else\n")
            return nil
        }
    } catch {
        print("Error parsing XML: \(error)")
        outputToLogView (logString: "\n⚠️ Error parsing XML: \(error)\n")
        return nil
    }
}

// Function to make dictionary values YAML-compatible
func makeYAMLCompatibleSnippet(_ value: Any) -> Any {
    if let dict = value as? [String: Any] {
        var yamlCompatibleDict = [String: Any]()
        for (key, value) in dict {
            yamlCompatibleDict[key] = makeYAMLCompatibleSnippet(value)
        }
        return yamlCompatibleDict
    } else if let array = value as? [Any] {
        return array.map { makeYAMLCompatibleSnippet($0) }
    } else {
        return String(describing: value)
    }
}

// Function to reorder the keys in the dictionary to ensure `Processor` comes first
func reorderProcessKeysSnippet(_ processStep: [String: Any]) -> [String: Any] {
    var orderedStep = [String: Any]()
    // Ensure Processor comes first
    if let processor = processStep["Processor"] as? String {
        orderedStep["Processor"] = processor
    }
    // Then Arguments
    if let arguments = processStep["Arguments"] as? [String: Any] {
        orderedStep["Arguments"] = arguments
    }
    // Add any other keys
    for (key, value) in processStep where key != "Processor" && key != "Arguments" {
        orderedStep[key] = value
    }
    return orderedStep
}

// Custom function to convert Dictionary to Ordered YAML
func dictionaryToOrderedYAMLSnippet(dict: [String: Any]) -> String {
    var yamlString = ""

    // Ensure Processor comes first
    if let processor = dict["Processor"] {
        let yamlFragment = (try? Yams.dump(object: ["Processor": processor])) ?? ""
        yamlString += yamlFragment
    }

    // Then Arguments
    if let arguments = dict["Arguments"] {
        let yamlFragment = (try? Yams.dump(object: ["Arguments": arguments])) ?? ""
        yamlString += yamlFragment
    }

    // Add any other keys
    for (key, value) in dict where key != "Processor" && key != "Arguments" {
        let yamlFragment = (try? Yams.dump(object: [key: value])) ?? ""
        yamlString += yamlFragment
    }

    return yamlString
}

// Function to convert XML `<dict>` snippet into a YAML list
func xmlDictSnippetToYAMLList(xmlSnippet: String) -> String? {
    guard let parsedDict = xmlSnippetToDictionary(xmlString: xmlSnippet) else {
        return nil
    }

    // Reorder the parsed dictionary to ensure `Processor` comes first
    let reorderedDict = reorderProcessKeysSnippet(parsedDict)

    // Wrap the dictionary in an array for YAML list formatting
    let yamlCompatibleObject = makeYAMLCompatibleSnippet([reorderedDict])

    if let list = yamlCompatibleObject as? [[String: Any]] {
        var yamlString = ""
        for item in list {
            let itemYAML = dictionaryToOrderedYAMLSnippet(dict: item)
            yamlString += "- " + itemYAML.replacingOccurrences(of: "\n", with: "\n  ").trimmingCharacters(in: .whitespacesAndNewlines) + "\n\n"
        }
        return yamlString
    }
    return nil
}

