CREATE QUEUE [dbo].[UpdateAttendStrQueue] 
WITH STATUS=ON, 
RETENTION=OFF, 
ACTIVATION (
STATUS=ON, 
PROCEDURE_NAME=[dbo].[UpdateAttendStrProc], 
MAX_QUEUE_READERS=3, 
EXECUTE AS OWNER
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
