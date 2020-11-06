using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
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
                    var customers = DBClass.db.customers.ToList();
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
            if (Session["LoggedIn"] != null)
            {
                
                return PartialView("_AddNewCustomer");
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
                if (!ModelState.IsValid)
                {
                    try
                    {
                        var model = new SMSYSTEM.customer();
                        if (objCustomer.idx > 0)
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
                                model.contactPersonName = objCustomer.contactPersonName;
                                model.customerName = objCustomer.customerName;
                                model.customerCode = objCustomer.customerCode;
                                model.accountNo = objCustomer.accountNo;
                                model.contact = objCustomer.contact;
                               
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
    }
}