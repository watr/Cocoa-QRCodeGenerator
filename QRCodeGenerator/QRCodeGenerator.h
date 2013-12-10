
#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
// iOS codes
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
// OS X codes
#endif

#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
@import UIKit;
#define IMAGE_CLASS      UIImage
#define IMAGE_VIEW_CLASS UIImageView
#define FRAME_STRUCT     CGRect
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
@import Cocoa;
#define IMAGE_CLASS      NSImage
#define IMAGE_VIEW_CLASS NSImageView
#define FRAME_STRUCT     NSRect
#else
#error NOT SUPPORTED
#endif

@import QuartzCore;

typedef NS_ENUM(NSInteger, QRCodeGeneratorCorrectionLevel)
{
    QRCodeGeneratorCorrectionLevelDefault = 0,
    QRCodeGeneratorCorrectionLevelL,// 7%
    QRCodeGeneratorCorrectionLevelM,// 15%
    QRCodeGeneratorCorrectionLevelQ,// 25%
    QRCodeGeneratorCorrectionLevelH,// 30%
};

@interface CIFilter (QRCodeGenerator)

+ (CIFilter *)QRCodeGenerator;
+ (CIFilter *)QRCodeGeneratorWithCorrectionLevel:(QRCodeGeneratorCorrectionLevel)correctionLevel;

- (IMAGE_CLASS *)QRCodeImageWithMessageString:(NSString *)messageString
                                 encoding:(NSStringEncoding)stringEncoding;

@end

@interface IMAGE_CLASS (QRCodeGenerator)

+ (IMAGE_CLASS *)QRCodeImageWithMessageString:(NSString *)messageString
                                 encoding:(NSStringEncoding)stringEncoding;

+ (IMAGE_CLASS *)QRCodeImageWithMessageString:(NSString *)messageString
                                 encoding:(NSStringEncoding)stringEncoding
                          correctionLevel:(QRCodeGeneratorCorrectionLevel)correctionLevel;
@end

@interface IMAGE_VIEW_CLASS (QRCodeGenerator)

- (void)updateSettingToShowQRCodeImage;

@end

@interface CodePreviewImageView : IMAGE_VIEW_CLASS

@end

void PrintAllCIFilter();
