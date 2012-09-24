//
//  VenueCell.h
//  CoffeeShop
//
//  Created by Romy Ilano on 9/23/12.
//  Copyright (c) 2012 Snowyla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkinsLabel;

@end
