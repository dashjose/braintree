#import "BTClient+BTVenmo.h"
#import "BTClient_Internal.h"
#import "BTClientToken+BTVenmo.h"

NSString *const BTVenmoStatusValueProduction = @"production";
NSString *const BTVenmoStatusValueOffline = @"offline";

@implementation BTClient (BTVenmo)

- (BTVenmoStatus)btVenmo_status {
    NSString *status = self.clientToken.btVenmo_status;
    if ([status isEqualToString:BTVenmoStatusValueProduction]) {
        return BTVenmoStatusProduction;
    } else if([status isEqualToString:BTVenmoStatusValueOffline]) {
        return BTVenmoStatusOffline;
    } else {
        return BTVenmoStatusOff;
    }
}

@end
