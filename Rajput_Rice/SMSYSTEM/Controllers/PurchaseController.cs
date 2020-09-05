using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class PurchaseController : Controller
    {
        // GET: Purchase
        public ActionResult ViewPurchase()
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

        public ActionResult AddPurchase()
        {
            if (Session["LoggedIn"] != null)
            {
                PurchaseVM objPrchseVM = new PurchaseVM();
                Product_Property objPrdct = new Product_Property();
                objPrchseVM.VendorLST = DBClass.db.vendors.ToList().Select(p => new Vendor_Property
                {
                    idx = p.idx,
                    vendorName = p.vendorName
                }).ToList();
                objPrchseVM.ProductList = DBClass.db.products.ToList().Select(p => new Product_Property
                {
                    idx = p.idx,
                    itemName = p.itemName
                }).ToList();
                return PartialView("_AddPurchase", objPrchseVM);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }
       

        [HttpPost]
        public JsonResult ADDUpdate(IEnumerable<PurchaseVM> timeline)
        {

            //Milestone_Details_Property objmilestone = new Milestone_Details_Property();
            //objmilestone.MilestoneDetails = ToDataTable(timeline);
            //objProjectBll = new Project_BLL(objmilestone);
            //var flag = objProjectBll.InsertMileStone();
            return Json(new { success = true }, JsonRequestBehavior.AllowGet);
        }

    }
}