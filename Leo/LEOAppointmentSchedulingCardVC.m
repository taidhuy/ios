//
//  LEOSingleAppointmentSchedulerCardVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAppointmentSchedulingCardVC.h"
#import "LEODataManager.h"
#import <NSDate+DateTools.h>
#import "LEOTimeCell.h"
#import "UIFont+LeoFonts.h"
#import "ArrayDataSource.h"
#import "LEODateCell.h"
#import "UIColor+LeoColors.h"
#import "PageViewDataSource.h"
#import "NSDate+Extensions.h"
#import "CollectionViewDataSource.h"
#import "LEODateCell+ConfigureCell.h"
#import "LEODropDownTableView.h"
#import "LEOCardScheduling.h"
#import "LEOSectionSeparator.h"
#import "LEOChildDropDownTableViewController.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "PrepAppointment.h"
#import "LEOCardScheduling.h"

#import "Practice.h"

@interface LEOAppointmentSchedulingCardVC ()

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet LEODropDownTableView *doctorDropDownTV;
@property (weak, nonatomic) IBOutlet LEODropDownTableView *visitDropDownTV;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UILabel *patientLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *providerLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesView;

#pragma mark - Data
@property (strong, nonatomic) PrepAppointment *prepAppointment;
@property (strong, nonatomic) Appointment *appointment;





@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDate *tempSelectedDate;
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSLayoutConstraint *containerViewHeightConstraint;
@property (strong, nonatomic) LEODropDownController *doctorDropDownController;
@property (strong, nonatomic) LEODropDownController * visitTypeDropDownController;

#pragma mark - Helper classes
@property (strong, nonatomic) ArrayDataSource *arrayDataSource;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;
@property (strong, nonatomic) LEODataManager *dataManager;
@property (strong, nonatomic) PageViewDataSource *pageViewDataSource;

#pragma mark - State
@property (strong, nonatomic) TimeCollectionViewController *timeCollectionVC;
@property (nonatomic) CGFloat startingContentOffsetX;

@end

@implementation LEOAppointmentSchedulingCardVC

static NSString * const dateReuseIdentifier = @"DateCell";



#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //FIXME: Needs HUD
    
//    [self fetchFieldDataWithCompletion:^{
        [self prepareForLaunch];
        [self setupDateCollectionView];
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //required such that the scrolling to initial selected date happens prior to appearance of collection view
    [self.dateCollectionView layoutIfNeeded];
}

- (void)prepareForLaunch {
    
    self.doctorDropDownController = [[LEODropDownController alloc] initWithTableView:self.doctorDropDownTV items:self.providers usingDescriptorKey:@"fullName" prepObject:self.prepAppointment associatedCardObjectPropertyDescriptor:@"provider"];
    
    //TODO: Remove hard coded options and move to DataManager.
    self.visitTypeDropDownController = [[LEODropDownController alloc] initWithTableView:self.visitDropDownTV items:self.visitTypes usingDescriptorKey:@"typeDescriptor" prepObject:self.prepAppointment associatedCardObjectPropertyDescriptor:@"leoAppointmentType"];
    
    [self.view setNeedsLayout];
    
    self.card.delegate = self;
    
    NSString *buttonTitle = [self.card stringRepresentationOfActionsAvailableForState][0];
    
    [self.bookButton setTitle:[buttonTitle uppercaseString] forState:UIControlStateNormal];
    [self.bookButton addTarget:self action:@selector(updateCard) forControlEvents:UIControlEventTouchUpInside];
    self.bookButton.backgroundColor = self.card.tintColor;
    [self.bookButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    self.bookButton.titleLabel.font = [UIFont leoBodyBoldFont];
    
    self.providerLabel.textColor = [UIColor leoWarmHeavyGray];
    self.patientLabel.textColor = [UIColor leoWarmHeavyGray];
    self.appointmentTypeLabel.textColor = [UIColor leoWarmHeavyGray];
    self.appointmentLabel.textColor = [UIColor leoWarmHeavyGray];
    self.appointmentDateLabel.textColor = [UIColor leoOrangeRed];
    self.notesView.delegate = self;
    //UINavigationItem *navCarrier = [[UINavigationItem alloc] init];
    
    UINavigationItem *navCarrier = _navBar.topItem;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SMS-32"]];
    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithCustomView:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    titleLabel.text = @"Schedule An Appointment";
    titleLabel.font = [UIFont leoTitleBasicFont];
    titleLabel.textColor = [UIColor leoWarmHeavyGray];
    [titleLabel sizeToFit];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    

    navCarrier.leftBarButtonItems = @[icon, title];
    //navCarrier.rightBarButtonItems = @[doneBarButton];
    
    self.navBar.items = @[navCarrier];
    
    if (self.prepAppointment.date == nil) {
        self.prepAppointment.date = [self firstAvailableAppointmentTimeFromDate:self.dates.firstObject toDate:self.dates.lastObject];
    }
    
    if (self.prepAppointment.note != nil) {
        self.notesView.text = self.prepAppointment.note;
    }
    
    [self setupAppointmentDateLabel];
    [self setupMonthLabel];
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewWasTapped:)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapGestureForTextFieldDismissal];
}


- (void)updateCard {
    Appointment *appointment = self.card.associatedCardObjects[0];
     appointment = [[Appointment alloc] initWithPrepAppointment:self.prepAppointment]; //FIXME: Make this a loop to account for changes to multiple objects on a card.
    [self.card performSelector:NSSelectorFromString([self.card actionsAvailableForState][0])];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView scrollToViewIfObstructedByKeyboard:self.notesView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.scrollView scrollToViewIfObstructedByKeyboard:nil];
}

#pragma mark - Lifecycle Helper Methods

/**
 *  Prepares a CollectionView for dates with datasource, delegate, layout, cell nib, and associated properties.
 */
- (void)setupDateCollectionView {
    
    void (^configureCell)(LEODateCell *, NSDate*) = ^(LEODateCell* cell, NSDate* date) {
        [cell configureForDate:date];
    };
    
    self.dataSource = [[CollectionViewDataSource alloc] initWithItems:self.dates cellIdentifier:dateReuseIdentifier configureCellBlock:configureCell];
    
    self.dateCollectionView.dataSource = self.dataSource;
    self.dateCollectionView.delegate = self;
    self.dateCollectionView.backgroundColor = [UIColor leoWarmLightGray];
    self.dateCollectionView.pagingEnabled = YES;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:10.0f];
    [flowLayout setMinimumLineSpacing:10.0f];
    self.dateCollectionView.collectionViewLayout = flowLayout;
    
    [self.dateCollectionView registerNib:[UINib nibWithNibName:@"LEODateCell" bundle:nil] forCellWithReuseIdentifier:dateReuseIdentifier];
}

/**
 *  Formats the month label
 */
- (void)setupMonthLabel {
    
    self.monthLabel.textColor = [UIColor leoWarmHeavyGray];
    self.monthLabel.font = [UIFont leoTitleBasicFont];
    
    [self updateMonthLabel];
}

- (void)updateMonthLabel {
    
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM' 'YYYY";
    self.monthLabel.text = [monthYearFormatter stringFromDate:self.prepAppointment.date];
}

- (void)setupAppointmentDateLabel {
    
    self.monthLabel.textColor = [UIColor leoWarmHeavyGray];
    self.monthLabel.font = [UIFont leoTitleBasicFont];
    
    [self updateAppointmentDateLabel];
}

- (void)updateAppointmentDateLabel {
    
    self.appointmentDateLabel.text = [self formatDateTimeForLabel:[[self prepAppointment] date]];
}


/**
 *  Turns an NSDate into an NSString with the following format: January 1, 12:30am
 *
 *  @param dateTime unformatted NSDate object
 *
 *  @return formatted stringified date
 */
- (NSString *)formatDateTimeForLabel:(NSDate *)dateTime {
    
    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];    fullDateFormatter.dateFormat = @"MMMM' 'd', 'h':'mma";
    [fullDateFormatter setAMSymbol:@"am"];
    [fullDateFormatter setPMSymbol:@"pm"];
    NSString *formattedDateTime = [fullDateFormatter stringFromDate:dateTime];
    
    return formattedDateTime;
}

-(void)showDoneBarButtonItem:(BOOL)show{
    [UIView setAnimationsEnabled:NO];
    if(show){
        _cancelButton.title = @"Done";
    }
    else{
        //Patrick
        //TODO: Set cancel button image or whatever the view will look like
        // for exiting out of the card
        _cancelButton.title = @"X";
    }
    [UIView setAnimationsEnabled:YES];
}

#pragma mark UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self showDoneBarButtonItem:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView{

    self.prepAppointment.note = textView.text;
    [self showDoneBarButtonItem:NO];
}



#pragma mark - Setup, Getters, Setters

- (PrepAppointment *)prepAppointment {
    
    Appointment *appt = self.card.associatedCardObjects[0]; //FIXME: Update to deal with array at some point...
    
    if (!_prepAppointment) {
        _prepAppointment = [[PrepAppointment alloc] initWithObjectID:appt.objectID date:appt.date appointmentType:appt.leoAppointmentType patient:appt.patient provider:appt.provider bookedByUser:appt.bookedByUser note:appt.note state:appt.state];
    }
    
    return _prepAppointment;
}

#pragma mark - Segue and segue helper methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.dataManager = [LEODataManager sharedManager];
    
    /**
     *  Segue associated with paged TimeCollectionViewController
     */
    if ([segue.identifier isEqualToString:@"EmbedSegue"]) {
        [self baseViewSetup]; //TODO: See 'MARK' above the implementation of this method.
        self.pageViewController = segue.destinationViewController;
        [self setupPageView];
    }
    
    /**
     *  Segue associated with childDropDownTableView
     */
    if([segue.identifier isEqualToString:@"ChildDropDownEmbedSegue"]) {
        LEOChildDropDownTableViewController *tvc = segue.destinationViewController;
        tvc.prepAppointment = self.prepAppointment;
        tvc.children = self.patients;
    }
}


/* Zachary Drossman
 * MARK: I take issue with the fact
 * that we can only set these things
 * up in our segue because it gets
 * called before view did load.
 * There has to be a better way or we need
 * to avoid using container views.
 */
- (void)baseViewSetup {
    
    self.pageViewDataSource = [[PageViewDataSource alloc] initWithAllItems:self.dates selectedSubsetOfItems:self.dataManager.availableDates];
}

- (void)setupPageView {
    
    self.pageViewController.dataSource = self.pageViewDataSource;
    self.pageViewController.delegate = self;
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    //TODO: Override this and make it such that it fits in three columns on the screen *using autolayout*.
    CGRect pageViewRect = self.containerView.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    //MARK: Should this really be done to bring the gestures forward?
    //self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}


/**
 *  Creates a new timeCollectionViewController and pages to it with the appropriate direction
 *
 *  @param toPage   the index of the page being scrolled to
 *  @param fromPage the index of the page being scrolled from
 */
- (void)turnToPage:(NSInteger)toPage fromPage:(NSInteger )fromPage {
    
    TimeCollectionViewController *timeCollectionVC = [self.pageViewDataSource viewControllerAtIndex:[self indexPathOfDate:self.prepAppointment.date].row storyboard:self.storyboard];
    
    self.timeCollectionVC = timeCollectionVC;
    
    self.timeCollectionVC.delegate = self;
    UIPageViewControllerNavigationDirection direction;
    
    if (fromPage < toPage) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
        
    }
    
    [self.pageViewController setViewControllers:@[timeCollectionVC] direction:direction animated:NO completion:nil];
    
}

/**
 *  Returns the index path of a date relative to the first date available in the dates array
 *
 *  @param date date being searched for in array of dates
 *
 *  @return indexpath of date
 */
- (NSIndexPath *)indexPathOfDate:(NSDate *)date {
    
    NSInteger daysFromBeginningOfDateArray;
    
    if (date) {
        daysFromBeginningOfDateArray = [[date beginningOfDay] daysFrom:self.dates.firstObject];
    } else {
        daysFromBeginningOfDateArray = [self.dataManager.availableDates.firstObject daysFrom:self.dates.firstObject];
    }
    
    return [NSIndexPath indexPathForRow:daysFromBeginningOfDateArray inSection:0];
}


- (NSUInteger)pageOfDate:(NSDate *)date {
    
    NSUInteger page = floor([self indexPathOfDate:date].row / 7.0);
    return page;
}


#pragma mark - IBActions

-(void)doneButtonTapped{
    
}

- (IBAction)cancelTapped:(UIBarButtonItem *)sender {
    
    if(_notesView.isFirstResponder){
        [_notesView resignFirstResponder];
    }
    else{
        [self.card returnToPriorState];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [UIView animateWithDuration:0.2 animations:^{
                self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
                self.collapsedCell.selected = NO;
            }];
        }];
    }
}

- (void)makeUpdatesForChangesToAppointmentDate {
    [self updateMonthLabel];
    [self updateAppointmentDateLabel];
}

- (BOOL)shouldTurnPage {
    
    NSArray *visibleIndexPaths = [[self.dateCollectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    
    if ([visibleIndexPaths containsObject:[self indexPathOfDate:self.prepAppointment.date]]) {
        return NO;
    }
    
    return YES;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateCollectionView:collectionView forSelectedCellAtIndexPath:indexPath];
    [self turnToPage:[self pageOfDate:self.prepAppointment.date] fromPage:0];
}

- (void)updateCollectionView:(UICollectionView *)collectionView forSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
    
    self.prepAppointment.date = self.dates[indexPath.row];
    
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LEODateCell *cell = (LEODateCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.selectable) {
        return YES;
    }
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selected = NO;
    
    NSDate *date = self.dates[indexPath.row];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    //If the cell about to be displayed is showing the same date as the date of the appointment
    if ([calendar isDate:date inSameDayAsDate:self.prepAppointment.date]) {
        
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        //MARK: Double check whether the conditional around the turnToPage method call is doing anything.
        if ([self shouldTurnPage]) {
            [self turnToPage:[self pageOfDate:self.prepAppointment.date] fromPage:0];
        }
    } else {
        
        NSArray *availableSlotsForDate = [self.dataManager availableTimesForDate:date];
        ((LEODateCell *)cell).selectable = [availableSlotsForDate count] > 0 ? YES : NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    [self updateSelectedCellBasedOnScrollViewUpdate:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startingContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateSelectedCellBasedOnScrollViewUpdate:scrollView];
}

- (void)updateSelectedCellBasedOnScrollViewUpdate:(UIScrollView *)scrollView {
    
    NSArray *indexPathsOfVisibleItems = [[self.dateCollectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSIndexPath *indexPath in indexPathsOfVisibleItems) {
        LEODateCell *cell = (LEODateCell *)[self.dateCollectionView cellForItemAtIndexPath:indexPath];
        
        if (cell.selectable) {
            [self updateCollectionView:self.dateCollectionView forSelectedCellAtIndexPath:indexPath];
            [self turnToPage:[self pageOfDate:self.prepAppointment.date] fromPage:0];
            break;
        }
    }
}

-(void)scrollViewWasTapped:(UIGestureRecognizer*)gesture{
    if (_notesView.isFirstResponder) {
        [_notesView resignFirstResponder];
    }
}


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.view.frame.size.width - 70)/7.0, 55.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10,5,10,5);
}



#pragma mark - <UPageViewControllerDelegate> + Helper Methods

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    self.tempSelectedDate = ((TimeCollectionViewController *)pendingViewControllers[0]).selectedDate;
    NSLog(@"Date to transition to: %@", self.tempSelectedDate);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        
        self.prepAppointment.date = self.tempSelectedDate;
        NSIndexPath *indexPathToSelect = [self indexPathOfDate:self.prepAppointment.date];
        [self scrollDateCollectionViewToWeekOfAppointmentDate];
        [self updateCollectionView:self.dateCollectionView forSelectedCellAtIndexPath:indexPathToSelect];
        
    } else {
        self.prepAppointment.date = [self firstAvailableAppointmentTimeFromDate:self.prepAppointment.date toDate:self.prepAppointment.date];
        self.timeCollectionVC.selectedDate = self.prepAppointment.date;
    }
}

- (void) scrollDateCollectionViewToWeekOfAppointmentDate {
    
    NSArray *visibleIndexPaths = [[self.dateCollectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    
    NSIndexPath *firstVisibleIndexPath = visibleIndexPaths[0];
    
    NSIndexPath *indexPathOfAppointmentWeekBeginning = [self indexPathOfDate:[[self.prepAppointment.date beginningOfDay] beginningOfWeekForStartOfWeek:1]];
    CGPoint offset = self.dateCollectionView.contentOffset;
    
    CGFloat horizontalInsets = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout     insetForSectionAtIndex:0].left + [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout insetForSectionAtIndex:0].right;
    
    CGFloat cellWidth = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout sizeForItemAtIndexPath:indexPathOfAppointmentWeekBeginning].width;
    
    NSInteger numberOfCellsToScroll = indexPathOfAppointmentWeekBeginning.row - firstVisibleIndexPath.row;
    
    offset.x += numberOfCellsToScroll * (cellWidth + horizontalInsets);
    
    [self.dateCollectionView setContentOffset:offset animated:YES];
}

#pragma mark - <TimeSelectionDelegate>
- (void)didUpdateAppointmentDateTime:(NSDate *)dateTime {
    self.prepAppointment.date = dateTime;
    [self makeUpdatesForChangesToAppointmentDate];
}

#pragma mark - <CardActivityDelegate>
- (void)didUpdateObjectStateForCard:(LEOCard *)card {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            // self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
            self.collapsedCell.selected = NO;
        }];
    }];
}

- (void)updateViews:(LEOCardScheduling *)card {
    
    Appointment *appointment = card.associatedCardObjects[0]; //FIXME: Update to deal with array at some point.
    
    switch (appointment.appointmentState) {
            
        case AppointmentStateBooking: {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [UIView animateWithDuration:0.2 animations:^{
                    // self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
                    self.collapsedCell.selected = NO;
                }];
            }];
        }
            
        case AppointmentStateCancelling: {
            
        }
            
        case AppointmentStateConfirmingCancelling: {
            
        }
    
        case AppointmentStateRecommending: {
            
        }
            
        case AppointmentStateReminding: {
            
        }
    }
}


#pragma mark - Helper Date Methods
- (NSArray *)dates {
    
    if (!_dates || [((NSDate *)_dates.firstObject) daysFrom:[self startDate]] != 0) {
        
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        
        NSDate *lastDate = [[self startDate] dateByAddingDays:180];
        
        NSDate *dateToAdd = [self startDate];
        
        while ([dateToAdd timeIntervalSinceDate:lastDate] < 0) {
            [dateArray addObject:dateToAdd];
            dateToAdd = [dateToAdd dateByAddingDays:1];
        }
        
        _dates = dateArray;
    }
    
    return _dates;
}


//MARK: Strategically, at scale this may not make sense, but with a few patients, we can probably do this and not engage too many conflicts.
/**
 *  Finds the first appointment available within a given range of dates. Input is based on the date portion of the NSDate; time portion is ignored.
 *
 *  @param fromDate starting date for range
 *  @param toDate   ending date for range, inclusive
 *
 *  @return NSDate that is the first appointment available in the range
 */
- (NSDate *)firstAvailableAppointmentTimeFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate {
    
    NSUInteger fromDateIndex = [self findIndexForExactDate:[fromDate beginningOfDay] inArray:self.dates];
    NSUInteger toDateIndex = [self findIndexForExactDate:[toDate beginningOfDay] inArray:self.dates];
    
    NSUInteger rangeLength = toDateIndex - fromDateIndex + 1;
    NSRange dateRange = NSMakeRange(fromDateIndex, rangeLength);
    
    NSArray *dateSubarray = [self.dates subarrayWithRange:dateRange];
    
    for (NSInteger i = 0; i < rangeLength; i++) {
        
        NSArray *availableTimes = [self.dataManager availableTimesForDate:dateSubarray[i]];
        
        if ([availableTimes count] > 0) {
            return availableTimes[0];
        }
    }
    
    //FIXME: Need to deal with rare case in which no dates have availability so app doesn't crash here. I really hope we crash for this reason someday though...
    //    ALog(@"No available times for any date in range.");
    return nil;
}

- (NSUInteger)findIndexForExactDate:(NSDate *)date inArray:(NSArray *)array {
    
    for (NSInteger i = 0; i < [array count]; i++) {
        if ([date isEqualToDate:array[i]]) {
            return i;
        }
    }
    
    ALog(@"Warning: Couldn't find index for exact date.");
    return 0; //FIXME: Deal with this.
}

- (NSDate *)startDate {
    
    static NSDate *startDate;
    
    if (!startDate) {
        
        startDate = [[NSDate date].beginningOfDay beginningOfWeekForStartOfWeek:1];
    }
    
    return startDate;
}


@end
