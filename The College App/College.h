//
//  College.h
//  The College App
//
//  Created by Jeffrey Barg on 7/12/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface College : NSManagedObject

@property (nonatomic, retain) NSString * admissionsInternetAddress;
@property (nonatomic, retain) NSNumber * admissionsTotal;
@property (nonatomic, retain) NSNumber * applicantsTotal;
@property (nonatomic, retain) NSNumber * applicationFee;
@property (nonatomic, retain) NSString * calendarSystem;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * combinedSATAverage;
@property (nonatomic, retain) NSNumber * compositeACT25;
@property (nonatomic, retain) NSNumber * compositeACT75;
@property (nonatomic, retain) NSNumber * enrolledMen;
@property (nonatomic, retain) NSNumber * enrolledTotal;
@property (nonatomic, retain) NSNumber * enrolledWomen;
@property (nonatomic, retain) NSString * financialAidInternetAddress;
@property (nonatomic, retain) NSNumber * hasROTC;
@property (nonatomic, retain) NSString * institutionControl;
@property (nonatomic, retain) NSString * internetAddress;
@property (nonatomic, retain) NSNumber * mathSAT25;
@property (nonatomic, retain) NSNumber * mathSAT75;
@property (nonatomic, retain) NSString * missionStatement;
@property (nonatomic, retain) NSString * missionStatementInternetAddress;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameAlias;
@property (nonatomic, retain) NSString * onlineApplicationInternetAddress;
@property (nonatomic, retain) NSNumber * openAdmissionPolicy;
@property (nonatomic, retain) NSNumber * phoneNumber;
@property (nonatomic, retain) NSNumber * readingSAT25;
@property (nonatomic, retain) NSNumber * readingSAT75;
@property (nonatomic, retain) NSString * reportingPeriod;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * stateAbbreviation;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSNumber * totalPriceInState;
@property (nonatomic, retain) NSNumber * totalPriceOutState;
@property (nonatomic, retain) NSNumber * tuitionAndFees;
@property (nonatomic, retain) NSNumber * undergraduatePopulation;
@property (nonatomic, retain) NSNumber * writingSAT25;
@property (nonatomic, retain) NSNumber * writingSAT75;
@property (nonatomic, retain) NSNumber * zipcode;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * unitID;

@end
