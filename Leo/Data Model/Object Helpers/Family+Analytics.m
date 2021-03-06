//
//  Family+Analytics.m
//  Leo
//
//  Created by Annie Graham on 6/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Family+Analytics.h"
#import "Patient.h"

@implementation Family (Analytics)

- (NSDictionary *)analyticAttributes {

    NSDictionary* attributeDictionary =
    @{@"Number of Children" : @([self numberOfChildren]),
      @"Age of oldest child" : @([self ageOfOldestChild]),
      @"Age of youngest child" : @([self ageOfYoungestChild]),
      @"Number of children older than 0 & younger than 2" : @([self numberOfChildrenZeroToTwo]),
      @"Number of children older than 2 & younger than 5" : @([self numberOfChildrenTwoToFive]),
      @"Number of children older than 5 & younger than 13": @([self numberOfChildrenFiveToThirteen]),
      @"Number of children older than 13 & younger than 18": @([self numberOfChildrenThirteenToEighteen]),
      @"Number of children older than 18": @([self numberOfChildrenEighteenOrOlder])};

    return attributeDictionary;
}

- (NSInteger)numberOfChildren {
    
    NSInteger numberOfPatients = [self.patients count];
    return numberOfPatients;
}

- (NSInteger)numberOfChildrenZeroToTwo {
    return [self numberOfPatientsGreaterThanOrEqualToAge:0 andUnderAge: 2];
}

- (NSInteger)numberOfChildrenTwoToFive {
    return [self numberOfPatientsGreaterThanOrEqualToAge:2 andUnderAge:5];
}

- (NSInteger)numberOfChildrenFiveToThirteen {
    return [self numberOfPatientsGreaterThanOrEqualToAge:5 andUnderAge:13];
}

- (NSInteger)numberOfChildrenThirteenToEighteen {
    return [self numberOfPatientsGreaterThanOrEqualToAge:13 andUnderAge:18];
}

- (NSInteger)numberOfChildrenEighteenOrOlder {
    return [self numberOfPatientsGreaterThanOrEqualToAge:13 andUnderAge:18];
}

- (NSInteger)numberOfPatientsGreaterThanOrEqualToAge:(NSInteger)olderThan
                                         andUnderAge:(NSInteger)youngerThan {
    
    NSArray *patients = self.patients;
    
    NSDate *now = [NSDate date];
    NSDateComponents *dateBornAfter = [NSDateComponents new];
    NSDateComponents *dateBornBefore = [NSDateComponents new];
    dateBornAfter.year = youngerThan * -1;
    dateBornBefore.year = olderThan * -1;
    
    NSDate *bornAfter =
    [[NSCalendar currentCalendar] dateByAddingComponents: dateBornAfter
                                                  toDate: now
                                                 options:0];
    NSDate *bornBefore =
    [[NSCalendar currentCalendar] dateByAddingComponents: dateBornBefore
                                                  toDate: now
                                                 options:0];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"dob >= %@ AND dob < %@", bornAfter, bornBefore];
    NSArray *patientsInAgeRange = [patients filteredArrayUsingPredicate:predicate];
    
    return [patientsInAgeRange count];
}

- (NSInteger)calculateAgeFromDOB:(NSDate*)dob {
    
    NSDateComponents *dobToPresent =
    [[NSCalendar currentCalendar] components: NSCalendarUnitYear
                                    fromDate:dob
                                      toDate:[NSDate date]
                                     options:0];
    
    return dobToPresent.year;
}

- (NSInteger)ageOfOldestChild {
    
    NSArray *youngestToOldest = [self patientsSortedByAscendingAge];
    Patient *oldest = youngestToOldest.lastObject;
    
    return [self calculateAgeFromDOB:oldest.dob];
}

- (NSInteger)ageOfYoungestChild {
    
    NSArray *youngestToOldest = [self patientsSortedByAscendingAge];
    Patient *youngest = youngestToOldest.firstObject;
    
    return [self calculateAgeFromDOB:youngest.dob];
}

- (NSArray *)patientsSortedByAscendingAge {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dob" ascending:NO];
    
    return [self.patients sortedArrayUsingDescriptors:@[sortDescriptor]];
}


@end
