//
//  Constants.h
//  Leo
//
//  Created by Zachary Drossman on 5/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOAnalyticConstants.h"

typedef NS_ENUM(NSUInteger, DeviceModel) {

    DeviceModelUnsupported,
    DeviceModel4OrLess,
    DeviceModel5,
    DeviceModel6,
    DeviceModel6Plus,
};

typedef void(^DefaultVoidBlock)(void);

typedef NS_ENUM(NSUInteger, CardLayout) {
    CardLayoutUndefined = 0,
    CardLayoutTwoButtonPrimaryAndSecondary = 1,
    CardLayoutTwoButtonSecondaryOnly = 2,
    CardLayoutTwoButtonPrimaryOnly = 3,
    CardLayoutOneButtonPrimaryAndSecondary = 4,
    CardLayoutOneButtonSecondaryOnly = 5,
    CardLayoutOneButtonPrimaryOnly = 6,
};

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
 *  @AppointmentStatusUndefined                  Any numeric value that is not defined explicitly
 */
typedef NS_ENUM(NSUInteger, AppointmentStatusCode) {
    AppointmentStatusCodeUndefined = 0,
    AppointmentStatusCodeCheckedIn = 1,
    AppointmentStatusCodeCheckedOut = 2,
    AppointmentStatusCodeChargeEntered = 3,
    AppointmentStatusCodeFuture = 4,
    AppointmentStatusCodeOpen = 5,
    AppointmentStatusCodeCancelled = 6,
    AppointmentStatusCodeBooking = 7,
    AppointmentStatusCodeCancelling = 8,
    AppointmentStatusCodeConfirmingCancelling = 9,
    AppointmentStatusCodeRecommending = 10,
    AppointmentStatusCodeNew = 11,
    AppointmentStatusCodeReminding = 12,
};


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
typedef NS_ENUM(NSUInteger, MessageStatusCode) {
    MessageStatusCodeUndefined = 0,
    MessageStatusCodeRead = 1,
    MessageStatusCodeUnread = 2,
    MessageStatusCodeEscalated = 3,
    MessageStatusCodeClosed = 4,
    MessageStatusCodeOpen = 5,
};

/**
 *  Description ConversationStatusCode tracks the status of the conversation
 *
 *  @ConversationStatusCodeClosed   
 *  @ConversationStatusCodeOpen
 *  @ConversationStatusCodeEscalated
 *
 */
typedef NS_ENUM(NSUInteger, ConversationStatusCode) {
    ConversationStatusCodeUndefined = 0,
    ConversationStatusCodeClosed = 1,
    ConversationStatusCodeOpen = 2,
    ConversationStatusCodeNewMessages = 3,
    ConversationStatusCodeReadMessages = 4,
    ConversationStatusCodeCallUs = 5,
};

/**
 *  Description AppointmentReason describes the reason for which the patient is making the appointment
 *
 *  @AppointmentTypeCheckup       A regular checkup that is typically scheduled every few months up until age 2 and annually thereafter.
 *  @AppointmentTypeSick          A visit to address new symptoms like cough, cold, ear pain, fever, diarrhea, or rash.
 *  @AppointmentTypeImmunizations A visit with a nurse to get one or more immunizations.
 *  @AppointmentTypeFollowup        A visit to follow-up on known conditionss like asthma, sickness, ADHD, or eczema.
 */
typedef NS_ENUM(NSUInteger, AppointmentTypeCode) {
    AppointmentTypeCodeUndefined = 0,
    AppointmentTypeCodeSick = 1,
    AppointmentTypeCodeFollowUp = 2,
    AppointmentTypeCodeImmunization = 3,
    AppointmentTypeCodeWellVisit = 4,
};

typedef NS_ENUM(NSUInteger, MessageTypeCode) {
    MessageTypeCodeUndefined = 0,
    MessageTypeCodeText = 1,
    MessageTypeCodeImage = 2,
};

typedef NS_ENUM(NSUInteger, RoleCode) {
    RoleCodeUndefined = 0,
    RoleCodeFinancial = 1,
    RoleCodeClinicalSupport = 2,
    RoleCodeCustomerService = 3,
    RoleCodeGuardian = 4,
    RoleCodeClinical = 5,
    RoleCodeBot = 6,
    RoleCodeOperational = 7,
};

typedef NS_ENUM(NSUInteger, ManagementMode) {
    ManagementModeUndefined = 0,
    ManagementModeCreate = 1,
    ManagementModeEdit = 2,
};

typedef NS_ENUM(NSUInteger, Feature) {
    FeatureUndefined = 0,
    FeatureOnboarding = 1,
    FeatureSettings = 2,
    FeatureAppointmentScheduling = 3,
    FeatureMessaging = 4,
    FeaturePayment = 5,
    FeaturePHR = 6,
};

typedef NS_ENUM(NSUInteger, MembershipType) {
    
    MembershipTypeUnknown = 0, //Not used explicitly, but in case nil is entered...
    MembershipTypeIncomplete = 1,
    MembershipTypeDelinquent = 2,
    MembershipTypeMember = 3,
    MembershipTypeExempted = 4,
    MembershipTypeExpecting = 5,
    MembershipTypePreview = 6,
};

typedef NS_ENUM(NSUInteger, LEOErrorDomainContentCodes) {

    LEOErrorDomainContentCodeMissingContent,
};

typedef void(^LEOVoidBlock)(void);
typedef void(^LEOErrorBlock)(NSError *error);
typedef void(^LEOArrayBlock)(NSArray *objects);
typedef void(^LEODictionaryBlock)(NSDictionary *hash);
typedef void(^LEOArrayErrorBlock)(NSArray *objects, NSError *error);
typedef void(^LEODictionaryErrorBlock)(NSDictionary *hash, NSError *error);
typedef void(^LEOObjectBlock)(id object);
typedef void(^LEOObjectErrorBlock)(id object, NSError *error);


@interface LEOConstants : NSObject


#pragma mark - Temp constants
extern NSString *const kUserToken; // @"";


#pragma mark - URL & endpoints
extern NSString *const APIEndpointUsers; // @"users";
extern NSString *const APIEndpointCurrentUser; // @"users/current";
extern NSString *const APIEndpointPatients; // @"patients";
extern NSString *const APIEndpointSessions; // @"sessions";
extern NSString *const APIEndpointResetPassword; // @"sessions/password";
extern NSString *const APIEndpointChangePassword; // @"passwords/change_password";
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
extern NSString *const APIEndpointPatientList; // @"family/patients";
extern NSString *const APIEndpointInsurers; // @"insurers";
extern NSString *const APIEndpointUserEnrollments; // @"enrollments";
extern NSString *const APIEndpointPatientEnrollments; // @"patient_enrollments";
extern NSString *const APIEndpointAvatars; // @"avatars";
extern NSString *const APIEndpointAddCaregiver; // @"invite";
extern NSString *const APIEndpointHealthRecord; // @"patients";
extern NSString *const APIEndpointNotes; // @"notes";
extern NSString *const APIEndpointMedications; // @"medications";
extern NSString *const APIEndpointAllergies; // @"allergies";
extern NSString *const APIEndpointImmunizations; // @"immunizations";
extern NSString *const APIEndpointBMIs; // @"bmis";
extern NSString *const APIEndpointHeights; // @"height";
extern NSString *const APIEndpointWeights; // @"weight";
extern NSString *const APIEndpointPusherAuth; // @"pusher/auth";
extern NSString *const APIEndpointConfiguration; // @"ios_configuration";
extern NSString *const APIEndpointPHR; // @"phr";
extern NSString *const APIEndpointConversationNotices; // @"conversation_notices";


extern NSString *const APIEndpointSubscriptions; // @"subscriptions";
extern NSString *const APIEndpointValidatePromoCode; // @"validate_coupon";

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
extern NSString *const APIParamSession; // @"session";


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
extern NSString *const APIParamPracticeTimeZone; // @"time_zone";
extern NSString *const APIParamPracticeActiveSchedule; // @"active_schedule";
extern NSString *const APIParamPracticeScheduleExceptions; // @"schedule_exceptions";
extern NSString *const APIParamStartDateTime; // @"start_datetime";
extern NSString *const APIParamEndDateTime; // @"end_datetime";
extern NSString *const APIParamPracticeScheduleType; // @"schedule_type"
extern NSString *const APIParamPracticeDailyHours; // @"daily_hours"
extern NSString *const APIParamPracticeMessagingAvailable; // @"available";


#pragma mark - Family
extern NSString *const APIParamFamilyID; // @"family_id";
extern NSString *const APIParamFamily; // @"family";


#pragma mark - User and user subclass
extern NSString *const APIParamUserEnrollment; // @"enrollment";
extern NSString *const APIParamUserTitle; // @"title";
extern NSString *const APIParamUserFirstName; // @"first_name";
extern NSString *const APIParamUserMiddleInitial; // @"middle_initial";
extern NSString *const APIParamUserLastName; // @"last_name";
extern NSString *const APIParamUserSuffix; // @"suffix";
extern NSString *const APIParamUserEmail; // @"email";
extern NSString *const APIParamUserAvatar; // @"avatar_url";

extern NSString *const kGenderMale; // @"M";
extern NSString *const kGenderFemale; // @"F";
extern NSString *const kGenderMaleDisplay; // @"Male";
extern NSString *const kGenderFemaleDisplay; // @"Female";

extern NSString *const APIParamUserProviderID; // @"provider_id";
extern NSString *const APIParamUserPatientID; // @"provider_id";
extern NSString *const APIParamUserBookedByID; // @"booked_by_id";
extern NSString *const APIParamUserCredentials; // @"credentials";
extern NSString *const APIParamUserSpecialties; // @"specialties";
extern NSString *const APIParamUserPrimary; // @"primary";
extern NSString *const APIParamUserStatus; // @"status";
extern NSString *const APIParamUserMembershipType; // @"membership_type";
extern NSString *const APIParamUserBirthDate; // @"birth_date";
extern NSString *const APIParamUserSex; // @"sex";
extern NSString *const APIParamUserPassword; // @"password";
extern NSString *const APIParamUserPasswordExisting; //@"current_password";
extern NSString *const APIParamUserPasswordNewRetyped; //@"password_confirmation"
extern NSString *const APIParamUserJobTitle; // @"job_title";
extern NSString *const APIParamUserVendorID; // @"vendor_id";


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


#pragma mark - Session
extern NSString *const APIParamSessionDeviceToken; // @"device_token";
extern NSString *const APIParamSessionAPNSPermissions; // @"apns_permissions";
extern NSString *const APIParamSessionDeviceType; // @"device_type";
extern NSString *const APIParamSessionPlatform; // @"platform";
extern NSString *const APIParamSessionOSVersion; // @"os_version";
extern NSString *const APIParamSessionAppVersion; // @"app_version";
extern NSString *const LocalParamSessionUser; // @"SessionUser";


#pragma mark - Role
extern NSString *const APIParamRole; // @"role";
extern NSString *const APIParamRoleID; // @"role_id";
extern NSString *const APIParamRoleDisplayName; // @"display_name";


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
extern NSString *const APIParamMessagePage; // @"page";
extern NSString *const APIParamMessageOffset; // @"offset";
extern NSString *const APIParamMessageMinDate; // @"start_datetime";
extern NSString *const APIParamMessageEscalatedTo; // @"escalated_to";
extern NSString *const APIParamMessageEscalatedBy; // @"escalated_by";


#pragma mark - Payment & Stripe
extern NSString *const APIParamPaymentToken; // @"credit_card_token";
extern NSString *const APIParamCouponID; // @"coupon_id";
extern NSString *const APIParamCouponSuccessMessage; // @"text";
extern NSString *const APIParamFullStripeCoupon; // @"coupon";
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


#pragma mark - Images
extern NSString *const APIEndpointImage; // @"image";
extern NSString *const APIParamImage; // @"image";
extern NSString *const APIParamImagePlaceholder; // @"placeholder";
extern NSString *const APIParamImageURL; // @"url";
extern NSString *const APIParamImageBaseURL; // @"base_url";
extern NSString *const APIParamImageURLParameters; // @"parameters";
extern NSString *const APIParamImageNonClinical; // @"non_clinical";
extern NSString *const APIParamAvatarOwnerID; // @"owner_id";


#pragma mark - Card
extern NSString *const APIParamCardCount; // @"count";
extern NSString *const APIParamCardData; // @"card_data";
extern NSString *const APIParamCardPriority; // @"priority";


#pragma mark - Card Types
extern NSString *const CardTypeNameAppointment; // @"appointment";
extern NSString *const CardTypeNameConversation; // @"conversation";
extern NSString *const CardTypeNameDeepLink; // @"deep_link";

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
extern NSString *const APIParamAppointmentID; // @"appointment_id";


#pragma mark - Appointment slot
extern NSString *const APIParamSlots; // @"slots";
extern NSString *const APIParamSlotStartDateTime; // @"start_datetime";
extern NSString *const APIParamSlotDuration; // @"duration";
extern NSString *const APIParamStartDate; // @"start_date";
extern NSString *const APIParamEndDate; // @"end_date";


#pragma mark - Insurer
extern NSString *const APIParamInsurancePlanID; // @"insurance_plan_id";
extern NSString *const APIParamInsurerID; // @"insurer_id";
extern NSString *const APIParamInsurers; // @"insurers";
extern NSString *const APIParamPhone; // @"phone";
extern NSString *const APIParamFax; // @"fax";
extern NSString *const APIParamInsurerName; // @"insurer_name";


#pragma mark - Insurance Plan
extern NSString *const APIParamInsurancePlan; // @"insurance_plan";
extern NSString *const APIParamInsurancePlans; // @"insurance_plans";
extern NSString *const APIParamPlanName; // @"plan_name";
extern NSString *const APIParamPlanSupported; // @"supported"; //Ironically, this param is not yet supported by the API.


#pragma mark - Personal Health Record
extern NSString *const APIParamBMIs; // @"bmis";
extern NSString *const APIParamHeights; // @"heights";
extern NSString *const APIParamWeights; // @"weights";
extern NSString *const APIParamMedications; // @"medications";
extern NSString *const APIParamAllergies; // @"allergies";
extern NSString *const APIParamNotes; // @"notes";
extern NSString *const APIParamImmunizations; // @"immunizations";


#pragma mark - PHR Allergy
extern NSString *const APIParamAllergyOnsetAt; // @"onset_at";
extern NSString *const APIParamAllergyAllergen; // @"allergen";
extern NSString *const APIParamAllergySeverity; // @"severity";
extern NSString *const APIParamAllergyNote; // @"note";


#pragma mark - PHR Immunization
extern NSString *const APIParamImmunizationAdministeredAt; // @"administered_at";
extern NSString *const APIParamImmunizationVaccine; // @"vaccine";


#pragma mark - PHR Medication
extern NSString *const APIParamMedicationStartedAt; // @"started_at";
extern NSString *const APIParamMedicationEnteredAt; // @"entered_at";
extern NSString *const APIParamMedicationMedication; // @"medication";
extern NSString *const APIParamMedicationSig; // @"sig";
extern NSString *const APIParamMedicationNote; // @"note";
extern NSString *const APIParamMedicationDose; // @"dose";
extern NSString *const APIParamMedicationRoute; // @"route";
extern NSString *const APIParamMedicationFrequency; // @"frequency";


#pragma mark - Patient Note
extern NSString *const APIParamPatientNoteID; // @"id";
extern NSString *const APIParamPatientNoteUser; // @"user";
extern NSString *const APIParamPatientNoteCreatedAt; // @"created_at";
extern NSString *const APIParamPatientNoteUpdatedAt; // @"updated_at";
extern NSString *const APIParamPatientNoteDeletedAt; // @"deleted_at";
extern NSString *const APIParamPatientNoteNote; // @"note";


#pragma mark - Vital Measurements
extern NSString *const APIParamVitalMeasurementSearchStartDate; // @"start_date";
extern NSString *const APIParamVitalMeasurementSearchEndDate; // @"end_date";
extern NSString *const APIParamVitalMeasurementTakenAt; // @"taken_at";
extern NSString *const APIParamVitalMeasurementValue; // @"value";
extern NSString *const APIParamVitalMeasurementPercentile; // @"percentile";
extern NSString *const APIParamVitalMeasurementUnit; // @"unit";
extern NSString *const APIParamVitalMeasurementFormattedValueAndUnit; // @"formatted_value_with_units";


#pragma mark - Feed Message Header
extern NSString *const APIParamFeedMessageHeaderText; // @"text";


#pragma mark - Notice
extern NSString *const APIParamNoticeName; // = @"name";
extern NSString *const APIParamNoticeHeaderString; // @"header_string";
extern NSString *const APIParamNoticeBodyString; // @"body_string";
extern NSString *const APIParamNoticeHeaderAttributes; // @"header_attributes";
extern NSString *const APIParamNoticeBodyAttributes; // @"body_attributes";
extern NSString *const APIParamNoticeActionAvailable; // @"action_available";


#pragma mark - Notices
extern NSString *const NoticeConversationPracticeOpen; // @"practice_open";
extern NSString *const NoticeConversationPracticeClosed; // @"practice_closed";


#pragma mark - Daily Schedule
extern NSString *const APIParamDailyScheduleDayOfWeek; // @"day_of_the_week";
extern NSString *const APIParamDailyScheduleStartTime; // @"start_time";
extern NSString *const APIParamDailyScheduleEndTime; // @"end_time";


#pragma mark - Magic numbers
extern CGFloat const kSelectionLineHeight; // 2.0f;
extern CGFloat const kCornerRadius; // 2.0f;
extern CGFloat const kHeightOfNoReturnConstant; // 0.4;
extern CGFloat const kSpeedForTitleViewAlphaChangeConstant; // 4.0;
extern CGFloat const kStickyHeaderHeight; // 150.0;
extern CGFloat const kPaddingHorizontalToolbarButtons; // 20;
extern CGFloat const kHeightDefaultToolbar; // 44;
extern CGFloat const kNumberOfProgressDots; // 4;
extern CGFloat const kHeightOnboardingHeaders; // 114;
extern CGFloat const kChargePerChild; // 20;


#pragma mark - Segues
extern NSString *const kSegueContinue; // @"ContinueSegue";
extern NSString *const kSeguePlan; // @"PlanSegue";
extern NSString *const kSegueTermsAndConditions; // @"TermsAndConditionsSegue";
extern NSString *const kSeguePrivacyPolicy; // @"PrivacyPolicySegue";


#pragma mark - Storyboards
extern NSString *const kStoryboardSettings; // @"Settings";
extern NSString *const kStoryboardLogin; // @"Login";
extern NSString *const kStoryboardFeed; // @"Feed";
extern NSString *const kStoryboardConversation; // @"Conversation";
extern NSString *const kStoryboardAppointment; // @"Appointment";


#pragma mark - Cell Reuse Identifiers
extern NSString *const kReviewUserCellReuseIdentifer; // @"ReviewUserCell";
extern NSString *const kReviewPatientCellReuseIdentifer; // @"ReviewPatientCell";
extern NSString *const kPaymentDetailsCellReuseIdentifier; // @"PaymentDetailsCell";
extern NSString *const kButtonCellReuseIdentifier; // @"ButtonCell";
extern NSString *const kPromptFieldCellReuseIdentifier; // @"LEOPromptFieldCell";


#pragma mark - LEO Error Domains
extern NSString *const LEOErrorDomainValidation; // @"LEOErrorDomainValidation";
extern NSString *const LEOErrorDomainContent; // @"LeoErrorDomainContent";
extern NSString *const LEOErrorDomainNotImplemented; // @"LEOErrorDomainNotImplemented";
extern NSInteger const LEOErrorCodeDefault; // 1622;

#pragma mark - API Errors
extern NSString *const APIParamErrorMessages; // @"message";
extern NSString *const APIParamErrorUserMessage; // @"user_message";
extern NSString *const APIParamErrorUserMessageTitle; // @"user_message_title";
extern NSString *const APIParamErrorDebugMessage; // @"debug_message";
extern NSString *const APIParamErrorCode; // @"error_code";


#pragma mark - Phone Numbers
extern NSString *const kFlatironPediatricsPhoneNumber; // @"2124605600"; //Flatiron Pediatrics


#pragma mark - URLs
extern NSString *const kURLTermsOfService; // @"/terms";
extern NSString *const kURLPrivacyPolicy; // @"/privacy";


#pragma mark - Notifications
extern NSString *const kNotificationDownloadedImageUpdated; // @"DownloadedImage-Updated";
extern NSString *const kNotificationImageChanged; // @"Image-Changed";
extern NSString *const kNotificationStatusChanged; // @"Status-Changed";
extern NSString *const kNotificationMembershipChanged; // @"membership-changed";
extern NSString *const kNotificationTokenInvalidated; // @"token-invalidated";
extern NSString *const kNotificationConversationAddedMessage; // @"Conversation-AddedMessage";
extern NSString *const kNotificationCardUpdated; // @"Card-Updated";


#pragma mark - Pusher Events
extern NSString *const APIChangeEventPracticeMessagingAvailable; // @"availability_changed";


#pragma mark - Push Notifications
extern NSString *const kPushNotificationParamDeepLink; // @"deep_link_url";


#pragma mark - Deep Linking
extern NSString *const kDeepLinkDefaultScheme; // @"leohealth";
extern NSString *const kDeepLinkPathFeed; // @"feed";
extern NSString *const kDeepLinkPathReferral; // @"referral";


#pragma mark - Images
extern CGFloat const kImageCompressionFactor; // 0.8


#pragma mark - Text Field Character Limits
extern NSInteger const kCharacterLimitEmail; // 50;
extern NSInteger const kCharacterLimitName; // 30;
extern NSInteger const kCharacterLimitAppointmentNotes; // 600;


#pragma mark - LEOBasicSelectionViewController selection keys
extern NSString *const kKeySelectionVCSlot; // @"slot";


#pragma mark - General Copy
extern NSString *const kCopyTermsOfService; // @"Terms of Service";
extern NSString *const kErrorDefaultMessage; // @"Looks like we have a boo-boo. We're already healing though and should be up and running again soon. Check back with us in a few minutes.";
extern NSString *const kErrorDefaultTitle; // @"Oops!";
extern NSString *const kErrorTitleMessagingDown; // @"Messaging is currently down";
extern NSString *const kErrorBodyMessagingDown; // @"We are experiencing technical difficulties. Please call your provider directly, or try again later.";


#pragma mark - Configuration Parameters
extern NSString *const kConfigurationPusherAPIKey; // @"PUSHER_KEY";
extern NSString *const kConfigurationCrittercismAppID; // @"CRITTERCISM_APP_ID";
extern NSString *const kConfigurationVendorID; // @"vendor_id";
extern NSString *const kConfigurationStripePublishableKey; // @"STRIPE_PUBLISHABLE_KEY";
extern NSString *const kConfigurationMinimumVersion; // @"MINIMUM_VERSION_REQUIREMENT"; #major.minor.patch (no 'v' in front of the version number)
extern NSString *const kConfigurationCurrentVersion; // @"version";
extern NSString *const kConfigurationHasReviewedVendorID; // @"hasReviewedVendorID";
extern NSString *const kConfigurationLocalyticsKey; // @"LOCALYTICS_APP_ID";

@end
