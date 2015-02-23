#import "MenuViewController.h"
#import "GameViewController.h"
#import "StarField.h"

@implementation MenuViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"PlayGame"]) {
        GameViewController *controller = segue.destinationViewController;
        controller.easyMode = self.difficultyChooser.selectedSegmentIndex == 0;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.demoView = [[SKView alloc] initWithFrame:self.view.bounds];
    SKScene *scene = [[SKScene alloc] initWithSize:self.view.bounds.size];
    scene.backgroundColor = [SKColor blackColor];
    scene.scaleMode = SKSceneScaleModeFill;
    SKNode *starField = [StarField node];
    [scene addChild:starField];
    [self.demoView presentScene:scene];
    [self.view insertSubview:self.demoView atIndex:0];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.demoView removeFromSuperview];
    self.demoView = nil;
}


@end