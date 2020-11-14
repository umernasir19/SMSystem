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
                    else if(objrprt.ReportID == 3)
                    {
                        var data = db.Sp_Customer_Report( from, TO).ToList();

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


        public ActionResult IncomeStatementReport()
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

        public JsonResult GetIncomeReport(Report_Manager objrprt)
        {
            try
            {
                String from = objrprt.From.ToString("yyyy-MM-dd");
                string TO = objrprt.To.ToString("yyyy-MM-dd");
                using (var db = new RAJPUT_RICE_DBEntities())
                {
                    var RevenueData = db.getRevenuesForIncomeStatementReport(from, TO).ToList();

                    var SalesDis = db.getSalesDiscountForIncomeStatementReport(from, TO).ToList();
                    return Json(new { RevenueData = RevenueData, SalesDis= SalesDis, TotalEx = SalesDis.Sum(g => g.EXPENSEAMOUNT), TotalRv=RevenueData.Sum(g=>g.REVAMOUNT) }, JsonRequestBehavior.AllowGet);
                    

                }

            }
            catch (Exception ex)
            {
                return Json(new { data = "" }, JsonRequestBehavior.AllowGet);
            }

        }


        public ActionResult BalanceSheetReport()
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


        public JsonResult GetBalanceSheetReports(Report_Manager objrprt)
        {
            try
            {
                String from = objrprt.From.ToString("yyyy-MM-dd");
                string TO = objrprt.To.ToString("yyyy-MM-dd");
                using (var db = new RAJPUT_RICE_DBEntities())
                {
                    var Assets = db.getBalanceSheetAssets(objrprt.From, objrprt.To).ToList();
                    var Liabilties=db.getBalanceSheetLiabilties(objrprt.From, objrprt.To).ToList();
                    var Capital = db.getBalanceSheetCapitalEquity(objrprt.From, objrprt.To).ToList();

                    var RevenueData = db.getRevenuesForIncomeStatementReport(from, TO).ToList();
                    var SalesDis = db.getSalesDiscountForIncomeStatementReport(from, TO).ToList();
                    return Json(new { RevenueData = RevenueData, SalesDis = SalesDis, TotalEx = SalesDis.Sum(g => g.EXPENSEAMOUNT), TotalRv = RevenueData.Sum(g => g.REVAMOUNT) }, JsonRequestBehavior.AllowGet);


                }

            }
            catch (Exception ex)
            {
                return Json(new { data = "" }, JsonRequestBehavior.AllowGet);
            }

        }

    }
}