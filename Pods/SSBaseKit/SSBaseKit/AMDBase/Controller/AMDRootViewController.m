//
//  AMDRootViewController.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDRootViewController.h"
#import "AMDRootNavgationBar.h"
#import "AMDBackControl.h"
#import <Masonry/Masonry.h>
#import "SSGlobalVar.h"


@interface AMDRootViewController ()
{
    AMDBackControl *_backControl;                   //线条颜色
}

@property(nonatomic) BOOL loadFromNib;     //从xib中加载的话
//导航是否展示
@property(nonatomic) BOOL titileViewHidden;
//底部tabbar的高度是否展示
@property(nonatomic) BOOL tabBarHidden;
@end

@implementation AMDRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 从xib中加载
        _loadFromNib = YES;
    }
    return self;
}

- (void)dealloc
{
    _backControl = nil;
    NSLog(@"%@ %s",[self class],__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //当从nib中加载的时候 不加载导航
    if (!_loadFromNib) {
        [self initRootContentView];
    }
    
    //禁止7.0以后自动调位置 TableView滑动
    self.automaticallyAdjustsScrollViewInsets=NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    [AMDTool clearMembory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    if (!self.isViewLoaded){
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}


// 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
//    return [[LoginInfoStorage sharedStorage] statusBarStyle];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}





#pragma mark -

- (instancetype)init
{
    return [self initWithTitle:nil];
}
//
- (instancetype)initWithTitle:(NSString *)title
{
//    if (self = [super init]) {
        //默认展示导航 不展示tabbar
        _titileViewHidden = NO;
        _tabBarHidden = YES;
        self.title = title;
    _loadFromNib = NO;
//    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow
                   tabBarShow:(BOOL)tabbar
{
    //    if (self = [super initWithNibName:nil bundle:nil]) {
    _titileViewHidden = !titleViewShow;
    _tabBarHidden = !tabbar;
    self.title = title;
    _loadFromNib = NO;
    //    }
    return self;
}

- (void)initRootContentView
{
    NSInteger h = 0;
    NSInteger w = self.view.frame.size.width;
    
    if (!_titileViewHidden) {//标题
        h = 64;
        AMDRootNavgationBar *bar = [[AMDRootNavgationBar alloc]initWithFrame:CGRectMake(0, 0, w, h)];
//        bar.naviationBarColor = nav_background_color;
        _titleView = bar;
        bar.title = self.title;
        [self.view addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(h));
            make.top.equalTo(@0);
        }];
    }
    
    //内部视图
    UIView *contentvw = [[UIView alloc]init];
    _contentView = contentvw;
    contentvw.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
//    contentvw.layer.borderWidth = 1;
    if (_titleView)
        [self.view insertSubview:contentvw belowSubview:_titleView];
    else
        [self.view addSubview:_contentView];
    
    [contentvw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        if (_titleView)
            make.top.equalTo(_titleView.mas_bottom).with.offset(0);
        else
            make.top.equalTo(@0);
    }];
    self.view.multipleTouchEnabled = NO;
}


#pragma mark - PriavteAPI
//
- (void)setTitileViewHidden:(BOOL)titileViewHidden
{
    if (_titileViewHidden != titileViewHidden) {
        self.titleView.hidden = titileViewHidden;
        _titileViewHidden = titileViewHidden;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (titileViewHidden)
                make.top.equalTo(self.mas_topLayoutGuide);
            else
                make.top.equalTo(_titleView.mas_bottom).with.offset(0);
        }];
    }
}


-(void)setSupportBackBt:(BOOL)supportBackBt
{
    if (_supportBackBt != supportBackBt) {
        _supportBackBt = supportBackBt;
        
        AMDBackControl *control = _backItem;
        if (supportBackBt) {
            if (control == nil) {
                AMDBackControl *backbt = [[AMDBackControl alloc]initWithFrame:CGRectMake(0, 0, 44+10, 44)];
                _backItem = backbt;
                [backbt addTarget:self action:@selector(ClickBt_Back:) forControlEvents:UIControlEventTouchUpInside];
                self.titleView.leftViews = @[backbt];
            }
        }
        control.hidden = !supportBackBt;
    }
}


- (void)setMessageCount:(NSInteger)messageCount
{
    if (_messageCount != messageCount) {
        _messageCount = messageCount;
        
        AMDBackControl *control = _backControl;
        control.mesRemindLabel.text = [NSString stringWithFormat:@"(%li)",(long)messageCount];
    }
}

/*后退按钮*/
-(void)ClickBt_Back:(UIControl *)sender
{
    //最后一层视图
    if (self.navigationController.viewControllers.count == 2) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillLayoutSubviews
{
//    self.contentView.layer.borderWidth = 1;
    // 当视图发生改变的时候
    [super viewWillLayoutSubviews];
}


- (AMDControllerShowType)controllerShowType
{
    return AMDControllerShowTypePush;
}

// 处理KVC机制
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@" 不存在的属性 %@ %@ ",key,value);
}



#pragma mark - 引导图相关处理 <目前还未使用>
- (BOOL)prefersGuideShow
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/AppControllerGuide.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        dict = [[NSMutableDictionary alloc]init];
    }
    NSString *description = [self description];
    if ([dict.allKeys containsObject:description]) {
        return [dict[description] boolValue];
    }
    return NO;
}



#pragma mark - 重写description方法
//直接返回类名
-(NSString *)description
{
    return [[self class] description];
}


@end





