using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class PlannerController : Controller
    {
        // GET: Planner
        public ActionResult ViewPlanner()
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
        public JsonResult ViewAllTODOS()
        {
            try
            {
                var data = DBClass.db.planners.ToList();
                return Json(new { data = data }, JsonRequestBehavior.AllowGet);

            }
            catch(Exception ex)
            {
                return Json(new { data = ex.InnerException }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult AddNewPlanner(int? id)
        {
            if (Session["LoggedIn"] != null)
            {
          
                return PartialView("_AddNewPlanner");
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }


        [HttpPost]
        public JsonResult AddUpdate(Planner__Property objplanner)
        {
            try
            {
                planner pln = new planner();
                pln.ID = objplanner.ID;
                pln.TO_DO = objplanner.TO_DO;
                pln.TO_DO_Date = objplanner.TO_DO_Date;
                pln.status =true;
                pln.DateCreated = DateTime.Now;
                pln.TO_DO = objplanner.TO_DO;
                pln.CreatedBy = Convert.ToInt16(Session["Useridx"].ToString());
                DBClass.db.planners.Add(pln);
                DBClass.db.SaveChanges();
                // objplanner.TO_DO_Date;
                // objplanner.TO_DO_Date;
                return Json(new { success = true, statuscode = 200, msg = "Successfull", url = "/Planner/ViewPlanner" }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                return Json(new { data = ex.InnerException }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}