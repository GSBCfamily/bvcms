CREATE TABLE [dbo].[ZipCodes]
(
[zip] [nvarchar] (10) NOT NULL,
[state] [char] (2) NULL,
[City] [nvarchar] (50) NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
