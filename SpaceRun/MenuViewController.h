#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface MenuViewController : UIViewController {}
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyChooser;
@property (nonatomic, strong) SKView *demoView;

@end