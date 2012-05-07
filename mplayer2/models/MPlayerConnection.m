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

#include "MPlayerConnection.h"

#pragma mark private methods
@interface MPlayerConnection (private)
- (void) observeHandle:(NSFileHandle *)fileHandle withCallback:(SEL)selector;
- (void) observeTaskTermination;
- (void) startReadingOnFileHandle:(NSFileHandle *) fileHandle;
- (NSFileHandle *) stdIn;
- (NSFileHandle *) stdOut;
- (NSFileHandle *) stdErr;
@end

@implementation MPlayerConnection (private)

- (void) observeHandle:(NSFileHandle *)fileHandle withCallback:(SEL)selector
{
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:selector
               name:NSFileHandleReadCompletionNotification
             object:fileHandle];
}

- (void) observeTaskTermination
{
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(taskHasTerminated:)
               name:NSTaskDidTerminateNotification
             object:task];
}

- (void) startReadingOnFileHandle:(NSFileHandle *)fileHandle
{
    [fileHandle readInBackgroundAndNotifyForModes:
        [NSArray arrayWithObjects:NSDefaultRunLoopMode, 
                                  NSModalPanelRunLoopMode,
                                  NSEventTrackingRunLoopMode,
                                  nil]];
}

- (NSFileHandle *) stdIn
{
    return [[task standardInput] fileHandleForReading];
}

- (NSFileHandle *) stdOut
{
    return [[task standardOutput] fileHandleForReading];
}

- (NSFileHandle *) stdErr
{
    return [[task standardError] fileHandleForReading];
}

@end

#pragma mark public methods
@implementation MPlayerConnection

-(id) init
{
    // fail on purpose, this method should never be called!
    return [self initWithFileName:nil andBinaryLocator:nil];
}

-(id) initWithFileName:(NSString *)fileName
      andBinaryLocator:(id <MPlayerLocator>)locator
{
    NSAssert(fileName != nil, @"fileName must be not nil. Please, contact the"
             " developers.");

    self = [super init];
    if (self) {
        task = [NSTask new];
        [task setStandardInput:[NSPipe pipe]];
        [task setStandardOutput:[NSPipe pipe]];
        [task setStandardError:[NSPipe pipe]];
        [task setLaunchPath:[(id <MPlayerLocator>)locator locate]];

        [self observeHandle:[self stdOut]
               withCallback:@selector(outputAvailable:)];
        [self observeHandle:[self stdErr]
               withCallback:@selector(errorAvailable:)];
        [self observeTaskTermination];

        [self startReadingOnFileHandle:[self stdOut]];
        [self startReadingOnFileHandle:[self stdErr]];

        [task launch];
    }

    return self;
}

- (BOOL) send:(NSString *) cmd
{
	if (task && [task isRunning]) {
		[[self stdIn] writeData:[cmd dataUsingEncoding:NSUTF8StringEncoding]];
		return YES;
	}
	return NO;
}

-(void) stop
{
    [task terminate];
    [task waitUntilExit];
}

-(void) outputAvailable:(NSNotification*)notification
{
    if (task && [task isRunning]) {
		NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
        #warning TODO: implement this later
        NSLog(@"output: %@", data);
        [self startReadingOnFileHandle:[self stdOut]];
	}
}

-(void) errorAvailable:(NSNotification*)notification
{
    if (task && [task isRunning]) {
		NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
        #warning TODO: implement this later
        NSLog(@"error: %@", data);
        [self startReadingOnFileHandle:[self stdErr]];
	}
}

-(void) taskHasTerminated:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end