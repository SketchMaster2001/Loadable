//
//  Errors.swift
//  Loadable
//
//  Created by Noah Pistilli on 2021-12-13.
//

import Foundation

public enum Errors: Error {
    case incompatibleDataType(String)
    case emptyByteArray(String)
}
