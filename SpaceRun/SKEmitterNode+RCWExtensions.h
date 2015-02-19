#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKEmitterNode (RCWExtensions)

+ (SKEmitterNode *)rcw_nodeWithFile:(NSString *)filename;

- (void)rcw_dieOutInDuration:(NSTimeInterval)duration;

@end