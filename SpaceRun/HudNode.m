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

        SKNode *powerupGroup = [SKNode node];
        powerupGroup.name = @"powerupGroup";

        SKLabelNode *powerupTitle = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
        powerupTitle.fontSize = 14;
        powerupTitle.fontColor = [SKColor redColor];
        powerupTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        powerupTitle.text = @"Power-up!";
        powerupTitle.position = CGPointMake(0, 4);

        SKAction *scaleUp = [SKAction scaleTo:1.3 duration:0.3];
        SKAction *scaleDown = [SKAction scaleTo:1 duration:0.3];
        SKAction *pulse = [SKAction sequence:@[scaleUp, scaleDown]];
        SKAction *pulseForever = [SKAction repeatActionForever:pulse];
        [powerupTitle runAction:pulseForever];

        [powerupGroup addChild:powerupTitle];

        SKLabelNode *powerupValue = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
        powerupValue.fontSize = 20;
        powerupValue.fontColor = [SKColor redColor];
        powerupValue.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        powerupValue.name = @"powerupValue";
        powerupValue.text = @"0s left";
        powerupValue.position = CGPointMake(0, -4);
        [powerupGroup addChild:powerupValue];
        [self addChild:powerupGroup];
        powerupGroup.alpha = 0;

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
    CGFloat allGroupsYPosition = sceneSize.height / 2 - groupSize.height;
    scoreGroup.position = CGPointMake(0 - sceneSize.width / 2 + 20, allGroupsYPosition);
    SKNode *elapsedGroup = [self childNodeWithName:@"elapsedGroup"];
    groupSize = [elapsedGroup calculateAccumulatedFrame].size;
    elapsedGroup.position = CGPointMake(sceneSize.width / 2 - 20, allGroupsYPosition);

    SKNode *powerupGroup = [self childNodeWithName:@"powerupGroup"];
    groupSize = [powerupGroup calculateAccumulatedFrame].size;
    powerupGroup.position = CGPointMake(0, allGroupsYPosition);
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
        elapsedValue.text = [NSString stringWithFormat:@"%@s", [weakSelf.timeFormatter stringFromNumber:@(elapsed)]];
    }];

    SKAction *delay = [SKAction waitForDuration:0.05];
    SKAction *updateAndDelay = [SKAction sequence:@[update, delay]];
    SKAction *timer = [SKAction repeatActionForever:updateAndDelay];
    [self runAction:timer withKey:@"elapsedGameTimer"];
}

- (void)endGame {
    [self removeActionForKey:@"elapsedGameTimer"];

    SKNode *powerupGroup = [self childNodeWithName:@"powerupGroup"];
    [powerupGroup removeActionForKey:@"showPowerupTimer"];

    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:0.3];
    [powerupGroup runAction:fadeOut];
}

- (void)showPowerupTimer:(NSTimeInterval)time {
    SKNode *powerupGroup = [self childNodeWithName:@"powerupGroup"];
    SKLabelNode *powerupValue = (SKLabelNode *) [powerupGroup childNodeWithName:@"powerupValue"];
    [powerupGroup removeActionForKey:@"showPowerupTimer"];

    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    __weak HudNode *weakSelf = self;
    SKAction *block = [SKAction runBlock:^{
        NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - start;
        NSTimeInterval left = time - elapsed;
        if (left < 0) {
            left = 0;
        }

        powerupValue.text = [NSString stringWithFormat:@"%@s left", [weakSelf.timeFormatter stringFromNumber:@(left)]];
    }];

    SKAction *blockPause = [SKAction waitForDuration:0.05];
    SKAction *countdownSequence = [SKAction sequence:@[block, blockPause]];
    SKAction *countdown = [SKAction repeatActionForever:countdownSequence];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:0.1];
    SKAction *wait = [SKAction waitForDuration:time];
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:1];
    SKAction *stopAction = [SKAction runBlock:^{
        [powerupGroup removeActionForKey:@"showPowerupTimer"];
    }];

    SKAction *visuals = [SKAction sequence:@[fadeIn, wait, fadeOut, stopAction]];
    [powerupGroup runAction:[SKAction group:@[countdown, visuals]] withKey:@"showPowerupTimer"];
}

@end