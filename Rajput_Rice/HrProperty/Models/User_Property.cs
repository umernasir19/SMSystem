using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
    [Serializable()]
   public class User_Property
    {
        private int _idx;
        public int idx
        {
            get { return _idx; }
            set { _idx = value; }
        }
        
        private string _firstName;
        [Required(ErrorMessage = "Please Enter First Name")]
        [StringLength(55)]
        public string firstName
        {
            get { return _firstName; }
            set { _firstName = value; }
        }

        private string _lastName;
        [Required(ErrorMessage = "Please Enter Last Name")]
        [StringLength(55)]
        public string lastName
        {
            get { return _lastName; }
            set { _lastName = value; }
        }

        private string _CNIC;
        [Required(ErrorMessage = "Please Enter CNIC")]
        [StringLength(13)]
        public string CNIC
        {
            get { return _CNIC; }
            set { _CNIC = value; }
        }

        private string _cellNumber;
        [Required(ErrorMessage = "Please Enter CNIC")]
        [StringLength(11)]
        public string cellNumber
        {
            get { return _cellNumber; }
            set { _cellNumber = value; }
        }

        private string _email;
        public string email
        {
            get { return _email; }
            set { _email = value; }
        }

        private int _designationIdx;
        public int designationIdx
        {
            get { return _designationIdx; }
            set { _designationIdx = value; }
        }

        private int _departmentIdx;
        public int departmentIdx
        {
            get { return _departmentIdx; }
            set { _departmentIdx = value; }
        }

        private string _loginId;
        [Required(ErrorMessage ="Please Enter Login ID")]
        public string loginId
        {
            get { return _loginId; }
            set { _loginId = value; }
        }

        private string _password;
        [Required(ErrorMessage = "Please Enter Password")]
        [DataType(DataType.Password)]
        public string password
        {
            get { return _password; }
            set { _password = value; }
        }

        private int _gender;
        public int gender
        {
            get { return _gender; }
            set { _gender = value; }
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

        private int _isActive;
        public int isActive
        {
            get { return _isActive; }
            set { _isActive = value; }
        }

        private int _visible;
        public int visible
        {
            get { return _visible; }
            set { _visible = value; }
        }

        private string _passCode;
        public string passCode
        {
            get { return _passCode; }
            set { _passCode = value; }
        }

        private int _PascodeYNID;
        public int PascodeYNID
        {
            get { return _PascodeYNID; }
            set { _PascodeYNID = value; }
        }

        private bool _Is_Admin;
        public bool Is_Admin
        {
            get { return _Is_Admin; }
            set { _Is_Admin = value; }
        }
    }
}
