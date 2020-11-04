using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class GatePass_property
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }

        private int _saleID;
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

    }
}
