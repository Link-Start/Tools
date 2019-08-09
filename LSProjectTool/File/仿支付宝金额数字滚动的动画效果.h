//
//  123465.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2019/5/17.
//  Copyright © 2019年 Link-Start. All rights reserved.
//

#ifndef _23465_h
#define _23465_h

仿支付宝金额数字滚动的动画效果 oc
2019年01月22日 12:07:06 BubuxingBala 阅读数：33
[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

- (void)timerFireMethod:(NSTimer *)theTimerP{
    
    //根据数值大小判断平均增加值
    
    float aver;
    
    if (amountF > 1000){
        
        aver = 100;
        
    } else if (amountF > 100){
        
        aver = 10;
        
    } else if (amountF > 10){
        
        aver = 1;
        
    } else{
        
        aver = 0.1;
        
    }
    
    //增加平均值
    
    indexF += amountF/aver;
    
    //判断是否达到随机数值
    
    if (indexF < amountF) {
        
        //判断随机数是否小于10
        
        if (amountF<=10) {
            
            //小于等于10，增加时显示小数点后两位
            
            amountLabel.text = [NSString stringWithFormat:@"%.2f",indexF];
            
        }else{
            
            //否则，增加时不显示小数位
            
            amountLabel.text = [NSString stringWithFormat:@"%.0f",indexF];
            
        }
        
    } else {
        
        //达到随机数值 //开始值设置为初始值
        
        indexF = 0;
        
        //标签设置为随机数值
        
        amountLabel.text = amountStr;
        
        //关闭计时器
        
        [theTimerP invalidate];
        
    }
    
}


#endif /* _23465_h */
