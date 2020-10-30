using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class Sale_Details_Property
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private int _salesIdx;
        public int salesIdx
        {
            get { return _salesIdx; }
            set { _salesIdx = value; }
        }

        private int _serviceIdx;
        public int serviceIdx
        {
            get { return _serviceIdx; }
            set { _serviceIdx = value; }
        }

        private string _serviceCode;
        public string serviceCode
        {
            get { return _serviceCode; }
            set { _serviceCode = value; }
        }

        private string _unit;
        public string unit
        {
            get { return _unit; }
            set { _unit = value; }
        }

        private decimal _serviceRate;
        public decimal serviceRate
        {
            get { return _serviceRate; }
            set { _serviceRate = value; }
        }

        private string _serviceDescription;
        public string serviceDescription
        {
            get { return _serviceDescription; }
            set { _serviceDescription = value; }
        }

        private decimal _serviceQty;
        public decimal serviceQty
        {
            get { return _serviceQty; }
            set { _serviceQty = value; }
        }

        private decimal _subAmount;
        public decimal subAmount
        {
            get { return _subAmount; }
            set { _subAmount = value; }
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
    }
}
