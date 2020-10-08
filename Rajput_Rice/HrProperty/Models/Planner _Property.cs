using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class Planner__Property
    {
        private int _ID;
        public int ID
        {
            get { return _ID; }
            set { _ID = value; }
        }

        private string _TO_DO;
        [Required(ErrorMessage ="Please Enter Data")]
        public string TO_DO
        {
            get { return _TO_DO; }
            set { _TO_DO = value; }
        }

        private DateTime _TO_DO_Date;
        [Required(ErrorMessage = "Please Enter Date")]
        [DataType(DataType.Date)]
        public DateTime TO_DO_Date
        {
            get { return _TO_DO_Date; }
            set { _TO_DO_Date = value; }
        }

        private DateTime _DateCreated;
        public DateTime DateCreated
        {
            get { return _DateCreated; }
            set { _DateCreated = value; }
        }

        private int _CreatedBy;
        public int CreatedBy
        {
            get { return _CreatedBy; }
            set { _CreatedBy = value; }
        }

        private bool _status;
        public bool status
        {
            get { return _status; }
            set { _status = value; }
        }

    }
}
