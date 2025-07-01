#import "DSTokenBamPlugin.h"
#if __has_include(<DSTokenBam/DSTokenBam-Swift.h>)
#import <DSTokenBam/DSTokenBam-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "DSTokenBam-Swift.h"
#endif

@implementation DSTokenBamPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDSTokenBamPlugin registerWithRegistrar:registrar];
}
@end
