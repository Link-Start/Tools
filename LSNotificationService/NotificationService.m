//
//  NotificationService.m
//  LSNotificationService
//
//  Created by 刘晓龙 on 2023/8/10.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//  https://www.jianshu.com/p/8c362a6dcc0e
//  如果要支持扩展服务，一定要确保payload的aps字典中包含mutable-content字段，值为1。

#import "NotificationService.h"
// 语音播放需要
#import <AVFoundation/AVFoundation.h>

@interface NotificationService ()<AVSpeechSynthesizerDelegate>

/// 用于告知系统已经处理完成，可以将通知内容传给App的回调对象。
/// 该对象需要返回一个 UNMutableNotificationContnet 对象。一般都是返回 bestAttemptContent
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);

/// 通知消息的内容对象，里面包含了通知相关的所有信息。一般有title、body、subTitle。
/// 如果是服务端封装的扩展参数，则一般都在userInfo中
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;


@property (nonatomic, strong) AVSpeechSynthesisVoice *synthesisVoice;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

/// 资源文件
@property (nonatomic, strong) NSMutableArray<UNNotificationAttachment *> *attachmentsArray;

@end


@implementation NotificationService

#pragma mark - 1. 用于拦截通知并处理好通知
/// 用于拦截通知并处理好通知
/// 可以通过重写此方法来实现自定义推送通知修改。
/// 如果要使用修改后的通知内容，则需要在该方法中调用 contentHandler 传递修改后的通知内容。
/// 如果在服务时间（30秒）到期之前未调用处理程序 contentHandler，则将传递未修改的通知。
/// - Parameters:
///   - request: 通知内容
///   - contentHandler: 处理结果，需要返回一个UNNotificationContent的通知内容
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    // 接收回调对象
    self.contentHandler = contentHandler;
    // copy通知内容
    self.bestAttemptContent = [request.content mutableCopy];
    
    // 在此处修改通知内容... Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
        
    [self handleRequest:request]; //对通知内容进行处理
//    // 回调通知结果
//    self.contentHandler(self.bestAttemptContent);
}
// 处理
- (void)handleRequest:(UNNotificationRequest *)request {
    // 获取通知信息
    NSDictionary *userInfo = request.content.userInfo;
    if (userInfo) {
        // 根据约定好的 key 获取相应的参数值
        // 获取通知中的aps信息
        NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
        NSDictionary *paramsDict = [userInfo objectForKey:@"params"];
        if (apsDict && paramsDict) {
            NSString *type = [paramsDict objectForKey:@"myNotificationType"];
            if (type) {
                BOOL isActionContentHandler = YES;
                if ([type isEqualToString:@"image"]) { //下载图片
                    //下载方法
                    [self downFileWithUrl:[apsDict objectForKey:@"imageUrl"] withFileType:@"image"];
                } else if ([type isEqualToString:@"audio"]) {//下载音频
                    [self downFileWithUrl:[apsDict objectForKey:@"imgUrl"] withFileType:@"image"];
                    [self downFileWithUrl:[paramsDict objectForKey:@"soundUrl"] withFileType:@"audio"];
                } else if ([type isEqualToString:@"video"]) { //下载视频
                    [self downFileWithUrl:[paramsDict objectForKey:@"videoUrl"] withFileType:@"video"];
                }
                else if ([type isEqualToString:@"pay"]) { //支付播报
                    
                    if (@available(iOS 12.1, *)) {
                        // 背景：12.1以后苹果不允许在Service中合成语音或者文字转语音
                        // 方案1，使用VOIP，唤醒app，由app完成语音的播报
                        // 方案2，收到远程通知后，循环发送本地通知，通知中播放本地拆分开的音频文件，这样可以减少音频文件的数量
                        // 方案3，本地预置大量的音频文件，例如：“支付宝收款100元.mp3“。包的体积会很大
                        // 方案4，服务端生成tts文件，客户端在Service里下载，然后设置通知的声音为tts文件(目前采用的方案)
//                        NSURL *saveUrl = [self downFile:[paramsDict objectForKey:@"soundUrl"] withFileType:@"audio"];
//                        UNNotificationSound *sound = [UNNotificationSound soundNamed:saveUrl.absoluteString];
//                        self.bestAttemptContent.sound = sound;
                        
                        __weak __typeof(self)weakSelf = self;
                        [self downFileWithUrl:[paramsDict objectForKey:@"soundUrl"] withFileType:@"audio" complete:^(NSURL *saveUrl) {
                            __strong __typeof(weakSelf)strongSelf = weakSelf;
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:saveUrl.absoluteString];
                            strongSelf.bestAttemptContent.sound = sound;
                        }];
                        
                    } else {
                        isActionContentHandler = NO;
                        [self playPaySound:[paramsDict objectForKey:@"pay"] isPayments:NO];
                    }
                    
                    //播放声音
                } else if ([type isEqualToString:@"payments"]) { // 收款播报
                    isActionContentHandler = NO;
                    //播放声音
                    [self playPaySound:[paramsDict objectForKey:@"payments"] isPayments:NO];
                }
                if (self.attachmentsArray.count > 0) {//资源文件 >0
                    self.bestAttemptContent.attachments = self.attachmentsArray;
                }
                if (isActionContentHandler) {
                    self.contentHandler(self.bestAttemptContent);
                }
            } else {
                self.contentHandler(self.bestAttemptContent);
            }
        } else {
            self.contentHandler(self.bestAttemptContent);
        }
    } else {
        self.contentHandler(self.bestAttemptContent);
    }
}

#pragma mark - 2. 当方法一 资源超时则会调用默认这里走原始推送即可
/// 当 didReceiveNotificationRequest 的方法执行超过30秒未调用 contentHandler时
/// 系统会自动调用 serviceExtensionTimeWillExpire 方法，给我们最后一次弥补处理的机会
/// 可以在 serviceExtensionTimeWillExpire 方法中设置 didReceiveNotificationRequest 方法中未完成数据的默认值
- (void)serviceExtensionTimeWillExpire {
    // 在系统将终止扩展之前调用。
    // 将此作为对修改内容进行“最佳尝试”的机会，否则将使用原始推送负载。
    self.contentHandler(self.bestAttemptContent);
}


#pragma mark - Private Method


/// 下载文件
- (void)downFileWithUrl:(NSString *)urlString withFileType:(NSString *)type {
    [self downFileWithUrl:urlString withFileType:type complete:nil];
}

/// 下载文件
/// - Parameters:
///   - urlString: 文件的url
///   - type: 文件的类型
- (void)downFileWithUrl:(NSString *)urlString withFileType:(NSString *)type complete:(void(^)(NSURL *saveUrl))complete {
    
    if (!urlString || urlString.length <= 0) {
        return;
    }
    
    // 下载图片数据
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }

//    // 文件扩展名
    NSString *fileExt = [self fileExtensinoForMediaType:type];
    __weak __typeof(self)weakSelf = self;
   //由于这是扩展的target，无法使用主工程的网络请求库，需要使用原生的网络请求方法下载资源文件：
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!error) {
//// 确定文件保存路径，这里要注意文件是保存在NotificationService这个应用沙盒中，并不是保存在主应用中,userDocument
NSString *tempDict = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//            // 沙盒中tmp的目录路径
//            NSString *tempDict = NSTemporaryDirectory();
            // 建议使用的文件名
//            NSString *filenameSuffix = response.suggestedFilename?response.suggestedFilename:[response.URL.absoluteString lastPathComponent];
            NSString *filenameSuffix = response.suggestedFilename?response.suggestedFilename:fileExt;
            // 附件ID
            NSString *attachmentID = [[[NSUUID UUID] UUIDString] stringByAppendingString:filenameSuffix];
            // 临时文件路径
            NSString *tempFilePath = [tempDict stringByAppendingPathComponent:attachmentID];
            //
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager moveItemAtPath:location.path toPath:tempFilePath error:&error];
            
            if (!error) {
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentID URL:[NSURL fileURLWithPath:tempFilePath] options:nil error:&error];
                if (attachment) {
                    strongSelf.bestAttemptContent.attachments = [strongSelf.bestAttemptContent.attachments arrayByAddingObject:attachment];
                    if (complete) {
                        complete([NSURL fileURLWithPath:tempFilePath]);
                    }
                } else {
                    NSLog(@"创建附件错误 error：%@", error.localizedDescription);
                }
            } else {
                NSLog(@"移动文件错误 error：%@", error.localizedDescription);
            }
            
//            NSURL *localURL = [NSURL fileURLWithPath:[location.path stringByAppendingString:fileExt]];
//            [fileManager moveItemAtURL:location toURL:localURL error:&error];
//            NSError *attachmentError = nil;
//            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
//            if (attachmentError) {
//                NSLog(@"报错：%@", attachmentError.localizedDescription);
//            } else {
//                self.bestAttemptContent.attachments = @[attachment];
//                self.contentHandler(self.bestAttemptContent);
//            }
        } else {
            NSLog(@"下载文件错误 error：%@", error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentHandler(self.bestAttemptContent);
        });
    }];
    [task resume];
    
    
    
//    // 确定文件保存路径，这里要注意文件是保存在NotificationService这个应用沙盒中，并不是保存在主应用中
//    NSString *userDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    // 附件保存的路径
//    NSString *path = @"";
//    if ([type isEqualToString:@"typeImage"]) { //图片
//        path = [NSString stringWithFormat:@"%@/notification.jpg", userDocument];
//    } else if ([type isEqualToString:@"typeSound"]) {//声音
//        path = [NSString stringWithFormat:@"%@/notification.mp3", userDocument];
//    } else if ([type isEqualToString:@"pay"]) { //付款
//        path = [self getFilePath];
//    } else {// 视频
//        path = [NSString stringWithFormat:@"%@/notification.mp4", userDocument];
//    }
//    // 先删除老的文件
//    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//    // 再保存新文件
//    [fileData writeToFile:path atomically:YES];
    
    // 传给自定义通知栏的URL
//    NSURL *saveUrl = [NSURL fileURLWithPath:path];
    
//    return saveUrl;
}

/// 获取文件扩展名
- (NSString *)fileExtensinoForMediaType:(NSString *)type {
    NSString *ext = type;
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    return [@"notification." stringByAppendingString:ext];
}

- (NSString *)getFilePath {
    NSString *filePath = @"";
    
    // 通过app组，获取主app沙盒路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *groupURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.com.linkstart.test001"];
    NSString *groupPath = [groupURL path];
    // 获取的文件路径
    filePath = [groupPath stringByAppendingPathComponent:@"Library/Sounds"];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件错误error：%@", error);
        }
    }
    
    NSString *pathFile = [NSString stringWithFormat:@"%@/%@", filePath, @"pay.wav"];
    
    return filePath;
}

/// 播放支付声音
/// - Parameters:
///   - money: 价格
///   - isPayments:是否是收款
- (void)playPaySound:(NSString *)money isPayments:(BOOL)isPayments {
    
    if (!money || money.length <= 0) {
        self.contentHandler(self.bestAttemptContent);
        return;
    }
    NSString *payStr = @"";
    if (isPayments) {
        payStr = [NSString stringWithFormat:@"您在App中收到了 %@ 元", money];
    } else {
        payStr = [NSString stringWithFormat:@"您在App中支付了 %@ 元", money];
    }
    
    [self playSoundText:payStr];
}

- (void)playSoundText:(NSString *)text {
    // 文本内容不宜过长，超过30秒会播报不完整，具体的播报字数与播放速度需要自己计算
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [self.synthesizer stopSpeakingAtBoundary:(AVSpeechBoundaryImmediate)];
    utterance.rate = 1;
    utterance.voice = self.synthesisVoice;
    [self.synthesizer speakUtterance:utterance];
}

#pragma mark - AVSpeechSynthesizerDelegate
// 新增语音播放代理函数，在语音播报完成的代理函数中，添加下面的代码
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    // 语音播放完成后调用
    self.contentHandler(self.bestAttemptContent);
}

#pragma mark - LazyLoad

- (AVSpeechSynthesisVoice *)synthesisVoice {
    if (!_synthesisVoice) {
        _synthesisVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    }
    return _synthesisVoice;
}

- (AVSpeechSynthesizer *)synthesizer {
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

- (NSMutableArray<UNNotificationAttachment *> *)attachmentsArray {
    if (!_attachmentsArray) {
        _attachmentsArray = [NSMutableArray array];
    }
    return _attachmentsArray;
}


@end
