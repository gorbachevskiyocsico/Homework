//
//  Constants.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define kGoogleApiKey @"AIzaSyAaM6UKomH8mTT2AROWa139ZnLYOFQ6i2M"

#define kFromUserListToMapViewSegueIdentifier @"fromUserListToMapViewSegueIdentifier"

#define kHoursBetweenUpdateUsersList 24
#define kSecondsBetweenUpdateMapViewMarkers 60
#define kSecondsCacheTime 30

#define kBaseUrlString @"http://mobi.connectedcar360.net/api/"
#define kUsersListDownloadTime @"kUsersListDownloadTime"

#if DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) (void)0
#endif

#endif /* Constants_h */
