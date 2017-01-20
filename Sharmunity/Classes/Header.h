//
//  Header.h
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define basicURL @"https://sharmunity2017-bogong17.c9users.io/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SYColor1 UIColorFromRGB(0x50514F)
#define SYColor2 UIColorFromRGB(0x247BA0)
#define SYColor3 UIColorFromRGB(0xB5B5B7)
#define SYColor4 UIColorFromRGB(0xECB363)
#define SYColor5 UIColorFromRGB(0x70C1B3)

#define SYBackgroundColorExtraLight UIColorFromRGB(0xFAFAFA)

#define SYSeparatorColor UIColorFromRGB(0xF2F2F2)
#define SYSeparatorHeight 2

#endif /* Header_h */
