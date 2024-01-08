//
//  GetMacAddress.m
//  LSProjectTool
//
//  Created by Xcode on 16/11/2.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "GetMacAddress.h"

//MAC地址
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>


//IP 地址
#import <ifaddrs.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation GetMacAddress


#pragma MARK - 获取Ip 地址
- (NSString *)getIponeIP{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    NSLog(@"-------ip %@", address);
    return address;
}

/// iPv4 地址： 
- (NSString *)wiFiIPAddress {
    @try {
        NSString *ipAddress;
        struct ifaddrs *interfaces;
        struct ifaddrs *temp;
        int Status = 0;
        Status = getifaddrs(&interfaces);
        if (Status == 0) {
            temp = interfaces;
            while(temp != NULL) {
                if(temp->ifa_addr->sa_family == AF_INET) {
                    if([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"en0"]) {
                        ipAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp->ifa_addr)->sin_addr)];
                    }
                }
                temp = temp->ifa_next;
            }
        }
        
        freeifaddrs(interfaces);
        
        if (ipAddress == nil || ipAddress.length <= 0) {
            return nil;
        }
        return ipAddress;
    }
    @catch (NSException *exception) {
        return nil;
    }
}


// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
//获取MAC地址 方法1
+ (NSString *)macaddress {
    
    int         mib[6];
    size_t       len;
    char        *buf;
    unsigned char    *ptr;
    struct if_msghdr  *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
//    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    // MAC地址不带冒号
      NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"MAC地址：outString:%@", outstring);
    
    free(buf); 
    
    return [outstring lowercaseString];
}

//获取MAC地址 方法2
+ (NSString *)getMacAddress {
    int         mgmtInfoBase[6];
    char        *msgBuffer = NULL;
    size_t       length;
    unsigned char    macAddress[6];
    struct if_msghdr  *interfaceMsgStruct;
    struct sockaddr_dl *socketStruct;
    NSString      *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;    // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;    // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;    // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST; // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac 地址: %@", macAddressString); 
    
    // Release the buffer memory 
    free(msgBuffer); 
    
    return macAddressString; 
}




@end
