//
//  RootViewController.m
//  DaysSince
//
//  Created by Sam Cole on 3/16/15.
//
//

#import "RootViewController.h"
#import "DaysSinceShared.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    self.pageViewController.delegate = self;
    
    self.dataSource = [[DataSource alloc] init];
    self.pageViewController.dataSource = self.dataSource;
    
    // Find the index of the last view displayed
    NSInteger currentView = 0;
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToCurrentViewIndex()]) {
        currentView = [[NSKeyedUnarchiver unarchiveObjectWithFile:pathToCurrentViewIndex()] integerValue];
        NSLog(@"Loaded index of current view from %@\nIndex of current view == %ld", pathToCurrentViewIndex(), (long)currentView);
    }
    
    NSArray *viewControllers = @[[self.dataSource viewControllerAtIndex:currentView storyboard:self.storyboard]];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // TODO: find out exactly what these do
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    // Not sure if I actually need this...
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
