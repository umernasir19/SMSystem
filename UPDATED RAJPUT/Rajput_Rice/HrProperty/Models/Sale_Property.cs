using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class Sale_Property
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private string _soNumber;
        public string soNumber
        {
            get { return _soNumber; }
            set { _soNumber = value; }
        }

        private int _customerIdx;
        public int customerIdx
        {
            get { return _customerIdx; }
            set { _customerIdx = value; }
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

        private decimal _taxAmount;
        public decimal taxAmount
        {
            get { return _taxAmount; }
            set { _taxAmount = value; }
        }

        private decimal _WithHoldingTax;
        public decimal WithHoldingTax
        {
            get { return _WithHoldingTax; }
            set { _WithHoldingTax = value; }
        }

        private decimal _SindhTax;
        public decimal SindhTax
        {
            get { return _SindhTax; }
            set { _SindhTax = value; }
        }

        private decimal _netAmount;
        public decimal netAmount
        {
            get { return _netAmount; }
            set { _netAmount = value; }
        }

        private decimal _Paid;
        public decimal Paid
        {
            get { return _Paid; }
            set { _Paid = value; }
        }

        private string _Balance;
        public string Balance
        {
            get { return _Balance; }
            set { _Balance = value; }
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

        private int _status;
        public int status
        {
            get { return _status; }
            set { _status = value; }
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

        private string _chequeNumber;
        public string chequeNumber
        {
            get { return _chequeNumber; }
            set { _chequeNumber = value; }
        }

        private string _salesDate;
        public string salesDate
        {
            get { return _salesDate; }
            set { _salesDate = value; }
        }
    }
}
