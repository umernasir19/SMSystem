using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
  public class PurchaseVM
    {
        public int idx { get; set; }
        public string poNumber { get; set; }
        public int vendorIdx { get; set; }
        public int purchaseTypeIdx { get; set; }
        [DataType(DataType.Date)]
        public string purchaseDate { get; set; }
        public string description { get; set; }
        public decimal totalAmount { get; set; }
        public decimal netAmount { get; set; }
        public string paidAmount { get; set; }
        public string balanceAmount { get; set; }
        public int paymentModeIdx { get; set; }
        public int bankIdx { get; set; }
        public string accorChequeNumber { get; set; }
        public string paidDate { get; set; }
        public DateTime creationDate { get; set; }
        public int createdByUserIdx { get; set; }
        public string lastModificationDate { get; set; }
        public int lastModifiedByUserIdx { get; set; }
        public int visible { get; set; }
        public int paymentStatus { get; set; }
        public string status { get; set; }
        public int isPaid { get; set; }
        public decimal discount { get; set; }
        public decimal tax { get; set; }
        public decimal taxAount { get; set; }

        public int itemIdx { get; set; }
        public decimal unitPrice { get; set; }
        public decimal qty { get; set; }
        public decimal amount { get; set; }
        [DataType(DataType.Date)]
        public DateTime DueDate { get; set; }
        [DataType(DataType.Date)]
        public DateTime purchaseduedate { get; set; }

        public List<Vendor_Property> VendorLST { get; set; }

        public List<Product_Property> ProductList { get; set; }

        public List<PaymentMode_Property> Paymentmodelist { get; set; }
        public List<PurchaseDetail_Property> PurchaseDetailLST { get; set; }



    }
}
