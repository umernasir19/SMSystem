using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class AccountController : Controller
    {

        // GET: Account
        // GET: Account
        #region Login
        public ActionResult Login()
        {
            Session.RemoveAll();
            Session.Clear();
            Session.Abandon();
            return View();
        }
        //Post Request from View
        [HttpPost]
        public JsonResult Login(Login_Property objuser)
        {
            //checking Validation at backend
            if (ModelState.IsValid)
            {//if valid
                string msg = "";
                try
                {
                    //Checking Database 
                    var objUser = DBClass.db.Users.Where(p => p.loginId == objuser.loginId && p.password == objuser.password && p.isActive == 1 && p.visible == 1).FirstOrDefault();
                    if (objUser != null)
                    {
                        //If User Found then setting sessions
                        msg = "Login Successfull";
                        Session["LoggedIn"] = true;
                        Session["LoginID"] = objUser.loginId;
                        Session["Useridx"] = objUser.idx;
                        Session["IsAdmin"] = objUser.Is_Admin;
                        return Json(new { success = true, statuscode = 200, msg = "Login Successfull", url = "/Dashboard/Dashboard" }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        //If User Not Found
                        return Json(new { success = true, statuscode = 400, msg = "Login Failed", url = "/Account/Login" }, JsonRequestBehavior.AllowGet);
                    }
                }
                catch (Exception ex)
                {
                    //If Exception
                    return Json(new { success = false, statuscode = 400, msg = ex.Message, url = "/Account/Login" }, JsonRequestBehavior.AllowGet);
                }

            }
            else
            {//Validation Failed
                return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/Account/Login" }, JsonRequestBehavior.AllowGet);
            }

        }
        #endregion

        #region
        public ActionResult NotAuthorized()
        {
            return View();
        }
        #endregion
    }
}