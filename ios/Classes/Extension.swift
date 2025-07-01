//
//  Extension.swift
//  Runner
//
//  Created by Devel Systems on 4/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
import Foundation


extension Data {
    
    /// Create hexadecimal string representation of NSData object.
    ///
    /// - returns: String representation of this NSData object.
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexadecimalString(options: HexEncodingOptions = []) -> String {
        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }
        return String(utf16CodeUnits: chars, count: chars.count)
    }
}
extension String {
    func dataFromHexadecimalString() -> Data? {
        let data = NSMutableData(capacity: self.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.append([num], length: 1)
        }
        
        return data as Data?
    }
    /// Create `NSData` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a String object from that. Note, if the string has any spaces, those are removed. Also if the string started with a '<' or ended with a '>', those are removed, too.
    ///
    /// - parameter encoding: The `NSStringCoding` that indicates how the binary data represented by the hex string should be converted to a `String`.
    ///
    /// - returns: `String` represented by this hexadecimal string.
    
    func stringFromHexadecimalStringUsingEncoding(_ encoding: String.Encoding) -> String? {
        if let data = dataFromHexadecimalString() {
            return String(data: data, encoding: encoding)
        }
        
        return nil
    }
    
    /// Create hexadecimal string representation of String object.
    ///
    /// - parameter encoding: The NSStringCoding that indicates how the string should be converted to NSData before performing the hexadecimal conversion.
    ///
    /// - returns: String representation of this String object.
    
    func hexadecimalStringUsingEncoding(_ encoding: String.Encoding) -> String? {
        let data = self.data(using: String.Encoding.utf8)
        return data?.hexadecimalString()
    }
}
