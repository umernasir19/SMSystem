using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class CustomerController : Controller
    {
        // GET: Customer
        public ActionResult ViewAllCustomers()
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

        [HttpGet]
        public JsonResult ViewCustomers()
        {
            if (Session["LoggedIn"] != null)
            {
                try
                {
                    var customers = DBClass.db.customers.Where(x => x.visible == 1).OrderByDescending(x => x.idx).ToList();
                    return Json(new { data = customers, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
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

        public ActionResult AddNewCustomer(int? id)
        {
            Customer_Property customer = new Customer_Property();
            if (Session["LoggedIn"] != null)
            {
                if (id > 0)
                {
                    var customerData = DBClass.db.customers.Where(x => x.idx == id).FirstOrDefault();
                    customer.idx = customerData.idx;
                    customer.contactPersonName = customerData.contactPersonName;
                    customer.customerName = customerData.customerName;
                    customer.customerCode = customerData.customerCode;
                    customer.cnic = customerData.cnic;
                    customer.accountNo = customerData.accountNo;
                    customer.contact = customerData.contact;
                    customer.visible = 1;
                }
                return PartialView("_AddNewCustomer", customer);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }

        [HttpPost]
        public JsonResult AddUpdate(Customer_Property objCustomer)
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {

                #region Session Exist
                if (ModelState.IsValid)
                {
                    try
                    {
                        var model = new SMSYSTEM.customer();
                        if (objCustomer.idx > 0)
                        {//update
                            model = DBClass.db.customers.Where(p => p.idx == objCustomer.idx).FirstOrDefault();

                            model.contactPersonName = objCustomer.contactPersonName;
                            model.customerName = objCustomer.customerName;
                            model.customerCode = objCustomer.customerCode;
                            model.accountNo = objCustomer.accountNo;
                            model.contact = objCustomer.contact;
                            model.visible = 1;
                            model.lastModificationDate = DateTime.Now.Date.ToString("yyyy-MM-dd");
                            model.lastModifiedByUserIdx = Convert.ToInt32(Session["Useridx"].ToString());


                            DBClass.db.Entry(model).State = EntityState.Modified;
                            DBClass.db.SaveChanges();
                            return Json(new { success = true, statuscode = 200, msg = "Updated Successfully", url = "#" }, JsonRequestBehavior.AllowGet);



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
                            model.contactPersonName = objCustomer.contactPersonName;
                            model.customerName = objCustomer.customerName;
                            model.customerCode = objCustomer.customerCode;
                            model.accountNo = objCustomer.accountNo;
                            model.contact = objCustomer.contact;
                            model.cnic = objCustomer.cnic;
                            model.visible = 1;
                            model.creationDate = DateTime.Now;
                            model.createdByUserIdx = Convert.ToInt32(Session["Useridx"].ToString());
                            DBClass.db.customers.Add(model);
                            DBClass.db.SaveChanges();
                            return Json(new { success = true, statuscode = 200, msg = "User Inserted Succesfully", url = "/Customer/ViewAllCustomers" }, JsonRequestBehavior.AllowGet);
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
        public JsonResult DeleteCustomer(int id)
        {
            try
            {
                if (Session["LoggedIn"] != null)
                {
                    customer objcustomer;
                    if (id > 0)
                    {
                        objcustomer = DBClass.db.customers.Where(x => x.idx == id).FirstOrDefault();
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
                        return Json(new { success = false, statuscode = 500, msg = "Error Occured", url = "/Customer/ViewAllCustomers" }, JsonRequestBehavior.AllowGet);
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