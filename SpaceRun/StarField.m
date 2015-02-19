#import "StarField.h"

@implementation StarField

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak StarField *weakSelf = self;
        SKAction *update = [SKAction runBlock:^{
            if (arc4random_uniform(10) < 3) {
                [weakSelf launchStar];
            }
        }];
        SKAction *delay = [SKAction waitForDuration:0.01];
        SKAction *updateLoop = [SKAction sequence:@[delay, update]];
        [self runAction:[SKAction repeatActionForever:updateLoop]];
    }

    return self;
}

- (void)launchStar {
    CGFloat randX = arc4random_uniform((u_int32_t) self.scene.size.width);
    CGFloat maxY = self.scene.size.height;
    CGPoint randomStart = CGPointMake(randX, maxY);
    SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"shootingstar"];
    star.position = randomStart;
    star.size = CGSizeMake(2, 10);
    star.alpha = (CGFloat) (0.1 + arc4random_uniform(10) / 10.0f);
    [self addChild:star];

    CGFloat destY = 0 - self.scene.size.height - star.size.height;
    CGFloat duration = (CGFloat) (0.1 + arc4random_uniform(10) / 10.0f);
    SKAction *move = [SKAction moveByX:0 y:destY duration:duration];
    SKAction *remove = [SKAction removeFromParent];
    [star runAction:[SKAction sequence:@[move, remove]]];
}


@end