//
//  NSPrivateTool.m
//  AMDNetworkService
//
//  Created by SunSet on 2017/7/25.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "NSPrivateTool.h"
//#include <netdb.h>
//#include <sys/socket.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
//#include <sys/socket.h>
//#include <net/if.h>

@implementation NSPrivateTool


//+ (NSString *)localIP
//{
//    InitAddresses();
//    GetIPAddresses();
//    GetHWAddresses();
//    
//    /*
//     int i;
//     NSString *deviceIP;
//     for (i=0; i<MAXADDRS; ++i)
//     {
//     static unsigned long localHost = 0x7F000001;        // 127.0.0.1
//     unsigned long theAddr;
//     
//     theAddr = ip_addrs[i];
//     
//     if (theAddr == 0) break;
//     if (theAddr == localHost) continue;
//     
//     NSLog(@"%s %s %s/n", if_names[i], hw_addrs[i], ip_names[i]);
//     }
//     deviceIP = [NSString stringWithFormat:@"%s", ip_names[i]];
//     */
//    
//    //this will get you the right IP from your device in format like 198.111.222.444. If you use the for loop above you will se that ip_names array will also contain localhost IP 127.0.0.1 that's why I don't use it. Eventualy this was code from mac that's why it uses arrays for ip_names as macs can have multiple IPs
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
//}


+ (NSString *)localIP
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}



@end








