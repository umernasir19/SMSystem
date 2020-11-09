using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class CompanyBankController: Controller
    {
        public ActionResult ViewCompanyBanks()
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
        public JsonResult ViewAllCompanyBank()
        {
            if (Session["LoggedIn"] != null)
            {
                try
                {
                    var companybank = from s in DBClass.db.companyBanks
                                      join sa in DBClass.db.banks on s.bankIdx equals sa.idx
                                      where s.visible == "1"
                                      select new { bankName = sa.bankName, accountTitle = s.accountTitle, accountNumber = s.accountNumber, branch = s.Branch };
                    var companyBanks = DBClass.db.Database.ExecuteSqlCommand(@"select cb.*,bk.bankName from companyBank cb inner join bank bk on bk.idx=cb.bankIdx where cb.visible=1");
                    return Json(new { data = companybank, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
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

        public ActionResult AddNewCompanyBank(int? id)
        {
            if (Session["LoggedIn"] != null)
            {
                CompanyBankVM objBankvm = new CompanyBankVM();

                if (id != null && id > 0)
                {
                    ViewBag.bklist = DBClass.db.banks.ToList();
                    objBankvm = DBClass.db.companyBanks.Where(p => p.idx == id).Select(p=> new CompanyBankVM {
                        idx=p.idx,
                        bankIdx=p.bankIdx,
                        accountNumber=p.accountNumber,
                        Branch=p.Branch,
                        accountTitle=p.accountTitle

                    }).FirstOrDefault();

                    objBankvm.Banklst = DBClass.db.banks.ToList().Select(p => new Bank_Property
                    {
                        bankName = p.bankName,
                        idx = p.idx
                    }).ToList();
                }
                else
                {
                    //ViewBag.ptlist = DBClass.db.productTypes.ToList();
                    // ProductVM objprdctvm = new ProductVM();
                    objBankvm.Banklst = DBClass.db.banks.ToList().Select(p => new Bank_Property
                    {
                        bankName = p.bankName,
                        idx = p.idx
                    }).ToList();


                }




                return PartialView("_AddNewCompanyBank", objBankvm);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }
        [HttpPost]
        public JsonResult AddUpdate(CompanyBankVM objCompanyBankVM)
        {
            if (Session["LoggedIn"] != null)
            {
                if (ModelState.IsValid)
                {//if valid

                    try
                    {
                        //Checking Database 
                        //var producttype = DBClass.db.productTypes.Where(p => p.productType1 == objCompanyBanktype.productType).FirstOrDefault();
                        //if (producttype != null)
                        //{
                        //    return Json(new { success = true, statuscode = 409, msg = "ProductType Already Exist", url = "#" }, JsonRequestBehavior.AllowGet);

                        //}
                        //else
                        //{
                        companyBank objCompanyBank = new companyBank()
                        {
                            bankIdx = objCompanyBankVM.bankIdx,
                            accountTitle = objCompanyBankVM.accountTitle,
                            Branch = objCompanyBankVM.Branch,
                            accountNumber = objCompanyBankVM.accountNumber,
                            creationDate = DateTime.Now,
                            createdByUserIdx = Convert.ToInt32(Session["Useridx"].ToString()),
                            visible = "1"
                        };
                        DBClass.db.companyBanks.Add(objCompanyBank);
                        DBClass.db.SaveChanges();
                        return Json(new { success = true, statuscode = 200, msg = "Added Successfully", url = "/CompanyBank/ViewCompanyBanks" }, JsonRequestBehavior.AllowGet);

                        //                        }

                    }
                    catch (Exception ex)
                    {
                        //If Exception
                        return Json(new { success = false, statuscode = 500, msg = ex.Message, url = "#" }, JsonRequestBehavior.AllowGet);
                    }

                }
                else
                {//Validation Failed
                    return Json(new { success = true, statuscode = 400, msg = "Validation Failed", url = "#" }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(new { success = true, statuscode = 400, msg = "Session Expired", url = "/Account/Login" }, JsonRequestBehavior.AllowGet);

            }
        }
    }
}