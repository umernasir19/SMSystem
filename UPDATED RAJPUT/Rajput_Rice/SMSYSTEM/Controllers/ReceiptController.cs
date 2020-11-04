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
    public class ReceiptController : Controller
    {
        // GET: Receipt
        // GET: Receipt
        public ActionResult ViewReceipts()
        {
            if (Session["LoggedIn"] != null)
            {
                Receipt_Property objpayment = new Receipt_Property();
                objpayment.customerList = DBClass.db.customers.ToList().Select(p => new Customer_Property
                {
                    idx = p.idx,
                    customerName = p.customerName
                }).ToList();

                objpayment.Paymentmodelist = DBClass.db.paymentModes.ToList().Select(p => new PaymentMode_Property
                {
                    idx = p.idx,
                    paymentMode = p.paymentMode1
                }).ToList();
                //objPrchseVM.BankList = DBClass.db.banks.ToList().Select(p => new Bank_Property
                //{
                //    idx = p.idx,
                //    bankName = p.bankName
                //}).ToList();

                objpayment.BankList = (from e in DBClass.db.companyBanks
                                       join d in DBClass.db.banks on e.bankIdx equals d.idx
                                       select new Bank_Property
                                       {
                                           idx = e.idx,
                                           bankName = d.bankName


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
        public JsonResult SearchReceipt(Receipt_Property objpayment)
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
                            join V in DBClass.db.customers on A.customerIdx equals V.idx
                            where (A.customerIdx == objpayment.customer_Id && A.isCredit == 1 && A.tranTypeIdx == 2)
                            select new
                            {
                                A.idxx,
                                A.customerIdx,
                                V.customerName,
                                A.debit,
                                A.balance,
                                A.paidAmount
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
        public JsonResult AddUpdate(Receipt_Property objpayment)
        {
            if (Session["IsAdmin"] != null && Convert.ToBoolean(Session["IsAdmin"].ToString()) == true)
            {

                if (Convert.ToDecimal(objpayment.PaidAmount) > 0)
                {
                    using (var db = new RAJPUT_RICE_DBEntities())
                    {
                        using (var txn = new TransactionScope())
                        {
                            //  string pinvoice = timeline[0].poNumber;


                            var previousam = db.accountMasterGLs.Where(p => p.idxx == objpayment.AccountId).ToList();
                            string invoiceNum = previousam.FirstOrDefault().invoiceNoIdx.ToString();
                            int customerIdx = int.Parse(previousam[0].customerIdx.ToString());
                            var invoiceSplit = invoiceNum.Split('-').ToArray();
                            int saleId;
                            var parseId = int.TryParse(invoiceSplit[1], out saleId);
                            decimal? previousPaidAmount = previousam.Sum(x => x.paidAmount);
                            decimal? totalamount = previousam.Sum(x => x.balance);

                            totalamount = totalamount - Convert.ToDecimal(objpayment.PaidAmount);

                            previousPaidAmount += Convert.ToDecimal(objpayment.PaidAmount);



                            if (totalamount > 0)
                            {
                                db.Database.ExecuteSqlCommand("UPDATE accountMasterGL SET isCredit = {0} ,balance={1},paidAmount={2} WHERE idxx = {3} ", 1, totalamount, previousPaidAmount, objpayment.AccountId);

                                db.Database.ExecuteSqlCommand("UPDATE sales SET isPaid = {0} ,balance={1},paid={2} WHERE idx = {3} ", 0, totalamount, previousPaidAmount, saleId);
                            }
                            else
                            {
                                db.Database.ExecuteSqlCommand("UPDATE accountMasterGL SET isCredit = {0},balance={1},paidAmount{2} WHERE idxx = {3}", 0, 0, previousPaidAmount, objpayment.AccountId);

                                db.Database.ExecuteSqlCommand("UPDATE sales SET isPaid = {0} ,balance={1},paid={2} WHERE idx = {3} ", 1, totalamount, previousPaidAmount, saleId);
                            }


                            accountMasterGL objaccountmaster = new accountMasterGL();
                            objaccountmaster.tranTypeIdx = 5;
                            objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objaccountmaster.customerIdx = customerIdx;
                            objaccountmaster.invoiceNoIdx = "RPT-00" + previousam[0].idxx;
                            objaccountmaster.debit = Convert.ToDecimal(objpayment.PaidAmount);
                            objaccountmaster.credit = Convert.ToDecimal(objpayment.PaidAmount);
                            objaccountmaster.balance = Convert.ToDecimal(objpayment.balanceamount);
                            //objaccountmaster.DueDate = objpayment.NextDueDate;
                            objaccountmaster.paidAmount = Convert.ToDecimal(objpayment.PaidAmount);
                            if (objaccountmaster.balance > 0)
                            {
                                objaccountmaster.isCredit = 1;
                            }
                            else
                            {
                                objaccountmaster.isCredit = 0;
                            }
                            objaccountmaster.paymentModeIdx = objpayment.paymentModeIdx;
                            objaccountmaster.bankIdx = objpayment.bankIdx;
                            objaccountmaster.chequeNumber = objpayment.accorChequeNumber;
                            objaccountmaster.createDate = DateTime.Now;
                            db.accountMasterGLs.Add(objaccountmaster);
                            db.SaveChanges();

                            int acountmsid = objaccountmaster.idxx;

                            accountGJ objacountgj = new accountGJ();
                            objacountgj.tranTypeIdx = 5;
                            objacountgj.GLIdx = acountmsid;
                            objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objacountgj.customerIdx = customerIdx;
                            objacountgj.invoiceNo = objaccountmaster.invoiceNoIdx;
                            objacountgj.debit = objpayment.PaidAmount;
                            objacountgj.credit = 0.00m;
                            objacountgj.coaIdx = 56; // cash or Bank
                            objacountgj.createDate = DateTime.Now;
                            db.accountGJs.Add(objacountgj);
                            db.SaveChanges();


                            objacountgj = new accountGJ();
                            objacountgj.tranTypeIdx = 5;
                            objacountgj.GLIdx = acountmsid;
                            objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objacountgj.customerIdx = customerIdx;
                            objacountgj.invoiceNo = objaccountmaster.invoiceNoIdx;
                            objacountgj.debit = 0.00m;
                            objacountgj.credit = objpayment.PaidAmount;
                            objacountgj.coaIdx = 1;
                            objacountgj.createDate = DateTime.Now;
                            db.accountGJs.Add(objacountgj);
                            db.SaveChanges();

                            txn.Complete();
                        }
                    }
                }
                return Json(new { data = "ok", success = true, statuscode = 400, url = "/Receipt/ViewReceipts" }, JsonRequestBehavior.AllowGet);



            }
            else
            {
                return Json(new { data = "No Login Found", success = true, statuscode = 400, url = "/Receipt/ViewReceipts" }, JsonRequestBehavior.AllowGet);
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