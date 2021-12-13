//
//  DataTypes.swift
//  Loadable
//
//  Created by Noah Pistilli on 2021-12-13.
//

import Foundation

public enum Endianess: Int {
    case bigEndian
    case littleEndian
}

/// Reads multiple bytes from a specified offset in data and returns them in a UInt8 array
/// - parameter data: Data object to read from
/// - parameter length: Amount of data to be read
/// - parameter position: Offset to data
func readBytes(_ data: Data, length: Int, at position: Int) -> [uint8] {
    let NSrange = NSRange(location: position, length: length)
    let range = Range(NSrange)!

    let bytes = data.subdata(in: range)

    return [uint8](bytes)
}

/// Reads a single byte from a specified offset in data
/// - parameter data: Data object to read from
/// - parameter position: Offset to data
func readByte(_ data: Data, at position: Int, endianess: Endianess) -> uint8 {
    let dataType = data.withUnsafeBytes { $0.load(fromByteOffset: position, as: uint8.self) }
    
    if endianess == .bigEndian {
        return dataType.bigEndian
    } else {
        return dataType.littleEndian
    }
}

/// Reads 2 bytes from a specified offset in data
/// - parameter data: Data object to read from
/// - parameter position: Offset to data
func readUint16(_ data: Data, at position: Int, endianess: Endianess) -> uint16 {
    let dataType = data.withUnsafeBytes { $0.load(fromByteOffset: position, as: uint16.self) }
    
    if endianess == .bigEndian {
        return dataType.bigEndian
    } else {
        return dataType.littleEndian
    }
}

/// Reads 4 bytes from a specified offset in data
/// - parameter data: Data object to read from
/// - parameter position: Offset to data
func readUint32(_ data: Data, at position: Int, endianess: Endianess) -> uint32 {
    let dataType = data.withUnsafeBytes { $0.load(fromByteOffset: position, as: uint32.self)}
    
    if endianess == .bigEndian {
        return dataType.bigEndian
    } else {
        return dataType.littleEndian
    }
}

/// Reads 8 bytes from a specified offset in data
/// - parameter data: Data object to read from
/// - parameter position: Offset to data
func readUint64(_ data: Data, at position: Int, endianess: Endianess) -> uint64 {
    let dataType = data.withUnsafeBytes { $0.load(fromByteOffset: position, as: uint64.self)}
    
    if endianess == .bigEndian {
        return dataType.bigEndian
    } else {
        return dataType.littleEndian
    }
}
