using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
    [Serializable]
   public class ExpenseVoucher_Property
    {
      
        public string voucherNo { get; set; }
        [DataType(DataType.Date)]
        [Required]
        public DateTime VoucherDate { get; set; }
        [Required]
        public decimal amount { get; set; }
        public string  Memo { get; set; }
        [Required(ErrorMessage ="Select payment Mode")]
        public int paymentModeIdx { get; set; }
        public int bankIdx { get; set; }
        public string accorChequeNumber { get; set; }

        [DataType(DataType.Date)]
        public string paidDate { get; set; }
        public List<PaymentMode_Property> Paymentmodelist { get; set; }
        public List<Bank_Property> BankList { get; set; }
        [Required(ErrorMessage = "Select COA ID")]
        public int COAID { get; set; }
        public List<COACHILDHEAD_Property> COACHILDS { get; set; }
    }
}
