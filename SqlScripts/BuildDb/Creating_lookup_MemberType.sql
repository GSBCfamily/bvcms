CREATE TABLE [lookup].[MemberType]
(
[Id] [int] NOT NULL,
[Code] [nvarchar] (20) NULL,
[Description] [nvarchar] (100) NULL,
[AttendanceTypeId] [int] NULL,
[Hardwired] [bit] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
