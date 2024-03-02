#import "SVGLength.h"

#import "CSSPrimitiveValue.h"
#import "CSSPrimitiveValue_ConfigurablePixelsPerInch.h"

#import "SVGUtils.h"
#import "SVGKDefine_Private.h"

#include <sys/types.h>
#include <sys/sysctl.h>

float _pixelsPerInch = 300;

@interface SVGLength()
@property(nonatomic,strong) CSSPrimitiveValue* internalCSSPrimitiveValue;
@end

@implementation SVGLength

@synthesize unitType;
@synthesize value;
@synthesize valueInSpecifiedUnits;
@synthesize valueAsString;
@synthesize internalCSSPrimitiveValue;

+(float)pixelsPerInch {
    return _pixelsPerInch;
}

+(void)setPixelsPerInch:(float)pixelsPerInch {
    _pixelsPerInch = pixelsPerInch;
}

- (id)init
{
    NSAssert(FALSE, @"This class must not be init'd. Use the static hepler methods to instantiate it instead");
    return nil;
}

- (id)initWithCSSPrimitiveValue:(CSSPrimitiveValue*) pv
{
    self = [super init];
    if (self) {
        self.internalCSSPrimitiveValue = pv;
    }
    return self;
}

-(float)value
{
	return [self.internalCSSPrimitiveValue getFloatValue:self.internalCSSPrimitiveValue.primitiveType];
}

-(NSString *)valueAsString
{
    return [self.internalCSSPrimitiveValue getStringValue];
}

-(SVG_LENGTH_TYPE)unitType
{
	switch( self.internalCSSPrimitiveValue.primitiveType )
	{
		case CSS_CM:
			return SVG_LENGTHTYPE_CM;
		case CSS_EMS:
			return SVG_LENGTHTYPE_EMS;
		case CSS_EXS:
			return SVG_LENGTHTYPE_EXS;
		case CSS_IN:
			return SVG_LENGTHTYPE_IN;
		case CSS_MM:
			return SVG_LENGTHTYPE_MM;
		case CSS_PC:
			return SVG_LENGTHTYPE_PC;
		case CSS_PERCENTAGE:
			return SVG_LENGTHTYPE_PERCENTAGE;
		case CSS_PT:
			return SVG_LENGTHTYPE_PT;
		case CSS_PX:
			return SVG_LENGTHTYPE_PX;
		case CSS_NUMBER:
		case CSS_DIMENSION:
			return SVG_LENGTHTYPE_NUMBER;
		default:
			return SVG_LENGTHTYPE_UNKNOWN;
	}
}

-(void) newValueSpecifiedUnits:(SVG_LENGTH_TYPE) unitType valueInSpecifiedUnits:(float) valueInSpecifiedUnits
{
	NSAssert(FALSE, @"Not supported yet");
}

-(void) convertToSpecifiedUnits:(SVG_LENGTH_TYPE) unitType
{
	NSAssert(FALSE, @"Not supported yet");
}

+(SVGLength*) svgLengthZero
{
	SVGLength* result = [[SVGLength alloc] initWithCSSPrimitiveValue:nil];
	
	return result;
}

+(SVGLength*) svgLengthFromNSString:(NSString*) s
{
	CSSPrimitiveValue* pv = [[CSSPrimitiveValue alloc] init];
	
	pv.pixelsPerInch = _pixelsPerInch;
	pv.cssText = s;
	
	SVGLength* result = [[SVGLength alloc] initWithCSSPrimitiveValue:pv];
	
	return result;
}

-(float) pixelsValue
{
	return [self.internalCSSPrimitiveValue getFloatValue:CSS_PX];
}

-(float) pixelsValueWithDimension:(float)dimension
{
    if (self.internalCSSPrimitiveValue.primitiveType == CSS_PERCENTAGE)
        return dimension * self.value / 100.0;
    
    return [self pixelsValue];
}

-(float) pixelsValueWithGradientDimension:(float)dimension treatAsPercentage:(BOOL)treatAsPercentage
{
    if (self.internalCSSPrimitiveValue.primitiveType == CSS_PERCENTAGE) {
        return dimension * self.value / 100.0;
    } else if (treatAsPercentage && self.internalCSSPrimitiveValue.primitiveType == CSS_NUMBER) {
        if (self.value >= 0 && self.value <= 1) {
            return dimension * self.value;
        }
    }
    
    return [self pixelsValue];
}

-(float) numberValue
{
	return [self.internalCSSPrimitiveValue getFloatValue:CSS_NUMBER];
}

@end
