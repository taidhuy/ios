//
//  Constants.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CardLayout {
    CardLayoutTwoButtonPrimaryAndSecondary = 0,
    CardLayoutTwoButtonSecondaryOnly = 1,
    CardLayoutTwoButtonPrimaryOnly = 2,
    CardLayoutOneButtonPrimaryAndSecondary = 3,
    CardLayoutOneButtonSecondaryOnly = 4,
    CardLayoutOneButtonPrimaryOnly = 5,
    CardLayoutUndefined = 99
} CardLayout;

/**
 *  Description AppointmentStatusCode tracks the status of the appointment
 *
 *  @AppointmentStatusCodeReminding              An appointment that is coming up AND of which we are reminding the user. Internal Leo status only.
 *  @AppointmentStatusCodeFuture                 An upcoming appointment prior to check-in that includes no shows. It is on Leo to cancel appointments from Athena. Athena supported.
 *  @AppointmentStatusCodeOpen                   A slot that can be deleted. Currently unsupported by iOS app. Athena supported.
 *  @AppointmentStatusCodeCheckedIn              Patient has checked in at the practice, but has not yet completed their visit. Currently unsupported by iOS app. Athena supported.
 *  @AppointmentStatusCodeCheckedOut             Patient has completed their visit and left the office. Currently unsupported by iOS app. Athena supported.
 *  @AppointmentStatusCodeChargeEntered          Completed and has been submitted to billing. Athena supported. Currently unsupported by iOS app.
 *  @AppointmentStatusCodeCancelled              Cancelled by staff or user. Athena supported.
 *  @AppointmentStatusCodeBooking                Patient is in process of making appointment. Internal Leo status only for use by iOS app. Not supported on Leo backend.
 *  @AppointmentStatusCodeCancelling             Patient is in process of cancelling appointment. Internal Leo status only for use on iOS app. Not supported on Leo backend.
 *  @AppointmentStatusCodeConfirmingCancelling   Patient has cancelled appointment but not yet dismissed card from app. Internal Leo status for use on iOS app. Not supported by Leo backend.
 *  @AppointmentStatusCodeRecommending           Leo creates appointment object for user without filling out date of appointment. User may decide to make appointment or not. Internal Leo status only.
 */
typedef enum AppointmentStatusCode : NSUInteger {
    AppointmentStatusCodeReminding = 0,
    AppointmentStatusCodeFuture = 1,
    AppointmentStatusCodeOpen = 2,
    AppointmentStatusCodeCheckedIn = 3,
    AppointmentStatusCodeCheckedOut = 4,
    AppointmentStatusCodeChargeEntered = 5,
    AppointmentStatusCodeCancelled = 6,
    AppointmentStatusCodeBooking = 7,
    AppointmentStatusCodeCancelling = 8,
    AppointmentStatusCodeConfirmingCancelling = 9,
    AppointmentStatusCodeRecommending = 10,
    AppointmentStatusCodeNew = 11,
    AppointmentStatusCodeUndefined = 99,
} AppointmentStatusCode;

/**
 *  Description MessageStatusCode tracks the status of the message
 *
 *  @MessageStatusCodeRead
 *  @MessageStatusCodeUnread
 *  @MessageStatusCodeEscalated
 *  @MessageStatusCodeClosed
 *  @MessageStatusCodeOpen
 *  @MessageStatusCodeUndefined
 *
 */
typedef enum MessageStatusCode : NSUInteger {
    MessageStatusCodeRead = 0,
    MessageStatusCodeUnread = 1,
    MessageStatusCodeEscalated = 2,
    MessageStatusCodeClosed = 3,
    MessageStatusCodeOpen   = 4,
    MessageStatusCodeUndefined = 99
} MessageStatusCode;

/**
 *  Description ConversationStatusCode tracks the status of the conversation
 *
 *  @ConversationStatusCodeClosed   
 *  @ConversationStatusCodeOpen
 *  @ConversationStatusCodeEscalated
 *
 */
typedef enum ConversationStatusCode : NSUInteger {
    ConversationStatusCodeClosed = 0,
    ConversationStatusCodeOpen = 1,
    ConversationStatusCodeNewMessages = 2,
    ConversationStatusCodeReadMessages = 3,
    ConversationStatusCodeUndefined = 99
} ConversationStatusCode;

/**
 *  Description AppointmentReason describes the reason for which the patient is making the appointment
 *
 *  @AppointmentTypeCheckup       A regular checkup that is typically scheduled every few months up until age 2 and annually thereafter.
 *  @AppointmentTypeSick          A visit to address new symptoms like cough, cold, ear pain, fever, diarrhea, or rash.
 *  @AppointmentTypeImmunizations A visit with a nurse to get one or more immunizations.
 *  @AppointmentTypeFollowup        A visit to follow-up on known conditionss like asthma, sickness, ADHD, or eczema.
 */
typedef enum AppointmentTypeCode : NSUInteger {
    AppointmentTypeCodeCheckup = 0,
    AppointmentTypeCodeSick = 1,
    AppointmentTypeCodeImmunization = 2,
    AppointmentTypeCodeFollowUp = 3,
    AppointmentTypeCodeUndefined = 99
} AppointmentTypeCode;

typedef enum MessageTypeCode : NSUInteger {
    MessageTypeCodeText = 0,
    MessageTypeCodeImage = 1,
    MessageTypeCodeUndefined = 99
} MessageTypeCode;

typedef enum RoleCode : NSUInteger {
    RoleCodeProvider = 0,
    RoleCodeNursePractitioner = 1,
    RoleCodeCustomerService = 2,
    RoleCodeBilling = 3,
    RoleCodeGuardian = 4,
    RoleCodePatient = 5,
    RoleCodeUndefined = 99,
} RoleCode;

@interface LEOConstants : NSObject

#pragma mark - Temp constants
extern NSString *const kUserToken; // @"";

#pragma mark - URL & endpoints

extern NSString *const APIEndpointUsers; // @"users";
extern NSString *const APIEndpointSessions; // @"sessions";
extern NSString *const APIEndpointResetPassword; // @"sessions/password";
extern NSString *const APIEndpointAppointments; // @"appointments";
extern NSString *const APIEndpointConversations; // @"conversations";
extern NSString *const APIEndpointMessages; // @"messages";
extern NSString *const APIEndpointAppointmentTypes; // @"appointmentTypes";
extern NSString *const APIEndpointLogin; // @"login";
extern NSString *const APIEndpointCards; // @"cards";
extern NSString *const APIEndpointPractices; // @"practices";
extern NSString *const APIEndpointPractice; // @"practice";

extern NSString *const APIEndpointSlots; // @"slots";
extern NSString *const APIEndpointFamily; // @"family";

#pragma mark - Common
extern NSString *const APIParamID; // @"id";
extern NSString *const APIParamState; // @"appointment_status_id";
extern NSString *const APIParamData; // @"data";
extern NSString *const APIParamType; // @"type";
extern NSString *const APIParamTypeID; // @"type_id";
extern NSString *const APIParamStatus; // @"status";
extern NSString *const APIParamStatusID; // @"status_id";
extern NSString *const APIParamName; // @"name";
extern NSString *const APIParamDescription; // @"description";
extern NSString *const APIParamShortDescription; // @"short_description";
extern NSString *const APIParamLongDescription; // @"long_description";

extern NSString *const APIParamToken; // @"token";

#pragma mark - Date & time
extern NSString *const APIParamCreatedDateTime; // @"created_datetime";
extern NSString *const APIParamUpdatedDateTime; // @"updated_datetime";

#pragma mark - Practice
extern NSString *const APIParamPracticeID; // @"practice_id";
extern NSString *const APIParamPractice; // @"practice";
extern NSString *const APIParamPracticeLocationAddressLine1; // @"address_line_1";
extern NSString *const APIParamPracticeLocationAddressLine2; // @"address_line_2";
extern NSString *const APIParamPracticeLocationCity; // @"city";
extern NSString *const APIParamPracticeLocationState; // @"state";
extern NSString *const APIParamPracticeLocationZip; // @"zip";
extern NSString *const APIParamPracticePhone; // @"phone";
extern NSString *const APIParamPracticeEmail; // @"email";
extern NSString *const APIParamPracticeName; // @"name";
extern NSString *const APIParamPracticeFax; // @"fax";

#pragma mark - Family
extern NSString *const APIParamFamilyID; // @"family_id";
extern NSString *const APIParamFamily; // @"family";

#pragma mark - User and user subclass

extern NSString *const APIParamUserTitle; // @"title";
extern NSString *const APIParamUserFirstName; // @"first_name";
extern NSString *const APIParamUserMiddleInitial; // @"middle_initial";
extern NSString *const APIParamUserLastName; // @"last_name";
extern NSString *const APIParamUserSuffix; // @"suffix";
extern NSString *const APIParamUserEmail; // @"email";
extern NSString *const APIParamUserAvatarURL; // @"avatar_url";

extern NSString *const APIParamUserProviderID; // @"provider_id";

extern NSString *const APIParamUserPatientID; // @"provider_id";
extern NSString *const APIParamUserBookedByID; // @"booked_by_id";

extern NSString *const APIParamUserCredentials; // @"credentials";
extern NSString *const APIParamUserSpecialties; // @"specialties";
extern NSString *const APIParamUserPrimary; // @"primary";
extern NSString *const APIParamUserStatus; // @"status";

extern NSString *const APIParamUserBirthDate; // @"birth_date";
extern NSString *const APIParamUserSex; // @"sex";
extern NSString *const APIParamUserPassword; // @"password";

#pragma mark - Common user object references
extern NSString *const APIParamUser; // @"user";
extern NSString *const APIParamUsers; // @"users";
extern NSString *const APIParamUserStaff; // @"staff";
extern NSString *const APIParamUserProvider; // @"provider";
extern NSString *const APIParamUserProviders; // @"providers";
extern NSString *const APIParamUserPatient; // @"patient";
extern NSString *const APIParamUserPatients; // @"patients";
extern NSString *const APIParamUserParent; // @"parent";
extern NSString *const APIParamUserParents; // @"parents";
extern NSString *const APIParamUserGuardian; // @"guardian";
extern NSString *const APIParamUserGuardians; // @"guardians";
extern NSString *const APIParamUserSupport; // @"support";
extern NSString *const APIParamUserSupports; // @"supports";

#pragma mark - Role
extern NSString *const APIParamRole; // @"role";
extern NSString *const APIParamRoleID; // @"role_id";

#pragma mark - Relationship
extern NSString *const APIParamRelationship; // @"relationship";
extern NSString *const APIParamRelationshipID; // @"relationship_id";

#pragma mark - Conversation & message
extern NSString *const APIParamConversations; // @"conversations";
extern NSString *const APIParamConversationMessageCount; // @"message_count";
extern NSString *const APIParamConversationLastEscalatedDateTime; // @"last_escalated_datetime";
extern NSString *const APIParamConversationParticipants; // @"participants";

extern NSString *const APIParamMessages; // @"messages";
extern NSString *const APIParamMessageBody; // @"body";
extern NSString *const APIParamMessageSender; // @"sender";
extern NSString *const APIParamMessageEscalatedTo; // @"escalated_to";

#pragma mark - Payment & Stripe
extern NSString *const APIParamPaymentBalance; // @"balance";
extern NSString *const APIParamPaymentDueDateTime; // @"due_datetime";
extern NSString *const APIParamPaymentPaidBy; // @"paid_by";

extern NSString *const APIParamStripe; // @"stripe";
extern NSString *const APIParamStripeCustomerId; // @"customer_id";
extern NSString *const APIParamStripeAmountPaid; // @"amount_paid";
extern NSString *const APIParamStripeSource; // @"source";
extern NSString *const APIParamStripeSourceObject; // @"object";
extern NSString *const APIParamStripeSourceBrand; // @"brand";

#pragma mark - Forms
extern NSString *const APIParamFormSubmittedDateTime; // @"submitted_datetime";
extern NSString *const APIParamFormSubmittedBy; // @"submitted_by";
extern NSString *const APIParamFormTitle; // @"title";
extern NSString *const APIParamFormNotes; // @"notes";

#pragma mark - Card
extern NSString *const APIParamCardCount; // @"count";
extern NSString *const APIParamCardData; // @"card_data";
extern NSString *const APIParamCardPriority; // @"priority";

#pragma mark - Appointment type
extern NSString *const APIParamAppointmentType; // @"visit_type";
extern NSString *const APIParamAppointmentTypeID; // @"visit_type_id";

extern NSString *const APIParamAppointmentTypeDuration; // @"duration";
extern NSString *const APIParamAppointmentTypeLongDescription; // @"long_description";
extern NSString *const APIParamAppointmentTypeShortDescription; // @"short_description";

#pragma mark - Appointment
extern NSString *const APIParamAppointment; // @"appointment";
extern NSString *const APIParamAppointmentStartDateTime; // @"start_datetime";
extern NSString *const APIParamAppointmentNotes; // @"notes";
extern NSString *const APIParamAppointmentBookedBy; // @"booked_by";

#pragma mark - Appointment slot
extern NSString *const APIParamSlots; // @"slots";
extern NSString *const APIParamSlotStartDateTime; // @"start_datetime";
extern NSString *const APIParamSlotDuration; // @"duration";
extern NSString *const APIParamStartDate; // @"start_date";
extern NSString *const APIParamEndDate; // @"end_date";

#pragma mark - Magic numbers
extern CGFloat const selectionLineHeight; // 2.0f;

@end

