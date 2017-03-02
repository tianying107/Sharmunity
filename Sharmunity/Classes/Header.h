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
#define SYColor1 UIColorFromRGB(0x50514F) //text color
#define SYColor2 UIColorFromRGB(0x3F7473) //dark blur
#define SYColor3 UIColorFromRGB(0xB5B5B7) //gray
#define SYColor4 UIColorFromRGB(0xEF7F40) //orange
#define SYColor5 UIColorFromRGB(0x417505) //dark green
#define SYColor6 UIColorFromRGB(0xB0D541) //light green
#define SYColor7 UIColorFromRGB(0x6CBF3B) //green
#define SYColor8 UIColorFromRGB(0xF0B94A) //yellow
#define SYColor9 UIColorFromRGB(0xEB6D6D) //red
#define SYColor10 UIColorFromRGB(0x70C1B3) //green blue


#define SYBackgroundColorExtraLight UIColorFromRGB(0xFFFFFF)
#define SYBackgroundColorGreen UIColorFromRGB(0xD7F4D8)

#define SYSeparatorColor UIColorFromRGB(0xDBDBDB)
#define SYSeparatorHeight 1


#define SYFont11 [UIFont fontWithName:@"SFUIDisplay-Regular" size:11]
#define SYFont13T [UIFont fontWithName:@"SFUIDisplay-Light" size:13]
#define SYFont13S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:13]
#define SYFont13B [UIFont fontWithName:@"SFUIDisplay-Bold" size:13]
#define SYFont13 [UIFont fontWithName:@"SFUIDisplay-Regular" size:13]
#define SYFont13M [UIFont fontWithName:@"SFUIDisplay-Medium" size:13]
#define SYFont15 [UIFont fontWithName:@"SFUIDisplay-Regular" size:15]
#define SYFont15M [UIFont fontWithName:@"SFUIDisplay-Medium" size:15]
#define SYFont15S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:15]
#define SYFont15B [UIFont fontWithName:@"SFUIDisplay-Bold" size:15]
#define SYFont18 [UIFont fontWithName:@"SFUIDisplay-Regular" size:18]
#define SYFont18M [UIFont fontWithName:@"SFUIDisplay-Medium" size:18]
#define SYFont18S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:18]
#define SYFont18B [UIFont fontWithName:@"SFUIDisplay-Bold" size:18]
#define SYFont20S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:20]
#define SYFont20M [UIFont fontWithName:@"SFUIDisplay-Medium" size:20]
#define SYFont20 [UIFont fontWithName:@"SFUIDisplay-Regular" size:20]
#define SYFont25 [UIFont fontWithName:@"SFUIDisplay-Regular" size:25]
#define SYFont25M [UIFont fontWithName:@"SFUIDisplay-Medium" size:25]
#define SYFont30T [UIFont fontWithName:@"SFUIDisplay-Thin" size:30]
#define SYFont30 [UIFont fontWithName:@"SFUIDisplay-Regular" size:30]
#define SYFont30S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:30]

#define SYFontW25 [UIFont fontWithName:@"Wawati SC" size:25]


#endif /* Header_h */
