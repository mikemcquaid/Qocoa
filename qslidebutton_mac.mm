/*
 Copyright (C) 2012 by Leo Franchi <lfranchi@kde.org>

 MBSliderButton mostly extracted from
  https://github.com/mxcl/playdar.prefpane/blob/master/MBSliderButton.m
 Copyright 2009 Max Howell <max@methylblue.com>, GPL

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#include "qslidebutton.h"

#include "qocoa_mac.h"

#import "Foundation/NSAutoreleasePool.h"
#import "AppKit/NSButton.h"
#import "AppKit/NSFont.h"

#include <QDebug>

#define KNOB_WIDTH 38
#define HEIGHT 26
#define WIDTH 89
#define KNOB_MIN_X 0
#define KNOB_MAX_X (WIDTH-KNOB_WIDTH)

@interface QSlideButtonTarget : NSObject
{
@public
    QPointer<QSlideButtonPrivate> pimpl;
}
-(void)clicked:(BOOL)checked;
@end

@interface MBSliderButton : NSControl<NSAnimationDelegate>
{
    QSlideButtonTarget* theDelegate;
    NSPoint location;
    NSImage* knob;
    NSImage* surround;
    NSString *onText;
    NSString *offText;
    bool state;
}

-(id)initWithState:(NSInteger)on;
-(void)setDelegate:(QSlideButtonTarget*)del;
-(void)moveLeft:(id)sender;
-(void)moveRight:(id)sender;

-(NSInteger)state;
-(void)setState:(NSInteger)newstate;
-(void)setState:(NSInteger)newstate animate:(bool)animate;

-(void)setOnString:(NSString*)on;
-(void)setOffString:(NSString*)off;

@end


@interface MBKnobAnimation : NSAnimation
{
    int start, range;
    id delegate;
}
@end
@implementation MBKnobAnimation
-(id)initWithStart:(int)begin end:(int)end
{
    [super init];
    start = begin;
    range = end - begin;
    return self;
}
-(void)setCurrentProgress:(NSAnimationProgress)progress
{
    int x = start+progress*range;
    [super setCurrentProgress:progress];
    [delegate performSelector:@selector(setPosition:) withObject:[NSNumber numberWithInteger:x]];
}
-(void)setDelegate:(id)d
{
    delegate = d;
}
@end

@implementation MBSliderButton

-(id)initWithState:(NSInteger)on
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    [super init];

    onText = [[NSString alloc] initWithString:@"On"];
    offText = [[NSString alloc] initWithString:@"Off"];

    surround = [fromQPixmap(QPixmap(":/button_surround.png")) retain];
    knob = [fromQPixmap(QPixmap(":/button_knob.png")) retain];

    state = on;

    [pool drain];

    return self;
}

-(void)setDelegate:(QSlideButtonTarget*)del
{
     theDelegate = del;
}

-(void)drawRect:(NSRect)rect
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    NSColor* darkBlue = [NSColor colorWithDeviceRed:0.031 green:0.212 blue:0.535 alpha:1.0];
    NSColor* lightBlue = [NSColor colorWithDeviceRed:0.461 green:0.676 blue:0.940 alpha:1.0];
    NSColor* darkGray = [NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    NSColor* lightGray = [NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:1.0];

    NSGradient* blue_gradient = [[NSGradient alloc] initWithStartingColor:darkBlue endingColor:lightBlue];
    NSGradient* gray_gradient = [[NSGradient alloc] initWithStartingColor:darkGray endingColor:lightGray];

    [blue_gradient drawInRect:NSMakeRect(0, location.y, location.x+10, HEIGHT) angle:270];

    NSMutableDictionary* attr = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont boldSystemFontOfSize:15.0], NSFontAttributeName,
                                 [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0], NSForegroundColorAttributeName,
                                 nil];

    NSSize sz = [onText sizeWithAttributes:attr];
    NSPoint pt;
    pt.x = (KNOB_MAX_X-sz.width)/2 - (KNOB_MAX_X-location.x);
    pt.y = HEIGHT/2 - sz.height/2;
    [onText drawAtPoint:pt withAttributes:attr];

    int x = location.x+KNOB_WIDTH-2;
    [gray_gradient drawInRect:NSMakeRect(x, location.y, WIDTH-x, HEIGHT) angle:270];

    [attr setObject:[NSColor colorWithDeviceWhite:0.2 alpha:0.66] forKey:NSForegroundColorAttributeName];
    sz = [offText sizeWithAttributes:attr];
    pt.x = location.x+KNOB_WIDTH+(KNOB_MAX_X-sz.width)/2;
    [offText drawAtPoint:pt withAttributes:attr];


    [surround drawAtPoint:NSMakePoint(0,0) fromRect:NSZeroRect
                operation:NSCompositeSourceOver
                 fraction:1.0];
    pt = location;
    pt.x -= 2;
    [knob drawAtPoint:pt fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

    [pool drain];
}

-(BOOL)isOpaque
{
    return YES;
}

-(NSInteger)state
{
    return state ? NSOnState : NSOffState;
}

-(void)animateTo:(int)x
{
    MBKnobAnimation* a = [[MBKnobAnimation alloc] initWithStart:location.x end:x];
    [a setDelegate:self];
    if (location.x == 0 || location.x == KNOB_MAX_X){
        [a setDuration:0.20];
        [a setAnimationCurve:NSAnimationEaseInOut];
    }else{
        [a setDuration:0.35 * ((fabs(location.x-x))/KNOB_MAX_X)];
        [a setAnimationCurve:NSAnimationLinear];
    }

    [a setAnimationBlockingMode:NSAnimationBlocking];
    [a startAnimation];
    [a release];
}

-(void)setPosition:(NSNumber*)x
{
    location.x = [x intValue];
    [self display];
}

-(void)setState:(NSInteger)newstate
{
    [self setState:newstate animate:true];
}

-(void)setState:(NSInteger)newstate animate:(bool)animate
{
    if(newstate == [self state])
        return;

    int x = newstate == NSOnState ? KNOB_MAX_X : 0;

    //TODO animate if  we are visible and otherwise don't
    if(animate)
        [self animateTo:x];
    else
        [self setNeedsDisplay:YES];

    state = newstate == NSOnState ? true : false;
    location.x = x;
}

-(void)offsetLocationByX:(float)x
{
    location.x = location.x + x;

    if (location.x < KNOB_MIN_X) location.x = KNOB_MIN_X;
    if (location.x > KNOB_MAX_X) location.x = KNOB_MAX_X;

    [self setNeedsDisplay:YES];
}

-(void)mouseDown:(NSEvent *)event
{
    BOOL loop = YES;

    // convert the initial click location into the view coords
    NSPoint clickLocation = [self convertPoint:[event locationInWindow] fromView:nil];

    // did the click occur in the draggable item?
    if (NSPointInRect(clickLocation, [self bounds])) {

        NSPoint newDragLocation;

        // the tight event loop pattern doesn't require the use
        // of any instance variables, so we'll use a local
        // variable localLastDragLocation instead.
        NSPoint localLastDragLocation;

        // save the starting location as the first relative point
        localLastDragLocation=clickLocation;

        while (loop) {
            // get the next event that is a mouse-up or mouse-dragged event
            NSEvent *localEvent;
            localEvent= [[self window] nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask];


            switch ([localEvent type]) {
                case NSLeftMouseDragged:

                    // convert the new drag location into the view coords
                    newDragLocation = [self convertPoint:[localEvent locationInWindow]
                                                fromView:nil];


                    // offset the item and update the display
                    [self offsetLocationByX:(newDragLocation.x-localLastDragLocation.x)];

                    // update the relative drag location;
                    localLastDragLocation = newDragLocation;

                    // support automatic scrolling during a drag
                    // by calling NSView's autoscroll: method
                    [self autoscroll:localEvent];

                    break;
                case NSLeftMouseUp:
                    // mouse up has been detected,
                    // we can exit the loop
                    loop = NO;

                    if (memcmp(&clickLocation, &localLastDragLocation, sizeof(NSPoint)) == 0)
                        [self animateTo:state ? 0 : KNOB_MAX_X];
                    else if (location.x > 0 && location.x < KNOB_MAX_X)
                        [self animateTo:state ? KNOB_MAX_X : 0];

                    //TODO if let go of it halfway then slide to non destructive side

                    if((location.x == 0 && state) || (location.x == KNOB_MAX_X && !state)) {
                        state = !state;
                        [theDelegate clicked:state];
                    }

                    // the rectangle has moved, we need to reset our cursor
                    // rectangle
                    [[self window] invalidateCursorRectsForView:self];

                    break;
                default:
                    // Ignore any other kind of event.
                    break;
            }
        }
    };
    return;
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)moveLeft:(id)sender
{
    [self offsetLocationByX:-10.0];
    [[self window] invalidateCursorRectsForView:self];
}

-(void)moveRight:(id)sender
{
    [self offsetLocationByX:10.0];
    [[self window] invalidateCursorRectsForView:self];
}

-(void)setOnString:(NSString *)on
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    [onText release];
    onText = on;
    [onText retain];

    [pool release];
}

-(void)setOffString:(NSString *)off
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    [offText release];
    offText = off;
    [offText retain];

    [pool release];
}
@end

class QSlideButtonPrivate : public QObject
{
public:
    QSlideButtonPrivate(QSlideButton *q, MBSliderButton *slider)
        : QObject(q), qSlider(q), slider(slider)
    {
    }

    void clicked(bool checked) {
        qSlider->clicked(checked);
    }

    QSlideButton *qSlider;
    MBSliderButton *slider;
};

@implementation QSlideButtonTarget
-(void)clicked:(BOOL)checked {
    Q_ASSERT(pimpl);
    if (pimpl)
        pimpl->clicked(checked);
}
@end


QSlideButton::QSlideButton(QWidget *parent) : QWidget(parent)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    MBSliderButton *slider = [[MBSliderButton alloc] initWithState:NSOffState];
    pimpl = new QSlideButtonPrivate(this, slider);

    QSlideButtonTarget *target = [[QSlideButtonTarget alloc] init];
    target->pimpl = pimpl;

    [slider setDelegate:target];

    setupLayout(slider, this);

    setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    [slider release];

    [pool drain];
}

QSize QSlideButton::sizeHint() const
{
    return QSize(WIDTH, HEIGHT);
}


void QSlideButton::setOnText(const QString &text)
{
    Q_ASSERT(pimpl);
    if (!pimpl)
        return;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [pimpl->slider setOnString:fromQString(text)];
    [pool drain];
}

void QSlideButton::setOffText(const QString &text)
{
    Q_ASSERT(pimpl);
    if (!pimpl)
        return;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [pimpl->slider setOffString:fromQString(text)];
    [pool drain];
}

void QSlideButton::setChecked(bool checked)
{
    Q_ASSERT(pimpl);
    if (pimpl)
        [pimpl->slider setState:(checked ? NSOnState : NSOffState) animate:YES];
}

bool QSlideButton::isChecked()
{
    Q_ASSERT(pimpl);
    if (!pimpl)
        return false;

    return [pimpl->slider state] == NSOnState;
}
