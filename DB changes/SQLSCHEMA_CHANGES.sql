USE [RAJPUT_RICE_DB]
GO

/****** Object:  StoredProcedure [dbo].[sp_Planner]    Script Date: 11/14/2020 8:59:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_Planner]
as

select 'Payemnt' as Task, A.invoiceNoIdx,balance as Amount,DueDate from accountMasterGL A
inner join  vendors B
on A.vendorIdx=B.[idx]
where A.isCredit=1
GO


