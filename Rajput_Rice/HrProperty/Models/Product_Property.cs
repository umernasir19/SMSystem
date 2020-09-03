using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class Product_Property
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private int _productTypeIdx;
        public int productTypeIdx
        {
            get { return _productTypeIdx; }
            set { _productTypeIdx = value; }
        }

        private string _itemName;
        public string itemName
        {
            get { return _itemName; }
            set { _itemName = value; }
        }

        private string _itemCode;
        public string itemCode
        {
            get { return _itemCode; }
            set { _itemCode = value; }
        }

        private int _unit;
        public int unit
        {
            get { return _unit; }
            set { _unit = value; }
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

    }
}
