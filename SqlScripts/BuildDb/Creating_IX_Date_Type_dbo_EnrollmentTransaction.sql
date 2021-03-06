CREATE NONCLUSTERED INDEX [IX_Date_Type] ON [dbo].[EnrollmentTransaction] ([TransactionDate], [TransactionTypeId]) INCLUDE ([OrganizationId], [PeopleId], [TransactionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
