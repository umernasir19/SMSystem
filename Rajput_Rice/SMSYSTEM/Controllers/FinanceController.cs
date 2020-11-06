using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class FinanceController : Controller
    {
        // GET: Finance
        public ActionResult ExpenseVouchers()
        {
            if (Session["LoggedIn"] != null)
            {
                ExpenseVoucher_Property objexpnvoucher = new ExpenseVoucher_Property();

               


                int lastPOid = Convert.ToInt16(Models.DBClass.db.accountMasterGLs.Where(p=>p.tranTypeIdx==9).OrderByDescending(x => x.idxx).Select(x => x.idxx).FirstOrDefault().ToString()) + 1;
                objexpnvoucher.voucherNo =("EX-00"+lastPOid).ToString();
               // objexpnvoucher.VoucherDate = DateTime.Now;
                objexpnvoucher.amount = 0.00m;
                objexpnvoucher.Paymentmodelist = DBClass.db.paymentModes.ToList().Select(p => new PaymentMode_Property
                {
                    idx = p.idx,
                    paymentMode = p.paymentMode1
                }).ToList();
               

                objexpnvoucher.BankList = (from e in DBClass.db.companyBanks
                                        join d in DBClass.db.banks on e.bankIdx equals d.idx
                                        select new Bank_Property
                                        {
                                            idx = e.idx,
                                            bankName = d.bankName


                                        }).ToList();
                objexpnvoucher.COACHILDS = DBClass.db.ChartofAccountsChildHeads.Where(p => p.headIdx == 4 && p.visible == 1).Select(p => new COACHILDHEAD_Property
                {
                    idx = p.idx,
                    childHeadName = p.childHeadName
                }).ToList();

                return View("ExpenseVouchers", objexpnvoucher);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }


        [HttpPost]
        public JsonResult AddUpdate(ExpenseVoucher_Property objexpense)
        {
            try
            {
                using (var db = new RAJPUT_RICE_DBEntities())
                {
                    using (var txn = new TransactionScope())
                    {
                        #region Account
                        accountMasterGL objaccountmaster = new accountMasterGL();
                        objaccountmaster.tranTypeIdx = 9;
                        objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        //  objaccountmaster.vendorIdx = timeline[0].vendorIdx;
                        objaccountmaster.invoiceNoIdx = objexpense.voucherNo;
                        objaccountmaster.debit = objexpense.amount; //timeline[i].qty * timeline[i].unitPrice;//Should be total Amount
                        objaccountmaster.credit = objexpense.amount;// timeline[i].qty * timeline[i].unitPrice;
                        objaccountmaster.paymentModeIdx = objexpense.paymentModeIdx;
                        if (objaccountmaster.paymentModeIdx > 0)
                        {


                            objaccountmaster.bankIdx = objexpense.bankIdx;

                            if (objexpense.paymentModeIdx == 2)
                            {
                                objaccountmaster.chequeNumber = objexpense.accorChequeNumber;
                                objexpense.paidDate = objexpense.paidDate;
                            }
                        }

                        objaccountmaster.balance = 0.00m;
                        objaccountmaster.isCredit = 0;
                        objaccountmaster.paidAmount = Convert.ToDecimal(objexpense.amount);
                        objaccountmaster.createDate = DateTime.Now;
                        db.accountMasterGLs.Add(objaccountmaster);
                        db.SaveChanges();
                        //account master entries done
                        int acountmsid = objaccountmaster.idxx;

                        accountGJ objacountgj = new accountGJ();
                        objacountgj.tranTypeIdx = 9;
                        objacountgj.GLIdx = acountmsid;
                        objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        //  objacountgj.vendorIdx = timeline[0].vendorIdx;
                        objacountgj.invoiceNo = objexpense.voucherNo;
                        objacountgj.credit = objexpense.amount;
                        objacountgj.debit = 0.00m;
                        //for cash
                        if (objexpense.paymentModeIdx == 1)
                        {
                            objacountgj.coaIdx = 56;
                        }
                        if (objexpense.paymentModeIdx == 2)
                        {
                            objacountgj.coaIdx = 64;
                        }
                        if (objexpense.paymentModeIdx == 3)
                        {
                            objacountgj.coaIdx = 64;
                        }

                        objacountgj.createDate = DateTime.Now;
                        db.accountGJs.Add(objacountgj);
                        db.SaveChanges();


                        //credit entry for gj
                        objacountgj = new accountGJ();
                        objacountgj.tranTypeIdx = 9;
                        objacountgj.GLIdx = acountmsid;
                        objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        //objacountgj.vendorIdx = timeline[0].vendorIdx;
                        objacountgj.invoiceNo = objexpense.voucherNo;

                        //for cash
                        objacountgj.credit = 0.00m;
                        objacountgj.debit = objexpense.amount;
                        objacountgj.coaIdx = objexpense.COAID;
                        //for cheque

                        objacountgj.createDate = DateTime.Now;
                        db.accountGJs.Add(objacountgj);
                        db.SaveChanges();

                        txn.Complete();
                    }

                }
                return Json(new { data = "", code = 200, success = true,url="/Finance/ViewAllVouchers" }, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                return Json(new { data = ex.InnerException, code = 400 , success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult ViewAllVouchers()
        {
            return View();

        }


        public JsonResult ViewExpenseVoucher()
        {
            var data = DBClass.db.accountMasterGLs.Where(p=>p.tranTypeIdx==9).ToList();

            return Json(new { data = data }, JsonRequestBehavior.AllowGet);
        }
    }
}
#endregion