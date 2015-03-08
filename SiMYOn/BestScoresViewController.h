//
//  BestScoresViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/02/15.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Util.h"
#import "Ranking.h"

@interface BestScoresViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (weak, nonatomic) IBOutlet UILabel *lblPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer3;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer4;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer5;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer6;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer7;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer8;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer9;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer10;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer11;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer12;

@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer1;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer2;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer3;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer4;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer5;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer6;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer7;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer8;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer9;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer10;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer11;
@property (weak, nonatomic) IBOutlet UILabel *lblScorePlayer12;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoading;

- (IBAction)returnAction:(id)sender;

@end