using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
    public class CompanyBankVM
    {
        public int idx { get; set; }

        public Nullable<int> bankIdx { get; set; }

        public string accountTitle { get; set; }

        public string Branch { get; set; }

        public string accountNumber { get; set; }

        public System.DateTime creationDate { get; set; }

        public int createdByUserIdx { get; set; }

        public string visible { get; set; }

        public string lastModificationDate { get; set; }

        public int lastModifiedByUserIdx { get; set; }

        public List<Bank_Property> Banklst { get; set; }
    }
}
