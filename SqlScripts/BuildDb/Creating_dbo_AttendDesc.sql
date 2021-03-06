-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[AttendDesc](@id int) 
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @ret nvarchar(100)
	SELECT @ret =  Description FROM lookup.AttendType WHERE id = @id
	RETURN @ret
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
