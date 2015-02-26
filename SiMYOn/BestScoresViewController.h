//
//  BestScoresViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/02/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BestScoresViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer3;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer4;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer5;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer6;

- (IBAction)returnAction:(id)sender;

@end