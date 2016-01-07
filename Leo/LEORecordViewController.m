//
//  LEOEHRViewController.m
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEORecordViewController.h"
#import "LEOHealthRecordService.h"
#import "HealthRecord.h"

@interface LEORecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL updatedConstraintsOnce;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString *cellReuseIdentifier;

@property (strong, nonatomic) HealthRecord *healthRecord;

@end

@implementation LEORecordViewController

NS_ENUM(NSInteger, PHRTableViewSection) {
    PHRTableViewSectionRecentVitals,
    PHRTableViewSectionAllergies,
    PHRTableViewSectionMedications,
    PHRTableViewSectionImmunizations,
    PHRTableViewSectionNotes,
};

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // request health record
    [self requestHealthRecord];
}

#pragma mark - Accessors and Setup

- (UITableView *)tableView {

    if (!_tableView) {

        UITableView *strongView = [UITableView new];
        [self.view addSubview:strongView];
        _tableView = strongView;

        _tableView.dataSource = self;
        _tableView.delegate = self;

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellReuseIdentifier];
    }
    return _tableView;
}

- (NSString *)cellReuseIdentifier {
    if (!_cellReuseIdentifier) {
        _cellReuseIdentifier = @"PLACEHOLDER";
    }
    return _cellReuseIdentifier;
}

- (void)requestHealthRecord {

    BOOL useMock = YES;

    if (useMock) {

        HealthRecord *hr = [HealthRecord mockObject];
        self.healthRecord = hr;
    } else {

        LEOHealthRecordService *service = [LEOHealthRecordService new];
        [service getHealthRecordForUser:self.patient withCompletion:^(HealthRecord *healthRecord, NSError *error) {

            if (error) {

                NSLog(@"ERROR: phr request - %@", error);
            }

            NSLog(@"RESPONSE: %@", healthRecord);

            self.healthRecord = healthRecord;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - Layout

- (void)updateViewConstraints {

    [super updateViewConstraints];

    if (!self.updatedConstraintsOnce) {

        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);

        NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:viewsDictionary];
        NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:viewsDictionary];

        [self.view addConstraints:tableViewHorizontalConstraints];
        [self.view addConstraints:tableViewVerticalConstraints];

        self.updatedConstraintsOnce = YES;
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case PHRTableViewSectionRecentVitals:
            rows += self.healthRecord.bmis.count > 0;
            rows += self.healthRecord.heights.count > 0;
            rows += self.healthRecord.weights.count > 0;
            break;

        case PHRTableViewSectionAllergies:
            rows = self.healthRecord.allergies.count;
            break;

        case PHRTableViewSectionMedications:
            rows = self.healthRecord.medications.count;
            break;

        case PHRTableViewSectionImmunizations:
            rows = self.healthRecord.immunizations.count;
            break;

        case PHRTableViewSectionNotes:
            rows = self.healthRecord.notes.count;
            break;

        default:
            break;
    };
    return rows;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];



     cell.textLabel.text = [NSString stringWithFormat:@"%@", indexPath];

     return cell;
}



@end
