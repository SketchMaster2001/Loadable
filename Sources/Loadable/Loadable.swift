//
//  Loadable.swift
//  Loadable
//
//  Created by Noah Pistilli on 2021-12-13.
//

import Foundation

/// Loadable allows for data to be loaded into structs.
public protocol Loadable: Decodable {}

public extension Loadable {
    public func load<T: Decodable>(_ type: T.Type, data: Data, endianess: Endianess) throws -> T {
        // File pointer to keep state
        var pointer = 0
        var dict: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            let type = getType(value: child.value)
            
            // Integers
            if (type == "UInt8" || type == "Int8") {
                dict[child.label!] = readByte(data, at: pointer, endianess: endianess)
                pointer += 1
            }
            else if (type == "UInt16" || type == "Int16") {
                dict[child.label!] = readUint16(data, at: pointer, endianess: endianess)
                pointer += 2
            }
            else if (type == "UInt32" || type == "Int32") {
                dict[child.label!] = readUint32(data, at: pointer, endianess: endianess)
                pointer += 4
            }
            else if (type == "UInt64" || type == "Int64") {
                dict[child.label!] = readUint64(data, at: pointer, endianess: endianess)
                pointer += 8
            }
            
            // Byte Array
            // The array must be initalized for this to work as we need a size
            else if (type == "Array<UInt8>" || type == "Array<Int8>") {
                let object = child.value as AnyObject
                let size = object.count ?? 0
                
                if size == 0 {
                    throw Errors.emptyByteArray("The passed byte array has not be initialized with a size!")
                }
                
                dict[child.label!] = readBytes(data, length: size, at: pointer)
                pointer += size
            }
            else {
                // Everything else is incompatible and cannot be loaded into the struct.
                throw Errors.incompatibleDataType("Data type \(type) does not conform to Loadable!")
            }
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: dict)
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
    
    /// getType gets the data type for the specified value. It also strips the `Optional<T>` if the type is optional
    fileprivate func getType(value: Any) -> String {
        var dataType = String(describing: type(of: value))
        
        if dataType.contains("Optional") {
            dataType = dataType.replacingOccurrences(of: "Optional<", with: "")
            dataType.removeLast()
        }
        
        return dataType
    }
}
