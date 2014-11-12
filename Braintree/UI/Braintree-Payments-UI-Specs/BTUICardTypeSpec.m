#import "BTUICardType.h"
#import "EXPMatchers+haveKerning.h"

SpecBegin(BTUICardType)

describe(@"BTUICardType", ^{

    it(@"should only have one instance of each brand", ^{
        BTUICardType *t1 = [BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)];
        BTUICardType *t2 = [BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)];
        expect(t1).to.beIdenticalTo(t2);
    });

    describe(@"possible card types for number", ^{

        it(@"should recognize all cards with empty string", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@""];
            expect(possibleCardTypes.count).to.equal(9);
        });

        it(@"should recognize no cards starting with 1", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"1"];
            expect(possibleCardTypes.count).to.equal(0);
        });

        it(@"should recognize AmEx and Diners Club and JCB cards with 3", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"3"];
            expect(possibleCardTypes.count).to.equal(3);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_DINERS_CLUB)]);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)]);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_JCB)]);
        });

        it(@"should recognize MasterCard and Maestro with a 5", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"5"];
            expect(possibleCardTypes.count).to.equal(2);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MASTER_CARD)]);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MAESTRO)]);
        });

        it(@"should recognize the start of a Visa", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"4"];
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
            expect(possibleCardTypes.count).to.equal(1);
        });

        it(@"should recognize a whole Visa", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"4111111111111111"];
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
            expect(possibleCardTypes.count).to.equal(1);
        });
    });

    describe(@"card number recognition", ^{

        it(@"should recognize a valid, formatted Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4111 1111 1111 1111"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize an invalid Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4111 1111 1111 1112"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize a non-formatted Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4111111111111111"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize an incomplete Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize a valid MasterCard", ^{
            expect([BTUICardType cardTypeForNumber:@"5555555555554444"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MASTER_CARD)]);
        });

        it(@"should recognize a valid American Express", ^{
            expect([BTUICardType cardTypeForNumber:@"378282246310005"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)]);
        });

        it(@"should recognize a valid Discover", ^{
            expect([BTUICardType cardTypeForNumber:@"6011 1111 1111 1117"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_DISCOVER)]);
        });

        it(@"should recognize a valid JCB", ^{
            expect([BTUICardType cardTypeForNumber:@"3530 1113 3330 0000"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_JCB)]);
        });

        it(@"should not recognize a non-number", ^{
            expect([BTUICardType cardTypeForNumber:@"notanumber"]).to.beNil();
        });

        it(@"should not recognize an unrecognizable number", ^{
            expect([BTUICardType cardTypeForNumber:@"notanumber"]).to.beNil();
        });

    });


    describe(@"card number formatting", ^{

        it(@"should format a non-number as an empty string", ^{
            expect([[[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"notanumber"] string]).to.equal(@"");
        });

        it(@"should return a too-long number without formatting", ^{
            expect([[[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"00000000000000000"] string]).to.equal(@"00000000000000000");
        });

        it(@"should format a valid, formatted number as a Visa", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"0000 0000 0000 0000"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format a non-formatted number as a Visa", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"0000000000000000"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format an incomplete number as a Visa", ^{
            expect([[[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"0"] string]).to.equal(@"0");
        });

        it(@"should format as a MasterCard", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MASTER_CARD)] formatNumber:@"0000000000000000"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format as an American Express", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)] formatNumber:@"000000000000000"]).to.haveKerning(@[@3, @9]);
        });

        it(@"should format as an incomplete American Express", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)] formatNumber:@"00000"]).to.haveKerning(@[@3]);
        });

        it(@"should format as a Discover", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_DISCOVER)] formatNumber:@"1234123412341234"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format as a JCB", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_JCB)] formatNumber:@"1234123412341234"]).to.haveKerning(@[@3, @7, @11]);
        });
    });
});

SpecEnd