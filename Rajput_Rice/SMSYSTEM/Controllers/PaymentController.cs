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
    public class PaymentController : Controller
    {
        // GET: Payment
        public ActionResult ViewPayments()
        {
            if (Session["LoggedIn"] != null)
            {
                Payment_Property objpayment = new Payment_Property();
                objpayment.VendorLsit= DBClass.db.vendors.ToList().Select(p => new Vendor_Property
                {
                    idx = p.idx,
                    vendorName = p.vendorName
                }).ToList();
                objpayment.Paymentmodelist = DBClass.db.paymentModes.ToList().Select(p => new PaymentMode_Property
                {
                    idx = p.idx,
                    paymentMode = p.paymentMode1
                }).ToList();
                objpayment.BankList = DBClass.db.banks.ToList().Select(p => new Bank_Property
                {
                    idx = p.idx,
                    bankName = p.bankName
                }).ToList();
                //   DBClass.db.vendors.ToList();
                return View(objpayment);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }
        [HttpPost]
        public JsonResult SearchPayment(Payment_Property objpayment)
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {

                //var data = (from A in DBClass.db.accountMasterGLs
                //            join V in DBClass.db.vendors on A.vendorIdx equals V.idx
                //            where (A.vendorIdx == objpayment.vendor_Id && A.DueDate <= objpayment.DueDate && A.isCredit == 1)
                //            select new
                //            {

                //                A.vendorIdx,
                //                V.vendorName,
                //                A.balance
                //            }
                //         into X group X by new
                //         {
                //             X.vendorIdx,
                //             X.vendorName,

                //         }
                //         into G
                //            select new
                //            {
                //                DueDate=objpayment.DueDate,
                //                Balancemount = G.Sum(i => i.balance),
                //                VendorName = G.Key.vendorName,
                //                VendorId = G.Key.vendorIdx
                //            }).ToList();

                var data = (from A in DBClass.db.accountMasterGLs
                            join V in DBClass.db.vendors on A.vendorIdx equals V.idx
                            where (A.vendorIdx == objpayment.vendor_Id && A.DueDate <= objpayment.DueDate && A.isCredit == 1 && A.tranTypeIdx==1)
                            select new
                            {
                                A.idxx,
                                A.vendorIdx,
                                V.vendorName,
                                A.balance
                            }
                         ).ToList();


                //var data = DBClass.db.accountMasterGLs.Where(p => p.vendorIdx == objpayment.vendor_Id && p.DueDate <= objpayment.DueDate && p.isCredit == 1 && p.tranTypeIdx == 1).ToList();
               //.Join()
               //  .ToList();

                return Json(new { data = data, success = true, statuscode = 400, url = "" }, JsonRequestBehavior.AllowGet);



            }
            else
            {
                return Json(new { data = "No Login Found", success = true, statuscode = 400, url = "/Customer/ViewAllCustomers" }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult AddUpdate(Payment_Property objpayment)
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {

                if (Convert.ToDecimal(objpayment.PaidAmount) > 0)
                {
                    using (var txn = new TransactionScope())
                    {



                        //  string pinvoice = timeline[0].poNumber;
                        var previousam = DBClass.db.accountMasterGLs.Where(p => p.idxx == objpayment.AccountId).ToList();
                        string mstid = previousam[0].invoiceNoIdx;
                        var purchasemstr = DBClass.db.purchases.Where(p => p.poNumber == mstid).FirstOrDefault();
                        
                        decimal? totalamount = previousam.Sum(x => x.balance);
                        totalamount = totalamount - Convert.ToDecimal(objpayment.PaidAmount);

                        decimal purchaseblnceamt =Convert.ToDecimal(Convert.ToDecimal(purchasemstr.balanceAmount)- objpayment.PaidAmount);
                        //decimal purchasetotalamt = Convert.ToDecimal(Convert.ToDecimal(purchasemstr.totalAmount) - totalamount);
                        if (totalamount > 0)
                        {
                            DBClass.db.Database.ExecuteSqlCommand("UPDATE accountMasterGL SET isCredit = {0} ,balance={1},DueDate={2} WHERE idxx = {3} ", 1, totalamount, objpayment.NextDueDate, objpayment.AccountId);
                           DBClass.db.Database.ExecuteSqlCommand("UPDATE purchase SET balanceAmount={0} WHERE poNumber = {1} ", purchaseblnceamt, previousam[0].invoiceNoIdx);

                        }
                        else
                        {
                            DBClass.db.Database.ExecuteSqlCommand("UPDATE accountMasterGL SET isCredit = {0},balance={1} WHERE idxx = {2}", 0, 0,objpayment.AccountId);
                            DBClass.db.Database.ExecuteSqlCommand("UPDATE purchase SET balanceAmount={0} WHERE poNumber = {1} ", purchaseblnceamt, previousam[0].invoiceNoIdx);
                        }


                        accountMasterGL objaccountmaster = new accountMasterGL();
                        objaccountmaster.tranTypeIdx = 6;
                        objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objaccountmaster.vendorIdx = objpayment.vendor_Id;
                        objaccountmaster.invoiceNoIdx = "PMT-00" + previousam[0].idxx;
                        objaccountmaster.debit = totalamount;
                        objaccountmaster.credit = totalamount;
                        objaccountmaster.paymentModeIdx = objpayment.paymentModeIdx;
                        objaccountmaster.bankIdx = objpayment.bankIdx;
                        objaccountmaster.chequeNumber = objpayment.accorChequeNumber;
                        //objaccountmaster.da = objpayment.paymentModeIdx;
                        objaccountmaster.balance = Convert.ToDecimal(objpayment.balanceamount);
                        objaccountmaster.DueDate = objpayment.NextDueDate;
                        objaccountmaster.paidAmount = Convert.ToDecimal(objpayment.PaidAmount);
                        if (objaccountmaster.balance > 0)
                        {
                            objaccountmaster.isCredit = 1;
                        }
                        else
                        {
                            objaccountmaster.isCredit = 0;
                        }
                        objaccountmaster.createDate = DateTime.Now;
                        DBClass.db.accountMasterGLs.Add(objaccountmaster);
                        DBClass.db.SaveChanges();

                        int acountmsid = objaccountmaster.idxx;

                        accountGJ objacountgj = new accountGJ();
                        objacountgj.tranTypeIdx = 6;
                        objacountgj.GLIdx = acountmsid;
                        objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objacountgj.vendorIdx = objpayment.vendor_Id;
                        objacountgj.invoiceNo = objaccountmaster.invoiceNoIdx;
                        objacountgj.debit = totalamount;
                        objacountgj.credit = 0.00m;
                        if (objpayment.paymentModeIdx == 1)
                        {
                            objacountgj.coaIdx = 56;
                        }
                        if (objpayment.paymentModeIdx == 2)
                        {
                            objacountgj.coaIdx = 43;
                        }
                        if (objpayment.paymentModeIdx == 3)
                        {
                            objacountgj.coaIdx = 64;
                        }
                        objacountgj.createDate = DateTime.Now;
                        DBClass.db.accountGJs.Add(objacountgj);
                        DBClass.db.SaveChanges();


                        objacountgj = new accountGJ();
                        objacountgj.tranTypeIdx = 6;
                        objacountgj.GLIdx = acountmsid;
                        objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objacountgj.vendorIdx = objpayment.vendor_Id;
                        objacountgj.invoiceNo = objaccountmaster.invoiceNoIdx;
                        objacountgj.debit = 0.00m;
                        objacountgj.credit = totalamount;
                        objacountgj.coaIdx = 43;
                        objacountgj.createDate = DateTime.Now;
                        DBClass.db.accountGJs.Add(objacountgj);
                        DBClass.db.SaveChanges();

                        txn.Complete();
                    }
                }
                return Json(new { data = "ok", success = true, statuscode = 400, url = "/Payment/ViewPayments" }, JsonRequestBehavior.AllowGet);



            }
            else
            {
                return Json(new { data = "No Login Found", success = true, statuscode = 400, url = "/Payment/ViewPayments" }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult ViewBill(int id)
        {
            try
            {
                DBClass.db.Dispose();
                DBClass.db = new RAJPUT_RICE_DBEntities();
                var data = DBClass.db.accountMasterGLs.Where(p => p.idxx == id).ToList();
                return Json(new { data = data, success = true, statuscode = 400, url = "" }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                return Json(new { data = ex.InnerException, success = true, statuscode = 400, url = "" }, JsonRequestBehavior.AllowGet);
            }
        }

    }
}