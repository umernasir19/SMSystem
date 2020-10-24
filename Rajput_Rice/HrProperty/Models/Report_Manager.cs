using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class Report_Manager
    {
        [Required(ErrorMessage ="Please Select Report")]
        public int ReportID { get; set; }
        public string ReportName { get; set; }
        [Required(ErrorMessage = "Please Select Start Date")]
        [DataType(DataType.Date)]
        public DateTime From { get; set; }
        [Required(ErrorMessage = "Please Select End Date")]
        [DataType(DataType.Date)]
        public DateTime To { get; set; }
        public DataTable ReportData { get; set; }

    }
}
