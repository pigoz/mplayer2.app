//
//  mplayer2Tests.m
//  mplayer2Tests
//
//  Created by Stefano Pigozzi on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Kiwi/Kiwi.h>

SPEC_BEGIN(MPSpec)

describe(@"something", ^{
    context(@"when newly created", ^{
        it(@"knows maths", ^{
            [[theValue(2+2) should] equal: theValue(4)];
        });
    });
});

SPEC_END
