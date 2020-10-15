using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
     public class SalesReturn_Property
    {

        public List<Sale_Property> SalesLiSt { get; set; }
        [Required(ErrorMessage ="Please Select Sale Invoice")]
        public string SaleInvoiceNumber { get; set; }

        public int SaleDetailsID { get; set; }

        //public int customer_Id { get; set; }

        //public string SAleNumber { get; set; }

        //public int AccountId { get; set; }

        //[DataType(DataType.Date)]
        //public DateTime DueDate { get; set; }

        //public List<Customer_Property> CustomerLsit { get; set; }


        // public List<Sale_Details_Property> Saledtiit { get; set; }

        //public decimal TotalSaleAmount { get; set; }

        //public decimal PaidAmount { get; set; }
        //public decimal balanceamount { get; set; }
        ////[DataType(DataType.Date)]
        ////public DateTime NextDueDate { get; set; }

        public int SalesMasterID { get; set; }

        public int Saleqty { get; set; }

        public int Salerate { get; set; }

        public int StockQty { get; set; }

        public decimal SaleAmount { get; set; }

        public decimal PaidAmount { get; set; }

        public decimal BalanceRemaining { get; set; }
        public int returnqty { get; set; }



        //public decimal itembalance { get; set; }
        //public decimal unitprice { get; set; }

    }
}
