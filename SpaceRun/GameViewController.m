#import "GameViewController.h"
#import "GameScene.h"
#import "OpeningScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];

    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *) self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;

    SKScene *blackScene = [[SKScene alloc] initWithSize:skView.bounds.size];
    blackScene.backgroundColor = [SKColor blackColor];
    [skView presentScene:blackScene];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    SKView *skView = (SKView *) self.view;
    OpeningScene *scene = [OpeningScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition fadeWithDuration:1];
    [skView presentScene:scene transition:transition];

    __weak GameViewController *weakSelf = self;
    scene.sceneEndCallback = ^{
        GameScene *scene = [[GameScene alloc] initWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.easyMode = weakSelf.easyMode;
        scene.endGameCallback = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:1];
        [skView presentScene:scene transition:transition];
    };
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
