// 
// Copyright 2022 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "CallHistoryViewController.h"

#import "RoomDataSource.h"
#import "RoomBubbleCellData.h"

#import "RoomInputToolbarView.h"
#import "DisabledRoomInputToolbarView.h"

#import "RoomActivitiesView.h"

#import "AttachmentsViewController.h"

#import "EventDetailsView.h"

#import "RoomAvatarTitleView.h"
#import "ExpandedRoomTitleView.h"
#import "SimpleRoomTitleView.h"
#import "PreviewRoomTitleView.h"

#import "RoomMemberDetailsViewController.h"
#import "ContactDetailsViewController.h"

#import "SegmentedViewController.h"
#import "RoomSettingsViewController.h"

#import "RoomFilesViewController.h"

#import "RoomSearchViewController.h"

#import "UsersDevicesViewController.h"

#import "ReadReceiptsViewController.h"

#import "JitsiViewController.h"

#import "RoomEmptyBubbleCell.h"
#import "RoomMembershipExpandedBubbleCell.h"
#import "MXKRoomBubbleTableViewCell+Riot.h"

#import "AvatarGenerator.h"
#import "Tools.h"
#import "WidgetManager.h"
#import "ShareManager.h"

#import "GBDeviceInfo_iOS.h"

#import "RoomEncryptedDataBubbleCell.h"
#import "EncryptionInfoView.h"

#import "MXRoom+Riot.h"

#import "IntegrationManagerViewController.h"
#import "WidgetPickerViewController.h"
#import "StickerPickerViewController.h"

#import "EventFormatter.h"

#import "SettingsViewController.h"
#import "SecurityViewController.h"

#import "TypingUserInfo.h"

#import "MXSDKOptions.h"

#import "RoomTimelineCellProvider.h"

#import "GeneratedInterface-Swift.h"
@interface CallHistoryViewController () <MasterTabBarItemDisplayProtocol>
{
    RecentsDataSource *recentsDataSource;
}
@property (nonatomic, readwrite) RoomDisplayConfiguration *displayConfiguration;
@property (nonatomic, strong) MXThrottler *tableViewPaginationThrottler;

@end

@implementation CallHistoryViewController

+ (instancetype)instantiate
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CallHistoryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CallHistoryViewController"];
    
    return viewController;
}
#pragma mark - Recent

- (NSArray<MXUser *> * _Nonnull)getRecentCalledUsers:(NSUInteger)maxNumberOfUsers
                                      ignoredUserIds:(NSArray<NSString*> * _Nullable)ignoredUserIds
{
    MXSession* _mxSession = [[[AppDelegate theDelegate] mxSessions] firstObject];
//    NSMutableArray *marray = [[_mxSession callManager] getRecentCalledUsers:20 ignoredUserIds:@[]];
//    NSLog(@"mxArrrraayyyy====::===%@",marray);
    if (maxNumberOfUsers == 0)
    {
        return NSArray.array;
    }

    NSArray<MXRoom *> *rooms = _mxSession.rooms;

    if (rooms.count == 0)
    {
        return NSArray.array;
    }

    NSMutableArray *callEvents = [NSMutableArray array];

    for (MXRoom *room in rooms) {
//        NSLog(@"room===id===%@", room);
        id<MXEventsEnumerator> enumerator = [room enumeratorForStoredMessagesWithTypeIn:@[kMXEventTypeStringCallInvite]];
        MXEvent *callEvent = enumerator.nextEvent;
//        NSLog(@"callEvent===value===%@", callEvent);

        if (callEvent)
        {
            while (callEvent != nil) {
//                NSLog(@"callEvent===%@value===%@", room, callEvent);
                        [callEvents addObject:callEvent];
                        callEvent = enumerator.nextEvent;
                    }
//            [callEvents addObject:callEvent];
        }
    }

    [callEvents sortUsingComparator:^NSComparisonResult(MXEvent * _Nonnull event1, MXEvent * _Nonnull event2) {
        return [@(event1.age) compare:@(event2.age)];
    }];
//    NSLog(@"callEvents======%@",callEvents);
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:callEvents.count];

    for (MXEvent *event in callEvents) {
        NSString *userId = nil;
        NSLog(@"callEvents::Type======%ld",(long)event.eventType);
        NSLog(@"callEvents==agelocal======%llu",event.ageLocalTs);
        NSLog(@"callEvents==age:======%llu",event.age);
        NSLog(@"callEvents==Sender======%@",event.sender);
        NSLog(@"callEvents==JSON======%@",event.JSONDictionary);

        if ([event.sender isEqualToString:_mxSession.myUserId])
        {
            userId = [_mxSession directUserIdInRoom:event.roomId];
        }
        else
        {
            userId = event.sender;
        }

        if (userId && ![ignoredUserIds containsObject:userId])
        {
            MXUser *user = [_mxSession userWithUserId:userId];
            if (user)
            {
                [users addObject:user];
                if (users.count == maxNumberOfUsers)
                {
                    //  no need to go further
                    break;
                }
            }
        }
    }
    NSLog(@"usersssss======%@",users);
    return users;
}
- (void)openCallTransfer
{
//    let mainSession = AppDelegate.theDelegate().mxSessions.first as? MXSession
    MXSession* session = [[[AppDelegate theDelegate] mxSessions] firstObject];
    CallTransferMainViewController *controller = [CallTransferMainViewController instantiateWithSession:session ignoredUserIds:@[]];
//    controller.delegate = self;
    UINavigationController *navController = [[RiotNavigationController alloc] initWithRootViewController:controller];
//    [self.mxCall hold:YES];
    [self presentViewController:navController animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
//    bt.frame = CGRectMake(150, 150, 100, 100);
//    [bt setTitle:@"Calllllll" forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(openCallTransfer) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bt];
    // Do any additional setup after loading the view.
//    [[RoomTimelineConfiguration shared].currentStyle.cellProvider registerCellsForTableView:self.bubblesTableView];
//    MXWeakify(self);



    // Observe user interface theme change.
//    kThemeServiceDidChangeThemeNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kThemeServiceDidChangeThemeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
//
//        MXStrongifyAndReturnIfNil(self);
//
//        [self userInterfaceThemeDidChange];
//
//    }];

//    [self userInterfaceThemeDidChange];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate theDelegate].masterTabBarController.tabBar.tintColor = ThemeService.shared.theme.tintColor;

    [self getRecentCalledUsers:200 ignoredUserIds:@[]];
}
- (void)userInterfaceThemeDidChange
{
    // Consider the main navigation controller if the current view controller is embedded inside a split view controller.
    UINavigationController *mainNavigationController = self.navigationController;
    if (self.splitViewController.isCollapsed && self.splitViewController.viewControllers.count)
    {
        mainNavigationController = self.splitViewController.viewControllers.firstObject;
    }

    [ThemeService.shared.theme applyStyleOnNavigationBar:self.navigationController.navigationBar];
    if (mainNavigationController)
    {
        [ThemeService.shared.theme applyStyleOnNavigationBar:mainNavigationController.navigationBar];
    }


    // Check the table view style to select its bg color.
    self.bubblesTableView.backgroundColor = ((self.bubblesTableView.style == UITableViewStylePlain) ? ThemeService.shared.theme.backgroundColor : ThemeService.shared.theme.headerBackgroundColor);
    self.bubblesTableView.separatorColor = ThemeService.shared.theme.lineBreakColor;
    self.view.backgroundColor = self.bubblesTableView.backgroundColor;

    if (self.bubblesTableView.dataSource)
    {
        [self.bubblesTableView reloadData];
    }

    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)destroy
{
    [super destroy];
}

- (void)displayRoom:(MXKRoomDataSource *)dataSource
{


    // Enable the read marker display, and disable its update.
    dataSource.showReadMarker = YES;
    self.updateRoomReadMarker = NO;

    [super displayRoom:dataSource];

}

#pragma mark - MasterTabBarItemDisplayProtocol

- (NSString *)masterTabBarItemTitle
{
    return [VectorL10n titleFavourites];
}

@end
