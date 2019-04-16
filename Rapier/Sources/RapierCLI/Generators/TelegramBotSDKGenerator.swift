import Foundation
import Rapier

private struct Context {
    let directory: String
    
    var outTypes: String = ""
    var outMethods: String = ""
    
    init(directory: String) {
        self.directory = directory
    }
}

class TelegramBotSDKGenerator: CodeGenerator {
    required init(directory: String) {
        self.context = Context(directory: directory)
    }
    
    func start() throws {
        
    }
    
    func beforeGeneratingTypes() throws {
        context.outTypes.append("// This file is automatically generated by Rapier\n\n")
    }
    
    func generateType(name: String, info: TypeInfo) throws {
        context.outTypes.append("""
            public struct \(name): JsonConvertible, InternalJsonConvertible {
                /// Original JSON for fields not yet added to Swift structures.
                public var json: Any {
                    get { return internalJson.object }
                    set { internalJson = JSON(newValue) }
                }
                internal var internalJson: JSON
            
            """)
        var allInitParams: [String] = []
        info.fields.sorted { $0.key < $1.key }.forEach { fieldName, fieldInfo in
            let getterName = makeGetterName(typeName: name, fieldName: fieldName, fieldType: fieldInfo.type).camelized(firstLower: true)
            //if let initParams = makeInitParams(fieldName: fieldName, fieldInfo: fieldInfo) {
            //    allInitParams.append(initParams)
            //}
        }
        let initParamsString = allInitParams.joined(separator: ", ")
        context.outTypes.append("""
            internal init(internalJson: JSON = \(initParamsString)) {
                self.internalJson = internalJson
            }
            public init(json: Any) {
                self.internalJson = JSON(json)
            }
            public init(data: Data) {
                self.internalJson = JSON(data: data)
            }
        }
        """)
    }
    
    func afterGeneratingTypes() throws {
    }
    
    func beforeGeneratingMethods() throws {
        let methodsHeader = """
        // This file is automatically generated by Rapier


        import Foundation
        import Dispatch

        public extension TelegramBot {


        """
        
        context.outMethods.append(methodsHeader)
    }
    
    func generateMethod(name: String, info: MethodInfo) throws {
        
        let parameters = info.parameters.sorted { $0.key < $1.key }
        
        let fields: [String] = parameters.map { fieldName, fieldInfo in
            var result = "\(fieldName.camelized(firstLower: true)): \(buildSwiftType(fieldInfo: fieldInfo))"
            if fieldInfo.isOptional {
                result.append(" = nil")
            }
            
            return result
        }
        
        let arrayFields: [String] = parameters.map { fieldName, _ in
            return #""\#(fieldName)": \#(fieldName.camelized(firstLower: true))"#
        }
        
        let fieldsString = fields.joined(separator: ",\n        ")
        let arrayFieldsString = arrayFields.joined(separator: ",\n")
        
        let completionName = (name.first?.uppercased() ?? "") + name.dropFirst() + "Completion"
        let resultSwiftType = buildSwiftType(fieldInfo: info.result)
        
        let method = """
            typealias \(completionName) = (_ result: \(resultSwiftType), _ error: DataTaskError?) -> ()
        
            @discardableResult
            public func \(name)Sync(
                    \(fieldsString),
                    _ parameters: [String: Any?] = [:]) -> Bool? {
                return requestSync("addStickerToSet", defaultParameters["addStickerToSet"], parameters, [
                    \(arrayFieldsString)])
            }

            public func \(name)Async(
                    \(fieldsString)
                    _ parameters: [String: Any?] = [:],
                    queue: DispatchQueue = .main,
                    completion: \(completionName)? = nil) {
                return requestAsync("addStickerToSet", defaultParameters["addStickerToSet"], parameters, [
                    \(arrayFieldsString)],
                    queue: queue, completion: completion)
            }
        
        """
        
        context.outMethods.append(method)
    }
    
    func afterGeneratingMethods() throws {
        context.outMethods.append("\n}\n")
    }
    
    func finish() throws {
        try saveTypes()
        try saveMethods()
    }
    
    private func saveTypes() throws {
        let dir = URL(fileURLWithPath: context.directory, isDirectory: true)
        let file = dir.appendingPathComponent("types.swift", isDirectory: false)
        try context.outTypes.write(to: file, atomically: true, encoding: .utf8)
    }
    
    private func saveMethods() throws {
        let dir = URL(fileURLWithPath: context.directory, isDirectory: true)
        let file = dir.appendingPathComponent("methods.swift", isDirectory: false)
        try context.outMethods.write(to: file, atomically: true, encoding: .utf8)
    }
    
    private func buildSwiftType(fieldInfo: FieldInfo) -> String {
        var type: String
        if (fieldInfo.isArray) {
            type = "[\(fieldInfo.type)]"
        } else {
            type = fieldInfo.type
        }
        if (fieldInfo.isOptional) {
            type.append("?")
        }
        return type
    }
    
    private var context: Context
}

extension TelegramBotSDKGenerator {
    private func makeGetterName(typeName: String, fieldName: String, fieldType: String) -> String {
        switch (typeName, fieldName) {
        case ("ChatMember", "status"):
            return "status_string"
        default:
            if fieldName == "type" && fieldType == "String" {
                return "type_string"
                
            }
            if fieldName == "parse_mode" && fieldType == "String" {
                return "parse_mode_string"
            }
            break
        }
        return fieldName
    }
}

//    private func makeInitParams(fieldName: String, fieldInfo) -> String? {
//        switch (varType, isOptional) {
//        case ("Bool", true): return "\(fieldName) = true"
//        case ("Bool", false): return "\(fieldName) = false"
//        }
//    }
//

extension String {
    fileprivate func camelized(firstLower: Bool) -> String {
        let components = self.components(separatedBy: "_")
        
        let firstLowercasedWord: String?
        if firstLower {
            firstLowercasedWord = components.first?.lowercased()
        } else {
            let firstComponent = components.first ?? ""
            firstLowercasedWord = firstComponent.prefix(1).uppercased() + firstComponent.dropFirst().lowercased()
        }
        
        let remainingWords = components.dropFirst().map {
            $0.prefix(1).uppercased() + $0.dropFirst().lowercased()
        }
        return ([firstLowercasedWord].compactMap{ $0 } + remainingWords).joined()
    }
}
