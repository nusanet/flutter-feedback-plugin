#import "FlutterFeedbackPlugin.h"
#if __has_include(<flutter_feedback/flutter_feedback-Swift.h>)
#import <flutter_feedback/flutter_feedback-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_feedback-Swift.h"
#endif

@implementation FlutterFeedbackPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFeedbackPlugin registerWithRegistrar:registrar];
}
@end
