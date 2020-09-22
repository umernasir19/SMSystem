using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
    public class Payment_Property
    {
        public int vendor_Id { get; set; }

        public int AccountId { get; set; }

        [DataType(DataType.Date)]
        public DateTime DueDate { get; set; }

        public List<Vendor_Property> VendorLsit { get; set; }

        public decimal totalAmount { get; set; }

        public decimal PaidAmount { get; set; }
        public decimal balanceamount { get; set; }
        [DataType(DataType.Date)]
        public DateTime NextDueDate { get; set; }

    }
}

