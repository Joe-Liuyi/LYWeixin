//
//  LYHomeViewController.m
//  LYWeiXin
//
//  Created by Joe on 16/7/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYHomeViewController.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import <CFNetwork/CFNetwork.h>
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

#define LYLogFunc NSLog(@"%s\t\t\t\t%d", __func__, [NSThread currentThread].isMainThread);

#define kAccount @"zhangsan"
#define kPassword @"liu6569567"
#define kDomain @"liuyi.local"
#define kHostName @"127.0.0.1"
#define kHostPort 5222

@interface LYHomeViewController () <XMPPStreamDelegate> {
    XMPPStream *xmppStream;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginBtn;
@end

@implementation LYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupXMPPStream];
}


- (IBAction)login:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"登录"]) {
        [self connectToHost];
    } else {
        sender.title = @"登录";
        [self disconnect];
    }
}

// 1. 初始化XMPPStream
- (void)setupXMPPStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    xmppStream.enableBackgroundingOnSocket = YES;
    xmppStream.hostName = kHostName;
    xmppStream.hostPort = kHostPort;
}


// 2.连接到服务器
- (void)connectToHost {
    if (![xmppStream isDisconnected]) {
        NSLog(@"已经连接");
        return;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithUser:kAccount domain:kDomain resource:@"iOS"]];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        DDLogError(@"Error connecting: %@", error);
    }
}


// 3.连接到服务成功后，再发送密码授权
- (void)sendPwdToHost {
    NSError *error = nil;
    if (![xmppStream authenticateWithPassword:kPassword error:&error]) {
        DDLogError(@"Error authenticating: %@", error);
    }
}


// 4.授权成功后，发送"在线" 消息
- (void)sendOnlineToHost {
    dispatch_async(dispatch_get_main_queue(), ^{
        _loginBtn.title = @"断开";
    });
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    // Google set their presence priority to 24, so we do the same to be compatible.
    NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
    [presence addChild:priority];
    
    [xmppStream sendElement:presence];
}

- (void)disconnect{
    // 1." 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [xmppStream disconnect];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

    // Configure the cell...

    return cell;
}
*/


/**
 * This method is called if the XMPP Stream's jid changes.
 **/
- (void)xmppStreamDidChangeMyJID:(XMPPStream *)xmppStream {
    LYLogFunc
}

/**
 * This method is called before the stream begins the connection process.
 *
 * If developing an iOS app that runs in the background, this may be a good place to indicate
 * that this is a task that needs to continue running in the background.
 **/
- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    LYLogFunc
}


/**
 * This method is called after the tcp socket has connected to the remote host.
 * It may be used as a hook for various things, such as updating the UI or extracting the server's IP address.
 *
 * If developing an iOS app that runs in the background,
 * please use XMPPStream's enableBackgroundingOnSocket property as opposed to doing it directly on the socket here.
 **/
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    LYLogFunc
}
/**
 * This method is called after a TCP connection has been established with the server,
 * and the opening XML stream negotiation has started.
 **/
- (void)xmppStreamDidStartNegotiation:(XMPPStream *)sender {
    LYLogFunc
}
/**
 * This method is called immediately prior to the stream being secured via TLS/SSL.
 * Note that this delegate may be called even if you do not explicitly invoke the startTLS method.
 * Servers have the option of requiring connections to be secured during the opening process.
 * If this is the case, the XMPPStream will automatically attempt to properly secure the connection.
 *
 * The possible keys and values for the security settings are well documented.
 * Some possible keys are:
 * - kCFStreamSSLLevel
 * - kCFStreamSSLAllowsExpiredCertificates
 * - kCFStreamSSLAllowsExpiredRoots
 * - kCFStreamSSLAllowsAnyRoot
 * - kCFStreamSSLValidatesCertificateChain
 * - kCFStreamSSLPeerName
 * - kCFStreamSSLCertificates
 *
 * Please refer to Apple's documentation for associated values, as well as other possible keys.
 *
 * The dictionary of settings is what will be passed to the startTLS method of ther underlying AsyncSocket.
 * The AsyncSocket header file also contains a discussion of the security consequences of various options.
 * It is recommended reading if you are planning on implementing this method.
 *
 * The dictionary of settings that are initially passed will be an empty dictionary.
 * If you choose not to implement this method, or simply do not edit the dictionary,
 * then the default settings will be used.
 * That is, the kCFStreamSSLPeerName will be set to the configured host name,
 * and the default security validation checks will be performed.
 *
 * This means that authentication will fail if the name on the X509 certificate of
 * the server does not match the value of the hostname for the xmpp stream.
 * It will also fail if the certificate is self-signed, or if it is expired, etc.
 *
 * These settings are most likely the right fit for most production environments,
 * but may need to be tweaked for development or testing,
 * where the development server may be using a self-signed certificate.
 **/
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
    LYLogFunc
}
/**
 * This method is called after the stream has been secured via SSL/TLS.
 * This method may be called if the server required a secure connection during the opening process,
 * or if the secureConnection: method was manually invoked.
 **/
- (void)xmppStreamDidSecure:(XMPPStream *)sender {
    LYLogFunc
}
/**
 * This method is called after the XML stream has been fully opened.
 * More precisely, this method is called after an opening <xml/> and <stream:stream/> tag have been sent and received,
 * and after the stream features have been received, and any required features have been fullfilled.
 * At this point it's safe to begin communication with the server.
 **/
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    LYLogFunc NSLog(@"成功连接");
    
    [self sendPwdToHost];
}
/**
 * This method is called after registration of a new user has successfully finished.
 * If registration fails for some reason, the xmppStream:didNotRegister: method will be called instead.
 **/
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    LYLogFunc
}
/**
 * This method is called if registration fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    LYLogFunc
}
/**
 * This method is called after authentication has successfully finished.
 * If authentication fails for some reason, the xmppStream:didNotAuthenticate: method will be called instead.
 **/
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    LYLogFunc NSLog(@"授权成功");
    [self sendOnlineToHost];
}

/**
 * This method is called if authentication fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    LYLogFunc NSLog(@"授权失败 %@", error);
}
/**
 * This method is called if the XMPP server doesn't allow our resource of choice
 * because it conflicts with an existing resource.
 *
 * Return an alternative resource or return nil to let the server automatically pick a resource for us.
 **/
//- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource {
//    
//}
/**
 * These methods are called before their respective XML elements are broadcast as received to the rest of the stack.
 * These methods can be used to modify elements on the fly.
 * (E.g. perform custom decryption so the rest of the stack sees readable text.)
 *
 * You may also filter incoming elements by returning nil.
 *
 * When implementing these methods to modify the element, you do not need to copy the given element.
 * You can simply edit the given element, and return it.
 * The reason these methods return an element, instead of void, is to allow filtering.
 *
 * Concerning thread-safety, delegates implementing the method are invoked one-at-a-time to
 * allow thread-safe modification of the given elements.
 *
 * You should NOT implement these methods unless you have good reason to do so.
 * For general processing and notification of received elements, please use xmppStream:didReceiveX: methods.
 *
 * @see xmppStream:didReceiveIQ:
 * @see xmppStream:didReceiveMessage:
 * @see xmppStream:didReceivePresence:
 **/
//- (XMPPIQ *)xmppStream:(XMPPStream *)sender willReceiveIQ:(XMPPIQ *)iq {
//    LYLogFunc
//}
//- (XMPPMessage *)xmppStream:(XMPPStream *)sender willReceiveMessage:(XMPPMessage *)message {
//    LYLogFunc
//}
//- (XMPPPresence *)xmppStream:(XMPPStream *)sender willReceivePresence:(XMPPPresence *)presence {
//    LYLogFunc
//}

/**
 * These methods are called after their respective XML elements are received on the stream.
 *
 * In the case of an IQ, the delegate method should return YES if it has or will respond to the given IQ.
 * If the IQ is of type 'get' or 'set', and no delegates respond to the IQ,
 * then xmpp stream will automatically send an error response.
 *
 * Concerning thread-safety, delegates shouldn't modify the given elements.
 * As documented in NSXML / KissXML, elements are read-access thread-safe, but write-access thread-unsafe.
 * If you have need to modify an element for any reason,
 * you should copy the element first, and then modify and use the copy.
 **/
//- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
//    LYLogFunc
//}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    LYLogFunc
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    LYLogFunc
}

/**
 * This method is called if an XMPP error is received.
 * In other words, a <stream:error/>.
 *
 * However, this method may also be called for any unrecognized xml stanzas.
 *
 * Note that standard errors (<iq type='error'/> for example) are delivered normally,
 * via the other didReceive...: methods.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error {
    LYLogFunc
}

/**
 * These methods are called before their respective XML elements are sent over the stream.
 * These methods can be used to modify outgoing elements on the fly.
 * (E.g. add standard information for custom protocols.)
 *
 * You may also filter outgoing elements by returning nil.
 *
 * When implementing these methods to modify the element, you do not need to copy the given element.
 * You can simply edit the given element, and return it.
 * The reason these methods return an element, instead of void, is to allow filtering.
 *
 * Concerning thread-safety, delegates implementing the method are invoked one-at-a-time to
 * allow thread-safe modification of the given elements.
 *
 * You should NOT implement these methods unless you have good reason to do so.
 * For general processing and notification of sent elements, please use xmppStream:didSendX: methods.
 *
 * @see xmppStream:didSendIQ:
 * @see xmppStream:didSendMessage:
 * @see xmppStream:didSendPresence:
 **/
//- (XMPPIQ *)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq {
//    LYLogFunc
//}
//- (XMPPMessage *)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message {
//    LYLogFunc
//}
//- (XMPPPresence *)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence {
//    LYLogFunc
//}

/**
 * These methods are called after their respective XML elements are sent over the stream.
 * These methods may be used to listen for certain events (such as an unavailable presence having been sent),
 * or for general logging purposes. (E.g. a central history logging mechanism).
 **/
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq {
    LYLogFunc
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    LYLogFunc
}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence {
    LYLogFunc NSLog(@"发送状态 %@", presence.type);
}

/**
 * These methods are called after failing to send the respective XML elements over the stream.
 **/
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error {
    LYLogFunc
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    LYLogFunc
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error {
    LYLogFunc
}



/**
 * This method is called if the disconnect method is called.
 * It may be used to determine if a disconnection was purposeful, or due to an error.
 **/
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender {
    LYLogFunc
}

/**
 * This methods is called if the XMPP Stream's connect times out
 **/
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    LYLogFunc
}

/**
 * This method is called after the stream is closed.
 *
 * The given error parameter will be non-nil if the error was due to something outside the general xmpp realm.
 * Some examples:
 * - The TCP socket was unexpectedly disconnected.
 * - The SRV resolution of the domain failed.
 * - Error parsing xml sent from server.
 **/
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    LYLogFunc NSLog(@"断开连接");
}

/**
 * This method is only used in P2P mode when the connectTo:withAddress: method was used.
 *
 * It allows the delegate to read the <stream:features/> element if/when they arrive.
 * Recall that the XEP specifies that <stream:features/> SHOULD be sent.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveP2PFeatures:(NSXMLElement *)streamFeatures {
    LYLogFunc
}

/**
 * This method is only used in P2P mode when the connectTo:withSocket: method was used.
 *
 * It allows the delegate to customize the <stream:features/> element,
 * adding any specific featues the delegate might support.
 **/
- (void)xmppStream:(XMPPStream *)sender willSendP2PFeatures:(NSXMLElement *)streamFeatures {
    LYLogFunc
}

/**
 * These methods are called as xmpp modules are registered and unregistered with the stream.
 * This generally corresponds to xmpp modules being initailzed and deallocated.
 *
 * The methods may be useful, for example, if a more precise auto delegation mechanism is needed
 * than what is available with the autoAddDelegate:toModulesOfClass: method.
 **/
- (void)xmppStream:(XMPPStream *)sender didRegisterModule:(id)module {
    LYLogFunc
}
- (void)xmppStream:(XMPPStream *)sender willUnregisterModule:(id)module {
    LYLogFunc
}

@end
