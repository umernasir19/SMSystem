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
                String from =objrprt.From.ToString("yyyy-MM-dd");
                string TO = objrprt.To.ToString("yyyy-MM-dd");
                using(var db=new RAJPUT_RICE_DBEntities())
                {
                    if (objrprt.ReportID == 1)
                    {
                        var data = db.Sp_Daily_PurchaseReport(objrprt.ReportID, from, TO).ToList();

                        return Json(new { data = data }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        var data = db.Sp_Daily_SaleReport(objrprt.ReportID, from, TO).ToList();

                        return Json(new { data = data }, JsonRequestBehavior.AllowGet);
                    }
                }
            
            }
            catch(Exception ex)
            {
                return Json(new  { data = "" }, JsonRequestBehavior.AllowGet);
            }
        
        }
    }
}