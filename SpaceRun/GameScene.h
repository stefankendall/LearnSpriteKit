
#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property(nonatomic, weak) UITouch *shipTouch;
@property (nonatomic) CFTimeInterval lastUpdateTime;
@property (nonatomic) CFTimeInterval lastShotFireTime;
@property (nonatomic) CGFloat shipFireRate;

@property (nonatomic, strong) SKAction *shootSound;
@property (nonatomic, strong) SKAction *shipExplodeSound;
@property (nonatomic, strong) SKAction *obstacleExplodeSound;

@property (nonatomic, strong) SKEmitterNode *shipExplodeTemplate;
@property (nonatomic, strong) SKEmitterNode *obstacleExplodeTemplate;

@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, copy) dispatch_block_t endGameCallback;
@property (nonatomic) BOOL easyMode;

@end
