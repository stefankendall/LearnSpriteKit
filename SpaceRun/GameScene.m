#import "GameScene.h"

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship.png"];
    ship.size = CGSizeMake(40, 40);
    ship.name = @"ship";
    ship.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:ship];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.shipTouch = [touches anyObject];
}


- (void)update:(CFTimeInterval)currentTime {
    if (self.lastUpdateTime == 0) {
        self.lastUpdateTime = currentTime;
    }
    NSTimeInterval timeDelta = currentTime - self.lastUpdateTime;

    if (self.shipTouch) {
        [self moveShipTowardPoint:[self.shipTouch locationInNode:self] byTimeDelta:timeDelta];
    }

    self.lastUpdateTime = currentTime;
}

- (void)moveShipTowardPoint:(CGPoint)point byTimeDelta:(NSTimeInterval)timeDelta {
    CGFloat shipSpeedPointsPerSecond = 130;
    SKNode *ship = [self childNodeWithName:@"ship"];
    CGFloat distanceLeft = (CGFloat) sqrt(pow(ship.position.x - point.x, 2) + pow(ship.position.y - point.y, 2));
    if (distanceLeft > 4) {
        CGFloat distanceToTravel = (CGFloat) (timeDelta * shipSpeedPointsPerSecond);
        CGFloat angle = (CGFloat) atan2(point.y - ship.position.y, point.x - ship.position.x);
        CGFloat yOffset = (CGFloat) (distanceToTravel * sin(angle));
        CGFloat xOffset = (CGFloat) (distanceToTravel * cos(angle));
        ship.position = CGPointMake(ship.position.x + xOffset, ship.position.y + yOffset);
    }
}

@end