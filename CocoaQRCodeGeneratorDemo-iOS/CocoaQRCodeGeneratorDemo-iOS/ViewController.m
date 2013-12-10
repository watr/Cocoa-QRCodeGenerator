
#import "ViewController.h"
#import "QRCodeGenerator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //PrintAllCIFilter();
    
    [self.imageView updateSettingToShowQRCodeImage];
    
    self.imageView.image = [UIImage QRCodeImageWithMessageString:@"Hello, I am iOS Device."
                                                        encoding:NSUTF8StringEncoding];
}

@end
