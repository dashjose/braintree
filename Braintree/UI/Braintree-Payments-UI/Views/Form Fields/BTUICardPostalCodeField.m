#import "BTUICardPostalCodeField.h"
#import "BTUIFormField_Protected.h"
#import "BTUILocalizedString.h"

@interface BTUICardPostalCodeField () <UITextFieldDelegate>

@end

@implementation BTUICardPostalCodeField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setThemedPlaceholder:BTUILocalizedString(POSTAL_CODE_PLACEHOLDER)];
        self.nonDigitsSupported = NO;
    }
    return self;
}

- (void)setNonDigitsSupported:(BOOL)nonDigitsSupported {
    _nonDigitsSupported = nonDigitsSupported;
    self.textField.keyboardType = _nonDigitsSupported ? UIKeyboardTypeNumbersAndPunctuation : UIKeyboardTypeNumberPad;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlack;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    numberToolbar.tintColor = [UIColor whiteColor];
    [numberToolbar sizeToFit];
    
    
    self.textField.inputAccessoryView = numberToolbar;

}

-(void)cancelNumberPad
{
    [self.textField resignFirstResponder];
    self.textField.text = @"";
}
-(void)doneWithNumberPad
{
    [self.textField resignFirstResponder];
}


- (BOOL)entryComplete {
    // Never allow auto-advancing out of postal code field since there is no way to know that the
    // input value constitutes a complete postal code.
    return NO;
}

- (BOOL)valid {
    return self.postalCode.length > 0;
}

- (void)fieldContentDidChange {
    _postalCode = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.displayAsValid = YES;
    [super fieldContentDidChange];
    [self.delegate formFieldDidChange:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.displayAsValid = YES;
    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.displayAsValid = YES;
    [super textFieldDidEndEditing:textField];
}

@end
