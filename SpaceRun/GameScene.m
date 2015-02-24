#import <stdlib.h>
#import "GameScene.h"
#import "StarField.h"
#import "SKEmitterNode+RCWExtensions.h"
#import "GameOverNode.h"

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship.png"];
    ship.size = CGSizeMake(40, 40);
    ship.name = @"ship";
    ship.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:ship];

    SKEmitterNode *thrust = [SKEmitterNode rcw_nodeWithFile:@"thrust.sks"];
    thrust.position = CGPointMake(0, -20);
    [ship addChild:thrust];

    self.shipExplodeTemplate = [SKEmitterNode rcw_nodeWithFile:@"shipExplode.sks"];
    self.obstacleExplodeTemplate = [SKEmitterNode rcw_nodeWithFile:@"obstacleExplode.sks"];

    self.shipFireRate = 0.5;

    self.shootSound = [SKAction playSoundFileNamed:@"shoot.m4a" waitForCompletion:NO];
    self.obstacleExplodeSound = [SKAction playSoundFileNamed:@"obstacleExplode.m4a" waitForCompletion:NO];
    self.shipExplodeSound = [SKAction playSoundFileNamed:@"shipExplode.m4a" waitForCompletion:NO];

    StarField *starField = [StarField node];
    [self addChild:starField];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    [self.view removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
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

        if (currentTime - self.lastShotFireTime > self.shipFireRate) {
            [self shoot];
            self.lastShotFireTime = currentTime;
        }
    }

    int thingProbability = self.easyMode ? 15 : 50;
    if (arc4random_uniform(1000) <= thingProbability) {
        [self dropThing];
    }

    [self checkCollisions];
    self.lastUpdateTime = currentTime;
}

- (void)checkCollisions {
    SKNode *ship = [self childNodeWithName:@"ship"];

    [self enumerateChildNodesWithName:@"powerup" usingBlock:^(SKNode *powerup, BOOL *stop) {
        if ([ship intersectsNode:powerup]) {
            [powerup removeFromParent];
            self.shipFireRate = 0.1;

            SKAction *powerdown = [SKAction runBlock:^{
                self.shipFireRate = 0.5;
            }];
            SKAction *wait = [SKAction waitForDuration:5];
            SKAction *waitAndPowerdown = [SKAction sequence:@[wait, powerdown]];
            [ship removeActionForKey:@"waitAndPowerdown"];
            [ship runAction:waitAndPowerdown withKey:@"waitAndPowerdown"];
        }
    }];

    [self enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *obstacle, BOOL *stop) {
        if ([ship intersectsNode:obstacle]) {
            self.shipTouch = nil;
            [ship removeFromParent];
            [obstacle removeFromParent];
            [self runAction:self.shipExplodeSound];

            SKEmitterNode *explosion = [self.shipExplodeTemplate copy];
            explosion.position = ship.position;
            [explosion rcw_dieOutInDuration:0.3];
            [self addChild:explosion];

            [self endGame];
        }

        [self enumerateChildNodesWithName:@"photon" usingBlock:^(SKNode *photon, BOOL *stop) {
            if ([photon intersectsNode:obstacle]) {
                [photon removeFromParent];
                [obstacle removeFromParent];
                [self runAction:self.obstacleExplodeSound];

                SKEmitterNode *explosion = [self.obstacleExplodeTemplate copy];
                explosion.position = obstacle.position;
                [explosion rcw_dieOutInDuration:0.1];
                [self addChild:explosion];

                *stop = YES;
            }
        }];
    }];
}

- (void)endGame {
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:self.tapGesture];
    GameOverNode *node = [GameOverNode node];
    node.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:node];
}

- (void)tapped {
    self.endGameCallback();
}

- (void)dropThing {
    u_int32_t dice = arc4random_uniform(100);
    if (dice < 5) {
        [self dropPowerUp];
    }
    else if (dice < 20) {
        [self dropEnemyShip];
    }
    else {
        [self dropAsteroid];
    }
}

- (void)dropPowerUp {
    CGFloat sideSize = 30;
    CGFloat startX = arc4random_uniform((u_int32_t) (self.size.width - 60)) + 30;
    CGFloat startY = self.size.height + sideSize;
    CGFloat endY = 0 - sideSize;
    SKSpriteNode *powerup = [SKSpriteNode spriteNodeWithImageNamed:@"powerup"];
    powerup.name = @"powerup";
    powerup.size = CGSizeMake(sideSize, sideSize);
    powerup.position = CGPointMake(startX, startY);
    [self addChild:powerup];

    SKAction *move = [SKAction moveTo:CGPointMake(startX, endY) duration:6];
    SKAction *spin = [SKAction rotateByAngle:-1 duration:1];
    SKAction *remove = [SKAction removeFromParent];

    SKAction *spinForever = [SKAction repeatActionForever:spin];
    SKAction *travelAndRemove = [SKAction sequence:@[move, remove]];
    SKAction *all = [SKAction group:@[spinForever, travelAndRemove]];
    [powerup runAction:all];
}

- (void)dropEnemyShip {
    for (int i = 1; i < 5; i++) {
        CGFloat sideSize = 30;
        CGFloat startX = arc4random_uniform((u_int32_t) (self.size.width - 40)) + 20;
        CGFloat startY = self.size.height + (sideSize + 5) * i;
        SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemy"];
        enemy.size = CGSizeMake(sideSize, sideSize);
        enemy.position = CGPointMake(startX, startY);
        enemy.name = @"obstacle";
        [self addChild:enemy];

        CGPathRef shipPath = [self buildEnemyShipMovementPath];
        SKAction *followPath = [SKAction followPath:shipPath asOffset:YES orientToPath:YES duration:7];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *all = [SKAction sequence:@[followPath, remove]];
        [enemy runAction:all];
    }
}

- (CGPathRef)buildEnemyShipMovementPath {

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.5, -0.5)];
    [bezierPath addCurveToPoint:CGPointMake(-2.5, -59.5)
                  controlPoint1:CGPointMake(0.5, -0.5)
                  controlPoint2:CGPointMake(4.55, -29.48)];
    [bezierPath addCurveToPoint:CGPointMake(-27.5, -154.5)
                  controlPoint1:CGPointMake(-9.55, -89.52)
                  controlPoint2:CGPointMake(-43.32, -115.43)];
    [bezierPath addCurveToPoint:CGPointMake(30.5, -243.5)
                  controlPoint1:CGPointMake(-11.68, -193.57)
                  controlPoint2:CGPointMake(17.28, -186.95)];
    [bezierPath addCurveToPoint:CGPointMake(-52.5, -379.5)
                  controlPoint1:CGPointMake(43.72, -300.05)
                  controlPoint2:CGPointMake(-47.71, -335.76)];
    [bezierPath addCurveToPoint:CGPointMake(54.5, -449.5)
                  controlPoint1:CGPointMake(-57.29, -423.24)
                  controlPoint2:CGPointMake(-8.14, -482.45)];
    [bezierPath addCurveToPoint:CGPointMake(-5.5, -348.5)
                  controlPoint1:CGPointMake(117.14, -416.55)
                  controlPoint2:CGPointMake(52.25, -308.62)];
    [bezierPath addCurveToPoint:CGPointMake(10.5, -494.5)
                  controlPoint1:CGPointMake(-63.25, -388.38)
                  controlPoint2:CGPointMake(-14.48, -457.43)];
    [bezierPath addCurveToPoint:CGPointMake(0.5, -559.5)
                  controlPoint1:CGPointMake(23.74, -514.16)
                  controlPoint2:CGPointMake(6.93, -537.57)];
    [bezierPath addCurveToPoint:CGPointMake(-2.5, -644.5)
                  controlPoint1:CGPointMake(-5.2, -578.93)
                  controlPoint2:CGPointMake(-2.5, -644.5)];
    return bezierPath.CGPath;
}

- (void)dropAsteroid {
    CGFloat sideSize = 15 + arc4random_uniform(30);
    CGFloat maxX = self.size.width;
    CGFloat quarterX = maxX / 4;
    CGFloat startX = arc4random_uniform((u_int32_t) maxX) + arc4random_uniform((u_int32_t) (quarterX * 2)) - quarterX;
    CGFloat startY = self.size.height + sideSize;
    CGFloat endX = arc4random_uniform((u_int32_t) maxX);
    CGFloat endY = 0 - sideSize;

    SKSpriteNode *asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    asteroid.size = CGSizeMake(sideSize, sideSize);
    asteroid.position = CGPointMake(startX, startY);
    asteroid.name = @"obstacle";
    [self addChild:asteroid];

    SKAction *move = [SKAction moveTo:CGPointMake(endX, endY) duration:3 + arc4random_uniform(4)];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *travelAndRemove = [SKAction sequence:@[move, remove]];
    SKAction *spin = [SKAction rotateByAngle:3 duration:arc4random_uniform(2) + 1];
    SKAction *spinForever = [SKAction repeatActionForever:spin];
    SKAction *all = [SKAction group:@[spinForever, travelAndRemove]];
    [asteroid runAction:all];
}

- (void)shoot {
    SKNode *ship = [self childNodeWithName:@"ship"];
    SKSpriteNode *photon = [SKSpriteNode spriteNodeWithImageNamed:@"photon"];
    photon.name = @"photon";
    photon.position = ship.position;
    [self addChild:photon];

    SKAction *fly = [SKAction moveByX:0 y:self.size.height + photon.size.height duration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *fireAndRemove = [SKAction sequence:@[fly, remove]];
    [photon runAction:fireAndRemove];
    [self runAction:self.shootSound];
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