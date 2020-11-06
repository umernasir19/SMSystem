using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class VendorController : Controller
    {
        // GET: Vendor
        public ActionResult ViewVendors()
        {
            return View();
        }
        [HttpGet]
        public JsonResult ViewAllVendors()
        {
            if (Session["LoggedIn"] != null)
            {
                try
                {
                    var vendors = DBClass.db.vendors.ToList();
                    return Json(new { data = vendors, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return Json(new { data = "Error:" + ex.Message, success = false, statuscode = 500 }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(new { data = "No Login Found", success = true, statuscode = 400 }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult AddNewVendor(int? id)
        {
            if (Session["LoggedIn"] != null)
            {

                



                return PartialView("_AddNewVendor");
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }


        [HttpPost]
        public JsonResult AddUpdate(Vendor_Property objVendor)
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {

                #region Session Exist
                if (!ModelState.IsValid)
                {
                    try
                    {
                        var model = new SMSYSTEM.vendor();
                        if (objVendor.idx > 0)
                        {//update
                            return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/Customer/ViewAllCustomers" }, JsonRequestBehavior.AllowGet);

                        }
                        else
                        {//insert
                         //var checkExists = DBClass.db.Users.Any(x => x.loginId == model.loginId);
                         //if (checkExists)
                         //{
                         //    return Json(new { success = false, message = "Name Already Exists", statusCode = HttpStatusCode.Ambiguous }, JsonRequestBehavior.DenyGet);
                         //}
                         //else
                         //{
                            model.contactPersonName = objVendor.contactPersonName;
                            model.vendorName = objVendor.vendorName;
                            model.vendorCode = objVendor.vendorCode;
                            model.accountNo = objVendor.accountNo;
                            model.contact = objVendor.contact;
                            model.openingBalance = objVendor.openingBalance;
                            model.creationDate = DateTime.Now;
                            model.createdByUserIdx = Convert.ToInt32(Session["Useridx"].ToString());
                            DBClass.db.vendors.Add(model);
                            DBClass.db.SaveChanges();
                            return Json(new { success = true, statuscode = 200, msg = "User Inserted Succesfully", url = "/Vendor/ViewVendors" }, JsonRequestBehavior.AllowGet);
                            //}

                        }

                    }
                    catch (Exception ex)
                    {

                        return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/Customer/ViewAllCustomers" }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/Customer/ViewAllCustomers" }, JsonRequestBehavior.AllowGet);
                }
                #endregion
            }
            else
            {
                return Json(new { data = "No Login Found", success = true, statuscode = 400, url = "/Customer/ViewAllCustomers" }, JsonRequestBehavior.AllowGet);
            }
        }

    }
}