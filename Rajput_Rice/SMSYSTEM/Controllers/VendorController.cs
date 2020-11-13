using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Data;
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
                    using (var db = new RAJPUT_RICE_DBEntities())
                    {
                        var vendors = db.vendors.Where(x => x.visible == 1).ToList();
                        return Json(new { data = vendors, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
                    }


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
            Vendor_Property vendor = new Vendor_Property();
            if (Session["LoggedIn"] != null)
            {
                if (id > 0)
                {
                    using (var db = new RAJPUT_RICE_DBEntities())
                    {
                        var vendorData = db.vendors.Where(x => x.idx == id).FirstOrDefault();
                        vendor.idx = vendorData.idx;
                        vendor.contactPersonName = vendorData.contactPersonName;
                        vendor.vendorCode = vendorData.vendorCode;
                        vendor.vendorName = vendorData.vendorName;
                        vendor.accountNo = vendorData.accountNo;
                        vendor.openingBalance = Convert.ToDecimal(vendorData.openingBalance);
                        vendor.contact = vendorData.contact;
                        vendor.visible = 1;

                    }
                }




                return PartialView("_AddNewVendor", vendor);
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
                if (ModelState.IsValid)
                {
                    try
                    {
                        var model = new SMSYSTEM.vendor();
                        if (objVendor.idx > 0)
                        {//update
                            model.idx = objVendor.idx;
                            model.contactPersonName = objVendor.contactPersonName;
                            model.vendorName = objVendor.vendorName;
                            model.vendorCode = objVendor.vendorCode;
                            model.accountNo = objVendor.accountNo;
                            model.contact = objVendor.contact;
                            model.openingBalance = objVendor.openingBalance;
                            model.visible = 1;
                            model.lastModificationDate = DateTime.Now.Date.ToString("yyyy-MM-dd");
                            model.lastModifiedByUserIdx = Convert.ToInt32(Session["Useridx"].ToString());

                            using (var db = new RAJPUT_RICE_DBEntities())
                            {
                                db.Entry(model).State = EntityState.Modified;
                                db.SaveChanges();
                            }

                            return Json(new { success = true, statuscode = 200, msg = "Vendor Uodated Succesfully", url = "/Vendor/ViewVendors" }, JsonRequestBehavior.AllowGet);

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
                            model.visible = 1;
                            model.creationDate = DateTime.Now;
                            model.createdByUserIdx = Convert.ToInt32(Session["Useridx"].ToString());
                            using (var db = new RAJPUT_RICE_DBEntities())
                            {

                                db.vendors.Add(model);
                                db.SaveChanges();
                            }

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
        public JsonResult DeleteVendor(int id)
        {
            try
            {
                if (Session["LoggedIn"] != null)
                {
                    vendor objcustomer;
                    if (id > 0)
                    {
                        objcustomer = DBClass.db.vendors.Where(x => x.idx == id).FirstOrDefault();
                        objcustomer.visible = 0;
                        using (var db = new RAJPUT_RICE_DBEntities())
                        {
                            //db.companyBanks.Add(objcustomer);
                            //db.SaveChanges();
                            //db.companyBanks.Attach(objcustomer);
                            db.Entry(objcustomer).State = EntityState.Modified;
                            db.SaveChanges();
                        }
                        return Json(new { success = true, statuscode = 200, msg = "Delete Successfully" }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, statuscode = 500, msg = "Error Occured", url = "/Vendor/ViewAllVendors" }, JsonRequestBehavior.AllowGet);
                    }
                }

                else
                {
                    return Json(new { success = true, statuscode = 400, msg = "Session Expired", url = "/Account/Login" }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception e)
            {
                return Json(new { success = false, statuscode = 500, msg = e.Message, url = "#" }, JsonRequestBehavior.AllowGet);

            }
        }

    }
}