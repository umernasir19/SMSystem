using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
    public class Receipt_Property
    {
        public int customer_Id { get; set; }
        public string invoiceNumber { get; set; }
        public int AccountId { get; set; }

        //[DataType(DataType.Date)]
        //public DateTime DueDate { get; set; }

        public List<Customer_Property> customerList { get; set; }

        public decimal totalAmount { get; set; }

        public decimal PaidAmount { get; set; }
        public decimal balanceamount { get; set; }

        //payment options
        [Required(ErrorMessage = "Please Select Payment")]
        public int paymentModeIdx { get; set; }
        public int bankIdx { get; set; }
        public string accorChequeNumber { get; set; }
        [DataType(DataType.Date)]
        public string paidDate { get; set; }
        public List<PaymentMode_Property> Paymentmodelist { get; set; }
        public List<Bank_Property> BankList { get; set; }

    }
}
