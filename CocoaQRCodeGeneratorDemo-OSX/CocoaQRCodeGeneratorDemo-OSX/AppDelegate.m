
#import "AppDelegate.h"
#import "QRCodeGenerator.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    ;
}

- (void)awakeFromNib
{
    //PrintAllCIFilter();
    
    [self.imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [self.imageView updateSettingToShowQRCodeImage];
    
    self.imageView.image = [NSImage QRCodeImageWithMessageString:@"Hello, I am Macintosh."
                                                        encoding:NSUTF8StringEncoding];
}

@end
