//
//  MainViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init {
    NSString *nibName = [self selectNibNameByModel:[Util getIphoneModel]];
    
    return [super initWithNibName:nibName bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateSoundStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *) selectNibNameByModel:(IPhoneModel) iPhoneModel {
    
    switch (iPhoneModel) {
        case IPHONE_5_5C_5S_MODEL:       return NIB_MENU_IPHONE_5_5C_5S;       break;
        case IPHONE_6_MODEL:             return NIB_MENU_IPHONE_6;             break;
        case IPHONE_6_PLUS_MODEL:        return NIB_MENU_IPHONE_6_PLUS;        break;
        case IPHONE_NOT_SUPPORTED_MODEL:
        default:                         return NIB_MENU_IPHONE_NOT_SUPPORTED; break;
    }
}

- (void) openViewController:(UIViewController *) viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)gameStarterAction:(id)sender {
    
    BOOL playSound = [self getSoundStatus];
    
    if([[TLMHub sharedHub] myoDevices].count == 0) {
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