#import "BraintreeDemoPaymentsUIComponentsViewController.h"
#import "BTUIPaymentMethodView.h"
#import "BTUICTAControl.h"

@interface BraintreeDemoPaymentsUIComponentsViewController ()
@property (nonatomic, weak) IBOutlet BTUIPaymentMethodView *cardPaymentMethodView;
@property (nonatomic, weak) IBOutlet UISwitch *processingSwitch;
@property (nonatomic, weak) IBOutlet BTUICTAControl *ctaControl;
@end

@implementation BraintreeDemoPaymentsUIComponentsViewController

- (void)viewDidLoad
{
    NSLog(@"right demo?!");
    [super viewDidLoad];

    [self.processingSwitch setOn:self.cardPaymentMethodView.isProcessing];
}

- (IBAction)tappedCTAControl:(id)sender {
    NSLog(@"Tapped CTA");
}

- (IBAction)tappedSwapCardType {
    [self.cardPaymentMethodView setType:((self.cardPaymentMethodView.type+1) % (BTUIPaymentMethodTypePayPal+1))];
}

- (IBAction)toggledProcessingState:(UISwitch *)sender {
    self.cardPaymentMethodView.processing = sender.on;
}
- (IBAction)toggledCTAEnabled:(UISwitch *)sender {
    self.ctaControl.enabled = sender.on;
}

@end
