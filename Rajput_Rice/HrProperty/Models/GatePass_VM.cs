using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class GatePass_VM
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private int _saleID;
        [Required(ErrorMessage = "Please Select Sales ID")]
        public int saleID
        {
            get { return _saleID; }
            set { _saleID = value; }
        }

        private string _drivername;
        public string drivername
        {
            get { return _drivername; }
            set { _drivername = value; }
        }

        private string _numberplate;
        [Required(ErrorMessage ="Please Enter Number Plate")]
        public string numberplate
        {
            get { return _numberplate; }
            set { _numberplate = value; }
        }

        private DateTime _createddate;
        public DateTime createddate
        {
            get { return _createddate; }
            set { _createddate = value; }
        }

        private int _userid;
        public int userid
        {
            get { return _userid; }
            set { _userid = value; }
        }

        private bool _status;
        public bool status
        {
            get { return _status; }
            set { _status = value; }
        }

        public List<Sale_Property> SalesList { get; set; }
    }
}
