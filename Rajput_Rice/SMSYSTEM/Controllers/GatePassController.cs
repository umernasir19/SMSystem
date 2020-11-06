using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class GatePassController : Controller
    {
        // GET: GatePass
        public ActionResult ViewGatePass()
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


        public ActionResult AddGatePass()
        {
            if (Session["LoggedIn"] != null)
            {
                GatePass_VM objgatepass = new GatePass_VM();
                objgatepass.SalesList = DBClass.db.sales.Where(p => p.visible == 1).Select(p => new Sale_Property
                {
                    idx=p.idx,
                    soNumber=p.soNumber

                }).ToList();
                return PartialView("_AddGatePass", objgatepass);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }

        //[HttpPost]

        public ActionResult AddUpdate(string driver,string numberplate, int sale)
        {
            try
            {
                GatePass_VM objgatepass = new GatePass_VM();
                objgatepass.drivername = driver;
                objgatepass.numberplate = numberplate;
                objgatepass.saleID = sale;
                TempData["data"] = (from A in DBClass.db.sales
                            join B in DBClass.db.salesDetails on A.idx equals B.salesIdx
                            join C in DBClass.db.products on B.serviceIdx equals C.idx
                            where A.idx == objgatepass.idx
                            select new
                            {
                                drivername = objgatepass.drivername,
                                numberplate = objgatepass.numberplate,
                                createddate = DateTime.Now,
                                sonumber = A.soNumber,
                                Product = C.itemName,
                                Qty = B.serviceQty,


                            }).ToList();

                return RedirectToAction("GatePass");
                //return View("GatePass");
            }
            catch(Exception ex)
            {
                return View();

            }
        }
        
        public ActionResult GatePass(string driver, string numberplate, int sale)
        {
            GatePass_VM objgatepass = new GatePass_VM();
            objgatepass.drivername = driver;
            objgatepass.numberplate = numberplate;
            objgatepass.saleID = sale;
            ViewBag.data = (from A in DBClass.db.sales
                            join B in DBClass.db.salesDetails on A.idx equals B.salesIdx
                            join C in DBClass.db.products on B.serviceIdx equals C.idx
                            where A.idx == objgatepass.saleID
                            select new
                            {
                                drivername = objgatepass.drivername,
                                numberplate = objgatepass.numberplate,
                                createddate = DateTime.Now,
                                sonumber = A.soNumber,
                                Product = C.itemName,
                                Qty = B.serviceQty,


                            }).ToList();
            //ViewBag.data = TempData["data"];
            return View();
        }
    }
}