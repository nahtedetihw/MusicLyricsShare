@interface UIView (MusicLyricsShare) <UIGestureRecognizerDelegate>
@property (nonatomic, assign) UILabel *accessibilitySelectedLyricLabel;
@property (nonatomic, assign) UILabel *accessibilityLyricLabel;
- (void)handleLyricsLongPressGesture:(UILongPressGestureRecognizer *)gesture;
- (id)_viewControllerForAncestor;
@end

@interface UIViewController (MusicLyricsShare) <UIGestureRecognizerDelegate>
- (void)handleLyricsLongPressGesture2:(UILongPressGestureRecognizer *)gesture;
@end

%hook UIView
- (id)initWithFrame:(CGRect)frame {
    self = %orig;
    if ([NSStringFromClass([((UIView *)self) class]) isEqualToString:@"MusicApplication.SyncedLyricsLineView"]) {
            UILongPressGestureRecognizer *lyricsLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLyricsLongPressGesture:)];
            lyricsLongPressGesture.delegate = self;
            lyricsLongPressGesture.minimumPressDuration = 0.75;
            [self addGestureRecognizer:lyricsLongPressGesture];
    }
    return self;
}

%new
- (void)handleLyricsLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if ([NSStringFromClass([((UIView *)self) class]) isEqualToString:@"MusicApplication.SyncedLyricsLineView"]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            if (self.accessibilityLyricLabel.text != nil || self.accessibilitySelectedLyricLabel.text != nil) {
                NSString *shareString = self.accessibilityLyricLabel.text;
                NSString *shareSelectedString = self.accessibilitySelectedLyricLabel.text;
        
                NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareSelectedString, nil];
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

                [[self _viewControllerForAncestor] presentViewController:activityViewController animated:YES completion:nil];
            }
        }
    }
}
%end

// static lyrics
%hook UIViewController
- (void)viewDidLoad {
    %orig;
    if ([NSStringFromClass([((UIViewController *)self) class]) isEqualToString:@"MusicApplication.StaticLyricsContentViewController"]) {
            UILongPressGestureRecognizer *lyricsLongPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLyricsLongPressGesture2:)];
            lyricsLongPressGesture2.delegate = self;
            lyricsLongPressGesture2.minimumPressDuration = 0.75;
            [self.view addGestureRecognizer:lyricsLongPressGesture2];
    }
}

%new
- (void)handleLyricsLongPressGesture2:(UILongPressGestureRecognizer *)gesture {
    if ([NSStringFromClass([((UIViewController *)self) class]) isEqualToString:@"MusicApplication.StaticLyricsContentViewController"]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            UITextView *textView = MSHookIvar<UITextView *>(self, "textView");
            if (textView.text != nil) {
                NSString *shareString = textView.text;
        
                NSArray *activityItems = [NSArray arrayWithObjects:shareString, nil];
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

                [self presentViewController:activityViewController animated:YES completion:nil];
            }
        }
    }
}
%end
