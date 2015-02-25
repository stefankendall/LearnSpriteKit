//
//  AppDelegate.m
//  SpaceRun
//
//  Created by Stefan Kendall on 2/16/15.
//  Copyright (c) 2015 Usable Design LLC. All rights reserved.
//


#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // prevent audio crash
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // prevent audio crash
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // resume audio
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}


@end