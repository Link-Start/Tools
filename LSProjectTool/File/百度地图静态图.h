//
//  百度地图静态图.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/7/31.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#ifndef ________h
#define ________h

#pragma - mark 服务介绍
//服务介绍：https://lbsyun.baidu.com/index.php?title=static
https://api.map.baidu.com/staticimage/v2?ak=E4805d16520de693a3fe707cdc962045&mcode=666666&center=116.403874,39.914888&width=300&height=200&zoom=11
//请将AK替换为您的AK

#pragma - mark 服务文档
//服务文档：
云端存储
    URL长度：2048
    点标记的数量：50个
    调用次数：同一个开发者帐号下的HTTP/HTTPS请求，配额、并发共享。
服务地址
    https://api.map.baidu.com/staticimage/v2 //GET请求
组成说明：
    域名：https://api.map.baidu.com
    服务名：staticimage
    版本号：v2

服务参数列表

参数名         必选          默认值                             描述
ak             是    无     用户的访问密钥。支持浏览器端和服务端ak，网页应用推荐使用 服务端ak(sn校验方式）
mcode          否    无     安全码。若为Android/IOS SDK的ak, 该参数必需。
width          否    400    图片宽度。取值范围：(0, 1024]。Scale=2,取值范围：(0, 512]。
height         否    300    图片高度。取值范围：(0, 1024]。Scale=2,取值范围：(0, 512]。
center         否    北京    地图中心点位置，参数可以为经纬度坐标或名称。坐标格式：lng<经度>，
                                lat<纬度>，例如116.43213,38.76623。
zoom           否    11      地图级别。高清图范围[3, 18]；低清图范围[3,19]
copyright      否    pl      静态图版权样式，0表示log+文字描述样式，1表示纯文字描述样式，默认为0。
dpiType        否    pl     手机屏幕类型。取值范围:{ph：高分屏，pl：低分屏(默认)}，
                            高分屏即调用高清地图，低分屏为普通地图。
coordtype      否    bd09ll      静态图的坐标类型。支持wgs84ll（wgs84坐标）/gcj02ll（国测局坐标）/
                                bd09ll（百度经纬度）/bd09mc（百度墨卡托）。默认bd09ll（百度经纬度）
scale    否    null    返回图片大小会根据此标志调整。取值范围为1或2：
1表示返回的图片大小为size= width * height;
2表示返回图片为(width*2)*(height *2)，且zoom加1
注：如果zoom为最大级别，则返回图片为（width*2）*（height*2），zoom不变。

bbox    否    null    地图视野范围。格式：minX,minY;maxX,maxY。
markers    否    null    标注，可通过经纬度或地址/地名描述；多个标注之间用竖线分隔。
markerStyles    否    null    与markers有对应关系。markerStyles可设置默认图标样式和自定义图标样式。其中设置默认图标样式时，可指定的属性包括size,label和color；设置自定义图标时，可指定的属性包括url，注意，设置自定义图标时需要先传-1以此区分默认图标。
labels    否    null    标签，可通过经纬度或地址/地名描述；多个标签之间用竖线分隔。坐标格式：lng<经度>，lat<纬度>，例如116.43213,38.76623。
labelStyles    否    null    标签样式 content, fontWeight,fontSize,fontColor,bgColor, border。与labels一一对应。
paths    否    null    折线，可通过经纬度或地址/地名描述；多个折线用竖线"|"分隔；每条折线的点用分号";"分隔；点坐标用逗号","分隔。坐标格式：lng<经度>，lat<纬度>，例如116.43213,38.76623。
pathStyles    否    null    折线样式 color,weight,opacity[,fillColor]。


#pragma - mark

#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#pragma - mark
#endif /* ________h */
