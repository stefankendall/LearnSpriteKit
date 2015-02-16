
#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property(nonatomic, weak) UITouch *shipTouch;
@property (nonatomic) CFTimeInterval lastUpdateTime;

@end
