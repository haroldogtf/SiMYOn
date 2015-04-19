//
//  MainViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "MainViewController.h"
#import "Constants.h"
#import "Util.h"
#import "Myo.h"
#import "SyncViewController.h"
#import "GameViewController.h"
#import "InstructionsViewController.h"
#import "BestScoresViewController.h"
#import "CreditsViewController.h"
#import <MyoKit/MyoKit.h>

@interface MainViewController ()

    @property (weak, nonatomic) IBOutlet UIButton *btnSound;

@end

@implementation MainViewController

- (id)init {
    return [super initWithNibName:[Util selectNibNameByModel:NIB_MENU]
                           bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateSoundStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) openViewController:(UIViewController *) viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)gameStarterAction:(id)sender {
    
    BOOL playSound = [self getSoundStatus];
    
    if(![Myo isConnected] || ![Myo isSynced]) {
        [self openViewController:[[SyncViewController alloc]initIsPlaySound:playSound]];
    } else {
        [self openViewController:[[GameViewController alloc]initIsPlaySound:playSound
                                                                  andUseMyo:YES]];
    }
}

- (IBAction)intructionsAction:(id)sender {
    [self openViewController:[[InstructionsViewController alloc]init]];
}

- (IBAction)bestScoresAction:(id)sender {
    [self openViewController:[[BestScoresViewController alloc]init]];
}

- (IBAction)creditsAction:(id)sender {
    [self openViewController:[[CreditsViewController alloc]init]];
}

- (IBAction)soundAction:(id)sender {
    BOOL playSound = [self getSoundStatus];
    [[NSUserDefaults standardUserDefaults] setBool:!playSound forKey:PLAY_SOUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateSoundStatus];
}

- (BOOL) getSoundStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PLAY_SOUND];
}

- (void) updateSoundStatus {
    if([self getSoundStatus]) {
        [self.btnSound setImage:[UIImage imageNamed:BTN_SOUND_ON] forState:UIControlStateNormal];
    } else {
        [self.btnSound setImage:[UIImage imageNamed:BTN_SOUND_OFF] forState:UIControlStateNormal];
    }
}

@end