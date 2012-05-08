/*
 * This file is part of mplayer2.app.
 *
 * mplayer2.app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * mplayer2.app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with mplayer2.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "MPlayer.h"
#include "MPlayerConnection.h"

@interface MPlayer (ConnectionDelegates) <MPlayerConnectionDelegate>
-(void) outputAvailable:(NSString *)error;
-(void) errorAvailable:(NSString *)error;
-(void) connectionEnded;
@end

@implementation MPlayer (ConnectionDelegates)
-(void) outputAvailable:(NSString *)error {}
-(void) errorAvailable:(NSString *)error {}
-(void) connectionEnded { [self stop]; }
@end

#pragma mark -
@implementation MPlayer
- (void) play:(NSString *)fileName
{
    if (!connection) {
        connection = [[MPlayerConnection alloc]
                         initWithFileName:fileName
                            binaryLocator:[MPlayerShellLocator new]
                       connectionDelegate:self];
    }
}

- (void) stop {
    [connection stop];
    [connection release];
    connection = nil;
}

- (BOOL) playing {
    return !!connection;
}

@end