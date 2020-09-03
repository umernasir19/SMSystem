using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
  public  class ProductType_Property
    {
        private int _idx;
        [Range(-1, int.MaxValue)]
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private string _productType;
        [Required(ErrorMessage ="Please Enter Product Type")]
        public string productType
        {
            get { return _productType; }
            set { _productType = value; }
        }

        private int _createdByUserIdx;
        public int createdByUserIdx
        {
            get { return _createdByUserIdx; }
            set { _createdByUserIdx = value; }
        }

        private DateTime _creationDate;
        public DateTime creationDate
        {
            get { return _creationDate; }
            set { _creationDate = value; }
        }

        
    }
}
