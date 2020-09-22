using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class SaleController : Controller
    {
        // GET: Purchase
        public ActionResult ViewSale()
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

        public ActionResult AddSale()
        {
            if (Session["LoggedIn"] != null)
            {
                SalesVm objSaleVM = new SalesVm();
                Product_Property objPrdct = new Product_Property();
                objSaleVM.CustomerLST = DBClass.db.customers.ToList().Select(p => new Customer_Property
                {
                    idx = p.idx,
                    customerName = p.customerName
                }).ToList();
                objSaleVM.ProductList = DBClass.db.products.ToList().Select(p => new Product_Property
                {
                    idx = p.idx,
                    itemName = p.itemName
                }).ToList();
                int lastPOid = Convert.ToInt16(DBClass.db.sales.OrderByDescending(x => x.idx).Select(x => x.idx).FirstOrDefault().ToString()) + 1;
                objSaleVM.soNumber = "SI-00" + lastPOid;
                //objPrchseVM.purchaseDate =DateTime.Now.ToString("YYYY-DD-MM");
                return PartialView("_AddSale", objSaleVM);
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
        public JsonResult ADDUpdate(List<SalesVm> timeline)
        {

            try
            {
                decimal unitpricesumcogs = 0.00m;
                //inventry COGS
                for (int i = 0; i < timeline.Count(); i++)
                {
                    var productid = timeline[i].itemIdx;
                    var inventorymaster = DBClass.db.inventories.Where(p => p.productIdx == productid).FirstOrDefault();
                    var cogsofproduct = timeline[i].qty * inventorymaster.unitPrice;
                    unitpricesumcogs = Convert.ToDecimal(cogsofproduct + unitpricesumcogs);


                }


                string pdamount = timeline[0].Paid.ToString();
                //DateTime newduedate = timeline[0].DueDate;
                int vndrid = timeline[0].customerIdx;
                //seprating data of PO Master and PO Details

                #region PO Master

                sale objPOMaster = new sale();
                objPOMaster.soNumber = timeline[0].soNumber;//timeline[0].poNumber;
                objPOMaster.customerIdx = timeline[0].customerIdx;
                // objPOMaster.purchaseTypeIdx = timeline[0].purchaseTypeIdx;
                objPOMaster.salesDate = DateTime.Now.ToString("yyyy-MM-dd");
                objPOMaster.description = timeline[0].description;
                objPOMaster.totalAmount = timeline.Sum(x => x.amount);
                objPOMaster.netAmount = objPOMaster.totalAmount;
                objPOMaster.Paid = timeline[0].Paid;
                //objPOMaster.paidDate = timeline[0].paidDate;
                //objPOMaster.tax = timeline[0].tax;
                if (objPOMaster.Paid > 0)
                {
                    objPOMaster.Balance = (objPOMaster.netAmount - objPOMaster.Paid).ToString();

                }
                else
                {
                    objPOMaster.Balance = objPOMaster.netAmount.ToString();
                }
                //objPOMaster.taxAount = timeline[0].taxAount;
                //objPOMaster.purchaseduedate = timeline[0].purchaseduedate;
                objPOMaster.creationDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                objPOMaster.createdByUserIdx = Convert.ToInt16(Session["Useridx"].ToString());
                objPOMaster.status = timeline[0].status;
                objPOMaster.visible = 1;
                DBClass.db.sales.Add(objPOMaster);
                DBClass.db.SaveChanges();

                int POMasterID = objPOMaster.idx;

                #endregion
                // objPOMaster.poNumber=
                //PO Detail
                #region POdetail
                List<Sale_Details_Property> saleDetailList = new List<Sale_Details_Property>();
                for (int i = 0; i < timeline.Count(); i++)
                {
                    salesDetail objSaleDetailList = new salesDetail();
                    objSaleDetailList.salesIdx = POMasterID;
                    // objSaleDetailList.productTypeIdx = POMasterID;
                    objSaleDetailList.serviceIdx = timeline[i].itemIdx;
                    objSaleDetailList.serviceQty = timeline[i].qty;
                    objSaleDetailList.serviceRate = timeline[i].unitPrice;
                    // objSaleDetailList.qty = timeline[i].qty;
                    objSaleDetailList.subAmount = timeline[i].qty * timeline[i].unitPrice;
                    objSaleDetailList.creationDate = DateTime.Now;
                    objSaleDetailList.createdByUserIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    objSaleDetailList.lastModificationDate = DateTime.Now.ToString();
                    objSaleDetailList.visible = 1;
                    // objSaleDetailList.DueDate = timeline[i].DueDate;



                    // saleDetailList.Add(objSaleDetailList); Commented Due To Conversion Error
                    DBClass.db.salesDetails.Add(objSaleDetailList);
                    DBClass.db.SaveChanges();

                    int purchasedtlid = objSaleDetailList.idx;
                    //////////////Purcahse details end

                    #region Inventory

                    //checking product id
                    if (CheckProductInInventoryMaster(timeline[i].itemIdx))
                    {
                        //exist
                        int itemidx = timeline[i].itemIdx;
                        var invmastrid = DBClass.db.inventories.Where(p => p.productIdx == itemidx).Select(p => p.idx).FirstOrDefault();
                        var currentStockInInventory = DBClass.db.inventories.Where(p => p.productIdx == itemidx).Select(p => p.stock).FirstOrDefault();
                        decimal remainingStock = Decimal.Parse(currentStockInInventory.ToString()) - timeline[i].qty;

                        if (timeline[i].qty > currentStockInInventory)
                        {
                            //Print Error and Roll Back Transaction
                        }

                        else
                        {
                            //update inventory
                            var updateInventory = DBClass.db.Database.ExecuteSqlCommand(@"Update Inventory Set stock=" + remainingStock + " where idx=" + invmastrid + " ");

                            inventory_logs objinvntrylogs = new inventory_logs();
                            objinvntrylogs.productIdx = timeline[i].itemIdx;
                            objinvntrylogs.stock = Convert.ToDecimal("-" + timeline[i].qty);
                            objinvntrylogs.unitPrice = timeline[i].unitPrice;
                            objinvntrylogs.totalAmount = timeline[i].qty * timeline[i].unitPrice;
                            objinvntrylogs.creationDate = DateTime.Now;
                            DBClass.db.inventory_logs.Add(objinvntrylogs);
                            DBClass.db.SaveChanges();
                        }
                        var purchsedtlid = DBClass.db.InventoryDetails.Where(p => p.InventoryIdx == invmastrid).Select(x => x.PurchaseDetailidx).ToArray();
                        var purchases = DBClass.db.pruchaseDetails.Where(p => !purchsedtlid.Contains(p.idx)).ToList();

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

                }
                #endregion

                //Accounts
                #region Account
                accountMasterGL objaccountmaster = new accountMasterGL();
                objaccountmaster.tranTypeIdx = 2;
                objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                objaccountmaster.customerIdx = timeline[0].customerIdx;
                objaccountmaster.invoiceNoIdx = timeline[0].soNumber;
                objaccountmaster.debit = timeline[0].totalAmount;//Should be total Amount
                objaccountmaster.credit = timeline[0].totalAmount;
                objaccountmaster.paidAmount = timeline[0].Paid;
                objaccountmaster.balance = Decimal.Parse(objPOMaster.Balance);
                // objaccountmaster.DueDate = timeline[i].purchaseduedate;
                objaccountmaster.isCredit = 1;
                objaccountmaster.createDate = DateTime.Now;
                objaccountmaster.visible = 1;
                DBClass.db.accountMasterGLs.Add(objaccountmaster);
                DBClass.db.SaveChanges();

                int acountmsid = objaccountmaster.idxx;

                accountGJ objacountgj = new accountGJ();
                objacountgj.tranTypeIdx = 2;
                objacountgj.GLIdx = acountmsid;
                objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                objacountgj.customerIdx = timeline[0].customerIdx;
                objacountgj.invoiceNo = timeline[0].soNumber;
                objacountgj.debit = 0.00m;
                objacountgj.credit = objPOMaster.netAmount;
                objacountgj.coaIdx = 54; //Sales 
                objacountgj.createDate = DateTime.Now;
                DBClass.db.accountGJs.Add(objacountgj);
                DBClass.db.SaveChanges();
                //credit entry for gj

                //inventory COGS

                objacountgj = new accountGJ();
                objacountgj.tranTypeIdx = 2;
                objacountgj.GLIdx = acountmsid;
                objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                objacountgj.customerIdx = timeline[0].customerIdx;
                objacountgj.invoiceNo = timeline[0].soNumber;
                objacountgj.debit = unitpricesumcogs;//Calculate the inventory Cost
                objacountgj.credit = 0.00m;
                objacountgj.coaIdx = 78;//COGS
                objacountgj.createDate = DateTime.Now;
                DBClass.db.accountGJs.Add(objacountgj);
                DBClass.db.SaveChanges();


                objacountgj = new accountGJ();
                objacountgj.tranTypeIdx = 2;
                objacountgj.GLIdx = acountmsid;
                objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                objacountgj.customerIdx = timeline[0].customerIdx;
                objacountgj.invoiceNo = timeline[0].soNumber;
                objacountgj.debit = objPOMaster.netAmount;//Net Amount To Be Received
                objacountgj.credit = 0.00m;
                objacountgj.coaIdx = 1;//Account Receiveable
                objacountgj.createDate = DateTime.Now;
                DBClass.db.accountGJs.Add(objacountgj);
                DBClass.db.SaveChanges();


                objacountgj = new accountGJ();
                objacountgj.tranTypeIdx = 2;
                objacountgj.GLIdx = acountmsid;
                objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                objacountgj.customerIdx = timeline[0].customerIdx;
                objacountgj.invoiceNo = timeline[0].soNumber;
                objacountgj.debit = 0.00m;
                objacountgj.credit = unitpricesumcogs;//Invntory Cost Calculate
                objacountgj.coaIdx = 60; //Inventory
                objacountgj.createDate = DateTime.Now;
                DBClass.db.accountGJs.Add(objacountgj);
                DBClass.db.SaveChanges();
                #endregion








                if (Convert.ToDecimal(pdamount) > 0)
                {
                    string pinvoice = timeline[0].soNumber;
                    var previousam = DBClass.db.accountMasterGLs.Where(p => p.invoiceNoIdx == pinvoice && p.isCredit == 1).ToList();
                    decimal? totalamount = previousam.Sum(x => x.debit);
                    totalamount = totalamount - Convert.ToDecimal(pdamount);
                    DBClass.db.Database.ExecuteSqlCommand("UPDATE accountMasterGL SET isCredit = {0} WHERE invoiceNoIdx = {1} ", 0, pinvoice);


                    objaccountmaster = new accountMasterGL();
                    objaccountmaster.tranTypeIdx = 2;
                    objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    objaccountmaster.vendorIdx = timeline[0].customerIdx;
                    objaccountmaster.invoiceNoIdx = timeline[0].soNumber;
                    objaccountmaster.debit = totalamount;
                    objaccountmaster.credit = totalamount;
                    //objaccountmaster.DueDate = newduedate;
                    objaccountmaster.isCredit = 1;
                    objaccountmaster.createDate = DateTime.Now;
                    DBClass.db.accountMasterGLs.Add(objaccountmaster);
                    DBClass.db.SaveChanges();

                    acountmsid = objaccountmaster.idxx;

                    objacountgj = new accountGJ();
                    objacountgj.tranTypeIdx = 2;
                    objacountgj.GLIdx = acountmsid;
                    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    objacountgj.vendorIdx = timeline[0].customerIdx;
                    objacountgj.invoiceNo = timeline[0].soNumber;
                    objacountgj.debit = totalamount;
                    objacountgj.credit = 0.00m;
                    objacountgj.coaIdx = 60;

                    objacountgj.createDate = DateTime.Now;
                    DBClass.db.accountGJs.Add(objacountgj);
                    DBClass.db.SaveChanges();
                    objacountgj = new accountGJ();
                    objacountgj.tranTypeIdx = 2;
                    objacountgj.GLIdx = acountmsid;
                    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                    objacountgj.vendorIdx = timeline[0].customerIdx;
                    objacountgj.invoiceNo = timeline[0].soNumber;
                    objacountgj.debit = 0.00m;
                    objacountgj.credit = totalamount;
                    objacountgj.coaIdx = 43;
                    objacountgj.createDate = DateTime.Now;
                    DBClass.db.accountGJs.Add(objacountgj);
                    DBClass.db.SaveChanges();
                }
                #endregion

                //Inventory




                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
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
                if (flag.Count() > 0)
                {
                    //means exist
                    return true;
                }
                else
                {//means not exist
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}