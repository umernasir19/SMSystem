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
    public class PurchaseController : Controller
    {
        // GET: Purchase
        public ActionResult ViewPurchase()
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

        public ActionResult AddPurchase()
        {
            if (Session["LoggedIn"] != null)
            {
                PurchaseVM objPrchseVM = new PurchaseVM();
                Product_Property objPrdct = new Product_Property();
                objPrchseVM.VendorLST = DBClass.db.vendors.ToList().Select(p => new Vendor_Property
                {
                    idx = p.idx,
                    vendorName = p.vendorName
                }).ToList();
                objPrchseVM.ProductList = DBClass.db.products.ToList().Select(p => new Product_Property
                {
                    idx = p.idx,
                    itemName = p.itemName
                }).ToList();
                objPrchseVM.Paymentmodelist = DBClass.db.paymentModes.ToList().Select(p => new PaymentMode_Property
                {
                    idx = p.idx,
                    paymentMode = p.paymentMode1
                }).ToList();
                int lastPOid =Convert.ToInt16(DBClass.db.purchases.OrderByDescending(x => x.idx).Select(x => x.idx).FirstOrDefault().ToString())+1;
                objPrchseVM.poNumber = "PR-00" + lastPOid;
                //objPrchseVM.purchaseDate =DateTime.Now.ToString("YYYY-DD-MM");
                return PartialView("_AddPurchase", objPrchseVM);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }
       

        /// <summary>
        /// 
        /// </summary>
        /// <param name="timeline"></param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult ADDUpdate(List<PurchaseVM> timeline)
        {

            try
            {
                using (var txn = new TransactionScope())
                {
                   
                    string pdamount = timeline[0].paidAmount;
                    DateTime newduedate = timeline[0].purchaseduedate;
                    int vndrid = timeline[0].vendorIdx;
                    //seprating data of PO Master and PO Details

                    #region PO Master

                    purchase objPOMaster = new purchase();
                    objPOMaster.poNumber = timeline[0].poNumber;
                    objPOMaster.vendorIdx = timeline[0].vendorIdx;
                    objPOMaster.purchaseTypeIdx = timeline[0].purchaseTypeIdx;
                    objPOMaster.purchaseDate = timeline[0].purchaseDate;
                    objPOMaster.description = timeline[0].description;
                    objPOMaster.totalAmount = timeline.Sum(x => x.amount);
                    objPOMaster.netAmount = timeline[0].tax + timeline[0].taxAount + objPOMaster.totalAmount;
                    objPOMaster.paidAmount = timeline[0].paidAmount;
                    //objPOMaster.paidDate = timeline[0].paidDate;
                    objPOMaster.tax = timeline[0].tax;
                    objPOMaster.balanceAmount = timeline[0].balanceAmount;
                    objPOMaster.taxAount = timeline[0].taxAount;
                    //objPOMaster.purchaseduedate = Convert.ToDateTime(timeline[0].purchaseduedate.ToString("yyyy-MM-dd"));
                    objPOMaster.creationDate = DateTime.Now;//  Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));//DateTime.Now;//
                    objPOMaster.createdByUserIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    objPOMaster.status = timeline[0].status;
                    DBClass.db.purchases.Add(objPOMaster);
                    DBClass.db.SaveChanges();

                    int POMasterID = objPOMaster.idx;

                    #endregion
                    // objPOMaster.poNumber=
                    //PO Detail
                    #region POdetail
                    List<pruchaseDetail> purchasedetaillist = new List<pruchaseDetail>();
                    for (int i = 0; i < timeline.Count(); i++)
                    {
                        pruchaseDetail objprchasedetail = new pruchaseDetail();
                        objprchasedetail.purchaseIdx = POMasterID;
                        objprchasedetail.productTypeIdx = POMasterID;
                        objprchasedetail.itemIdx = timeline[i].itemIdx;
                        objprchasedetail.qty = timeline[i].qty;
                        objprchasedetail.unitPrice = timeline[i].unitPrice;
                        //objprchasedetail.qty = timeline[i].qty;
                        objprchasedetail.amount = timeline[i].qty * timeline[i].unitPrice;
                        objprchasedetail.creationDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));// DateTime.Now;
                        objprchasedetail.createdByUserIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objprchasedetail.lastModificationDate = DateTime.Now.ToString();
                        objprchasedetail.visible = 1;
                        objprchasedetail.DueDate = timeline[i].DueDate;
                        purchasedetaillist.Add(objprchasedetail);
                        DBClass.db.pruchaseDetails.Add(objprchasedetail);
                        DBClass.db.SaveChanges();

                        int purchasedtlid = objprchasedetail.idx;
                        //////////////Purcahse details end

                        #region Inventory

                        //checking product id
                        if (CheckProductInInventoryMaster(timeline[i].itemIdx))
                        {
                            //exist
                            int itemidx = timeline[i].itemIdx;
                            var invmastrid = DBClass.db.inventories.Where(p => p.productIdx == itemidx).FirstOrDefault();
                            
                            var purchsedtlid = DBClass.db.InventoryDetails.Where(p => p.InventoryIdx == invmastrid.idx).Select(x => x.PurchaseDetailidx).ToArray();
                            var purchases = DBClass.db.pruchaseDetails.Where(p => !purchsedtlid.Contains(p.idx) && p.itemIdx== invmastrid.productIdx).ToList();
                            decimal stockqty = Convert.ToDecimal(invmastrid.stock);
                            decimal unitprice = Convert.ToDecimal(invmastrid.unitPrice);
                            for (int j = 0; j < purchases.Count(); j++)
                            {
                                stockqty = stockqty + Convert.ToDecimal(purchases[j].qty);
                                unitprice = unitprice + Convert.ToDecimal(purchases[j].unitPrice);

                            }
                            unitprice = unitprice / 2;
                            DBClass.db.Database.ExecuteSqlCommand("UPDATE inventory SET stock = {0} ,unitPrice={1} WHERE idx = {2} ", stockqty, unitprice, invmastrid.idx);
                            for (int j = 0; j < purchases.Count(); j++)
                            {
                                InventoryDetail objinvdetails = new InventoryDetail();
                                objinvdetails.InventoryIdx = invmastrid.idx;
                                objinvdetails.PurchaseDetailidx = purchases[j].idx;
                                objinvdetails.ConsumptionIdx = 0;
                                DBClass.db.InventoryDetails.Add(objinvdetails);
                                DBClass.db.SaveChanges();

                            }

                            inventory_logs objinvntrylogs = new inventory_logs();
                            objinvntrylogs.productIdx = timeline[i].itemIdx;
                            objinvntrylogs.stock = timeline[i].qty;
                            objinvntrylogs.unitPrice = timeline[i].unitPrice;
                            objinvntrylogs.totalAmount = timeline[i].qty * timeline[i].unitPrice;
                            objinvntrylogs.creationDate = DateTime.Now;
                            DBClass.db.inventory_logs.Add(objinvntrylogs);
                            DBClass.db.SaveChanges();

                        }
                        else
                        {
                            //not exist
                            inventory objinvntry = new inventory();
                            objinvntry.productIdx = timeline[i].itemIdx;
                            objinvntry.stock = timeline[i].qty;
                            objinvntry.unitPrice = timeline[i].unitPrice;
                            objinvntry.totalAmount = timeline[i].qty * timeline[i].unitPrice;
                            objinvntry.creationDate = DateTime.Now;
                            DBClass.db.inventories.Add(objinvntry);
                            DBClass.db.SaveChanges();

                            int invntrymasterid = objinvntry.idx;
                            //inv details
                            InventoryDetail objinvdetails = new InventoryDetail();
                            objinvdetails.InventoryIdx = invntrymasterid;
                            objinvdetails.PurchaseDetailidx = purchasedtlid;
                            objinvdetails.ConsumptionIdx = 0;
                            DBClass.db.InventoryDetails.Add(objinvdetails);
                            DBClass.db.SaveChanges();

                            //inv logs
                            inventory_logs objinvntrylogs = new inventory_logs();
                            objinvntrylogs.productIdx = timeline[i].itemIdx;
                            objinvntrylogs.stock = timeline[i].qty;
                            objinvntrylogs.unitPrice = timeline[i].unitPrice;
                            objinvntrylogs.totalAmount = timeline[i].qty * timeline[i].unitPrice;
                            objinvntrylogs.creationDate = DateTime.Now;
                            DBClass.db.inventory_logs.Add(objinvntrylogs);
                            DBClass.db.SaveChanges();
                        }


                        #endregion

                        //Accounts
                        #region Account
                        accountMasterGL objaccountmaster = new accountMasterGL();
                        objaccountmaster.tranTypeIdx = 1;
                        objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objaccountmaster.vendorIdx = timeline[0].vendorIdx;
                        objaccountmaster.invoiceNoIdx = timeline[0].poNumber;
                        objaccountmaster.debit = timeline[i].qty * timeline[i].unitPrice;//Should be total Amount
                        objaccountmaster.credit = timeline[i].qty * timeline[i].unitPrice;
                       ;//Should be total Amount
                        if(Convert.ToDecimal(timeline[i].paidAmount) == timeline.Sum(x => x.amount))
                        {
                            objaccountmaster.balance = 0.00m;
                            objaccountmaster.isCredit = 0;
                            objaccountmaster.paidAmount = Convert.ToDecimal(timeline[i].qty * timeline[i].unitPrice);
                        }
                        else
                        {
                            objaccountmaster.balance = (timeline[i].qty * timeline[i].unitPrice);
                            objaccountmaster.isCredit = 1;
                            objaccountmaster.paidAmount = Convert.ToDecimal(timeline[i].qty * timeline[i].unitPrice);
                        }
                        
                        

                        objaccountmaster.DueDate = timeline[i].DueDate;
                       
                        objaccountmaster.createDate = DateTime.Now;
                        DBClass.db.accountMasterGLs.Add(objaccountmaster);
                        DBClass.db.SaveChanges();

                        int acountmsid = objaccountmaster.idxx;

                        accountGJ objacountgj = new accountGJ();
                        objacountgj.tranTypeIdx = 1;
                        objacountgj.GLIdx = acountmsid;
                        objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objacountgj.vendorIdx = timeline[0].vendorIdx;
                        objacountgj.invoiceNo = timeline[0].poNumber;
                        objacountgj.debit = timeline[i].qty * timeline[i].unitPrice;
                        objacountgj.credit = 0.00m;
                        objacountgj.coaIdx = 60;
                        objacountgj.createDate = DateTime.Now;
                        DBClass.db.accountGJs.Add(objacountgj);
                        DBClass.db.SaveChanges();
                        //credit entry for gj
                        objacountgj = new accountGJ();
                        objacountgj.tranTypeIdx = 1;
                        objacountgj.GLIdx = acountmsid;
                        objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objacountgj.vendorIdx = timeline[0].vendorIdx;
                        objacountgj.invoiceNo = timeline[0].poNumber;
                        objacountgj.debit = 0.00m;
                        objacountgj.credit = timeline[i].qty * timeline[i].unitPrice;
                        objacountgj.coaIdx = 43;
                        objacountgj.createDate = DateTime.Now;
                        DBClass.db.accountGJs.Add(objacountgj);
                        DBClass.db.SaveChanges();
                        #endregion







                    }
                    //if (Convert.ToDecimal(pdamount) > 0)
                    //{
                    //    string pinvoice = timeline[0].poNumber;
                    //    var previousam = DBClass.db.accountMasterGLs.Where(p => p.invoiceNoIdx == pinvoice && p.isCredit == 1).ToList();
                    //    decimal? totalamount = previousam.Sum(x => x.balance);
                    //    totalamount = totalamount - Convert.ToDecimal(pdamount);
                    //    DBClass.db.Database.ExecuteSqlCommand("UPDATE accountMasterGL SET isCredit = {0} WHERE invoiceNoIdx = {1} ", 0, pinvoice);


                    //    accountMasterGL objaccountmaster = new accountMasterGL();
                    //    objaccountmaster.tranTypeIdx = 1;
                    //    objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    //    objaccountmaster.vendorIdx = timeline[0].vendorIdx;
                    //    objaccountmaster.invoiceNoIdx ="BI-00"+ timeline[0].poNumber;//auto increment of mater
                    //    objaccountmaster.debit = totalamount;
                    //    objaccountmaster.credit = totalamount;
                    //    objaccountmaster.balance =Convert.ToDecimal(timeline[0].balanceAmount);
                    //    objaccountmaster.DueDate = timeline[0].purchaseduedate;
                    //    objaccountmaster.paidAmount = Convert.ToDecimal(timeline[0].paidAmount);
                    //    if (objaccountmaster.balance > 0)
                    //    {
                    //        objaccountmaster.isCredit = 1;
                    //    }
                    //    else
                    //    {
                    //        objaccountmaster.isCredit = 0;
                    //    }
                    //    objaccountmaster.createDate = DateTime.Now;
                    //    DBClass.db.accountMasterGLs.Add(objaccountmaster);
                    //    DBClass.db.SaveChanges();

                    //    int acountmsid = objaccountmaster.idxx;

                    //    accountGJ objacountgj = new accountGJ();
                    //    objacountgj.tranTypeIdx = 1;
                    //    objacountgj.GLIdx = acountmsid;
                    //    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    //    objacountgj.vendorIdx = timeline[0].vendorIdx;
                    //    objacountgj.invoiceNo = timeline[0].poNumber;
                    //    objacountgj.debit = totalamount;
                    //    objacountgj.credit = 0.00m;
                    //    objacountgj.coaIdx = 60;

                    //    objacountgj.createDate = DateTime.Now;
                    //    DBClass.db.accountGJs.Add(objacountgj);
                    //    DBClass.db.SaveChanges();
                    //    objacountgj = new accountGJ();
                    //    objacountgj.tranTypeIdx = 1;
                    //    objacountgj.GLIdx = acountmsid;
                    //    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    //    objacountgj.vendorIdx = timeline[0].vendorIdx;
                    //    objacountgj.invoiceNo = timeline[0].poNumber;
                    //    objacountgj.debit = 0.00m;
                    //    objacountgj.credit = totalamount;
                    //    objacountgj.coaIdx = 43;
                    //    objacountgj.createDate = DateTime.Now;
                    //    DBClass.db.accountGJs.Add(objacountgj);
                    //    DBClass.db.SaveChanges();


                    //    //Payment Entry
                    //     objaccountmaster = new accountMasterGL();
                    //    objaccountmaster.tranTypeIdx = 6;
                    //    objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    //    objaccountmaster.vendorIdx = timeline[0].vendorIdx;
                    //    objaccountmaster.invoiceNoIdx = "PL-00" + timeline[0].poNumber;//auto increment of mater
                    //    objaccountmaster.debit = totalamount;
                    //    objaccountmaster.credit = totalamount;
                        
                    //    objaccountmaster.balance = Convert.ToDecimal(timeline[0].balanceAmount);
                    //    objaccountmaster.DueDate = timeline[0].purchaseduedate;
                    //    objaccountmaster.paidAmount = Convert.ToDecimal(timeline[0].paidAmount);
                    //    if (objaccountmaster.balance > 0)
                    //    {
                    //        objaccountmaster.isCredit = 1;
                    //    }
                    //    else
                    //    {
                    //        objaccountmaster.isCredit = 0;
                    //    }
                    //    objaccountmaster.createDate = DateTime.Now;
                    //    DBClass.db.accountMasterGLs.Add(objaccountmaster);
                    //    DBClass.db.SaveChanges();

                    //     acountmsid = objaccountmaster.idxx;

                    //     objacountgj = new accountGJ();
                    //    objacountgj.tranTypeIdx = 6;
                    //    objacountgj.GLIdx = acountmsid;
                    //    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    //    objacountgj.vendorIdx = timeline[0].vendorIdx;
                    //    objacountgj.invoiceNo = timeline[0].poNumber;
                    //    objacountgj.debit = Convert.ToDecimal(timeline[0].paidAmount);
                    //    objacountgj.credit = 0.00m;
                    //    objacountgj.coaIdx = 43;

                    //    objacountgj.createDate = DateTime.Now;
                    //    DBClass.db.accountGJs.Add(objacountgj);
                    //    DBClass.db.SaveChanges();
                    //    objacountgj = new accountGJ();
                    //    objacountgj.tranTypeIdx = 6;
                    //    objacountgj.GLIdx = acountmsid;
                    //    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    //    objacountgj.vendorIdx = timeline[0].vendorIdx;
                    //    objacountgj.invoiceNo = timeline[0].poNumber;
                    //    objacountgj.debit = 0.00m;
                    //    objacountgj.credit = Convert.ToDecimal(timeline[0].paidAmount);
                    //    objacountgj.coaIdx = 56;//ya phir 64
                    //    objacountgj.createDate = DateTime.Now;
                    //    DBClass.db.accountGJs.Add(objacountgj);
                    //    DBClass.db.SaveChanges();





                    //}
                    #endregion

                    //Inventory
                    txn.Complete();



                    return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                }
            }

            catch (Exception ex)
            {
                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            
           
        }

        public bool CheckProductInInventoryMaster(int productid)
        {
            try
            {
                var flag = DBClass.db.inventories.Where(x => x.productIdx == productid).ToList();
                if (flag.Count()>0)
                {
                    //means exist
                    return true;
                }
                else
                {//means not exist
                    return false;
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        #region Purchase Return

        public ActionResult PurchaseReturn()
        {
            if (Session["LoggedIn"] != null)
            {
                PurchaseReturn_Property objprrtrn = new PurchaseReturn_Property();
                objprrtrn.VendorLsit = DBClass.db.vendors.ToList().Select(p => new Vendor_Property
                {
                    idx = p.idx,
                    vendorName = p.vendorName
                }).ToList();
                objprrtrn.PurchaseLiit = DBClass.db.purchases.ToList().Select(p => new Purchase_Property
                {
                    idx = p.idx,
                    poNumber = p.poNumber
                }).ToList();

                //   DBClass.db.vendors.ToList();
                return View(objprrtrn);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }

        [HttpPost]

        public JsonResult SearchPurchases(PurchaseReturn_Property objprchse)
        {
            var purchasemaster = DBClass.db.purchases.Where(p => p.poNumber == objprchse.PRNumber).FirstOrDefault();
            var data = (from a in DBClass.db.pruchaseDetails
                        join B in DBClass.db.inventories on a.itemIdx equals B.productIdx
                        join C in DBClass.db.products on B.productIdx equals C.idx
                        where B.stock > 0 
                        select new 
                        {
                           productid=C.idx,
                           productname=C.itemName,
                           inventorystock=B.stock,
                           inventoryunitprice=B.unitPrice,
                           purchaseqty=a.qty,
                           purchaseunitprice=a.unitPrice,
                           purchasetotalamount=(a.unitPrice*a.qty),
                           purchaseid=a.purchaseIdx
                        }
                        ) .ToList();


            return Json(new {data=data }, JsonRequestBehavior.AllowGet);

        }

        #endregion


    }
}