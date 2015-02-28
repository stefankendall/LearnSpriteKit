#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

- (void)layoutForScene;

- (void)addPoints:(NSInteger)points;

- (void)startGame;

- (void)endGame;

- (void)
showPowerupTimer:(NSTimeInterval) time;

@property(nonatomic) NSTimeInterval elapsedTime;
@property(nonatomic) NSInteger score;

@property(nonatomic, strong) NSNumberFormatter *scoreFormatter;
@property(nonatomic, strong) NSNumberFormatter *timeFormatter;

@end