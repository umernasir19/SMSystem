using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrProperty.Models
{
   public   class Bank_Property
    {
		private int _idx;
		public int idx
		{
			get { return _idx; }
			set { _idx = value; }
		}

		private string _bankName;
		public string bankName
		{
			get { return _bankName; }
			set { _bankName = value; }
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

		private int _visible;
		public int visible
		{
			get { return _visible; }
			set { _visible = value; }
		}


	}
}
