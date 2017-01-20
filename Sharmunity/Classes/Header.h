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

#define SYFont13T [UIFont fontWithName:@"SFUIDisplay-Light" size:13]
#define SYFont13S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:13]
#define SYFont13B [UIFont fontWithName:@"SFUIDisplay-Bold" size:13]
#define SYFont13 [UIFont fontWithName:@"SFUIDisplay-Regular" size:13]
#define SYFont15 [UIFont fontWithName:@"SFUIDisplay-Regular" size:15]
#define SYFont15M [UIFont fontWithName:@"SFUIDisplay-Medium" size:15]
#define SYFont15S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:15]
#define SYFont15B [UIFont fontWithName:@"SFUIDisplay-Bold" size:15]
#define SYFont18 [UIFont fontWithName:@"SFUIDisplay-Regular" size:18]
#define SYFont18M [UIFont fontWithName:@"SFUIDisplay-Medium" size:18]
#define SYFont18S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:18]
#define SYFont18B [UIFont fontWithName:@"SFUIDisplay-Bold" size:18]
#define SYFont20S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:20]
#define SYFont20 [UIFont fontWithName:@"SFUIDisplay-Regular" size:20]
#define SYFont30T [UIFont fontWithName:@"SFUIDisplay-Thin" size:30]
#define SYFont30 [UIFont fontWithName:@"SFUIDisplay-Regular" size:30]
#define SYFont30S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:30]

#endif /* Header_h */
