SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Creating schemata'
GO
CREATE SCHEMA [lookup]
AUTHORIZATION [dbo]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
CREATE SCHEMA [disc]
AUTHORIZATION [dbo]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[People]'
GO
CREATE TABLE [dbo].[People]
(
[PeopleId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NULL,
[DropCodeId] [int] NOT NULL,
[GenderId] [int] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_GENDER_ID] DEFAULT ((0)),
[DoNotMailFlag] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_DO_NOT_MAIL_FLAG] DEFAULT ((0)),
[DoNotCallFlag] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_DO_NOT_CALL_FLAG] DEFAULT ((0)),
[DoNotVisitFlag] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_DO_NOT_VISIT_FLAG] DEFAULT ((0)),
[AddressTypeId] [int] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_ADDRESS_TYPE_ID] DEFAULT ((10)),
[PhonePrefId] [int] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_PHONE_PREF_ID] DEFAULT ((10)),
[MaritalStatusId] [int] NOT NULL,
[PositionInFamilyId] [int] NOT NULL,
[MemberStatusId] [int] NOT NULL,
[FamilyId] [int] NOT NULL,
[BirthMonth] [int] NULL,
[BirthDay] [int] NULL,
[BirthYear] [int] NULL,
[OriginId] [int] NULL,
[EntryPointId] [int] NULL,
[InterestPointId] [int] NULL,
[BaptismTypeId] [int] NULL,
[BaptismStatusId] [int] NULL,
[DecisionTypeId] [int] NULL,
[DiscoveryClassStatusId] [int] NULL,
[NewMbrClassStatusId] [int] NULL,
[LetterStatusId] [int] NULL,
[JoinCodeId] [int] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_JOIN_CODE_ID] DEFAULT ((0)),
[EnvelopeOptionsId] [int] NULL,
[BadAddressFlag] [bit] NULL,
[AltBadAddressFlag] [bit] NULL,
[ResCodeId] [int] NULL,
[AltResCodeId] [int] NULL,
[AddressFromDate] [datetime] NULL,
[AddressToDate] [datetime] NULL,
[AltAddressFromDate] [datetime] NULL,
[AltAddressToDate] [datetime] NULL,
[WeddingDate] [datetime] NULL,
[OriginDate] [datetime] NULL,
[BaptismSchedDate] [datetime] NULL,
[BaptismDate] [datetime] NULL,
[DecisionDate] [datetime] NULL,
[DiscoveryClassDate] [datetime] NULL,
[NewMbrClassDateCompleted] [datetime] NULL,
[LetterDateRequested] [datetime] NULL,
[LetterDateReceived] [datetime] NULL,
[JoinDate] [datetime] NULL,
[DropDate] [datetime] NULL,
[DeceasedDate] [datetime] NULL,
[TitleCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MiddleName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaidenName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SuffixCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLineOne] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLineTwo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltAddressLineOne] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltAddressLineTwo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltCityName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStateCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltCountryName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStreetName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CellPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPreviousChurch] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherNewChurch] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchoolOther] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployerOther] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationOther] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HobbyOther] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SkillOther] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestOther] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LetterStatusNotes] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChristAsSavior] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_CHRIST_AS_SAVIOR] DEFAULT ((0)),
[MemberAnyChurch] [bit] NULL,
[InterestedInJoining] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_INTERESTED_IN_JOINING] DEFAULT ((0)),
[PleaseVisit] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_PLEASE_VISIT] DEFAULT ((0)),
[InfoBecomeAChristian] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_INFO_BECOME_A_CHRISTIAN] DEFAULT ((0)),
[ContributionsStatement] [bit] NOT NULL CONSTRAINT [DF_PEOPLE_TBL_CONTRIBUTIONS_STATEMENT] DEFAULT ((0)),
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[PictureId] [int] NULL,
[ContributionOptionsId] [int] NULL,
[PrimaryCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseId] [int] NULL,
[PrimaryAddress2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryResCode] [int] NULL,
[PrimaryBadAddrFlag] [int] NULL,
[LastContact] [datetime] NULL,
[Grade] [int] NULL,
[CellPhoneLU] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhoneLU] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BibleFellowshipClassId] [int] NULL,
[Name] AS ((case when [Nickname]<>'' then [nickname] else [FirstName] end+' ')+[LastName]),
[Name2] AS (([LastName]+', ')+case when [Nickname]<>'' then [nickname] else [FirstName] end),
[HashNum] AS (checksum([FirstName]+[LastName])),
[CampusId] [int] NULL,
[CellPhoneAC] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredName] AS (case when [Nickname]<>'' then [nickname] else [FirstName] end),
[CheckInNotes] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] AS ((datepart(year,isnull([DeceasedDate],getdate()))-[BirthYear])-case when [BirthMonth]>datepart(month,isnull([DeceasedDate],getdate())) OR [BirthMonth]=datepart(month,isnull([DeceasedDate],getdate())) AND [BirthDay]>datepart(day,isnull([DeceasedDate],getdate())) then (1) else (0) end)
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PEOPLE_PK] on [dbo].[People]'
GO
ALTER TABLE [dbo].[People] ADD CONSTRAINT [PEOPLE_PK] PRIMARY KEY NONCLUSTERED ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [PEOPLE_FAMILY_FK_IX] on [dbo].[People]'
GO
CREATE NONCLUSTERED INDEX [PEOPLE_FAMILY_FK_IX] ON [dbo].[People] ([FamilyId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_PEOPLE_TBL] on [dbo].[People]'
GO
CREATE NONCLUSTERED INDEX [IX_PEOPLE_TBL] ON [dbo].[People] ([EmailAddress])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_People_2] on [dbo].[People]'
GO
CREATE NONCLUSTERED INDEX [IX_People_2] ON [dbo].[People] ([CellPhoneLU])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CoupleFlag]'
GO
-- =============================================
-- Author:		Kenny
-- Create date: 4/17/2008
-- Description:	Finds the Couple Flag given a family ID
-- This flag is used for figuring out how mailings should
-- be addressed (see codes below)
-- =============================================

CREATE FUNCTION [dbo].[CoupleFlag] 
(
	@family_id int
)

-- Returns:
--  0 - Individual
--  1 - Couple
--  2 - Couple + Family
--  3 - Single Parent + Family
--  4 - No Primary Family

RETURNS int
AS
BEGIN
	DECLARE @Result int

    SELECT top 1 @Result = 
        case (sum(case PositionInFamilyId when 10 then 1 else 0 end))
            when 2 then (case count(*) when 2 then (case min(MaritalStatusId) when 30 then (CASE MAX(MaritalStatusId) WHEN 30 THEN 1 ELSE 4 end) else 4 end) else 2 end)
            when 1 then (case count(*) when 1 then 0 else 3 end)
            else (case count(*) when 1 then 0 else 4 end)
        end
      FROM dbo.People
     WHERE FamilyId = @family_id
       AND DeceasedDate IS NULL
       AND FirstName <> 'Duplicate'

	-- Return the result of the function
	RETURN @Result

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Birthday]'
GO
CREATE FUNCTION [dbo].[Birthday](@pid int)
RETURNS DATETIME
AS
BEGIN
	
	DECLARE
		@dt DATETIME, 
		@m int,
		@d int,
		@y int
    SET @dt = NULL
		
	select @m = BirthMonth, @d = BirthDay, @y = BirthYear from dbo.People where @pid = PeopleId
	IF NOT (@m IS NULL OR @y IS NULL OR @d IS NULL)
	    SET @dt = dateadd(month,((@y-1900)*12)+@m-1,@d-1)
	RETURN @dt
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Program]'
GO
CREATE TABLE [dbo].[Program]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BFProgram] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Program] on [dbo].[Program]'
GO
ALTER TABLE [dbo].[Program] ADD CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Division]'
GO
CREATE TABLE [dbo].[Division]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgId] [int] NULL,
[SortOrder] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Division] on [dbo].[Division]'
GO
ALTER TABLE [dbo].[Division] ADD CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Organizations]'
GO
CREATE TABLE [dbo].[Organizations]
(
[OrganizationId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[OrganizationStatusId] [int] NOT NULL,
[DivisionId] [int] NULL,
[LeaderMemberTypeId] [int] NULL,
[GradeAgeStart] [int] NULL,
[GradeAgeEnd] [int] NULL,
[RollSheetVisitorWks] [int] NULL,
[AttendTrkLevelId] [int] NOT NULL,
[SecurityTypeId] [int] NOT NULL,
[AttendClassificationId] [int] NOT NULL CONSTRAINT [DF_Organizations_AttendClassificationId] DEFAULT ((0)),
[FirstMeetingDate] [datetime] NULL,
[LastMeetingDate] [datetime] NULL,
[OrganizationClosedDate] [datetime] NULL,
[Location] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrganizationName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[ScheduleId] [int] NULL,
[EntryPointId] [int] NULL,
[ParentOrgId] [int] NULL,
[AllowAttendOverlap] [bit] NOT NULL CONSTRAINT [DF_Organizations_AllowAttendOverlap] DEFAULT ((0)),
[MemberCount] [int] NULL,
[LeaderId] [int] NULL,
[LeaderName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClassFilled] [bit] NULL,
[OnLineCatalogSort] [int] NULL,
[PendingLoc] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CanSelfCheckin] [bit] NULL,
[NumCheckInLabels] [int] NULL,
[CampusId] [int] NULL,
[AllowNonCampusCheckIn] [bit] NULL,
[NumWorkerCheckInLabels] [int] NULL,
[SchedTime] [datetime] NULL,
[SchedDay] [int] NULL,
[MeetingTime] [datetime] NULL,
[ShowOnlyRegisteredAtCheckIn] [bit] NULL,
[Limit] [int] NULL,
[EmailAddresses] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailSubject] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Instructions] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenderId] [int] NULL,
[Fee] [money] NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDayStart] [datetime] NULL,
[BirthDayEnd] [datetime] NULL,
[VisitorDate] AS (dateadd(day, -(7)*isnull([RollSheetVisitorWks],(3)),getdate())),
[Deposit] [money] NULL,
[ShirtFee] [money] NULL,
[ExtraFee] [money] NULL,
[LastDayBeforeExtra] [datetime] NULL,
[AskTylenolEtc] [bit] NULL,
[AskAllergies] [bit] NULL,
[AskShirtSize] [bit] NULL,
[AskRequest] [bit] NULL,
[AskParents] [bit] NULL,
[AskEmContact] [bit] NULL,
[AskMedical] [bit] NULL,
[AskInsurance] [bit] NULL,
[AllowLastYearShirt] [bit] NULL,
[AskDoctor] [bit] NULL,
[AskCoaching] [bit] NULL,
[AskChurch] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [ORGANIZATIONS_PK] on [dbo].[Organizations]'
GO
ALTER TABLE [dbo].[Organizations] ADD CONSTRAINT [ORGANIZATIONS_PK] PRIMARY KEY NONCLUSTERED ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[OrganizationMembers]'
GO
CREATE TABLE [dbo].[OrganizationMembers]
(
[OrganizationId] [int] NOT NULL,
[PeopleId] [int] NOT NULL,
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL,
[MemberTypeId] [int] NOT NULL,
[EnrollmentDate] [datetime] NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[InactiveDate] [datetime] NULL,
[AttendStr] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendPct] [real] NULL,
[LastAttended] [datetime] NULL,
[Pending] [bit] NULL,
[UserData] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[Request] [varchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [ORGANIZATION_MEMBERS_PK] on [dbo].[OrganizationMembers]'
GO
ALTER TABLE [dbo].[OrganizationMembers] ADD CONSTRAINT [ORGANIZATION_MEMBERS_PK] PRIMARY KEY NONCLUSTERED ([OrganizationId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [ORGANIZATION_MEMBERS_PPL_FK_IX] on [dbo].[OrganizationMembers]'
GO
CREATE NONCLUSTERED INDEX [ORGANIZATION_MEMBERS_PPL_FK_IX] ON [dbo].[OrganizationMembers] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DivOrg]'
GO
CREATE TABLE [dbo].[DivOrg]
(
[DivId] [int] NOT NULL,
[OrgId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_DivOrg] on [dbo].[DivOrg]'
GO
ALTER TABLE [dbo].[DivOrg] ADD CONSTRAINT [PK_DivOrg] PRIMARY KEY CLUSTERED ([DivId], [OrgId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SpouseId]'
GO
CREATE FUNCTION [dbo].[SpouseId] 
(
	@peopleid int
)
RETURNS int
AS
BEGIN
	DECLARE @Result int

	SELECT TOP 1 @Result = s.PeopleId FROM dbo.People p
	JOIN dbo.People s ON s.FamilyId = p.FamilyId
	WHERE s.PeopleId <> @peopleid AND p.PeopleId = @peopleid
	AND p.MaritalStatusId = 20
	AND s.MaritalStatusId = 20
	AND s.DeceasedDate IS NULL
	AND p.DeceasedDate IS NULL
	AND p.PositionInFamilyId = s.PositionInFamilyId
	AND s.FirstName <> 'Duplicate'	-- Return the result of the function
	
	RETURN @Result

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[AttendType]'
GO
CREATE TABLE [lookup].[AttendType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_AttendType] on [lookup].[AttendType]'
GO
ALTER TABLE [lookup].[AttendType] ADD CONSTRAINT [PK_AttendType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AttendDesc]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[AttendDesc](@id int) 
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @ret VARCHAR(100)
	SELECT @ret =  Description FROM lookup.AttendType WHERE id = @id
	RETURN @ret
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[OrganizationMemberCount]'
GO
CREATE FUNCTION [dbo].[OrganizationMemberCount](@oid int) 
RETURNS int
AS
BEGIN
	DECLARE @c int
	SELECT @c = count(*) from dbo.OrganizationMembers 
	where OrganizationId = @oid
	RETURN @c
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SchoolGrade]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[SchoolGrade] (@pid INT)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @g INT

	SELECT TOP 1 @g = o.GradeAgeStart 
	FROM dbo.OrganizationMembers AS om 
		JOIN dbo.Organizations AS o ON om.OrganizationId = o.OrganizationId 
		JOIN dbo.DivOrg do ON o.OrganizationId = do.OrgId 
		JOIN dbo.Division d ON do.DivId = d.Id 
		JOIN dbo.Program p ON d.ProgId = p.Id
	WHERE p.BFProgram = 1 
		AND om.PeopleId = @pid 
		AND om.MemberTypeId = 220 
		AND GradeAgeStart <> 0

	-- Return the result of the function
	RETURN @g

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UEmail]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[UEmail] (@pid int)
RETURNS varchar(100)
AS
BEGIN
	-- Declare the return variable here
	declare @email varchar(100)
	
	SELECT  @email = EmailAddress
	FROM         dbo.People
	WHERE     PeopleId = @pid

	return @email

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Meetings]'
GO
CREATE TABLE [dbo].[Meetings]
(
[MeetingId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[OrganizationId] [int] NOT NULL,
[NumPresent] [int] NOT NULL CONSTRAINT [DF__MEETINGS___NUM_P__4D4B3A2F] DEFAULT ((0)),
[NumMembers] [int] NOT NULL CONSTRAINT [DF__MEETINGS___NUM_M__4F3382A1] DEFAULT ((0)),
[NumVstMembers] [int] NOT NULL CONSTRAINT [DF__MEETINGS___NUM_V__5027A6DA] DEFAULT ((0)),
[NumRepeatVst] [int] NOT NULL CONSTRAINT [DF__MEETINGS___NUM_R__511BCB13] DEFAULT ((0)),
[NumNewVisit] [int] NOT NULL CONSTRAINT [DF__MEETINGS___NUM_N__520FEF4C] DEFAULT ((0)),
[Location] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MeetingDate] [datetime] NULL,
[GroupMeetingFlag] [bit] NOT NULL CONSTRAINT [DF__MEETINGS___GROUP__5AA5354D] DEFAULT ((0)),
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [MEETINGS_PK] on [dbo].[Meetings]'
GO
ALTER TABLE [dbo].[Meetings] ADD CONSTRAINT [MEETINGS_PK] PRIMARY KEY NONCLUSTERED ([MeetingId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_MEETINGS_ORG_ID] on [dbo].[Meetings]'
GO
CREATE NONCLUSTERED INDEX [IX_MEETINGS_ORG_ID] ON [dbo].[Meetings] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Meetings_MeetingDate] on [dbo].[Meetings]'
GO
CREATE NONCLUSTERED INDEX [IX_Meetings_MeetingDate] ON [dbo].[Meetings] ([MeetingDate] DESC)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Attend]'
GO
CREATE TABLE [dbo].[Attend]
(
[PeopleId] [int] NOT NULL,
[MeetingId] [int] NOT NULL,
[OrganizationId] [int] NOT NULL,
[MeetingDate] [datetime] NOT NULL,
[AttendanceFlag] [bit] NOT NULL CONSTRAINT [DF_Attend_AttendanceFlag] DEFAULT ((0)),
[OtherOrgId] [int] NULL,
[AttendanceTypeId] [int] NULL,
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL,
[MemberTypeId] [int] NOT NULL,
[AttendId] [int] NOT NULL IDENTITY(1, 1),
[OtherAttends] [int] NOT NULL CONSTRAINT [DF_Attend_OtherAttends] DEFAULT ((0)),
[BFCAttendance] [bit] NULL,
[EffAttendFlag] AS (CONVERT([bit],case when [AttendanceTypeId]=(90) then NULL when [AttendanceFlag]=(1) AND [OtherAttends]>(0) AND [BFCAttendance]=(1) then NULL when [AttendanceFlag]=(1) then (1) when [OtherAttends]>(0) then NULL else (0) end,(0))),
[Registered] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Attend] on [dbo].[Attend]'
GO
ALTER TABLE [dbo].[Attend] ADD CONSTRAINT [PK_Attend] PRIMARY KEY CLUSTERED ([AttendId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Attend_2] on [dbo].[Attend]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Attend_2] ON [dbo].[Attend] ([MeetingId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Attend_3] on [dbo].[Attend]'
GO
CREATE NONCLUSTERED INDEX [IX_Attend_3] ON [dbo].[Attend] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Attend_4] on [dbo].[Attend]'
GO
CREATE NONCLUSTERED INDEX [IX_Attend_4] ON [dbo].[Attend] ([MeetingId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Attend] on [dbo].[Attend]'
GO
CREATE NONCLUSTERED INDEX [IX_Attend] ON [dbo].[Attend] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Attend_1] on [dbo].[Attend]'
GO
CREATE NONCLUSTERED INDEX [IX_Attend_1] ON [dbo].[Attend] ([MeetingDate])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Picture]'
GO
CREATE TABLE [dbo].[Picture]
(
[PictureId] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LargeId] [int] NULL,
[MediumId] [int] NULL,
[SmallId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Picture] on [dbo].[Picture]'
GO
ALTER TABLE [dbo].[Picture] ADD CONSTRAINT [PK_Picture] PRIMARY KEY CLUSTERED ([PictureId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Families]'
GO
CREATE TABLE [dbo].[Families]
(
[FamilyId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NULL,
[RecordStatus] [bit] NOT NULL CONSTRAINT [DF_FAMILIES_TBL_RECORD_STATUS] DEFAULT ((0)),
[BadAddressFlag] [bit] NULL,
[AltBadAddressFlag] [bit] NULL,
[ResCodeId] [int] NULL,
[AltResCodeId] [int] NULL,
[AddressFromDate] [datetime] NULL,
[AddressToDate] [datetime] NULL,
[AltAddressFromDate] [datetime] NULL,
[AltAddressToDate] [datetime] NULL,
[AddressLineOne] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLineTwo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltAddressLineOne] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltAddressLineTwo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltCityName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStateCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltCountryName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStreetName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[HeadOfHouseholdId] [int] NULL,
[HeadOfHouseholdSpouseId] [int] NULL,
[CoupleFlag] [int] NULL,
[HomePhoneLU] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhoneAC] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [FAMILIES_PK] on [dbo].[Families]'
GO
ALTER TABLE [dbo].[Families] ADD CONSTRAINT [FAMILIES_PK] PRIMARY KEY NONCLUSTERED ([FamilyId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Families] on [dbo].[Families]'
GO
CREATE NONCLUSTERED INDEX [IX_Families] ON [dbo].[Families] ([HomePhoneLU])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[RelatedFamilies]'
GO
CREATE TABLE [dbo].[RelatedFamilies]
(
[FamilyId] [int] NOT NULL,
[RelatedFamilyId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[FamilyRelationshipDesc] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [RELATED_FAMILIES_PK] on [dbo].[RelatedFamilies]'
GO
ALTER TABLE [dbo].[RelatedFamilies] ADD CONSTRAINT [RELATED_FAMILIES_PK] PRIMARY KEY NONCLUSTERED ([FamilyId], [RelatedFamilyId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [RELATED_FAMILIES_RELATED_FK_IX] on [dbo].[RelatedFamilies]'
GO
CREATE NONCLUSTERED INDEX [RELATED_FAMILIES_RELATED_FK_IX] ON [dbo].[RelatedFamilies] ([RelatedFamilyId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VolInterestInterestCodes]'
GO
CREATE TABLE [dbo].[VolInterestInterestCodes]
(
[PeopleId] [int] NOT NULL,
[InterestCodeId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VolInterestInterestCodes] on [dbo].[VolInterestInterestCodes]'
GO
ALTER TABLE [dbo].[VolInterestInterestCodes] ADD CONSTRAINT [PK_VolInterestInterestCodes] PRIMARY KEY CLUSTERED ([PeopleId], [InterestCodeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[RecReg]'
GO
CREATE TABLE [dbo].[RecReg]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PeopleId] [int] NULL,
[ImgId] [int] NULL,
[IsDocument] [bit] NULL,
[ActiveInAnotherChurch] [bit] NULL,
[ShirtSize] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MedAllergy] [bit] NULL,
[email] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MedicalDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fname] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mname] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[coaching] [bit] NULL,
[member] [bit] NULL,
[emcontact] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emphone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[doctor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[docphone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[insurance] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[policy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tylenol] [bit] NULL,
[Advil] [bit] NULL,
[Maalox] [bit] NULL,
[Robitussin] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Participant] on [dbo].[RecReg]'
GO
ALTER TABLE [dbo].[RecReg] ADD CONSTRAINT [PK_Participant] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LoveRespect]'
GO
CREATE TABLE [dbo].[LoveRespect]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Created] [datetime] NOT NULL,
[HimId] [int] NULL,
[HisEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HisEmailPreferred] [bit] NULL,
[HerId] [int] NULL,
[HerEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HerEmailPreferred] [bit] NULL,
[OrgId] [int] NULL,
[Relationship] [int] NULL,
[PreferNight] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_LoveRespect] on [dbo].[LoveRespect]'
GO
ALTER TABLE [dbo].[LoveRespect] ADD CONSTRAINT [PK_LoveRespect] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SoulMate]'
GO
CREATE TABLE [dbo].[SoulMate]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[HimId] [int] NULL,
[HisEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HisEmailPreferred] [bit] NULL,
[HerId] [int] NULL,
[HerEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HerEmailPreferred] [bit] NULL,
[EventId] [int] NULL,
[Relationship] [int] NULL,
[ChildcareId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SoulMate] on [dbo].[SoulMate]'
GO
ALTER TABLE [dbo].[SoulMate] ADD CONSTRAINT [PK_SoulMate] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_SoulMate] on [dbo].[SoulMate]'
GO
CREATE NONCLUSTERED INDEX [IX_SoulMate] ON [dbo].[SoulMate] ([EventId], [HimId], [HerId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[TagShare]'
GO
CREATE TABLE [dbo].[TagShare]
(
[TagId] [int] NOT NULL,
[PeopleId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TagShare] on [dbo].[TagShare]'
GO
ALTER TABLE [dbo].[TagShare] ADD CONSTRAINT [PK_TagShare] PRIMARY KEY CLUSTERED ([TagId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[TagPerson]'
GO
CREATE TABLE [dbo].[TagPerson]
(
[Id] [int] NOT NULL,
[PeopleId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TagPeople] on [dbo].[TagPerson]'
GO
ALTER TABLE [dbo].[TagPerson] ADD CONSTRAINT [PK_TagPeople] PRIMARY KEY CLUSTERED ([Id], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TagPerson] on [dbo].[TagPerson]'
GO
CREATE NONCLUSTERED INDEX [IX_TagPerson] ON [dbo].[TagPerson] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Users]'
GO
CREATE TABLE [dbo].[Users]
(
[UserId] [int] NOT NULL IDENTITY(1, 1),
[PeopleId] [int] NULL,
[Username] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PasswordQuestion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordAnswer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsApproved] [bit] NOT NULL CONSTRAINT [DF_Users_IsApproved] DEFAULT ((0)),
[LastActivityDate] [datetime] NULL,
[LastLoginDate] [datetime] NULL,
[LastPasswordChangedDate] [datetime] NULL,
[CreationDate] [datetime] NULL,
[IsLockedOut] [bit] NOT NULL CONSTRAINT [DF_Users_IsLockedOut] DEFAULT ((0)),
[LastLockedOutDate] [datetime] NULL,
[FailedPasswordAttemptCount] [int] NOT NULL CONSTRAINT [DF_Users_FailedPasswordAttemptCount] DEFAULT ((0)),
[FailedPasswordAttemptWindowStart] [datetime] NULL,
[FailedPasswordAnswerAttemptCount] [int] NOT NULL CONSTRAINT [DF_Users_FailedPasswordAnswerAttemptCount] DEFAULT ((0)),
[FailedPasswordAnswerAttemptWindowStart] [datetime] NULL,
[EmailAddress] AS ([dbo].[UEmail]([PeopleId])),
[ItemsInGrid] [int] NULL,
[CurrentCart] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MustChangePassword] [bit] NOT NULL CONSTRAINT [DF_Users_MustChangePassword] DEFAULT ((0)),
[Host] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TempPassword] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResetPasswordCode] [uniqueidentifier] NULL,
[DefaultGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Users_1] on [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users_1] PRIMARY KEY CLUSTERED ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[PageVisit]'
GO
CREATE TABLE [disc].[PageVisit]
(
[CreatedOn] [datetime] NOT NULL,
[PageTitle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Id] [int] NOT NULL IDENTITY(1, 1),
[PageUrl] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VisitTime] [datetime] NULL,
[UserId] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PageVisit] on [disc].[PageVisit]'
GO
ALTER TABLE [disc].[PageVisit] ADD CONSTRAINT [PK_PageVisit] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_VisitTime] on [disc].[PageVisit]'
GO
CREATE NONCLUSTERED INDEX [IX_VisitTime] ON [disc].[PageVisit] ([VisitTime])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[UserGroupRole]'
GO
CREATE TABLE [disc].[UserGroupRole]
(
[UserId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UserGroupRole] on [disc].[UserGroupRole]'
GO
ALTER TABLE [disc].[UserGroupRole] ADD CONSTRAINT [PK_UserGroupRole] PRIMARY KEY CLUSTERED ([UserId], [RoleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_UserGroupRole] on [disc].[UserGroupRole]'
GO
CREATE NONCLUSTERED INDEX [IX_UserGroupRole] ON [disc].[UserGroupRole] ([cUserid], [RoleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VolunteerForm]'
GO
CREATE TABLE [dbo].[VolunteerForm]
(
[PeopleId] [int] NOT NULL,
[AppDate] [datetime] NULL,
[LargeId] [int] NULL,
[MediumId] [int] NULL,
[SmallId] [int] NULL,
[Id] [int] NOT NULL IDENTITY(1, 1),
[UploaderId] [int] NULL,
[IsDocument] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VolunteerForm] on [dbo].[VolunteerForm]'
GO
ALTER TABLE [dbo].[VolunteerForm] ADD CONSTRAINT [PK_VolunteerForm] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_VolunteerForm] on [dbo].[VolunteerForm]'
GO
CREATE NONCLUSTERED INDEX [IX_VolunteerForm] ON [dbo].[VolunteerForm] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UserCanEmailFor]'
GO
CREATE TABLE [dbo].[UserCanEmailFor]
(
[UserId] [int] NOT NULL,
[CanEmailFor] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UserCanEmailFor] on [dbo].[UserCanEmailFor]'
GO
ALTER TABLE [dbo].[UserCanEmailFor] ADD CONSTRAINT [PK_UserCanEmailFor] PRIMARY KEY CLUSTERED ([UserId], [CanEmailFor])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UserRole]'
GO
CREATE TABLE [dbo].[UserRole]
(
[UserId] [int] NOT NULL,
[RoleId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UserRole] on [dbo].[UserRole]'
GO
ALTER TABLE [dbo].[UserRole] ADD CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED ([UserId], [RoleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ActivityLog]'
GO
CREATE TABLE [dbo].[ActivityLog]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[ActivityDate] [datetime] NULL,
[UserId] [int] NULL,
[Activity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PageUrl] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_alog] on [dbo].[ActivityLog]'
GO
ALTER TABLE [dbo].[ActivityLog] ADD CONSTRAINT [PK_alog] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Preferences]'
GO
CREATE TABLE [dbo].[Preferences]
(
[UserId] [int] NOT NULL,
[Preference] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UserPreferences] on [dbo].[Preferences]'
GO
ALTER TABLE [dbo].[Preferences] ADD CONSTRAINT [PK_UserPreferences] PRIMARY KEY CLUSTERED ([UserId], [Preference])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[TaskListOwners]'
GO
CREATE TABLE [dbo].[TaskListOwners]
(
[TaskListId] [int] NOT NULL,
[PeopleId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TaskListOwners] on [dbo].[TaskListOwners]'
GO
ALTER TABLE [dbo].[TaskListOwners] ADD CONSTRAINT [PK_TaskListOwners] PRIMARY KEY CLUSTERED ([TaskListId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Task]'
GO
CREATE TABLE [dbo].[Task]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[OwnerId] [int] NOT NULL,
[ListId] [int] NOT NULL,
[CoOwnerId] [int] NULL,
[CoListId] [int] NULL,
[StatusId] [int] NULL,
[CreatedOn] [datetime] NOT NULL,
[SourceContactId] [int] NULL,
[CompletedContactId] [int] NULL,
[Notes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [int] NULL,
[ModifiedOn] [datetime] NULL,
[Project] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archive] [bit] NOT NULL CONSTRAINT [DF_Task_Archive] DEFAULT ((0)),
[Priority] [int] NULL,
[WhoId] [int] NULL,
[Due] [datetime] NULL,
[Location] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompletedOn] [datetime] NULL,
[ForceCompleteWContact] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Task] on [dbo].[Task]'
GO
ALTER TABLE [dbo].[Task] ADD CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Task] on [dbo].[Task]'
GO
CREATE NONCLUSTERED INDEX [IX_Task] ON [dbo].[Task] ([OwnerId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Contactors]'
GO
CREATE TABLE [dbo].[Contactors]
(
[ContactId] [int] NOT NULL,
[PeopleId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Contactors] on [dbo].[Contactors]'
GO
ALTER TABLE [dbo].[Contactors] ADD CONSTRAINT [PK_Contactors] PRIMARY KEY CLUSTERED ([ContactId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Contactees]'
GO
CREATE TABLE [dbo].[Contactees]
(
[ContactId] [int] NOT NULL,
[PeopleId] [int] NOT NULL,
[ProfessionOfFaith] [bit] NULL,
[PrayedForPerson] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Contactees] on [dbo].[Contactees]'
GO
ALTER TABLE [dbo].[Contactees] ADD CONSTRAINT [PK_Contactees] PRIMARY KEY CLUSTERED ([ContactId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Volunteer]'
GO
CREATE TABLE [dbo].[Volunteer]
(
[PeopleId] [int] NOT NULL,
[StatusId] [int] NULL,
[ProcessedDate] [datetime] NULL,
[Standard] [bit] NOT NULL CONSTRAINT [DF_Volunteer_Standard] DEFAULT ((0)),
[Children] [bit] NOT NULL CONSTRAINT [DF_Volunteer_Children] DEFAULT ((0)),
[Leader] [bit] NOT NULL CONSTRAINT [DF_Volunteer_Leader] DEFAULT ((0)),
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VolunteerApproval] on [dbo].[Volunteer]'
GO
ALTER TABLE [dbo].[Volunteer] ADD CONSTRAINT [PK_VolunteerApproval] PRIMARY KEY CLUSTERED ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Contribution]'
GO
CREATE TABLE [dbo].[Contribution]
(
[ContributionId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[FundId] [int] NOT NULL,
[ContributionTypeId] [int] NOT NULL,
[PeopleId] [int] NULL,
[ContributionDate] [datetime] NULL,
[ContributionAmount] [numeric] (11, 2) NULL,
[ContributionDesc] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContributionStatusId] [int] NULL,
[PledgeFlag] [bit] NOT NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[PostingDate] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [CONTRIBUTION_PK] on [dbo].[Contribution]'
GO
ALTER TABLE [dbo].[Contribution] ADD CONSTRAINT [CONTRIBUTION_PK] PRIMARY KEY NONCLUSTERED ([ContributionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [CONTRIBUTION_FUND_FK_IX] on [dbo].[Contribution]'
GO
CREATE NONCLUSTERED INDEX [CONTRIBUTION_FUND_FK_IX] ON [dbo].[Contribution] ([FundId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ContributionTypeId] on [dbo].[Contribution]'
GO
CREATE NONCLUSTERED INDEX [IX_ContributionTypeId] ON [dbo].[Contribution] ([ContributionTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [CONTRIBUTION_PEOPLE_FK_IX] on [dbo].[Contribution]'
GO
CREATE NONCLUSTERED INDEX [CONTRIBUTION_PEOPLE_FK_IX] ON [dbo].[Contribution] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [CONTRIBUTION_DATE_IX] on [dbo].[Contribution]'
GO
CREATE NONCLUSTERED INDEX [CONTRIBUTION_DATE_IX] ON [dbo].[Contribution] ([ContributionDate])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_INDIVIDUAL_CONTRIBUTION_TBL_1] on [dbo].[Contribution]'
GO
CREATE NONCLUSTERED INDEX [IX_INDIVIDUAL_CONTRIBUTION_TBL_1] ON [dbo].[Contribution] ([ContributionStatusId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_INDIVIDUAL_CONTRIBUTION_TBL_2] on [dbo].[Contribution]'
GO
CREATE NONCLUSTERED INDEX [IX_INDIVIDUAL_CONTRIBUTION_TBL_2] ON [dbo].[Contribution] ([PledgeFlag])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[BlogPost]'
GO
CREATE TABLE [disc].[BlogPost]
(
[Id] [int] NOT NULL IDENTITY(568, 1),
[Title] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BlogId] [int] NOT NULL,
[Post] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryDate] [datetime] NULL,
[Updated] [datetime] NULL,
[EnclosureUrl] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnclosureLength] [int] NULL,
[EnclosureType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPublic] [bit] NOT NULL CONSTRAINT [DF_BlogPost_IsPublic] DEFAULT ((0)),
[NotifyLater] [bit] NOT NULL CONSTRAINT [DF_BlogPost_NotifyLater] DEFAULT ((0)),
[PosterId] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BlogPost] on [disc].[BlogPost]'
GO
ALTER TABLE [disc].[BlogPost] ADD CONSTRAINT [PK_BlogPost] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[BlogCategoryXref]'
GO
CREATE TABLE [disc].[BlogCategoryXref]
(
[CatId] [int] NOT NULL,
[BlogPostId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_bc] on [disc].[BlogCategoryXref]'
GO
ALTER TABLE [disc].[BlogCategoryXref] ADD CONSTRAINT [PK_bc] PRIMARY KEY CLUSTERED ([CatId], [BlogPostId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[VerseCategory]'
GO
CREATE TABLE [disc].[VerseCategory]
(
[id] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedOn] [datetime] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_btea_VerseCategory_3D610094] on [disc].[VerseCategory]'
GO
ALTER TABLE [disc].[VerseCategory] ADD CONSTRAINT [PK_btea_VerseCategory_3D610094] PRIMARY KEY CLUSTERED ([id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_VerseCategory] on [disc].[VerseCategory]'
GO
CREATE NONCLUSTERED INDEX [IX_VerseCategory] ON [disc].[VerseCategory] ([CreatedBy], [Name])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[VerseCategoryXref]'
GO
CREATE TABLE [disc].[VerseCategoryXref]
(
[VerseCategoryId] [int] NOT NULL,
[VerseId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VerseCategoryXref_1] on [disc].[VerseCategoryXref]'
GO
ALTER TABLE [disc].[VerseCategoryXref] ADD CONSTRAINT [PK_VerseCategoryXref_1] PRIMARY KEY CLUSTERED ([VerseCategoryId], [VerseId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [iVerseCategories_btea_VerseCategoriesVerses_5CB9F1B2] on [disc].[VerseCategoryXref]'
GO
CREATE NONCLUSTERED INDEX [iVerseCategories_btea_VerseCategoriesVerses_5CB9F1B2] ON [disc].[VerseCategoryXref] ([VerseCategoryId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [iVerseCategoriesVerses_btea_VerseCategoriesVerses_5FC63DDC] on [disc].[VerseCategoryXref]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [iVerseCategoriesVerses_btea_VerseCategoriesVerses_5FC63DDC] ON [disc].[VerseCategoryXref] ([VerseCategoryId], [VerseId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [iVerses_btea_VerseCategoriesVerses_1161F2C4] on [disc].[VerseCategoryXref]'
GO
CREATE NONCLUSTERED INDEX [iVerses_btea_VerseCategoriesVerses_1161F2C4] ON [disc].[VerseCategoryXref] ([VerseId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[PrayerSlot]'
GO
CREATE TABLE [disc].[PrayerSlot]
(
[Day] [int] NOT NULL,
[Time] [datetime] NOT NULL,
[PeopleId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PrayerSlot_1] on [disc].[PrayerSlot]'
GO
ALTER TABLE [disc].[PrayerSlot] ADD CONSTRAINT [PK_PrayerSlot_1] PRIMARY KEY CLUSTERED ([Day], [Time], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[PendingNotifications]'
GO
CREATE TABLE [disc].[PendingNotifications]
(
[PeopleId] [int] NOT NULL,
[NotifyType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PendingNotifications_1] on [disc].[PendingNotifications]'
GO
ALTER TABLE [disc].[PendingNotifications] ADD CONSTRAINT [PK_PendingNotifications_1] PRIMARY KEY CLUSTERED ([PeopleId], [NotifyType])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CheckInTimes]'
GO
CREATE TABLE [dbo].[CheckInTimes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PeopleId] [int] NULL,
[OrganizationId] [int] NULL,
[CheckInDay] [datetime] NULL,
[CheckInTime] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CheckInTimes] on [dbo].[CheckInTimes]'
GO
ALTER TABLE [dbo].[CheckInTimes] ADD CONSTRAINT [PK_CheckInTimes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_CheckInTimes] on [dbo].[CheckInTimes]'
GO
CREATE NONCLUSTERED INDEX [IX_CheckInTimes] ON [dbo].[CheckInTimes] ([CheckInDay])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_CheckInTimes_1] on [dbo].[CheckInTimes]'
GO
CREATE NONCLUSTERED INDEX [IX_CheckInTimes_1] ON [dbo].[CheckInTimes] ([CheckInTime])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CardIdentifiers]'
GO
CREATE TABLE [dbo].[CardIdentifiers]
(
[Id] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PeopleId] [int] NULL,
[CreatedOn] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CardIdentifiers] on [dbo].[CardIdentifiers]'
GO
ALTER TABLE [dbo].[CardIdentifiers] ADD CONSTRAINT [PK_CardIdentifiers] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[MOBSReg]'
GO
CREATE TABLE [dbo].[MOBSReg]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PeopleId] [int] NULL,
[Created] [datetime] NULL,
[NumTickets] [int] NOT NULL,
[FeePaid] [bit] NULL,
[TransactionId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MeetingId] [int] NULL,
[email] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[homecell] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MOBS_Id] on [dbo].[MOBSReg]'
GO
ALTER TABLE [dbo].[MOBSReg] ADD CONSTRAINT [PK_MOBS_Id] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EnrollmentTransaction]'
GO
CREATE TABLE [dbo].[EnrollmentTransaction]
(
[TransactionId] [int] NOT NULL IDENTITY(1, 1),
[TransactionStatus] [bit] NOT NULL CONSTRAINT [DF_ENROLLMENT_TRANSACTION_TBL_TRANSACTION_STATUS] DEFAULT ((0)),
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL,
[TransactionDate] [datetime] NOT NULL,
[TransactionTypeId] [int] NOT NULL,
[OrganizationId] [int] NOT NULL,
[OrganizationName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PeopleId] [int] NOT NULL,
[MemberTypeId] [int] NOT NULL,
[EnrollmentDate] [datetime] NULL,
[AttendancePercentage] [real] NULL,
[NextTranChangeDate] [datetime] NULL,
[EnrollmentTransactionId] [int] NULL,
[Pending] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [ENROLLMENT_TRANSACTION_PK] on [dbo].[EnrollmentTransaction]'
GO
ALTER TABLE [dbo].[EnrollmentTransaction] ADD CONSTRAINT [ENROLLMENT_TRANSACTION_PK] PRIMARY KEY NONCLUSTERED ([TransactionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [<Name of Missing Index, sysname,>] on [dbo].[EnrollmentTransaction]'
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[EnrollmentTransaction] ([TransactionDate], [TransactionTypeId]) INCLUDE ([OrganizationId], [PeopleId], [TransactionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [ENROLLMENT_TRANS_ORG_TC_TS_IX] on [dbo].[EnrollmentTransaction]'
GO
CREATE NONCLUSTERED INDEX [ENROLLMENT_TRANS_ORG_TC_TS_IX] ON [dbo].[EnrollmentTransaction] ([OrganizationId], [TransactionTypeId], [TransactionStatus])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ENROLLMENT_TRANSACTION_TBL] on [dbo].[EnrollmentTransaction]'
GO
CREATE NONCLUSTERED INDEX [IX_ENROLLMENT_TRANSACTION_TBL] ON [dbo].[EnrollmentTransaction] ([TransactionDate])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [ENROLLMENT_TRANSACTION_ORG_IX] on [dbo].[EnrollmentTransaction]'
GO
CREATE NONCLUSTERED INDEX [ENROLLMENT_TRANSACTION_ORG_IX] ON [dbo].[EnrollmentTransaction] ([OrganizationId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [ENROLLMENT_TRANSACTION_PPL_IX] on [dbo].[EnrollmentTransaction]'
GO
CREATE NONCLUSTERED INDEX [ENROLLMENT_TRANSACTION_PPL_IX] ON [dbo].[EnrollmentTransaction] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[BadET]'
GO
CREATE TABLE [dbo].[BadET]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[PeopleId] [int] NOT NULL,
[OrgId] [int] NULL,
[TranId] [int] NOT NULL,
[Flag] [int] NOT NULL,
[Status] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BadET] on [dbo].[BadET]'
GO
ALTER TABLE [dbo].[BadET] ADD CONSTRAINT [PK_BadET] PRIMARY KEY CLUSTERED ([id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_BadET] on [dbo].[BadET]'
GO
CREATE NONCLUSTERED INDEX [IX_BadET] ON [dbo].[BadET] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_BadET_1] on [dbo].[BadET]'
GO
CREATE NONCLUSTERED INDEX [IX_BadET_1] ON [dbo].[BadET] ([TranId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[OrgMemMemTags]'
GO
CREATE TABLE [dbo].[OrgMemMemTags]
(
[OrgId] [int] NOT NULL,
[PeopleId] [int] NOT NULL,
[MemberTagId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_OrgMemMemTags] on [dbo].[OrgMemMemTags]'
GO
ALTER TABLE [dbo].[OrgMemMemTags] ADD CONSTRAINT [PK_OrgMemMemTags] PRIMARY KEY CLUSTERED ([OrgId], [PeopleId], [MemberTagId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[QueryBuilderClauses]'
GO
CREATE TABLE [dbo].[QueryBuilderClauses]
(
[QueryId] [int] NOT NULL IDENTITY(1, 1),
[ClauseOrder] [int] NOT NULL CONSTRAINT [DF_QueryBuilderClauses_ClauseOrder] DEFAULT ((0)),
[GroupId] [int] NULL,
[Field] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comparison] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TextValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateValue] [datetime] NULL,
[CodeIdValue] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Organization] [int] NOT NULL CONSTRAINT [DF_QueryBuilderClauses_Organization] DEFAULT ((0)),
[Days] [int] NOT NULL CONSTRAINT [DF_QueryBuilderClauses_Days] DEFAULT ((0)),
[SavedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPublic] [bit] NOT NULL CONSTRAINT [QueryBuilderIsPublic] DEFAULT ((0)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_QueryBuilderClauses_ModifiedOn] DEFAULT (getdate()),
[Quarters] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SavedQueryIdDesc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_QueryBuilderClauses_SavedQueryId] DEFAULT ((0)),
[Tags] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Schedule] [int] NOT NULL CONSTRAINT [DF_QueryBuilderClauses_Schedule] DEFAULT ((0)),
[Program] [int] NOT NULL CONSTRAINT [DF_QueryBuilderClauses_DivOrgs] DEFAULT ((0)),
[Division] [int] NOT NULL CONSTRAINT [DF_QueryBuilderClauses_SubDivOrgs] DEFAULT ((0)),
[Age] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_QueryBuilderClauses] on [dbo].[QueryBuilderClauses]'
GO
ALTER TABLE [dbo].[QueryBuilderClauses] ADD CONSTRAINT [PK_QueryBuilderClauses] PRIMARY KEY CLUSTERED ([QueryId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_GroupId] on [dbo].[QueryBuilderClauses]'
GO
CREATE NONCLUSTERED INDEX [IX_GroupId] ON [dbo].[QueryBuilderClauses] ([GroupId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_QueryBuilderClauses] on [dbo].[QueryBuilderClauses]'
GO
CREATE NONCLUSTERED INDEX [IX_QueryBuilderClauses] ON [dbo].[QueryBuilderClauses] ([SavedBy])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[QBClauses]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION QBClauses(@qid INT)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	WITH QB (QueryId, GroupId, SavedBy, Description, Level)
	AS
	(
	-- Anchor member definition
		SELECT c.QueryId, c.GroupId, c.SavedBy, c.Description, 0 AS Level
		FROM dbo.QueryBuilderClauses c
		WHERE c.QueryId = @qid AND c.GroupId IS NULL
		UNION ALL
	-- Recursive member definition
		SELECT c.QueryId, c.GroupId, c.SavedBy, c.Description, cc.Level + 1
		FROM dbo.QueryBuilderClauses c
		INNER JOIN QB AS cc
			ON c.GroupId = cc.QueryId
	)
	SELECT QueryId, GroupId, SavedBy, Description, [Level] FROM QB
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DeleteQBTree]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DeleteQBTree(@qid INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

		DECLARE cur CURSOR FOR SELECT QueryId FROM dbo.QBClauses(@qid) ORDER BY LEVEL DESC
		OPEN cur
		DECLARE @id int
		FETCH NEXT FROM cur INTO @id
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE dbo.QueryBuilderClauses
			WHERE QueryId = @id
			FETCH NEXT FROM cur INTO @id
		END
		CLOSE cur
		DEALLOCATE cur

		
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryAdult3]'
GO
CREATE PROCEDURE [dbo].[PrimaryAdult3]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT PeopleId, v.cnt, v.FamilyId FROM dbo.People p
	JOIN (SELECT COUNT(*) cnt, FamilyId
	FROM dbo.People
	WHERE PositionInFamilyId = 10
	GROUP BY FamilyId
	HAVING COUNT(*) > 2) v
	ON p.FamilyId = v.FamilyId
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LastName]'
GO
CREATE VIEW [dbo].[LastName]
AS
SELECT LastName, COUNT(*) AS [count] FROM dbo.People GROUP BY LastName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[WidowedDate]'
GO
CREATE FUNCTION [dbo].[WidowedDate] 
(
	@peopleid int
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result DATETIME

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = s.DeceasedDate 
      FROM ( SELECT p1.FamilyId,
                    p1.MaritalStatusId,
                    p1.PositionInFamilyId
               FROM dbo.People p1
              WHERE p1.PeopleId =  @peopleid
                AND p1.MaritalStatusId = 50
                AND p1.DeceasedDate IS NULL
           ) p
     INNER JOIN dbo.Families f
             ON f.FamilyId = p.FamilyId
     INNER JOIN dbo.People s
             ON s.FamilyId = f.FamilyId
     WHERE s.PeopleId <> @peopleid 
       AND p.PositionInFamilyId = s.PositionInFamilyId
       AND s.DeceasedDate IS NOT NULL

	-- Return the result of the function
	RETURN @Result

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[WasDeaconActive2008]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[WasDeaconActive2008](@pid INT, @dt DATETIME)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @r BIT 

	IF EXISTS(SELECT NULL FROM dbo.OrganizationMembers o WHERE o.OrganizationId = 80063 AND @pid = o.PeopleId) AND @dt > '1/1/2008' AND @dt < '11/1/2008'
		SELECT @r = 0
	ELSE IF EXISTS(SELECT NULL FROM dbo.OrganizationMembers o2 WHERE o2.OrganizationId = 80092 AND o2.PeopleId = @pid)
		SELECT @r = 1
	ELSE
		SELECT @r = 0

	-- Return the result of the function
	RETURN @r

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[words]'
GO
CREATE TABLE [dbo].[words]
(
[word] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[n] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_words_1] on [dbo].[words]'
GO
ALTER TABLE [dbo].[words] ADD CONSTRAINT [PK_words_1] PRIMARY KEY CLUSTERED ([word])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_words] on [dbo].[words]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_words] ON [dbo].[words] ([n])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[RenumberWords]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE disc.RenumberWords
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE dbo.words
	SET n = nn
	FROM words w JOIN 
	(SELECT word, ROW_NUMBER() OVER (ORDER BY word) AS nn FROM dbo.words) AS tt
	ON w.word = tt.word
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateAttendStr]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAttendStr] @orgid INT, @pid INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-----------------------------------------------------------------
    DECLARE @yearago DATETIME
    DECLARE @lastmeet DATETIME 
    DECLARE @tct INT 
    DECLARE @act INT
    DECLARE @pct REAL
		
    SELECT @lastmeet = MAX(MeetingDate) FROM dbo.Meetings
    WHERE OrganizationId = @orgid
    
    SELECT @yearago = DATEADD(year,-1,@lastmeet)
    
	SELECT @tct = COUNT(*) FROM dbo.Attend a
	JOIN dbo.Organizations o ON a.OrganizationId = o.OrganizationId
    WHERE PeopleId = @pid
    AND a.OrganizationId = @orgid
    AND ((o.AttendTrkLevelId = 30 AND (ISNULL(a.Registered,0) = 1 OR EffAttendFlag = 1)) 
			OR o.AttendTrkLevelId = 20)
    AND EffAttendFlag IS NOT NULL
    AND MeetingDate >= @yearago
    AND MeetingDate <= GETDATE()
    
    SELECT @act = COUNT(*) FROM dbo.Attend
    WHERE PeopleId = @pid
    AND OrganizationId = @orgid
    AND EffAttendFlag = 1
    AND MeetingDate >= @yearago
    AND MeetingDate <= GETDATE()
       
       
	if @tct = 0
			select @pct = 0
		else
			SELECT @pct = @act * 100.0 / @tct
			
	-------------------------------------------------------
	DECLARE @a nvarchar(200) -- attendance string
	set @a = ''
			
	DECLARE @mindt DATETIME, @dt DATETIME 

	SELECT @mindt = MIN(MeetingDate), @dt = MAX(MeetingDate) FROM dbo.Meetings WHERE OrganizationId = @orgid
	SELECT @dt = DATEADD(yy, -1, @dt)
	IF (@dt > @mindt)
		SELECT @mindt = @dt
		FROM dbo.Attend
		WHERE OrganizationId = @orgid AND PeopleId = @pid

	SELECT @a = 
		CASE 
		WHEN a.EffAttendFlag IS NULL THEN
			CASE a.AttendanceTypeId
			WHEN 20 THEN 'V'
			WHEN 70 THEN 'I'
			WHEN 90 THEN 'G'
			WHEN 80 THEN 'O'
			WHEN 110 THEN '*'
			ELSE '*'
			END
		WHEN a.EffAttendFlag = 1 THEN 'P'
		ELSE '.'
		END + @a
	FROM dbo.Attend a
	JOIN dbo.Organizations o ON a.OrganizationId = o.OrganizationId
	WHERE a.MeetingDate >= @dt 
	AND a.MeetingDate <= GETDATE()
	AND a.PeopleId = @pid 
	AND a.OrganizationId = @orgid
    AND ((o.AttendTrkLevelId = 30 AND ISNULL(a.Registered,0) = 1) 
			OR o.AttendTrkLevelId = 20)
	ORDER BY MeetingDate DESC
	
	----------------------------------------------------------------
	DECLARE @lastattend DATETIME
	SELECT @lastattend = MAX(a.MeetingDate) FROM dbo.Attend a
	WHERE a.AttendanceFlag = 1 AND a.OrganizationId = @orgid AND a.PeopleId = @pid

	
	--------------------------------------------	
	
		
	UPDATE dbo.OrganizationMembers SET
		AttendPct = @pct,
		AttendStr = @a,
		LastAttended = @lastattend
	WHERE OrganizationId = @orgid AND PeopleId = @pid

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateAllAttendStr]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAllAttendStr]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		DECLARE cur CURSOR FOR SELECT OrganizationId, PeopleId FROM dbo.OrganizationMembers
		OPEN cur
		DECLARE @oid INT, @pid INT, @n INT
		SET @n = 0
		FETCH NEXT FROM cur INTO @oid, @pid
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE dbo.UpdateAttendStr @oid, @pid
			SET @n = @n + 1
			IF (@n % 1000) = 0
				RAISERROR ('%d', 0, 1, @n) WITH NOWAIT
			FETCH NEXT FROM cur INTO @oid, @pid
		END
		CLOSE cur
		DEALLOCATE cur
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Nick]'
GO
CREATE VIEW [dbo].[Nick]
AS
SELECT NickName, COUNT(*) AS [count] FROM dbo.People GROUP BY NickName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[Verse]'
GO
CREATE TABLE [disc].[Verse]
(
[id] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[VerseRef] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VerseText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Book] [int] NULL,
[Chapter] [int] NULL,
[VerseNum] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_btea_Verse_1D7E4B61] on [disc].[Verse]'
GO
ALTER TABLE [disc].[Verse] ADD CONSTRAINT [PK_btea_Verse_1D7E4B61] PRIMARY KEY CLUSTERED ([id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[VersePos]'
GO
CREATE FUNCTION disc.VersePos
	(
	@id int
	)
RETURNS int
AS
	BEGIN
		return (select Book * 100000 + Chapter * 100 + VerseNum 
		from Verse
		where id = @id)
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[NextBirthday]'
GO
CREATE FUNCTION [dbo].[NextBirthday](@pid int)
RETURNS datetime
AS
	BEGIN
	
	
	  DECLARE
		@today DATETIME,
		@date datetime, 
		@m int,
		@d int,
		@y int
		
SELECT @today = CONVERT(datetime, CONVERT(varchar, GETDATE(), 112))
select @date = null
select @m = BirthMonth, @d = BirthDay from dbo.People where @pid = PeopleId
if @m is null or @d is null
	return @date
select @y = DATEPART(year, @today) 
select @date = dateadd(mm,(@y-1900)* 12 + @m - 1,0) + (@d-1) 
if @date < @today
	select @date = dateadd(yy, 1, @date)
RETURN @date
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FirstNick]'
GO
CREATE VIEW [dbo].[FirstNick]
AS
SELECT FirstName, NickName, COUNT(*) AS [count] FROM dbo.People GROUP BY FirstName, NickName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FirstName2]'
GO
CREATE VIEW [dbo].[FirstName2]
AS
SELECT     FirstName, GenderId, CA, COUNT(*) AS Expr1
FROM         (SELECT     FirstName, GenderId, CASE WHEN Age <= 18 THEN 'C' ELSE 'A' END AS CA
                       FROM          dbo.People) AS ttt
GROUP BY FirstName, GenderId, CA

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Age]'
GO
CREATE FUNCTION [dbo].[Age](@pid int)
RETURNS int
AS
	BEGIN
	
	  DECLARE
		@v_return int, 
		@v_end_date datetime,
		@m int,
		@d int,
		@y int,
		@p_deceased_date datetime,
		@p_drop_code_id int
		
select @m = BirthMonth, @d = BirthDay, @y = BirthYear, @p_deceased_date = DeceasedDate, @p_drop_code_id = DropCodeId from dbo.People where @pid = PeopleId


         SET @v_return = NULL

         IF @y IS NOT NULL AND NOT (@p_deceased_date IS NULL AND isnull(@p_drop_code_id, 0) = 30)
            /* 30=Deceased*/
            BEGIN

               SET @v_end_date = isnull(@p_deceased_date, getdate())

               SET @v_return = datepart(YEAR, @v_end_date) - @y

               IF isnull(@m, 1) > datepart(MONTH, @v_end_date)
                  SET @v_return = @v_return - 1
               ELSE 
                  IF isnull(@m, 1) = datepart(MONTH, @v_end_date) AND isnull(@d, 1) > datepart(DAY, @v_end_date)
                     SET @v_return = @v_return - 1

            END

	RETURN @v_return
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FirstName]'
GO
CREATE VIEW [dbo].[FirstName]
AS
SELECT     FirstName, COUNT(*) AS count
FROM         dbo.People
GROUP BY FirstName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EnrollmentTransactionId]'
GO
CREATE FUNCTION [dbo].[EnrollmentTransactionId]
(
  @pid int
 ,@oid int
 ,@tid int
 ,@ttid int
)
RETURNS int
AS
	BEGIN
	  DECLARE @TransactionId int
	  SELECT @TransactionId = NULL
	  if @ttid >= 3
		  select top 1 @TransactionId = et.TransactionId
			from  dbo.EnrollmentTransaction et
		   where et.TransactionTypeId <= 2
			 and et.PeopleId = @pid
			 and et.OrganizationId = @oid
			 and et.TransactionId < @tid
	   order by et.TransactionId desc
	RETURN @TransactionId
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[NextTranChangeDate]'
GO
CREATE FUNCTION [dbo].[NextTranChangeDate]
(
  @pid int
 ,@oid int
 ,@tid int
 ,@typeid int
)
RETURNS datetime
AS
	BEGIN
	  DECLARE @dt datetime 
		  select top 1 @dt = TransactionDate
			from dbo.EnrollmentTransaction
		   where TransactionTypeId >= 3
		     and @typeid <= 3
			 and PeopleId = @pid
			 and OrganizationId = @oid
			 and TransactionId > @tid
	   order by TransactionId
	RETURN @dt
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ShowTransactions]'
GO
CREATE PROCEDURE [dbo].[ShowTransactions](@pid INT, @orgid INT)
AS
BEGIN
	SELECT
		TransactionId, 
		TransactionDate, 
		TransactionTypeId, 
		OrganizationId, 
		PeopleId, 
		NextTranChangeDate,
		dbo.NextTranChangeDate(PeopleId, OrganizationId, TransactionId, TransactionTypeId) NextTranChangeDate0,
		EnrollmentTransactionId,
		dbo.EnrollmentTransactionId(PeopleId, OrganizationId, TransactionId, TransactionTypeId) EnrollmentTransactionId0,
		CreatedDate
	FROM dbo.EnrollmentTransaction
	WHERE PeopleId = @pid AND (OrganizationId = @orgid OR @orgid = 0)
	ORDER BY TransactionId

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DeleteAllQueriesWithNoChildren]'
GO
CREATE PROCEDURE [dbo].[DeleteAllQueriesWithNoChildren]
AS
BEGIN
	SET NOCOUNT ON;

delete from QueryBuilderClauses where queryid in (select q.queryid
FROM       QueryBuilderClauses q
where not exists (select null from QueryBuilderClauses where groupid = q.queryid))

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Audits]'
GO
CREATE TABLE [dbo].[Audits]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Action] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableKey] [int] NULL,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AuditDate] [smalldatetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Audits] on [dbo].[Audits]'
GO
ALTER TABLE [dbo].[Audits] ADD CONSTRAINT [PK_Audits] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AuditValues]'
GO
CREATE TABLE [dbo].[AuditValues]
(
[AuditId] [int] NOT NULL,
[MemberName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_AuditValues] on [dbo].[AuditValues]'
GO
ALTER TABLE [dbo].[AuditValues] ADD CONSTRAINT [PK_AuditValues] PRIMARY KEY CLUSTERED ([AuditId], [MemberName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[BundleDetail]'
GO
CREATE TABLE [dbo].[BundleDetail]
(
[BundleDetailId] [int] NOT NULL IDENTITY(1, 1),
[BundleHeaderId] [int] NOT NULL,
[ContributionId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [BUNDLE_DETAIL_PK] on [dbo].[BundleDetail]'
GO
ALTER TABLE [dbo].[BundleDetail] ADD CONSTRAINT [BUNDLE_DETAIL_PK] PRIMARY KEY NONCLUSTERED ([BundleDetailId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [BUNDLE_DETAIL_BUNDLE_FK_IX] on [dbo].[BundleDetail]'
GO
CREATE NONCLUSTERED INDEX [BUNDLE_DETAIL_BUNDLE_FK_IX] ON [dbo].[BundleDetail] ([BundleHeaderId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [BUNDLE_DETAIL_CONTR_FK_IX] on [dbo].[BundleDetail]'
GO
CREATE NONCLUSTERED INDEX [BUNDLE_DETAIL_CONTR_FK_IX] ON [dbo].[BundleDetail] ([ContributionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[BundleHeader]'
GO
CREATE TABLE [dbo].[BundleHeader]
(
[BundleHeaderId] [int] NOT NULL IDENTITY(1, 1),
[ChurchId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[RecordStatus] [bit] NOT NULL,
[BundleStatusId] [int] NOT NULL,
[ContributionDate] [datetime] NOT NULL,
[BundleHeaderTypeId] [int] NOT NULL,
[DepositDate] [datetime] NULL,
[BundleTotal] [numeric] (10, 2) NULL,
[TotalCash] [numeric] (10, 2) NULL,
[TotalChecks] [numeric] (10, 2) NULL,
[TotalEnvelopes] [numeric] (10, 2) NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[FundId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [BUNDLE_HEADER_PK] on [dbo].[BundleHeader]'
GO
ALTER TABLE [dbo].[BundleHeader] ADD CONSTRAINT [BUNDLE_HEADER_PK] PRIMARY KEY NONCLUSTERED ([BundleHeaderId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [BUNDLE_HEADER_CHURCH_FK_IX] on [dbo].[BundleHeader]'
GO
CREATE NONCLUSTERED INDEX [BUNDLE_HEADER_CHURCH_FK_IX] ON [dbo].[BundleHeader] ([ChurchId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[TaskList]'
GO
CREATE TABLE [dbo].[TaskList]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TaskList] on [dbo].[TaskList]'
GO
ALTER TABLE [dbo].[TaskList] ADD CONSTRAINT [PK_TaskList] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[RecLeague]'
GO
CREATE TABLE [dbo].[RecLeague]
(
[DivId] [int] NOT NULL,
[AgeDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraFee] [money] NULL,
[ExpirationDt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShirtFee] [money] NULL,
[EmailMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailSubject] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddresses] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_RecLeague] on [dbo].[RecLeague]'
GO
ALTER TABLE [dbo].[RecLeague] ADD CONSTRAINT [PK_RecLeague] PRIMARY KEY CLUSTERED ([DivId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Promotion]'
GO
CREATE TABLE [dbo].[Promotion]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[FromDivId] [int] NULL,
[ToDivId] [int] NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sort] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Promotion] on [dbo].[Promotion]'
GO
ALTER TABLE [dbo].[Promotion] ADD CONSTRAINT [PK_Promotion] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[MemberTags]'
GO
CREATE TABLE [dbo].[MemberTags]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrgId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MemberTags] on [dbo].[MemberTags]'
GO
ALTER TABLE [dbo].[MemberTags] ADD CONSTRAINT [PK_MemberTags] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[NewContact]'
GO
CREATE TABLE [dbo].[NewContact]
(
[ContactId] [int] NOT NULL IDENTITY(200000, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ContactTypeId] [int] NOT NULL,
[ContactDate] [datetime] NOT NULL,
[ContactReasonId] [int] NOT NULL,
[MinistryId] [int] NULL,
[NotAtHome] [bit] NULL,
[LeftDoorHanger] [bit] NULL,
[LeftMessage] [bit] NULL,
[GospelShared] [bit] NULL,
[PrayerRequest] [bit] NULL,
[ContactMade] [bit] NULL,
[GiftBagGiven] [bit] NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Contacts] on [dbo].[NewContact]'
GO
ALTER TABLE [dbo].[NewContact] ADD CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED ([ContactId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VolInterestCodes]'
GO
CREATE TABLE [dbo].[VolInterestCodes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Org] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VolInterestCodes] on [dbo].[VolInterestCodes]'
GO
ALTER TABLE [dbo].[VolInterestCodes] ADD CONSTRAINT [PK_VolInterestCodes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ShowOddTransactions]'
GO
CREATE PROCEDURE [dbo].[ShowOddTransactions]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @t TABLE(PeopleId INT, OrgId INT)

	DECLARE @tid INT, @typeid INT, @orgid INT, @pid INT
	DECLARE @ptid INT = 0, @ptypeid INT = 0, @porgid INT = 0, @ppid INT = 0

	DECLARE c CURSOR FOR
	SELECT TransactionId, TransactionTypeId, OrganizationId, PeopleId 
	FROM dbo.EnrollmentTransaction
	ORDER BY PeopleId, OrganizationId, TransactionId

	OPEN c
	FETCH NEXT FROM c INTO @tid, @typeid, @orgid, @pid
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ppid = @pid AND @porgid = @orgid
		BEGIN
			IF (@typeid < 3 AND @ptypeid < 3) or (@typeid > 3 AND @ptypeid > 3)
				INSERT @t (PeopleId, OrgId) VALUES (@pid, @orgid)
		END
		
		SELECT @ptid = @tid, @ptypeid = @typeid, @porgid = @orgid, @ppid = @pid
		FETCH NEXT FROM c INTO @tid, @typeid, @orgid, @pid
	END
	CLOSE c
	DEALLOCATE c
	
	DECLARE cc CURSOR FOR
	SELECT DISTINCT * FROM @t
	OPEN cc
	FETCH NEXT FROM cc INTO @pid, @orgid
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.ShowTransactions @pid, @orgid
		FETCH NEXT FROM cc INTO @pid, @orgid
	END
	CLOSE cc
	DEALLOCATE cc
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[HomePhone]'
GO
CREATE FUNCTION [dbo].[HomePhone](@pid int)
RETURNS varchar(11)
AS
	BEGIN
	declare @homephone varchar(11)
	select @homephone = f.HomePhone from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

	RETURN @homephone
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PopulateComputedEnrollmentTransactions]'
GO
CREATE PROCEDURE [dbo].[PopulateComputedEnrollmentTransactions]
AS
BEGIN
	UPDATE dbo.EnrollmentTransaction
	SET NextTranChangeDate = dbo.NextTranChangeDate(PeopleId, OrganizationId, TransactionId, TransactionTypeId),
		EnrollmentTransactionId = dbo.EnrollmentTransactionId(PeopleId, OrganizationId, TransactionId, TransactionTypeId)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryZip]'
GO
CREATE FUNCTION [dbo].[PrimaryZip] ( @pid int )
RETURNS varchar(11)
AS
	BEGIN
declare @zip varchar(11)
select @zip =
	case AddressTypeId
			when 10 then f.ZipCode
			when 20 then f.AltZipCode
			when 30 then p.ZipCode
			when 40 then p.AltZipCode
	end
from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

	RETURN @zip
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryResCode]'
GO
CREATE FUNCTION [dbo].[PrimaryResCode]( @pid int )
RETURNS int
AS
	BEGIN
declare @rescodeid int
select @rescodeid =
	case AddressTypeId
		when 10 then f.ResCodeId
		when 20 then f.AltResCodeId
		when 30 then p.ResCodeId
		when 40 then p.AltResCodeId
	end
from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

if @rescodeid is null
	select @rescodeid = 40

	RETURN @rescodeid
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryBadAddressFlag]'
GO
CREATE FUNCTION [dbo].[PrimaryBadAddressFlag]( @pid int )
RETURNS int
AS
	BEGIN
declare @flag bit
select @flag =
	case AddressTypeId
		when 10 then f.BadAddressFlag
		when 20 then f.AltBadAddressFlag
		when 30 then p.BadAddressFlag
		when 40 then p.AltBadAddressFlag
	end
	
from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

if (@flag is null)
	select @flag = 0

	RETURN @flag
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryState]'
GO
CREATE FUNCTION [dbo].[PrimaryState] ( @pid int )
RETURNS varchar(5)
AS
	BEGIN
declare @st varchar(5)
select @st =
	case AddressTypeId
			when 10 then f.StateCode
			when 20 then f.AltStateCode
			when 30 then p.StateCode
			when 40 then p.AltStateCode
	end
from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

	RETURN @st
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryAddress2]'
GO
CREATE FUNCTION [dbo].[PrimaryAddress2] ( @pid int )
RETURNS varchar(60)
AS
	BEGIN
declare @addr varchar(60)
select @addr =
	case AddressTypeId
			when 10 then f.AddressLineTwo
			when 20 then f.AltAddressLineTwo
			when 30 then p.AddressLineTwo
			when 40 then p.AltAddressLineTwo
	end
from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

	RETURN @addr
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryAddress]'
GO
CREATE FUNCTION [dbo].[PrimaryAddress] ( @pid int )
RETURNS varchar(60)
AS
	BEGIN
declare @addr varchar(60)
select @addr =
	case AddressTypeId
			when 10 then f.AddressLineOne
			when 20 then f.AltAddressLineOne
			when 30 then p.AddressLineOne
			when 40 then p.AltAddressLineOne
	end
from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

	RETURN @addr
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PrimaryCity]'
GO
CREATE FUNCTION [dbo].[PrimaryCity] ( @pid int )
RETURNS varchar(50)
AS
	BEGIN
declare @city varchar(50)
select @city =
	case AddressTypeId
			when 10 then f.CityName
			when 20 then f.AltCityName
			when 30 then p.CityName
			when 40 then p.AltCityName
	end
from dbo.People p join dbo.Families f on f.FamilyId = p.FamilyId
where PeopleId = @pid

	RETURN @city
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[NextChangeTransactionId2]'
GO
CREATE FUNCTION [dbo].[NextChangeTransactionId2]
(
  @pid int
 ,@oid int
 ,@tid int
 ,@typeid int
)
RETURNS int
AS
	BEGIN
	  DECLARE @rtid int 
		  select top 1 @rtid = TransactionId
			from dbo.EnrollmentTransaction
		   where TransactionTypeId >= 3
		     and @typeid <= 3
			 and PeopleId = @pid
			 and OrganizationId = @oid
			 and TransactionId > @tid
			 AND TransactionStatus = 0
	   order by TransactionId
	RETURN @rtid
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UName2]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[UName2] (@pid int)
RETURNS varchar(100)
AS
BEGIN
	-- Declare the return variable here
	declare @name varchar(100)
	
	SELECT  @name = [LastName]+', '+(case when [Nickname]<>'' then [nickname] else [FirstName] end)
	FROM         dbo.People
	WHERE     PeopleId = @pid

	return @name

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UName]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[UName] (@pid int)
RETURNS varchar(100)
AS
BEGIN
	-- Declare the return variable here
	declare @name varchar(100)
	
	SELECT  @name = (case when [Nickname]<>'' then [nickname] else [FirstName] end) + ' ' + [LastName]
	FROM         dbo.People
	WHERE     PeopleId = @pid

	return @name

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[NextChangeTransactionId]'
GO
CREATE FUNCTION [dbo].[NextChangeTransactionId]
(
  @pid int
 ,@oid int
 ,@tid int
 ,@typeid int
)
RETURNS int
AS
	BEGIN
	  DECLARE @rtid int 
		  select top 1 @rtid = TransactionId
			from dbo.EnrollmentTransaction
		   where TransactionTypeId >= 3
		     and @typeid <= 3
			 and PeopleId = @pid
			 and OrganizationId = @oid
			 and TransactionId > @tid
	   order by TransactionId
	RETURN @rtid
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LinkEnrollmentTransaction]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LinkEnrollmentTransaction] (@tid INT, @trandt DATETIME, @typeid INT, @orgid INT, @pid int)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @etid INT -- Find the original enrollment transaction
	SELECT TOP 1 @etid = TransactionId
	FROM dbo.EnrollmentTransaction
	WHERE TransactionTypeId <= 2
		AND PeopleId = @pid
		AND OrganizationId = @orgid
		AND TransactionId < @tid
		AND @typeid >= 3
	ORDER  BY  TransactionId DESC 

	-- point the current transction to the original enrollment
	UPDATE dbo.EnrollmentTransaction
	SET EnrollmentTransactionId = @etid
	WHERE TransactionId = @tid AND @etid IS NOT NULL

	DECLARE @previd INT -- find previous transaction
	
	SELECT TOP 1 @previd = TransactionId
	FROM dbo.EnrollmentTransaction
	WHERE TransactionTypeId <= 3
		AND @typeid >= 3
		AND PeopleId = @pid
		AND OrganizationId = @orgid
		AND TransactionId < @tid
	ORDER BY TransactionId DESC
	
	-- set the previous transaction's next tran date
	UPDATE dbo.EnrollmentTransaction
	SET NextTranChangeDate = @trandt
	WHERE TransactionId = @previd
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LinkEnrollmentTransactions]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LinkEnrollmentTransactions] (@pid INT, @orgid INT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tid INT, @typeid INT, @tdt DATETIME

	DECLARE c CURSOR FOR
	SELECT TransactionId, TransactionTypeId, TransactionDate
	FROM dbo.EnrollmentTransaction et
	WHERE et.TransactionStatus = 0 AND et.PeopleId = @pid AND et.OrganizationId = @orgid
	ORDER BY TransactionDate, TransactionId

	OPEN c
	FETCH NEXT FROM c INTO @tid, @typeid, @tdt
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.LinkEnrollmentTransaction @tid, @tdt, @typeid, @orgid, @pid
		FETCH NEXT FROM c INTO @tid, @typeid, @tdt
	END
	CLOSE c
	DEALLOCATE c
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[City]'
GO
CREATE VIEW [dbo].[City]
AS
SELECT PrimaryCity AS City, PrimaryState AS State, PrimaryZip AS Zip, COUNT(*) AS [count] FROM dbo.People GROUP BY PrimaryCity, PrimaryState, PrimaryZip

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GetTodaysMeetingId]'
GO
CREATE FUNCTION [dbo].[GetTodaysMeetingId]
    (
      @orgid INT ,
      @thisday INT
    )
RETURNS INT 
AS 
    BEGIN
        DECLARE 
			@DefaultHour DATETIME,
            @DefaultDay INT,
            @prevMidnight DATETIME,
            @ninetyMinutesAgo DATETIME,
            @nextMidnight DATETIME
            
        IF @thisday IS NULL
			SELECT @thisday = DATEPART(dw, GETDATE()) - 1
			
		DECLARE @plusdays INT = @thisday - (DATEPART(dw, GETDATE())-1) + 7
		IF @plusdays > 6
			SELECT @plusdays = @plusdays - 7
		SELECT @prevMidnight = dateadd(dd,0, datediff(dd,0,GETDATE())) + @plusdays
        SELECT @nextMidnight = @prevMidnight + 1
        SELECT @ninetyMinutesAgo = DATEADD(mi, -90, GETDATE())
        
        SELECT  @DefaultHour = MeetingTime,
                @DefaultDay = ISNULL(SchedDay, 0)
        FROM    dbo.Organizations
        WHERE   OrganizationId = @orgid
        
        DECLARE @meetingid INT, @meetingdate DATETIME
        
        SELECT TOP 1 @meetingid = MeetingId FROM dbo.Meetings
        WHERE OrganizationId = @orgid
        AND MeetingDate >= @ninetyMinutesAgo
        AND MeetingDate < @nextMidnight
        ORDER BY MeetingDate
        
        IF @meetingid IS NULL
			SELECT TOP 1 @meetingid = MeetingId FROM dbo.Meetings
			WHERE OrganizationId = @orgid
			AND MeetingDate >= @prevMidnight
			AND MeetingDate < @nextMidnight
			ORDER BY MeetingDate
			
		RETURN @meetingid

    END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Contributors]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[Contributors](@fd DATETIME, @td DATETIME, @pid INT, @spid INT, @fid INT)
RETURNS TABLE 
AS
RETURN 
(
	select	p.PeopleId, 
			p.PositionInFamilyId, 
			p.Name, 
			f.HeadOfHouseholdId, 
			p.TitleCode AS Title, 
			p.SuffixCode AS Suffix,
			p.SpouseId,
			sp.[Name] AS SpouseName, 
			sp.TitleCode AS SpouseTitle,
			sp.ContributionOptionsId AS SpouseContributionOptionsId,
			p.ContributionOptionsId,
			p.PrimaryAddress,
			p.PrimaryAddress2,
			p.PrimaryCity,
			p.PrimaryState,
			p.PrimaryZip,
			p.DeceasedDate,
			p.FamilyId,
			p.Age,
			CASE WHEN f.HeadOfHouseholdId = p.PeopleId THEN 1 ELSE 0 END AS hohFlag
	from People p
	JOIN dbo.Families f ON p.FamilyId = f.FamilyId
	LEFT OUTER JOIN dbo.People sp ON p.SpouseId = sp.PeopleId
	WHERE EXISTS(
		SELECT NULL FROM Contribution c 
		WHERE c.PeopleId = p.PeopleId
		AND c.ContributionStatusId = 0
		AND c.ContributionTypeId NOT IN (6,7)
		AND c.ContributionDate >= @fd
		AND c.ContributionDate <= @td)
	AND p.ContributionOptionsId > 0
	AND p.PrimaryAddress <> ''
	AND p.PrimaryBadAddrFlag = 0
	AND (@pid = 0 OR @pid = p.PeopleId OR @spid = p.PeopleId)
	AND (@fid = 0 OR @fid = p.FamilyId)
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GetTodaysMeetingHour]'
GO
CREATE FUNCTION [dbo].[GetTodaysMeetingHour]
    (
      @orgid INT ,
      @thisday INT
    )
RETURNS DATETIME
AS 
    BEGIN
        DECLARE 
			@DefaultHour DATETIME,
            @DefaultDay INT,
            @prevMidnight DATETIME
            
        IF @thisday IS NULL
			SELECT @thisday = DATEPART(dw, GETDATE()) - 1
			
		DECLARE @plusdays INT = @thisday - (DATEPART(dw, GETDATE())-1) + 7
		IF @plusdays > 6
			SELECT @plusdays = @plusdays - 7
		SELECT @prevMidnight = dateadd(dd,0, datediff(dd,0,GETDATE())) + @plusdays
        
        SELECT  @DefaultHour = MeetingTime,
                @DefaultDay = ISNULL(SchedDay, 0)
        FROM    dbo.Organizations
        WHERE   OrganizationId = @orgid
        
        DECLARE @meetingid INT, @meetingdate DATETIME
        
		DECLARE @DefaultTime DATETIME = DATEADD(dd, -DATEDIFF(dd, 0, @DefaultHour), @DefaultHour)
		
		SELECT @meetingid = dbo.GetTodaysMeetingId(@orgid, @thisday)
		
		IF @meetingid IS NOT NULL
			SELECT @meetingdate = MeetingDate FROM dbo.Meetings
			WHERE MeetingId = @meetingid
		ELSE IF @DefaultDay = @thisday
			SELECT @meetingdate = @prevMidnight + @DefaultTime
					
        RETURN @meetingdate
    END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FlagOddTransactions]'
GO
CREATE PROCEDURE [dbo].[FlagOddTransactions]
AS
BEGIN
	SET NOCOUNT ON;

	TRUNCATE TABLE dbo.BadET

	DECLARE @tid INT, @typeid INT, @orgid INT, @pid INT, @tdt DATETIME
	DECLARE @ptid INT = 0, @ptypeid INT = 0, @porgid INT = 0, @ppid INT = 0, @ptdt DATETIME

	DECLARE c CURSOR FOR
	SELECT TransactionId, TransactionTypeId, OrganizationId, PeopleId, TransactionDate
	FROM dbo.EnrollmentTransaction et
	WHERE et.TransactionStatus = 0
	ORDER BY PeopleId, OrganizationId, TransactionDate, TransactionId

	OPEN c
	FETCH NEXT FROM c INTO @tid, @typeid, @orgid, @pid, @tdt
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ptid > 0 AND (@ppid <> @pid OR @porgid <> @orgid)
		BEGIN
			IF (@ppid <> @pid OR @porgid <> @orgid) AND 
					@ptypeid < 3 AND NOT EXISTS(SELECT NULL FROM dbo.OrganizationMembers
							WHERE OrganizationId = @porgid AND PeopleId = @ppid)
				INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
								VALUES ( @ppid, @porgid, @ptid, 10)
			SELECT @ptid = 0, @ptypeid = 0, @porgid = 0, @ppid = 0
		END
		IF @ptid > 0
		BEGIN
			IF @tdt = @ptdt
				INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
								VALUES ( @pid, @orgid, @tid, 15)
			ELSE IF @typeid < 3 AND @ptypeid <= 3
				INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
								VALUES ( @pid, @orgid, @tid, 11)
				
			ELSE IF @typeid > 3 AND @ptypeid > 3
				INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
								VALUES ( @pid, @orgid, @tid, 55)
		END

		SELECT @ptid = @tid, @ptypeid = @typeid, @porgid = @orgid, @ppid = @pid, @ptdt = @tdt

		FETCH NEXT FROM c INTO @tid, @typeid, @orgid, @pid, @tdt
	END
	CLOSE c
	DEALLOCATE c
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LastContact]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[LastContact](@pid INT)
RETURNS DATETIME
AS
BEGIN
	DECLARE @dt DATETIME

	SELECT @dt = MAX(c.ContactDate) FROM dbo.NewContact c
	JOIN dbo.Contactees ce ON c.ContactId = ce.ContactId
	WHERE ce.PeopleId = @pid
	IF @dt IS NULL
		SELECT @dt = DATEADD(DAY,-5000,GETDATE())

	RETURN @dt

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FlagOddTransaction]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FlagOddTransaction] (@pid INT, @orgid INT)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM dbo.BadET WHERE PeopleId = @pid AND OrgId = @orgid

	DECLARE @tid INT, @typeid INT, @tdt DATETIME
	DECLARE @ptypeid INT = 0, @ptdt DATETIME

	DECLARE c CURSOR FOR
	SELECT TransactionId, TransactionTypeId, TransactionDate
	FROM dbo.EnrollmentTransaction et
	WHERE et.TransactionStatus = 0 AND et.PeopleId = @pid AND et.OrganizationId = @orgid
	ORDER BY TransactionDate, TransactionId

	OPEN c
	FETCH NEXT FROM c INTO @tid, @typeid, @tdt
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ptypeid > 0
		BEGIN
			IF @tdt = @ptdt
				INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
								VALUES ( @pid, @orgid, @tid, 15)
			ELSE IF @typeid < 3 AND @ptypeid <= 3
				INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
								VALUES ( @pid, @orgid, @tid, 11)
				
			ELSE IF @typeid > 3 AND @ptypeid > 3
				INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
								VALUES ( @pid, @orgid, @tid, 55)
		END

		SELECT @ptypeid = @typeid, @ptdt = @tdt

		FETCH NEXT FROM c INTO @tid, @typeid, @tdt
	END
	CLOSE c
	DEALLOCATE c

	IF @typeid < 3 AND NOT EXISTS(SELECT NULL FROM dbo.OrganizationMembers
					WHERE OrganizationId = @orgid AND PeopleId = @pid)
		INSERT INTO dbo.BadET (PeopleId, OrgId,	TranId,	Flag) 
						VALUES ( @pid, @orgid, @tid, 10)
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[BadETView]'
GO
CREATE VIEW [dbo].[BadETView]
AS
SELECT     et.id, et.Flag, et2.PeopleId, et2.OrganizationId, et2.TransactionId, et2.OrganizationName, p.Name2, et.Status, et2.TransactionDate, et2.TransactionTypeId, 
                      et2.TransactionStatus
FROM         dbo.People AS p INNER JOIN
                      dbo.EnrollmentTransaction AS et2 ON p.PeopleId = et2.PeopleId LEFT OUTER JOIN
                      dbo.BadET AS et ON et2.TransactionId = et.TranId
WHERE     EXISTS
                          (SELECT     NULL AS Expr1
                            FROM          dbo.BadET
                            WHERE      (OrgId = et2.OrganizationId) AND (PeopleId = et2.PeopleId))

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[VerseInCategory]'
GO
CREATE FUNCTION disc.VerseInCategory
	(
	@vid int,
	@catid int
	)
RETURNS bit
AS
	BEGIN
	RETURN 	Cast(case when EXISTS(
			select * from dbo.VerseCategoryXref 
			where versecategoryid = @catid and verseid = @vid) 
			then 1 else 0 end as bit)
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[BadEtsList]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[BadEtsList](@flag INT) 
RETURNS TABLE 
AS
RETURN 
(
SELECT et.id, et.Flag, et2.PeopleId, et2.OrganizationId, et2.TransactionId, et2.OrganizationName, p.Name2, et.Status, et2.TransactionDate, et2.TransactionTypeId, 
                      et2.TransactionStatus
FROM dbo.People AS p 
INNER JOIN dbo.EnrollmentTransaction AS et2 ON p.PeopleId = et2.PeopleId 
LEFT OUTER JOIN dbo.BadET AS et ON et2.TransactionId = et.TranId
WHERE EXISTS (SELECT NULL FROM dbo.BadET
              WHERE OrgId = et2.OrganizationId AND PeopleId = et2.PeopleId)
AND (@flag = 0 
OR EXISTS(SELECT NULL FROM dbo.BadET
			WHERE OrgId = et2.OrganizationId AND PeopleId = et2.PeopleId
			AND Flag = @flag))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PurgeOrganization]'
GO
CREATE PROCEDURE [dbo].[PurgeOrganization](@oid INT)
AS
BEGIN
	BEGIN TRY 
		BEGIN TRANSACTION 
		DECLARE @fid INT, @pic INT
		DELETE FROM dbo.OrganizationMembers WHERE OrganizationId = @oid
		DELETE FROM dbo.BadET WHERE OrgId = @oid
		DELETE FROM dbo.EnrollmentTransaction WHERE OrganizationId = @oid
		DELETE FROM dbo.Attend WHERE OrganizationId = @oid
		DELETE FROM dbo.DivOrg WHERE OrgId = @oid
		DELETE FROM dbo.Meetings WHERE OrganizationId = @oid
		DELETE FROM dbo.Organizations WHERE OrganizationId = @oid
		COMMIT
	END TRY 
	BEGIN CATCH 
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH 
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PersonAttendCountOrg]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[PersonAttendCountOrg]
(@pid int, @oid int)
RETURNS int
AS
	BEGIN
	RETURN (SELECT COUNT(*)
	        FROM   dbo.Attend a INNER JOIN
	                   dbo.Meetings m ON a.MeetingId = m.MeetingId
	        WHERE (m.OrganizationId = @oid) AND (a.PeopleId = @pid)
              AND a.AttendanceFlag = 1)
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LastAttended]'
GO
CREATE FUNCTION [dbo].[LastAttended] (@orgid INT, @pid INT)
RETURNS DATETIME
AS
	BEGIN
	DECLARE @dt DATETIME
		SELECT @dt = MAX(m.MeetingDate) FROM dbo.Attend a
		JOIN dbo.Meetings m
		ON a.MeetingId = m.MeetingId
		WHERE a.AttendanceFlag = 1 AND m.OrganizationId = @orgid AND a.PeopleId = @pid
	RETURN @dt
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LastAttend]'
GO
CREATE FUNCTION [dbo].[LastAttend] (@orgid INT, @pid INT)
RETURNS DATETIME
AS
	BEGIN
	DECLARE @dt DATETIME
		SELECT @dt = MAX(m.MeetingDate) FROM dbo.Attend a
		JOIN dbo.Meetings m
		ON a.MeetingId = m.MeetingId
		WHERE a.AttendanceFlag = 1 AND m.OrganizationId = @orgid AND a.PeopleId = @pid
	RETURN @dt
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DaysSinceAttend]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[DaysSinceAttend](@pid INT, @oid INT)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @days int

	-- Add the T-SQL statements to compute the return value here
	SELECT @days = MAX(DATEDIFF(D,a.MeetingDate,GETDATE())) FROM dbo.Attend a
	JOIN dbo.Meetings m
	ON a.MeetingId = m.MeetingId
	WHERE a.PeopleId = @pid AND m.OrganizationId = @oid
	

	-- Return the result of the function
	RETURN @days

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AddAbsents]'
GO
CREATE PROCEDURE [dbo].[AddAbsents](@meetid INT, @userid INT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @oid INT, @meetdate DATETIME, @attendType INT, @offsiteType INT, @groupflag BIT, @dt DATETIME
	SELECT @oid = OrganizationId, @meetdate = MeetingDate, 
		@attendType = 30, @offsiteType = 80, 
		@groupflag = GroupMeetingFlag, @dt = GETDATE()
	FROM dbo.Meetings m
	WHERE MeetingId = @meetid

	IF @groupflag <> 0
		RETURN

BEGIN TRY
	BEGIN TRANSACTION
	INSERT dbo.Attend 
	(
		MeetingId,
		OrganizationId,
		MeetingDate,
		CreatedBy,
		CreatedDate,
		OtherOrgId,
		PeopleId,
		MemberTypeId,
		AttendanceFlag,
		AttendanceTypeId
	)
	SELECT
		@meetid, 
		@oid, 
		@meetdate, 
		@userid,
		@dt, 
		NULL, 
		o.PeopleId, 
		o.MemberTypeId,
		0,
		@attendType
	FROM dbo.OrganizationMembers o
	WHERE o.OrganizationId = @oid
		AND NOT EXISTS
		(
			SELECT NULL FROM dbo.Attend a 
			WHERE a.PeopleId = o.PeopleId AND a.MeetingId = @meetid
		)

	UPDATE dbo.Attend
	SET 
		AttendanceFlag = NULL, 
		AttendanceTypeId = @offsiteType
	FROM dbo.OrganizationMembers o
	JOIN dbo.Attend a ON o.OrganizationId = a.OrganizationId
	WHERE a.MeetingId = @meetid AND a.PeopleId = o.PeopleId
	AND EXISTS
	(
		SELECT NULL FROM dbo.OrganizationMembers om2
		JOIN dbo.Organizations o2 ON om2.OrganizationId = o2.OrganizationId
		WHERE o2.AttendClassificationId = 2 AND om2.PeopleId = o.PeopleId
		AND o2.FirstMeetingDate <= @meetdate AND @meetdate <= DATEADD(dd, 1, o2.LastMeetingDate)
	) 
	COMMIT
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
	DECLARE @em VARCHAR(4000), @es INT
	SELECT @em=ERROR_MESSAGE(), @es=ERROR_SEVERITY()
	RAISERROR(@em, @es, 1)
END CATCH


END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VerseSummary]'
GO

CREATE VIEW dbo.VerseSummary
AS
SELECT        TOP (100) PERCENT v.id, v.VerseRef + ' (' + v.Version + ')' AS Reference, SUBSTRING(v.VerseText, 1, 90) + '...' AS ShortText, COUNT(c.VerseCategoryId) 
                         AS CategoryCount, v.Book, v.Chapter, v.VerseNum
FROM            disc.Verse AS v LEFT OUTER JOIN
                         disc.VerseCategoryXref AS c ON v.id = c.VerseId
GROUP BY v.id, v.VerseRef, v.Version, v.VerseText, v.Book, v.Chapter, v.VerseNum


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[VerseSummaryForCategory]'
GO
CREATE PROCEDURE disc.VerseSummaryForCategory 
	@cat INT,
	@startRow INT,
	@NumRows INT
AS

BEGIN

select count(*) from dbo.VerseSummary;

	With Verses as (
		SELECT ROW_NUMBER() OVER (ORDER BY book, chapter, versenum) as Row, 
			id, Reference, ShortText, CategoryCount, Book, Chapter, VerseNum,
			Cast(case when EXISTS(
			select * from dbo.VerseCategoryXref 
			where versecategoryid = @cat and verseid = vs.id) 
			then 1 else 0 end as bit) as InCategory
		FROM dbo.VerseSummary vs
	)
	
	Select id, Reference, ShortText, CategoryCount, Book, Chapter, VerseNum, InCategory
	FROM Verses
	WHERE Row between 
	@startRow and @startRow+@NumRows-1
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GetScheduleTime]'
GO
CREATE FUNCTION [dbo].[GetScheduleTime]
(
	@day INT,
	@time DATETIME
)
RETURNS DATETIME
AS 
    BEGIN
        DECLARE @Ret DATETIME
        DECLARE @Timeonly DATETIME = DATEADD(dd, -DATEDIFF(dd, 0, @time), @time)
		 
		DECLARE @MinDate DATETIME = CONVERT(DATETIME, 0)
		DECLARE @MinDayOfWeek INT = DATEPART(dw, @MinDate) - 1
		SELECT @day = ISNULL(@day, 0)
		IF (@MinDayOfWeek > @day)
			SELECT @day = @day + 7
		SELECT @Ret = CONVERT(DATETIME, @day - @MinDayOfWeek) + @Timeonly
		
        RETURN @Ret
    END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ScheduleId]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ScheduleId](@day INT, @time datetime)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @id INT
	
	-- Add the T-SQL statements to compute the return value here
	SELECT @id = (ISNULL(@day, 0) + 1) * 10000 + DATEPART(hour, @time) * 100 + DATEPART(mi, @time)

	-- Return the result of the function
	RETURN @id

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[BlogCategory]'
GO
CREATE TABLE [disc].[BlogCategory]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Category] on [disc].[BlogCategory]'
GO
ALTER TABLE [disc].[BlogCategory] ADD CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[BlogCategoriesView]'
GO

CREATE VIEW dbo.BlogCategoriesView
AS
SELECT        c.Name AS Category, COUNT(*) AS n
FROM            disc.BlogCategoryXref x
JOIN disc.BlogCategory c ON x.CatId = c.Id
GROUP BY c.Name


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[VerseSummaryForCategory2]'
GO
CREATE FUNCTION disc.VerseSummaryForCategory2
	(
	@catid int
	)
RETURNS TABLE
AS
	RETURN SELECT *, disc.VerseInCategory(id, @catid) As InCategory FROM dbo.VerseSummary

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[EntryPoint]'
GO
CREATE TABLE [lookup].[EntryPoint]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EntryPoint] on [lookup].[EntryPoint]'
GO
ALTER TABLE [lookup].[EntryPoint] ADD CONSTRAINT [PK_EntryPoint] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EntryPointId]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[EntryPointId] ( @pid INT )
RETURNS INT 
AS
BEGIN
	DECLARE @ret INT 

	SELECT TOP 1 @ret = e.Id FROM 
	dbo.Attend a 
	JOIN dbo.Meetings m ON a.MeetingId = m.MeetingId
	JOIN dbo.Organizations o ON m.OrganizationId = o.OrganizationId
	LEFT OUTER JOIN lookup.EntryPoint e ON o.EntryPointId = e.Id
	WHERE a.PeopleId = @pid
	ORDER BY a.MeetingDate
	
	RETURN @ret
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Setting]'
GO
CREATE TABLE [dbo].[Setting]
(
[Id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Setting] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Setting] on [dbo].[Setting]'
GO
ALTER TABLE [dbo].[Setting] ADD CONSTRAINT [PK_Setting] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[MemberStatus]'
GO
CREATE TABLE [lookup].[MemberStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MemberStatus_1] on [lookup].[MemberStatus]'
GO
ALTER TABLE [lookup].[MemberStatus] ADD CONSTRAINT [PK_MemberStatus_1] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UserName]'
GO
CREATE FUNCTION [dbo].[UserName] (@pid int)
RETURNS varchar(100)
AS
	BEGIN
	declare @name varchar(100)
	
SELECT  @name = [LastName]+', '+(case when [Nickname]<>'' then [nickname] else [FirstName] end)
FROM         dbo.People
WHERE     PeopleId = @pid

	return @name
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateSchoolGrade]'
GO
CREATE PROCEDURE [dbo].[UpdateSchoolGrade] @pid INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-----------------------------------------------------------------
	
	UPDATE dbo.People SET Grade = dbo.SchoolGrade(@pid) WHERE PeopleId = @pid

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Churches]'
GO

CREATE VIEW [dbo].Churches
AS
SELECT c FROM (
SELECT OtherNewChurch c FROM dbo.People
UNION 
SELECT OtherPreviousChurch c FROM dbo.People
) AS t
GROUP BY c


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[TemporaryToken]'
GO
CREATE TABLE [disc].[TemporaryToken]
(
[id] [uniqueidentifier] NOT NULL,
[expired] [bit] NOT NULL CONSTRAINT [DF_TemporaryTokens_expired] DEFAULT ((0)),
[CreatedOn] [datetime] NOT NULL,
[CreatedBy] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TemporaryTokens] on [disc].[TemporaryToken]'
GO
ALTER TABLE [disc].[TemporaryToken] ADD CONSTRAINT [PK_TemporaryTokens] PRIMARY KEY CLUSTERED ([id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[PodCast]'
GO
CREATE TABLE [disc].[PodCast]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[S3Name] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pubDate] [datetime] NULL,
[length] [int] NULL,
[postId] [int] NULL,
[UserId] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PodCast] on [disc].[PodCast]'
GO
ALTER TABLE [disc].[PodCast] ADD CONSTRAINT [PK_PodCast] PRIMARY KEY CLUSTERED ([id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[ParaContent]'
GO
CREATE TABLE [disc].[ParaContent]
(
[ContentID] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContentName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Body] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL CONSTRAINT [DF_Content_CreatedOn] DEFAULT (getdate()),
[CreatedById] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Content] on [disc].[ParaContent]'
GO
ALTER TABLE [disc].[ParaContent] ADD CONSTRAINT [PK_Content] PRIMARY KEY CLUSTERED ([ContentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[PageContent]'
GO
CREATE TABLE [disc].[PageContent]
(
[PageID] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Body] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PageUrl] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_Page_createdOn] DEFAULT (getdate()),
[ModifiedOn] [datetime] NULL CONSTRAINT [DF_Page_modifiedOn] DEFAULT (getdate()),
[Deleted] [bit] NOT NULL CONSTRAINT [DF_CMS_Page_Deleted] DEFAULT ((0)),
[CreatedById] [int] NULL,
[ModifiedById] [int] NULL,
[cUserid] [int] NULL,
[cUserid2] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CMS_Page] on [disc].[PageContent]'
GO
ALTER TABLE [disc].[PageContent] ADD CONSTRAINT [PK_CMS_Page] PRIMARY KEY CLUSTERED ([PageID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[ForumUserRead]'
GO
CREATE TABLE [disc].[ForumUserRead]
(
[ForumEntryId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[CreatedOn] [datetime] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ForumUserRead] on [disc].[ForumUserRead]'
GO
ALTER TABLE [disc].[ForumUserRead] ADD CONSTRAINT [PK_ForumUserRead] PRIMARY KEY CLUSTERED ([ForumEntryId], [UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[ForumNotify]'
GO
CREATE TABLE [disc].[ForumNotify]
(
[ThreadId] [int] NOT NULL,
[UserId] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ForumNotify] on [disc].[ForumNotify]'
GO
ALTER TABLE [disc].[ForumNotify] ADD CONSTRAINT [PK_ForumNotify] PRIMARY KEY CLUSTERED ([ThreadId], [UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[Forum]'
GO
CREATE TABLE [disc].[Forum]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[GroupId] [int] NULL,
[CreatedBy] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Forum] on [disc].[Forum]'
GO
ALTER TABLE [disc].[Forum] ADD CONSTRAINT [PK_Forum] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[BlogNotify]'
GO
CREATE TABLE [disc].[BlogNotify]
(
[BlogId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BlogNotify] on [disc].[BlogNotify]'
GO
ALTER TABLE [disc].[BlogNotify] ADD CONSTRAINT [PK_BlogNotify] PRIMARY KEY CLUSTERED ([BlogId], [UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[BlogComment]'
GO
CREATE TABLE [disc].[BlogComment]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BlogPostId] [int] NULL,
[DatePosted] [datetime] NOT NULL,
[PosterId] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BlogComment] on [disc].[BlogComment]'
GO
ALTER TABLE [disc].[BlogComment] ADD CONSTRAINT [PK_BlogComment] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[Blog]'
GO
CREATE TABLE [disc].[Blog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupId] [int] NULL,
[NotOnMenu] [bit] NOT NULL CONSTRAINT [DF_Blog_NotOnMenu] DEFAULT ((0)),
[OwnerId] [int] NULL,
[PrivacyLevel] [int] NOT NULL CONSTRAINT [DF__Blog__PrivacyLev__73501C2F] DEFAULT ((1)),
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Blog] on [disc].[Blog]'
GO
ALTER TABLE [disc].[Blog] ADD CONSTRAINT [PK_Blog] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Blog] on [disc].[Blog]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Blog] ON [disc].[Blog] ([Name])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PodcastSummary]'
GO

CREATE VIEW dbo.PodcastSummary
AS
SELECT     disc.PodCast.UserId, MAX(disc.PodCast.pubDate) AS lastPosted, COUNT(disc.PodCast.id) AS Count, dbo.Users.Username
FROM         disc.PodCast INNER JOIN
                      dbo.Users ON disc.PodCast.UserId = dbo.Users.UserId
GROUP BY disc.PodCast.UserId, dbo.Users.Username


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VerseCategoriesView]'
GO

CREATE VIEW dbo.VerseCategoriesView
AS
SELECT     TOP (100) PERCENT c.id, c.Name + CASE WHEN (u.Username = 'admin') THEN ' - Master' ELSE '' END + ' (' + CAST(COUNT(v.VerseId) AS varchar) 
                      + ')' AS DisplayName, COUNT(v.VerseId) AS VerseCount, c.Name, u.Username
FROM         disc.VerseCategory AS c INNER JOIN
                      dbo.Users AS u ON c.CreatedBy = u.UserId LEFT OUTER JOIN
                      disc.VerseCategoryXref AS v ON c.id = v.VerseCategoryId
GROUP BY c.id, c.Name, c.CreatedBy, u.Username


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[TaggedPeople]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[TaggedPeople](@tagid INT) 
RETURNS @t TABLE ( PeopleId INT)
AS
BEGIN
	INSERT INTO @t (PeopleId)
	SELECT p.PeopleId FROM dbo.People p
	WHERE EXISTS(
    SELECT NULL
    FROM dbo.TagPerson t
    WHERE (t.Id = @tagid) AND (t.PeopleId = p.PeopleId))
    RETURN
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ContributionFund]'
GO
CREATE TABLE [dbo].[ContributionFund]
(
[FundId] [int] NOT NULL IDENTITY(1, 1),
[ChurchId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[RecordStatus] [bit] NOT NULL,
[FundName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FundDescription] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FundStatusId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[FundPledgeFlag] [bit] NOT NULL,
[FundTarget] [numeric] (11, 2) NULL,
[FundOpenDate] [datetime] NOT NULL,
[FundCloseDate] [datetime] NULL,
[FundReopenDate] [datetime] NULL,
[FundDropDate] [datetime] NULL,
[FundAccountCode] [int] NULL,
[FundIncomeDept] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FundIncomeAccount] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FundIncomeFund] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FundCashDept] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FundCashAccount] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FundCashFund] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [FUND_PK] on [dbo].[ContributionFund]'
GO
ALTER TABLE [dbo].[ContributionFund] ADD CONSTRAINT [FUND_PK] PRIMARY KEY NONCLUSTERED ([FundId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [FUND_CHURCH_FK_IX] on [dbo].[ContributionFund]'
GO
CREATE NONCLUSTERED INDEX [FUND_CHURCH_FK_IX] ON [dbo].[ContributionFund] ([ChurchId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [FUND_NAME_IX] on [dbo].[ContributionFund]'
GO
CREATE NONCLUSTERED INDEX [FUND_NAME_IX] ON [dbo].[ContributionFund] ([FundName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[ContributionType]'
GO
CREATE TABLE [lookup].[ContributionType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ContributionType] on [lookup].[ContributionType]'
GO
ALTER TABLE [lookup].[ContributionType] ADD CONSTRAINT [PK_ContributionType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[ContributionStatus]'
GO
CREATE TABLE [lookup].[ContributionStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ContributionStatus] on [lookup].[ContributionStatus]'
GO
ALTER TABLE [lookup].[ContributionStatus] ADD CONSTRAINT [PK_ContributionStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UserList]'
GO


CREATE VIEW [dbo].[UserList]
AS
SELECT     Username, UserId, p.Name, p.Name2, IsApproved, MustChangePassword, IsLockedOut, p.EmailAddress,
                          (SELECT     MAX(v.VisitTime) AS Expr1
                            FROM          disc.PageVisit AS v
                            WHERE      (UserId = u.UserId)) AS LastVisit, u.PeopleId
FROM         dbo.Users u JOIN dbo.People p ON u.PeopleId = p.PeopleId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateETAttendPct]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateETAttendPct] (@tid INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-----------------------------------------------------------------
    DECLARE @yearago DATETIME
    DECLARE @lastmeet DATETIME 
    DECLARE @tct INT 
    DECLARE @act INT
    DECLARE @pct REAL
    DECLARE @fromdt DATETIME
    DECLARE @pid INT, @orgid INT
		
	SELECT @fromdt = TransactionDate, @pid = PeopleId, @orgid = OrganizationId
	FROM dbo.EnrollmentTransaction WHERE @tid = TransactionId
		
    SELECT @lastmeet = MAX(MeetingDate) FROM dbo.Meetings
    WHERE OrganizationId = @orgid AND MeetingDate <= @fromdt
    
    SELECT @yearago = DATEADD(year,-1,@lastmeet)
    
	SELECT @tct = COUNT(*) FROM dbo.Attend
     WHERE PeopleId = @pid
       AND OrganizationId = @orgid
       AND EffAttendFlag IS NOT NULL
       AND MeetingDate >= @yearago
       AND MeetingDate <= @fromdt
       
    SELECT @act = COUNT(*) FROM dbo.Attend
     WHERE PeopleId = @pid
       AND OrganizationId = @orgid
       AND EffAttendFlag = 1
       AND MeetingDate >= @yearago
       AND MeetingDate <= @fromdt
      
       
	if @tct = 0
			select @pct = 0
		else
			SELECT @pct = @act * 100.0 / @tct
			
	--------------------------------------------	
	
		
	UPDATE dbo.EnrollmentTransaction SET
		AttendancePercentage = @pct
	WHERE TransactionId = @tid

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateAllETAttendPct]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAllETAttendPct]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		DECLARE cur CURSOR FOR SELECT TransactionId FROM dbo.EnrollmentTransaction WHERE TransactionTypeId > 3
		OPEN cur
		DECLARE @tid INT, @n INT
		SET @n = 0
		FETCH NEXT FROM cur INTO @tid
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE dbo.UpdateETAttendPct @tid
			SET @n = @n + 1
			IF (@n % 1000) = 0
				RAISERROR ('%d', 0, 1, @n) WITH NOWAIT
			FETCH NEXT FROM cur INTO @tid
		END
		CLOSE cur
		DEALLOCATE cur
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AttendMeetingInfo]'
GO
CREATE PROCEDURE [dbo].[AttendMeetingInfo]
( @MeetingId INT, @PeopleId INT)
AS
BEGIN
	DECLARE @orgid INT
			,@meetingdate DATETIME
			,@meetdt DATE
			,@tm TIME
			,@dt DATETIME
			,@regularhour BIT
			,@membertypeid INT
			,@schedid INT
			,@attendedelsewhere INT
			,@allowoverlap BIT

	SELECT @regularhour = CASE WHEN EXISTS(
		SELECT null
			FROM dbo.Meetings m
			JOIN dbo.Organizations o ON m.OrganizationId = o.OrganizationId
			WHERE m.MeetingId = @MeetingId
				AND CONVERT(TIME, m.MeetingDate) = CONVERT(TIME, o.MeetingTime)
				AND SchedDay = (DATEPART(weekday, m.MeetingDate) - 1))
		THEN 1 ELSE 0 END

	SELECT
		@orgid = m.OrganizationId,
		@schedid = o.ScheduleId,
		@dt = DATEADD(DAY, o.RollSheetVisitorWks * -7, m.MeetingDate),
		@meetingdate = m.MeetingDate,
		@allowoverlap = o.AllowAttendOverlap,
		@membertypeid = (SELECT om.MemberTypeId
					FROM dbo.OrganizationMembers om
					WHERE om.OrganizationId = o.OrganizationId
					AND om.PeopleId = @PeopleId)

	FROM dbo.Meetings m
	JOIN dbo.Organizations o ON m.OrganizationId = o.OrganizationId
	WHERE m.MeetingId = @MeetingId

	DECLARE @name VARCHAR(50), @bfclassid INT

	SELECT @name = p.[Name], @bfclassid = BibleFellowshipClassId
	FROM dbo.People p
	WHERE PeopleId = @PeopleId

	SELECT
		@meetdt = CONVERT(DATE, m.MeetingDate),
		@tm = CONVERT(TIME, m.MeetingDate)
	FROM dbo.Meetings m
	WHERE m.MeetingId = @MeetingId
		
	IF @dt IS NULL
		SELECT @dt = DATEADD(DAY, 3 * -7, @meetdt)

	DECLARE	@isrecentvisitor BIT
			,@isoffsite BIT
			,@otherattend INT
			,@bfcattend INT
			,@bfcid INT
			--,@isinservice BIT
			--,@issamehour bit

	SELECT @isrecentvisitor = CASE WHEN exists(
				SELECT NULL FROM Attend
				WHERE PeopleId = @PeopleId
				AND AttendanceFlag = 1
				AND MeetingDate >= @dt
				AND MeetingDate <= @meetdt
				AND OrganizationId = @orgid
				AND AttendanceTypeId IN (50, 60)) -- new and recent
			THEN 1 ELSE 0 END

	--SELECT @isinservice = CASE WHEN exists(
	--			SELECT NULL FROM dbo.OrganizationMembers om
	--			JOIN dbo.Organizations o ON om.OrganizationId = o.OrganizationId
	--			WHERE om.PeopleId = @PeopleId
	--			AND om.OrganizationId <> @orgid
	--			AND om.MemberTypeId = 500 -- inservice member
	--			AND o.ScheduleId = @schedid)
	--		THEN 1 ELSE 0 END
			
	SELECT @isoffsite = CASE WHEN exists(
				SELECT NULL FROM dbo.OrganizationMembers om
				JOIN dbo.Organizations o ON om.OrganizationId = o.OrganizationId
				WHERE om.PeopleId = @PeopleId
				AND om.OrganizationId <> @orgid
				AND o.AttendClassificationId = 2 -- offsite
				AND o.FirstMeetingDate <= @meetdt
				AND @meetdt <= o.LastMeetingDate)
			THEN 1 ELSE 0 END

	SELECT TOP 1 @otherattend = ae.AttendId
	FROM Attend ae
	JOIN dbo.Organizations o ON ae.OrganizationId = o.OrganizationId
	WHERE ae.PeopleId = @PeopleId
	AND ae.MeetingDate = @meetingdate
	AND ae.OrganizationId <> @orgid
	
	-- BFC class membership
	SELECT @bfcid = om.OrganizationId FROM dbo.OrganizationMembers om
	JOIN dbo.Organizations o ON om.OrganizationId = o.OrganizationId
	WHERE om.PeopleId = @PeopleId 
	AND om.OrganizationId <> @orgid
	AND o.ScheduleId = @schedid AND @regularhour = 1
	AND (om.OrganizationId = @bfclassid OR om.MemberTypeId = 500) -- regular or InSvc

	-- BFC Attendance at same time
	SELECT @bfcattend = a.AttendId FROM dbo.Attend a
	JOIN dbo.OrganizationMembers om ON a.OrganizationId = om.OrganizationId AND a.PeopleId = om.PeopleId
	JOIN dbo.Organizations o ON om.OrganizationId = o.OrganizationId
	WHERE o.ScheduleId = @schedid AND @regularhour = 1
	AND a.MeetingDate = @meetingdate
	AND om.OrganizationId <> @orgid
	AND om.OrganizationId = @bfcid
	AND a.PeopleId = @PeopleId

	-- attended elsewhere at same time
	SELECT TOP 1 @attendedelsewhere = ae.AttendId
	FROM Attend ae
	JOIN dbo.Organizations o ON ae.OrganizationId = o.OrganizationId
	WHERE ae.PeopleId = @PeopleId
	AND ae.AttendanceFlag = 1
	AND ae.MeetingDate = @meetingdate
	AND ae.OrganizationId NOT IN (@orgid, @bfcid)
	AND o.AllowAttendOverlap <> 1
	AND @allowoverlap <> 1

-- The returned records:
			
	SELECT
		 @attendedelsewhere AttendedElsewhere
		,@membertypeid MemberTypeId
		,@isoffsite IsOffSite
		,@isrecentvisitor IsRecentVisitor
		,@name Name
		,@bfclassid BFClassId
	
	-- Attend if any
	SELECT * FROM dbo.Attend
	WHERE MeetingId = @MeetingId AND PeopleId = @PeopleId
		
	-- the meeting
	SELECT * FROM dbo.Meetings
	WHERE MeetingId = @MeetingId
	
	-- Related VIP Attendance
	SELECT v.*
	FROM Attend v
	JOIN dbo.OrganizationMembers om ON v.OrganizationId = om.OrganizationId AND v.PeopleId = om.PeopleId
	WHERE v.PeopleId = @PeopleId
	AND v.MeetingDate = @meetingdate
	AND v.OrganizationId <> @orgid
	AND om.MemberTypeId = 700 -- vip
	AND @orgid = @bfclassid
	
	-- BFC class membership 
	SELECT * FROM dbo.OrganizationMembers
	WHERE OrganizationId = @bfcid
	AND PeopleId = @PeopleId
	
	-- BFC Attendance at same time
	SELECT * FROM dbo.Attend
	WHERE AttendId = @bfcattend

	-- BFC Meeting at same time
	SELECT m.* FROM dbo.Meetings m
	JOIN dbo.Attend a ON m.MeetingId = a.MeetingId
	WHERE AttendId = @bfcattend
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[ForumEntry]'
GO
CREATE TABLE [disc].[ForumEntry]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entry] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForumId] [int] NULL,
[ReplyToId] [int] NULL,
[ThreadId] [int] NULL,
[DisplayOrder] [int] NULL,
[DisplayDepth] [int] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [int] NULL,
[cUserid] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ForumEntry] on [disc].[ForumEntry]'
GO
ALTER TABLE [disc].[ForumEntry] ADD CONSTRAINT [PK_ForumEntry] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[GetToken]'
GO
CREATE PROCEDURE disc.GetToken(@guid uniqueidentifier) 
AS
	declare @expired bit
	set @expired = (select expired from dbo.TemporaryToken where @guid = id)
	update dbo.TemporaryToken set expired = 1 where id = @guid
	select CreatedOn, @expired as expired, CreatedBy from dbo.TemporaryToken where id = @guid
	RETURN

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[UploadAuthenticationXref]'
GO
CREATE TABLE [disc].[UploadAuthenticationXref]
(
[postinguser] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[postsfor] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UploadAuthenticationXref] on [disc].[UploadAuthenticationXref]'
GO
ALTER TABLE [disc].[UploadAuthenticationXref] ADD CONSTRAINT [PK_UploadAuthenticationXref] PRIMARY KEY CLUSTERED ([postinguser], [postsfor])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[GetUsersToUploadFor]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE disc.GetUsersToUploadFor (@uploader varchar(20))
AS
BEGIN

select postsfor from dbo.UploadAuthenticationXref x 
where postinguser = @uploader

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[MemberType]'
GO
CREATE TABLE [lookup].[MemberType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendanceTypeId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MemberType] on [lookup].[MemberType]'
GO
ALTER TABLE [lookup].[MemberType] ADD CONSTRAINT [PK_MemberType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[MemberDesc]'
GO
CREATE FUNCTION [dbo].[MemberDesc](@id int) 
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @ret VARCHAR(100)
	SELECT @ret =  Description FROM lookup.MemberType WHERE id = @id
	RETURN @ret
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DaysSinceContact]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[DaysSinceContact](@pid INT)
RETURNS int
AS
BEGIN
	DECLARE @days int

	SELECT @days = MIN(DATEDIFF(D,c.ContactDate,GETDATE())) FROM dbo.NewContact c
	JOIN dbo.Contactees ce ON c.ContactId = ce.ContactId
	WHERE ce.PeopleId = @pid

	RETURN @days

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[MembersAsOf]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[MembersAsOf]
(	
	@from DATETIME,
	@to DATETIME,
	@progid INT,
	@divid INT,
	@orgid INT
)
RETURNS @t TABLE ( PeopleId INT )
AS
BEGIN
	INSERT INTO @t (PeopleId) SELECT p.PeopleId FROM dbo.People p
	WHERE
	EXISTS (
		SELECT NULL FROM dbo.EnrollmentTransaction et
		WHERE et.PeopleId = p.PeopleId
		AND et.TransactionTypeId <= 3
		AND @from <= COALESCE(et.NextTranChangeDate, GETDATE())
		AND et.TransactionDate <= @to
		AND (et.OrganizationId = @orgid OR @orgid = 0)
		AND (EXISTS(SELECT NULL FROM DivOrg d1
				WHERE d1.OrgId = et.OrganizationId
				AND d1.DivId = @divid) OR @divid = 0)
		AND (EXISTS(SELECT NULL FROM DivOrg d2
				WHERE d2.OrgId = et.OrganizationId
				AND EXISTS(SELECT NULL FROM Division d
						WHERE d2.DivId = d.Id
						AND d.ProgId = @progid)) OR @progid = 0)
		)
	RETURN
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[OrganizationMemberCount2]'
GO

CREATE FUNCTION [dbo].[OrganizationMemberCount2](@oid int) 
RETURNS int
AS
BEGIN
	DECLARE @c int
	SELECT @c = count(*) from dbo.OrganizationMembers 
	where OrganizationId = @oid AND (Pending IS NULL OR Pending = 0)
	RETURN @c
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CsvTable]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[CsvTable](@csv VARCHAR(4000))
RETURNS 
@tbl TABLE (id int NOT NULL)
AS
BEGIN
	declare @pos int
	declare @val varchar(1000)

	set @csv = @csv + ','

WHILE PATINDEX('%,%',@csv) > 0
BEGIN

	SELECT @pos = PATINDEX('%,%', @csv)
	SELECT @val = left(@csv, @pos - 1)

	INSERT INTO @tbl SELECT @val
	SELECT @csv = STUFF(@csv, 1, @pos, '')
END

	RETURN 
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PeopleExtra]'
GO
CREATE TABLE [dbo].[PeopleExtra]
(
[PeopleId] [int] NOT NULL,
[TransactionTime] [datetime] NOT NULL CONSTRAINT [DF_PeopleExtra_TransactionTime] DEFAULT (((1)/(1))/(1900)),
[Field] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StrValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateValue] [datetime] NULL,
[Data] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PeopleExtra] on [dbo].[PeopleExtra]'
GO
ALTER TABLE [dbo].[PeopleExtra] ADD CONSTRAINT [PK_PeopleExtra] PRIMARY KEY CLUSTERED ([PeopleId], [TransactionTime], [Field])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_PeopleExtra_2] on [dbo].[PeopleExtra]'
GO
CREATE NONCLUSTERED INDEX [IX_PeopleExtra_2] ON [dbo].[PeopleExtra] ([Field], [DateValue])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_PeopleExtra] on [dbo].[PeopleExtra]'
GO
CREATE NONCLUSTERED INDEX [IX_PeopleExtra] ON [dbo].[PeopleExtra] ([Field], [StrValue])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GeoCodes]'
GO
CREATE TABLE [dbo].[GeoCodes]
(
[Address] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Latitude] [float] NOT NULL CONSTRAINT [DF_GeoCodes_Latitude] DEFAULT ((0)),
[Longitude] [float] NOT NULL CONSTRAINT [DF_GeoCodes_Longitude] DEFAULT ((0))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_GeoCodes_1] on [dbo].[GeoCodes]'
GO
ALTER TABLE [dbo].[GeoCodes] ADD CONSTRAINT [PK_GeoCodes_1] PRIMARY KEY CLUSTERED ([Address])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[ResidentCode]'
GO
CREATE TABLE [lookup].[ResidentCode]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ResidentCode] on [lookup].[ResidentCode]'
GO
ALTER TABLE [lookup].[ResidentCode] ADD CONSTRAINT [PK_ResidentCode] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[EnvelopeOption]'
GO
CREATE TABLE [lookup].[EnvelopeOption]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EnvelopeOption] on [lookup].[EnvelopeOption]'
GO
ALTER TABLE [lookup].[EnvelopeOption] ADD CONSTRAINT [PK_EnvelopeOption] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[Group]'
GO
CREATE TABLE [disc].[Group]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContentId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Group] on [disc].[Group]'
GO
ALTER TABLE [disc].[Group] ADD CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[BundleHeaderTypes]'
GO
CREATE TABLE [lookup].[BundleHeaderTypes]
(
[Id] [int] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BundleHeaderTypes] on [lookup].[BundleHeaderTypes]'
GO
ALTER TABLE [lookup].[BundleHeaderTypes] ADD CONSTRAINT [PK_BundleHeaderTypes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[BundleStatusTypes]'
GO
CREATE TABLE [lookup].[BundleStatusTypes]
(
[Id] [int] NOT NULL,
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BundleStatusTypes] on [lookup].[BundleStatusTypes]'
GO
ALTER TABLE [lookup].[BundleStatusTypes] ADD CONSTRAINT [PK_BundleStatusTypes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[NewContactType]'
GO
CREATE TABLE [lookup].[NewContactType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ContactTypes] on [lookup].[NewContactType]'
GO
ALTER TABLE [lookup].[NewContactType] ADD CONSTRAINT [PK_ContactTypes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Ministries]'
GO
CREATE TABLE [dbo].[Ministries]
(
[MinistryId] [int] NOT NULL IDENTITY(1, 1),
[MinistryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[RecordStatus] [bit] NULL,
[DepartmentId] [int] NULL,
[MinistryDescription] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinistryContactId] [int] NULL,
[ChurchId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MINISTRIES_TBL] on [dbo].[Ministries]'
GO
ALTER TABLE [dbo].[Ministries] ADD CONSTRAINT [PK_MINISTRIES_TBL] PRIMARY KEY CLUSTERED ([MinistryId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [MINISTRIES_PK_IX] on [dbo].[Ministries]'
GO
CREATE NONCLUSTERED INDEX [MINISTRIES_PK_IX] ON [dbo].[Ministries] ([MinistryId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EmailOptOut]'
GO
CREATE TABLE [dbo].[EmailOptOut]
(
[ToPeopleId] [int] NOT NULL,
[FromEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EmailOptOut_1] on [dbo].[EmailOptOut]'
GO
ALTER TABLE [dbo].[EmailOptOut] ADD CONSTRAINT [PK_EmailOptOut_1] PRIMARY KEY CLUSTERED ([ToPeopleId], [FromEmail])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[GroupRoles]'
GO
CREATE TABLE [disc].[GroupRoles]
(
[RoleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RoleId] [int] NOT NULL IDENTITY(1, 1),
[GroupId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_GroupRoles] on [disc].[GroupRoles]'
GO
ALTER TABLE [disc].[GroupRoles] ADD CONSTRAINT [PK_GroupRoles] PRIMARY KEY CLUSTERED ([RoleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[Invitation]'
GO
CREATE TABLE [disc].[Invitation]
(
[password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[expires] [datetime] NULL,
[GroupId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Invitation] on [disc].[Invitation]'
GO
ALTER TABLE [disc].[Invitation] ADD CONSTRAINT [PK_Invitation] PRIMARY KEY CLUSTERED ([password], [GroupId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[NewContactReason]'
GO
CREATE TABLE [lookup].[NewContactReason]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ContactReasons] on [lookup].[NewContactReason]'
GO
ALTER TABLE [lookup].[NewContactReason] ADD CONSTRAINT [PK_ContactReasons] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[AttendTrackLevel]'
GO
CREATE TABLE [lookup].[AttendTrackLevel]
(
[Id] [int] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_AttendTrackLevel] on [lookup].[AttendTrackLevel]'
GO
ALTER TABLE [lookup].[AttendTrackLevel] ADD CONSTRAINT [PK_AttendTrackLevel] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[Campus]'
GO
CREATE TABLE [lookup].[Campus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Campus] on [lookup].[Campus]'
GO
ALTER TABLE [lookup].[Campus] ADD CONSTRAINT [PK_Campus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[Gender]'
GO
CREATE TABLE [lookup].[Gender]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Gender] on [lookup].[Gender]'
GO
ALTER TABLE [lookup].[Gender] ADD CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[OrganizationStatus]'
GO
CREATE TABLE [lookup].[OrganizationStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_OrganizationStatus] on [lookup].[OrganizationStatus]'
GO
ALTER TABLE [lookup].[OrganizationStatus] ADD CONSTRAINT [PK_OrganizationStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[OtherNotify]'
GO
CREATE TABLE [disc].[OtherNotify]
(
[Id] [int] NOT NULL,
[email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BlogId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_OtherNotify] on [disc].[OtherNotify]'
GO
ALTER TABLE [disc].[OtherNotify] ADD CONSTRAINT [PK_OtherNotify] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_OtherNotify] on [disc].[OtherNotify]'
GO
CREATE NONCLUSTERED INDEX [IX_OtherNotify] ON [disc].[OtherNotify] ([BlogId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[BaptismStatus]'
GO
CREATE TABLE [lookup].[BaptismStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BaptismStatus] on [lookup].[BaptismStatus]'
GO
ALTER TABLE [lookup].[BaptismStatus] ADD CONSTRAINT [PK_BaptismStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[BaptismType]'
GO
CREATE TABLE [lookup].[BaptismType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_BaptismType] on [lookup].[BaptismType]'
GO
ALTER TABLE [lookup].[BaptismType] ADD CONSTRAINT [PK_BaptismType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[DecisionType]'
GO
CREATE TABLE [lookup].[DecisionType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_DecisionType] on [lookup].[DecisionType]'
GO
ALTER TABLE [lookup].[DecisionType] ADD CONSTRAINT [PK_DecisionType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[DiscoveryClassStatus]'
GO
CREATE TABLE [lookup].[DiscoveryClassStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_DiscoveryClassStatus] on [lookup].[DiscoveryClassStatus]'
GO
ALTER TABLE [lookup].[DiscoveryClassStatus] ADD CONSTRAINT [PK_DiscoveryClassStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[DropType]'
GO
CREATE TABLE [lookup].[DropType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_DropType] on [lookup].[DropType]'
GO
ALTER TABLE [lookup].[DropType] ADD CONSTRAINT [PK_DropType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[FamilyPosition]'
GO
CREATE TABLE [lookup].[FamilyPosition]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_FamilyPosition] on [lookup].[FamilyPosition]'
GO
ALTER TABLE [lookup].[FamilyPosition] ADD CONSTRAINT [PK_FamilyPosition] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[InterestPoint]'
GO
CREATE TABLE [lookup].[InterestPoint]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_InterestPoint] on [lookup].[InterestPoint]'
GO
ALTER TABLE [lookup].[InterestPoint] ADD CONSTRAINT [PK_InterestPoint] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[JoinType]'
GO
CREATE TABLE [lookup].[JoinType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_JoinType] on [lookup].[JoinType]'
GO
ALTER TABLE [lookup].[JoinType] ADD CONSTRAINT [PK_JoinType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[MaritalStatus]'
GO
CREATE TABLE [lookup].[MaritalStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MaritalStatus] on [lookup].[MaritalStatus]'
GO
ALTER TABLE [lookup].[MaritalStatus] ADD CONSTRAINT [PK_MaritalStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[MemberLetterStatus]'
GO
CREATE TABLE [lookup].[MemberLetterStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MemberLetterStatus] on [lookup].[MemberLetterStatus]'
GO
ALTER TABLE [lookup].[MemberLetterStatus] ADD CONSTRAINT [PK_MemberLetterStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[Origin]'
GO
CREATE TABLE [lookup].[Origin]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Origin] on [lookup].[Origin]'
GO
ALTER TABLE [lookup].[Origin] ADD CONSTRAINT [PK_Origin] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SaleTransaction]'
GO
CREATE TABLE [dbo].[SaleTransaction]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[SaleDate] [datetime] NOT NULL,
[Amount] [money] NOT NULL,
[TransactionId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PeopleId] [int] NOT NULL,
[Username] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemId] [int] NOT NULL,
[Quantity] [int] NOT NULL,
[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SaleTransaction] on [dbo].[SaleTransaction]'
GO
ALTER TABLE [dbo].[SaleTransaction] ADD CONSTRAINT [PK_SaleTransaction] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SaleItem]'
GO
CREATE TABLE [dbo].[SaleItem]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price] [money] NOT NULL,
[Available] [bit] NULL,
[URL] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaxItems] [int] NULL,
[DefaultItems] [int] NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SaleItem] on [dbo].[SaleItem]'
GO
ALTER TABLE [dbo].[SaleItem] ADD CONSTRAINT [PK_SaleItem] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[TaskStatus]'
GO
CREATE TABLE [lookup].[TaskStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TaskStatus] on [lookup].[TaskStatus]'
GO
ALTER TABLE [lookup].[TaskStatus] ADD CONSTRAINT [PK_TaskStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Roles]'
GO
CREATE TABLE [dbo].[Roles]
(
[RoleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RoleId] [int] NOT NULL IDENTITY(1, 1)
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Roles] on [dbo].[Roles]'
GO
ALTER TABLE [dbo].[Roles] ADD CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([RoleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Roles] on [dbo].[Roles]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles] ON [dbo].[Roles] ([RoleName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[VolApplicationStatus]'
GO
CREATE TABLE [lookup].[VolApplicationStatus]
(
[Id] [int] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VolApplicationStatus] on [lookup].[VolApplicationStatus]'
GO
ALTER TABLE [lookup].[VolApplicationStatus] ADD CONSTRAINT [PK_VolApplicationStatus] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Zips]'
GO
CREATE TABLE [dbo].[Zips]
(
[ZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MetroMarginalCode] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Zips] on [dbo].[Zips]'
GO
ALTER TABLE [dbo].[Zips] ADD CONSTRAINT [PK_Zips] PRIMARY KEY CLUSTERED ([ZipCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[TagType]'
GO
CREATE TABLE [dbo].[TagType]
(
[Id] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TagTypes] on [dbo].[TagType]'
GO
ALTER TABLE [dbo].[TagType] ADD CONSTRAINT [PK_TagTypes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GetEldestFamilyMember]'
GO
CREATE FUNCTION [dbo].[GetEldestFamilyMember]( @fid int )
RETURNS int
AS
BEGIN
    DECLARE @Result int

    select @Result = PeopleId
      from dbo.People
     where FamilyId = @fid
       and dbo.Birthday(PeopleId) = (select max(dbo.Birthday(PeopleId))
                    from dbo.People
                   where FamilyId = @fid)
                   
    IF @Result IS NULL
		SELECT TOP 1 @Result = PeopleId FROM dbo.People WHERE FamilyId = @fid
     
	RETURN @Result
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[BibleFellowshipClassId]'
GO

CREATE FUNCTION [dbo].[BibleFellowshipClassId]
	(
	@pid int
	)
RETURNS int
AS
	BEGIN
	declare @oid INT, @bfid INT
	SELECT TOP 1 @bfid = Id FROM dbo.Program WHERE BFProgram = 1

	select top 1 @oid = om.OrganizationId from dbo.OrganizationMembers AS om 
	JOIN dbo.Organizations AS o ON om.OrganizationId = o.OrganizationId
	JOIN dbo.Division d ON o.DivisionId = d.Id
	where d.ProgId = @bfid and om.PeopleId = @pid
	AND ISNULL(om.Pending, 0) = 0

	IF @oid IS NULL
		select top 1 @oid = om.OrganizationId from dbo.OrganizationMembers AS om 
		JOIN dbo.Organizations AS o ON om.OrganizationId = o.OrganizationId
		JOIN dbo.DivOrg do ON o.OrganizationId = do.OrgId
		JOIN dbo.Division d ON do.DivId = d.Id
		where d.ProgId = @bfid and om.PeopleId = @pid
		AND ISNULL(om.Pending, 0) = 0

	return @oid
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[HeadOfHouseholdId]'
GO

CREATE FUNCTION [dbo].[HeadOfHouseholdId] ( @family_id INT )
RETURNS INT
AS 
    BEGIN
        DECLARE @Result INT

        SELECT TOP 1
                @Result = ISNULL(CASE ( SUM(CASE PositionInFamilyId
                                              WHEN 10 THEN 1
                                              ELSE 0
                                            END) )
                                   WHEN 2 -- couple
                                   -- use primary male
                                        THEN ISNULL(MIN(CASE PositionInFamilyId
                                                          WHEN 10
                                                          THEN CASE GenderId
                                                              WHEN 1
                                                              THEN PeopleId
                                                              ELSE NULL
                                                              END
                                                          ELSE NULL
                                                        END),
                                                   -- primary female
                                                    MIN(CASE PositionInFamilyId
                                                          WHEN 10
                                                          THEN CASE GenderId
                                                              WHEN 2
                                                              THEN PeopleId
                                                              ELSE NULL
                                                              END
                                                          ELSE NULL
                                                        END))
                                   WHEN 1 -- single
                                   -- primary male
                                        THEN ISNULL(MIN(CASE PositionInFamilyId
                                                          WHEN 10
                                                          THEN CASE GenderId
                                                              WHEN 1
                                                              THEN PeopleId
                                                              ELSE NULL
                                                              END
                                                          ELSE NULL
                                                        END),
                                                   -- primary female
                                                    ISNULL(MIN(CASE PositionInFamilyId
                                                              WHEN 10
                                                              THEN CASE GenderId
                                                              WHEN 2
                                                              THEN PeopleId
                                                              ELSE NULL
                                                              END
                                                              ELSE NULL
                                                              END),
                                                          -- primary unknown
                                                           MIN(CASE PositionInFamilyId
                                                              WHEN 10
                                                              THEN CASE GenderId
                                                              WHEN 0
                                                              THEN PeopleId
                                                              ELSE NULL
                                                              END
                                                              ELSE NULL
                                                              END)))
                                      -- eldest
                                 END, dbo.GetEldestFamilyMember(@family_id))
        FROM    dbo.People
        WHERE   FamilyId = @family_id
                AND DeceasedDate IS NULL
                AND FirstName <> 'Duplicate'

	-- Return the result of the function
        RETURN @Result

    END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[HeadOfHouseHoldSpouseId]'
GO

CREATE FUNCTION [dbo].[HeadOfHouseHoldSpouseId] 
(
	@family_id int
)

RETURNS int
AS
BEGIN
	DECLARE @Result int

    SELECT @Result = 
           dbo.SpouseId(dbo.HeadOfHouseholdId(@family_id))

	-- Return the result of the function
	RETURN @Result

END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[OrganizationLeaderName]'
GO
CREATE FUNCTION [dbo].[OrganizationLeaderName](@orgid int)
RETURNS varchar(100)
AS
BEGIN
	DECLARE @id int, @orgstatus int, @name varchar(100)
	select @orgstatus = OrganizationStatusId 
	from dbo.Organizations
	where OrganizationId = @orgid
	if (@orgstatus = 40)
	SELECT top 1 @id = PeopleId from
                      dbo.EnrollmentTransaction et INNER JOIN
                      dbo.Organizations o ON 
                      et.OrganizationId = o.OrganizationId AND 
                      et.MemberTypeId = o.LeaderMemberTypeId
			where et.OrganizationId = @orgid
                      order by et.TransactionDate desc
	else
	SELECT top 1 @id = PeopleId from
                      dbo.OrganizationMembers om INNER JOIN
                      dbo.Organizations o ON 
                      om.OrganizationId = o.OrganizationId AND 
                      om.MemberTypeId = o.LeaderMemberTypeId
	where om.OrganizationId = @orgid
	ORDER BY om.EnrollmentDate

	SELECT @name = (case when [Nickname]<>'' then [nickname] else [FirstName] end+' ')+[LastName] from dbo.People where PeopleId = @id
	RETURN @name
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[OrganizationLeaderId]'
GO
CREATE FUNCTION [dbo].[OrganizationLeaderId](@orgid int)
RETURNS int
AS
BEGIN
	DECLARE @id int, @orgstatus int
	select @orgstatus = OrganizationStatusId 
	from dbo.Organizations
	where OrganizationId = @orgid
	if (@orgstatus = 40)
	SELECT top 1 @id = PeopleId from
                      dbo.EnrollmentTransaction et INNER JOIN
                      dbo.Organizations o ON 
                      et.OrganizationId = o.OrganizationId AND 
                      et.MemberTypeId = o.LeaderMemberTypeId
			where et.OrganizationId = @orgid
                      order by et.TransactionDate desc
	else
	SELECT top 1 @id = PeopleId from
                      dbo.OrganizationMembers om INNER JOIN
                      dbo.Organizations o ON 
                      om.OrganizationId = o.OrganizationId AND 
                      om.MemberTypeId = o.LeaderMemberTypeId
	where om.OrganizationId = @orgid
	ORDER BY om.EnrollmentDate
	RETURN @id

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateMeetingCounters]'
GO
CREATE PROCEDURE [dbo].[UpdateMeetingCounters](@mid INT)
AS
BEGIN
	DECLARE @gf BIT, @numPresent INT, @numNewVisit INT, @numMembers INT, @numVstMembers INT, @numRepeatVst INT
	SELECT @gf = GroupMeetingFlag FROM dbo.Meetings WHERE MeetingId = @mid
	IF @gf = 0
	BEGIN
		SELECT @numPresent = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1
		SELECT @numNewVisit = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1 AND AttendanceTypeId = 60
		SELECT @numMembers = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1 AND AttendanceTypeId IN (10,20,30)
		SELECT @numVstMembers = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1 AND AttendanceTypeId = 40
		SELECT @numRepeatVst = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1 AND AttendanceTypeId = 50
		UPDATE dbo.Meetings SET
			NumMembers = @numMembers,
			NumPresent = @numPresent,
			NumNewVisit = @numNewVisit,
			NumVstMembers = @numVstMembers,
			NumRepeatVst = @numRepeatVst
			WHERE MeetingId = @mid
	END
	ELSE
	BEGIN
		SELECT @numNewVisit = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1 AND AttendanceTypeId = 60
		SELECT @numRepeatVst = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1 AND AttendanceTypeId = 50
		SELECT @numVstMembers = COUNT(*) FROM dbo.Attend WHERE MeetingId = @mid AND AttendanceFlag = 1 AND AttendanceTypeId = 40
		UPDATE dbo.Meetings SET
			NumNewVisit = @numNewVisit,
			NumVstMembers = @numVstMembers,
			NumRepeatVst = @numRepeatVst
			WHERE MeetingId = @mid
	END
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Tag]'
GO
CREATE TABLE [dbo].[Tag]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeId] [int] NOT NULL CONSTRAINT [DF_Tag_TypeId] DEFAULT ((1)),
[Owner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL,
[PeopleId] [int] NULL,
[OwnerName] AS ([dbo].[UName]([PeopleId]))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Tag] on [dbo].[Tag]'
GO
ALTER TABLE [dbo].[Tag] ADD CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Tag] on [dbo].[Tag]'
GO
CREATE NONCLUSTERED INDEX [IX_Tag] ON [dbo].[Tag] ([TypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VBSOrg]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[VBSOrg](@pid INT) 
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @org INT

	-- Add the T-SQL statements to compute the return value here
	DECLARE @vbs INT
	SELECT @vbs = CONVERT(INT, Setting) FROM dbo.Setting WHERE Id = 'VBS'
	
	SELECT @org = om.OrganizationId
	FROM dbo.OrganizationMembers om
	JOIN dbo.People p ON om.PeopleId = p.PeopleId
	JOIN dbo.Organizations o ON om.OrganizationId = o.OrganizationId
	WHERE EXISTS(SELECT NULL FROM dbo.DivOrg do 
		JOIN dbo.Division d ON do.DivId = d.Id
		WHERE d.ProgId = @vbs
		AND do.OrgId = om.OrganizationId)
	AND o.OrganizationStatusId = 30
	AND p.PeopleId = @pid

	-- Return the result of the function
	RETURN @org

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateLargeMeetingCounters]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateLargeMeetingCounters]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		DECLARE cur CURSOR FOR SELECT MeetingId FROM dbo.Meetings WHERE NumPresent > 4000
		OPEN cur
		DECLARE @mid int
		FETCH NEXT FROM cur INTO @mid
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE dbo.UpdateMeetingCounters @mid
			FETCH NEXT FROM cur INTO @mid
		END
		CLOSE cur
		DEALLOCATE cur
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DeleteTagForUser]'
GO
CREATE PROCEDURE [dbo].[DeleteTagForUser](@tag varchar, @user varchar)
AS
	/* SET NOCOUNT ON */
	declare @id int
	select @id = id from tag where name = @tag and @user = owner
	
	delete from tagperson where id = @id
	delete from tagshare where tagid = @id
	delete from tag where id = @id
	
	RETURN

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DeleteSpecialTags]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteSpecialTags](@pid INT = null)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DELETE dbo.TagPerson
FROM dbo.TagPerson tp
JOIN dbo.Tag t ON tp.Id = t.Id
WHERE t.TypeId IN (3,4,5) AND (t.PeopleId = @pid OR @pid IS NULL)

DELETE FROM dbo.Tag
WHERE TypeId IN (3,4,5) AND (PeopleId = @pid OR @pid IS NULL)

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[OneHeadOfHouseholdIsMember]'
GO
CREATE FUNCTION dbo.OneHeadOfHouseholdIsMember(@fid INT)
RETURNS BIT
AS
	BEGIN
	IF EXISTS(SELECT NULL FROM dbo.People WHERE FamilyId = @fid AND PeopleId IN (dbo.HeadOfHouseholdId(@fid), dbo.HeadOfHouseHoldSpouseId(@fid)) AND MemberStatusId = 10)
		RETURN 1
	RETURN 0
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[GetAttendedTodaysMeeting]'
GO
CREATE FUNCTION dbo.GetAttendedTodaysMeeting
    (
      @orgid INT ,
      @thisday INT,
      @pid INT
    )
RETURNS BIT
AS 
    BEGIN
        IF @thisday IS NULL
			SELECT @thisday = DATEPART(dw, GETDATE()) - 1

		DECLARE @attended BIT, @meetingid INT
		
		SELECT @meetingid = dbo.GetTodaysMeetingId(@orgid, @thisday)
		
		IF @meetingid IS NOT NULL
			SELECT @attended = AttendanceFlag FROM dbo.Attend 
			WHERE MeetingId = @meetingid AND PeopleId = @pid
		IF (@attended IS NULL)
			SELECT @attended = 0

        RETURN @attended
    END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[UpdateAllPhoneHOH]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateAllPhoneHOH
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		UPDATE dbo.Families
		SET HomePhoneLU = RIGHT(HomePhone, 7),
			HomePhoneAC = LEFT(RIGHT(REPLICATE('0',10) + HomePhone, 10), 3),
			HeadOfHouseholdId = dbo.HeadOfHouseholdId(FamilyId),
			HeadOfHouseholdSpouseId = dbo.HeadOfHouseHoldSpouseId(FamilyId)
			
		UPDATE dbo.People
		SET CellPhoneLU = RIGHT(CellPhone, 7),
			CellPhoneAC = LEFT(RIGHT(REPLICATE('0',10) + CellPhone, 10), 3)
		
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[MemberStatusDescription]'
GO
CREATE FUNCTION [dbo].[MemberStatusDescription](@pid int)
RETURNS varchar(50)
AS
	BEGIN
	declare @desc varchar(50)
	select @desc = m.description from lookup.memberstatus m
	join dbo.People p on p.MemberStatusId = m.id
	where p.PeopleId = @pid
	return @desc
	END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[MoveUser]'
GO
CREATE PROCEDURE disc.MoveUser(@frid INT, @toid INT) 
AS
BEGIN
UPDATE dbo.Blog SET OwnerId = @toid 
WHERE OwnerId = @frid

UPDATE dbo.BlogComment SET PosterId = @toid 
WHERE @frid = PosterId

UPDATE dbo.BlogNotify SET UserId = @toid 
WHERE @frid = dbo.BlogNotify.UserId

UPDATE dbo.BlogPost SET PosterId = @toid 
WHERE @frid = PosterId

UPDATE dbo.Forum SET CreatedBy = @toid 
WHERE @frid = dbo.Forum.CreatedBy

UPDATE dbo.ForumNotify SET UserId = @toid 
WHERE @frid = dbo.ForumNotify.UserId

UPDATE dbo.ForumUserRead SET UserId = @toid 
WHERE @frid = dbo.ForumUserRead.UserId

UPDATE dbo.PageContent SET CreatedById = @toid
WHERE @frid = CreatedById
UPDATE dbo.PageContent SET ModifiedById = @toid
WHERE @frid = ModifiedById

UPDATE dbo.PageVisit SET UserId = @toid 
WHERE @frid = dbo.PageVisit.UserId

UPDATE dbo.ParaContent SET CreatedById = @toid 
WHERE @frid = CreatedById

UPDATE dbo.PendingNotifications SET UserId = @toid 
WHERE @frid = dbo.PendingNotifications.UserId

UPDATE dbo.PodCast SET UserId = @toid 
WHERE @frid = dbo.PodCast.UserId

UPDATE dbo.PrayerSlot SET UserId = @toid 
WHERE @frid = dbo.PrayerSlot.UserId

UPDATE dbo.TemporaryToken SET CreatedBy = @toid 
WHERE @frid = CreatedBy

UPDATE dbo.UserGroupRole SET UserId = @toid 
WHERE @frid = dbo.UserGroupRole.UserId

UPDATE dbo.Verse SET CreatedBy = @toid 
WHERE @frid = CreatedBy

UPDATE dbo.VerseCategory SET CreatedBy = @toid 
WHERE @frid = CreatedBy

DELETE dbo.Users WHERE UserId = @frid
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ContributionsView]'
GO


CREATE VIEW [dbo].[ContributionsView]
AS
SELECT
	f.FundId, 
	ContributionTypeId AS TypeId, 
	ContributionDate AS CDate, 
	ContributionAmount AS Amount, 
	ContributionStatusId AS StatusId,
	PledgeFlag AS Pledged,
	Age,
	Age / 10 AS AgeRange,
	f.FundDescription AS Fund,
	cs.Description AS [Status],
	ct.Description AS [Type],
	p.Name
FROM dbo.Contribution c
JOIN dbo.People p ON c.PeopleId = p.PeopleId
JOIN lookup.ContributionStatus cs ON c.ContributionStatusId = cs.Id
JOIN lookup.ContributionType ct ON c.ContributionTypeId = ct.Id
JOIN dbo.ContributionFund f ON c.FundId = f.FundId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[ForumThread]'
GO
CREATE PROCEDURE disc.ForumThread (@ThreadId int, @UserId nvarchar(50)) 
AS
	SELECT        e.Id, e.Title, e.ReplyToId, e.DisplayOrder, e.DisplayDepth, e.CreatedOn, 
		CAST(CASE WHEN r.userid IS NULL THEN 0 ELSE 1 END AS bit) AS IsRead, 
	                         e.CreatedBy, e.ForumId
	FROM            dbo.ForumEntry AS e LEFT OUTER JOIN
	                         dbo.ForumUserRead AS r ON e.Id = r.ForumEntryId AND (r.UserId = @UserId)
	WHERE        (e.ThreadId = @ThreadId) 
	ORDER BY e.DisplayOrder

	RETURN

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AttendMemberTypeAsOf]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[AttendMemberTypeAsOf]
(	
	@from DATETIME,
	@to DATETIME,
	@progid INT,
	@divid INT,
	@orgid INT,
	@not BIT,
	@ids VARCHAR(4000)
)
RETURNS @t TABLE ( PeopleId INT )
AS
BEGIN
	INSERT INTO @t (PeopleId) SELECT p.PeopleId FROM dbo.People p
	WHERE EXISTS (
		SELECT NULL FROM dbo.Attend a
		WHERE a.PeopleId = p.PeopleId
		AND (@not = 1 OR a.MemberTypeId IN (SELECT id FROM CsvTable(@ids)))
		AND (@not = 0 OR a.MemberTypeId NOT IN (SELECT id FROM CsvTable(@ids)))
		AND a.AttendanceFlag = 1
		AND a.MeetingDate >= @from
		AND a.MeetingDate < @to
		AND (a.OrganizationId = @orgid OR @orgid = 0)
		AND (EXISTS(SELECT NULL FROM DivOrg d1
				WHERE d1.OrgId = a.OrganizationId
				AND d1.DivId = @divid) OR @divid = 0)
		AND (EXISTS(SELECT NULL FROM DivOrg d2
				WHERE d2.OrgId = a.OrganizationId
				AND EXISTS(SELECT NULL FROM Division d
						WHERE d2.DivId = d.Id
						AND d.ProgId = @progid)) OR @progid = 0)
		)
	RETURN
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VBSApp]'
GO
CREATE TABLE [dbo].[VBSApp]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PeopleId] [int] NULL,
[ImgId] [int] NULL,
[IsDocument] [bit] NULL,
[Uploaded] [datetime] NULL,
[Request] [varchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActiveInAnotherChurch] [bit] NULL,
[GradeCompleted] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrgId] AS ([dbo].[VBSOrg]([PeopleId])),
[Inactive] [bit] NULL,
[PubPhoto] [bit] NULL,
[UserInfo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MedAllergy] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VBSApp] on [dbo].[VBSApp]'
GO
ALTER TABLE [dbo].[VBSApp] ADD CONSTRAINT [PK_VBSApp] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[VBSInfo]'
GO
CREATE VIEW dbo.VBSInfo
AS
SELECT        v.Id, p.Name, p.Name2, p.PeopleId, v.UserInfo, v.PubPhoto, p.MemberStatusId, v.ActiveInAnotherChurch, v.GradeCompleted, p.GenderId, v.Request, 
                         v.Uploaded, o.OrganizationName AS OrgName, o.OrganizationId AS OrgId, o.DivisionId AS DivId
FROM            dbo.People AS p RIGHT OUTER JOIN
                         dbo.VBSApp AS v ON p.PeopleId = v.PeopleId LEFT OUTER JOIN
                         dbo.Organizations AS o ON dbo.VBSOrg(p.PeopleId) = o.OrganizationId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PurgeAllButOrg]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PurgeAllButOrg](@orgid INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

DECLARE @people TABLE ( id INT )

INSERT INTO @people
SELECT PeopleId
FROM dbo.People p
WHERE NOT EXISTS(
	SELECT NULL FROM dbo.OrganizationMembers om
	JOIN dbo.People pp ON om.PeopleId = pp.PeopleId
	WHERE OrganizationId = @orgid AND pp.FamilyId = p.FamilyId
	)
	AND NOT EXISTS(
	SELECT NULL FROM dbo.EnrollmentTransaction et
	JOIN dbo.People pp ON et.PeopleId = pp.PeopleId
	WHERE OrganizationId = @orgid AND pp.FamilyId = p.FamilyId
	)
	
DELETE dbo.SoulMate
	
DELETE dbo.LoveRespect

DELETE dbo.OrgMemMemTags
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.OrganizationMembers
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.BadET
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.EnrollmentTransaction
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.MOBSReg
WHERE PeopleId IN (SELECT id FROM @people)
	
DELETE dbo.Attend
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.BundleDetail
FROM dbo.BundleDetail bd
JOIN dbo.Contribution c ON bd.ContributionId = c.ContributionId
WHERE PeopleId IN (SELECT id FROM @people)
	
DELETE dbo.Contribution
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.VolunteerForm
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.Volunteer
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.Contactees
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.Contactors
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.TagPerson
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.Task
WHERE WhoId IN (SELECT id FROM @people)

DELETE dbo.Task
WHERE OwnerId IN (SELECT id FROM @people)

DELETE dbo.Task
WHERE CoOwnerId IN (SELECT id FROM @people)

DELETE dbo.TaskListOwners
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.Preferences
WHERE UserId IN (SELECT UserId FROM Users
WHERE PeopleId IN (SELECT id FROM @people))

DELETE dbo.ActivityLog
WHERE UserId IN (SELECT UserId FROM Users
WHERE PeopleId IN (SELECT id FROM @people))

DELETE dbo.UserRole
WHERE UserId IN (SELECT UserId FROM Users
WHERE PeopleId IN (SELECT id FROM @people))

DELETE dbo.UserCanEmailFor
WHERE UserId IN (SELECT UserId FROM Users
WHERE PeopleId IN (SELECT id FROM @people))

DELETE dbo.UserCanEmailFor
WHERE CanEmailFor IN (SELECT UserId FROM Users
WHERE PeopleId IN (SELECT id FROM @people))

DELETE dbo.VolunteerForm
WHERE UploaderId IN (SELECT UserId FROM Users
WHERE PeopleId IN (SELECT id FROM @people))

DELETE dbo.Users
WHERE UserId IN (SELECT UserId FROM Users
WHERE PeopleId IN (SELECT id FROM @people))
	
DELETE dbo.TagPerson
DELETE dbo.TagShare
DELETE dbo.Tag

DELETE dbo.RecReg
WHERE PeopleId IN (SELECT id FROM @people)
	
DELETE dbo.VBSApp
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.VolInterestInterestCodes

DELETE dbo.VolInterest

DELETE dbo.VolInterestCodes

UPDATE dbo.Families
SET HeadOfHouseholdId = NULL, HeadOfHouseholdSpouseId = NULL

UPDATE dbo.People
SET PictureId = NULL 
WHERE PeopleId IN (SELECT id FROM @people)

DELETE dbo.Picture
FROM dbo.Picture pic
WHERE NOT EXISTS(SELECT NULL FROM dbo.People WHERE PictureId = pic.PictureId)

---------------------------------------
DELETE dbo.People
WHERE PeopleId IN (SELECT id FROM @people)
---------------------------------------

DELETE dbo.RelatedFamilies
FROM dbo.RelatedFamilies r
JOIN dbo.Families f ON r.FamilyId = f.FamilyId
WHERE (SELECT COUNT(*) FROM dbo.People WHERE FamilyId = f.FamilyId) = 0

DELETE dbo.RelatedFamilies
FROM dbo.RelatedFamilies r
JOIN dbo.Families f ON r.RelatedFamilyId = f.FamilyId
WHERE (SELECT COUNT(*) FROM dbo.People WHERE FamilyId = f.FamilyId) = 0

DELETE dbo.Families 
FROM dbo.Families f
WHERE (SELECT COUNT(*) FROM dbo.People WHERE FamilyId = f.FamilyId) = 0
	
----------------------------------------------------------------------------
DELETE dbo.NewContact
FROM dbo.NewContact nc
WHERE NOT EXISTS(SELECT NULL FROM dbo.Contactees WHERE ContactId = nc.ContactId)
AND NOT EXISTS(SELECT NULL FROM dbo.Contactors WHERE ContactId = nc.ContactId)

DELETE dbo.Meetings
FROM dbo.Meetings m
WHERE NOT EXISTS(SELECT NULL FROM dbo.Attend WHERE MeetingId = m.MeetingId)

DELETE dbo.DivOrg
FROM dbo.DivOrg od
JOIN dbo.Organizations o ON od.OrgId = o.OrganizationId
WHERE NOT EXISTS(SELECT NULL FROM dbo.OrganizationMembers WHERE OrganizationId = o.OrganizationId)
AND NOT EXISTS(SELECT NULL FROM dbo.EnrollmentTransaction WHERE OrganizationId = o.OrganizationId)

DELETE dbo.MemberTags
FROM dbo.MemberTags mt
JOIN dbo.Organizations o ON mt.OrgId = o.OrganizationId
WHERE NOT EXISTS(SELECT NULL FROM dbo.OrganizationMembers WHERE OrganizationId = o.OrganizationId)

DELETE dbo.Organizations
FROM dbo.Organizations o
WHERE NOT EXISTS(SELECT NULL FROM dbo.OrganizationMembers WHERE OrganizationId = o.OrganizationId)
AND NOT EXISTS(SELECT NULL FROM dbo.EnrollmentTransaction WHERE OrganizationId = o.OrganizationId)
AND NOT EXISTS(SELECT NULL FROM dbo.Attend WHERE OrganizationId = o.OrganizationId)

DELETE dbo.Promotion

DELETE dbo.Division
FROM dbo.Division d
WHERE NOT EXISTS(SELECT NULL FROM dbo.DivOrg WHERE DivId = d.Id)
AND NOT EXISTS(SELECT NULL FROM dbo.Organizations WHERE DivisionId = d.Id)
AND NOT EXISTS(SELECT NULL FROM dbo.RecLeague WHERE DivId = d.Id)

DELETE dbo.Program
FROM dbo.Program p
WHERE NOT EXISTS(SELECT NULL FROM dbo.Division WHERE ProgId = p.Id)

DELETE dbo.TaskList
FROM dbo.TaskList t
WHERE NOT EXISTS(SELECT NULL FROM  dbo.Users WHERE UserId = t.CreatedBy)

DELETE Tag
FROM dbo.Tag t
WHERE PeopleId IS NULL
AND NOT EXISTS(SELECT NULL FROM dbo.TagPerson WHERE Id = t.Id)

DELETE dbo.BundleDetail
FROM dbo.BundleDetail bd
WHERE EXISTS(SELECT NULL FROM dbo.Contribution WHERE ContributionId = bd.ContributionId AND PeopleId IS NULL)

DELETE FROM dbo.Contribution WHERE PeopleId IS NULL

DELETE dbo.BundleHeader
FROM dbo.BundleHeader h
WHERE NOT EXISTS(SELECT NULL FROM dbo.BundleDetail WHERE BundleHeaderId = h.BundleHeaderId)

DELETE FROM dbo.AuditValues
DELETE FROM dbo.Audits

EXEC dbo.DeleteAllQueriesWithNoChildren
EXEC dbo.DeleteAllQueriesWithNoChildren
EXEC dbo.DeleteAllQueriesWithNoChildren
EXEC dbo.DeleteAllQueriesWithNoChildren

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PurgePerson]'
GO
CREATE PROCEDURE [dbo].[PurgePerson](@pid INT)
AS
BEGIN
	BEGIN TRY 
		BEGIN TRANSACTION 
		DECLARE @fid INT, @pic INT
		DELETE FROM dbo.OrgMemMemTags WHERE PeopleId = @pid
		DELETE FROM dbo.OrganizationMembers WHERE PeopleId = @pid
		DELETE FROM dbo.BadET WHERE PeopleId = @pid
		DELETE FROM dbo.EnrollmentTransaction WHERE PeopleId = @pid
		DELETE FROM dbo.MOBSReg WHERE PeopleId = @pid
		DELETE FROM dbo.CardIdentifiers WHERE PeopleId = @pid
		DELETE FROM dbo.CheckInTimes WHERE PeopleId = @pid
		DELETE FROM disc.PendingNotifications WHERE PeopleId = @pid
		DELETE FROM disc.PrayerSlot WHERE PeopleId = @pid
		
		DELETE disc.VerseCategoryXref
		FROM disc.VerseCategoryXref x 
		JOIN disc.VerseCategory c ON x.VerseCategoryId = c.id
		JOIN dbo.Users u ON c.CreatedBy = u.UserId
		WHERE u.PeopleId = @pid
		
		DELETE disc.VerseCategory
		FROM disc.VerseCategory c
		JOIN dbo.Users u ON c.CreatedBy = u.UserId
		WHERE u.PeopleId = @pid
		
		DELETE disc.BlogCategoryXref
		FROM disc.BlogCategoryXref x
		JOIN disc.BlogPost bp ON x.BlogPostId = bp.Id
		JOIN dbo.Users u ON bp.PosterId = u.UserId
		WHERE u.PeopleId = @pid
		
		DELETE disc.BlogPost
		FROM disc.BlogPost bp
		JOIN dbo.Users u ON bp.PosterId = u.UserId
		WHERE u.PeopleId = @pid

		DECLARE @t TABLE(id int)
		INSERT INTO @t(id) SELECT MeetingId FROM dbo.Attend a WHERE a.PeopleId = @pid
		
		DELETE FROM dbo.Attend WHERE PeopleId = @pid
		
		DECLARE cur CURSOR FOR SELECT id FROM @t
		OPEN cur
		DECLARE @mid int
		FETCH NEXT FROM cur INTO @mid
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE dbo.UpdateMeetingCounters @mid
			FETCH NEXT FROM cur INTO @mid
		END
		CLOSE cur
		DEALLOCATE cur
		
		UPDATE dbo.Contribution SET PeopleId = NULL WHERE PeopleId = @pid
		DELETE FROM dbo.VolunteerForm WHERE PeopleId = @pid
		DELETE FROM dbo.Volunteer WHERE PeopleId = @pid
		DELETE FROM dbo.Contactees WHERE PeopleId = @pid
		DELETE FROM dbo.Contactors WHERE PeopleId = @pid
		DELETE FROM dbo.TagPerson WHERE PeopleId = @pid
		DELETE FROM dbo.Task WHERE WhoId = @pid
		DELETE FROM dbo.Task WHERE OwnerId = @pid
		DELETE FROM dbo.Task WHERE CoOwnerId = @pid
		DELETE FROM dbo.TaskListOwners WHERE PeopleId = @pid
		
		DELETE FROM dbo.Preferences WHERE UserId IN (SELECT UserId FROM dbo.Users WHERE PeopleId = @pid)
		DELETE FROM dbo.ActivityLog WHERE UserId IN (SELECT UserId FROM dbo.Users WHERE PeopleId = @pid)
		DELETE FROM dbo.UserRole WHERE UserId IN (SELECT UserId FROM dbo.Users WHERE PeopleId = @pid)
		DELETE FROM dbo.UserCanEmailFor WHERE UserId IN (SELECT UserId FROM dbo.Users WHERE PeopleId = @pid)
		DELETE FROM dbo.UserCanEmailFor WHERE CanEmailFor IN (SELECT UserId FROM dbo.Users WHERE PeopleId = @pid)
		UPDATE dbo.VolunteerForm SET UploaderId = NULL WHERE UploaderId IN (SELECT UserId FROM dbo.Users WHERE PeopleId = @pid)
		
		DELETE disc.UserGroupRole
		FROM disc.UserGroupRole ugr
		JOIN dbo.Users u ON ugr.UserId = u.UserId
		WHERE u.PeopleId = @pid
		DELETE disc.PageVisit
		FROM disc.PageVisit pv
		JOIN dbo.Users u ON pv.UserId = u.UserId
		WHERE u.PeopleId = @pid
		DELETE FROM dbo.Users WHERE PeopleId = @pid
		
		DELETE FROM dbo.TagPerson WHERE id IN (SELECT Id FROM dbo.Tag WHERE PeopleId = @pid)
		DELETE FROM dbo.TagShare WHERE TagId IN (SELECT Id FROM dbo.Tag WHERE PeopleId = @pid)
		DELETE FROM dbo.TagShare WHERE PeopleId = @pid
		DELETE FROM dbo.Tag WHERE PeopleId = @pid
		
		DELETE FROM dbo.SoulMate WHERE HerId = @pid OR HimId = @pid
		DELETE FROM dbo.LoveRespect WHERE HerId = @pid OR HimId = @pid
		DELETE FROM dbo.RecReg WHERE PeopleId = @pid
		DELETE FROM dbo.VBSApp WHERE PeopleId = @pid
		
		DELETE dbo.VolInterestInterestCodes
		FROM dbo.VolInterestInterestCodes vc
		WHERE vc.PeopleId = @pid
		
		SELECT @fid = FamilyId, @pic = PictureId FROM dbo.People WHERE PeopleId = @pid
		
		UPDATE dbo.Families
		SET HeadOfHouseholdId = NULL, HeadOfHouseholdSpouseId = NULL
		WHERE FamilyId = @fid AND HeadOfHouseholdId = @pid
		OR FamilyId = @fid AND HeadOfHouseholdSpouseId = @pid
		
		DELETE FROM dbo.People WHERE PeopleId = @pid
		IF (SELECT COUNT(*) FROM dbo.People WHERE FamilyId = @fid) = 0
		BEGIN
			DELETE FROM dbo.RelatedFamilies WHERE FamilyId = @fid OR RelatedFamilyId = @fid
			DELETE FROM dbo.Families WHERE FamilyId = @fid			
		END
		DELETE FROM dbo.Picture WHERE PictureId = @pic
		COMMIT
	END TRY 
	BEGIN CATCH 
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH 
 
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PurgeAllPeople]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PurgeAllPeople]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		DECLARE pcur CURSOR FOR SELECT PeopleId FROM dbo.People
		OPEN pcur
		DECLARE @pid INT, @n INT
		SET @n = 0
		FETCH NEXT FROM pcur INTO @pid
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE dbo.PurgePerson	@pid
			SET @n = @n + 1
			IF (@n % 50) = 0
				RAISERROR ('%d', 0, 1, @n) WITH NOWAIT
			IF (@n % 3) = 0
			BEGIN
				FETCH NEXT FROM pcur INTO @pid
				SET @n = @n + 1
				IF (@n % 50) = 0
					RAISERROR ('%d', 0, 1, @n) WITH NOWAIT
			END
			FETCH NEXT FROM pcur INTO @pid
		END
		CLOSE pcur
		DEALLOCATE pcur
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DollarRange]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[DollarRange](@amt DECIMAL)
RETURNS int
AS
BEGIN
DECLARE @ret INT 
	SELECT @ret =
	CASE
		WHEN @amt IS NULL THEN 1
		WHEN @amt < 101 THEN 1
		WHEN @amt < 251 THEN 2
		WHEN @amt < 501 THEN 3
		WHEN @amt < 751 THEN 4
		WHEN @amt < 1001 THEN 5
		WHEN @amt < 2001 THEN 6
		WHEN @amt < 3001 THEN 7
		WHEN @amt < 4001 THEN 8
		WHEN @amt < 5001 THEN 9
		WHEN @amt < 10001 THEN 10
		WHEN @amt < 20001 THEN 11
		WHEN @amt < 30001 THEN 12
		WHEN @amt < 40001 THEN 13
		WHEN @amt < 50001 THEN 14
		WHEN @amt < 100001 THEN 15
		ELSE 16
	END 
	RETURN @ret
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DayAndTime]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[DayAndTime] (@dt DATETIME)
RETURNS VARCHAR(20)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @daytime VARCHAR(20)

SELECT @daytime =
	CASE DATEPART(dw,@dt)
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
    END + ' ' + SUBSTRING(CONVERT(varchar,@dt,0),13,7)
    
	RETURN @daytime

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[FirstMondayOfMonth]'
GO
CREATE FUNCTION [dbo].[FirstMondayOfMonth] (@inputDate DATETIME)RETURNS DATETIME BEGIN     RETURN DATEADD(wk, DATEDIFF(wk, 0, dateadd(dd, 6 - datepart(day, @inputDate), @inputDate)), 0)  END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[LastNameCount]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[LastNameCount](@last VARCHAR(20))
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @r INT
	
	SELECT @r = [count] FROM dbo._LastName WHERE LastName = @last
	RETURN @r

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SundayForWeek]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[SundayForWeek](@year INT, @week INT)
RETURNS datetime
AS
BEGIN

DECLARE @dt DATETIME 
SELECT @dt = DATEADD(MONTH,((@year-1900)*12),0) -- jan 1 for year
SELECT @dt = DATEADD(MONTH, 9, @dt) -- Oct 1 for year
SELECT @dt = DATEADD(d, -DATEPART(dw, @dt)+1, @dt) -- sunday of that week
IF DATEPART(MONTH, @dt) < 10 -- are we in september now?
	SELECT @dt = DATEADD(d, 7, @dt) -- next sunday (to get into october)
SELECT @dt = DATEADD(ww, @week - 1, @dt) -- sunday for week number

	-- Return the result of the function
	RETURN @dt

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[StartsLower]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[StartsLower] (@s NVARCHAR) 
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ret bit

	SELECT @ret = 0
	-- Add the T-SQL statements to compute the return value here
	SELECT @ret = 1 WHERE @s COLLATE Latin1_General_BIN2 > 'Z'


	-- Return the result of the function
	RETURN @ret

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[DayOfYear]'
GO
CREATE   FUNCTION disc.DayOfYear ( @Date datetime ) 
RETURNS int
 WITH SCHEMABINDING
AS BEGIN
	declare @d1 as datetime
	set @d1 = '1/1/' + CAST(YEAR(@Date) AS CHAR(4))
	return (select DATEDIFF (day,@d1,@Date)+1)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[GetProfile]'
GO
CREATE FUNCTION disc.GetProfile
(
    @Username VARCHAR(50),
    @PropertyName varchar(100)
)
RETURNS VARCHAR(100)
AS
BEGIN

    DECLARE @StartPosition INT
    DECLARE @PropertyLength INT
    DECLARE @Return VARCHAR(100)

    DECLARE @RowData nvarchar(2000)
    DECLARE @SplitOn nvarchar(5)

    DECLARE @PropertyTable table 
    (
        Id int identity(1,1),
        Property nvarchar(100),
        DataType CHAR(1),
        Start INT,
        Length INT
    ) 

    SELECT @RowData = PropertyNames
    FROM aspnet_Profile
    JOIN dbo.aspnet_Users ON dbo.aspnet_Profile.UserId = dbo.aspnet_Users.UserId
    WHERE Username = @Username
    AND PropertyNames LIKE '%'+@PropertyName+'%'

    SET @SplitOn = ':'

    While (Charindex(@SplitOn,@RowData)>0)
    Begin
        Insert Into @PropertyTable (Property)
        Select ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))
        
        Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
        
        UPDATE @PropertyTable SET DataType = (
            Select ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1))))
            WHERE Id = @@IDENTITY
        
        Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
        
        UPDATE @PropertyTable SET Start = (
            Select ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1))))
            WHERE Id = @@IDENTITY
        
        Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
        
        UPDATE @PropertyTable SET Length = (
            Select ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1))))
            WHERE Id = @@IDENTITY
        
        Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
    END

    SELECT @StartPosition = Start, @PropertyLength = Length FROM @PropertyTable WHERE Property = @PropertyName

    SELECT @Return = SUBSTRING(PropertyValuesString, @StartPosition + 1, @PropertyLength)
    FROM aspnet_Profile
    JOIN dbo.aspnet_Users ON dbo.aspnet_Profile.UserId = dbo.aspnet_Users.UserId
    WHERE Username = @Username
    AND PropertyNames LIKE '%'+@PropertyName+'%'

    RETURN @Return
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Tool_VarbinaryToVarcharHex]'
GO
/**
<summary>
Based on ufn_VarbinaryToVarcharHex by Clay Beatty.
Used by Tool_ScriptDiagram2005

Function has two 'parts':

PART ONE: takes large VarbinaryValue chunks (greater than four bytes) 
and splits them into half, calling the function recursively with 
each half until the chunks are only four bytes long

PART TWO: notices the VarbinaryValue is four bytes or less, and 
starts actually processing these four byte chunks. It does this
by splitting the least-significant (rightmost) byte into two 
hexadecimal characters and recursively calling the function
with the more significant bytes until none remain (four recursive
calls in total).
</summary>
<author>Craig Dunn</author>
<remarks>
Clay Beatty's original function was written for Sql Server 2000.
Sql Server 2005 introduces the VARBINARY(max) datatype which this 
function now uses.

References
----------
1) MSDN: Using Large-Value Data Types
http://msdn2.microsoft.com/en-us/library/ms178158.aspx

2) Clay's "original" Script, Save, Export SQL 2000 Database Diagrams
http://www.thescripts.com/forum/thread81534.html or
http://groups-beta.google.com/group/comp.databases.ms-sqlserver/browse_frm/thread/ca9a9229d06a56f9?dq=&hl=en&lr=&ie=UTF-8&oe=UTF-8&prev=/groups%3Fdq%3D%26num%3D25%26hl%3Den%26lr%3D%26ie%3DUTF-8%26oe%3DUTF-8%26group%3Dcomp.databases.ms-sqlserver%26start%3D25
</remarks>
<param name="VarbinaryValue">binary data to be converted to Hexadecimal </param>
<returns>Hexadecimal representation of binary data, using chars [0-0a-f]</returns>
*/
CREATE FUNCTION [dbo].[Tool_VarbinaryToVarcharHex]
(
	@VarbinaryValue	VARBINARY(max)
)
RETURNS VARCHAR(max) AS
	BEGIN
	DECLARE @NumberOfBytes 	INT

	SET @NumberOfBytes = DATALENGTH(@VarbinaryValue)
	-- PART ONE --
	IF (@NumberOfBytes > 4)
	BEGIN
		DECLARE @FirstHalfNumberOfBytes INT
		DECLARE @SecondHalfNumberOfBytes INT
		SET @FirstHalfNumberOfBytes  = @NumberOfBytes/2
		SET @SecondHalfNumberOfBytes = @NumberOfBytes - @FirstHalfNumberOfBytes
		-- Call this function recursively with the two parts of the input split in half
		RETURN dbo.Tool_VarbinaryToVarcharHex(CAST(SUBSTRING(@VarbinaryValue, 1					        , @FirstHalfNumberOfBytes)  AS VARBINARY(max)))
			 + dbo.Tool_VarbinaryToVarcharHex(CAST(SUBSTRING(@VarbinaryValue, @FirstHalfNumberOfBytes+1 , @SecondHalfNumberOfBytes) AS VARBINARY(max)))
	END
	
	IF (@NumberOfBytes = 0)
	BEGIN
		RETURN ''	-- No bytes found, therefore no 'hex string' is returned
	END
	
	-- PART TWO --
	DECLARE @LowByte 		INT
	DECLARE @HighByte 		INT
	-- @NumberOfBytes <= 4 (four or less characters/8 hex digits were input)
	--						 eg. 88887777 66665555 44443333 22221111
	-- We'll process ONLY the right-most (least-significant) Byte, which consists
	-- of eight bits, or two hexadecimal values (eg. 22221111 --> XY) 
	-- where XY are two hex digits [0-f]

	-- 1. Carve off the rightmost four bits/single hex digit (ie 1111)
	--    BINARY AND 15 will result in a number with maxvalue of 15
	SET @LowByte = CAST(@VarbinaryValue AS INT) & 15
	-- Now determine which ASCII char value
	SET @LowByte = CASE 
	WHEN (@LowByte < 10)		-- 9 or less, convert to digits [0-9]
		THEN (48 + @LowByte)	-- 48 ASCII = 0 ... 57 ASCII = 9
		ELSE (87 + @LowByte)	-- else 10-15, convert to chars [a-f]
	END							-- (87+10)97 ASCII = a ... (87+15_102 ASCII = f

	-- 2. Carve off the rightmost eight bits/single hex digit (ie 22221111)
	--    Divide by 16 does a shift-left (now processing 2222)
	SET @HighByte = CAST(@VarbinaryValue AS INT) & 255
	SET @HighByte = (@HighByte / 16)
	-- Again determine which ASCII char value	
	SET @HighByte = CASE 
	WHEN (@HighByte < 10)		-- 9 or less, convert to digits [0-9]
		THEN (48 + @HighByte)	-- 48 ASCII = 0 ... 57 ASCII = 9
		ELSE (87 + @HighByte)	-- else 10-15, convert to chars [a-f]
	END							-- (87+10)97 ASCII = a ... (87+15)102 ASCII = f
	
	-- 3. Trim the byte (two hex values) from the right (least significant) input Binary
	--    in preparation for further parsing
	SET @VarbinaryValue = SUBSTRING(@VarbinaryValue, 1, (@NumberOfBytes-1))

	-- 4. Recursively call this method on the remaining Binary data, concatenating the two 
	--    hexadecimal 'values' we just decoded as their ASCII character representation
	--    ie. we pass 88887777 66665555 44443333 back to this function, adding XY to the result string
	RETURN dbo.Tool_VarbinaryToVarcharHex(@VarbinaryValue) + CHAR(@HighByte) + CHAR(@LowByte)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Address]'
GO
CREATE TABLE [dbo].[Address]
(
[Id] [int] NOT NULL,
[Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BadAddress] [bit] NULL,
[FromDt] [datetime] NULL,
[ToDt] [datetime] NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Address] on [dbo].[Address]'
GO
ALTER TABLE [dbo].[Address] ADD CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[AddressType]'
GO
CREATE TABLE [lookup].[AddressType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__AddressType__148954CD] on [lookup].[AddressType]'
GO
ALTER TABLE [lookup].[AddressType] ADD CONSTRAINT [PK__AddressType__148954CD] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[AttendanceClassification]'
GO
CREATE TABLE [lookup].[AttendanceClassification]
(
[Id] [int] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_AttendanceClassification] on [lookup].[AttendanceClassification]'
GO
ALTER TABLE [lookup].[AttendanceClassification] ADD CONSTRAINT [PK_AttendanceClassification] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ChurchAttReportIds]'
GO
CREATE TABLE [dbo].[ChurchAttReportIds]
(
[Name] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Id] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ChurchAttReportIds] on [dbo].[ChurchAttReportIds]'
GO
ALTER TABLE [dbo].[ChurchAttReportIds] ADD CONSTRAINT [PK_ChurchAttReportIds] PRIMARY KEY CLUSTERED ([Name])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[ContactPreference]'
GO
CREATE TABLE [lookup].[ContactPreference]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ContactPreference] on [lookup].[ContactPreference]'
GO
ALTER TABLE [lookup].[ContactPreference] ADD CONSTRAINT [PK_ContactPreference] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Content]'
GO
CREATE TABLE [dbo].[Content]
(
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Body] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Content_1] on [dbo].[Content]'
GO
ALTER TABLE [dbo].[Content] ADD CONSTRAINT [PK_Content_1] PRIMARY KEY CLUSTERED ([Name])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[CountryLookup]'
GO
CREATE TABLE [lookup].[CountryLookup]
(
[CountryName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayFlag] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_COUNTRY_LOOKUP_TBL_1] on [lookup].[CountryLookup]'
GO
ALTER TABLE [lookup].[CountryLookup] ADD CONSTRAINT [PK_COUNTRY_LOOKUP_TBL_1] PRIMARY KEY CLUSTERED ([CountryCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [COUNTRY_LOOKUP_NAME_IX] on [lookup].[CountryLookup]'
GO
CREATE NONCLUSTERED INDEX [COUNTRY_LOOKUP_NAME_IX] ON [lookup].[CountryLookup] ([CountryName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EmailLog]'
GO
CREATE TABLE [dbo].[EmailLog]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[fromaddr] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[toaddr] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[time] [datetime] NULL,
[subject] [varchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EmailLog] on [dbo].[EmailLog]'
GO
ALTER TABLE [dbo].[EmailLog] ADD CONSTRAINT [PK_EmailLog] PRIMARY KEY CLUSTERED ([id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ExtraData]'
GO
CREATE TABLE [dbo].[ExtraData]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Data] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Stamp] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ExtraData] on [dbo].[ExtraData]'
GO
ALTER TABLE [dbo].[ExtraData] ADD CONSTRAINT [PK_ExtraData] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[FamilyMemberType]'
GO
CREATE TABLE [lookup].[FamilyMemberType]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_FamilyMemberType] on [lookup].[FamilyMemberType]'
GO
ALTER TABLE [lookup].[FamilyMemberType] ADD CONSTRAINT [PK_FamilyMemberType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[FamilyRelationship]'
GO
CREATE TABLE [lookup].[FamilyRelationship]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_FamilyRelationship] on [lookup].[FamilyRelationship]'
GO
ALTER TABLE [lookup].[FamilyRelationship] ADD CONSTRAINT [PK_FamilyRelationship] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[GenderClass]'
GO
CREATE TABLE [lookup].[GenderClass]
(
[Id] [int] NOT NULL,
[Code] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_GenderClass] on [lookup].[GenderClass]'
GO
ALTER TABLE [lookup].[GenderClass] ADD CONSTRAINT [PK_GenderClass] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[MeetingType]'
GO
CREATE TABLE [lookup].[MeetingType]
(
[Id] [int] NOT NULL,
[Code] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_MeetingType] on [lookup].[MeetingType]'
GO
ALTER TABLE [lookup].[MeetingType] ADD CONSTRAINT [PK_MeetingType] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[NameSuffix]'
GO
CREATE TABLE [lookup].[NameSuffix]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_NameSuffix] on [lookup].[NameSuffix]'
GO
ALTER TABLE [lookup].[NameSuffix] ADD CONSTRAINT [PK_NameSuffix] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[NameTitle]'
GO
CREATE TABLE [lookup].[NameTitle]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_NameTitle] on [lookup].[NameTitle]'
GO
ALTER TABLE [lookup].[NameTitle] ADD CONSTRAINT [PK_NameTitle] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[PhonePreference]'
GO
CREATE TABLE [lookup].[PhonePreference]
(
[Id] [int] NOT NULL,
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PhonePreference] on [lookup].[PhonePreference]'
GO
ALTER TABLE [lookup].[PhonePreference] ADD CONSTRAINT [PK_PhonePreference] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[PostalLookup]'
GO
CREATE TABLE [lookup].[PostalLookup]
(
[PostalCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CityName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResCodeId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_POSTAL_LOOKUP_TBL] on [lookup].[PostalLookup]'
GO
ALTER TABLE [lookup].[PostalLookup] ADD CONSTRAINT [PK_POSTAL_LOOKUP_TBL] PRIMARY KEY CLUSTERED ([PostalCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [POSTAL_LOOKUP_CODE_IX] on [lookup].[PostalLookup]'
GO
CREATE NONCLUSTERED INDEX [POSTAL_LOOKUP_CODE_IX] ON [lookup].[PostalLookup] ([PostalCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [disc].[ReadPlan]'
GO
CREATE TABLE [disc].[ReadPlan]
(
[Day] [int] NOT NULL,
[Section] [int] NOT NULL,
[StartBook] [int] NULL,
[StartChap] [int] NULL,
[StartVerse] [int] NULL,
[EndBook] [int] NULL,
[EndChap] [int] NULL,
[EndVerse] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ReadPlan_1] on [disc].[ReadPlan]'
GO
ALTER TABLE [disc].[ReadPlan] ADD CONSTRAINT [PK_ReadPlan_1] PRIMARY KEY CLUSTERED ([Day], [Section])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[RssFeed]'
GO
CREATE TABLE [dbo].[RssFeed]
(
[Url] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Data] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETag] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModified] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_RssFeed] on [dbo].[RssFeed]'
GO
ALTER TABLE [dbo].[RssFeed] ADD CONSTRAINT [PK_RssFeed] PRIMARY KEY CLUSTERED ([Url])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[ShirtSizes]'
GO
CREATE TABLE [lookup].[ShirtSizes]
(
[Id] [int] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ShirtSizes] on [lookup].[ShirtSizes]'
GO
ALTER TABLE [lookup].[ShirtSizes] ADD CONSTRAINT [PK_ShirtSizes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[StateLookup]'
GO
CREATE TABLE [lookup].[StateLookup]
(
[StateCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_STATE_LOOKUP_TBL] on [lookup].[StateLookup]'
GO
ALTER TABLE [lookup].[StateLookup] ADD CONSTRAINT [PK_STATE_LOOKUP_TBL] PRIMARY KEY CLUSTERED ([StateCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [STATE_LOOKUP_CODE_IX] on [lookup].[StateLookup]'
GO
CREATE NONCLUSTERED INDEX [STATE_LOOKUP_CODE_IX] ON [lookup].[StateLookup] ([StateCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [lookup].[VolunteerCodes]'
GO
CREATE TABLE [lookup].[VolunteerCodes]
(
[Id] [int] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_VolunteerCodes] on [lookup].[VolunteerCodes]'
GO
ALTER TABLE [lookup].[VolunteerCodes] ADD CONSTRAINT [PK_VolunteerCodes] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ZipCodes]'
GO
CREATE TABLE [dbo].[ZipCodes]
(
[zip] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[state] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_ZipCodes] on [dbo].[ZipCodes]'
GO
ALTER TABLE [dbo].[ZipCodes] ADD CONSTRAINT [PK_ZipCodes] PRIMARY KEY CLUSTERED ([zip])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Sprocs]'
GO

CREATE VIEW [dbo].Sprocs
AS
SELECT ROUTINE_TYPE type, ROUTINE_NAME Name, ROUTINE_DEFINITION Code
    FROM INFORMATION_SCHEMA.ROUTINES 
    WHERE ROUTINE_TYPE IN ('FUNCTION','PROCEDURE')
    AND SPECIFIC_NAME NOT LIKE 'sp_%'
    AND SPECIFIC_NAME NOT LIKE 'fn_%'


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Triggers]'
GO
CREATE VIEW dbo.Triggers
AS
SELECT TOP (100) PERCENT Tables.name AS TableName, Triggers.name AS TriggerName, Triggers.crdate AS TriggerCreatedDate, Comments.text AS TriggerText
FROM  sys.sysobjects AS Triggers INNER JOIN
               sys.sysobjects AS Tables ON Triggers.parent_obj = Tables.id INNER JOIN
               sys.syscomments AS Comments ON Triggers.id = Comments.id
WHERE (Triggers.xtype = 'TR') AND (Tables.xtype = 'U')
ORDER BY TableName, TriggerName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[DisableForeignKeys]'
GO
CREATE PROCEDURE [dbo].[DisableForeignKeys]
    @disable BIT = 1
AS
    DECLARE
        @sql VARCHAR(500),
        @tableName VARCHAR(128),
        @foreignKeyName VARCHAR(128),
		@schema varchar(50)

    -- A list of all foreign keys and table names
    DECLARE foreignKeyCursor CURSOR
    FOR SELECT
        ref.constraint_name AS FK_Name,
        fk.table_name AS FK_Table,
		ref.Constraint_schema as FK_Schema
    FROM
        INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS ref
        INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS fk 
    ON ref.constraint_name = fk.constraint_name
    ORDER BY
        fk.table_name,
        ref.constraint_name 

    OPEN foreignKeyCursor

    FETCH NEXT FROM foreignKeyCursor 
    INTO @foreignKeyName, @tableName, @schema

    WHILE ( @@FETCH_STATUS = 0 )
        BEGIN
            IF @disable = 1
                SET @sql = 'ALTER TABLE ' + @schema + '.[' 
                    + @tableName + '] NOCHECK CONSTRAINT ['
                    + @foreignKeyName + ']'
            ELSE
                SET @sql = 'ALTER TABLE ' + @schema + '.[' 
                    + @tableName + '] CHECK CONSTRAINT ['
                    + @foreignKeyName + ']'

        PRINT 'Executing Statement - ' + @sql

        EXECUTE(@sql)
        FETCH NEXT FROM foreignKeyCursor 
        INTO @foreignKeyName, @tableName, @schema
    END

    CLOSE foreignKeyCursor
    DEALLOCATE foreignKeyCursor

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ShowTableSizes]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ShowTableSizes]
AS
BEGIN
CREATE TABLE #temp (
       table_name sysname ,
       row_count int,
       reserved_size varchar(50),
       data_size varchar(50),
       index_size varchar(50),
       unused_size varchar(50))
SET NOCOUNT ON
INSERT     #temp
EXEC       sp_msforeachtable 'sp_spaceused ''?'''
SELECT     b.table_schema as owner,
		   a.table_name,
           a.row_count,
           count(*) as col_count,
           a.data_size
FROM       #temp a
INNER JOIN information_schema.columns b
           ON a.table_name collate database_default
                = b.table_name collate database_default
GROUP BY   b.table_schema, a.table_name, a.row_count, a.data_size
ORDER BY   a.row_count desc
DROP TABLE #temp
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ForumNewEntry]'
GO
CREATE PROCEDURE dbo.ForumNewEntry 
(
	@forumid int, 
	@replytoid int, 
	@title nvarchar(50), 
	@entry text, 
	@created datetime, 
	@createdby nvarchar(50)
)
AS

	declare @DisplayOrder int, @DisplayDepth int, @ThreadId int, @newid int
	
	set @DisplayOrder = 1
	set @DisplayDepth = 0
	
BEGIN TRANSACTION
BEGIN TRY
	if @replytoid is not null
	BEGIN
		SELECT @DisplayOrder=DisplayOrder, @DisplayDepth=DisplayDepth, @ThreadId = ThreadId, @forumid = ForumId
		FROM dbo.ForumEntry 
		WHERE Id=@replytoid
		
		
		-- Find the next entry at the same level or closer to root
		SELECT @DisplayOrder = Min(DisplayOrder)
		FROM dbo.ForumEntry
		WHERE DisplayOrder > @DisplayOrder -- after this entry
		AND DisplayDepth <= @DisplayDepth -- beyond the children
		AND ThreadID = @ThreadID
		
	    IF @DisplayOrder IS NOT NULL
		BEGIN
			-- Move the existing Entries down
			UPDATE dbo.ForumEntry
			SET DisplayOrder = DisplayOrder + 1
			WHERE ThreadID = @ThreadID
			AND DisplayOrder >= @DisplayOrder
		END
		ELSE -- There are no BlogComments at this level or above
		BEGIN
    		-- Find the highest sort order for this parent
    		SELECT @DisplayOrder = MAX(DisplayOrder) + 1
    		FROM dbo.ForumEntry
    		WHERE ThreadID = @ThreadID
		END 
	END
	
	INSERT into dbo.ForumEntry (Title, Entry, ReplyToId, ForumId, ThreadId, DisplayOrder, DisplayDepth, CreatedOn, CreatedBy)
	values (@title, @entry, @replytoid, @forumid, @ThreadId, @DisplayOrder, @DisplayDepth+1, @created, @createdby)
	
	set @newid = scope_identity()
	
	if @ThreadId is null
	begin
		update dbo.ForumEntry set ThreadId = @newid where id = @newid
	end
	
END TRY
BEGIN CATCH
	ROLLBACK

	DECLARE @ErrorMessage NVARCHAR(400);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

	RETURN
END CATCH

COMMIT

	Select * from dbo.ForumEntry where Id = @newid

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[BundleDetail]'
GO
ALTER TABLE [dbo].[BundleDetail] WITH NOCHECK ADD
CONSTRAINT [BUNDLE_DETAIL_BUNDLE_FK] FOREIGN KEY ([BundleHeaderId]) REFERENCES [dbo].[BundleHeader] ([BundleHeaderId]),
CONSTRAINT [BUNDLE_DETAIL_CONTR_FK] FOREIGN KEY ([ContributionId]) REFERENCES [dbo].[Contribution] ([ContributionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[EnrollmentTransaction]'
GO
ALTER TABLE [dbo].[EnrollmentTransaction] WITH NOCHECK ADD
CONSTRAINT [ENROLLMENT_TRANSACTION_ORG_FK] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organizations] ([OrganizationId]),
CONSTRAINT [ENROLLMENT_TRANSACTION_PPL_FK] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_ENROLLMENT_TRANSACTION_TBL_MemberType] FOREIGN KEY ([MemberTypeId]) REFERENCES [lookup].[MemberType] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[RelatedFamilies]'
GO
ALTER TABLE [dbo].[RelatedFamilies] WITH NOCHECK ADD
CONSTRAINT [RelatedFamilies1__RelatedFamily1] FOREIGN KEY ([FamilyId]) REFERENCES [dbo].[Families] ([FamilyId]),
CONSTRAINT [RelatedFamilies2__RelatedFamily2] FOREIGN KEY ([RelatedFamilyId]) REFERENCES [dbo].[Families] ([FamilyId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Meetings]'
GO
ALTER TABLE [dbo].[Meetings] WITH NOCHECK ADD
CONSTRAINT [FK_MEETINGS_TBL_ORGANIZATIONS_TBL] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[OrganizationMembers]'
GO
ALTER TABLE [dbo].[OrganizationMembers] WITH NOCHECK ADD
CONSTRAINT [FK_ORGANIZATION_MEMBERS_TBL_MemberType] FOREIGN KEY ([MemberTypeId]) REFERENCES [lookup].[MemberType] ([Id]),
CONSTRAINT [ORGANIZATION_MEMBERS_ORG_FK] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organizations] ([OrganizationId]),
CONSTRAINT [ORGANIZATION_MEMBERS_PPL_FK] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Organizations]'
GO
ALTER TABLE [dbo].[Organizations] WITH NOCHECK ADD
CONSTRAINT [ChildOrgs__ParentOrg] FOREIGN KEY ([ParentOrgId]) REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[TagPerson]'
GO
ALTER TABLE [dbo].[TagPerson] WITH NOCHECK ADD
CONSTRAINT [Tags__Person] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [PersonTags__Tag] FOREIGN KEY ([Id]) REFERENCES [dbo].[Tag] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[QueryBuilderClauses]'
GO
ALTER TABLE [dbo].[QueryBuilderClauses] WITH NOCHECK ADD
CONSTRAINT [Clauses__Parent] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[QueryBuilderClauses] ([QueryId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Tag]'
GO
ALTER TABLE [dbo].[Tag] WITH NOCHECK ADD
CONSTRAINT [Tags__TagType] FOREIGN KEY ([TypeId]) REFERENCES [dbo].[TagType] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[ActivityLog]'
GO
ALTER TABLE [dbo].[ActivityLog] ADD
CONSTRAINT [FK_ActivityLog_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Attend]'
GO
ALTER TABLE [dbo].[Attend] ADD
CONSTRAINT [FK_AttendWithAbsents_TBL_PEOPLE_TBL] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_AttendWithAbsents_TBL_MEETINGS_TBL] FOREIGN KEY ([MeetingId]) REFERENCES [dbo].[Meetings] ([MeetingId]),
CONSTRAINT [FK_AttendWithAbsents_TBL_ORGANIZATIONS_TBL] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organizations] ([OrganizationId]),
CONSTRAINT [FK_AttendWithAbsents_TBL_AttendType] FOREIGN KEY ([AttendanceTypeId]) REFERENCES [lookup].[AttendType] ([Id]),
CONSTRAINT [FK_Attend_MemberType] FOREIGN KEY ([MemberTypeId]) REFERENCES [lookup].[MemberType] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Organizations]'
GO
ALTER TABLE [dbo].[Organizations] ADD
CONSTRAINT [FK_Organizations_AttendTrackLevel] FOREIGN KEY ([AttendTrkLevelId]) REFERENCES [lookup].[AttendTrackLevel] ([Id]),
CONSTRAINT [FK_Organizations_Campus] FOREIGN KEY ([CampusId]) REFERENCES [lookup].[Campus] ([Id]),
CONSTRAINT [FK_Organizations_Division] FOREIGN KEY ([DivisionId]) REFERENCES [dbo].[Division] ([Id]),
CONSTRAINT [FK_ORGANIZATIONS_TBL_EntryPoint] FOREIGN KEY ([EntryPointId]) REFERENCES [lookup].[EntryPoint] ([Id]),
CONSTRAINT [FK_Organizations_Gender] FOREIGN KEY ([GenderId]) REFERENCES [lookup].[Gender] ([Id]),
CONSTRAINT [FK_ORGANIZATIONS_TBL_OrganizationStatus] FOREIGN KEY ([OrganizationStatusId]) REFERENCES [lookup].[OrganizationStatus] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [lookup].[MemberType]'
GO
ALTER TABLE [lookup].[MemberType] ADD
CONSTRAINT [FK_MemberType_AttendType] FOREIGN KEY ([AttendanceTypeId]) REFERENCES [lookup].[AttendType] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[AuditValues]'
GO
ALTER TABLE [dbo].[AuditValues] ADD
CONSTRAINT [FK_AuditValues_Audits] FOREIGN KEY ([AuditId]) REFERENCES [dbo].[Audits] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[BadET]'
GO
ALTER TABLE [dbo].[BadET] ADD
CONSTRAINT [FK_BadET_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_BadET_Organizations] FOREIGN KEY ([OrgId]) REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[People]'
GO
ALTER TABLE [dbo].[People] ADD
CONSTRAINT [FK_People_BaptismStatus] FOREIGN KEY ([BaptismStatusId]) REFERENCES [lookup].[BaptismStatus] ([Id]),
CONSTRAINT [FK_People_BaptismType] FOREIGN KEY ([BaptismTypeId]) REFERENCES [lookup].[BaptismType] ([Id]),
CONSTRAINT [FK_People_Campus] FOREIGN KEY ([CampusId]) REFERENCES [lookup].[Campus] ([Id]),
CONSTRAINT [FK_People_DecisionType] FOREIGN KEY ([DecisionTypeId]) REFERENCES [lookup].[DecisionType] ([Id]),
CONSTRAINT [FK_People_DiscoveryClassStatus] FOREIGN KEY ([DiscoveryClassStatusId]) REFERENCES [lookup].[DiscoveryClassStatus] ([Id]),
CONSTRAINT [FK_People_DropType] FOREIGN KEY ([DropCodeId]) REFERENCES [lookup].[DropType] ([Id]),
CONSTRAINT [FK_People_EntryPoint] FOREIGN KEY ([EntryPointId]) REFERENCES [lookup].[EntryPoint] ([Id]),
CONSTRAINT [EnvPeople__EnvelopeOption] FOREIGN KEY ([EnvelopeOptionsId]) REFERENCES [lookup].[EnvelopeOption] ([Id]),
CONSTRAINT [StmtPeople__ContributionStatementOption] FOREIGN KEY ([ContributionOptionsId]) REFERENCES [lookup].[EnvelopeOption] ([Id]),
CONSTRAINT [FK_People_Families] FOREIGN KEY ([FamilyId]) REFERENCES [dbo].[Families] ([FamilyId]),
CONSTRAINT [FK_People_FamilyPosition] FOREIGN KEY ([PositionInFamilyId]) REFERENCES [lookup].[FamilyPosition] ([Id]),
CONSTRAINT [FK_People_Gender] FOREIGN KEY ([GenderId]) REFERENCES [lookup].[Gender] ([Id]),
CONSTRAINT [FK_People_InterestPoint] FOREIGN KEY ([InterestPointId]) REFERENCES [lookup].[InterestPoint] ([Id]),
CONSTRAINT [FK_People_JoinType] FOREIGN KEY ([JoinCodeId]) REFERENCES [lookup].[JoinType] ([Id]),
CONSTRAINT [FK_People_MaritalStatus] FOREIGN KEY ([MaritalStatusId]) REFERENCES [lookup].[MaritalStatus] ([Id]),
CONSTRAINT [FK_People_MemberLetterStatus] FOREIGN KEY ([LetterStatusId]) REFERENCES [lookup].[MemberLetterStatus] ([Id]),
CONSTRAINT [FK_People_MemberStatus] FOREIGN KEY ([MemberStatusId]) REFERENCES [lookup].[MemberStatus] ([Id]),
CONSTRAINT [BFMembers__BFClass] FOREIGN KEY ([BibleFellowshipClassId]) REFERENCES [dbo].[Organizations] ([OrganizationId]),
CONSTRAINT [FK_People_Origin] FOREIGN KEY ([OriginId]) REFERENCES [lookup].[Origin] ([Id]),
CONSTRAINT [ResCodePeople__ResidentCode] FOREIGN KEY ([ResCodeId]) REFERENCES [lookup].[ResidentCode] ([Id]),
CONSTRAINT [AltResCodePeople__AltResidentCode] FOREIGN KEY ([AltResCodeId]) REFERENCES [lookup].[ResidentCode] ([Id]),
CONSTRAINT [FK_PEOPLE_TBL_Picture] FOREIGN KEY ([PictureId]) REFERENCES [dbo].[Picture] ([PictureId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[BlogNotify]'
GO
ALTER TABLE [disc].[BlogNotify] ADD
CONSTRAINT [FK_BlogNotify_Blog] FOREIGN KEY ([BlogId]) REFERENCES [disc].[Blog] ([Id]),
CONSTRAINT [FK_BlogNotify_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[BlogPost]'
GO
ALTER TABLE [disc].[BlogPost] ADD
CONSTRAINT [FK_BlogPost_Blog] FOREIGN KEY ([BlogId]) REFERENCES [disc].[Blog] ([Id]),
CONSTRAINT [FK_BlogPost_Users] FOREIGN KEY ([PosterId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[OtherNotify]'
GO
ALTER TABLE [disc].[OtherNotify] ADD
CONSTRAINT [FK_OtherNotify_Blog] FOREIGN KEY ([BlogId]) REFERENCES [disc].[Blog] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[Blog]'
GO
ALTER TABLE [disc].[Blog] ADD
CONSTRAINT [FK_Blog_Group] FOREIGN KEY ([GroupId]) REFERENCES [disc].[Group] ([Id]),
CONSTRAINT [FK_Blog_Users] FOREIGN KEY ([OwnerId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[BlogCategoryXref]'
GO
ALTER TABLE [disc].[BlogCategoryXref] ADD
CONSTRAINT [FK_BlogCategoryXref_Category] FOREIGN KEY ([CatId]) REFERENCES [disc].[BlogCategory] ([Id]),
CONSTRAINT [FK_BlogCategoryXref_BlogPost] FOREIGN KEY ([BlogPostId]) REFERENCES [disc].[BlogPost] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[BlogComment]'
GO
ALTER TABLE [disc].[BlogComment] ADD
CONSTRAINT [FK_BlogComment_BlogPost] FOREIGN KEY ([BlogPostId]) REFERENCES [disc].[BlogPost] ([Id]),
CONSTRAINT [FK_BlogComment_Users] FOREIGN KEY ([PosterId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[PodCast]'
GO
ALTER TABLE [disc].[PodCast] ADD
CONSTRAINT [FK_PodCast_BlogPost] FOREIGN KEY ([postId]) REFERENCES [disc].[BlogPost] ([Id]),
CONSTRAINT [FK_PodCast_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[BundleHeader]'
GO
ALTER TABLE [dbo].[BundleHeader] ADD
CONSTRAINT [FK_BUNDLE_HEADER_TBL_BundleStatusTypes] FOREIGN KEY ([BundleStatusId]) REFERENCES [lookup].[BundleStatusTypes] ([Id]),
CONSTRAINT [FK_BUNDLE_HEADER_TBL_BundleHeaderTypes] FOREIGN KEY ([BundleHeaderTypeId]) REFERENCES [lookup].[BundleHeaderTypes] ([Id]),
CONSTRAINT [BundleHeaders__Fund] FOREIGN KEY ([FundId]) REFERENCES [dbo].[ContributionFund] ([FundId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[CardIdentifiers]'
GO
ALTER TABLE [dbo].[CardIdentifiers] ADD
CONSTRAINT [FK_CardIdentifiers_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[CheckInTimes]'
GO
ALTER TABLE [dbo].[CheckInTimes] ADD
CONSTRAINT [FK_CheckInTimes_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_CheckInTimes_Organizations] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Contactees]'
GO
ALTER TABLE [dbo].[Contactees] ADD
CONSTRAINT [contactees__contact] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[NewContact] ([ContactId]),
CONSTRAINT [contactsHad__person] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Contactors]'
GO
ALTER TABLE [dbo].[Contactors] ADD
CONSTRAINT [contactsMakers__contact] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[NewContact] ([ContactId]),
CONSTRAINT [contactsMade__person] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Contribution]'
GO
ALTER TABLE [dbo].[Contribution] ADD
CONSTRAINT [FK_Contribution_ContributionFund] FOREIGN KEY ([FundId]) REFERENCES [dbo].[ContributionFund] ([FundId]),
CONSTRAINT [FK_Contribution_ContributionType] FOREIGN KEY ([ContributionTypeId]) REFERENCES [lookup].[ContributionType] ([Id]),
CONSTRAINT [FK_Contribution_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_Contribution_ContributionStatus] FOREIGN KEY ([ContributionStatusId]) REFERENCES [lookup].[ContributionStatus] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[DivOrg]'
GO
ALTER TABLE [dbo].[DivOrg] ADD
CONSTRAINT [FK_DivOrg_Division] FOREIGN KEY ([DivId]) REFERENCES [dbo].[Division] ([Id]),
CONSTRAINT [FK_DivOrg_Organizations] FOREIGN KEY ([OrgId]) REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[RecLeague]'
GO
ALTER TABLE [dbo].[RecLeague] ADD
CONSTRAINT [FK_RecLeague_Division] FOREIGN KEY ([DivId]) REFERENCES [dbo].[Division] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Promotion]'
GO
ALTER TABLE [dbo].[Promotion] ADD
CONSTRAINT [FromPromotions__FromDivision] FOREIGN KEY ([FromDivId]) REFERENCES [dbo].[Division] ([Id]),
CONSTRAINT [ToPromotions__ToDivision] FOREIGN KEY ([ToDivId]) REFERENCES [dbo].[Division] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Division]'
GO
ALTER TABLE [dbo].[Division] ADD
CONSTRAINT [FK_Division_Program] FOREIGN KEY ([ProgId]) REFERENCES [dbo].[Program] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[EmailOptOut]'
GO
ALTER TABLE [dbo].[EmailOptOut] ADD
CONSTRAINT [FK_EmailOptOut_People] FOREIGN KEY ([ToPeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[EnrollmentTransaction]'
GO
ALTER TABLE [dbo].[EnrollmentTransaction] ADD
CONSTRAINT [DescTransactions__FirstTransaction] FOREIGN KEY ([EnrollmentTransactionId]) REFERENCES [dbo].[EnrollmentTransaction] ([TransactionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Families]'
GO
ALTER TABLE [dbo].[Families] ADD
CONSTRAINT [ResCodeFamilies__ResidentCode] FOREIGN KEY ([ResCodeId]) REFERENCES [lookup].[ResidentCode] ([Id]),
CONSTRAINT [AltResCodeFamilies__AltResidentCode] FOREIGN KEY ([AltResCodeId]) REFERENCES [lookup].[ResidentCode] ([Id]),
CONSTRAINT [FamiliesHeaded__HeadOfHousehold] FOREIGN KEY ([HeadOfHouseholdId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FamiliesHeaded2__HeadOfHouseholdSpouse] FOREIGN KEY ([HeadOfHouseholdSpouseId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[ForumEntry]'
GO
ALTER TABLE [disc].[ForumEntry] ADD
CONSTRAINT [FK_ForumEntry_Forum] FOREIGN KEY ([ForumId]) REFERENCES [disc].[Forum] ([Id]),
CONSTRAINT [Replies__RepliedTo] FOREIGN KEY ([ReplyToId]) REFERENCES [disc].[ForumEntry] ([Id]),
CONSTRAINT [ThreadEntries__ThreadPost] FOREIGN KEY ([ThreadId]) REFERENCES [disc].[ForumEntry] ([Id]),
CONSTRAINT [FK_ForumEntry_Users] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[Forum]'
GO
ALTER TABLE [disc].[Forum] ADD
CONSTRAINT [FK_Forum_Group] FOREIGN KEY ([GroupId]) REFERENCES [disc].[Group] ([Id]),
CONSTRAINT [FK_Forum_Users] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[ForumNotify]'
GO
ALTER TABLE [disc].[ForumNotify] ADD
CONSTRAINT [FK_ForumNotify_ForumEntry] FOREIGN KEY ([ThreadId]) REFERENCES [disc].[ForumEntry] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[ForumUserRead]'
GO
ALTER TABLE [disc].[ForumUserRead] ADD
CONSTRAINT [FK_ForumUserRead_ForumEntry] FOREIGN KEY ([ForumEntryId]) REFERENCES [disc].[ForumEntry] ([Id]),
CONSTRAINT [FK_ForumUserRead_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[GroupRoles]'
GO
ALTER TABLE [disc].[GroupRoles] ADD
CONSTRAINT [FK_GroupRoles_Group] FOREIGN KEY ([GroupId]) REFERENCES [disc].[Group] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[Invitation]'
GO
ALTER TABLE [disc].[Invitation] ADD
CONSTRAINT [FK_Invitation_Group] FOREIGN KEY ([GroupId]) REFERENCES [disc].[Group] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[Group]'
GO
ALTER TABLE [disc].[Group] ADD
CONSTRAINT [Groups__WelcomeText] FOREIGN KEY ([ContentId]) REFERENCES [disc].[ParaContent] ([ContentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[UserGroupRole]'
GO
ALTER TABLE [disc].[UserGroupRole] ADD
CONSTRAINT [FK_UserGroupRole_GroupRoles] FOREIGN KEY ([RoleId]) REFERENCES [disc].[GroupRoles] ([RoleId]),
CONSTRAINT [FK_UserGroupRole_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[LoveRespect]'
GO
ALTER TABLE [dbo].[LoveRespect] ADD
CONSTRAINT [HisLoveRespects__Him] FOREIGN KEY ([HimId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [HerLoveRespects__Her] FOREIGN KEY ([HerId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_LoveRespect_Organizations] FOREIGN KEY ([OrgId]) REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[SoulMate]'
GO
ALTER TABLE [dbo].[SoulMate] ADD
CONSTRAINT [ChildSoulMates__ChildCareMeeting] FOREIGN KEY ([ChildcareId]) REFERENCES [dbo].[Meetings] ([MeetingId]),
CONSTRAINT [FK_SoulMate_Meetings] FOREIGN KEY ([EventId]) REFERENCES [dbo].[Meetings] ([MeetingId]),
CONSTRAINT [HerSoulMates__Her] FOREIGN KEY ([HerId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [HisSoulMates__Him] FOREIGN KEY ([HimId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[MOBSReg]'
GO
ALTER TABLE [dbo].[MOBSReg] ADD
CONSTRAINT [FK_MOBSReg_Meeting] FOREIGN KEY ([MeetingId]) REFERENCES [dbo].[Meetings] ([MeetingId]),
CONSTRAINT [FK_Attender_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[OrgMemMemTags]'
GO
ALTER TABLE [dbo].[OrgMemMemTags] ADD
CONSTRAINT [FK_OrgMemMemTags_MemberTags] FOREIGN KEY ([MemberTagId]) REFERENCES [dbo].[MemberTags] ([Id]),
CONSTRAINT [FK_OrgMemMemTags_OrganizationMembers] FOREIGN KEY ([OrgId], [PeopleId]) REFERENCES [dbo].[OrganizationMembers] ([OrganizationId], [PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[MemberTags]'
GO
ALTER TABLE [dbo].[MemberTags] ADD
CONSTRAINT [FK_MemberTags_Organizations] FOREIGN KEY ([OrgId]) REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[NewContact]'
GO
ALTER TABLE [dbo].[NewContact] ADD
CONSTRAINT [FK_Contacts_Ministries] FOREIGN KEY ([MinistryId]) REFERENCES [dbo].[Ministries] ([MinistryId]),
CONSTRAINT [FK_Contacts_ContactTypes] FOREIGN KEY ([ContactTypeId]) REFERENCES [lookup].[NewContactType] ([Id]),
CONSTRAINT [FK_NewContacts_ContactReasons] FOREIGN KEY ([ContactReasonId]) REFERENCES [lookup].[NewContactReason] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Task]'
GO
ALTER TABLE [dbo].[Task] ADD
CONSTRAINT [TasksAssigned__SourceContact] FOREIGN KEY ([SourceContactId]) REFERENCES [dbo].[NewContact] ([ContactId]),
CONSTRAINT [TasksCompleted__CompletedContact] FOREIGN KEY ([CompletedContactId]) REFERENCES [dbo].[NewContact] ([ContactId]),
CONSTRAINT [Tasks__Owner] FOREIGN KEY ([OwnerId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [TasksAboutPerson__AboutWho] FOREIGN KEY ([WhoId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [TasksCoOwned__CoOwner] FOREIGN KEY ([CoOwnerId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [Tasks__TaskList] FOREIGN KEY ([ListId]) REFERENCES [dbo].[TaskList] ([Id]),
CONSTRAINT [CoTasks__CoTaskList] FOREIGN KEY ([CoListId]) REFERENCES [dbo].[TaskList] ([Id]),
CONSTRAINT [FK_Task_TaskStatus] FOREIGN KEY ([StatusId]) REFERENCES [lookup].[TaskStatus] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[PageContent]'
GO
ALTER TABLE [disc].[PageContent] ADD
CONSTRAINT [CreatedPages__CreatedBy] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[Users] ([UserId]),
CONSTRAINT [ModifiedPages__ModifiedBy] FOREIGN KEY ([ModifiedById]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[PageVisit]'
GO
ALTER TABLE [disc].[PageVisit] ADD
CONSTRAINT [FK_PageVisit_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[PendingNotifications]'
GO
ALTER TABLE [disc].[PendingNotifications] ADD
CONSTRAINT [FK_PendingNotifications_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[PeopleExtra]'
GO
ALTER TABLE [dbo].[PeopleExtra] ADD
CONSTRAINT [FK_PeopleExtra_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[PrayerSlot]'
GO
ALTER TABLE [disc].[PrayerSlot] ADD
CONSTRAINT [FK_PrayerSlot_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[RecReg]'
GO
ALTER TABLE [dbo].[RecReg] ADD
CONSTRAINT [FK_RecReg_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[SaleTransaction]'
GO
ALTER TABLE [dbo].[SaleTransaction] ADD
CONSTRAINT [FK_SaleTransaction_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_SaleTransaction_SaleItem] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[SaleItem] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[TagShare]'
GO
ALTER TABLE [dbo].[TagShare] ADD
CONSTRAINT [FK_TagShare_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_TagShare_Tag] FOREIGN KEY ([TagId]) REFERENCES [dbo].[Tag] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[TaskListOwners]'
GO
ALTER TABLE [dbo].[TaskListOwners] ADD
CONSTRAINT [FK_TaskListOwners_PEOPLE_TBL] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_TaskListOwners_TaskList] FOREIGN KEY ([TaskListId]) REFERENCES [dbo].[TaskList] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD
CONSTRAINT [FK_Users_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[VBSApp]'
GO
ALTER TABLE [dbo].[VBSApp] ADD
CONSTRAINT [FK_VBSApp_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[VolInterestInterestCodes]'
GO
ALTER TABLE [dbo].[VolInterestInterestCodes] ADD
CONSTRAINT [FK_VolInterestInterestCodes_People] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_VolInterestInterestCodes_VolInterestCodes] FOREIGN KEY ([InterestCodeId]) REFERENCES [dbo].[VolInterestCodes] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Volunteer]'
GO
ALTER TABLE [dbo].[Volunteer] ADD
CONSTRAINT [FK_Volunteer_PEOPLE_TBL] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [FK_Volunteer_VolApplicationStatus] FOREIGN KEY ([StatusId]) REFERENCES [lookup].[VolApplicationStatus] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[VolunteerForm]'
GO
ALTER TABLE [dbo].[VolunteerForm] ADD
CONSTRAINT [FK_VolunteerForm_PEOPLE_TBL] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId]),
CONSTRAINT [VolunteerFormsUploaded__Uploader] FOREIGN KEY ([UploaderId]) REFERENCES [dbo].[Users] ([UserId]),
CONSTRAINT [FK_VolunteerForm_Volunteer1] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[Volunteer] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Tag]'
GO
ALTER TABLE [dbo].[Tag] ADD
CONSTRAINT [TagsOwned__PersonOwner] FOREIGN KEY ([PeopleId]) REFERENCES [dbo].[People] ([PeopleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Preferences]'
GO
ALTER TABLE [dbo].[Preferences] ADD
CONSTRAINT [FK_UserPreferences_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Zips]'
GO
ALTER TABLE [dbo].[Zips] ADD
CONSTRAINT [FK_Zips_ResidentCode] FOREIGN KEY ([MetroMarginalCode]) REFERENCES [lookup].[ResidentCode] ([Id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[UserRole]'
GO
ALTER TABLE [dbo].[UserRole] ADD
CONSTRAINT [FK_UserRole_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleId]),
CONSTRAINT [FK_UserRole_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[TemporaryToken]'
GO
ALTER TABLE [disc].[TemporaryToken] ADD
CONSTRAINT [FK_TemporaryToken_Users] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[UserCanEmailFor]'
GO
ALTER TABLE [dbo].[UserCanEmailFor] ADD
CONSTRAINT [UsersICanEmailFor__Assistant] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId]),
CONSTRAINT [UsersWhoCanEmailForMe__Boss] FOREIGN KEY ([CanEmailFor]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[Verse]'
GO
ALTER TABLE [disc].[Verse] ADD
CONSTRAINT [FK_Verse_Users] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[VerseCategory]'
GO
ALTER TABLE [disc].[VerseCategory] ADD
CONSTRAINT [FK_VerseCategory_Users] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [disc].[VerseCategoryXref]'
GO
ALTER TABLE [disc].[VerseCategoryXref] ADD
CONSTRAINT [FK_VerseCategoryXref_Verse] FOREIGN KEY ([VerseId]) REFERENCES [disc].[Verse] ([id]),
CONSTRAINT [FK_VerseCategoryXref_VerseCategory] FOREIGN KEY ([VerseCategoryId]) REFERENCES [disc].[VerseCategory] ([id])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updDivision] on [dbo].[Division]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[updDivision] 
   ON  [dbo].[Division] 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	IF UPDATE(ProgId)
	BEGIN
		UPDATE dbo.People
		SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
		FROM dbo.People p
		JOIN dbo.OrganizationMembers m ON p.PeopleId = m.PeopleId
		JOIN dbo.Organizations o ON m.OrganizationId = o.OrganizationId
		JOIN dbo.DivOrg x ON o.OrganizationId = x.OrgId
		JOIN INSERTED i ON i.Id = x.DivId
		JOIN DELETED d ON d.Id = x.DivId
		JOIN Program pr ON i.ProgId = pr.Id OR d.ProgId = pr.Id
		WHERE pr.BFProgram = 1
	END
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updDivOrg] on [dbo].[DivOrg]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[updDivOrg] 
   ON  [dbo].[DivOrg] 
   AFTER INSERT, DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.People
	SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
	FROM dbo.People p
	JOIN dbo.OrganizationMembers m ON p.PeopleId = m.PeopleId
	JOIN dbo.Organizations o ON m.OrganizationId = o.OrganizationId
	JOIN INSERTED x ON o.OrganizationId = x.OrgId
	JOIN dbo.Division d ON d.Id = x.DivId
	JOIN Program pr ON d.ProgId = pr.Id
	WHERE pr.BFProgram = 1

	UPDATE dbo.People
	SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
	FROM dbo.People p
	JOIN dbo.OrganizationMembers m ON p.PeopleId = m.PeopleId
	JOIN dbo.Organizations o ON m.OrganizationId = o.OrganizationId
	JOIN DELETED x ON o.OrganizationId = x.OrgId
	JOIN dbo.Division d ON d.Id = x.DivId
	JOIN Program pr ON d.ProgId = pr.Id
	WHERE pr.BFProgram = 1

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[insEnrollmentTransaction] on [dbo].[EnrollmentTransaction]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[insEnrollmentTransaction] 
   ON  [dbo].[EnrollmentTransaction] 
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tid INT, @trandt DATETIME, @typeid INT, @orgid INT, @pid INT

	DECLARE c CURSOR FORWARD_ONLY FOR
	SELECT TransactionId, TransactionDate, TransactionTypeId, OrganizationId, PeopleId 
	FROM inserted 
	WHERE TransactionTypeId > 2

	OPEN c
	FETCH NEXT FROM c INTO @tid, @trandt, @typeid, @orgid, @pid
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.LinkEnrollmentTransaction @tid, @trandt, @typeid, @orgid, @pid
		FETCH NEXT FROM c INTO @tid, @trandt, @typeid, @orgid, @pid
	END
	CLOSE c
	DEALLOCATE c
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updFamily] on [dbo].[Families]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[updFamily] 
   ON  [dbo].[Families] 
   FOR UPDATE, INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF UPDATE(HomePhone)
	BEGIN
		UPDATE dbo.People
		SET HomePhone = f.HomePhone
		FROM dbo.People p
		JOIN dbo.Families f ON p.FamilyId = f.FamilyId
		WHERE f.FamilyId IN (SELECT FamilyId FROM INSERTED)
		
		UPDATE dbo.Families
		SET HomePhoneLU = RIGHT(HomePhone, 7),
			HomePhoneAC = LEFT(RIGHT(REPLICATE('0',10) + HomePhone, 10), 3)
		WHERE FamilyId IN (SELECT FamilyId FROM INSERTED)
	END
	
	IF UPDATE(CityName) 
	OR UPDATE(AltCityName)
	OR UPDATE(AddressLineOne) 
	OR UPDATE(AltAddressLineOne)
	OR UPDATE(AddressLineTwo) 
	OR UPDATE(AltAddressLineTwo)
	OR UPDATE(StateCode) 
	OR UPDATE(AltStateCode)
	OR UPDATE(ZipCode)
	OR UPDATE(AltZipCode)
	OR UPDATE(BadAddressFlag) 
	OR UPDATE(AltBadAddressFlag)
	OR UPDATE(ResCodeId) 
	OR UPDATE(AltResCodeId)
	BEGIN
		UPDATE dbo.People
		SET PrimaryCity = dbo.PrimaryCity(PeopleId),
		PrimaryAddress = dbo.PrimaryAddress(PeopleId),
		PrimaryAddress2 = dbo.PrimaryAddress2(PeopleId),
		PrimaryState = dbo.PrimaryState(PeopleId),
		PrimaryBadAddrFlag = dbo.PrimaryBadAddressFlag(PeopleId),
		PrimaryResCode = dbo.PrimaryResCode(PeopleId),
		PrimaryZip = dbo.PrimaryZip(PeopleId)
		WHERE FamilyId IN (SELECT FamilyId FROM inserted)
	END

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[delOrganizationMember] on [dbo].[OrganizationMembers]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE TRIGGER [dbo].[delOrganizationMember] 
   ON  [dbo].[OrganizationMembers]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE dbo.Organizations
	SET MemberCount = dbo.OrganizationMemberCount(OrganizationId)
	WHERE OrganizationId IN 
	(SELECT OrganizationId FROM DELETED GROUP BY OrganizationId)

	UPDATE dbo.People
	SET Grade = dbo.SchoolGrade(PeopleId)
	WHERE PeopleId IN (SELECT PeopleId FROM DELETED)

	DECLARE c CURSOR FOR
	SELECT d.OrganizationId, MemberTypeId, o.LeaderMemberTypeId FROM DELETED d
	JOIN dbo.Organizations o ON o.OrganizationId = d.OrganizationId
	OPEN c;
	DECLARE @oid INT, @mt INT, @lmt INT
	FETCH NEXT FROM c INTO @oid, @mt, @lmt;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@mt = @lmt)
		BEGIN
			UPDATE dbo.Organizations
			SET LeaderId = dbo.OrganizationLeaderId(OrganizationId),
			LeaderName = dbo.OrganizationLeaderName(OrganizationId)
			WHERE OrganizationId = @oid
			
			UPDATE dbo.People
			SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
			FROM dbo.People p
			JOIN dbo.OrganizationMembers om ON p.PeopleId = om.PeopleId
			WHERE om.OrganizationId = @oid
		END
		FETCH NEXT FROM c INTO @oid, @mt, @lmt;
	END;
	CLOSE c;
	DEALLOCATE c;

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[insOrganizationMember] on [dbo].[OrganizationMembers]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE TRIGGER [dbo].[insOrganizationMember] 
   ON  [dbo].[OrganizationMembers]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE dbo.Organizations
	SET MemberCount = dbo.OrganizationMemberCount(OrganizationId)
	WHERE OrganizationId IN 
	(SELECT OrganizationId FROM INSERTED GROUP BY OrganizationId)

	UPDATE dbo.People
	SET Grade = dbo.SchoolGrade(PeopleId)
	WHERE PeopleId IN (SELECT PeopleId FROM INSERTED)

	DECLARE c CURSOR FOR
	SELECT d.OrganizationId, MemberTypeId, o.LeaderMemberTypeId FROM INSERTED d
	JOIN dbo.Organizations o ON o.OrganizationId = d.OrganizationId
	OPEN c;
	DECLARE @oid INT, @mt INT, @lmt INT
	FETCH NEXT FROM c INTO @oid, @mt, @lmt;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@mt = @lmt)
			UPDATE dbo.Organizations
			SET LeaderId = dbo.OrganizationLeaderId(OrganizationId),
			LeaderName = dbo.OrganizationLeaderName(OrganizationId)
			WHERE OrganizationId = @oid

			UPDATE dbo.People
			SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
			FROM dbo.People p
			JOIN dbo.OrganizationMembers om ON p.PeopleId = om.PeopleId
			WHERE om.OrganizationId = @oid
		FETCH NEXT FROM c INTO @oid, @mt, @lmt;
	END;
	CLOSE c;
	DEALLOCATE c;
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updOrganizationMember] on [dbo].[OrganizationMembers]'
GO
CREATE TRIGGER [dbo].[updOrganizationMember] 
   ON  [dbo].[OrganizationMembers]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF UPDATE(Pending)
	BEGIN
		UPDATE dbo.People
		SET Grade = dbo.SchoolGrade(PeopleId) 
		WHERE PeopleId IN (SELECT PeopleId FROM INSERTED)

		UPDATE dbo.Organizations
		SET MemberCount = dbo.OrganizationMemberCount(OrganizationId)
		WHERE OrganizationId IN 
		(SELECT OrganizationId FROM INSERTED GROUP BY OrganizationId)
	END

	DECLARE c CURSOR FOR
	SELECT d.OrganizationId, d.MemberTypeId, i.MemberTypeId, o.LeaderMemberTypeId 
	FROM DELETED d
	JOIN INSERTED i ON i.OrganizationId = d.OrganizationId AND i.PeopleId = d.PeopleId
	JOIN dbo.Organizations o ON o.OrganizationId = d.OrganizationId
	
    IF UPDATE(MemberTypeId)
    OR UPDATE(Pending)
    BEGIN
		OPEN c;
		DECLARE @oid INT, @dmt INT, @imt INT, @lmt INT
		FETCH NEXT FROM c INTO @oid, @dmt, @imt, @lmt;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@dmt = @lmt OR @imt = @lmt)
			BEGIN
				UPDATE dbo.Organizations
				SET LeaderId = dbo.OrganizationLeaderId(OrganizationId),
				LeaderName = dbo.OrganizationLeaderName(OrganizationId)
				WHERE OrganizationId = @oid
				
				UPDATE dbo.People
				SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
				FROM dbo.People p
				JOIN dbo.OrganizationMembers om ON p.PeopleId = om.PeopleId
				WHERE om.OrganizationId = @oid
			END
			FETCH NEXT FROM c INTO @oid, @dmt, @imt, @lmt;
		END;
		CLOSE c;
		DEALLOCATE c;
	END

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[insOrg] on [dbo].[Organizations]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[insOrg] 
   ON  [dbo].[Organizations] 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Organizations
	SET ScheduleId = dbo.ScheduleId(SchedDay, SchedTime),
	MeetingTime = dbo.GetScheduleTime(SchedDay, SchedTime)
	WHERE OrganizationId IN (SELECT OrganizationId FROM INSERTED)
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updOrg] on [dbo].[Organizations]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[updOrg] 
   ON  [dbo].[Organizations] 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	IF UPDATE(SchedDay) OR UPDATE(SchedTime)
		UPDATE dbo.Organizations
		SET ScheduleId = dbo.ScheduleId(SchedDay, SchedTime),
		MeetingTime = dbo.GetScheduleTime(SchedDay, SchedTime)
		WHERE OrganizationId IN (SELECT OrganizationId FROM INSERTED)
	
	IF UPDATE(DivisionId)
	OR UPDATE(LeaderMemberTypeId)
	BEGIN
		UPDATE dbo.Organizations
		SET LeaderId = dbo.OrganizationLeaderId(OrganizationId),
		LeaderName = dbo.OrganizationLeaderName(OrganizationId)
		WHERE OrganizationId IN (SELECT OrganizationId FROM INSERTED)

		IF 1 IN (SELECT ISNULL(BFProgram,0) FROM dbo.Program p
				JOIN dbo.Division d ON p.Id = d.ProgId
				JOIN DELETED od ON d.Id = od.DivisionId
				JOIN INSERTED oi ON d.Id = oi.DivisionId)
		BEGIN
			UPDATE dbo.People
			SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
			FROM dbo.People p
			JOIN dbo.OrganizationMembers m ON p.PeopleId = m.PeopleId
			JOIN INSERTED o ON m.OrganizationId = o.OrganizationId
		END
	END
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[delPeople] on [dbo].[People]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[delPeople] 
   ON  [dbo].[People]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @fid INT
	DECLARE c CURSOR FOR
	SELECT FamilyId FROM deleted GROUP BY FamilyId
	OPEN c;
	FETCH NEXT FROM c INTO @fid;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE dbo.Families SET HeadOfHouseHoldId = dbo.HeadOfHouseholdId(FamilyId),
			HeadOfHouseHoldSpouseId = dbo.HeadOfHouseHoldSpouseId(FamilyId),
			CoupleFlag = dbo.CoupleFlag(FamilyId)
		WHERE FamilyId = @fid

		UPDATE dbo.People
		SET SpouseId = dbo.SpouseId(PeopleId)
		WHERE FamilyId = @fid

		DECLARE @n INT
		SELECT @n = COUNT(*) FROM dbo.People WHERE FamilyId = @fid
		IF @n = 0
		BEGIN
			DELETE dbo.RelatedFamilies WHERE @fid IN(FamilyId, RelatedFamilyId)
			DELETE dbo.Families WHERE FamilyId = @fid
		END
		FETCH NEXT FROM c INTO @fid;
	END;
	CLOSE c;
	DEALLOCATE c;

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[insPeople] on [dbo].[People]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[insPeople] 
   ON  [dbo].[People]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE dbo.Families 
	SET HeadOfHouseHoldId = dbo.HeadOfHouseholdId(FamilyId),
		HeadOfHouseHoldSpouseId = dbo.HeadOfHouseHoldSpouseId(FamilyId),
		CoupleFlag = dbo.CoupleFlag(FamilyId)
	WHERE FamilyId IN (SELECT FamilyId FROM INSERTED)
	
	UPDATE dbo.People
	SET SpouseId = dbo.SpouseId(PeopleId)
	WHERE FamilyId IN (SELECT FamilyId FROM INSERTED)

	UPDATE dbo.People
	SET HomePhone = f.HomePhone
	FROM dbo.People p JOIN dbo.Families f ON p.FamilyId = f.FamilyId
	WHERE p.PeopleId IN (SELECT PeopleId FROM INSERTED)

	UPDATE dbo.People
	SET CellPhoneLU = RIGHT(CellPhone, 7),
	CellPhoneAC = LEFT(RIGHT(REPLICATE('0',10) + CellPhone, 10), 3),
	PrimaryCity = dbo.PrimaryCity(PeopleId),
	PrimaryAddress = dbo.PrimaryAddress(PeopleId),
	PrimaryAddress2 = dbo.PrimaryAddress2(PeopleId),
	PrimaryState = dbo.PrimaryState(PeopleId),
	PrimaryBadAddrFlag = dbo.PrimaryBadAddressFlag(PeopleId),
	PrimaryResCode = dbo.PrimaryResCode(PeopleId),
	PrimaryZip = dbo.PrimaryZip(PeopleId),
	SpouseId = dbo.SpouseId(PeopleId)
	WHERE PeopleId IN (SELECT PeopleId FROM INSERTED)
		
	UPDATE dbo.Families
	SET CoupleFlag = dbo.CoupleFlag(FamilyId)
	WHERE FamilyId IN (SELECT FamilyId FROM INSERTED)
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updPeople] on [dbo].[People]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[updPeople] 
   ON  [dbo].[People]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF (
		UPDATE(PositionInFamilyId) 
		OR UPDATE(GenderId) 
		OR UPDATE(DeceasedDate) 
		OR UPDATE(FirstName)
		OR UPDATE(MaritalStatusId)
		OR UPDATE(FamilyId)
    )
	BEGIN
		UPDATE dbo.Families 
		SET HeadOfHouseHoldId = dbo.HeadOfHouseholdId(FamilyId),
			HeadOfHouseHoldSpouseId = dbo.HeadOfHouseHoldSpouseId(FamilyId),
			CoupleFlag = dbo.CoupleFlag(FamilyId)
		WHERE FamilyId IN (SELECT FamilyId FROM INSERTED)
		
		UPDATE dbo.People
		SET SpouseId = dbo.SpouseId(PeopleId)
		WHERE FamilyId IN (SELECT FamilyId FROM INSERTED)
		OR FamilyId IN (SELECT FamilyId FROM DELETED)

		IF (UPDATE(FamilyId))
		BEGIN
			DECLARE c CURSOR FOR
			SELECT FamilyId FROM deleted GROUP BY FamilyId
			OPEN c;
			DECLARE @fid INT
			FETCH NEXT FROM c INTO @fid;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @n INT
				SELECT @n = COUNT(*) FROM dbo.People WHERE FamilyId = @fid
				IF @n = 0
				BEGIN
					DELETE dbo.RelatedFamilies WHERE @fid IN(FamilyId, RelatedFamilyId)
					DELETE dbo.Families WHERE FamilyId = @fid
				END
				FETCH NEXT FROM c INTO @fid;
			END;
			CLOSE c;
			DEALLOCATE c;

			UPDATE dbo.People
			SET HomePhone = f.HomePhone
			FROM dbo.People p JOIN dbo.Families f ON p.FamilyId = f.FamilyId
			WHERE p.PeopleId IN (SELECT PeopleId FROM INSERTED)
		END

	END
    IF UPDATE(CellPhone)
	BEGIN
		UPDATE dbo.People
		SET CellPhoneLU = RIGHT(CellPhone, 7),
			CellPhoneAC = LEFT(RIGHT(REPLICATE('0',10) + CellPhone, 10), 3)
		WHERE PeopleId IN (SELECT PeopleId FROM inserted)
	END

	IF UPDATE(AddressTypeId)
	OR UPDATE(CityName) 
	OR UPDATE(AltCityName)
	OR UPDATE(AddressLineOne) 
	OR UPDATE(AltAddressLineOne)
	OR UPDATE(AddressLineTwo) 
	OR UPDATE(AltAddressLineTwo)
	OR UPDATE(StateCode) 
	OR UPDATE(AltStateCode)
	OR UPDATE(BadAddressFlag) 
	OR UPDATE(AltBadAddressFlag)
	OR UPDATE(ResCodeId) 
	OR UPDATE(AltResCodeId)
	OR UPDATE(ZipCode)
	OR UPDATE(AltZipCode)
	OR UPDATE(FamilyId)
	BEGIN
		UPDATE dbo.People
		SET PrimaryCity = dbo.PrimaryCity(PeopleId),
		PrimaryAddress = dbo.PrimaryAddress(PeopleId),
		PrimaryAddress2 = dbo.PrimaryAddress2(PeopleId),
		PrimaryState = dbo.PrimaryState(PeopleId),
		PrimaryBadAddrFlag = dbo.PrimaryBadAddressFlag(PeopleId),
		PrimaryResCode = dbo.PrimaryResCode(PeopleId),
		PrimaryZip = dbo.PrimaryZip(PeopleId)
		WHERE PeopleId IN (SELECT PeopleId FROM inserted)
	END

	IF UPDATE(FirstName)
	OR UPDATE(LastName)
	OR UPDATE(NickName)
	BEGIN
		UPDATE Users
		SET Name = dbo.UName(PeopleId),
		Name2 = dbo.UName2(PeopleId)
		WHERE PeopleId IN (SELECT PeopleId FROM INSERTED)
	END


END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updProgram] on [dbo].[Program]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[updProgram] 
   ON  [dbo].[Program] 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	IF UPDATE(BFProgram)
	BEGIN
		UPDATE dbo.People
		SET BibleFellowshipClassId = dbo.BibleFellowshipClassId(p.PeopleId)
		FROM dbo.People p
		JOIN dbo.OrganizationMembers m ON p.PeopleId = m.PeopleId
		JOIN dbo.Organizations o ON m.OrganizationId = o.OrganizationId
		JOIN dbo.DivOrg x ON o.OrganizationId = x.OrgId
		JOIN dbo.Division d ON x.DivId = d.Id
		JOIN INSERTED pr ON pr.Id = d.ProgId
		WHERE pr.BFProgram = 1
	END
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating trigger [dbo].[updUser] on [dbo].[Users]'
GO
CREATE TRIGGER [dbo].[updUser] 
   ON  [dbo].[Users]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF UPDATE(PeopleId)
	BEGIN
		UPDATE Users
		SET Name = dbo.UName(PeopleId),
		Name2 = dbo.UName2(PeopleId)
		WHERE PeopleId IN (SELECT PeopleId FROM INSERTED)
	END
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BlogCategory"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 99
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'BlogCategoriesView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'BlogCategoriesView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PodCast"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 133
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users"
            Begin Extent = 
               Top = 97
               Left = 443
               Bottom = 214
               Right = 759
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'PodcastSummary', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'PodcastSummary', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Triggers"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 149
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Tables"
            Begin Extent = 
               Top = 7
               Left = 294
               Bottom = 149
               Right = 492
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Comments"
            Begin Extent = 
               Top = 7
               Left = 540
               Bottom = 149
               Right = 724
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'Triggers', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'Triggers', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 123
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v"
            Begin Extent = 
               Top = 6
               Left = 303
               Bottom = 123
               Right = 505
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 6
               Left = 543
               Bottom = 123
               Right = 748
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'VBSInfo', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'VBSInfo', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 204
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 256
               Left = 65
               Bottom = 373
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v"
            Begin Extent = 
               Top = 11
               Left = 380
               Bottom = 240
               Right = 558
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 3495
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'VerseCategoriesView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'VerseCategoriesView', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[22] 4[27] 2[34] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "v"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 123
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 21
               Left = 282
               Bottom = 138
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2835
         Width = 3225
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'VerseSummary', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'VerseSummary', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_addextendedproperty N'ReturnType', N'ForumEntry', 'SCHEMA', N'dbo', 'PROCEDURE', N'ForumNewEntry', NULL, NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
