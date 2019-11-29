#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNPytorch, NSObject)

RCT_EXTERN_METHOD(loadModel:(NSString *)modelPath labelPath:(NSString *)labelPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(predict:(NSString *)imagePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
