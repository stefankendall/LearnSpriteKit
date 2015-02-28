#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface MenuViewController : UIViewController {}
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyChooser;
@property (nonatomic, strong) SKView *demoView;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@end