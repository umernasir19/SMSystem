USE [RAJPUT_RICE_DB]
GO

/****** Object:  StoredProcedure [dbo].[Sp_Daily_SaleReport]    Script Date: 10/30/2020 4:37:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Sp_Daily_SaleReport](
@reportID int,
@from nvarchar(30),
@TO nvarchar(30)
)
as


select P.*,V.customerName from sales P
	inner join customers V on P.customerIdx =V.idx
	where P.creationDate>=@from and P.creationDate <=@TO
    -- Statement block executes when the Boolean expression is FALSE


GO

