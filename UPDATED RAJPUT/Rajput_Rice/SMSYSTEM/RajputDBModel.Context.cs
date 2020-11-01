﻿

//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------


namespace SMSYSTEM
{

using System;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;

using System.Data.Objects;
using System.Data.Objects.DataClasses;
using System.Linq;


public partial class RAJPUT_RICE_DBEntities : DbContext
{
    public RAJPUT_RICE_DBEntities()
        : base("name=RAJPUT_RICE_DBEntities")
    {

    }

    protected override void OnModelCreating(DbModelBuilder modelBuilder)
    {
        throw new UnintentionalCodeFirstException();
    }


    public DbSet<accountGJ> accountGJs { get; set; }

    public DbSet<accountMasterGL> accountMasterGLs { get; set; }

    public DbSet<advanceSalary> advanceSalaries { get; set; }

    public DbSet<bank> banks { get; set; }

    public DbSet<branch> branches { get; set; }

    public DbSet<ChartofAccountsChildHead> ChartofAccountsChildHeads { get; set; }

    public DbSet<ChartofAccountsHead> ChartofAccountsHeads { get; set; }

    public DbSet<ChartofAccountsSubHead> ChartofAccountsSubHeads { get; set; }

    public DbSet<COA> COAs { get; set; }

    public DbSet<company> companies { get; set; }

    public DbSet<companyBank> companyBanks { get; set; }

    public DbSet<consumption> consumptions { get; set; }

    public DbSet<contract> contracts { get; set; }

    public DbSet<ContractType> ContractTypes { get; set; }

    public DbSet<customer> customers { get; set; }

    public DbSet<department> departments { get; set; }

    public DbSet<designation> designations { get; set; }

    public DbSet<employee> employees { get; set; }

    public DbSet<employeeType> employeeTypes { get; set; }

    public DbSet<gender> genders { get; set; }

    public DbSet<inventory> inventories { get; set; }

    public DbSet<InventoryDetail> InventoryDetails { get; set; }

    public DbSet<itemUnit> itemUnits { get; set; }

    public DbSet<loan> loans { get; set; }

    public DbSet<loanInstallment> loanInstallments { get; set; }

    public DbSet<maritalStatu> maritalStatus { get; set; }

    public DbSet<Month> Months { get; set; }

    public DbSet<paymentMode> paymentModes { get; set; }

    public DbSet<payroll> payrolls { get; set; }

    public DbSet<product> products { get; set; }

    public DbSet<productType> productTypes { get; set; }

    public DbSet<pruchaseDetail> pruchaseDetails { get; set; }

    public DbSet<purchase> purchases { get; set; }

    public DbSet<PurchaseType> PurchaseTypes { get; set; }

    public DbSet<Role> Roles { get; set; }

    public DbSet<salary> salaries { get; set; }

    public DbSet<sale> sales { get; set; }

    public DbSet<salesDetail> salesDetails { get; set; }

    public DbSet<service> services { get; set; }

    public DbSet<station> stations { get; set; }

    public DbSet<transactionType> transactionTypes { get; set; }

    public DbSet<User> Users { get; set; }

    public DbSet<vendor> vendors { get; set; }

    public DbSet<Url> Urls { get; set; }

    public DbSet<inventory_logs> inventory_logs { get; set; }

    public DbSet<planner> planners { get; set; }


    public virtual ObjectResult<Sp_Daily_PurchaseReport_Result> Sp_Daily_PurchaseReport(Nullable<int> reportID, string from, string tO)
    {

        var reportIDParameter = reportID.HasValue ?
            new ObjectParameter("reportID", reportID) :
            new ObjectParameter("reportID", typeof(int));


        var fromParameter = from != null ?
            new ObjectParameter("from", from) :
            new ObjectParameter("from", typeof(string));


        var tOParameter = tO != null ?
            new ObjectParameter("TO", tO) :
            new ObjectParameter("TO", typeof(string));


        return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Sp_Daily_PurchaseReport_Result>("Sp_Daily_PurchaseReport", reportIDParameter, fromParameter, tOParameter);
    }


    public virtual ObjectResult<Sp_Daily_SaleReport_Result> Sp_Daily_SaleReport(Nullable<int> reportID, string from, string tO)
    {

        var reportIDParameter = reportID.HasValue ?
            new ObjectParameter("reportID", reportID) :
            new ObjectParameter("reportID", typeof(int));


        var fromParameter = from != null ?
            new ObjectParameter("from", from) :
            new ObjectParameter("from", typeof(string));


        var tOParameter = tO != null ?
            new ObjectParameter("TO", tO) :
            new ObjectParameter("TO", typeof(string));


        return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Sp_Daily_SaleReport_Result>("Sp_Daily_SaleReport", reportIDParameter, fromParameter, tOParameter);
    }


    public virtual ObjectResult<Sp_Customer_Report_Result> Sp_Customer_Report(string from, string tO)
    {

        var fromParameter = from != null ?
            new ObjectParameter("from", from) :
            new ObjectParameter("from", typeof(string));


        var tOParameter = tO != null ?
            new ObjectParameter("TO", tO) :
            new ObjectParameter("TO", typeof(string));


        return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Sp_Customer_Report_Result>("Sp_Customer_Report", fromParameter, tOParameter);
    }

}

}

