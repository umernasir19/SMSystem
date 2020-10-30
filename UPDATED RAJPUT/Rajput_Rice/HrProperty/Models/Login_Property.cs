using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public class Login_Property
    {
        private string _loginId;
        [Required(ErrorMessage = "Please Enter Login ID")]
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
    }
}
