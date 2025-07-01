import SwiftBase32
 
class SeedConvertor {
     
    static func parseSeed(seedToParse: String) -> String{
        let seed = seedToParse.data(using: .utf8)
        let secretBase64Decoded = Data(base64Encoded: seed!, options: NSData.Base64DecodingOptions(rawValue: 0))
        let hex = secretBase64Decoded!.hexadecimalString()
        let startIndex = hex.index(hex.startIndex, offsetBy: 2)
        let endIndex = hex.index(hex.endIndex, offsetBy: -2)
        let xhex: String = String(hex[startIndex..<endIndex])
        let hexBase32: String? = xhex.dataFromHexadecimalString()?.base32EncodedString
         
        /*let secretBase64Decoded = Data(base64Encoded: seed, options: NSData.Base64DecodingOptions(rawValue: 0))
        let hex = secretBase64Decoded!.hexadecimalString()
        let startIndex = hex.index(hex.startIndex, offsetBy: 2)
        let endIndex = hex.index(hex.endIndex, offsetBy: -2)
        let xhex = String(hex[startIndex..<endIndex])
        let hexBase32 = xhex.dataFromHexadecimalString()?.base32EncodedString*/
        //let totp = TOTP(secret: hexBase32!, digits: 6, timeInterval: 30, algorithm: .sha1)
        //result(totp?.generate(time: Date()))
        return hexBase32!
    }
     
}
