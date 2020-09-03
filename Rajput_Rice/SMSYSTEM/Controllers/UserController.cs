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
    public class UserController : Controller
    {
        // GET: User
        public ActionResult SystemUsers()
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {
                return View();
            }
            else
            {
                return RedirectToAction("NotAuthorized", "Account");
            }
            
        }

        [HttpGet]
        public JsonResult ViewSystemUsers()
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {
                try
                {
                    var SystemUsers = (from U in DBClass.db.Users
                                      join CU in DBClass.db.Users on U.createdByUserIdx equals CU.idx
                                      select new
                                      {
                                          ID=U.idx,
                                          firstname = U.firstName,
                                          lastname = U.lastName,
                                          cnic = U.CNIC,
                                          cellnumber = U.cellNumber,
                                          loginId = U.loginId,
                                          datecreated = U.creationDate,
                                          createdby = CU.loginId
                                      }).ToList();
                   // var SystemUsers = DBClass.db.Users.ToList();
                    return Json(new { data = SystemUsers, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
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

        public ActionResult AddSystemUsers()
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {
                return PartialView("_AddSystemUsers");
            }
            else
            {
                return RedirectToAction("NotAuthorized", "Account");
            }

        }

        [HttpPost]
        public JsonResult AddUpdate(User_Property objUser)
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {

                #region Session Exist
                if (!ModelState.IsValid)
                {
                    try
                    {
                        var model = new SMSYSTEM.User();
                        if (objUser.idx > 0)
                        {//update
                            return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/user/SystemUsers" }, JsonRequestBehavior.AllowGet);

                        }
                        else
                        {//insert
                            var checkExists = DBClass.db.Users.Any(x => x.loginId == model.loginId);
                            if (checkExists)
                            {
                                return Json(new { success = false, message = "Name Already Exists", statusCode = HttpStatusCode.Ambiguous }, JsonRequestBehavior.DenyGet);
                            }
                            else
                            {
                                model.firstName = objUser.firstName;
                                model.lastName = objUser.lastName;
                                model.CNIC = objUser.CNIC;
                                model.email = objUser.email;
                                model.loginId = objUser.loginId;
                                model.loginId = objUser.loginId;
                                model.password = objUser.password;
                                model.creationDate = DateTime.Now;
                                model.Is_Admin = objUser.Is_Admin;
                                DBClass.db.Users.Add(model);
                                DBClass.db.SaveChanges();
                                return Json(new { success = true, statuscode = 200, msg = "User Inserted Succesfully", url = "/user/SystemUsers" }, JsonRequestBehavior.AllowGet);
                            }

                        }

                    }
                    catch (Exception ex)
                    {

                        return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/user/SystemUsers" }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/user/SystemUsers" }, JsonRequestBehavior.AllowGet);
                }
                #endregion
            }
            else
            {
                return Json(new { data = "No Login Found", success = true, statuscode = 400 }, JsonRequestBehavior.AllowGet);
            }
        }


        
    }
}