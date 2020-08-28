using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        public ActionResult SystemUsers()
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {
                return View();
            }
            else
            {
                return RedirectToAction("NotAuthorized", "Account");
            }
            
        }

        public ActionResult AddSystemUsers()
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {
                return PartialView("_AddSystemUsers");
            }
            else
            {
                return RedirectToAction("NotAuthorized", "Account");
            }

        }
    }
}