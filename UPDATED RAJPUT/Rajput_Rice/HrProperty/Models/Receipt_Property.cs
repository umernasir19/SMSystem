using System;
using System.Collections.Generic;
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
   
    }
}
