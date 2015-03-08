//
//  SyncViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 23/02/15.
//
//

#import "SyncViewController.h"

@interface SyncViewController ()

@end

@implementation SyncViewController

- (id)initIsPlaySound:(BOOL)isPlaySound
{
    self = [super init];
    
    if(self) {
        self.playSound = isPlaySound;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareMyoForSync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)syncMyoAction:(id)sender {
    [self configureMyo];
}

- (IBAction)noMyoAction:(id)sender {
    [self goToGameUsingMyo:NO];
}

- (void) goToGameUsingMyo:(BOOL)yesOrNo {
    GameViewController *gameViewController = [[GameViewController alloc]init];
    gameViewController.playSound = self.playSound;
    gameViewController.useMyo = yesOrNo;
    [self.navigationController pushViewController:gameViewController animated:YES];
}

- (void) prepareMyoForSync {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice:)
                                                 name:TLMHubDidConnectDeviceNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice:)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncArm:)
                                                 name:TLMMyoDidReceiveArmSyncEventNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm:)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnlockDevice:)
                                                 name:TLMMyoDidReceiveUnlockEventNotification
                                               object:nil];
}

- (void) configureMyo {
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) configureMyoIfDisconneted {
    if([[TLMHub sharedHub] myoDevices].count == 0) {
        [self configureMyo];
    }
}

- (void)didReceivePoseChange:(NSNotification*)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    [pose.myo unlockWithType:TLMUnlockTypeHold];
}

- (void)didConnectDevice:(NSNotification *)notification {
    self.imgBackground.image = [UIImage imageNamed:@"sync2.png"];
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    self.imgBackground.image = [UIImage imageNamed:@"sync1.png"];
}

- (void)didSyncArm:(NSNotification *)notification {
    BOOL isLeftArm;
    
    TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];
    if(armEvent.arm == TLMArmLeft) {
        isLeftArm = YES;
    } else {
        isLeftArm = NO;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:isLeftArm forKey:@"isLeftArm"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didUnsyncArm:(NSNotification *)notification {
    self.imgBackground.image = [UIImage imageNamed:@"sync1.png"];
}

- (void)didUnlockDevice:(NSNotification *)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    [pose.myo unlockWithType:TLMUnlockTypeHold];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self goToGameUsingMyo:YES];
}

@end