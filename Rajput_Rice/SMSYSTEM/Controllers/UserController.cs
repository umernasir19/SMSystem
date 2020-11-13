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
    public class UserController : Controller
    {
        User_Property _objUser;
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
                                       where U.visible == 1
                                       select new
                                       {
                                           ID = U.idx,
                                           firstname = U.firstName,
                                           lastname = U.lastName,
                                           cnic = U.CNIC,
                                           email = U.email,
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

        public ActionResult AddSystemUsers(int? Id)
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {
                _objUser = new User_Property();
                if (Id > 0)
                {
                    var user = DBClass.db.Users.Where(p => p.idx == Id).FirstOrDefault();
                    if (user != null)
                    {
                        _objUser.idx = user.idx;
                        _objUser.firstName = user.firstName;
                        _objUser.lastName = user.lastName;
                        _objUser.CNIC = user.CNIC;
                        _objUser.email = user.email;
                        _objUser.loginId = user.loginId;
                        _objUser.password = user.password;
                        _objUser.Is_Admin = Convert.ToBoolean(user.Is_Admin);


                    }
                }


                return PartialView("_AddSystemUsers", _objUser);
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

                            var checkExists = DBClass.db.Users.Any(x => x.loginId == objUser.loginId || x.CNIC == objUser.CNIC);

                            if (checkExists)
                            {
                                return Json(new { success = false, msg = "LoginID/CNIC Already Exists", statusCode = HttpStatusCode.Ambiguous }, JsonRequestBehavior.DenyGet);
                            }

                            else
                            {

                                model = DBClass.db.Users.Where(p => p.idx == objUser.idx).FirstOrDefault();
                                model.idx = objUser.idx;
                                model.firstName = objUser.firstName;
                                model.lastName = objUser.lastName;
                                model.CNIC = objUser.CNIC;
                                model.email = objUser.email;
                                model.loginId = objUser.loginId;
                                model.loginId = objUser.loginId;
                                model.password = objUser.password;
                                model.lastModificationDate = DateTime.Now.ToString("MM/dd/yyyy");
                                model.Is_Admin = objUser.Is_Admin;
                                model.lastModifiedByUserIdx = Convert.ToInt16(Session["Useridx"].ToString());
                                model.isActive = 1;
                                model.visible = 1;
                                // DBClass.db.Entry(model).CurrentValues.SetValues(model);
                                //  DBClass.db.Entry(model).State = System.Data.EntityState.Modified;
                                //DBClass.db.Users.Find(model.idx);
                                using (var db = new RAJPUT_RICE_DBEntities())
                                {
                                    db.Entry(model).State = EntityState.Modified;
                                    db.SaveChanges();
                                }

                                return Json(new { success = true, statuscode = 200, msg = "User Updated Succesfully", url = "/user/SystemUsers" }, JsonRequestBehavior.AllowGet);


                                //return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "/user/SystemUsers" }, JsonRequestBehavior.AllowGet);
                            }
                        }
                        else
                        {//insert
                            var checkExists = DBClass.db.Users.Any(x => x.loginId == objUser.loginId || x.CNIC == objUser.CNIC);
                            if (checkExists)
                            {
                                return Json(new { success = false, msg = "LoginID/CNIC Already Exists", statusCode = HttpStatusCode.Ambiguous }, JsonRequestBehavior.DenyGet);
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
                                model.createdByUserIdx = Convert.ToInt16(Session["Useridx"].ToString());
                                model.isActive = 1;// objUser.Is_Admin;
                                model.visible = 1;
                                using (var db = new RAJPUT_RICE_DBEntities())
                                {
                                    db.Users.Add(model);
                                    db.SaveChanges();
                                }

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

        public JsonResult DeleteUser(int id)
        {
            try
            {
                if (Session["LoggedIn"] != null)
                {
                    User objUser;
                    if (id > 0)
                    {
                        objUser = DBClass.db.Users.Where(x => x.idx == id).FirstOrDefault();
                        objUser.visible = 0;
                        using (var db = new RAJPUT_RICE_DBEntities())
                        {
                            //db.companyBanks.Add(objUser);
                            //db.SaveChanges();
                            //db.companyBanks.Attach(objUser);
                            db.Entry(objUser).State = EntityState.Modified;
                            db.SaveChanges();
                        }
                        return Json(new { success = true, statuscode = 200, msg = "Delete Successfully", url = "/User/SystemUsers" }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, statuscode = 500, msg = "Error Occured", url = "/User/SystemUsers" }, JsonRequestBehavior.AllowGet);
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