USE [master]
GO
/****** Object:  Database [RAJPUT_RICE_DB]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[advance_Aproval]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[advannce_AprovalList]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[deleteDetailsRecordonEdit]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[deleteGLandGJBySaleIdx]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[Get_AccountPayableDate]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[Get_AccountRecivableDate]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[get_payrollList]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[get_Sale_byServiceId]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetAccountsHeadDDL]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetAccountsHeadList]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[getEmployeeReport]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[getProductType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[getPurchaseReport]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[getSalesTaxForIncomeStatement]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetSubHeadRecordByHeadId]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetSubHeadRecordsAll]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[InventoryReport]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[loan_Aproval]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[loan_aprovalList]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[loan_installment]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[purchaseDetailsList]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[salesDetailsList]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[search_payroll]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_accountGJEX]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_accountGJJE]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_accountMasterGLEX]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_accountMasterGLIsCredit]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_accountMasterGLJE]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_PurchaseIsPaid]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_SaleIsPaid]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[update_status]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[updatePurchaseDetailsAccept]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateStatus]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_AcceptConsumptionRequest]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_advanceSalary]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_ChartofAccountsChildHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_ChartofAccountsSubHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_COA]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_company]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_contract]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_ContractType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_loan]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_pruchaseDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_salesDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Add_transactionType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_accountGJ]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_accountGJWithMasterID]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_accountMasterGL]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_advanceSalary]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_branch]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_ChartofAccountsChildHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_ChartofAccountsSubHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_COA]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_company]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_companyBank]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_consumption]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_contract]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_ContractType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_customers]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_department]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_designation]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_employees]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_employeeType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_inventory]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_itemUnits]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_loan]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_payroll]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_products]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_pruchaseDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_purchase]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_PurchaseType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_roles]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_salary]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_sales]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_salesDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_salesDetailsBySalesIdx]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_services]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_stations]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_Users]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_delete_vendors]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_RejectConsumptionRequest]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_advanceSalary]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_ChartofAccountsChildHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_ChartofAccountsSubHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_COA]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_company]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_contract]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_department]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_designation]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_employeeType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_inventory]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_loan]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_pruchaseDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_purchase]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_update_salesDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[accountGJ]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[accountMasterGL]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[advanceSalary]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[bank]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[branch]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[ChartofAccountsChildHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[ChartofAccountsHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[ChartofAccountsSubHead]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[COA]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[company]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[companyBank]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[consumption]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[contract]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[ContractType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[customers]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[department]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[designation]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[employees]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[employeeType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[gender]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[inventory]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[inventory_logs]    Script Date: 10/8/2020 3:38:07 PM ******/
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
 CONSTRAINT [PK_inventory_logs] PRIMARY KEY CLUSTERED 
(
	[idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InventoryDetail]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[itemUnits]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[loan]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[loanInstallments]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[maritalStatus]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[Month]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[paymentMode]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[payroll]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[products]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[productType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[pruchaseDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[purchase]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[PurchaseType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[salary]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[sales]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[salesDetails]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[services]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[stations]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[transactionType]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[Url]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 10/8/2020 3:38:07 PM ******/
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
/****** Object:  Table [dbo].[vendors]    Script Date: 10/8/2020 3:38:07 PM ******/
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
