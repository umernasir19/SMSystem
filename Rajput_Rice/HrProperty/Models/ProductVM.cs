using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
    public class ProductVM
    {
        public int idx { get; set; }
        public int? productTypeIdx { get; set; }
        public string itemName { get; set; }
        public string itemCode { get; set; }
        public int? unit { get; set; }
        public string description { get; set; }
        public DateTime creationDate { get; set; }
        public int createdByUserIdx { get; set; }
        public string lastModificationDate { get; set; }
        public int lastModifiedByUserIdx { get; set; }
        public int visible { get; set; }

        public List<ProductType_Property> Producttypelst { get; set; }
    }
}
