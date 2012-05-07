#import <Kiwi/Kiwi.h>
#import <MPlayer.h>

SPEC_BEGIN(MPlayerSpec)

describe(@"MPlayer", ^{
    context(@"when newly created", ^{
        __block id subject;
        
        beforeEach(^{
            subject = [MPlayer new];
        });
        
        afterEach(^{
            [subject release];
            subject = nil;
        });
        
        it(@"is idle", ^{
            [[theValue([subject playing]) should] equal:theValue(NO)];
        });
        
    });
});

SPEC_END
