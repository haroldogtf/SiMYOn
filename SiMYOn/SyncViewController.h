//
//  SyncViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 23/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MyoKit/MyoKit.h>
#import "Constants.h"
#import "GameViewController.h"

@interface SyncViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (nonatomic) BOOL playSound;

- (id)initIsPlaySound:(BOOL)value;

- (IBAction)returnAction: (id)sender;
- (IBAction)syncMyoAction:(id)sender;
- (IBAction)noMyoAction:  (id)sender;

@end