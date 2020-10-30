using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class Customer_Property
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private string _contactPersonName;
        public string contactPersonName
        {
            get { return _contactPersonName; }
            set { _contactPersonName = value; }
        }

        private string _customerName;
        public string customerName
        {
            get { return _customerName; }
            set { _customerName = value; }
        }

        private string _customerCode;
        public string customerCode
        {
            get { return _customerCode; }
            set { _customerCode = value; }
        }

        private int _customerAccountType;
        public int customerAccountType
        {
            get { return _customerAccountType; }
            set { _customerAccountType = value; }
        }

        private string _cnic;
        public string cnic
        {
            get { return _cnic; }
            set { _cnic = value; }
        }

        private string _contact;
        public string contact
        {
            get { return _contact; }
            set { _contact = value; }
        }

        private string _emailAddress;
        public string emailAddress
        {
            get { return _emailAddress; }
            set { _emailAddress = value; }
        }

        private string _accountNo;
        public string accountNo
        {
            get { return _accountNo; }
            set { _accountNo = value; }
        }

        private string _ntn;
        public string ntn
        {
            get { return _ntn; }
            set { _ntn = value; }
        }

        private string _strnNo;
        public string strnNo
        {
            get { return _strnNo; }
            set { _strnNo = value; }
        }

        private string _address;
        public string address
        {
            get { return _address; }
            set { _address = value; }
        }

        private string _description;
        public string description
        {
            get { return _description; }
            set { _description = value; }
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

        private decimal _openingBalance;
        public decimal openingBalance
        {
            get { return _openingBalance; }
            set { _openingBalance = value; }
        }

    }
}
