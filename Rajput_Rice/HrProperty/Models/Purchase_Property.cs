using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
  public  class Purchase_Property
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private string _poNumber;
        public string poNumber
        {
            get { return _poNumber; }
            set { _poNumber = value; }
        }

        private int _vendorIdx;
        public int vendorIdx
        {
            get { return _vendorIdx; }
            set { _vendorIdx = value; }
        }

        private int _purchaseTypeIdx;
        public int purchaseTypeIdx
        {
            get { return _purchaseTypeIdx; }
            set { _purchaseTypeIdx = value; }
        }

        private string _purchaseDate;
        public string purchaseDate
        {
            get { return _purchaseDate; }
            set { _purchaseDate = value; }
        }

        private string _description;
        public string description
        {
            get { return _description; }
            set { _description = value; }
        }

        private decimal _totalAmount;
        public decimal totalAmount
        {
            get { return _totalAmount; }
            set { _totalAmount = value; }
        }

        private decimal _netAmount;
        public decimal netAmount
        {
            get { return _netAmount; }
            set { _netAmount = value; }
        }

        private string _paidAmount;
        public string paidAmount
        {
            get { return _paidAmount; }
            set { _paidAmount = value; }
        }

        private string _balanceAmount;
        public string balanceAmount
        {
            get { return _balanceAmount; }
            set { _balanceAmount = value; }
        }

        private int _paymentModeIdx;
        public int paymentModeIdx
        {
            get { return _paymentModeIdx; }
            set { _paymentModeIdx = value; }
        }

        private int _bankIdx;
        public int bankIdx
        {
            get { return _bankIdx; }
            set { _bankIdx = value; }
        }

        private string _accorChequeNumber;
        public string accorChequeNumber
        {
            get { return _accorChequeNumber; }
            set { _accorChequeNumber = value; }
        }

        private string _paidDate;
        public string paidDate
        {
            get { return _paidDate; }
            set { _paidDate = value; }
        }

        private DateTime _creationDate;
        public DateTime creationDate
        {
            get { return _creationDate; }
            set { _creationDate = value; }
        }

        private int _createdByUserIdx;
        public int createdByUserIdx
        {
            get { return _createdByUserIdx; }
            set { _createdByUserIdx = value; }
        }

        private string _lastModificationDate;
        public string lastModificationDate
        {
            get { return _lastModificationDate; }
            set { _lastModificationDate = value; }
        }

        private int _lastModifiedByUserIdx;
        public int lastModifiedByUserIdx
        {
            get { return _lastModifiedByUserIdx; }
            set { _lastModifiedByUserIdx = value; }
        }

        private int _visible;
        public int visible
        {
            get { return _visible; }
            set { _visible = value; }
        }

        private int _paymentStatus;
        public int paymentStatus
        {
            get { return _paymentStatus; }
            set { _paymentStatus = value; }
        }

        private string _status;
        public string status
        {
            get { return _status; }
            set { _status = value; }
        }

        private int _isPaid;
        public int isPaid
        {
            get { return _isPaid; }
            set { _isPaid = value; }
        }

        private decimal _discount;
        public decimal discount
        {
            get { return _discount; }
            set { _discount = value; }
        }

        private decimal _tax;
        public decimal tax
        {
            get { return _tax; }
            set { _tax = value; }
        }

        private decimal _taxAount;
        public decimal taxAount
        {
            get { return _taxAount; }
            set { _taxAount = value; }
        }
        public DateTime purchaseduedate { get; set; }
    }
}
