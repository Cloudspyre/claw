// The MIT License (MIT)
//
// Copyright (c) 2013-2014 Cloudspyre, LLC and Atlantic Apps, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
//  ViewController.m
//  DaClaw
//
//  Created by Stephen Jernigan on 12/12/13.
//  Copyright (c) 2013 Stephen Jernigan. All rights reserved.
//

#import "ViewController.h"
#import "sendgrid.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize ble;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [[UIAccelerometer sharedAccelerometer]setDelegate:self];
    //Do any additional setup after loading the view,typically from a nib

    ble = [[BLE alloc] init];
    [ble controlSetup:1];
    ble.delegate = self;
    indConnecting.hidden = YES;
    
    self.x = 50;
    self.y = 50;
    self.distance = 50;
    
    [super viewDidLoad];
}

// Connect button will call to this
- (IBAction)btnScanForPeripherals:(id)sender
{
    if (ble.activePeripheral)
        if(ble.activePeripheral.isConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [btnConnect setEnabled:false];
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    indConnecting.hidden = NO;
    [indConnecting startAnimating];
}

-(void) connectionTimer:(NSTimer *)timer
{
    [btnConnect setEnabled:true];
    lblConnectButton.text = @"Disconnect";
    //    [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    else
    {
        //        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        lblConnectButton.text = @"Connect";
        indConnecting.hidden = YES;
        [indConnecting stopAnimating];
    }
}

-(void) sendTimer:(NSTimer *)timer
{
    NSLog(@"Timer event!");
    UInt8 bufdistance[3] = {0x03, 0x50, 0x00};
    
    bufdistance[1] = self.distance;
    
    NSData *datadistance = [[NSData alloc] initWithBytes:bufdistance length:3];
    [ble write:datadistance];
    
    UInt8 bufx[3] = {0x01, 0x50, 0x00};
    
    bufx[1] = self.x;
    
    NSData *datax = [[NSData alloc] initWithBytes:bufx length:3];
    [ble write:datax];
    
    UInt8 bufy[3] = {0x02, 0x50, 0x00};
    
    bufy[1] = self.y;
    
    NSData *datay = [[NSData alloc] initWithBytes:bufy length:3];
    [ble write:datay];
    

}

-(void)sendEmail {
    
    //create Email Object
    // put your own user/pass in here if you want the SendGrid piece to work
    sendgrid *msg = [sendgrid user:@"myuser" andPass:@"mypassword"];
    
    //set parameters
    msg.subject = @"Da Claw SendGrid Diagnostics";
    msg.to = @"steve@cloudspyre.com";
    
    msg.from = @"daclaw@daclaw.com";
    NSString *msgString = [NSString stringWithFormat:@"X: %d  Y: %d  Claw: %d",self.x, self.y, self.distance];

    msg.text = msgString;
    msg.html = msgString;
    
    [msg sendWithWeb];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:
(UIAcceleration *)acceleration{
    NSInteger localy = -(acceleration.y * 100);
    if (localy < 0) {
        localy = 0;
    }
    NSInteger localx = (acceleration.x * 50);
    if (localx < 0) {
        localx = 50 - (-(localx));
    }
    else {
        localx = localx + 50;
    }
    [xlabel setText:[NSString stringWithFormat:@"%d",localx]];
    [ylabel setText:[NSString stringWithFormat:@"%d",localy]];

    self.x = localx;
    self.y = localy;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint currentTouchPosition = [aTouch locationInView:self.view];
    
    NSInteger clawPosition = currentTouchPosition.y;
    if (clawPosition < 20) {
        clawPosition = 20;
    }
    if (clawPosition > 180) {
        clawPosition = 180;
    }
    self.distance = clawPosition - 20;
    self.distance = self.distance / 1.6;
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}


#pragma mark - BLE delegate

    - (void)bleDidDisconnect
    {
        NSLog(@"->Disconnected");
        
        lblConnectButton.text = @"Connect to Bluetooth";
        //    [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        indConnecting.hidden = YES;
        [indConnecting stopAnimating];
        
        //    lblRSSI.text = @"---";
        //   lblAnalogIn.text = @"----";
    }
    
    // When RSSI is changed, this will be called
    -(void) bleDidUpdateRSSI:(NSNumber *) rssi
    {
        //    lblRSSI.text = rssi.stringValue;
    }
    
    // When disconnected, this will be called
    -(void) bleDidConnect
    {
        NSLog(@"->Connected");
        
        indConnecting.hidden = YES;
        [indConnecting stopAnimating];
        
        lblConnectButton.text = @"Disconnect";
        [NSTimer scheduledTimerWithTimeInterval:(float)0.20 target:self selector:@selector(sendTimer:) userInfo:nil repeats:YES];
        
    }



    
    


@end
