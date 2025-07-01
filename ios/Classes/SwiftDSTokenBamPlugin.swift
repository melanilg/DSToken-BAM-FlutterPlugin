import Flutter
import UIKit
import SmartIdLocal

public class SwiftDSTokenBamPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "DSTokenBam", binaryMessenger: registrar.messenger())
    let instance = SwiftDSTokenBamPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterMethodNotImplemented)
            return
        }

        switch call.method {
        case "getSeedDecrypt":
            if let mySecret = args["seed"] as? String {
                result(SeedConvertor.parseSeed(seedToParse: mySecret))
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing 'seed' parameter", details: nil))
            }

        case "getSmartId":
            getSmartId(arguments: args, result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
    private func getSmartId(arguments: [String: Any], result: @escaping FlutterResult) {
      result(SID.shared.getSmartId())
    }
}
