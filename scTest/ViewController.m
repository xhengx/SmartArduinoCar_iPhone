//
//  ViewController.m
//  scTest
//
//  Created by honey on 04/11/2016.
//  Copyright © 2016 honey. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

@interface ViewController () <GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_socket;
    BOOL _state;
    dispatch_queue_t _message_queue;
    NSInteger lastValue;
    
    GCDAsyncUdpSocket *_udp;
    
}
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _message_queue = dispatch_queue_create("message_queue", DISPATCH_QUEUE_CONCURRENT);
    
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:_message_queue];
    _udp = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:_message_queue];
    
  
    _state = NO;
//    [_socket connectToHost:@"192.168.4.1" onPort:8080 withTimeout:-1 error:nil];
    
}
- (IBAction)moveFrom:(id)sender {
    [self sendControl:@"from"];
}
- (IBAction)moveRight:(id)sender {
    [self sendControl:@"right"];
}
- (IBAction)moveBack:(id)sender {
    [self sendControl:@"back"];
}
- (IBAction)moveLeft:(id)sender {
    [self sendControl:@"left"];
}
- (IBAction)stop:(id)sender {
    [self sendControl:@"stop"];
}
- (IBAction)moveAuto:(UISwitch *)sender {
    [self sendControl:@"auto"];
}


- (IBAction)speed:(UISlider *)sender {
    
    if ((NSInteger)sender.value != lastValue) {
        NSString *value = [NSString stringWithFormat:@"speed:%ld", (NSInteger)sender.value];
        [self sendControl:value];
        
        lastValue = sender.value;
        
        NSLog(@"%@", value);
    }
}


- (void)sendControl:(NSString *)controlMessage {
    
    
    NSString *send = [controlMessage stringByAppendingString:@"\n"];
    
    NSData *data = [send dataUsingEncoding:NSUTF8StringEncoding];
    
//    [_socket writeData:data withTimeout:-1 tag:1000];
    
    [_udp sendData:data toHost:@"192.168.4.1" port:8889 withTimeout:-1 tag:1000];
    
    
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"conneect...");
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"success write");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
