
#import "QRCodeGenerator.h"

@implementation CIFilter (QRCodeGenerator)

+ (CIFilter *)QRCodeGenerator
{
    return [self QRCodeGeneratorWithCorrectionLevel:QRCodeGeneratorCorrectionLevelDefault];
}

+ (CIFilter *)QRCodeGeneratorWithCorrectionLevel:(QRCodeGeneratorCorrectionLevel const)correctionLevel
{
    CIFilter *qrCodeGenerator = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrCodeGenerator setDefaults];
    
    BOOL isCorrectionLevelDefault = (correctionLevel == QRCodeGeneratorCorrectionLevelDefault);
    if (! isCorrectionLevelDefault) {
        NSString *correctionLevelString = nil;
        switch (correctionLevel) {
            case QRCodeGeneratorCorrectionLevelL:
                correctionLevelString = @"L";
                break;
            case QRCodeGeneratorCorrectionLevelM:
                correctionLevelString = @"M";
                break;
            case QRCodeGeneratorCorrectionLevelQ:
                correctionLevelString = @"Q";
                break;
            case QRCodeGeneratorCorrectionLevelH:
                correctionLevelString = @"H";
                break;
            default:
                break;
        }
        NSAssert((correctionLevelString != nil), @"correction level string must not be nil");
        
        [qrCodeGenerator setValue:correctionLevelString
                           forKey:@"inputCorrectionLevel"];
    }
    return qrCodeGenerator;
}


- (IMAGE_CLASS *)QRCodeImageWithMessageString:(NSString *)messageString
                                 encoding:(NSStringEncoding)stringEncoding
{
    [self setValue:[messageString dataUsingEncoding:stringEncoding]
            forKey:@"inputMessage"];
    CIImage *ciImage = [self valueForKey:@"outputImage"];
    
    if (ciImage == nil) {
        return nil;
    }
    
#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
    UIImage *image = nil;
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImage
                                         fromRect:[ciImage extent]];
    if (cgImage) {
        image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
    }
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
    NSImage *image = nil;
    CIContext *ciContext = [CIContext contextWithCGContext:
                            (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort]
                                                   options:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImage
                                         fromRect:[ciImage extent]];
    if (cgImage) {
        image = [[NSImage alloc] initWithCGImage:cgImage
                                            size:NSMakeSize(CGImageGetWidth(cgImage),
                                                            CGImageGetHeight(cgImage))];
        CGImageRelease(cgImage);
    }
#endif
    return image;
}

@end

@implementation IMAGE_CLASS (QRCodeGenerator)

+ (IMAGE_CLASS *)QRCodeImageWithMessageString:(NSString *)messageString
                                     encoding:(NSStringEncoding)stringEncoding
{
    return [self QRCodeImageWithMessageString:messageString
                                     encoding:stringEncoding
                              correctionLevel:QRCodeGeneratorCorrectionLevelDefault];
}

+ (IMAGE_CLASS *)QRCodeImageWithMessageString:(NSString *)messageString
                                     encoding:(NSStringEncoding)stringEncoding
                              correctionLevel:(QRCodeGeneratorCorrectionLevel)correctionLevel
{
    CIFilter *qrCodeGenerator = [CIFilter QRCodeGeneratorWithCorrectionLevel:correctionLevel];
    IMAGE_CLASS *qrCodeImage = [qrCodeGenerator QRCodeImageWithMessageString:messageString
                                                                encoding:stringEncoding];
    return qrCodeImage;
}

@end

@implementation IMAGE_VIEW_CLASS (QRCodeGenerator)

- (void)updateSettingToShowQRCodeImage
{
#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
    ;
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
    self.wantsLayer = YES;
    NSImageCell *imageCell = [self cell];
    [imageCell setImageFrameStyle:NSImageFrameNone];
#endif
    self.layer.magnificationFilter = kCAFilterNearest;
}

@end

@implementation CodePreviewImageView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self updateSettingToShowQRCodeImage];
    }
    return self;
}

- (id)initWithFrame:(FRAME_STRUCT)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self updateSettingToShowQRCodeImage];
    }
    return self;
}

@end

void PrintAllCIFilter()
{
    NSArray *filterNames = [CIFilter filterNamesInCategories:nil];
    
    for (NSString *aFilterName in filterNames) {
        CIFilter *aFilter = [CIFilter filterWithName:aFilterName];
        NSDictionary *attributes = [aFilter attributes];
        printf("%s\n", [[attributes description] UTF8String]);
    }

}

