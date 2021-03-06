USE [master]
GO
/****** Object:  Database [RAJPUT_RICE_DB]    Script Date: 10/19/2020 2:43:24 PM ******/
CREATE DATABASE [RAJPUT_RICE_DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RAJPUT_RICE_DB_Data', FILENAME = N'E:\Visual Studio Projects\MangoTechProjects\RAJPUT RICE\DB\RAJPUT_RICE_DB.mdf' , SIZE = 167872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 16384KB )
 LOG ON 
( NAME = N'RAJPUT_RICE_DB_Log', FILENAME = N'E:\Visual Studio Projects\MangoTechProjects\RAJPUT RICE\DB\RAJPUT_RICE_DB_Log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 16384KB )
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RAJPUT_RICE_DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET RECOVERY FULL 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET  MULTI_USER 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'RAJPUT_RICE_DB', N'ON'
GO
USE [RAJPUT_RICE_DB]
GO
/****** Object:  StoredProcedure [dbo].[advance_Aproval]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE proc [dbo].[advance_Aproval]   
  
@idx int,  
@status int,  
@statusBy int,  
@statusDate varchar(50)  
  
as  
  
set nocount on  
  
update [advanceSalary]  
  
set [status]=@status,  
   [statusBy]=@statusBy,  
    [statusDate]=@statusDate  
      
  
where [idx] = @idx  
  
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[advannce_AprovalList]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[advannce_AprovalList]

as

begin
update advanceSalary set isExpire=1,status=3  where idx in (select idx from advanceSalary where Month(Convert(date,creationDate,103))< Month(Convert(date,GETDATE(),103)))
select e.idx as empId ,e.firstName +' '+ e.lastName as FullName, e.hrmsNumber,ads.advanceAmount,ads.deductionMonth,ads.deductionYear, ads.idx,


case
when ads.[status] = 0 and ads.isExpire=0 then 'Pending'  
when ads.[status] = 1 and ads.isExpire=0 then 'Approved'
when ads.[status] = 2 and ads.isExpire=0 then 'Reject'
when ads.[status] = 0 and ads.isExpire=1 then 'Expire'
end status


from advanceSalary ads inner join employees e on ads.employeeIdx =e.idx where ads.visible=1 and isExpire=0 
and status=0

order by idx desc
end






GO
/****** Object:  StoredProcedure [dbo].[deleteDetailsRecordonEdit]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[deleteDetailsRecordonEdit]    
(    
 @idx varchar(10)    
)    
    
as    
    
set nocount on    
    
delete from [pruchaseDetails]    
where purchaseIdx = @idx 





GO
/****** Object:  StoredProcedure [dbo].[deleteGLandGJBySaleIdx]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[deleteGLandGJBySaleIdx]
(
@idx int
)
as 
begin
declare @glidx int
declare @c int
declare @result int
set @glidx=(select idxx from accountMasterGL where invoiceNoIdx=@idx and tranTypeIdx=2)
if @glidx>0
	begin
			begin transaction
			delete from accountMasterGL where invoiceNoIdx=@idx and tranTypeIdx=2
			if @@ROWCOUNT>0
				begin
					set @c=(select count(*) from accountGJ where GLIdx= @glidx and tranTypeIdx=2)
					if (@c>0)
						begin
							delete from accountGJ where GLIdx=@glidx and tranTypeIdx=2
							if (@@ROWCOUNT=@c)
								begin
									commit transaction
									set @result =1
								end
							else
								begin
									rollback transaction
									set @result=0
								end
						end
					else
						begin
							rollback transaction
							set @result=0
						end
				end
			else
				begin
					rollback transaction
					set @result=0
				end

	end
else
	begin
	set @result=0
	end

	return @result
end 






GO
/****** Object:  StoredProcedure [dbo].[Get_AccountPayableDate]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_AccountPayableDate]     
@from date,     
@to date      
as      
begin    
select * from accountGj where coaIdx=43 And CONVERT(date,createDate,103) between CONVERT(date,@from,103) and Convert(date,@to,103)     
end 




GO
/****** Object:  StoredProcedure [dbo].[Get_AccountRecivableDate]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_AccountRecivableDate]   
@from date,   
@to date   
as    
begin  
select * from accountGj where coaIdx=1 And CONVERT(date,createDate,103) between CONVERT(date,@from,103) and Convert(date,@to,103)  
end




GO
/****** Object:  StoredProcedure [dbo].[get_payrollList]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[get_payrollList]

@idx int

as


begin 
select p.*,de.departmentName,e.hrmsNumber, e.firstName + ' ' + e.lastName as FullName , DATEPART(MONTH,p.creationDate) +' '+ DATEPART(YEAR, p.creationDate) as DateNew from payroll as p inner join employees e on p.empIdx = e.idx inner join department de on de.idx=e.departmentIdx where p.idx=@idx

end








GO
/****** Object:  StoredProcedure [dbo].[get_Sale_byServiceId]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[get_Sale_byServiceId]   
@idx int   
as    
begin  
select serv.idx,serv.serviceCost,u.unit from services serv inner join itemUnits u on serv.unitIdx=u.idx where serv.idx=@idx  
end  




GO
/****** Object:  StoredProcedure [dbo].[GetAccountsHeadDDL]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetAccountsHeadDDL]
as
begin 
select idx,
accountName,
accountCode
 from [dbo].[ChartofAccountsHead]
end




GO
/****** Object:  StoredProcedure [dbo].[GetAccountsHeadList]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetAccountsHeadList]
as
begin 
select idx,
accountName,
accountCode,
creationDate,
createdByUserIdx
 from [dbo].[ChartofAccountsHead]
end




GO
/****** Object:  StoredProcedure [dbo].[getEmployeeReport]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getEmployeeReport]   
(      
     
@param nvarchar(MAX)      
)      
as            
      
begin        
Declare @sql nvarchar(MAX)        
        
set @sql=N'select distinct de.designationName,d.departmentName,emp.*,B.branchName,S.stationName, case when emp.[isActive] = 0 then ''De-Active'' when emp.[isActive] = 1 then ''Active''  end status from employees emp inner join branch B on emp.branchIdx=B.idx inner join stations S on emp.stationIdx=S.idx inner join department d on emp.departmentIdx=d.idx inner join designation de on emp.designationIdx=de.idx ' + @param;        
        
exec sp_executesql @sql        
      
  
end        
      
      




GO
/****** Object:  StoredProcedure [dbo].[getProductType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getProductType]
as
begin
select * from productType 

end




GO
/****** Object:  StoredProcedure [dbo].[getPurchaseReport]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getPurchaseReport] --'3/04/2020','4/4/2020',1,1,1   
(  
--@from nvarchar (50),     
--@to nvarchar (50),  
--@branchIdx nvarchar (10),  
--@stationIdx nvarchar (10),  
--@status nvarchar (10)  
@param nvarchar(MAX)  
)  
as        
  
begin    
Declare @sql nvarchar(MAX)    
    
set @sql=N'select pr.idx,pr.poNumber,pr.purchaseDate,pr.netAmount,B.branchName,S.stationName, case when pr.[status] = 0 then ''Pending'' when pr.[status] = 1 then ''Accepted'' when pr.[status] = 2 then ''Rejected'' when pr.[status] = 3 then ''Goods Received'' end status from purchase pr inner join branch B on pr.branchIdx=B.idx inner join stations S on pr.stationIdx=S.idx ' + @param;    
    
exec sp_executesql @sql    
  
--select pr.idx,pr.poNumber,pr.purchaseDate,pr.netAmount,B.branchName,S.stationName,  
--case   
--when pr.[status] = 0 then 'Pending'  
--when pr.[status] = 1 then 'Accepted'  
--when pr.[status] = 2 then 'Rejected'  
--when pr.[status] = 3 then 'Goods Received' end status   
  
--from purchase pr  
--inner join branch B on pr.branchIdx=B.idx  
-- inner join stations S on pr.stationIdx=S.idx     
  
--where CONVERT(DateTime,pr.creationDate,103)>=CONVERT(DateTime,@from,103) and pr.creationDate<=Convert(DateTime,@to,103) and pr.branchIdx=@branchIdx and pr.stationIdx=@stationIdx and pr.[status]=@status   
end    
  
  
----select *, case when purchase.[status] = 0 then 'Pending'end statu from purchase where status = 0




GO
/****** Object:  StoredProcedure [dbo].[getSalesTaxForIncomeStatement]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getSalesTaxForIncomeStatement]
(
@dtStart datetime,
@dtEnd datetime,
@companyIdx int
)
as
begin
 Select 'Sales Tax' AS TYPED, 0 AS REVAMOUNT, CASE WHEN COA.idx = 45 THEN ISNULL(SUM(GJ.[Credit]),0)-ISNULL(SUM(Gj.[Debit]),0) ELSE ISNULL(SUM(GJ.[Debit]),0)-ISNULL(SUM(GJ.[Credit]),0)  END AS EXPAMOUNT, subHead.subHeadName
 FROM 
	accountGJ AS GJ
INNER JOIN ChartofAccountsChildHead AS COA ON COA.idx = GJ.coaIdx AND (COA.headIdx = 10 or coaIdx=45)
INNER JOIN ChartofAccountsSubHead AS subHead ON COA.subHeadIdx = subHead.idx
where
convert(varchar,gj.createDate, 103) between convert(varchar,@dtStart, 103) and convert(varchar,@dtEnd, 103)
	--GJ.createDate>=@dtStart and gj.createDate<=@dtEnd and GJ.companyIdx=@companyIdx
GROUP BY
	subHead.subHeadName,COA.idx
end




GO
/****** Object:  StoredProcedure [dbo].[GetSubHeadRecordByHeadId]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetSubHeadRecordByHeadId](@headIdx int)
as 
begin
select sub.idx,
sub.subHeadCode,
sub.subHeadName,
head.accountName as headName,
head.accountCode as headCode
from [dbo].[ChartofAccountsSubHead] sub
inner join [dbo].[ChartofAccountsHead] head on sub.headIdx = @headIdx where sub.visible=1

end




GO
/****** Object:  StoredProcedure [dbo].[GetSubHeadRecordsAll]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetSubHeadRecordsAll]
as 
begin
select sub.idx,
sub.subHeadCode,
sub.subHeadName,
head.accountName as headName,
head.accountCode as headCode,
Convert(varchar(50), sub.creationDate,103) as creationDate,
sub.createdByUserIdx,
CONCAT(us.firstName,' ',us.lastName) as fullName
from [dbo].[ChartofAccountsSubHead] sub
inner join [dbo].[ChartofAccountsHead] head on sub.headIdx = head.idx 
inner join users us on sub.createdByUserIdx=us.idx
where sub.visible=1
end


GO
/****** Object:  StoredProcedure [dbo].[InventoryReport]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[InventoryReport] 
(
@param nvarchar(MAX) 
)
as 
begin
Declare @sql nvarchar(MAX)

set @sql=N'select inv.*,br.branchName,st.stationName,p.itemCode,p.itemName,i.unit,pt.productType from inventory inv inner join branch br on inv.branchIdx=br.idx inner join stations st on inv.stationIdx=st.idx inner join products p on inv.productIdx=p.idx inner join itemUnits i on p.unit=i.idx inner join productType pt on inv.productTypeIdx=pt.idx ' + @param;

exec sp_executesql @sql


end







GO
/****** Object:  StoredProcedure [dbo].[loan_Aproval]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[loan_Aproval] 

@idx int,
@status int

as

set nocount on

update [loan]

set [status]=@status

where [idx] = @idx




GO
/****** Object:  StoredProcedure [dbo].[loan_aprovalList]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE proc [dbo].[loan_aprovalList]

as 

begin
select e.idx as empId ,e.firstName +' '+ e.lastName as FullName, e.hrmsNumber,ln.endDate,ln.loanAmount,ln.numberOfInstallment,ln.installmentAmount,ln.idx,ln.purposeOfLoan,

case
when ln.[status] = 0 then 'Pending'  
when ln.[status] = 1 then 'Approved'
end status


from loan ln inner join employees e on ln.empIdx =e.idx where ln.visible=1
and status=0

order by idx desc
end







GO
/****** Object:  StoredProcedure [dbo].[loan_installment]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[loan_installment]

 (
	@loanAmount int,
	@numberOfInstallment int,
	@installmentAmount int,
	@loanIdx int
	)
as

set nocount on

insert into [loanInstallments]
(
	[loanAmount],
	[numberOfInstallment],
	[installmentAmount],
	[loanIdx]
	)
	values
	(
	@loanAmount,
	@numberOfInstallment,
	@installmentAmount,
	@loanIdx
	)
	select scope_identity()





GO
/****** Object:  StoredProcedure [dbo].[purchaseDetailsList]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[purchaseDetailsList](@purchaseIdx nvarchar(50))    
AS    
  
select pd.*,pr.itemName,pt.productType,pr.itemCode,iu.unit from pruchaseDetails pd
inner join products pr on pd.itemIdx = pr.idx
inner join productType pt on pr.productTypeIdx=pt.idx
inner join itemUnits iu on pr.unit = iu.idx
where purchaseIdx=@purchaseIdx





GO
/****** Object:  StoredProcedure [dbo].[salesDetailsList]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[salesDetailsList](@salesIdx nvarchar(50))        
AS        
      
select sr.serviceCode as code ,sd.*,sr.serviceName,sd.unit as serviceUnit,sd.subAmount as Amount from salesDetails sd    
    
inner join services sr on sd.serviceIdx = sr.idx     
where sd.salesIdx=@salesIdx    

GO
/****** Object:  StoredProcedure [dbo].[search_payroll]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE proc [dbo].[search_payroll]  
  
@dep int,   
@month nvarchar(10),  
@year int  
  
as  
  
begin  
  
select e.firstName +' '+ e.lastName as FullName, de.departmentName ,e.hrmsNumber,p.departmentIdx,p.empIdx,p.creationDate,p.visible,p.idx,p.totalSalary,p.loanDeductionAmount,advanceDeductionAmount, Cast (DATENAME(MONTH,p.creationDate) AS NVARCHAR (10)) 'Month' , DATEPART(YEAR, p.creationDate) 'Year',
   
  
case  
when p.[status]  = 0 then 'Pending'    
when p.[status] = 1 then 'Approved'  
end status  
  
from payroll as p inner join employees e on e.idx=p.empIdx inner join department de on de.idx = p.departmentIdx where p.departmentIdx=@dep and DATEPART(MONTH,p.creationDate)=@month and DATEPART(YEAR, p.creationDate)=@year and p.visible=1  
and status=0  
order by idx desc  
end  
  
  
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[update_accountGJEX]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_accountGJEX]    
(    
 @idx int,    
 --@GLIdx int,    
 --@tranTypeIdx int,    
 --@companyIdx int,    
 --@branchIdx int,    
 --@stationIdx int,    
 --@userIdx int,    
 --@vendorIdx int,    
 --@customerIdx int,    
 @coaIdx int,    
 --@invoiceNo nvarchar(30),    
 @debit decimal(10, 2),    
 @credit decimal(10, 2), 
 @customerIdx int,
 @vendorIdx int ,
 --@createDate datetime,    
 @modifiedDate varchar(10)    
)    
    
as    
    
set nocount on    
    
update [accountGJ]    
set     
--[GLIdx] = @GLIdx,    
-- [tranTypeIdx] = @tranTypeIdx,    
-- [companyIdx] = @companyIdx,    
-- [branchIdx] = @branchIdx,    
-- [stationIdx] = @stationIdx,    
-- [userIdx] = @userIdx,    
-- [vendorIdx] = @vendorIdx,    
-- [customerIdx] = @customerIdx,    
 [coaIdx] = @coaIdx,    
 --[invoiceNo] = @invoiceNo,    
 [debit] = @debit,    
 [credit] = @credit,
 [customerIdx]=@customerIdx,
 [vendorIdx]=@vendorIdx,
 --[createDate] = @createDate,    
 [modifiedDate] = @modifiedDate    
where [idx] = @idx    
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[update_accountGJJE]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[update_accountGJJE]  
(  
 @idx int,  
 --@GLIdx int,  
 --@tranTypeIdx int,  
 --@companyIdx int,  
 --@branchIdx int,  
 --@stationIdx int,  
 --@userIdx int,  
 --@vendorIdx int,  
 --@customerIdx int,  
 @coaIdx int,  
 --@invoiceNo nvarchar(30),  
 @debit decimal(10, 2),  
 @credit decimal(10, 2),  
 --@createDate datetime,  
 @modifiedDate varchar(10)  
)  
  
as  
  
set nocount on  
  
update [accountGJ]  
set   
--[GLIdx] = @GLIdx,  
-- [tranTypeIdx] = @tranTypeIdx,  
-- [companyIdx] = @companyIdx,  
-- [branchIdx] = @branchIdx,  
-- [stationIdx] = @stationIdx,  
-- [userIdx] = @userIdx,  
-- [vendorIdx] = @vendorIdx,  
-- [customerIdx] = @customerIdx,  
 [coaIdx] = @coaIdx,  
 --[invoiceNo] = @invoiceNo,  
 [debit] = @debit,  
 [credit] = @credit,  
 --[createDate] = @createDate,  
 [modifiedDate] = @modifiedDate  
where [idx] = @idx  




GO
/****** Object:  StoredProcedure [dbo].[update_accountMasterGLEX]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
CREATE procedure [dbo].[update_accountMasterGLEX]      
(      
 @idxx int,      
     
 @debit decimal(10, 2),      
 @credit decimal(10, 2),      
  @bankIdx int,  
  @paymentModeIdx int,  
  @chequeNumber int,  
 @modifiedDate nvarchar(50) ,
 @memo nvarchar(MAX)
     
)      
      
as      
      
set nocount on      
      
update [accountMasterGL]      
set       
     
 [debit] = @debit,      
 [credit] = @credit,    
 [modifiedDate] = @modifiedDate,  
 [bankIdx]=@bankIdx,  
 [paymentModeIdx] = @paymentModeIdx,  
 [chequeNumber]=@chequeNumber  ,
 [memo]=@memo
 where [idxx] = @idxx      
    
    

GO
/****** Object:  StoredProcedure [dbo].[update_accountMasterGLIsCredit]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[update_accountMasterGLIsCredit]    
(    
 @idxx int,    
   
@isCredit int,    
  
 @modifiedDate nvarchar(50)    
   
)    
    
as    
    
set nocount on    
    
update [accountMasterGL]    
set     
   
 [isCredit] = @isCredit,  
 [modifiedDate] = @modifiedDate  
 where [idxx] = @idxx    




GO
/****** Object:  StoredProcedure [dbo].[update_accountMasterGLJE]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
CREATE procedure [dbo].[update_accountMasterGLJE]        
(        
 @idxx int,        
       
 @debit decimal(10, 2),        
 @credit decimal(10, 2),        
 @bankIdx int,    
 @customerIdx int,  
 @vendorIdx int,  
 @modifiedDate nvarchar(50)  ,
 @memo nvarchar(MAX)
       
)        
        
as        
        
set nocount on        
        
update [accountMasterGL]        
set         
       
 [debit] = @debit,        
 [credit] = @credit,      
 [modifiedDate] = @modifiedDate,    
 [bankIdx] = @bankIdx,  
 [customerIdx]=@customerIdx,  
 [vendorIdx]=@vendorIdx  ,
 [memo] =@memo
 where [idxx] = @idxx        
        
      

GO
/****** Object:  StoredProcedure [dbo].[update_PurchaseIsPaid]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[update_PurchaseIsPaid]      
(      
 @idx int,      
     
@isPaid int,      
    
 @lastModificationDate nvarchar(50),      
 @lastModifiedByUserIdx int   
)      
      
as      
      
set nocount on      
      
update [purchase]      
set       
     
 [lastModificationDate] = lastModificationDate,    
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx,    
 [isPaid] = @isPaid  
 where [idx] = @idx 





GO
/****** Object:  StoredProcedure [dbo].[update_SaleIsPaid]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[update_SaleIsPaid]    
(    
 @idx int,    
   
@isPaid int,    
  
 @lastModificationDate nvarchar(50),    
 @lastModifiedByUserIdx int 
)    
    
as    
    
set nocount on    
    
update [sales]    
set     
   
 [lastModificationDate] = lastModificationDate,  
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx,  
 [isPaid] = @isPaid
 where [idx] = @idx    




GO
/****** Object:  StoredProcedure [dbo].[update_status]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[update_status]


@idx int,
@status int

as

set nocount on

update [payroll]

set [status]=@status

where [idx] = @idx




GO
/****** Object:  StoredProcedure [dbo].[updatePurchaseDetailsAccept]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[updatePurchaseDetailsAccept]      
(      
 @idx int,      
 @purchaseIdx int,     
 @productTypeIdx int ,    
 @itemIdx int,      
 --@itemCode nvarchar(50),      
 --@unit int,      
 @unitPrice decimal(20,2),      
 @qty decimal(20,2),      
 @amount decimal(20,2),      
 --@creationDate datetime,      
 --@createdByUserIdx int,      
 @lastModificationDate varchar(50),      
 @lastModifiedByUserIdx int      
 --@visible int      
)      
      
as      
      
set nocount on      
      
update [pruchaseDetails]      
set [purchaseIdx] = @purchaseIdx,    
[productTypeIdx] = @productTypeIdx,    
 [itemIdx] = @itemIdx,      
 --[itemCode] = @itemCode,      
 --[unit] = @unit,      
 [unitPrice] = @unitPrice,      
 [qty] = @qty,      
 [amount] = @amount,      
 --[creationDate] = @creationDate,      
 --[createdByUserIdx] = @createdByUserIdx,      
 [lastModificationDate] = @lastModificationDate,      
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx      
 --[visible] = @visible      
where purchaseIdx = @purchaseIdx and itemIdx=@itemIdx      

GO
/****** Object:  StoredProcedure [dbo].[UpdateStatus]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[UpdateStatus]
(
	@idx int,
	--@poNumber nvarchar(50),
	--@companyIdx int,
	--@branchIdx int,
	--@stationIdx int,
	--@vendorIdx int,
	--@purchaseTypeIdx int,
	--@purchaseDate varchar(50),
	--@description nvarchar(max),
	--@netAmount int,
	--@isPaid int,
	--@paidDate varchar(50),
	--@creationDate datetime,
	--@createdByUserIdx int,
	--@lastModificationDate varchar(50),
	--@lastModifiedByUserIdx int,
	--@visible int,
	--@paymentStatus int,
	@status int
)

as

set nocount on

update [purchase]
-- [poNumber] = @poNumber,
--	[companyIdx] = @companyIdx,
--	[branchIdx] = @branchIdx,
--	[stationIdx] = @stationIdx,
--	[vendorIdx] = @vendorIdx,
--	[purchaseTypeIdx] = @purchaseTypeIdx,
--	[purchaseDate] = @purchaseDate,
--	[description] = @description,
--	[netAmount] = @netAmount,
	--[isPaid] = @isPaid,
	--[paidDate] = @paidDate,
	--[creationDate] = @creationDate,
	--[createdByUserIdx] = @createdByUserIdx,
	--[lastModificationDate] = @lastModificationDate,
	--[lastModifiedByUserIdx] = @lastModifiedByUserIdx,
	--[visible] = @visible,
	--[paymentStatus] = @paymentStatus,
	set [status] = @status
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_AcceptConsumptionRequest]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_AcceptConsumptionRequest](@idx int,@statusBy int, @consumedBy int)
as 
begin
update consumption 
set [status]=1 ,statusDate=getdate() ,[consumedBy]=@consumedBy,[statusBy]=@statusBy
where idx=@idx
end





GO
/****** Object:  StoredProcedure [dbo].[usp_Add_advanceSalary]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_Add_advanceSalary]  
(  
 @employeeIdx int,  
 @netSalary decimal(20,2),  
 @advanceAmount decimal(20,2),  
 @deductionMonth nvarchar(50),  
 @deductionYear nvarchar(50),  
 --@creationDate datetime,  
  @createdByUserIdx int
 --@lastModificationDate nvarchar(50),  
 --@lastModifiedByUserIdx int,  
 --@visible int  
)  
  
as  
  
set nocount on  
  
insert into [advanceSalary]  
(  
 [employeeIdx],  
 [netSalary],  
 [advanceAmount],  
 [deductionMonth],  
 [deductionYear] , 
 --[creationDate],  
 [createdByUserIdx] 
 --[lastModificationDate],  
 --[lastModifiedByUserIdx],  
 --[visible]  
)  
values  
(  
 @employeeIdx,  
 @netSalary,  
 @advanceAmount,  
 @deductionMonth,  
 @deductionYear , 
 --@creationDate,  
 @createdByUserIdx  
 --@lastModificationDate,  
 --@lastModifiedByUserIdx,  
 --@visible  
)  
  
select scope_identity()  
  
  
  
  
  
  
  
  
  
  


GO
/****** Object:  StoredProcedure [dbo].[usp_Add_ChartofAccountsChildHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_Add_ChartofAccountsChildHead]
(
	@subHeadIdx int,
	@headIdx int,
	@childHeadName nvarchar(50),
	@childHeadCode nvarchar(20),
	@creationDate datetime,
	@createdByUserIdx int,
	@lasModificationDate varchar(10),
	@lastModifiedByUserIdx int,
	@visible int
)

as

set nocount on

insert into [ChartofAccountsChildHead]
(
	[subHeadIdx],
	[headIdx],
	[childHeadName],
	[childHeadCode],
	[creationDate],
	[createdByUserIdx],
	[lasModificationDate],
	[lastModifiedByUserIdx],
	[visible]
)
values
(
	@subHeadIdx,
	@headIdx,
	@childHeadName,
	@childHeadCode,
	@creationDate,
	@createdByUserIdx,
	@lasModificationDate,
	@lastModifiedByUserIdx,
	@visible
)

select scope_identity()




GO
/****** Object:  StoredProcedure [dbo].[usp_Add_ChartofAccountsSubHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_Add_ChartofAccountsSubHead]
(
	@headIdx int,
	@subHeadName nvarchar(50),
	@subHeadCode nvarchar(20),
	@creationDate datetime,
	@createdByUserIdx int,
	@lasModificationDate varchar(10),
	@lastModifiedByUserIdx int,
	@visible int
)

as

set nocount on

insert into [ChartofAccountsSubHead]
(
	[headIdx],
	[subHeadName],
	[subHeadCode],
	[creationDate],
	[createdByUserIdx],
	[lasModificationDate],
	[lastModifiedByUserIdx],
	[visible]
)
values
(
	@headIdx,
	@subHeadName,
	@subHeadCode,
	@creationDate,
	@createdByUserIdx,
	@lasModificationDate,
	@lastModifiedByUserIdx,
	@visible
)

select scope_identity()




GO
/****** Object:  StoredProcedure [dbo].[usp_Add_COA]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_Add_COA]
(
	@parentIdx int,
	@headAccount int,
	@accountName nvarchar(50),
	@CoaLevel int,
	@IsActive bit
)

as

set nocount on

insert into [COA]
(
	[parentIdx],
	[headAccount],
	[accountName],
	[CoaLevel],
	[IsActive]
)
values
(
	@parentIdx,
	@headAccount,
	@accountName,
	@CoaLevel,
	@IsActive
)

select scope_identity()





GO
/****** Object:  StoredProcedure [dbo].[usp_Add_company]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_Add_company]
(
	@companyName nvarchar(max),
	@ownerName nvarchar(50),
	@STRN nvarchar(50),
	@address nvarchar(max),
	--@contactNumber nvarchar(50),
	--@email nvarchar(50),
	--@companyLogo nvarchar(50),
	--@creationDate datetime,
	@createdByUserIdx int
	--@lastModificationDate varchar(50),
	--@lastModifiedByUserIdx int,
	--@isActive int,
	--@visible int
)

as

set nocount on

insert into [company]
(
	[companyName],
	[ownerName],
	[STRN],
	[address],
	--[contactNumber],
	--[email],
	--[companyLogo],
	--[creationDate],
	[createdByUserIdx]
	--[lastModificationDate],
	--[lastModifiedByUserIdx],
	--[isActive],
	--[visible]
)
values
(
	@companyName,
	@ownerName,
	@STRN,
	@address,
	--@contactNumber,
	--@email,
	--@companyLogo,
	--@creationDate,
	@createdByUserIdx
	--@lastModificationDate,
	--@lastModifiedByUserIdx,
	--@isActive,
	--@visible
)

select scope_identity()





GO
/****** Object:  StoredProcedure [dbo].[usp_Add_contract]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_Add_contract]
(
	@empCode int,
	@employeeIdx int,
	@departmentIdx int,
	@designationIdx int,
	@employeeTypeIdx int,
	@contractTypeIdx int,
	@contractStartDate nvarchar(50),
	@contractEndDate nvarchar(50),
	--@creationDate datetime,
	@createdByUserIdx int
	--@lastModificationDate varchar(50),
	--@lastModifiedByUserIdx int,
	--@visible int
)

as

set nocount on

insert into [contract]
(
	[empCode],
	[employeeIdx],
	[departmentIdx],
	[designationIdx],
	[employeeTypeIdx],
	[contractTypeIdx],
	[contractStartDate],
	[contractEndDate],
	--[creationDate],
	[createdByUserIdx]
	--[lastModificationDate],
	--[lastModifiedByUserIdx],
	--[visible]
)
values
(
	@empCode,
	@employeeIdx,
	@departmentIdx,
	@designationIdx,
	@employeeTypeIdx,
	@contractTypeIdx,
	@contractStartDate,
	@contractEndDate,
	--@creationDate,
	@createdByUserIdx
	--@lastModificationDate,
	--@lastModifiedByUserIdx,
	--@visible
)

select scope_identity()





GO
/****** Object:  StoredProcedure [dbo].[usp_Add_ContractType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_Add_ContractType]
(
	@contractType nvarchar(50),
	@creationDate datetime,
	@createdByUserIdx int,
	@lastModificationDate varchar(50),
	@lastModifiedByUserIdx int,
	@visible int
)

as

set nocount on

insert into [ContractType]
(
	[contractType],
	[creationDate],
	[createdByUserIdx],
	[lastModificationDate],
	[lastModifiedByUserIdx],
	[visible]
)
values
(
	@contractType,
	@creationDate,
	@createdByUserIdx,
	@lastModificationDate,
	@lastModifiedByUserIdx,
	@visible
)

select scope_identity()





GO
/****** Object:  StoredProcedure [dbo].[usp_Add_loan]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[usp_Add_loan]        
(        
 @empIdx int,        
 @loanAmount decimal(20,2),        
 @numberOfInstallment decimal(20,2),       
 @installmentAmount decimal(20,2),    
 @modeOfPayment nvarchar(50),        
 @loanReqDate nvarchar(50),        
 @endDate nvarchar(50),        
 @purposeOfLoan nvarchar(50),        
 --@status int,        
 --@statusBy int,        
 --@statusDate datetime,        
 --@remarks nvarchar(50),        
 @creationDate datetime,        
 @createdByUserIdx int        
 --@lastModificationDate nvarchar(50),        
 --@lastModifiedByUserIdx int,        
 --@visible int        
)        
        
as        
        
set nocount on        
        
insert into [loan]        
(        
 [empIdx],        
 [loanAmount],        
 [numberOfInstallment],      
 [installmentAmount],    
 [modeOfPayment],        
 [loanReqDate],        
 [endDate],        
 [purposeOfLoan],        
 --[status],        
 --[statusBy],        
 --[statusDate],        
 --[remarks],        
 [creationDate],        
 [createdByUserIdx]        
 --[lastModificationDate],        
 --[lastModifiedByUserIdx],        
 --[visible]        
)        
values        
(        
 @empIdx,        
 @loanAmount,        
 @numberOfInstallment,     
 @installmentAmount,    
 @modeOfPayment,        
 @loanReqDate,        
 @endDate,        
 @purposeOfLoan,        
 --@status,        
 --@statusBy,        
 --@statusDate,        
 --@remarks,        
 @creationDate,        
 @createdByUserIdx        
 --@lastModificationDate,        
 --@lastModifiedByUserIdx,        
 --@visible        
)        
        
select scope_identity()        
        
        
        
        
        
        
        
        
        

GO
/****** Object:  StoredProcedure [dbo].[usp_Add_pruchaseDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_Add_pruchaseDetails]      
(      
 @purchaseIdx int,    
 @productTypeIdx int,    
 @itemIdx int,      
 --@itemCode nvarchar(50),      
 --@unit int,      
 @unitPrice decimal(20,2),      
 @qty decimal(20,2),      
 @amount decimal(20,2),      
 --@creationDate datetime,      
 @createdByUserIdx int      
 --@lastModificationDate varchar(50),      
 --@lastModifiedByUserIdx int,      
 --@visible int      
)      
      
as      
      
set nocount on      
      
insert into [pruchaseDetails]      
(      
 [purchaseIdx],    
 [productTypeIdx],    
 [itemIdx],      
 --[itemCode],      
 --[unit],      
 [unitPrice],      
 [qty],      
 [amount],      
 --[creationDate],      
 [createdByUserIdx]      
 --[lastModificationDate],      
 --[lastModifiedByUserIdx],      
 --[visible]      
)      
values      
(      
 @purchaseIdx,     
 @productTypeIdx,    
 @itemIdx,      
 --@itemCode,      
 --@unit,      
 @unitPrice,      
 @qty,      
 @amount,      
 --@creationDate,      
 @createdByUserIdx      
 --@lastModificationDate,      
 --@lastModifiedByUserIdx,      
 --@visible      
)      
      
select scope_identity()      
    

GO
/****** Object:  StoredProcedure [dbo].[usp_Add_salesDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_Add_salesDetails]
(
	@salesIdx int,
	@serviceIdx int,
	@serviceRate decimal(10,2),
	@serviceDescription nvarchar(50),
	@serviceQty decimal(10, 2),
	@subAmount decimal(10, 2),
	--@creationDate datetime,
	@createdByUserIdx int,
	--@lastModificationDate varchar(50),
	--@lastModifiedByUserIdx int,
	--@visible int
	@unit nvarchar(50)
)

as

set nocount on

insert into [salesDetails]
(
	[salesIdx],
	[serviceIdx],
	[serviceRate],
	[serviceDescription],
	[serviceQty],
	[subAmount],
	--[creationDate],
	[createdByUserIdx],
	--[lastModificationDate],
	--[lastModifiedByUserIdx],
	--[visible]
	[unit]
)
values
(
	@salesIdx ,
	@serviceIdx ,
	@serviceRate ,
	@serviceDescription ,
	@serviceQty ,
	@subAmount,
	--@creationDate datetime,
	@createdByUserIdx,
	@unit
)

select scope_identity()







GO
/****** Object:  StoredProcedure [dbo].[usp_Add_transactionType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_Add_transactionType]
(
	@Name nvarchar(50),
	@IsActive int
)

as

set nocount on

insert into [transactionType]
(
	[Name],
	[IsActive]
)
values
(
	@Name,
	@IsActive
)

select scope_identity()





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_accountGJ]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_accountGJ]
(
	@idx int
)

as

set nocount on

delete from [accountGJ]
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_accountGJWithMasterID]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
create procedure [dbo].[usp_delete_accountGJWithMasterID]  
(  
 @GLIdx int  
)  
  
as  
  
set nocount on  
  
delete from [accountGJ]  
where GLIdx = @GLIdx  
  
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[usp_delete_accountMasterGL]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_accountMasterGL]
(
	@idxx int
)

as

set nocount on

delete from [accountMasterGL]
where [idxx] = @idxx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_advanceSalary]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_delete_advanceSalary]
(
	@idx int
)

as

set nocount on

update [advanceSalary]  set visible = 0
where [idx] = @idx  










GO
/****** Object:  StoredProcedure [dbo].[usp_delete_branch]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_branch]
(
	@idx int
)

as

set nocount on

update [branch] set visible =0
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_ChartofAccountsChildHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_ChartofAccountsChildHead]
(
	@idx int
)

as

set nocount on

update [ChartofAccountsChildHead]
set visible=0
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_delete_ChartofAccountsSubHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_ChartofAccountsSubHead]
(
	@idx int
)

as

set nocount on

update  [ChartofAccountsSubHead]
set visible=0
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_delete_COA]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_COA]
(
	@idx int
)

as

set nocount on

delete from [COA]
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_company]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_delete_company]  
(  
 @idx int  
)  
  
as  
  
set nocount on  
  
update [company]  set visible = 0
where [idx] = @idx  




GO
/****** Object:  StoredProcedure [dbo].[usp_delete_companyBank]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_companyBank]
(
	@idx int
)

as

set nocount on

update [companyBank] set visible=0
where [idx] = @idx

GO
/****** Object:  StoredProcedure [dbo].[usp_delete_consumption]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_consumption]
(
	@idx int
)

as

set nocount on

update  [consumption]
set visible =0
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_contract]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_contract]
(
	@idx int
)

as

set nocount on

update [contract]  set visible = 0
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_ContractType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_ContractType]
(
	@idx int
)

as

set nocount on

delete from [ContractType]
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_customers]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_customers]
(
	@idx int
)

as

set nocount on

update [customers] set visible=0
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_department]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_department]
(
	@idx int
)

as

set nocount on

update [department]
set visible = 0
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_delete_designation]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_designation]
(
	@idx int
)

as

set nocount on

update [designation]
set visible = 0
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_delete_employees]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_delete_employees]  
(  
 @idx int  
)  
  
as  
  
set nocount on  
  
update [employees]  set visible = 0
where [idx] = @idx  
  
  







GO
/****** Object:  StoredProcedure [dbo].[usp_delete_employeeType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_employeeType]
(
	@idx int
)

as

set nocount on

update [employeeType]
set visible = 0
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_delete_inventory]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_inventory]
(
	@idx int
)

as

set nocount on

delete from [inventory]
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_itemUnits]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_itemUnits]
(
	@idx int
)

as

set nocount on

delete from [itemUnits]
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_loan]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_loan]
(
	@idx int
)

as

set nocount on

update [company]  set visible = 0
where [idx] = @idx  







GO
/****** Object:  StoredProcedure [dbo].[usp_delete_payroll]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_delete_payroll]
(
	@idx int
)

as

set nocount on

update [company]  set visible = 0
where [idx] = @idx  





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_products]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_products]
(
	@idx int
)

as

set nocount on

update [products]  set visible = 0
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_pruchaseDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_delete_pruchaseDetails]  
(  
 @idx int  
)  
  
as  
  
set nocount on  
  
update [pruchaseDetails]  set visible=0 
where purchaseIdx = @idx  
  






GO
/****** Object:  StoredProcedure [dbo].[usp_delete_purchase]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
CREATE procedure [dbo].[usp_delete_purchase]  
(  
 @idx int  
)  
  
as  
  
set nocount on  
  
update [purchase] set visible = 0  
where [idx] = @idx  
  





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_PurchaseType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_PurchaseType]
(
	@idx int
)

as

set nocount on

delete from [PurchaseType]
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_roles]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_roles]
(
	@idx int
)

as

set nocount on

delete from [roles]
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_delete_salary]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_delete_salary]
(
	@idx int
)

as

set nocount on

update [company]  set visible = 0
where [idx] = @idx  








GO
/****** Object:  StoredProcedure [dbo].[usp_delete_sales]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_sales]
(
	@idx int
)

as

set nocount on

delete from [sales]
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_salesDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_delete_salesDetails]
(
	@idx int
)

as

set nocount on

delete from [salesDetails]
where [idx] = @idx







GO
/****** Object:  StoredProcedure [dbo].[usp_delete_salesDetailsBySalesIdx]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[usp_delete_salesDetailsBySalesIdx]  
(  
 @idx int  
)  
  
as  
  
set nocount on  
  
delete from [salesDetails]  
where [salesIdx] = @idx  
  
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[usp_delete_services]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_services]
(
	@idx int
)

as

set nocount on

update  [services] Set visible=0
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_stations]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_stations]
(
	@idx int
)

as

set nocount on


update [stations]  set visible = 0
where [idx] = @idx  





GO
/****** Object:  StoredProcedure [dbo].[usp_delete_Users]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_delete_Users]  
(  
 @idx int  
)  
  
as  
  
set nocount on  
  
update [Users]  set visible = 0
where [idx] = @idx  




GO
/****** Object:  StoredProcedure [dbo].[usp_delete_vendors]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_delete_vendors]
(
	@idx int
)

as

set nocount on

update [vendors] set visible=0
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_RejectConsumptionRequest]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_RejectConsumptionRequest](@idx int,@statusBy int, @consumedBy int)
as 
begin
update consumption 
set [status]=2 ,statusDate=getdate() ,[consumedBy]=@consumedBy,[statusBy]=@statusBy
where idx=@idx
end





GO
/****** Object:  StoredProcedure [dbo].[usp_update_advanceSalary]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_update_advanceSalary]  
(  
 @idx int,  
 @employeeIdx int,  
 @netSalary decimal(20,2),  
 @advanceAmount decimal(20,2),  
 @deductionMonth nvarchar(50),  
 @deductionYear nvarchar(50),  
 --@creationDate datetime,  
 --@createdByUserIdx int,  
 @lastModificationDate nvarchar(50),  
 @lastModifiedByUserIdx int
 --@visible int  
)  
  
as  
  
set nocount on  
  
update [advanceSalary]  
set [employeeIdx] = @employeeIdx,  
 [netSalary] = @netSalary,  
 [advanceAmount] = @advanceAmount,  
 [deductionMonth] = @deductionMonth,  
 [deductionYear] = @deductionYear,  
 --[creationDate] = @creationDate,  
 --[createdByUserIdx] = @createdByUserIdx,  
 [lastModificationDate] = @lastModificationDate,  
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx
 --[visible] = @visible  
where [idx] = @idx  
  
  
  
  
  
  
  
  
  
  


GO
/****** Object:  StoredProcedure [dbo].[usp_update_ChartofAccountsChildHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[usp_update_ChartofAccountsChildHead]  
(  
 @idx int,  
 @subHeadIdx int,  
 @headIdx int,  
 @childHeadName nvarchar(50),  
 @childHeadCode nvarchar(20),  
 --@creationDate datetime,  
 --@createdByUserIdx int,  
 @lasModificationDate varchar(10),  
 @lastModifiedByUserIdx int  
 --@visible int  
)  
  
as  
  
set nocount on  
  
update [ChartofAccountsChildHead]  
set [subHeadIdx] = @subHeadIdx,  
 [headIdx] = @headIdx,  
 [childHeadName] = @childHeadName,  
 [childHeadCode] = @childHeadCode,  
 --[creationDate] = @creationDate,  
 --[createdByUserIdx] = @createdByUserIdx,  
 [lasModificationDate] = @lasModificationDate,  
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx  
 --[visible] = @visible  
where [idx] = @idx  
  
  
  
  


GO
/****** Object:  StoredProcedure [dbo].[usp_update_ChartofAccountsSubHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[usp_update_ChartofAccountsSubHead]  
(  
 @idx int,  
 @headIdx int,  
 @subHeadName nvarchar(50),  
 @subHeadCode nvarchar(20),  

 @lasModificationDate varchar(10),  
 @lastModifiedByUserIdx int
)  
  
as  
  
set nocount on  
  
update [ChartofAccountsSubHead]  
set [headIdx] = @headIdx,  
 [subHeadName] = @subHeadName,  
 [subHeadCode] = @subHeadCode,  
  
 [lasModificationDate] = @lasModificationDate,  
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx

where [idx] = @idx  
  
  
  
  


GO
/****** Object:  StoredProcedure [dbo].[usp_update_COA]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_update_COA]
(
	@idx int,
	@parentIdx int,
	@headAccount int,
	@accountName nvarchar(50),
	@CoaLevel int,
	@IsActive bit
)

as

set nocount on

update [COA]
set [parentIdx] = @parentIdx,
	[headAccount] = @headAccount,
	[accountName] = @accountName,
	[CoaLevel] = @CoaLevel,
	[IsActive] = @IsActive
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_update_company]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_update_company]
(
	@idx int,
	@companyName nvarchar(max),
	@ownerName nvarchar(50),
	@STRN nvarchar(50),
	@address nvarchar(max),
	--@contactNumber nvarchar(50),
	--@email nvarchar(50),
	--@companyLogo nvarchar(50),
	--@creationDate datetime,
	@createdByUserIdx int,
	@lastModificationDate varchar(50),
	@lastModifiedByUserIdx int
	--@isActive int,
	--@visible int
)

as

set nocount on

update [company]
set [companyName] = @companyName,
	[ownerName] = @ownerName,
	[STRN] = @STRN,
	[address] = @address,
	--[contactNumber] = @contactNumber,
	--[email] = @email,
	--[companyLogo] = @companyLogo,
	--[creationDate] = @creationDate,
	[createdByUserIdx] = @createdByUserIdx,
	[lastModificationDate] = @lastModificationDate,
	[lastModifiedByUserIdx] = @lastModifiedByUserIdx
	--[isActive] = @isActive,
	--[visible] = @visible
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_update_contract]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_update_contract]
(
	@idx int,
	@empCode int,
	@employeeIdx int,
	@departmentIdx int,
	@designationIdx int,
	@employeeTypeIdx int,
	@contractTypeIdx int,
	@contractStartDate nvarchar(50),
	@contractEndDate nvarchar(50),
	@lastModificationDate varchar(50),
	@lastModifiedByUserIdx int
)

as

set nocount on

update [contract]
set [empCode] = @empCode,
	[employeeIdx] = @employeeIdx,
	[departmentIdx] = @departmentIdx,
	[designationIdx] = @designationIdx,
	[employeeTypeIdx] = @employeeTypeIdx,
	[contractTypeIdx] = @contractTypeIdx,
	[contractStartDate] = @contractStartDate,
	[contractEndDate] = @contractEndDate,
	[lastModificationDate] = @lastModificationDate,
	[lastModifiedByUserIdx] = @lastModifiedByUserIdx
where [idx] = @idx





GO
/****** Object:  StoredProcedure [dbo].[usp_update_department]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_update_department]
(
	@idx int,
	--@companyIdx int,
	@departmentName nvarchar(50),
	--@creationDate datetime,

	@lastModificationDate varchar(50),
	@lastModifiedByUserIdx int
	--@visible int
)

as

set nocount on

update [department]
set --companyIdx] = @companyIdx,
	[departmentName] = @departmentName,
	--[creationDate] = @creationDate,

	[lastModificationDate] = @lastModificationDate,
	[lastModifiedByUserIdx] = @lastModifiedByUserIdx
	--[visible] = @visible
where [idx] = @idx






GO
/****** Object:  StoredProcedure [dbo].[usp_update_designation]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_update_designation]  
(  
 @idx int,  
 --@companyIdx int,  
 @departmentIdx int,  
 @designationName nvarchar(50),  
 --@creationDate datetime,  
 --@createdByUserIdx int,  
 @lastModificationDate varchar(50),  
 @lastModifiedByUserIdx int  
 --@visible int  
)  
  
as  
  
set nocount on  
  
update [designation]  
set
--[companyIdx] = @companyIdx,  
 [departmentIdx] = @departmentIdx,  
 [designationName] = @designationName,  
 --[creationDate] = @creationDate,  
 --[createdByUserIdx] = @createdByUserIdx,  
 [lastModificationDate] = @lastModificationDate,  
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx 
 --[visible] = @visible  
where [idx] = @idx  
  
  




GO
/****** Object:  StoredProcedure [dbo].[usp_update_employeeType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_update_employeeType]  
(  
 @idx int,  
 --@companyIdx int,  
 @employeeType nvarchar(50),  
 --@creationDate datetime,  
 --@createdByUserIdx int,  
 @lastModificationDate varchar(50),  
 @lastModifiedByUserIdx int  
 --@visible int  
)  
  
as  
  
set nocount on  
  
update [employeeType]  
set --[companyIdx] = @companyIdx,  
 [employeeType] = @employeeType,  
 --[creationDate] = @creationDate,  
 --[createdByUserIdx] = @createdByUserIdx,  
 [lastModificationDate] = @lastModificationDate,  
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx  
 --[visible] = @visible  
where [idx] = @idx  




GO
/****** Object:  StoredProcedure [dbo].[usp_update_inventory]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_update_inventory]        
(        
 @idx int,          
 @stock decimal(20,2)   
  
)        
        
as        
        
set nocount on        
        
update [inventory]        
set         
         
 [stock] = @stock    
  
where [idx] = @idx        

GO
/****** Object:  StoredProcedure [dbo].[usp_update_loan]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
CREATE procedure [dbo].[usp_update_loan]    
(    
 @idx int,    
 @empIdx int,    
 @loanAmount decimal(20,2),    
 @numberOfInstallment int,    
 @modeOfPayment nvarchar(50),   
 @installmentAmount decimal(20,2),  
 @loanReqDate nvarchar(50),    
 @endDate nvarchar(50),    
 @purposeOfLoan nvarchar(50),    
 --@status int,    
 --@statusBy int,    
 --@statusDate datetime,    
 --@remarks nvarchar(50),    
 --@creationDate datetime,    
 --@createdByUserIdx int    
 @lastModificationDate nvarchar(50),    
 @lastModifiedByUserIdx int    
 --@visible int    
)    
    
as    
    
set nocount on    
    
update [loan]    
set [empIdx] = @empIdx,    
 [loanAmount] = @loanAmount,    
 [numberOfInstallment] = @numberOfInstallment,    
 [modeOfPayment] = @modeOfPayment,    
 [loanReqDate] = @loanReqDate,    
 [endDate] = @endDate,    
 [purposeOfLoan] = @purposeOfLoan,    
 [installmentAmount]=@installmentAmount,  
 --[status] = @status,    
 --[statusBy] = @statusBy,    
 --[statusDate] = @statusDate,    
 --[remarks] = @remarks,    
 --[creationDate] = @creationDate,    
 --[createdByUserIdx] = @createdByUserIdx    
 [lastModificationDate] = @lastModificationDate,    
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx    
 --[visible] = @visible    
where [idx] = @idx    
    
    
    
    
    
    
    
    
    
  

GO
/****** Object:  StoredProcedure [dbo].[usp_update_pruchaseDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_update_pruchaseDetails]      
(      
 @idx int,      
 @purchaseIdx int,    
 @productTypeIdx int,    
 @itemIdx int,      
 --@itemCode nvarchar(50),      
 --@unit int,      
 @unitPrice decimal(20,2),      
 @qty decimal(20,2),      
 @amount decimal(20,2),      
 @creationDate datetime,      
 @createdByUserIdx int,      
 @lastModificationDate varchar(50),      
 @lastModifiedByUserIdx int,      
 @visible int      
)      
      
as      
      
set nocount on      
      
update [pruchaseDetails]      
set [purchaseIdx] = @purchaseIdx,      
 [productTypeIdx] = @productTypeIdx,    
 [itemIdx] = @itemIdx,      
 --[itemCode] = @itemCode,      
 --[unit] = @unit,      
 [unitPrice] = @unitPrice,      
 [qty] = @qty,      
 [amount] = @amount,      
 [creationDate] = @creationDate,      
 [createdByUserIdx] = @createdByUserIdx,      
 [lastModificationDate] = @lastModificationDate,      
 [lastModifiedByUserIdx] = @lastModifiedByUserIdx,      
 [visible] = @visible      
where [idx] = @idx      

GO
/****** Object:  StoredProcedure [dbo].[usp_update_purchase]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_update_purchase]          
(          
 @idx int,          
 @poNumber nvarchar(50),          
          
 @vendorIdx int,          
        
 @description nvarchar(max),    
 @totalAmount int,    
 @tax decimal(20,2),    
 @taxAmount decimal(20,2),    
 @netAmount decimal(20,2),          
@paymentMode int =null,    
@bankIdx int =null,    
@accOrChequeNum varchar(50) =null,    
@paidAmount nvarchar(50) =null,    
@balanceAmount nvarchar(50) = null,    
 @lastModificationDate varchar(50),          
 @lastModifiedByUserIdx int,          
    
 @paymentStatus int,          
 @status int          
)          
          
as          
begin    
set nocount on          
if (@paymentStatus=0)    
 begin    
  update [purchase]          
  set         
   [poNumber] = @poNumber,          
         
   [vendorIdx] = @vendorIdx,          
        
   [description] = @description,    
   [tax]=@tax,    
   [taxAount]=@taxAmount,    
   [totalAmount]=@totalAmount,    
   [netAmount] = @netAmount,    
   [paidAmount]=@paidAmount,    
   [balanceAmount]=@balanceAmount,    
   [paymentModeIdx]=0,    
   [bankIdx]=0,    
   [accorChequeNumber]='',    
   [lastModificationDate] = @lastModificationDate,          
   [lastModifiedByUserIdx] = @lastModifiedByUserIdx,          
        
   [paymentStatus] = @paymentStatus,          
   [status] = @status      
        
    
   where [idx] =@idx    
 end    
else if (@paymentStatus=1) --Paid    
 begin    
  if (@paymentMode=1)    
   begin    
      update [purchase]          
    set         
     [poNumber] = @poNumber,          
         
     [vendorIdx] = @vendorIdx,          
        
     [description] = @description,       
     [tax]=@tax,    
     [taxAount]=@taxAmount,    
     [totalAmount]=@totalAmount,    
     [netAmount] = @netAmount,    
     [paidAmount]=@paidAmount,    
     [balanceAmount]=@balanceAmount,    
     [paymentModeIdx]=@paymentMode,    
     [lastModificationDate] = @lastModificationDate,          
     [lastModifiedByUserIdx] = @lastModifiedByUserIdx,          
        
     [paymentStatus] = @paymentStatus,          
     [status] = @status      
        
    
     where [idx] =@idx    
   end    
  else if (@paymentMode=2) --Cheque    
   begin    
     update [purchase]          
    set         
     [poNumber] = @poNumber,          
         
     [vendorIdx] = @vendorIdx,          
        
     [description] = @description,       
     [tax]=@tax,    
     [taxAount]=@taxAmount,    
     [totalAmount]=@totalAmount,    
     [netAmount] = @netAmount,    
     [paidAmount]=@paidAmount,    
     [balanceAmount]=@balanceAmount,    
     [paymentModeIdx]=@paymentMode,    
     [bankIdx]=@bankIdx,    
     [accorChequeNumber]=@accOrChequeNum,    
     [lastModificationDate] = @lastModificationDate,          
     [lastModifiedByUserIdx] = @lastModifiedByUserIdx,          
        
     [paymentStatus] = @paymentStatus,          
     [status] = @status      
        
    
     where [idx] =@idx    
   end    
  else if (@paymentMode=3) --bank    
   begin    
      update [purchase]          
    set         
     [poNumber] = @poNumber,          
         
     [vendorIdx] = @vendorIdx,          
        
     [description] = @description,       
     [tax]=@tax,    
     [taxAount]=@taxAmount,    
     [totalAmount]=@totalAmount,    
     [netAmount] = @netAmount,    
     [paidAmount]=@paidAmount,    
     [balanceAmount]=@balanceAmount,    
     [paymentModeIdx]=@paymentMode,    
     [bankIdx]=@bankIdx,    
     [lastModificationDate] = @lastModificationDate,          
     [lastModifiedByUserIdx] = @lastModifiedByUserIdx,          
        
     [paymentStatus] = @paymentStatus,          
     [status] = @status      
        
    
     where [idx] =@idx    
   end    
 end    
    
    
 end 

GO
/****** Object:  StoredProcedure [dbo].[usp_update_salesDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_update_salesDetails]
(
	@idx int,
	@salesIdx int,
	@serviceIdx int,
	--@unitPrice int,
	--@qty int,
	--@amount int,
	@creationDate datetime,
	@createdByUserIdx int,
	@lastModificationDate varchar(50),
	@lastModifiedByUserIdx int,
	@visible int
)

as

set nocount on

update [salesDetails]
set [salesIdx] = @salesIdx,
	[serviceIdx] = @serviceIdx,
	--[unitPrice] = @unitPrice,
	--[qty] = @qty,
	--[amount] = @amount,
	[creationDate] = @creationDate,
	[createdByUserIdx] = @createdByUserIdx,
	[lastModificationDate] = @lastModificationDate,
	[lastModifiedByUserIdx] = @lastModifiedByUserIdx,
	[visible] = @visible
where [idx] = @idx






GO
/****** Object:  Table [dbo].[accountGJ]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[accountGJ](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[GLIdx] [int] NULL,
	[tranTypeIdx] [int] NULL,
	[userIdx] [int] NULL,
	[vendorIdx] [int] NULL,
	[employeeIdx] [int] NULL,
	[customerIdx] [int] NULL,
	[coaIdx] [int] NULL,
	[invoiceNo] [nvarchar](30) NULL,
	[debit] [decimal](10, 2) NULL,
	[credit] [decimal](10, 2) NULL,
	[createDate] [datetime] NULL,
	[modifiedDate] [varchar](10) NULL,
	[DueDate] [datetime] NULL,
 CONSTRAINT [PK_AccountGJ] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[accountMasterGL]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[accountMasterGL](
	[idxx] [int] IDENTITY(1,1) NOT NULL,
	[tranTypeIdx] [int] NULL,
	[userIdx] [int] NULL,
	[vendorIdx] [int] NULL,
	[employeeIdx] [int] NULL,
	[customerIdx] [int] NULL,
	[invoiceNoIdx] [nvarchar](50) NULL,
	[debit] [decimal](10, 2) NULL,
	[credit] [decimal](10, 2) NULL,
	[createDate] [datetime] NULL,
	[modifiedDate] [nvarchar](50) NULL,
	[paidAmount] [decimal](10, 2) NULL,
	[balance] [decimal](10, 2) NULL,
	[discount] [decimal](10, 2) NULL,
	[isCredit] [int] NULL,
	[creditDays] [int] NULL,
	[visible] [int] NULL,
	[paymentModeIdx] [int] NULL,
	[bankIdx] [int] NULL,
	[chequeNumber] [nvarchar](50) NULL,
	[memo] [nvarchar](max) NULL,
	[DueDate] [datetime] NULL,
	[ItemId] [int] NULL,
 CONSTRAINT [PK_AccountMasterGL] PRIMARY KEY CLUSTERED 
(
	[idxx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[advanceSalary]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[advanceSalary](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[employeeIdx] [int] NULL,
	[netSalary] [decimal](20, 2) NULL,
	[advanceAmount] [decimal](20, 2) NULL,
	[deductionMonth] [nvarchar](50) NULL,
	[deductionYear] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [nvarchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
	[status] [int] NULL,
	[statusBy] [int] NULL,
	[statusDate] [varchar](50) NULL,
	[isExpire] [int] NULL,
	[isPaid] [int] NULL,
	[Paid] [decimal](20, 2) NULL,
	[Balance] [decimal](20, 2) NULL,
 CONSTRAINT [PK_advance] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bank]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bank](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[bankName] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_bank] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[branch]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[branch](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[branchName] [nvarchar](max) NULL,
	[headQuarter] [nvarchar](max) NULL,
	[address] [nvarchar](max) NULL,
	[contactNumber] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[isActive] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_BranchSetup] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ChartofAccountsChildHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ChartofAccountsChildHead](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[subHeadIdx] [int] NOT NULL,
	[headIdx] [int] NOT NULL,
	[childHeadName] [nvarchar](50) NOT NULL,
	[childHeadCode] [nvarchar](20) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[createdByUserIdx] [int] NOT NULL,
	[lasModificationDate] [varchar](10) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NOT NULL,
 CONSTRAINT [PK__ChartofA__DC501A7884ADCA2D] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ChartofAccountsHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChartofAccountsHead](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[accountName] [nvarchar](50) NOT NULL,
	[accountCode] [nvarchar](20) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[createdByUserIdx] [int] NOT NULL,
	[parentIdx] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChartofAccountsSubHead]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ChartofAccountsSubHead](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[headIdx] [int] NOT NULL,
	[subHeadName] [nvarchar](50) NOT NULL,
	[subHeadCode] [nvarchar](20) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[createdByUserIdx] [int] NOT NULL,
	[lasModificationDate] [varchar](10) NULL,
	[lastModifiedByUserIdx] [int] NOT NULL,
	[visible] [int] NOT NULL,
 CONSTRAINT [PK__ChartofA__DC501A78E546B982] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[COA]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COA](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[parentIdx] [int] NULL,
	[headAccount] [int] NULL,
	[accountName] [nvarchar](50) NULL,
	[CoaLevel] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Acc_COA] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[company]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[company](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[companyName] [nvarchar](max) NULL,
	[ownerName] [nvarchar](50) NULL,
	[STRN] [nvarchar](50) NULL,
	[address] [nvarchar](max) NULL,
	[contactNumber] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[companyLogo] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[isActive] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_CompanySetup] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[companyBank]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[companyBank](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[bankIdx] [int] NULL,
	[accountTitle] [nvarchar](30) NULL,
	[Branch] [nvarchar](50) NULL,
	[accountNumber] [nvarchar](50) NULL,
	[creationDate] [datetime] NOT NULL,
	[createdByUserIdx] [int] NOT NULL,
	[visible] [nchar](10) NULL,
	[lastModificationDate] [varchar](13) NULL,
	[lastModifiedByUserIdx] [int] NULL,
 CONSTRAINT [PK_companyBank] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[consumption]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[consumption](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[itemIdx] [int] NULL,
	[consumedBy] [int] NULL,
	[consumedQuanity] [decimal](20, 2) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[status] [int] NULL,
	[statusBy] [int] NULL,
	[statusDate] [varchar](50) NULL,
	[remarks] [nvarchar](max) NULL,
	[lastModificationByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[visible] [int] NULL,
	[stock] [decimal](20, 2) NULL,
 CONSTRAINT [PK_Consumption] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[contract]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[contract](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[empCode] [int] NULL,
	[employeeIdx] [int] NULL,
	[departmentIdx] [int] NULL,
	[designationIdx] [int] NULL,
	[employeeTypeIdx] [int] NULL,
	[contractTypeIdx] [int] NULL,
	[contractStartDate] [nvarchar](50) NULL,
	[contractEndDate] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_contract] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContractType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContractType](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[contractType] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_ContractType] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[customers]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[customers](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[contactPersonName] [nvarchar](max) NULL,
	[customerName] [nvarchar](max) NULL,
	[customerCode] [nvarchar](50) NULL,
	[customerAccountType] [int] NULL,
	[cnic] [nvarchar](50) NULL,
	[contact] [nvarchar](50) NULL,
	[emailAddress] [nvarchar](50) NULL,
	[accountNo] [nvarchar](50) NULL,
	[ntn] [nvarchar](50) NULL,
	[strnNo] [nvarchar](50) NULL,
	[address] [nvarchar](max) NULL,
	[description] [nvarchar](max) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
	[openingBalance] [decimal](10, 2) NULL,
 CONSTRAINT [PK_CustomerRegistration] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[department]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[department](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[departmentName] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[designation]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[designation](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[departmentIdx] [int] NULL,
	[designationName] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_Designation] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[employees]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[employees](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[hrmsNumber] [int] NULL,
	[firstName] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[cnic] [nvarchar](50) NULL,
	[dateOfBirth] [nvarchar](50) NULL,
	[contactNumber] [nvarchar](50) NULL,
	[maritalIdx] [int] NULL,
	[genderIdx] [int] NULL,
	[emailAddress] [nvarchar](50) NULL,
	[address] [nvarchar](50) NULL,
	[departmentIdx] [int] NULL,
	[designationIdx] [int] NULL,
	[hiringDate] [varchar](50) NULL,
	[avatar] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[isTerminated] [int] NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_EmployeeRegistration] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[employeeType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[employeeType](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[employeeType] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_Employee Type] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[gender]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gender](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[Gender] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_gender] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[inventory]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inventory](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[productIdx] [int] NULL,
	[stock] [decimal](20, 2) NULL,
	[productTypeIdx] [int] NULL,
	[unitPrice] [decimal](20, 2) NULL,
	[totalAmount] [decimal](20, 2) NULL,
	[creationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[inventory_logs]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inventory_logs](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[productIdx] [int] NULL,
	[stock] [decimal](20, 2) NULL,
	[productTypeIdx] [int] NULL,
	[unitPrice] [decimal](20, 2) NULL,
	[totalAmount] [decimal](20, 2) NULL,
	[creationDate] [datetime] NOT NULL,
	[TransactionTypeID] [int] NULL,
	[MasterID] [int] NULL,
 CONSTRAINT [PK_inventory_logs] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InventoryDetail]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryDetail](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[InventoryIdx] [int] NULL,
	[PurchaseDetailidx] [int] NULL,
	[ConsumptionIdx] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[itemUnits]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[itemUnits](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[unit] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_ItemUnits] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[loan]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[empIdx] [int] NULL,
	[loanAmount] [decimal](20, 2) NULL,
	[numberOfInstallment] [int] NULL,
	[installmentAmount] [decimal](20, 2) NULL,
	[modeOfPayment] [int] NULL,
	[loanReqDate] [nvarchar](50) NULL,
	[endDate] [nvarchar](50) NULL,
	[purposeOfLoan] [nvarchar](50) NULL,
	[status] [int] NULL,
	[statusBy] [int] NULL,
	[statusDate] [datetime] NULL,
	[remarks] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [nvarchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
	[balance] [decimal](20, 2) NULL,
	[paid] [decimal](20, 2) NULL,
	[isPaid] [int] NULL,
	[isExpire] [int] NULL,
 CONSTRAINT [PK_loan] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[loanInstallments]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loanInstallments](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[loanIdx] [int] NULL,
	[loanAmount] [int] NULL,
	[numberOfInstallment] [int] NULL,
	[installmentAmount] [int] NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_loanInstallments] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[maritalStatus]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[maritalStatus](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[MaritalStatus] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_maritalStatus] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Month]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Month](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[month] [nvarchar](50) NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_Month] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[paymentMode]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[paymentMode](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[paymentMode] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_paymentMode] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[payroll]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[payroll](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[departmentIdx] [int] NULL,
	[empIdx] [int] NULL,
	[netSalary] [decimal](20, 2) NULL,
	[totalLeave] [int] NULL,
	[leaveDeductionAmount] [decimal](20, 2) NULL,
	[loanReamainingAmount] [decimal](20, 2) NULL,
	[loanDeductionAmount] [decimal](20, 2) NULL,
	[advanceRemainingAmount] [decimal](20, 2) NULL,
	[advanceDeductionAmount] [decimal](20, 2) NULL,
	[otherBenefits] [decimal](20, 2) NULL,
	[totalSalary] [decimal](20, 2) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserrIDx] [int] NULL,
	[lastModificationDate] [nvarchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[status] [int] NULL,
	[statusBy] [int] NULL,
	[statusDate] [nvarchar](10) NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_payroll] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[planner]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[planner](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TO_DO] [nvarchar](100) NOT NULL,
	[TO_DO_Date] [datetime] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[products]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[products](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[productTypeIdx] [int] NULL,
	[itemName] [nvarchar](max) NULL,
	[itemCode] [nvarchar](50) NULL,
	[unit] [int] NULL,
	[description] [nvarchar](max) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_ProductSetup] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[productType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[productType](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[productType] [nvarchar](30) NULL,
	[createdByUserIdx] [int] NULL,
	[creationDate] [date] NOT NULL,
 CONSTRAINT [PK_productType] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[pruchaseDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pruchaseDetails](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[purchaseIdx] [int] NULL,
	[productTypeIdx] [int] NOT NULL,
	[itemIdx] [int] NULL,
	[unitPrice] [decimal](20, 2) NULL,
	[qty] [decimal](20, 2) NULL,
	[amount] [decimal](20, 2) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
	[DueDate] [datetime] NULL,
 CONSTRAINT [PK_PurchaseItemSubTable] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[purchase]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[purchase](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[poNumber] [nvarchar](50) NULL,
	[vendorIdx] [int] NULL,
	[purchaseTypeIdx] [int] NULL,
	[purchaseDate] [varchar](50) NULL,
	[description] [nvarchar](max) NULL,
	[totalAmount] [decimal](20, 2) NULL,
	[netAmount] [decimal](20, 2) NULL,
	[paidAmount] [nvarchar](50) NULL,
	[balanceAmount] [nvarchar](50) NULL,
	[paymentModeIdx] [int] NULL,
	[bankIdx] [int] NULL,
	[accorChequeNumber] [varchar](50) NULL,
	[paidDate] [varchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
	[paymentStatus] [int] NULL,
	[status] [varchar](50) NULL,
	[isPaid] [int] NOT NULL,
	[discount] [decimal](10, 2) NULL,
	[tax] [decimal](10, 2) NULL,
	[taxAount] [decimal](10, 2) NULL,
	[purchaseduedate] [datetime] NULL,
 CONSTRAINT [PK_AddPurchaseParentTable] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PurchaseType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurchaseType](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[purchaseType] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_PurchaseType] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Roles](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[employeeIdx] [int] NULL,
	[pageUrl] [nvarchar](50) NULL,
	[add] [bit] NULL,
	[edit] [bit] NULL,
	[delete] [bit] NULL,
	[view] [bit] NULL,
	[approved] [bit] NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[salary]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[salary](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[empIdx] [int] NULL,
	[basicSalary] [int] NULL,
	[hraAllowance] [int] NULL,
	[daAllowance] [int] NULL,
	[conveyance] [int] NULL,
	[medicalAllowance] [int] NULL,
	[others] [int] NULL,
	[netSalary] [int] NULL,
	[isActive] [int] NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_EmployeeSalary] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sales]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sales](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[soNumber] [nvarchar](50) NULL,
	[customerIdx] [int] NULL,
	[description] [nvarchar](max) NULL,
	[totalAmount] [decimal](20, 2) NULL,
	[taxAmount] [decimal](20, 2) NULL,
	[WithHoldingTax] [decimal](20, 2) NULL,
	[SindhTax] [decimal](20, 2) NULL,
	[netAmount] [decimal](20, 2) NULL,
	[Paid] [decimal](20, 2) NULL,
	[Balance] [nchar](10) NULL,
	[isPaid] [int] NOT NULL,
	[discount] [decimal](20, 2) NULL,
	[paidDate] [varchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
	[paymentStatus] [int] NULL,
	[status] [int] NULL,
	[paymentModeIdx] [int] NULL,
	[bankIdx] [int] NULL,
	[chequeNumber] [nvarchar](30) NULL,
	[salesDate] [nvarchar](50) NULL,
 CONSTRAINT [PK_SalesParentTable] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[salesDetails]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[salesDetails](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[salesIdx] [int] NULL,
	[serviceIdx] [int] NULL,
	[serviceCode] [nvarchar](30) NULL,
	[unit] [nvarchar](50) NULL,
	[serviceRate] [decimal](10, 2) NULL,
	[serviceDescription] [nvarchar](50) NULL,
	[serviceQty] [decimal](10, 2) NULL,
	[subAmount] [decimal](10, 2) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_SalesItemSubTable] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[services]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[services](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[serviceName] [nvarchar](max) NULL,
	[serviceCode] [nvarchar](50) NULL,
	[unitIdx] [int] NULL,
	[serviceCost] [nvarchar](50) NULL,
	[description] [nvarchar](max) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_AddService] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stations]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stations](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[stationName] [nvarchar](max) NULL,
	[address] [nvarchar](max) NOT NULL,
	[contactNumber] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[isActive] [int] NULL,
	[visible] [int] NULL,
 CONSTRAINT [PK_StationSetup] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[transactionType]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactionType](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[IsActive] [int] NULL,
 CONSTRAINT [PK_transactionType] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Url]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Url](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[pageUrl] [nvarchar](50) NULL,
	[pageName] [nvarchar](50) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[CNIC] [nvarchar](50) NULL,
	[cellNumber] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[designationIdx] [int] NULL,
	[departmentIdx] [int] NULL,
	[loginId] [nvarchar](50) NULL,
	[password] [nvarchar](50) NULL,
	[gender] [int] NULL,
	[creationDate] [datetime] NOT NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[isActive] [int] NOT NULL,
	[visible] [int] NOT NULL,
	[passCode] [nvarchar](50) NULL,
	[PascodeYNID] [int] NULL,
	[Is_Admin] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[vendors]    Script Date: 10/19/2020 2:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vendors](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[vendorName] [nvarchar](max) NULL,
	[vendorCode] [nvarchar](50) NULL,
	[contactPersonName] [nvarchar](50) NULL,
	[vendorAccountType] [int] NULL,
	[accountNo] [nvarchar](50) NULL,
	[contact] [nvarchar](50) NULL,
	[emailAddress] [nvarchar](50) NULL,
	[strn] [nvarchar](50) NULL,
	[ntn] [nvarchar](50) NULL,
	[address] [nvarchar](max) NULL,
	[description] [nvarchar](max) NULL,
	[creationDate] [datetime] NULL,
	[createdByUserIdx] [int] NULL,
	[lastModificationDate] [varchar](50) NULL,
	[lastModifiedByUserIdx] [int] NULL,
	[visible] [int] NULL,
	[openingBalance] [decimal](10, 2) NULL,
 CONSTRAINT [PK_VendorRegistration] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[accountGJ] ON 

INSERT [dbo].[accountGJ] ([idx], [GLIdx], [tranTypeIdx], [userIdx], [vendorIdx], [employeeIdx], [customerIdx], [coaIdx], [invoiceNo], [debit], [credit], [createDate], [modifiedDate], [DueDate]) VALUES (1, 1, 1, 1, 7, NULL, NULL, 56, N'PR-001', CAST(2000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0x0000AC5800E0D80E AS DateTime), NULL, NULL)
INSERT [dbo].[accountGJ] ([idx], [GLIdx], [tranTypeIdx], [userIdx], [vendorIdx], [employeeIdx], [customerIdx], [coaIdx], [invoiceNo], [debit], [credit], [createDate], [modifiedDate], [DueDate]) VALUES (2, 1, 1, 1, 7, NULL, NULL, 60, N'PR-001', CAST(0.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), CAST(0x0000AC5800E0D81B AS DateTime), NULL, NULL)
INSERT [dbo].[accountGJ] ([idx], [GLIdx], [tranTypeIdx], [userIdx], [vendorIdx], [employeeIdx], [customerIdx], [coaIdx], [invoiceNo], [debit], [credit], [createDate], [modifiedDate], [DueDate]) VALUES (3, 2, 1, 1, 7, NULL, NULL, 56, N'PR-001', CAST(2000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0x0000AC5800E0D832 AS DateTime), NULL, NULL)
INSERT [dbo].[accountGJ] ([idx], [GLIdx], [tranTypeIdx], [userIdx], [vendorIdx], [employeeIdx], [customerIdx], [coaIdx], [invoiceNo], [debit], [credit], [createDate], [modifiedDate], [DueDate]) VALUES (4, 2, 1, 1, 7, NULL, NULL, 60, N'PR-001', CAST(0.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), CAST(0x0000AC5800E0D836 AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[accountGJ] OFF
SET IDENTITY_INSERT [dbo].[accountMasterGL] ON 

INSERT [dbo].[accountMasterGL] ([idxx], [tranTypeIdx], [userIdx], [vendorIdx], [employeeIdx], [customerIdx], [invoiceNoIdx], [debit], [credit], [createDate], [modifiedDate], [paidAmount], [balance], [discount], [isCredit], [creditDays], [visible], [paymentModeIdx], [bankIdx], [chequeNumber], [memo], [DueDate], [ItemId]) VALUES (1, 1, 1, 7, NULL, NULL, N'PR-001', CAST(2000.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), CAST(0x0000AC5800E0D7FC AS DateTime), NULL, CAST(2000.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), NULL, 1, NULL, NULL, 1, 0, NULL, NULL, CAST(0x0000AC5A00000000 AS DateTime), 1)
INSERT [dbo].[accountMasterGL] ([idxx], [tranTypeIdx], [userIdx], [vendorIdx], [employeeIdx], [customerIdx], [invoiceNoIdx], [debit], [credit], [createDate], [modifiedDate], [paidAmount], [balance], [discount], [isCredit], [creditDays], [visible], [paymentModeIdx], [bankIdx], [chequeNumber], [memo], [DueDate], [ItemId]) VALUES (2, 1, 1, 7, NULL, NULL, N'PR-001', CAST(2000.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), CAST(0x0000AC5800E0D82E AS DateTime), NULL, CAST(2000.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), NULL, 1, NULL, NULL, 1, 0, NULL, NULL, CAST(0x0000AC5B00000000 AS DateTime), 2)
SET IDENTITY_INSERT [dbo].[accountMasterGL] OFF
SET IDENTITY_INSERT [dbo].[bank] ON 

INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (1, N'Al Baraka Bank (Pakistan) Limited.', CAST(0x0000ABDE00DD09B9 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (2, N'Allied Bank Limited.', CAST(0x0000ABDE00DD09EF AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (3, N'Askari Bank Limited.', CAST(0x0000ABDE00DD09FE AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (4, N'Bank Alfalah Limited.', CAST(0x0000ABDE00DD0A0F AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (5, N'Bank Al-Habib Limited.', CAST(0x0000ABDE00DD0A20 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (6, N'BankIslami Pakistan Limited.', CAST(0x0000ABDE00DD0A3F AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (7, N'Citi Bank', CAST(0x0000ABDE00DD0A57 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (8, N'Deutsche Bank A.G.', CAST(0x0000ABDE00DD0A6D AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (9, N'The Bank of Tokyo-Mitsubishi UFJ', CAST(0x0000ABDE00DD0A85 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (10, N'Dubai Islamic Bank Pakistan Limited.', CAST(0x0000ABDE00DD0AA9 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (11, N'Faysal Bank Limited.', CAST(0x0000ABDE00DD0ACE AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (12, N'First Women Bank Limited.', CAST(0x0000ABDE00DD0AF3 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (13, N'Habib Bank Limited.', CAST(0x0000ABDE00DD0B1B AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (14, N'Standard Chartered Bank (Pakistan) Limited.', CAST(0x0000ABDE00DD0B42 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (15, N'Habib Metropolitan Bank Limited.', CAST(0x0000ABDE00DD0B68 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (16, N'Industrial and Commercial Bank of China', CAST(0x0000ABDE00DD0B8D AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (17, N'Industrial Development Bank of Pakistan', CAST(0x0000ABDE00DD0BB1 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (18, N'JS Bank Limited.', CAST(0x0000ABDE00DD0BCD AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (19, N'MCB Bank Limited.', CAST(0x0000ABDE00DD0BE7 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (20, N'MCB Islamic Bank Limited.', CAST(0x0000ABDE00DD0BFE AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (21, N'Meezan Bank Limited.', CAST(0x0000ABDE00DD0C17 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (22, N'National Bank of Pakistan', CAST(0x0000ABDE00DD0C27 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (23, N'S.M.E. Bank Limited.', CAST(0x0000ABDE00DD0C35 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (24, N'Samba Bank Limited.', CAST(0x0000ABDE00DD0C43 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (25, N'Silk Bank Limited', CAST(0x0000ABDE00DD0C50 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (26, N'Sindh Bank Limited.', CAST(0x0000ABDE00DD0C5D AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (27, N'Soneri Bank Limited.', CAST(0x0000ABDE00DD0C6B AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (28, N'Summit Bank Limited.', CAST(0x0000ABDE00DD0C79 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (29, N'The Bank of Khyber.', CAST(0x0000ABDE00DD0C86 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (30, N'The Bank of Punjab.', CAST(0x0000ABDE00DD0C92 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (31, N'The Punjab Provincial Cooperative Bank Limited.', CAST(0x0000ABDE00DD0CA0 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (32, N'United Bank Limited.', CAST(0x0000ABDE00DD0CAE AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (33, N'Zarai Taraqiati Bank Limited', CAST(0x0000ABDE00DD0CBC AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (34, N'National Bank of Pakistan', CAST(0x0000ABDE00DD0CC8 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (35, N'Bank of Punjab', CAST(0x0000ABDE00DD0CD5 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (36, N'Sindh Bank', CAST(0x0000ABDE00DD0CE1 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (37, N'Bank of Khyber', CAST(0x0000ABDE00DD0CED AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (38, N'First Women Bank', CAST(0x0000ABDE00DD0CF9 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (39, N'Zarai Taraqiyati Bank Limited', CAST(0x0000ABDE00DD0D05 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (40, N'Bank of Azad Jammu & Kashmir', CAST(0x0000ABDE00DD0D11 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (41, N'Industrial Development Bank', CAST(0x0000ABDE00DD0D1F AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (42, N'SME Bank', CAST(0x0000ABDE00DD0D2E AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (43, N'The Punjab Provincial Cooperative Bank', CAST(0x0000ABDE00DD0D3D AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (44, N'Zarai Taraqiati Bank Limited', CAST(0x0000ABDE00DD0D4C AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (45, N'Askari Bank', CAST(0x0000ABDE00DD0D5A AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (46, N'Allied Bank Limited', CAST(0x0000ABDE00DD0D69 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (47, N'Bank Alfalah', CAST(0x0000ABDE00DD0D78 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (48, N'Bank Al Habib', CAST(0x0000ABDE00DD0D87 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (49, N'Faysal Bank', CAST(0x0000ABDE00DD0D95 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (50, N'Habib Bank Limited', CAST(0x0000ABDE00DD0DA4 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (51, N'Habib Metropolitan Bank', CAST(0x0000ABDE00DD0DB2 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (52, N'JS Bank', CAST(0x0000ABDE00DD0DC1 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (53, N'Samba Bank Limited', CAST(0x0000ABDE00DD0DD0 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (54, N'Silkbank Limited', CAST(0x0000ABDE00DD0DDE AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (55, N'Standard Chartered Pakistan', CAST(0x0000ABDE00DD0DED AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (56, N'Soneri Bank', CAST(0x0000ABDE00DD0DFB AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (57, N'Summit Bank', CAST(0x0000ABDE00DD0E09 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (58, N'United Bank Limited', CAST(0x0000ABDE00DD0E18 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (59, N'MCB Bank Limited', CAST(0x0000ABDE00DD0E26 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (60, N'Meezan Bank Limited', CAST(0x0000ABDE00DD0E34 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (61, N'Soneri Mustaqeem Islamic Bank', CAST(0x0000ABDE00DD0E43 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (62, N'Dubai Islamic Bank', CAST(0x0000ABDE00DD0E51 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (63, N'Al Baraka Bank', CAST(0x0000ABDE00DD0E5F AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (64, N'Bank Alfalah Islamic', CAST(0x0000ABDE00DD0E6E AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (65, N'BankIslami Pakistan Limited', CAST(0x0000ABDE00DD0E7C AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (66, N'Askari Bank Ltd', CAST(0x0000ABDE00DD0E8B AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (67, N'MCB Islamic Banking', CAST(0x0000ABDE00DD0E99 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (68, N'UBL Islamic Banking', CAST(0x0000ABDE00DD0EA8 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (69, N'HBL Islamic Banking', CAST(0x0000ABDE00DD0EB6 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (70, N'National Bank of Pakistan', CAST(0x0000ABDE00DD0EC4 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (71, N'Bank Al Habib Islamic Banking', CAST(0x0000ABDE00DD0ED2 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (72, N'Bank of Punjab Islamic Banking', CAST(0x0000ABDE00DD0EE1 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (73, N'Allied Islamic Bank', CAST(0x0000ABDE00DD0EF0 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (74, N'Faysal Bank (Islamic)', CAST(0x0000ABDE00DD0EFE AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (75, N'Advans Microfinance Bank', CAST(0x0000ABDE00DD0F0D AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (76, N'Finca Microfinance Bank', CAST(0x0000ABDE00DD0F1C AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (77, N'ASA Pakistan Microfinance', CAST(0x0000ABDE00DD0F2B AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (78, N'First Microfinance Bank', CAST(0x0000ABDE00DD0F3A AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (79, N'Khushhali Microfinance Bank', CAST(0x0000ABDE00DD0F48 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (80, N'NRSP Microfinance Bank', CAST(0x0000ABDE00DD0F55 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (81, N'Telenor Microfinance Bank', CAST(0x0000ABDE00DD0F64 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (82, N'Apna Microfinance Bank', CAST(0x0000ABDE00DD0F72 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (83, N'Mobilink Microfinance Bank', CAST(0x0000ABDE00DD0F80 AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (84, N'Pak-Oman Microfinance Bank', CAST(0x0000ABDE00DD0F8F AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (85, N'Sindh Microfinance Bank (SMFB)', CAST(0x0000ABDE00DD0F9E AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (86, N'U Microfinance Bank', CAST(0x0000ABDE00DD0FAC AS DateTime), 1, 1)
INSERT [dbo].[bank] ([idx], [bankName], [creationDate], [createdByUserIdx], [visible]) VALUES (87, N'Akhuwat (Microfinance)', CAST(0x0000ABDE00DD0FBB AS DateTime), 1, 1)
SET IDENTITY_INSERT [dbo].[bank] OFF
SET IDENTITY_INSERT [dbo].[branch] ON 

INSERT [dbo].[branch] ([idx], [branchName], [headQuarter], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (7, N'NEW QUALITY CATERING SERVICES', N'KARACHI', NULL, NULL, NULL, CAST(0x0000AC1400E9E311 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[branch] ([idx], [branchName], [headQuarter], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (8, N'BISMILLAH FOOD GOODS RAW MATERIAL SUPPLIER', N'KARACHI', NULL, NULL, NULL, CAST(0x0000AC1400EA21FB AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[branch] ([idx], [branchName], [headQuarter], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (9, N'HUMAN RESOURCE MANAGEMENT SERVICES', N'KARACHI', NULL, NULL, NULL, CAST(0x0000AC1400EA4826 AS DateTime), 1, NULL, NULL, 1, 0)
INSERT [dbo].[branch] ([idx], [branchName], [headQuarter], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (10, N'IMRAN BROTHERS', N'KARACHI', NULL, NULL, NULL, CAST(0x0000AC1400EA5DD1 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[branch] ([idx], [branchName], [headQuarter], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (11, N'COMMERCIAL KITCHEN', N'KARACHI', NULL, NULL, NULL, CAST(0x0000AC1400EC49F4 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[branch] ([idx], [branchName], [headQuarter], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (12, N'BFG & HRMS', N'KARACHI', NULL, NULL, NULL, CAST(0x0000AC1400F12536 AS DateTime), 1, NULL, NULL, 1, 1)
SET IDENTITY_INSERT [dbo].[branch] OFF
SET IDENTITY_INSERT [dbo].[ChartofAccountsChildHead] ON 

INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 1, 8, N'Accounts Receivable', N'666-1-1', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (2, 1, 8, N'Undeposited Funds', N'666-1-2', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (3, 1, 8, N'Prepaid Sales Tax', N'666-1-3', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (4, 1, 8, N'Sales tax(GST)', N'666-1-4', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (5, 1, 8, N' Petty Cash', N'666-1-5', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 0)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (6, 1, 8, N'Staff Advance', N'666-1-6', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (7, 2, 8, N'Petty Cash', N'666-2-7', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 0)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (8, 2, 8, N' Petty Cash A/c', N'666-2-8', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 0)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (9, 3, 8, N'Arif Habib - Habib Metro', N'666-3-9', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (10, 4, 8, N'Inventory', N'666-4-10', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (11, 5, 9, N'Loan', N'777-5-11', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (12, 6, 9, N'Computer Equipment', N'777-6-12', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (13, 6, 9, N'Less Accumulated Depreciation on Computer Equipmen', N'777-6-13', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (14, 6, 9, N'Less Accumulated Depreciation on Office Equipment', N'777-6-14', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (15, 6, 9, N'Office Equipment', N'777-6-15', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (16, 9, 9, N'Furniture & Fixtures - At Cost', N'777-7-16', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (17, 9, 9, N'Furniture & Fixtures - Accumulated depreciation', N'777-7-17', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (18, 10, 3, N'Owner''s Share Capital', N'333-10-18', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (19, 10, 3, N'Opening Balance Equity', N'333-10-19', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (20, 10, 3, N'Retained Earnings', N'333-10-20', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (21, 10, 3, N'Current Earnings', N'333-10-21', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (22, 11, 4, N'Cost of Goods Sold', N'444-11-22', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (23, 13, 4, N'Bank Revaluations', N'444-13-23', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (24, 13, 4, N'Exchange Gain or Loss', N'444-13-24', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (25, 13, 4, N'Advertising', N'444-13-25', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (26, 13, 4, N'Bank Fees', N'444-13-26', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (27, 13, 4, N'Cleaning', N'444-13-27', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (28, 13, 4, N'Consulting & Accounting', N'444-13-28', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (29, 13, 4, N'Depreciation', N'444-13-29', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (30, 13, 4, N'Entertainment', N'444-13-30', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (31, 13, 4, N' Freight & Courier', N'444-13-31', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (32, 13, 4, N'General Expenses', N'444-13-32', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (33, 13, 4, N'Discounts Given', N'444-13-33', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (34, 13, 4, N'Discounts Received', N'444-13-34', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (35, 13, 4, N'Income Tax Expense', N'444-13-35', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (36, 13, 4, N'Insurance', N'444-13-36', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (37, 13, 4, N'Legal expenses', N'444-13-37', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (38, 13, 4, N'Light, Power, Heating', N'444-13-38', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (39, 13, 4, N'Motor Vehicle Expenses', N'444-13-39', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (40, 13, 4, N'Office Expenses', N'444-13-40', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (41, 14, 4, N'Salaries, Wages and Benefits', N'444-14-41', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (42, 14, 4, N'Daily expense', N'444-14-42', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (43, 17, 10, N'Accounts Payable', N'888-17-43', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (44, 17, 10, N'Historical Adjustment', N'888-17-44', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (45, 17, 10, N'Sales Tax', N'888-17-45', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (46, 17, 10, N'Unpaid Expense Claims', N'888-17-46', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (47, 17, 10, N'Wages Payable', N'888-17-47', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (48, 17, 10, N'Employee Tax Payable', N'888-17-48', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (49, 17, 10, N'Income Tax Payable', N'888-17-49', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (50, 17, 10, N'Owner A Drawings', N'888-17-50', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (51, 17, 10, N'Provident Fund Payable', N'888-17-51', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (52, 17, 10, N'With Holding Tax Collected', N'888-17-52', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (53, 19, 5, N'Other Revenue', N'555-19-53', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (54, 19, 5, N'Sales', N'555-19-54', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (55, 13, 4, N'Purchase', N'444-13-55', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (56, 2, 8, N'Cash In Hand', N'666-2-56', CAST(0x0000AB8900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (57, 19, 5, N'Service', N'555-19-57', CAST(0x0000AB8A00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (58, 5, 9, N'Advance Salary Account', N'777-5-58', CAST(0x0000AB8C00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (59, 1, 8, N'Loan', N'666-1-59', CAST(0x0000AB8C00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (60, 1, 8, N'Raw Material ', N'666-1-60', CAST(0x0000AB8D00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (61, 13, 4, N'Consumed Raw Material', N'444-13-61', CAST(0x0000AB8D00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (62, 2, 8, N'Test', N'666-2-62', CAST(0x0000AB9D00000000 AS DateTime), 1, NULL, 0, 0)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (63, 12, 4, N'test', N'444-12-63', CAST(0x0000AB9D00000000 AS DateTime), 1, NULL, 0, 0)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (64, 1, 8, N'Bank', N'666-1-64', CAST(0x0000ABB800000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (65, 1, 8, N'Purchase Tax', N'666-1-65', CAST(0x0000ABB900000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (66, 23, 5, N'WareHouse Sales', N'555-23-66', CAST(0x0000ABD400000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (67, 13, 4, N'Petty Cash', N'444-13-67', CAST(0x0000ABD500000000 AS DateTime), 1, NULL, 0, 0)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (68, 24, 3, N'Customer Opening Balance', N'333-24-68', CAST(0x0000ABD500000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (69, 25, 3, N'Vendor Opening Balance', N'333-25-69', CAST(0x0000ABD500000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (70, 1, 8, N'Cash Control', N'666-1-70', CAST(0x0000ABDB00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (71, 17, 10, N'Cash Transfer', N'888-17-71', CAST(0x0000ABDB00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (72, 26, 4, N'With Holding Tax', N'444-26-72', CAST(0x0000ABDB00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (73, 26, 4, N'Sindh Tax', N'444-26-73', CAST(0x0000ABDB00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (74, 2, 8, N'Petty Cash Expense', N'666-2-74', CAST(0x0000ABDD00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (75, 27, 8, N'Advance Salary HR', N'666-27-75', CAST(0x0000ABFF00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (76, 27, 8, N'Loan Current', N'666-27-76', CAST(0x0000ABFF00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (77, 28, 9, N'Loan Non-Current', N'777-28-77', CAST(0x0000ABFF00000000 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[ChartofAccountsChildHead] ([idx], [subHeadIdx], [headIdx], [childHeadName], [childHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (78, 29, 4, N'COGS', N'444-29-78', CAST(0x0000AC3B00000000 AS DateTime), 1, NULL, 0, 1)
SET IDENTITY_INSERT [dbo].[ChartofAccountsChildHead] OFF
SET IDENTITY_INSERT [dbo].[ChartofAccountsHead] ON 

INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (1, N'Asset', N'111', CAST(0x0000AB7701149861 AS DateTime), 1, 0)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (2, N'Liability', N'222', CAST(0x0000AB770114B35E AS DateTime), 1, 0)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (3, N'Equity', N'333', CAST(0x0000AB770114C815 AS DateTime), 1, 0)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (4, N'Expenses', N'444', CAST(0x0000AB770114D3FC AS DateTime), 1, 0)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (5, N'Revenue', N'555', CAST(0x0000AB770114ECD6 AS DateTime), 1, 0)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (8, N'Current Assets', N'666', CAST(0x0000AB89011561D1 AS DateTime), 1, 1)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (9, N'Non Current Assets', N'777', CAST(0x0000AB890115B111 AS DateTime), 1, 1)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (10, N'Current Liability', N'888', CAST(0x0000AB890115E959 AS DateTime), 1, 2)
INSERT [dbo].[ChartofAccountsHead] ([idx], [accountName], [accountCode], [creationDate], [createdByUserIdx], [parentIdx]) VALUES (13, N'Non Current Liability', N'999', CAST(0x0000AB8901160B14 AS DateTime), 1, 2)
SET IDENTITY_INSERT [dbo].[ChartofAccountsHead] OFF
SET IDENTITY_INSERT [dbo].[ChartofAccountsSubHead] ON 

INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 8, N'Current Assets', N'666-1', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (2, 8, N'Cash', N'666-2', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (3, 8, N'Bank', N'666-3', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (4, 8, N'Inventory', N'666-4', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (5, 9, N'Non Current Assets', N'777-5', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (6, 9, N'Fixed Assets', N'777-6', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (9, 9, N'Furniture & Fixtures', N'777-7', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (10, 3, N'Equity', N'333-10', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (11, 4, N'Direct Costs', N'444-11', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (12, 4, N'Depreciation', N'444-12', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (13, 4, N'Expense', N'444-13', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (14, 4, N'Operating Expenses', N'444-14', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (15, 4, N'Head Office Expenses', N'444-15', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (16, 4, N'Other Expense', N'444-16', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (17, 10, N'Current Liability', N'888-17', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (18, 13, N'Long Term Liability', N'999-18', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (19, 5, N'Revenue', N'555-19', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (20, 5, N'Other Income', N'555-20', CAST(0x0000AB8900000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (21, 1, N'Test', N'111-21', CAST(0x0000AB9D00000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (22, 2, N'Test', N'222-22', CAST(0x0000AB9D00000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (23, 5, N'Zaman Sales', N'555-23', CAST(0x0000ABD400000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (24, 3, N'Opening Balance', N'333-24', CAST(0x0000ABD500000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (25, 3, N'Contra Equity', N'333-25', CAST(0x0000ABD500000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (26, 4, N'Tax Expense', N'444-26', CAST(0x0000ABDB00000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (27, 8, N'Prepaid Expense', N'666-27', CAST(0x0000ABFF00000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (28, 9, N'Prepaid Expense Non Current', N'777-28', CAST(0x0000ABFF00000000 AS DateTime), 1, N'', 0, 1)
INSERT [dbo].[ChartofAccountsSubHead] ([idx], [headIdx], [subHeadName], [subHeadCode], [creationDate], [createdByUserIdx], [lasModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (29, 4, N'Cost Of Good Sold', N'444-29', CAST(0x0000AC3B00000000 AS DateTime), 1, N'', 0, 1)
SET IDENTITY_INSERT [dbo].[ChartofAccountsSubHead] OFF
SET IDENTITY_INSERT [dbo].[COA] ON 

INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (1, 0, 0, N'Assets', 0, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (2, 0, 0, N'Liablites', 0, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (3, 0, 0, N'Equity', 0, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (4, 0, 0, N'Expense', 0, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (5, 0, 0, N'Revenue', 0, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (6, 1, 1, N'Inventory', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (7, 6, 1, N'StockInTrade', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (8, 6, 1, N'Diesel', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (9, 6, 1, N'Oil', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (10, 1, 1, N'AccountReceivable', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (11, 1, 1, N'Cash', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (12, 2, 2, N'AccountPayable', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (13, 4, 4, N'CostOfGoodsSold', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (14, 5, 5, N'Sales', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (19, 4, 4, N'Administrative Expenses', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (20, 4, 4, N'Inventory Expenses', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (21, 19, 4, N'Salaries', 2, 0)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (22, 20, 4, N'Generator Diesel', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (23, 19, 4, N'Office Expenses', 2, 0)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (24, 3, 3, N'Shareholder''s Equity', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (25, 0, 5, N'Bonus Revenue', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (27, 19, 4, N'Entertainment', 2, 0)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (30, 19, 4, N'Misc', 2, 0)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (99, 2, 2, N'Sales Tax', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (101, 5, 5, N'Sales Service', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (104, 1, 1, N'Bank Accounts', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (132, 3, 3, N'Adjustment Equity', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (133, 4, 4, N'Adjustment Cost of goods sold', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (147, 19, 4, N'parking', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (149, 19, 4, N'jeff', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (150, 19, 4, N'split ', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (151, 19, 4, N'cleaning', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (152, 19, 4, N'Kary pay', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (155, 19, 4, N'Adjustment', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (159, 19, 4, N'Buy', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (161, 19, 4, N'misc', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (162, 19, 4, N'rocky ', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (164, 4, 4, N'purchase', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (165, 19, 4, N'gas', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (166, 19, 4, N'Francis Pay', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (167, 19, 4, N'Suzuki Rent', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (168, 19, 4, N'rents', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (169, 19, 4, N'stationery', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (170, 19, 4, N'utility/wifi', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (171, 19, 4, N'fuel expences', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (172, 19, 4, N'salery', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (173, 19, 4, N'Taxes', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (181, 19, 4, N'Refreshment ', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (182, 19, 4, N'Suzuki Fuel', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (183, 19, 4, N'Photocopy', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (184, 19, 4, N'Hmot Office Rent', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (185, 19, 4, N'Sadqa ', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (186, 19, 4, N'Security Deposit Refundable ', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (187, 19, 4, N'Company Asset', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (189, 25, 5, N'Vendor2 Bonus', 2, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (190, 4, 4, N'Contra Revenue', 0, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (191, 190, 190, N'Sales Return', 1, 1)
INSERT [dbo].[COA] ([idx], [parentIdx], [headAccount], [accountName], [CoaLevel], [IsActive]) VALUES (192, 190, 190, N'Sales Discount', 1, 1)
SET IDENTITY_INSERT [dbo].[COA] OFF
SET IDENTITY_INSERT [dbo].[company] ON 

INSERT [dbo].[company] ([idx], [companyName], [ownerName], [STRN], [address], [contactNumber], [email], [companyLogo], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (11, N'NEW QUALITY CATERING SERVICES', N'MUHAMMAD ABDULLAH', N'123456', N'MEZZANINE FLOOR, ANUM ARCADE, PLOT # 33-C, 22ND EAST STREET, DHA PHASE 1, KARACHI
', NULL, NULL, NULL, CAST(0x0000AC1400E934D5 AS DateTime), 1, NULL, NULL, 1, 1)
SET IDENTITY_INSERT [dbo].[company] OFF
SET IDENTITY_INSERT [dbo].[companyBank] ON 

INSERT [dbo].[companyBank] ([idx], [bankIdx], [accountTitle], [Branch], [accountNumber], [creationDate], [createdByUserIdx], [visible], [lastModificationDate], [lastModifiedByUserIdx]) VALUES (6, 21, N'NEW QUALITY CATERING SERVICES', N'DHA PH 1', N'0000000974', CAST(0x0000AC14010CAD0F AS DateTime), 1, N'1         ', NULL, NULL)
INSERT [dbo].[companyBank] ([idx], [bankIdx], [accountTitle], [Branch], [accountNumber], [creationDate], [createdByUserIdx], [visible], [lastModificationDate], [lastModifiedByUserIdx]) VALUES (7, 51, N'NEW QUALITY CATERING SERVICES', N'DHA PH 1', N'00000006201', CAST(0x0000AC14010CF4EC AS DateTime), 1, N'1         ', NULL, NULL)
INSERT [dbo].[companyBank] ([idx], [bankIdx], [accountTitle], [Branch], [accountNumber], [creationDate], [createdByUserIdx], [visible], [lastModificationDate], [lastModifiedByUserIdx]) VALUES (8, 18, N'NEW QUALITY CATERING SERVICES', N'DHA PH 1', N'00000000684', CAST(0x0000AC14010D1743 AS DateTime), 1, N'1         ', NULL, NULL)
INSERT [dbo].[companyBank] ([idx], [bankIdx], [accountTitle], [Branch], [accountNumber], [creationDate], [createdByUserIdx], [visible], [lastModificationDate], [lastModifiedByUserIdx]) VALUES (9, 32, N'NEW QUALITY CATERING SERVICES', N'JORIA BAZAR, KHI', N'00000000654', CAST(0x0000AC14010D5878 AS DateTime), 1, N'1         ', NULL, NULL)
INSERT [dbo].[companyBank] ([idx], [bankIdx], [accountTitle], [Branch], [accountNumber], [creationDate], [createdByUserIdx], [visible], [lastModificationDate], [lastModifiedByUserIdx]) VALUES (10, 21, N'BISMILLAH FOODS R/M SUPPLIER', N'Shahbaz Comm.', N'000000307', CAST(0x0000AC14010D80D8 AS DateTime), 1, N'1         ', NULL, NULL)
INSERT [dbo].[companyBank] ([idx], [bankIdx], [accountTitle], [Branch], [accountNumber], [creationDate], [createdByUserIdx], [visible], [lastModificationDate], [lastModifiedByUserIdx]) VALUES (11, 21, N'BISMILLAH FOODS R/M SUPPLIER', N'DHA PH 1', N'000000975', CAST(0x0000AC14010DAD0C AS DateTime), 1, N'1         ', NULL, NULL)
SET IDENTITY_INSERT [dbo].[companyBank] OFF
SET IDENTITY_INSERT [dbo].[consumption] ON 

INSERT [dbo].[consumption] ([idx], [itemIdx], [consumedBy], [consumedQuanity], [creationDate], [createdByUserIdx], [status], [statusBy], [statusDate], [remarks], [lastModificationByUserIdx], [lastModificationDate], [visible], [stock]) VALUES (2, 16, 1, CAST(50.00 AS Decimal(20, 2)), CAST(0x0000AC1500000000 AS DateTime), 1, 1, 1, N'Aug 12 2020  3:42AM', NULL, 0, NULL, 1, CAST(50.00 AS Decimal(20, 2)))
INSERT [dbo].[consumption] ([idx], [itemIdx], [consumedBy], [consumedQuanity], [creationDate], [createdByUserIdx], [status], [statusBy], [statusDate], [remarks], [lastModificationByUserIdx], [lastModificationDate], [visible], [stock]) VALUES (3, 18, 1, CAST(2.00 AS Decimal(20, 2)), CAST(0x0000AC1500000000 AS DateTime), 1, 1, 1, N'Aug 12 2020  3:53AM', NULL, 0, NULL, 1, CAST(2.00 AS Decimal(20, 2)))
INSERT [dbo].[consumption] ([idx], [itemIdx], [consumedBy], [consumedQuanity], [creationDate], [createdByUserIdx], [status], [statusBy], [statusDate], [remarks], [lastModificationByUserIdx], [lastModificationDate], [visible], [stock]) VALUES (4, 16, 1, CAST(40.00 AS Decimal(20, 2)), CAST(0x0000AC1500000000 AS DateTime), 1, 1, 1, N'Aug 12 2020  7:18AM', NULL, 0, NULL, 1, CAST(50.00 AS Decimal(20, 2)))
INSERT [dbo].[consumption] ([idx], [itemIdx], [consumedBy], [consumedQuanity], [creationDate], [createdByUserIdx], [status], [statusBy], [statusDate], [remarks], [lastModificationByUserIdx], [lastModificationDate], [visible], [stock]) VALUES (5, 17, 1, CAST(18.00 AS Decimal(20, 2)), CAST(0x0000AC1500000000 AS DateTime), 1, 1, 1, N'Aug 12 2020  7:22AM', NULL, 0, NULL, 1, CAST(25.00 AS Decimal(20, 2)))
SET IDENTITY_INSERT [dbo].[consumption] OFF
SET IDENTITY_INSERT [dbo].[contract] ON 

INSERT [dbo].[contract] ([idx], [empCode], [employeeIdx], [departmentIdx], [designationIdx], [employeeTypeIdx], [contractTypeIdx], [contractStartDate], [contractEndDate], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 1, 1, 16, 15, 0, 1, N'2020-01-01', N'2021-01-01', CAST(0x0000AC1D00C2A261 AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[contract] OFF
SET IDENTITY_INSERT [dbo].[ContractType] ON 

INSERT [dbo].[ContractType] ([idx], [contractType], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, N'Permanent', CAST(0x0000ABCB0109BB58 AS DateTime), NULL, NULL, NULL, 1)
INSERT [dbo].[ContractType] ([idx], [contractType], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (2, N'Contractual', CAST(0x0000ABCB0109CBFC AS DateTime), NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[ContractType] OFF
SET IDENTITY_INSERT [dbo].[customers] ON 

INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (4, N'AZEEM UR REHMAN', N'GLAXOSMITHKLINE LTD', N'C-004', NULL, NULL, N'123', N'az@gsk.com', N'123', N'123', N'123', N'PETARO ROAD, JAMSHORO', NULL, CAST(0x0000AC1400FB9B60 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (5, N'SAJID AHMED', N'ARCHROMA PAKISTAN LTD, JAMSHORO', N'C-005', NULL, NULL, N'123', N'sajid@apl.com', N'123', N'123', N'123', N'PETARO ROAD, JAMSHORO', NULL, CAST(0x0000AC1400FC546B AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (6, N'REHAN ZUBAIR', N'ARCHROMA PAKISTAN LTD, HEAD OFFICE', N'C-006', NULL, NULL, N'123', N'rehan@apl.com', N'123', N'123', N'123', N'SINGER CHOWRANGI, KORANGI INDUSTRIAL AREA, KARACHI', NULL, CAST(0x0000AC1400FCCDE0 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (7, N'ZEESHAN', N'ARCHROMA PAKISTAN LTD, LANDHI PLANT', N'C-007', NULL, NULL, N'123', N'zeeshan@apl.com', N'123', N'123', N'123', N'INDUSTRIAL ZONE, KARACHI', NULL, CAST(0x0000AC1400FD3365 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (8, N'TARIQ', N'CLARIANT CHEMICALS PAKISTAN PVT. LTD', N'C-008', NULL, NULL, N'123', N'tariq@ccppl.com', N'123', N'123', N'123', N'SINGER CHOWRANGI, KORANGI INDUSTRIAL AREA, KARACHI', NULL, CAST(0x0000AC1400FDBDD7 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (9, N'RIFFAT', N'PROCTER & GAMBLE PAKISTAN PVT. LTD, PQ', N'C-009', NULL, NULL, N'123', N'riff@pg.com', N'123', N'123', N'123', N'PORT QASIM', NULL, CAST(0x0000AC1400FE4969 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (10, N'DANISH', N'PROCTER & GAMBLE PVT LTD, HUB', N'C-010', NULL, NULL, N'123', N'md@pg.com', N'123', N'123', N'123', N'PORT QASIM', NULL, CAST(0x0000AC140100A997 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (11, N'BEENISH', N'NESTLE PAKISTAN PVT LTD', N'C-011', NULL, NULL, N'123', N'beenish@nestle.com', N'123', N'123', N'123', N'PORT QASIM', NULL, CAST(0x0000AC1401010CB4 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (12, N'SALEEM', N'DP World NLCCT', N'C-012', NULL, NULL, N'123', N'saleem@dpworld.com', N'123', N'123', N'123', N'XYZ', NULL, CAST(0x0000AC1401013B3E AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (13, N'ASAD', N'CONTOUR SOFTWARE', N'C-013', NULL, NULL, N'123', N'asad@contour.com', N'123', N'123', N'123', N'Xyz', NULL, CAST(0x0000AC1401017AC3 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (14, N'ALLAH DETA', N'VENDING MACHINE PQ', N'C-014', NULL, NULL, N'123', N'ad@gmail.com', N'123', N'123', N'123', N'XYZ', NULL, CAST(0x0000AC140101DD59 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (15, N'ZUBAIR', N'HRSG OUTSOURCING- NESTLE WATER', N'C-015', NULL, NULL, N'123', N'zubair@hrsg', N'123', N'123', N'123', N'Xyz', NULL, CAST(0x0000AC1401028B00 AS DateTime), 1, N'11/08/2020', 1, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (16, N'ARIF', N'ATLAS ENGINEERING', N'C-016', NULL, NULL, N'123', N'arif@aip.com', N'123', N'123', N'123', N'Xyz', NULL, CAST(0x0000AC1401074697 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (17, N'ABC TESTING', N'TESTING CUSTOMER', N'CT-0001', NULL, NULL, N'03333106310', NULL, N'2414124', NULL, NULL, NULL, NULL, CAST(0x0000AC2B014E8A0A AS DateTime), 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (18, N'ABC TESTING', N'TESTING CUSTOMER', N'CT-0001', NULL, NULL, N'03333106310', NULL, N'2414124', NULL, NULL, NULL, NULL, CAST(0x0000AC2B014F1854 AS DateTime), 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (19, N'ABC TESTING 1', N'TESTING CUSTOMER 1', N'CT-0002', NULL, NULL, N'0534543', NULL, N'1123143', NULL, NULL, NULL, NULL, CAST(0x0000AC2B014F3F6D AS DateTime), 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000AC2B01537CCC AS DateTime), 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000AC4E01702E68 AS DateTime), 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[customers] ([idx], [contactPersonName], [customerName], [customerCode], [customerAccountType], [cnic], [contact], [emailAddress], [accountNo], [ntn], [strnNo], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0x0000AC4E0170F3CE AS DateTime), 1, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[customers] OFF
SET IDENTITY_INSERT [dbo].[department] ON 

INSERT [dbo].[department] ([idx], [departmentName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (16, N'ACCOUNTS & ADMIN', CAST(0x0000AC140103216E AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[department] ([idx], [departmentName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (17, N'CANTEEN ', CAST(0x0000AC140103316A AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[department] ([idx], [departmentName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (18, N'KITCHEN ', CAST(0x0000AC1401033BE1 AS DateTime), 1, NULL, 0, 1)
INSERT [dbo].[department] ([idx], [departmentName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (19, N'PROPRIETOR -HEAD OFFICE', CAST(0x0000AC14010367E2 AS DateTime), 1, NULL, 0, 1)
SET IDENTITY_INSERT [dbo].[department] OFF
SET IDENTITY_INSERT [dbo].[designation] ON 

INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (15, 16, N'ACCOUNTANT', CAST(0x0000AC1401038AAD AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (16, 17, N'CANTEEN SUPERVISOR', CAST(0x0000AC140103B2D9 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (17, 17, N'CANTEEN MANAGER', CAST(0x0000AC140103CF66 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (18, 17, N'WAITER', CAST(0x0000AC14010594C4 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (19, 17, N'GENERAL WORKER', CAST(0x0000AC140105B3A1 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (20, 17, N'HEAD COOK', CAST(0x0000AC140105C881 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (21, 17, N'COOK HELPER', CAST(0x0000AC140105DBDE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (22, 17, N'DISH WASHER', CAST(0x0000AC140105F497 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (23, 17, N'TEA MAKER', CAST(0x0000AC1401064788 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (24, 17, N'TEA SERVING STAFF', CAST(0x0000AC1401066A9C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (25, 17, N'CHAPATI MAKER', CAST(0x0000AC14010684CA AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (26, 17, N'TANDOOR STAFF', CAST(0x0000AC140106A085 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (27, 18, N'HEAD COOK', CAST(0x0000AC1401076DF1 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (28, 18, N'GENERAL WORKER', CAST(0x0000AC1401078A67 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (29, 18, N'DISH WASHER', CAST(0x0000AC140107A1C8 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (30, 18, N'COOK HELPER', CAST(0x0000AC140107BD72 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (31, 18, N'KITCHEN SUPERVISOR', CAST(0x0000AC140107D0BD AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (32, 18, N'STORE KEEPER', CAST(0x0000AC140107EB7F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (33, 19, N'CEO', CAST(0x0000AC140107FDB3 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (34, 16, N'PURCHASING STAFF', CAST(0x0000AC1401082FC0 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (35, 16, N'HR MANAGER', CAST(0x0000AC140108A642 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (36, 16, N'BUSINESS DEVELOPEMENT MANAGER', CAST(0x0000AC140108C581 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (37, 16, N'CASHIER', CAST(0x0000AC140108F0DD AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (38, 16, N'PEON & RIDDER', CAST(0x0000AC1401091BBD AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (39, 16, N'RECOVERY OFFICER', CAST(0x0000AC140109462D AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (40, 16, N'DRIVER', CAST(0x0000AC14010956C0 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[designation] ([idx], [departmentIdx], [designationName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (41, 18, N'DRIVER', CAST(0x0000AC1401096EC6 AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[designation] OFF
SET IDENTITY_INSERT [dbo].[employees] ON 

INSERT [dbo].[employees] ([idx], [hrmsNumber], [firstName], [lastName], [cnic], [dateOfBirth], [contactNumber], [maritalIdx], [genderIdx], [emailAddress], [address], [departmentIdx], [designationIdx], [hiringDate], [avatar], [isActive], [isTerminated], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 1, N'Salaman', N'nqcs', N'5454654654654', N'1990-01-10', N'654654654654', 5, 1, N'abc@gmail.com', N'ABC', 16, 15, N'2020-01-01', NULL, 1, 1, CAST(0x0000AC1D00C27C10 AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[employees] OFF
SET IDENTITY_INSERT [dbo].[employeeType] ON 

INSERT [dbo].[employeeType] ([idx], [employeeType], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (7, N'HEAD OFFICE', CAST(0x0000AC1401098D6C AS DateTime), 1, NULL, NULL, 0)
INSERT [dbo].[employeeType] ([idx], [employeeType], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (8, N'HEAD OFFICE STAFF', CAST(0x0000AC14010A0FF3 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[employeeType] ([idx], [employeeType], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (9, N'KITCHEN STAFF', CAST(0x0000AC14010A21EC AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[employeeType] ([idx], [employeeType], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (10, N'CANTEEN STAFF', CAST(0x0000AC14010A3195 AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[employeeType] OFF
SET IDENTITY_INSERT [dbo].[gender] ON 

INSERT [dbo].[gender] ([idx], [Gender], [creationDate], [createdByUserIdx], [visible]) VALUES (1, N'Male', NULL, NULL, 1)
INSERT [dbo].[gender] ([idx], [Gender], [creationDate], [createdByUserIdx], [visible]) VALUES (2, N'Female', NULL, NULL, 1)
INSERT [dbo].[gender] ([idx], [Gender], [creationDate], [createdByUserIdx], [visible]) VALUES (3, N'Others', NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[gender] OFF
SET IDENTITY_INSERT [dbo].[inventory] ON 

INSERT [dbo].[inventory] ([idx], [productIdx], [stock], [productTypeIdx], [unitPrice], [totalAmount], [creationDate]) VALUES (1, 1, CAST(10.00 AS Decimal(20, 2)), NULL, CAST(200.00 AS Decimal(20, 2)), CAST(2000.00 AS Decimal(20, 2)), CAST(0x0000AC5800E0D7E4 AS DateTime))
INSERT [dbo].[inventory] ([idx], [productIdx], [stock], [productTypeIdx], [unitPrice], [totalAmount], [creationDate]) VALUES (2, 2, CAST(10.00 AS Decimal(20, 2)), NULL, CAST(200.00 AS Decimal(20, 2)), CAST(2000.00 AS Decimal(20, 2)), CAST(0x0000AC5800E0D824 AS DateTime))
SET IDENTITY_INSERT [dbo].[inventory] OFF
SET IDENTITY_INSERT [dbo].[inventory_logs] ON 

INSERT [dbo].[inventory_logs] ([idx], [productIdx], [stock], [productTypeIdx], [unitPrice], [totalAmount], [creationDate], [TransactionTypeID], [MasterID]) VALUES (1, 2, CAST(12.00 AS Decimal(20, 2)), NULL, CAST(3.00 AS Decimal(20, 2)), CAST(36.00 AS Decimal(20, 2)), CAST(0x0000AC56000DD26C AS DateTime), NULL, NULL)
INSERT [dbo].[inventory_logs] ([idx], [productIdx], [stock], [productTypeIdx], [unitPrice], [totalAmount], [creationDate], [TransactionTypeID], [MasterID]) VALUES (2, 1, CAST(12.00 AS Decimal(20, 2)), NULL, CAST(3.00 AS Decimal(20, 2)), CAST(36.00 AS Decimal(20, 2)), CAST(0x0000AC56000DD293 AS DateTime), NULL, NULL)
INSERT [dbo].[inventory_logs] ([idx], [productIdx], [stock], [productTypeIdx], [unitPrice], [totalAmount], [creationDate], [TransactionTypeID], [MasterID]) VALUES (3, 1, CAST(-1.00 AS Decimal(20, 2)), NULL, CAST(2.00 AS Decimal(20, 2)), CAST(2.00 AS Decimal(20, 2)), CAST(0x0000AC56001293BF AS DateTime), NULL, NULL)
INSERT [dbo].[inventory_logs] ([idx], [productIdx], [stock], [productTypeIdx], [unitPrice], [totalAmount], [creationDate], [TransactionTypeID], [MasterID]) VALUES (4, 1, CAST(10.00 AS Decimal(20, 2)), NULL, CAST(200.00 AS Decimal(20, 2)), CAST(2000.00 AS Decimal(20, 2)), CAST(0x0000AC5800E0D7F2 AS DateTime), NULL, NULL)
INSERT [dbo].[inventory_logs] ([idx], [productIdx], [stock], [productTypeIdx], [unitPrice], [totalAmount], [creationDate], [TransactionTypeID], [MasterID]) VALUES (5, 2, CAST(10.00 AS Decimal(20, 2)), NULL, CAST(200.00 AS Decimal(20, 2)), CAST(2000.00 AS Decimal(20, 2)), CAST(0x0000AC5800E0D82A AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[inventory_logs] OFF
SET IDENTITY_INSERT [dbo].[InventoryDetail] ON 

INSERT [dbo].[InventoryDetail] ([Idx], [InventoryIdx], [PurchaseDetailidx], [ConsumptionIdx]) VALUES (1, 1, 1, 0)
INSERT [dbo].[InventoryDetail] ([Idx], [InventoryIdx], [PurchaseDetailidx], [ConsumptionIdx]) VALUES (2, 2, 2, 0)
SET IDENTITY_INSERT [dbo].[InventoryDetail] OFF
SET IDENTITY_INSERT [dbo].[itemUnits] ON 

INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (15, N'KG', CAST(0x0000AC14010AD1AE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (16, N'GRAM', CAST(0x0000AC14010AE4B8 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (17, N'16 LITER TIN', CAST(0x0000AC14010B2694 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (18, N'16 LITER CANE', CAST(0x0000AC14010B498F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (19, N'1000 GM PKT', CAST(0x0000AC14010B55F0 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (20, N'12 LITER CARTON', CAST(0x0000AC14010B70A7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (21, N'CARTON', CAST(0x0000AC14010B7CFE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (22, N'10 KG CARTON', CAST(0x0000AC14010B9ACE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (23, N'PER HEAD', CAST(0x0000AC14010BB33A AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (24, N'PER CUP', CAST(0x0000AC14010BBF79 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[itemUnits] ([idx], [unit], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (25, N'1', CAST(0x0000AC14010BC86C AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[itemUnits] OFF
SET IDENTITY_INSERT [dbo].[maritalStatus] ON 

INSERT [dbo].[maritalStatus] ([idx], [MaritalStatus], [creationDate], [createdByUserIdx], [visible]) VALUES (1, N'Married', NULL, NULL, 1)
INSERT [dbo].[maritalStatus] ([idx], [MaritalStatus], [creationDate], [createdByUserIdx], [visible]) VALUES (2, N'Single', NULL, NULL, 1)
INSERT [dbo].[maritalStatus] ([idx], [MaritalStatus], [creationDate], [createdByUserIdx], [visible]) VALUES (3, N'Widowed', NULL, NULL, 1)
INSERT [dbo].[maritalStatus] ([idx], [MaritalStatus], [creationDate], [createdByUserIdx], [visible]) VALUES (4, N'Divorced', NULL, NULL, 1)
INSERT [dbo].[maritalStatus] ([idx], [MaritalStatus], [creationDate], [createdByUserIdx], [visible]) VALUES (5, N'Engaged', NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[maritalStatus] OFF
SET IDENTITY_INSERT [dbo].[Month] ON 

INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (1, N'Jan', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (2, N'Feb', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (3, N'March', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (4, N'Apr', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (5, N'May', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (6, N'June', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (7, N'July', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (8, N'Aug', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (9, N'Sep', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (10, N'Oct', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (11, N'Nov', 1)
INSERT [dbo].[Month] ([idx], [month], [visible]) VALUES (12, N'Dec', 1)
SET IDENTITY_INSERT [dbo].[Month] OFF
SET IDENTITY_INSERT [dbo].[paymentMode] ON 

INSERT [dbo].[paymentMode] ([idx], [paymentMode]) VALUES (1, N'Cash')
INSERT [dbo].[paymentMode] ([idx], [paymentMode]) VALUES (2, N'Cheque')
INSERT [dbo].[paymentMode] ([idx], [paymentMode]) VALUES (3, N'Bank')
SET IDENTITY_INSERT [dbo].[paymentMode] OFF
SET IDENTITY_INSERT [dbo].[planner] ON 

INSERT [dbo].[planner] ([ID], [TO_DO], [TO_DO_Date], [DateCreated], [CreatedBy], [status]) VALUES (1, N'Task 1', CAST(0x0000AC5000000000 AS DateTime), CAST(0x0000AC4E01334A3E AS DateTime), 1, 1)
SET IDENTITY_INSERT [dbo].[planner] OFF
SET IDENTITY_INSERT [dbo].[products] ON 

INSERT [dbo].[products] ([idx], [productTypeIdx], [itemName], [itemCode], [unit], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 16, N'TEST 1', N'P-0001', 1, N'TEST', CAST(0x0000AC2C0174F5A5 AS DateTime), 1, NULL, NULL, NULL)
INSERT [dbo].[products] ([idx], [productTypeIdx], [itemName], [itemCode], [unit], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (2, 19, N'TEST 2', N'P-0002', 1, N'TEST', CAST(0x0000AC3701372B32 AS DateTime), 1, NULL, NULL, NULL)
INSERT [dbo].[products] ([idx], [productTypeIdx], [itemName], [itemCode], [unit], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (3, 16, N'TEST 3', N'P-0003', 1, N'TEST', CAST(0x0000AC47005CB13E AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[products] OFF
SET IDENTITY_INSERT [dbo].[productType] ON 

INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (14, N'GROCERY & GENERAL ITEMS', 1, CAST(0x6F410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (15, N'MEAT', 1, CAST(0x6F410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (16, N'VEGETABLES', 1, CAST(0x6F410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (17, N'FRUIT', 1, CAST(0x6F410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (18, N'SPICES', 1, CAST(0x6F410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (19, N'p1', 1, CAST(0x83410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (20, N'p2', 1, CAST(0x83410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (21, N'p3', 1, CAST(0x86410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (22, N'p4', 1, CAST(0x86410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (23, N'p15', 1, CAST(0xA9410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (24, N'flour1', 1, CAST(0xA9410B00 AS Date))
INSERT [dbo].[productType] ([idx], [productType], [createdByUserIdx], [creationDate]) VALUES (25, N'rice', 1, CAST(0xA9410B00 AS Date))
SET IDENTITY_INSERT [dbo].[productType] OFF
SET IDENTITY_INSERT [dbo].[pruchaseDetails] ON 

INSERT [dbo].[pruchaseDetails] ([idx], [purchaseIdx], [productTypeIdx], [itemIdx], [unitPrice], [qty], [amount], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [DueDate]) VALUES (1, 1, 1, 1, CAST(200.00 AS Decimal(20, 2)), CAST(10.00 AS Decimal(20, 2)), CAST(2000.00 AS Decimal(20, 2)), CAST(0x0000AC5800000000 AS DateTime), 1, N'10/18/2020 1:38:37 PM', NULL, 1, CAST(0x0000AC5A00000000 AS DateTime))
INSERT [dbo].[pruchaseDetails] ([idx], [purchaseIdx], [productTypeIdx], [itemIdx], [unitPrice], [qty], [amount], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [DueDate]) VALUES (2, 1, 1, 2, CAST(200.00 AS Decimal(20, 2)), CAST(10.00 AS Decimal(20, 2)), CAST(2000.00 AS Decimal(20, 2)), CAST(0x0000AC5800000000 AS DateTime), 1, N'10/18/2020 1:38:37 PM', NULL, 1, CAST(0x0000AC5B00000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[pruchaseDetails] OFF
SET IDENTITY_INSERT [dbo].[purchase] ON 

INSERT [dbo].[purchase] ([idx], [poNumber], [vendorIdx], [purchaseTypeIdx], [purchaseDate], [description], [totalAmount], [netAmount], [paidAmount], [balanceAmount], [paymentModeIdx], [bankIdx], [accorChequeNumber], [paidDate], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [paymentStatus], [status], [isPaid], [discount], [tax], [taxAount], [purchaseduedate]) VALUES (1, N'PR-001', 7, 0, N'2020-10-17', N'TEST', CAST(4000.00 AS Decimal(20, 2)), CAST(4000.00 AS Decimal(20, 2)), N'0', N'4000', 1, 0, NULL, NULL, CAST(0x0000AC5800E0D71E AS DateTime), 1, NULL, NULL, 1, NULL, NULL, 0, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), NULL)
SET IDENTITY_INSERT [dbo].[purchase] OFF
SET IDENTITY_INSERT [dbo].[PurchaseType] ON 

INSERT [dbo].[PurchaseType] ([idx], [purchaseType], [creationDate], [visible]) VALUES (1, N'MRN', CAST(0x0000AB73014A70F6 AS DateTime), 1)
INSERT [dbo].[PurchaseType] ([idx], [purchaseType], [creationDate], [visible]) VALUES (2, N'Direct Purchase', CAST(0x0000AB73014A86C9 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[PurchaseType] OFF
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 2, N'48', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708C9 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (2, 2, N'37', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708D7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (3, 2, N'36', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708DC AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (4, 2, N'72', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708E1 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (5, 2, N'73', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708E4 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (6, 2, N'49', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708E7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (7, 2, N'66', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708EB AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (8, 2, N'67', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708EE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (9, 2, N'64', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708F1 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (10, 2, N'70', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708F6 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (11, 2, N'7', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708FA AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (12, 2, N'6', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E708FD AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (13, 2, N'45', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70900 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (14, 2, N'55', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70904 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (15, 2, N'56', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70908 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (16, 2, N'57', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7090B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (17, 2, N'58', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7090E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (18, 2, N'22', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70913 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (19, 2, N'21', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70916 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (20, 2, N'59', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70919 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (21, 2, N'60', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7091C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (22, 2, N'41', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70920 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (23, 2, N'50', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70923 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (24, 2, N'34', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70926 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (25, 2, N'54', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7092B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (26, 2, N'51', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7092E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (27, 2, N'61', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70930 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (28, 2, N'62', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70933 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (29, 2, N'75', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70936 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (30, 2, N'8', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70939 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (31, 2, N'9', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7093D AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (32, 2, N'63', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70940 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (33, 2, N'15', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7094B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (34, 2, N'16', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7094F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (35, 2, N'46', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70952 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (36, 2, N'17', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70955 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (37, 2, N'18', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70958 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (38, 2, N'10', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7095B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (39, 2, N'12', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7095E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (40, 2, N'11', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70963 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (41, 2, N'23', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70967 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (42, 2, N'25', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70969 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (43, 2, N'27', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7096C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (44, 2, N'26', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70974 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (45, 2, N'24', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70976 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (46, 2, N'28', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70979 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (47, 2, N'30', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7097C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (48, 2, N'29', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7097F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (49, 2, N'31', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70982 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (50, 2, N'33', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70986 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (51, 2, N'32', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7098B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (52, 2, N'19', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7098F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (53, 2, N'20', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70992 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (54, 2, N'47', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70995 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (55, 2, N'13', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E70998 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (56, 2, N'14', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7099B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (57, 2, N'35', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E7099E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (58, 2, N'52', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709A1 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (59, 2, N'2', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709A4 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (60, 2, N'3', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709AA AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (61, 2, N'1', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709AD AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (62, 2, N'5', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709B1 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (63, 2, N'68', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709B4 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (64, 2, N'69', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709B7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (65, 2, N'43', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709C0 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (66, 2, N'65', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709C3 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (67, 2, N'4', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709C7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (68, 2, N'71', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709CB AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Roles] ([idx], [employeeIdx], [pageUrl], [add], [edit], [delete], [view], [approved], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (69, 2, N'44', NULL, NULL, NULL, NULL, 0, CAST(0x0000ABF200E709CE AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Roles] OFF
SET IDENTITY_INSERT [dbo].[salary] ON 

INSERT [dbo].[salary] ([idx], [empIdx], [basicSalary], [hraAllowance], [daAllowance], [conveyance], [medicalAllowance], [others], [netSalary], [isActive], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 1, 30000, 1000, 0, 0, 2000, 2000, 35000, 1, CAST(0x0000AC1D00CAB317 AS DateTime), NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[salary] OFF
SET IDENTITY_INSERT [dbo].[sales] ON 

INSERT [dbo].[sales] ([idx], [soNumber], [customerIdx], [description], [totalAmount], [taxAmount], [WithHoldingTax], [SindhTax], [netAmount], [Paid], [Balance], [isPaid], [discount], [paidDate], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [paymentStatus], [status], [paymentModeIdx], [bankIdx], [chequeNumber], [salesDate]) VALUES (1, N'SI-001', 4, N'TEST', CAST(2.00 AS Decimal(20, 2)), NULL, NULL, NULL, CAST(2.00 AS Decimal(20, 2)), CAST(0.00 AS Decimal(20, 2)), N'2         ', 0, NULL, NULL, CAST(0x0000AC5600000000 AS DateTime), 1, NULL, NULL, 1, NULL, 0, 1, 0, NULL, N'2020-10-16')
INSERT [dbo].[sales] ([idx], [soNumber], [customerIdx], [description], [totalAmount], [taxAmount], [WithHoldingTax], [SindhTax], [netAmount], [Paid], [Balance], [isPaid], [discount], [paidDate], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [paymentStatus], [status], [paymentModeIdx], [bankIdx], [chequeNumber], [salesDate]) VALUES (2, N'SI-002', 6, N'TEST', CAST(3000.00 AS Decimal(20, 2)), NULL, NULL, NULL, CAST(3000.00 AS Decimal(20, 2)), CAST(0.00 AS Decimal(20, 2)), N'3000      ', 0, NULL, NULL, CAST(0x0000AC5600000000 AS DateTime), 1, NULL, NULL, 1, NULL, 0, 1, 0, NULL, N'2020-10-16')
SET IDENTITY_INSERT [dbo].[sales] OFF
SET IDENTITY_INSERT [dbo].[salesDetails] ON 

INSERT [dbo].[salesDetails] ([idx], [salesIdx], [serviceIdx], [serviceCode], [unit], [serviceRate], [serviceDescription], [serviceQty], [subAmount], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, 1, 1, NULL, NULL, CAST(2.00 AS Decimal(10, 2)), NULL, CAST(1.00 AS Decimal(10, 2)), CAST(2.00 AS Decimal(10, 2)), CAST(0x0000AC56001293A9 AS DateTime), 1, N'10/16/2020 1:07:38 AM', NULL, 1)
INSERT [dbo].[salesDetails] ([idx], [salesIdx], [serviceIdx], [serviceCode], [unit], [serviceRate], [serviceDescription], [serviceQty], [subAmount], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (2, 2, 1, NULL, NULL, CAST(20.00 AS Decimal(10, 2)), NULL, CAST(100.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), CAST(0x0000AC560038571B AS DateTime), 1, N'10/16/2020 3:25:07 AM', NULL, 1)
INSERT [dbo].[salesDetails] ([idx], [salesIdx], [serviceIdx], [serviceCode], [unit], [serviceRate], [serviceDescription], [serviceQty], [subAmount], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (3, 2, 2, NULL, NULL, CAST(20.00 AS Decimal(10, 2)), NULL, CAST(50.00 AS Decimal(10, 2)), CAST(1000.00 AS Decimal(10, 2)), CAST(0x0000AC560038573A AS DateTime), 1, N'10/16/2020 3:25:07 AM', NULL, 1)
SET IDENTITY_INSERT [dbo].[salesDetails] OFF
SET IDENTITY_INSERT [dbo].[stations] ON 

INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (10, N'HEAD OFFICE', N'MEZZANINE FLOOR, ANUM ARCAD, PLOT # 33-C, 22ND EAST STREET, DHA PHASE 1, KARACHI', NULL, NULL, CAST(0x0000AC1400EB7B17 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (11, N'P&G HUB PLANT', N'HUB BALOCHISTAN', NULL, NULL, CAST(0x0000AC1400ECCADD AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (12, N' NESTLE WATER PLANT', N' PORT QASIM', NULL, NULL, CAST(0x0000AC1400ECF57F AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (13, N' DP WORLD- NLCCT', N' KARACHI', NULL, NULL, CAST(0x0000AC1400ED2869 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (14, N' P&G PQ PLANT', N' PORT QASIM, KARACHI', NULL, NULL, CAST(0x0000AC1400ED9445 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (15, N' CONTOUR SOFTWARE', N' JAIL CHOWRANGI, KARACHI', NULL, NULL, CAST(0x0000AC1400EDCB0C AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (16, N' GSK JAMSHORO PLANT', N' PETARO ROAD, JAMSHORO', NULL, NULL, CAST(0x0000AC1400EE29BE AS DateTime), 1, NULL, NULL, 1, 0)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (17, N' ARCHROMA JAMSHORO PLANT', N' PETARO ROAD, JAMSHORO', NULL, NULL, CAST(0x0000AC1400EE5541 AS DateTime), 1, NULL, NULL, 1, 0)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (18, N' ARCROMA HEAD OFFICE', N'SINGER CHOWRANGI, KORANGI INDUSTRIAL AREA, KARACHI', NULL, NULL, CAST(0x0000AC1400EED342 AS DateTime), 1, NULL, NULL, 1, 0)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (19, N'GSK JAMSHORO PLANT', N'PETARO ROAD, JAMSHORO', NULL, NULL, CAST(0x0000AC1400F16B09 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (20, N' ARCHROMA JAMSHORO PLANT', N' PETARO ROAD, JAMSHORO', NULL, NULL, CAST(0x0000AC1400F19F6C AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (21, N' ARCHROMA HEAD OFFICE', N' SINGER CHOWRANGI, KORANGI INDUSTRIAL AREA, KARACHI', NULL, NULL, CAST(0x0000AC1400F1C1F4 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (23, N' CLARIANT CHEMICALS PAKISTAN PVT. LTD', N' SINGER CHOWRANGI, KORANGI INDUSTRIAL AREA, KARACHI', NULL, NULL, CAST(0x0000AC1400F299C7 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (24, N'ARCHROMA LANDHI PLANT', N'INDUSTRIAL ZONE, KARACHI', NULL, NULL, CAST(0x0000AC1400F68E29 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (25, N'VENDING MACHINE P&G PQ PLANT', N'PORT QASIM', NULL, NULL, CAST(0x0000AC1400F758A1 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (26, N'ATLAS ENGINEERING', N'NATIONAL HIGHWAY', NULL, NULL, CAST(0x0000AC1401070037 AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (27, N'CLARIANT CHEMICALS PAKISTAN PVT. LTD-LHR', N'Katar Bund Road, Thokar Niaz Baig, Lahore', NULL, NULL, CAST(0x0000AC15002BD8EA AS DateTime), 1, NULL, NULL, 1, 1)
INSERT [dbo].[stations] ([idx], [stationName], [address], [contactNumber], [email], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible]) VALUES (28, N'Artistic Millinors', N'xyz', NULL, NULL, CAST(0x0000AC150080E666 AS DateTime), 1, NULL, NULL, 1, 1)
SET IDENTITY_INSERT [dbo].[stations] OFF
SET IDENTITY_INSERT [dbo].[transactionType] ON 

INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (1, N'Purchase', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (2, N'Sales', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (3, N'General Voucher', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (4, N'Expense', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (5, N'Payment Against Credit Sales', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (6, N'Payment Against Credit Purchase', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (7, N'Advance Salary', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (8, N'Loan', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (9, N'Expense', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (10, N'Consumption', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (11, N'Customer Opening', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (12, N'Vendor Opening', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (13, N'Customer Opening Receipt', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (14, N'Vendor Opening Receipt', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (15, N'Cash Transfer', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (16, N'Puchase Return', 1)
INSERT [dbo].[transactionType] ([idx], [Name], [IsActive]) VALUES (17, N'Sales Return', 1)
SET IDENTITY_INSERT [dbo].[transactionType] OFF
SET IDENTITY_INSERT [dbo].[Url] ON 

INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (1, N'RegisterUsers.aspx', N'Users Registration', CAST(0x0000AB7B0112E733 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (2, N'UsersList.aspx', N'Users List', CAST(0x0000AB7B0112EC68 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (3, N'pageAccess.aspx', N'Users Page Access', CAST(0x0000AB7E01191744 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (4, N'RegisterVendor.aspx', N'Vendor Registration', CAST(0x0000AB7E011928E8 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (5, N'VendorList.aspx', N'Vendor List', CAST(0x0000AB7E01192D6E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (6, N'RegisterCustomer.aspx', N'Customers Registration', CAST(0x0000AB7E01195FB5 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (7, N'CustomerList.aspx', N'Customers List', CAST(0x0000AB7E011980A3 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (8, N'AddProducts.aspx', N'Product Add', CAST(0x0000AB7E011991A7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (9, N'ProductSetupList.aspx', N'Product List', CAST(0x0000AB7E0119A56A AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (10, N'RawMaterial.aspx', N'Raw Material', CAST(0x0000AB7E0119B31B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (11, N'ConsumptionRequestList.aspx', N'Raw Material Request List', CAST(0x0000AB7E0119C276 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (12, N'RawMaterialList.aspx', N'Raw Material List', CAST(0x0000AB7E0119D308 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (13, N'AddServices.aspx', N'Services Add', CAST(0x0000AB7E0119E246 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (14, N'ServiceList.aspx', N'Services List', CAST(0x0000AB7E0119F098 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (15, N'AddPurchase.aspx', N'Purchase Add', CAST(0x0000AB7E011A06FD AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (16, N'PurchaseList.aspx', N'Purchase List', CAST(0x0000AB7E011A160E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (17, N'PurchaseRequestList.aspx', N'Purchase Request List', CAST(0x0000AB7E011A3A0E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (18, N'GoodReceivedList.aspx', N'Purchased Good Recived List', CAST(0x0000AB7E011A8EE6 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (19, N'Sales.aspx', N'Sales Add', CAST(0x0000AB7E011AB031 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (20, N'SalesList.aspx', N'Sales List', CAST(0x0000AB7E011AC25C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (21, N'EmployeeRegistration.aspx', N'Employee Registration', CAST(0x0000AB7E011ADB9B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (22, N'EmployeeList.aspx', N'Employee List', CAST(0x0000AB7E011AF3AF AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (23, N'AddSalary.aspx', N'Salary Add', CAST(0x0000AB7E011B099C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (24, N'EmployeeSalaryList.aspx', N'Salary List', CAST(0x0000AB7E011B1D99 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (25, N'AddAdvance.aspx', N'Salary Advance', CAST(0x0000AB7E011B37F8 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (26, N'AdvanceSalaryList.aspx', N'Salary Advance List', CAST(0x0000AB7E011B48FB AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (27, N'AdvanceAprovalList.aspx', N'Salary Advance Approval', CAST(0x0000AB7E011B584B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (28, N'AddLoan.aspx', N'Salary Loan', CAST(0x0000AB7E011B6E62 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (29, N'LoanList.aspx', N'Salary Loan List', CAST(0x0000AB7E011B7EFE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (30, N'LoanAprovalList.aspx', N'Salary Loan Approval', CAST(0x0000AB7E011B92EE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (31, N'EmployeesPayroll.aspx', N'Salary Payroll', CAST(0x0000AB7E011BA46F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (32, N'EmployeesPayrollList.aspx', N'Salary Payroll List', CAST(0x0000AB7E011BB7E6 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (33, N'PayrollList', N'Salary Payroll Approval', CAST(0x0000AB7E011BD7BC AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (34, N'HeadAccounts.aspx', N'Head Accounts', CAST(0x0000AB7E011BEA2F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (35, N'SubHeadAccounts.aspx', N'Sub Head Accounts', CAST(0x0000AB7E011BFDF7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (36, N'ChildHeadAccounts.aspx', N'Child Head Accounts', CAST(0x0000AB7E011C0C27 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (37, N'coaList.aspx', N'Chart of Accounts', CAST(0x0000AB7E011C1B3E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (38, N'JournalEntry.aspx', N'Journal Entry', CAST(0x0000AB7E011C5F0C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (39, N'JournalEntryList.aspx', N'Journal Entry List', CAST(0x0000AB7E011C697F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (40, N'AddExpense.aspx', N'Expense Add', CAST(0x0000AB7E013418FB AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (41, N'ExpenseList.aspx', N'Expense List', CAST(0x0000AB7E0134258D AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (42, N'CustomerPayment.aspx', N'Customer Payment', CAST(0x0000AB7E01349D38 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (43, N'VendorPayment.aspx', N'Vendor Payment', CAST(0x0000AB7E0134B40E AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (44, N'VendorReports.aspx', N'Vendors Report', CAST(0x0000AB7E0137509C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (45, N'CustomerReport.aspx', N'Customers Report', CAST(0x0000AB96016FAD8B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (46, N'PurchaseReport.aspx', N'Purchase Report', CAST(0x0000AB96016FBEB4 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (47, N'SaleRepotrs.aspx', N'Sales Report', CAST(0x0000AB96016FF6D7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (48, N'AccountReceivableReports.aspx', N'Accounts Receivable Report', CAST(0x0000AB9601703D3A AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (49, N'ConsumptionReports.aspx', N'Consumption Report', CAST(0x0000AB96017102E2 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (50, N'ExpenseReport.aspx', N'Expense Report', CAST(0x0000AB96017115D9 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (51, N'InventoryReport.aspx', N'Inventory Report', CAST(0x0000AB96017124DE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (52, N'TrialBalanceReport.aspx', N'Trial Balance Report', CAST(0x0000AB960171352B AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (53, N'BalanceSheet.aspx', N'Balance Sheet', CAST(0x0000AB96017142CB AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (54, N'IncomeStatement.aspx', N'Income Statement', CAST(0x0000AB960171548F AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (55, N'AddDepartment.aspx', N'Department Add', CAST(0x0000AB9601717015 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (56, N'DepartmentList.aspx', N'Department List', CAST(0x0000AB9601717B5C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (57, N'AddDesignation.aspx', N'Designation Add', CAST(0x0000AB9601718799 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (58, N'DesignationList.aspx', N'Designation List', CAST(0x0000AB96017193EE AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (59, N'AddEmployeeType.aspx', N'Employee Type', CAST(0x0000AB960171B5DF AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (60, N'EmployeeTypeList.aspx', N'Employee Type List', CAST(0x0000AB960171C2D0 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (61, N'Units.aspx', N'Item Unit', CAST(0x0000AB960171D528 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (62, N'ItemUnitsList.aspx', N'Item Unit List', CAST(0x0000AB960171E271 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (63, N'ProductTypeList', N'Product Type List', CAST(0x0000AB9E0182F416 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (64, N'CustomerPaymentHistory.aspx', N'Customer Payment History', CAST(0x0000ABDE00E656A8 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (72, N'CompanyBank.aspx', N'Company Bank', CAST(0x0000ABDE00EB5247 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (73, N'CompanyBankList', N'Company Bank List', CAST(0x0000ABDE00EB6D76 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (78, N'bankStatement.aspx', N'Bank Statement', CAST(0x0000ABF700F402E6 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (75, N'LedgerReport.aspx', N'Ledger Report', CAST(0x0000ABEA00CB200D AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (65, N'VendorPaymentHistory.aspx', N'Vendor Payment History', CAST(0x0000ABDE00E715E1 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (66, N'CustomerOpeningBalanceList.aspx', N'Customer Opening Balance List', CAST(0x0000ABDE00E74DB4 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (67, N'CustomerOpeningReceipt.aspx', N'Customer Opening Balance Receipt', CAST(0x0000ABDE00E86CC8 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (68, N'VendorOpeningBalanceList.aspx', N'Vendor Opening Balance List', CAST(0x0000ABDE00E88A6C AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (69, N'VendorOpeningPayment.aspx', N'Vendor Opening Balance Payment', CAST(0x0000ABDE00E8CFD7 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (70, N'CustomerStatement.aspx', N'Customer Statement', CAST(0x0000ABDE00EAB796 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (71, N'VendorStatement.aspx', N'Vendor Statement', CAST(0x0000ABDE00EAD075 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (79, N'AddContract.aspx', N'Contract', CAST(0x0000AC1C00FF4AFB AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (80, N'ContractList.aspx', N'Contract List', CAST(0x0000AC1C00FF6825 AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[Url] ([idx], [pageUrl], [pageName], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible]) VALUES (81, N'contractRenewal.aspx', N'Renew Contract', CAST(0x0000AC1C00FFA752 AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Url] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (1, N'Super', N'Admin', N'000000000000', N'0000000000', N'izhar@supersoft-tech.com', 1, 1, N'sadmin', N'123', 1, CAST(0x0000AB7700FC863F AS DateTime), 1, N'', NULL, 1, 1, N'6879315', 1, 1)
INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (2, N'normal u', N'User u', N'12115451245', N'2112121', N'izhar@suupersoft-tech.com', 1, 1, N'useru', N'123u', 1, CAST(0x0000AB7700FC863F AS DateTime), 1, N'10/09/2020', 1, 1, 1, N'6879315', 1, 1)
INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (3, N'umer', N'nasir', N'2343525', NULL, N'umernasir19@yahoo.com', NULL, NULL, NULL, N'123', NULL, CAST(0x0000AC2B0143D224 AS DateTime), 1, NULL, NULL, 0, 0, NULL, NULL, 1)
INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (4, N'umer', N'nasir', N'324324', NULL, N'umernasir19@yahoo.com', NULL, NULL, NULL, N'123', NULL, CAST(0x0000AC2B0143E5B3 AS DateTime), NULL, NULL, NULL, 0, 0, NULL, NULL, 1)
INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (5, N'umer', N'nasir', N'2343525', NULL, N'umernasir19@yahoo.com', NULL, NULL, NULL, N'123', NULL, CAST(0x0000AC2B0144054D AS DateTime), NULL, NULL, NULL, 0, 0, NULL, NULL, 1)
INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (6, N'testing', N'user', N'1234567891011', NULL, N'umernasir19@gmail.com', NULL, NULL, N'umernasir19', N'testing1234', NULL, CAST(0x0000AC4E01485569 AS DateTime), NULL, NULL, NULL, 0, 0, NULL, NULL, 1)
INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (7, N'Hafiz Umer', N'Nasir', N'2343525', NULL, N'umernasir19@gmail.com', NULL, NULL, N'umernasir19', N'123', NULL, CAST(0x0000AC4E0149E340 AS DateTime), 1, NULL, NULL, 1, 0, NULL, NULL, 1)
INSERT [dbo].[Users] ([idx], [firstName], [lastName], [CNIC], [cellNumber], [email], [designationIdx], [departmentIdx], [loginId], [password], [gender], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [isActive], [visible], [passCode], [PascodeYNID], [Is_Admin]) VALUES (8, N'Hafiz Umer', N'Nasir', N'1234567891013', NULL, N'umernasir19@gmail.com', NULL, NULL, N'umernasir1', N'abc1234', NULL, CAST(0x0000AC4E014EA17E AS DateTime), 1, NULL, NULL, 1, 0, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
SET IDENTITY_INSERT [dbo].[vendors] ON 

INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (7, N'METRO', N'V-007', N'TAHIR', NULL, N'123', N'123', N'tahir@metro.com', N'123', N'123', NULL, N'STAR GATE, KARACHI', CAST(0x0000AC1400F79ECF AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (8, N'HIRAMAL', N'V-008', N'ADIL', NULL, N'123', N'123', N'adil@gmail.com', N'123', N'123', NULL, N'KARACHI', CAST(0x0000AC1400F7FAA7 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (9, N'IMRAN CHICKEN', N'V-009', N'IMRAN', NULL, N'123', N'123', N'imram@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400F8331F AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (10, N'ANSARI CHICKEN', N'V-010', N'ANSARI', NULL, N'123', N'123', N'ansari@gmail.com', N'123', N'123', NULL, N'Landhi', CAST(0x0000AC1400F8879A AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (11, N'CHAND BEEF & MUTTON SUPPLIER', N'V-011', N'CHAND BHAI', NULL, N'123', N'123', N'chand@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400F8E07B AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (12, N'MEHTAB BEEF SUPPLIER', N'V-012', N'MEHTAB', NULL, N'123', N'123', N'mehtab@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400F93789 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (13, N'ALI GOHAR & CO. PVT LTD', N'V-013', N'ASHRAF', NULL, N'123', N'123', N'ashraf@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400F98B92 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (14, N'SPEEDY SERVICES', N'V-014', N'YUSUF', NULL, N'123', N'123', N'yusuf@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400F9D6F0 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (15, N'QAMAR FISH SUPPLIER', N'V-015', N'QAMAR', NULL, N'123', N'123', N'qamar@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400FA13CC AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (16, N'ASLAM CHOHAN ARAIN', N'V-016', N'ASLAM CHOHAN', NULL, N'13', N'123', N'aslam@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400FA666D AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (17, N'MINHAJ SERVICES', N'V-017', N'NOMAN', NULL, N'123', N'123', N'noman@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400FAB169 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (18, N'MALIK BROTHERS', N'V-018', N'UMAIR', NULL, N'123', N'123', N'umair@gmail.com', N'123', N'123', NULL, N'Xyz', CAST(0x0000AC1400FB0091 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (19, N'Open Market Lahore', N'V-019', N'Israr', NULL, N'123', N'123', N'israr@gmail.com', N'123', N'123', NULL, N'', CAST(0x0000AC150034F14B AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (20, N'Ghulam Muhammad', N'V-020', N'GM', NULL, N'123', N'123', N'gm@gmail.com', N'123', N'123', NULL, N'', CAST(0x0000AC15003DC455 AS DateTime), 1, NULL, NULL, 1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[vendors] ([idx], [vendorName], [vendorCode], [contactPersonName], [vendorAccountType], [accountNo], [contact], [emailAddress], [strn], [ntn], [address], [description], [creationDate], [createdByUserIdx], [lastModificationDate], [lastModifiedByUserIdx], [visible], [openingBalance]) VALUES (21, N'V1', N'V-0003233', N'ABC TESTING', NULL, N'2414124', N'0534543', NULL, NULL, NULL, NULL, NULL, CAST(0x0000AC2B015D4974 AS DateTime), 1, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[vendors] OFF
ALTER TABLE [dbo].[accountGJ] ADD  CONSTRAINT [DF_accountGJ_createDate]  DEFAULT (getdate()) FOR [createDate]
GO
ALTER TABLE [dbo].[accountMasterGL] ADD  CONSTRAINT [DF_accountMasterGL_createDate]  DEFAULT (getdate()) FOR [createDate]
GO
ALTER TABLE [dbo].[accountMasterGL] ADD  CONSTRAINT [DF_accountMasterGL_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[advanceSalary] ADD  CONSTRAINT [DF_advanceSalary_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[advanceSalary] ADD  CONSTRAINT [DF_advanceSalary_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[advanceSalary] ADD  CONSTRAINT [DF_advanceSalary_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[advanceSalary] ADD  CONSTRAINT [DF_advanceSalary_isExpire]  DEFAULT ((0)) FOR [isExpire]
GO
ALTER TABLE [dbo].[advanceSalary] ADD  CONSTRAINT [DF_advanceSalary_isPaid]  DEFAULT ((0)) FOR [isPaid]
GO
ALTER TABLE [dbo].[bank] ADD  CONSTRAINT [DF_bank_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[bank] ADD  CONSTRAINT [DF_bank_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[branch] ADD  CONSTRAINT [DF_BranchSetup_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[branch] ADD  CONSTRAINT [DF_BranchSetup_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[branch] ADD  CONSTRAINT [DF_BranchSetup_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[ChartofAccountsChildHead] ADD  CONSTRAINT [DF__ChartofAc__creat__56E8E7AB]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[ChartofAccountsChildHead] ADD  CONSTRAINT [DF__ChartofAc__visib__57DD0BE4]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[ChartofAccountsHead] ADD  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[ChartofAccountsSubHead] ADD  CONSTRAINT [DF__ChartofAc__creat__531856C7]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[ChartofAccountsSubHead] ADD  CONSTRAINT [DF__ChartofAc__visib__540C7B00]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[company] ADD  CONSTRAINT [DF_CompanySetup_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[company] ADD  CONSTRAINT [DF_CompanySetup_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[company] ADD  CONSTRAINT [DF_CompanySetup_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[companyBank] ADD  CONSTRAINT [DF_companyBank_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[companyBank] ADD  CONSTRAINT [DF_companyBank_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[consumption] ADD  CONSTRAINT [DF_consumption_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[consumption] ADD  CONSTRAINT [DF_consumption_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[consumption] ADD  CONSTRAINT [DF_consumption_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[contract] ADD  CONSTRAINT [DF_contract_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[contract] ADD  CONSTRAINT [DF_contract_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[ContractType] ADD  CONSTRAINT [DF_ContractType_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[ContractType] ADD  CONSTRAINT [DF_ContractType_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[customers] ADD  CONSTRAINT [DF_CustomerRegistration_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[customers] ADD  CONSTRAINT [DF_CustomerRegistration_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[customers] ADD  CONSTRAINT [DF_customers_openingBalance]  DEFAULT ((0.00)) FOR [openingBalance]
GO
ALTER TABLE [dbo].[department] ADD  CONSTRAINT [DF_Department_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[department] ADD  CONSTRAINT [DF_Department_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[designation] ADD  CONSTRAINT [DF_Designation_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[designation] ADD  CONSTRAINT [DF_Designation_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_EmployeeRegistration_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_EmployeeRegistration_isTerminated]  DEFAULT ((1)) FOR [isTerminated]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_EmployeeRegistration_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_EmployeeRegistration_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[employeeType] ADD  CONSTRAINT [DF_Employee Type_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[employeeType] ADD  CONSTRAINT [DF_Employee Type_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[inventory] ADD  CONSTRAINT [DF_inventory_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[itemUnits] ADD  CONSTRAINT [DF_ItemUnits_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[itemUnits] ADD  CONSTRAINT [DF_ItemUnits_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[loan] ADD  CONSTRAINT [DF_loan_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[loan] ADD  CONSTRAINT [DF_loan_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[loan] ADD  CONSTRAINT [DF_loan_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[loan] ADD  CONSTRAINT [DF_loan_isPaid]  DEFAULT ((0)) FOR [isPaid]
GO
ALTER TABLE [dbo].[loan] ADD  CONSTRAINT [DF_loan_isExpire]  DEFAULT ((0)) FOR [isExpire]
GO
ALTER TABLE [dbo].[Month] ADD  CONSTRAINT [DF_Month_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[payroll] ADD  CONSTRAINT [DF_payroll_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[payroll] ADD  CONSTRAINT [DF_payroll_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[payroll] ADD  CONSTRAINT [DF_payroll_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[products] ADD  CONSTRAINT [DF_ProductSetup_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[products] ADD  CONSTRAINT [DF_ProductSetup_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[productType] ADD  CONSTRAINT [DF_productType_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[pruchaseDetails] ADD  CONSTRAINT [DF_PurchaseItemSubTable_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[pruchaseDetails] ADD  CONSTRAINT [DF_PurchaseItemSubTable_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[purchase] ADD  CONSTRAINT [DF_AddPurchaseParentTable_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[purchase] ADD  CONSTRAINT [DF_AddPurchaseParentTable_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[purchase] ADD  CONSTRAINT [DF_purchase_isPaid]  DEFAULT ((0)) FOR [isPaid]
GO
ALTER TABLE [dbo].[PurchaseType] ADD  CONSTRAINT [DF_PurchaseType_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[PurchaseType] ADD  CONSTRAINT [DF_PurchaseType_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Role_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Role_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[salary] ADD  CONSTRAINT [DF_EmployeeSalary_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[salary] ADD  CONSTRAINT [DF_EmployeeSalary_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[salary] ADD  CONSTRAINT [DF_EmployeeSalary_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[sales] ADD  CONSTRAINT [DF_SalesParentTable_isPaid]  DEFAULT ((0)) FOR [isPaid]
GO
ALTER TABLE [dbo].[sales] ADD  CONSTRAINT [DF_sales_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[sales] ADD  CONSTRAINT [DF_SalesParentTable_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[salesDetails] ADD  CONSTRAINT [DF_SalesItemSubTable_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[salesDetails] ADD  CONSTRAINT [DF_SalesItemSubTable_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[services] ADD  CONSTRAINT [DF_AddService_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[services] ADD  CONSTRAINT [DF_AddService_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[stations] ADD  CONSTRAINT [DF_StationSetup_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[stations] ADD  CONSTRAINT [DF_StationSetup_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[stations] ADD  CONSTRAINT [DF_StationSetup_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[transactionType] ADD  CONSTRAINT [DF_transactionType_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Url] ADD  CONSTRAINT [DF_Url_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[Url] ADD  CONSTRAINT [DF_Url_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_PascodeYNID]  DEFAULT ((0)) FOR [PascodeYNID]
GO
ALTER TABLE [dbo].[vendors] ADD  CONSTRAINT [DF_VendorRegistration_creationDate]  DEFAULT (getdate()) FOR [creationDate]
GO
ALTER TABLE [dbo].[vendors] ADD  CONSTRAINT [DF_VendorRegistration_visible]  DEFAULT ((1)) FOR [visible]
GO
ALTER TABLE [dbo].[vendors] ADD  CONSTRAINT [DF_vendors_openingBalance]  DEFAULT ((0.00)) FOR [openingBalance]
GO
USE [master]
GO
ALTER DATABASE [RAJPUT_RICE_DB] SET  READ_WRITE 
GO
