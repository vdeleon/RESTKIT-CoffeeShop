//
//  DetailViewController.h
//  CoffeeShop
//
//  Created by Romy Ilano on 9/13/12.
//  Copyright (c) 2012 Snowyla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
