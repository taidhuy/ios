//
//  GNZSegmentControl.m
//  Pods
//
//  Created by Chris Gonzales on 11/17/15.
//
//

#import "GNZSegmentedControl.h"

NSString * const GNZSegmentOptionControlBackgroundColor = @"SEGMENT_OPTION_BACKGROUND_COLOR";
NSString * const GNZSegmentOptionSelectedSegmentTintColor = @"SEGMENT_OPTION_SELECTED_COLOR";
NSString * const GNZSegmentOptionDefaultSegmentTintColor = @"SEGMENT_OPTION_DEFAULT_COLOR";
NSString * const GNZSegmentOptionIndicatorColor = @"SEGMENT_INDICATOR_COLOR";
NSString * const GNZSegmentOptionDefaultSegmentFont = @"SEGMENT_OPTION_DEFAULT_FONT";
NSString * const GNZSegmentOptionSelectedSegmentFont = @"SEGMENT_OPTION_SELECTED_FONT";

@interface GNZSegmentedControl ()
@property (nonatomic) NSUInteger selectedSegmentIndex;
@property (nonatomic) NSMutableArray *segments;
@property (nonatomic) UIColor *controlBackgroundColor;
@property (nonatomic) UIColor *segmentDefaultColor;
@property (nonatomic) UIColor *segmentSelectedColor;
@property (nonatomic) UIFont *segmentDefaultFont;
@property (nonatomic) UIFont *segmentSelectedFont;
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic) UIColor *hairlineShadowColor;
@property (nonatomic) GNZIndicatorStyle indicatorStyle;
@property (nonatomic) NSUInteger segmentCount;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

//default
@property (weak, nonatomic) UIView *defaultSelectionIndicator;
@property (nonatomic) NSLayoutConstraint *defaultIndicatorConstraint;

//elevator
@property (nonatomic) NSMutableArray<NSLayoutConstraint *> *elevatorHeightConstraints;

@end
@implementation GNZSegmentedControl

#pragma mark - Initializers
- (instancetype)initWithSegmentCount:(NSUInteger)count indicatorStyle:(GNZIndicatorStyle)style options:(NSDictionary<NSString *,id> *)segmentOptions {
    if (self = [super initWithFrame:CGRectZero]) {


        _indicatorStyle = style;
        _elevatorHeightConstraints = [NSMutableArray new];
        _controlBackgroundColor = segmentOptions[GNZSegmentOptionControlBackgroundColor];
        _segmentDefaultColor = segmentOptions[GNZSegmentOptionDefaultSegmentTintColor];
        _segmentSelectedColor = segmentOptions[GNZSegmentOptionSelectedSegmentTintColor];
        _segmentDefaultFont = segmentOptions[GNZSegmentOptionDefaultSegmentFont];
        _segmentSelectedFont = segmentOptions[GNZSegmentOptionSelectedSegmentFont];

        _indicatorColor = segmentOptions[GNZSegmentOptionIndicatorColor];
        _segmentCount = count;


        [self commonInit];
    }

    return self;
}

- (void)commonInit {

    self.backgroundColor = self.controlBackgroundColor;
    _selectedSegmentIndex = 0;

    for (NSInteger i = 0; i < _segmentCount; i++) {
        [self deactivateSelectedSegmentAtIndex:i];
    }

    [self activateSelectedSegmentAtIndex:_selectedSegmentIndex];
}

#pragma mark - Layout and Defaults

- (NSMutableArray *)segments {

    if (!_segments && self.segmentCount != 0) {

        _segments = [NSMutableArray new];

        for (NSUInteger count = 0; count < self.segmentCount; count++) {

            UIButton *button = [self configureSegmentButton];
            [_segments addObject:button];
        }
    }

    return _segments;
}

- (CGFloat)segmentDistance {

    if (!_segmentDistance) {
        _segmentDistance = 8.0;
    }

    return _segmentDistance;
}

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        CGFloat segmentControlWidth;

        [self removeConstraints:self.constraints];

        [self.segments enumerateObjectsUsingBlock:^(id  _Nonnull segmentButton, NSUInteger idx, BOOL * _Nonnull stop) {

            UIButton *button = segmentButton;

            button.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 5, 10);

            self.translatesAutoresizingMaskIntoConstraints = NO;
            button.translatesAutoresizingMaskIntoConstraints = NO;

            NSDictionary *views;

            BOOL leftMostButton = idx == 0;
            BOOL middleButton = idx > 0;
            BOOL finalButton = idx == [self.segments count] - 1;

            NSNumber *halfSpaceBetweenButtons = @(self.segmentDistance / 2.0);
            NSNumber *spaceBetweenButtons = @(self.segmentDistance);

            NSDictionary *metrics = NSDictionaryOfVariableBindings(halfSpaceBetweenButtons, spaceBetweenButtons);

            if (leftMostButton) {

                views = NSDictionaryOfVariableBindings(segmentButton);
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(halfSpaceBetweenButtons)-[segmentButton]" options:0 metrics:metrics views:views]];
            }


            if (middleButton) {

                UIButton *priorSegmentButton = self.segments[idx -1];

                views = NSDictionaryOfVariableBindings(segmentButton, priorSegmentButton);

                //TODO: ZSD remove magic number and make settable by client.
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[priorSegmentButton]-(spaceBetweenButtons)-[segmentButton]" options:0 metrics:metrics views:views]];
            }

            if (finalButton) {


                views = NSDictionaryOfVariableBindings(segmentButton);
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[segmentButton]-(halfSpaceBetweenButtons)-|" options:0 metrics:metrics views:views]];
            }

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segmentButton]|" options:0 metrics:nil views:views]];

        }];

        switch (self.indicatorStyle) {
            case GNZIndicatorStyleElevator:
                [self createElevatorIndicatorConstraints];
                break;
            case GNZIndicatorStyleDefault:
                [self createDefaultIndicatorConstraints];
                break;
        }

        if (self.indicatorStyle == GNZIndicatorStyleDefault) {

            [self.segments enumerateObjectsUsingBlock:^(id  _Nonnull segmentButton, NSUInteger idx, BOOL * _Nonnull stop) {

                if (idx > 0) {

                    UIButton *priorSegmentButton = self.segments[idx -1];

                    NSLayoutConstraint *widthConstraint =
                    [NSLayoutConstraint constraintWithItem:segmentButton
                                                 attribute:NSLayoutAttributeWidth
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:priorSegmentButton
                                                 attribute:NSLayoutAttributeWidth
                                                multiplier:1.0
                                                  constant:0];

                    [self addConstraint:widthConstraint];
                }
            }];
        }

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

-(void)addHairlineShadow
{
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f/UIScreen.mainScreen.scale)];
    [self.layer setShadowRadius:0];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.25f];

}

- (void)createDefaultIndicatorConstraints {
    NSLayoutConstraint *segmentLeftConstraint = [NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.segments.firstObject attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:segmentLeftConstraint];
    self.defaultIndicatorConstraint = segmentLeftConstraint;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.segments.firstObject attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:2.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}

- (void)createElevatorIndicatorConstraints {
    for (UIView *segmentView in self.segments) {
        UIView *segmentIndicator = [self selectionIndicator];
        [segmentView addSubview:segmentIndicator];

        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
        [segmentView addConstraint:heightConstraint];
        [self.elevatorHeightConstraints addObject:heightConstraint];


        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:segmentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [segmentView addConstraint:bottomConstraint];

        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:segmentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        [segmentView addConstraint:widthConstraint];

        NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:segmentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        [segmentView addConstraint:xConstraint];

        //        [segmentView layoutIfNeeded];
    }

    self.elevatorHeightConstraints.firstObject.constant = 5;
}

- (UIButton *)selectedSegmentButton {
    return self.segments[self.selectedSegmentIndex];
}

- (CGRect)selectedSegmentFrame {

    return [self selectedSegmentButton].frame;
}

- (CGRect)selectedSegmentFrameAdjustedForSpacing {

    CGRect adjustedSegmentFrame = [self selectedSegmentFrame];
    adjustedSegmentFrame.origin.x -= self.segmentDistance / 2;
    adjustedSegmentFrame.size.width += self.segmentDistance;

    return adjustedSegmentFrame;
}

- (UIButton *)configureSegmentButton {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(segmentTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:self.segmentDefaultColor forState:UIControlStateNormal];
    [button setTintColor:self.segmentDefaultColor];
    [self addSubview:button];
    return button;
}

#pragma mark - GNZSegment Protocol
- (NSUInteger)numberOfSegments {
    return self.segments.count;
}

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    if (![self validSegmentIndex:selectedSegmentIndex]) return;

    [self deactivateSelectedSegmentAtIndex:_selectedSegmentIndex];
    _selectedSegmentIndex = selectedSegmentIndex;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self activateSelectedSegmentAtIndex:selectedSegmentIndex];
}



#pragma mark - Overrides

-(void)setFont:(UIFont *)font {

    for (UIButton *button in self.segments) {
        button.titleLabel.font = font;
    }

    _font = font;
}

- (UIView *)defaultSelectionIndicator {
    if (!_defaultSelectionIndicator) {
        UIView *strongIndicator = [UIView new];
        _defaultSelectionIndicator = strongIndicator;
        _defaultSelectionIndicator.backgroundColor = self.indicatorColor;
        _defaultSelectionIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_defaultSelectionIndicator];
    }
    return _defaultSelectionIndicator;
}

- (UIView *)selectionIndicator {
    UIView *newIndicator = [UIView new];
    newIndicator.backgroundColor = self.indicatorColor;
    newIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    return newIndicator;
}

#pragma mark - Actions
- (void)segmentTouchedUpInside:(UIButton *)sender {
    NSUInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    NSUInteger currentSelectedIndex = [self.segments indexOfObject:sender];

    self.selectedSegmentIndex = currentSelectedIndex;

    if (self.indicatorStyle == GNZIndicatorStyleDefault) {
        [self adjustDefaultIndicatorsWithTapOnSegmentIndex:currentSelectedIndex];
    }
}

//- (void)segmentChanged:(UIButton *)sender {
//
//    NSUInteger currentSelectedIndex = [self.segments indexOfObject:sender];
//    self.selectedSegmentIndex = currentSelectedIndex;
//}

#pragma mark - Set Segment Properties
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    [self setTitle:title andImage:nil withSpacing:0.0 forSegmentAtIndex:segment];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
    [self setTitle:nil andImage:image withSpacing:0.0 forSegmentAtIndex:segment];
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image withSpacing:(CGFloat)spacing forSegmentAtIndex:(NSUInteger)segment {
    if (![self validSegmentIndex:segment]) return;

    UIButton *editingSegment = [self.segments objectAtIndex:segment];
    [editingSegment setImage:image forState:UIControlStateNormal];
    [editingSegment setTitle:title forState:UIControlStateNormal];
    editingSegment.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    editingSegment.titleEdgeInsets = UIEdgeInsetsMake(1, spacing, 0, 0);
    [editingSegment sizeToFit];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Helpers

- (BOOL)validSegmentIndex:(NSUInteger)segmentIndex {
    return segmentIndex < self.segments.count;
}

- (void)deactivateSelectedSegmentAtIndex:(NSInteger)index {

    UIButton *previousSelected = self.segments[index];
    [previousSelected setTitleColor:self.segmentDefaultColor forState:UIControlStateNormal];
    [previousSelected setTintColor:self.segmentDefaultColor];

    if (_segmentDefaultFont) {
        previousSelected.titleLabel.font = self.segmentDefaultFont;
    }
}

- (void)activateSelectedSegmentAtIndex:(NSInteger)index {

    UIButton *currentSelected = self.segments[index];
    [currentSelected setTitleColor:self.segmentSelectedColor forState:UIControlStateNormal];
    [currentSelected setTintColor:self.segmentSelectedColor];

    if (_segmentSelectedFont) {
        currentSelected.titleLabel.font = self.segmentSelectedFont;
    }
}

- (void)adjustIndicatorForScroll:(UIScrollView *)scrollView {
    switch (self.indicatorStyle) {
        case GNZIndicatorStyleElevator:
            [self adjustElevatorIndicatorsWithScroll:scrollView];
            break;
        case GNZIndicatorStyleDefault:
            [self adjustDefaultIndicatorWithScroll:scrollView];
            break;
        case GNZIndicatorStyleCustom:
            [self adjustCustomIndicatorWithScroll:scrollView];

    }
}

- (void)adjustCustomIndicatorWithScroll:(UIScrollView *)scrollView {

    if (self.customIndicatorAnimatorBlock) {
        self.customIndicatorAnimatorBlock(scrollView);
    }
}

- (void)adjustDefaultIndicatorWithScroll:(UIScrollView *)scrollView {
    self.defaultIndicatorConstraint.constant = (scrollView.contentOffset.x/scrollView.contentSize.width)*self.frame.size.width;
}

- (void)adjustElevatorIndicatorsWithScroll:(UIScrollView *)scrollView {
    for (int i = 0; i < self.elevatorHeightConstraints.count; i++) {
        CGFloat segmentPosition = i*(self.frame.size.width);
        CGFloat distanceFromViewport = fabs(segmentPosition-scrollView.contentOffset.x);
        CGFloat percentHeight = 1-(distanceFromViewport/self.frame.size.width);
        percentHeight = percentHeight*2-1;
        NSLayoutConstraint *constraint = self.elevatorHeightConstraints[i];
        CGFloat constant =  percentHeight*5;
        constraint.constant = MAX(0, constant);
    }
}

- (void)adjustDefaultIndicatorsWithTapOnSegmentIndex:(NSInteger)segmentIndex {

    //TODO: Will break if we add margins between segments
    self.defaultIndicatorConstraint.constant = segmentIndex * (self.frame.size.width / self.segmentCount);

    [UIView animateWithDuration:0.2 delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:nil];
}

-(void)setControlHeight:(CGFloat)controlHeight {
    _controlHeight = controlHeight;

    [self invalidateIntrinsicContentSize];
}

-(CGSize)intrinsicContentSize {

    CGSize intrinsicContentSize;

    if (self.controlHeight) {
        intrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, self.controlHeight);
    } else {
        intrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    }
    
    return intrinsicContentSize;
}

@end
