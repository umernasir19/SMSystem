using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
    public class SalesVm
    {
        public int idx { get; set; }
        public string soNumber { get; set; }
        public int customerIdx { get; set; }
        public int itemIdx { get; set; }
        public decimal unitPrice { get; set; }
        public decimal qty { get; set; }
        public decimal amount { get; set; }
        public string description { get; set; }
        public decimal totalAmount { get; set; }
        public decimal taxAmount { get; set; }
        public decimal WithHoldingTax { get; set; }
        public decimal SindhTax { get; set; }
        public decimal netAmount { get; set; }
        public decimal Paid { get; set; }
        public string Balance { get; set; }
        public int isPaid { get; set; }
        public decimal discount { get; set; }
        public string paidDate { get; set; }
        public DateTime creationDate { get; set; }
        public int createdByUserIdx { get; set; }
        public string lastModificationDate { get; set; }
        public int lastModifiedByUserIdx { get; set; }
        public int visible { get; set; }
        public int paymentStatus { get; set; }
        public int status { get; set; }
        public int paymentModeIdx { get; set; }
        public int bankIdx { get; set; }
        public string chequeNumber { get; set; }
        [DataType(DataType.Date)]
        public string salesDate { get; set; }
        public List<Customer_Property> CustomerLST { get; set; }

        public List<Product_Property> ProductList { get; set; }

        public List<Sale_Details_Property>SalesDetailsLST { get; set; }

    }
}
