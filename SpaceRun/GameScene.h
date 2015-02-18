
#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property(nonatomic, weak) UITouch *shipTouch;
@property (nonatomic) CFTimeInterval lastUpdateTime;
@property (nonatomic) CFTimeInterval lastShotFireTime;
@property (nonatomic) CGFloat shipFireRate;

@property (nonatomic, strong) SKAction *shootSound;
@property (nonatomic, strong) SKAction *shipExplodeSound;
@property (nonatomic, strong) SKAction *obstacleExplodeSound;

@end
