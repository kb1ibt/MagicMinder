//
//  LoadingView.h
//  Magic Minder
//
//  Created by Shawn Stricker on 6/5/09.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIViewController {
	IBOutlet UILabel *labelBlock;
	IBOutlet UILabel *labelSet;
	IBOutlet UILabel *labelCard;
	IBOutlet UIProgressView *progressBlocks;
	IBOutlet UIProgressView *progressSets;
	IBOutlet UIProgressView *progressCards;	
}
@property (nonatomic, retain) UILabel *labelBlock;
@property (nonatomic, retain) UILabel *labelSet;
@property (nonatomic, retain) UILabel *labelCard;
@property (nonatomic, retain) UIProgressView *progressBlocks;
@property (nonatomic, retain) UIProgressView *progressSets;
@property (nonatomic, retain) UIProgressView *progressCards;

@end
