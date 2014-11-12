#import "BTUIFormField.h"
#import "BTUICardType.h"

@interface BTUICardNumberField : BTUIFormField

@property (nonatomic, strong, readonly) BTUICardType *cardType;
@property (nonatomic, strong, readonly) NSString *number;

-(void)setText:(NSAttributedString *)text;

@end
