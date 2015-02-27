#import "HudNode.h"

@implementation HudNode

- (instancetype)init {
    self = [super init];
    if (self) {
        SKNode *scoreGroup = [SKNode node];
        scoreGroup.name = @"scoreGroup";
        SKLabelNode *scoreTitle = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        scoreTitle.fontSize = 12;
        scoreTitle.fontColor = [SKColor whiteColor];
        scoreTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        scoreTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        scoreTitle.text = @"SCORE";
        scoreTitle.position = CGPointMake(0, 4);
        [scoreGroup addChild:scoreTitle];

        SKLabelNode *scoreValue = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
        scoreValue.fontSize = 20;
        scoreValue.fontColor = [SKColor whiteColor];
        scoreValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        scoreValue.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        scoreValue.name = @"scoreValue";
        scoreValue.text = @"0";
        scoreValue.position = CGPointMake(0, -4);
        [scoreGroup addChild:scoreValue];
        [self addChild:scoreGroup];

        SKNode *elapsedGroup = [SKNode node];
        elapsedGroup.name = @"elapsedGroup";
        SKLabelNode *elapsedTitle = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        elapsedTitle.fontSize = 12;
        elapsedTitle.fontColor = [SKColor whiteColor];
        elapsedTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        elapsedTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        elapsedTitle.text = @"TIME";
        elapsedTitle.position = CGPointMake(0, 4);
        [elapsedGroup addChild:elapsedTitle];

        SKLabelNode *elapsedValue = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
        elapsedValue.fontSize = 20;
        elapsedValue.fontColor = [SKColor whiteColor];
        elapsedValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        elapsedValue.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        elapsedValue.name = @"elapsedValue";
        elapsedValue.text = @"0.0s";
        elapsedValue.position = CGPointMake(0, -4);
        [elapsedGroup addChild:elapsedValue];
        [self addChild:elapsedGroup];

        self.scoreFormatter = [NSNumberFormatter new];
        self.scoreFormatter.numberStyle = NSNumberFormatterDecimalStyle;

        self.timeFormatter = [NSNumberFormatter new];
        self.timeFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.timeFormatter.minimumFractionDigits = 1;
        self.timeFormatter.maximumFractionDigits = 1;
    }

    return self;
}

- (void)layoutForScene {
    CGSize sceneSize = self.scene.size;
    SKNode *scoreGroup = [self childNodeWithName:@"scoreGroup"];
    CGSize groupSize = [scoreGroup calculateAccumulatedFrame].size;
    scoreGroup.position = CGPointMake(0 - sceneSize.width / 2 + 20, sceneSize.height / 2 - groupSize.height);
    SKNode *elapsedGroup = [self childNodeWithName:@"elapsedGroup"];
    groupSize = [elapsedGroup calculateAccumulatedFrame].size;
    elapsedGroup.position = CGPointMake(sceneSize.width / 2 - 20, sceneSize.height / 2 - groupSize.height);
}

- (void)addPoints:(NSInteger)points {
    self.score += points;
    SKLabelNode *scoreValue = (SKLabelNode *) [self childNodeWithName:@"scoreGroup/scoreValue"];
    scoreValue.text = [NSString stringWithFormat:@"%@", [self.scoreFormatter stringFromNumber:@(self.score)]];
    SKAction *scale = [SKAction scaleTo:1.1 duration:0.02];
    SKAction *shrink = [SKAction scaleTo:1 duration:0.07];
    SKAction *all = [SKAction sequence:@[scale, shrink]];
    [scoreValue runAction:all];
}

- (void)startGame {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    SKLabelNode *elapsedValue = (SKLabelNode *) [self childNodeWithName:@"elapsedGroup/elapsedValue"];
    __weak HudNode *weakSelf = self;
    SKAction *update = [SKAction runBlock:^{
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval elapsed = now - startTime;
        weakSelf.elapsedTime = elapsed;
        elapsedValue.text = [NSString stringWithFormat:@"%@s", [weakSelf.timeFormatter stringFromNumber: @(elapsed)]];
    }];

    SKAction *delay = [SKAction waitForDuration:0.05];
    SKAction *updateAndDelay = [SKAction sequence:@[update, delay]];
    SKAction *timer = [SKAction repeatActionForever:updateAndDelay];
    [self runAction:timer withKey:@"elapsedGameTimer"];
}

- (void)endGame {
    [self removeActionForKey:@"elapsedGameTimer"];
}

@end