/* Author: David Carroll
 * Copyright (c) 2008, 2009 Bellevue Baptist Church 
 * Licensed under the GNU General Public License (GPL v2)
 * you may not use this code except in compliance with the License.
 * You may obtain a copy of the License at http://bvcms.codeplex.com/license 
 */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.Caching;
using UtilityExtensions;

namespace CmsData
{
    public partial class Condition
    {
        private CMSDataContext db;
        private ParameterExpression parm;

        private FieldType FieldType { get { return Compare2.FieldType; } }
        private CompareType op { get { return Compare2.CompType; } }

        internal Expression GetExpression(ParameterExpression parm, CMSDataContext Db)
        {
            var expressionDictionary = new Dictionary<QueryType, Func<Expression>>()
            {
                { QueryType.AttendCntHistory, AttendCntHistory },
                { QueryType.AttendedAsOf, MemberAttendedAsOf },
                { QueryType.AttendMemberTypeAsOf, AttendMemberTypeAsOf },
                { QueryType.AttendPct, AttendPct },
                { QueryType.AttendPctHistory, AttendPctHistory },
                { QueryType.AttendTypeAsOf, AttendanceTypeAsOf },
                { QueryType.AttendTypeCodes, AttendTypeIds },
                { QueryType.Birthday, Birthday },
                { QueryType.CampusId, CampusId },
                { QueryType.CcExpiration, CcExpiration },
                { QueryType.CheckInByActivity, CheckInByActivity },
                { QueryType.CheckInByDate, CheckInByDate },
                { QueryType.CheckInVisits, CheckInVisits },
                { QueryType.CommitmentForMeetingId, CommitmentForMeetingId },
                { QueryType.ContributionAmount2, ContributionAmount },
                { QueryType.ContributionChange, ContributionChange },
                { QueryType.CreatedBy, CreatedBy },
                { QueryType.DaysAfterNthVisitAsOf, DaysAfterNthVisitAsOf },
                { QueryType.DaysBetween12Attendance, DaysBetween12Attendance },
                { QueryType.DaysSinceContact, DaysSinceContact },
                { QueryType.DaysTillAnniversary, DaysTillAnniversary },
                { QueryType.DaysTillBirthday, DaysTillBirthday },
                { QueryType.DuplicateEmails, DuplicateEmails },
                { QueryType.DuplicateNames, DuplicateNames },
                { QueryType.EmailRecipient, EmailRecipient },
                { QueryType.FamHasPrimAdultChurchMemb, FamHasPrimAdultChurchMemb },
                { QueryType.FamHasStatusFlag, FamHasStatusFlag },
                { QueryType.FamilyHasChildren, FamilyHasChildren },
                { QueryType.FamilyHasChildrenAged, FamilyHasChildrenAged },
                { QueryType.FamilyHasChildrenAged2, FamilyHasChildrenAged2 },
                { QueryType.FamilyHasChildrenAged3, FamilyHasChildrenAged3 },
                { QueryType.FirstOrgJoinDate, FirstOrgJoinDate },
                { QueryType.GuestAsOf, GuestAttendedAsOf },
                { QueryType.HadIndContributions, HadIndContributions },
                { QueryType.HasBalanceInCurrentOrg, HasBalanceInCurrentOrg },
                { QueryType.HasBalance, HasBalance},
                { QueryType.HasCommitmentForMeetingId, HasCommitmentForMeetingId },
                { QueryType.HasContacts, HasContacts },
                { QueryType.HasCurrentTag, HasCurrentTag },
                { QueryType.HasFailedEmails, HasFailedEmails },
                { QueryType.HasFamilyPicture, HasFamilyPicture },
                { QueryType.HasIncompleteTask, HasIncompleteTask },
                { QueryType.HasInvalidEmailAddress, HasInvalidEmailAddress },
                { QueryType.HasLowerName, HasLowerName },
                { QueryType.HasZipPlus4, HasZipPlus4 },
                { QueryType.HasManagedGiving, HasManagedGiving },
                { QueryType.HasMemberDocs, HasMemberDocs },
                { QueryType.HasMyTag, HasMyTag },
                { QueryType.HasOptoutsForEmail, HasEmailOptout },
                { QueryType.HasOpenedEmail, HasOpenedEmail },
                { QueryType.HasParents, HasParents },
                { QueryType.HasPeopleExtraField, HasPeopleExtraField },
                { QueryType.HasFamilyExtraField, HasFamilyExtraField },
                { QueryType.HasPicture, HasPicture },
                { QueryType.HasRelatedFamily, HasRelatedFamily },
                { QueryType.HasSpamBlock, HasSpamBlock },
                { QueryType.HasTaskWithName, HasTaskWithName },
                { QueryType.HaveVolunteerApplications, HasVolunteerApplications },
                { QueryType.HeadOrSpouseWithEmail, HeadOrSpouseWithEmail },
                { QueryType.InBFClass, InBFClass },
                { QueryType.InCurrentOrg, InCurrentOrg },
                { QueryType.InOneOfMyOrgs, InOneOfMyOrgs },
                { QueryType.IsCurrentPerson, IsCurrentPerson },
                { QueryType.IsCurrentUser, IsCurrentUser },
                { QueryType.IsHeadOfHousehold, IsHeadOfHousehold },
                { QueryType.IsInactiveMemberOf, IsInactiveMemberOf },
                { QueryType.IsMemberOf, IsMemberOf },
                { QueryType.IsPendingMemberOf, IsPendingMemberOf },
                { QueryType.IsPreviousMemberOf, IsPreviousMemberOf },
                { QueryType.IsProspectOf, IsProspectOf },
                { QueryType.IsRecentGiver, IsRecentGiver },
                { QueryType.IsTopGiver, IsTopGiver },
                { QueryType.IsTopPledger, IsTopPledger },
                { QueryType.IsUser, IsUser },
                { QueryType.KidsRecentAttendCount, KidsRecentAttendCount },
                { QueryType.LeadersUnderCurrentOrg, LeadersUnderCurrentOrg },
                { QueryType.MadeContactTypeAsOf, MadeContactTypeAsOf },
                { QueryType.ManagedGivingCreditCard, ManagedGivingCreditCard },
                { QueryType.MatchAnything, MatchAnything },
                { QueryType.MatchNothing, MatchNothing },
                { QueryType.MedicalLength, MedicalLength },
                { QueryType.MeetingId, MeetingId },
                { QueryType.MembersUnderCurrentOrg, MembersUnderCurrentOrg },
                { QueryType.MemberTypeAsOf, MemberTypeAsOf },
                { QueryType.MemberTypeCodes, MemberTypeIds },
                { QueryType.MembOfOrgWithCampus, MembOfOrgWithCampus },
                { QueryType.MembOfOrgWithSched, MembOfOrgWithSched },
                { QueryType.NeedAttendance, NeedAttendance },
                { QueryType.NonTaxDedAmount, NonTaxDedAmount },
                { QueryType.NumberOfFamilyMembers, NumberOfFamilyMembers },
                { QueryType.NumberOfMemberships, NumberOfMemberships },
                { QueryType.NumberOfPrimaryAdults, NumberOfPrimaryAdults },
                { QueryType.OrgInactiveDate, OrgInactiveDate },
                { QueryType.OrgJoinDate, OrgJoinDate },
                { QueryType.OrgJoinDateCompare, OrgJoinDateCompare },
                { QueryType.OrgJoinDateDaysAgo, OrgJoinDateDaysAgo },
                { QueryType.OrgSearchMember, OrgSearchMember },
                { QueryType.PeopleExtra, PeopleExtra },
                { QueryType.PeopleExtraData, PeopleExtraData },
                { QueryType.PeopleExtraDate, PeopleExtraDate },
                { QueryType.PeopleExtraInt, PeopleExtraInt },
                { QueryType.FamilyExtra, FamilyExtra },
                { QueryType.FamilyExtraData, FamilyExtraData },
                { QueryType.FamilyExtraDate, FamilyExtraDate },
                { QueryType.FamilyExtraInt, FamilyExtraInt },
                { QueryType.PeopleIds, PeopleIds },
                { QueryType.PendingCurrentOrg, PendingCurrentOrg },
                { QueryType.InactiveCurrentOrg, InactiveCurrentOrg },
                { QueryType.PreviousCurrentOrg, PreviousCurrentOrg },
                { QueryType.VisitedCurrentOrg, VisitedCurrentOrg },
                { QueryType.ProspectCurrentOrg, ProspectCurrentOrg },
                { QueryType.PmmBackgroundCheckStatus, BackgroundCheckStatus },
                { QueryType.RecActiveOtherChurch, RecActiveOtherChurch },
                { QueryType.RecentAttendCount, RecentAttendCount },
                { QueryType.RecentAttendCountAttCred, RecentAttendCountAttCred },
                { QueryType.RecentAttendMemberType, RecentAttendMemberType },
                { QueryType.RecentAttendType, RecentAttendType },
                { QueryType.RecentBundleType, RecentBundleType },
                { QueryType.RecentContactMinistry, RecentContactMinistry },
                { QueryType.RecentContactReason, RecentContactReason },
                { QueryType.RecentContactType, RecentContactType },
                { QueryType.RecentContributionAmount, RecentContributionAmount },
                { QueryType.RecentContributionAmountBothJoint, RecentContributionAmountBothJoint },
                { QueryType.RecentContributionCount, RecentContributionCount },
                { QueryType.RecentChanged, RecentChanged },
                { QueryType.RecentCreated, RecentCreated },
                { QueryType.RecentDecisionType, RecentDecisionType },
                { QueryType.RecentEmailCount, RecentEmailCount },
                { QueryType.RecentEmailSentCount, RecentEmailSentCount },
                { QueryType.RecentFirstTimeGiver, RecentFirstTimeGiver },
                { QueryType.RecentGivingAsPctOfPrevious, RecentGivingAsPctOfPrevious },
                { QueryType.RecentHasIndContributions, RecentHasIndContributions },
                { QueryType.RecentIncompleteRegistrations, RecentIncompleteRegistrations },
                { QueryType.RecentJoinChurch, RecentJoinChurch },
                { QueryType.RecentNewVisitCount, RecentNewVisitCount },
                { QueryType.RecentNonTaxDedAmount, RecentNonTaxDedAmount },
                { QueryType.RecentNonTaxDedCount, RecentNonTaxDedCount },
                { QueryType.RecentPeopleExtraFieldChanged, RecentPeopleExtraFieldChanged },
                { QueryType.RecentPledgeAmount, RecentPledgeAmount },
                { QueryType.RecentPledgeCount, RecentPledgeCount },
                { QueryType.RecentRegistrationType, RecentRegistrationType },
                { QueryType.RecentVisitNumber, RecentVisitNumber },
                { QueryType.RecInterestedCoaching, RecInterestedCoaching },
                { QueryType.RegisteredForMeetingId, RegisteredForMeetingId },
                { QueryType.RelatedFamilyMembers, RelatedFamilyMembers },
                { QueryType.SavedQuery, SavedQuery2 },
                { QueryType.SmallGroup, SmallGroup },
                { QueryType.SpouseHasEmail, SpouseHasEmail },
                { QueryType.SpouseOrHeadWithEmail, SpouseOrHeadWithEmail },
                { QueryType.StatusFlag, StatusFlag },
                { QueryType.UserRole, UserRole },
                { QueryType.VisitNumber, VisitNumber },
                { QueryType.VolAppStatusCode, VolAppStatusCode },
                { QueryType.MVRStatusCode, MVRStatusCode },
                { QueryType.VolunteerApprovalCode, VolunteerApprovalCode },
                { QueryType.VolunteerProcessedDateMonthsAgo, VolunteerProcessedDateMonthsAgo },
                { QueryType.MVRProcessedDateMonthsAgo, MVRProcessedDateMonthsAgo },
                { QueryType.WantsElectronicStatement, WantsElectronicStatement },
                { QueryType.WasMemberAsOf, WasMemberAsOf },
                { QueryType.WasRecentMemberOf, WasRecentMemberOf },
                { QueryType.WeddingDate, WeddingDate },
                { QueryType.WidowedDate, WidowedDate },
            };
            this.parm = parm;
            this.db = Db;
            Func<Expression> f = null;
            if (expressionDictionary.TryGetValue(FieldInfo.QueryType, out f))
                return f();

            var IsMultiple = op == CompareType.OneOf || op == CompareType.NotOneOf;
            switch (FieldInfo.QueryType)
            {
                case QueryType.MemberStatusId:
                case QueryType.MaritalStatusId:
                case QueryType.GenderId:
                case QueryType.DropCodeId:
                case QueryType.JoinCodeId:
                    if (op == CompareType.IsNull || op == CompareType.IsNotNull)
                        return CompareConstant(ConditionName, -1);
                    return CompareConstant(ConditionName, IsMultiple ? (object)CodeIntIds : (object)CodeIds.ToInt());
//                case QueryType.PrimaryAddress:
//                case QueryType.PrimaryAddress2:
//                case QueryType.PrimaryZip:
//                case QueryType.PrimaryCountry:
//                case QueryType.PrimaryCity:
//                case QueryType.FirstName:
//                case QueryType.MiddleName:
//                case QueryType.MaidenName:
//                case QueryType.NickName:
//                case QueryType.CellPhone:
//                case QueryType.WorkPhone:
//                case QueryType.HomePhone:
//                case QueryType.EmailAddress:
//                case QueryType.EmailAddress2:
//                    if (op == CompareType.IsNull || op == CompareType.IsNotNull)
//                        return CompareConstant(ConditionName, null);
//                    return CompareStringConstant(ConditionName, TextValue ?? "");
                default:
                    if (op == CompareType.IsNull || op == CompareType.IsNotNull)
                        return CompareConstant(ConditionName, null);
                    switch (FieldType)
                    {
                        case FieldType.NullBit:
                        case FieldType.Bit: return CompareConstant(ConditionName, CodeIds == "1");
                        case FieldType.Code: return CompareConstant(ConditionName, IsMultiple ? (object)CodeIntIds : (object)CodeIds.ToInt());
                        case FieldType.NullCode: return CompareCodeConstant(ConditionName, IsMultiple ? (object)CodeIntIds : (object)CodeIds.ToInt());
                        case FieldType.CodeStr: return CompareConstant(ConditionName, IsMultiple ? (object)CodeStrIds : (object)CodeIdValue);
                        case FieldType.String: return CompareStringConstant(ConditionName, TextValue ?? "");
                        case FieldType.Number:
                        case FieldType.NullNumber: return CompareConstant(ConditionName, decimal.Parse(TextValue));
                        case FieldType.Integer:
                        case FieldType.IntegerSimple:
                        case FieldType.NullInteger: return CompareIntConstant(ConditionName, TextValue);
                        case FieldType.Date:
                        case FieldType.DateSimple:
                            return CompareDateConstant(ConditionName, DateValue);
                        default:
                            throw new ArgumentException();
                    }
            }
        }
    }
}
