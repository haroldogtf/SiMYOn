//
//  BestScoresViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/02/15.
//
//

#import "BestScoresViewController.h"
#import "Constants.h"
#import "Util.h"
#import "Player.h"
#import "Ranking.h"

@interface BestScoresViewController ()

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

    @property (weak, nonatomic) NSArray *bestScores;

@end

@implementation BestScoresViewController

- (id)init {    
    return [super initWithNibName:[Util selectNibNameByModel:NIB_BESTSCORES]
                           bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateScoresWithLocalScores];    
}

- (void)viewDidAppear:(BOOL)animated {
    [self performSelectorInBackground:@selector(updateBestScores) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateBestScores {
    if([Util hasInternetConnection]) {
        [self updateScores];
    } else {
        self.imgBackground.image = [UIImage imageNamed:IMG_BEST_SCORES_NO_CONNECTION];
        self.indicatorLoading.hidden = YES;
    }
}

- (void) updateScores {

    __weak typeof(self) this = self;
    
    [Ranking getBestScores:^(NSArray *scores) {
        this.indicatorLoading.hidden = YES;
        
        if(scores.count == 0) {
            this.imgBackground.image = [UIImage imageNamed:IMG_BEST_SCORES_NO_CONNECTION];
        } else {
            NSMutableArray *scoresArray = [scores mutableCopy];
            while (scoresArray.count <= TOP_RANKING) {
                Player *player = [Player new];
                player.name = INITAL_NAME;
                player.score = INITIAL_SCORE;
                [scoresArray addObject: player];
            }
            
            self.bestScores = scoresArray;
            this.imgBackground.image = [UIImage imageNamed:IMG_BEST_SCORES];
            [this updateScoresInView];
            [this showLastRankings];
        }
    }];
}

- (void) updateScoresWithLocalScores {
    self.lblPlayer1.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_1];
    self.lblScorePlayer1.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_1];
    
    self.lblPlayer2.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_2];
    self.lblScorePlayer2.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_2];
    
    self.lblPlayer3.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_3];
    self.lblScorePlayer3.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_3];
    
    self.lblPlayer4.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_4];
    self.lblScorePlayer4.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_4];
    
    self.lblPlayer5.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_5];
    self.lblScorePlayer5.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_5];
    
    self.lblPlayer6.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_6];
    self.lblScorePlayer6.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_6];
    
    self.lblPlayer7.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_7];
    self.lblScorePlayer7.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_7];
    
    self.lblPlayer8.text      = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_8];
    self.lblScorePlayer8.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PLAYER_8];
}

- (void) updateScoresInView {
    [self updateScoreWithIndex:0  labelName:self.lblPlayer1  andLabelScore:self.lblScorePlayer1];
    [self updateScoreWithIndex:1  labelName:self.lblPlayer2  andLabelScore:self.lblScorePlayer2];
    [self updateScoreWithIndex:2  labelName:self.lblPlayer3  andLabelScore:self.lblScorePlayer3];
    [self updateScoreWithIndex:3  labelName:self.lblPlayer4  andLabelScore:self.lblScorePlayer4];
    [self updateScoreWithIndex:4  labelName:self.lblPlayer5  andLabelScore:self.lblScorePlayer5];
    [self updateScoreWithIndex:5  labelName:self.lblPlayer6  andLabelScore:self.lblScorePlayer6];
    [self updateScoreWithIndex:6  labelName:self.lblPlayer7  andLabelScore:self.lblScorePlayer7];
    [self updateScoreWithIndex:7  labelName:self.lblPlayer8  andLabelScore:self.lblScorePlayer8];
    [self updateScoreWithIndex:8  labelName:self.lblPlayer9  andLabelScore:self.lblScorePlayer9];
    [self updateScoreWithIndex:9  labelName:self.lblPlayer10 andLabelScore:self.lblScorePlayer10];
    [self updateScoreWithIndex:10 labelName:self.lblPlayer11 andLabelScore:self.lblScorePlayer11];
    [self updateScoreWithIndex:11 labelName:self.lblPlayer12 andLabelScore:self.lblScorePlayer12];
}

- (void)showLastRankings
{
    self.lblPlayer9.hidden      = NO;
    self.lblScorePlayer9.hidden = NO;
    
    self.lblPlayer10.hidden      = NO;
    self.lblScorePlayer10.hidden = NO;
    
    self.lblPlayer11.hidden      = NO;
    self.lblScorePlayer11.hidden = NO;
    
    self.lblPlayer12.hidden      = NO;
    self.lblScorePlayer12.hidden = NO;
}

- (void) updateScoreWithIndex:(int)index
              labelName:(UILabel *)name
              andLabelScore:(UILabel *)score {

    Player *player = self.bestScores[index];
    if(player) {
        name.text  = player.name;
        score.text = player.score;
        
        if(score >=0 && index <= 7) {
           [Util setString:name.text  forKey:[PLAYER       stringByAppendingFormat:@"%d", index+1]];
           [Util setString:score.text forKey:[SCORE_PLAYER stringByAppendingFormat:@"%d", index+1]];
           [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
