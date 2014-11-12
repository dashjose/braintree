#import "BraintreeDemoTokenizationDemoViewController.h"

#import <Braintree/Braintree.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>

@interface BraintreeDemoTokenizationDemoViewController ()

@property (nonatomic, strong) Braintree *braintree;
@property (nonatomic, copy) void (^completionBlock)(NSString *);

@property (nonatomic, strong) IBOutlet UITextField *cardNumberField;
@property (nonatomic, strong) IBOutlet UITextField *expirationMonthField;
@property (nonatomic, strong) IBOutlet UITextField *expirationYearField;
@end

@implementation BraintreeDemoTokenizationDemoViewController

- (instancetype)initWithBraintree:(Braintree *)braintree completion:(void (^)(NSString *))completionBlock {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.braintree = braintree;
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"tokenization?!");
    [super viewDidLoad];

    self.title = @"Tokenization";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                              target:self
                                                                                              action:@selector(submitForm)],
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                              target:self
                                                                                              action:@selector(setupDemoData)]
                                                ];
}

- (void)viewDidAppear:(__unused BOOL)animated {
    [self.cardNumberField becomeFirstResponder];
}

- (void)submitForm {
    NSLog(@"Tokenizing card!");
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.braintree tokenizeCardWithNumber:self.cardNumberField.text
                           expirationMonth:self.expirationMonthField.text
                            expirationYear:self.expirationYearField.text
                                completion:^(NSString *nonce, NSError *error) {
                                    [self.navigationItem.rightBarButtonItem setEnabled:YES];
                                    if (error) {
                                        NSLog(@"Error: %@", error);
                                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil] show];
                                    }

                                    if (nonce) {
                                        NSLog(@"Card tokenized -> Nonce Received: %@", nonce);
                                        [UIAlertView showWithTitle:@"Success"
                                                           message:@"Nonce Received"
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil
                                                          tapBlock:^(__unused UIAlertView *alertView, __unused NSInteger buttonIndex) {
                                                              self.completionBlock(nonce);
                                                          }];
                                    }
                                }];
}

- (void)setupDemoData {
    self.cardNumberField.text = @"4111111111111111";
    self.expirationMonthField.text = @"12";
    self.expirationYearField.text = @"2038";
}

#pragma mark Table View Overrides

- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(__unused NSInteger)section {
    return @"Custom Card Form";
}

@end