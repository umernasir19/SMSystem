
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
    using System.Collections.Generic;
    
public partial class sale
{

    public int idx { get; set; }

    public string soNumber { get; set; }

    public Nullable<int> customerIdx { get; set; }

    public string description { get; set; }

    public Nullable<decimal> totalAmount { get; set; }

    public Nullable<decimal> taxAmount { get; set; }

    public Nullable<decimal> WithHoldingTax { get; set; }

    public Nullable<decimal> SindhTax { get; set; }

    public Nullable<decimal> netAmount { get; set; }

    public Nullable<decimal> Paid { get; set; }

    public string Balance { get; set; }

    public int isPaid { get; set; }

    public Nullable<decimal> discount { get; set; }

    public string paidDate { get; set; }

    public Nullable<System.DateTime> creationDate { get; set; }

    public Nullable<int> createdByUserIdx { get; set; }

    public string lastModificationDate { get; set; }

    public Nullable<int> lastModifiedByUserIdx { get; set; }

    public Nullable<int> visible { get; set; }

    public Nullable<int> paymentStatus { get; set; }

    public Nullable<int> status { get; set; }

    public Nullable<int> paymentModeIdx { get; set; }

    public Nullable<int> bankIdx { get; set; }

    public string chequeNumber { get; set; }

    public string salesDate { get; set; }

}

}
