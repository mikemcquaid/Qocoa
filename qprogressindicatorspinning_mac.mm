/*
Copyright (C) 2011 by Mike McQuaid

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

#include "qprogressindicatorspinning.h"

#include "qocoa_mac.h"

#import "Foundation/NSAutoreleasePool.h"
#import "AppKit/NSProgressIndicator.h"

QProgressIndicatorSpinning::QProgressIndicatorSpinning(QWidget *parent) : QWidget(parent)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSProgressIndicator *progress = [[NSProgressIndicator alloc] init];
    [progress setStyle:NSProgressIndicatorSpinningStyle];
    // TODO: This doesn't work yet.
    [progress startAnimation:nil];

    zeroLayout(progress, this);

    setMinimumSize(16, 16);
    setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);

    [progress release];

    [pool drain];
}
