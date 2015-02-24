#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface OpeningScene : SKScene
@property (nonatomic, copy) dispatch_block_t sceneEndCallback;

@property(nonatomic, strong) UIView *slantedView;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end