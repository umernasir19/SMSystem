using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SMSYSTEM.Models
{
    public static class DBClass
    {
        public static RAJPUT_RICE_DBEntities  db = new RAJPUT_RICE_DBEntities();
       
        public static RAJPUT_RICE_DBEntities connection()
        {
            return new RAJPUT_RICE_DBEntities();
        }
     //  var static dbtransaction =db.Database.BeginTransaction();
    }
}