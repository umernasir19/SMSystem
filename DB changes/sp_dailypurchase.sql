USE [RAJPUT_RICE_DB]
GO

/****** Object:  StoredProcedure [dbo].[Sp_Daily_PurchaseReport]    Script Date: 10/30/2020 4:38:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Sp_Daily_PurchaseReport](
@reportID int,
@from nvarchar(30),
@TO nvarchar(30)
)
as


select P.*,V.vendorName from purchase P
	inner join vendors V on P.vendorIdx =V.idx
	where P.creationDate>=@from and P.creationDate <=@TO
    -- Statement block executes when the Boolean expression is FALSE


GO

