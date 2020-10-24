using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class ReportsController : Controller
    {
        // GET: Reports
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult DailyReports()
        {
            if (Session["LoggedIn"] != null)
            {
                return View();
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }

        public JsonResult GetDailyReport(Report_Manager objrprt)
        {
            try
            {
                if (objrprt.ReportID == 1)
                {
                   // var data=DBClass.db.purchases
                }
                if (objrprt.ReportID == 2)
                {

                }
                return Json(new JsonResult { Data = "" }, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                return Json(new JsonResult { Data = "" }, JsonRequestBehavior.AllowGet);
            }
        
        }
    }
}