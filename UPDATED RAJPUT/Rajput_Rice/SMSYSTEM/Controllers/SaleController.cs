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


    internal class tempResult
    {

        public int? productid { get; set; }
        public string productname { get; set; }
        public decimal? inventoryunitprice { get; set; }
        public decimal salesRate { get; set; }
        public int saleId { get; set; }
        public decimal saleTotalAmount { get; set; }
        public decimal saleQty { get; set; }
        public decimal inventorystock { get; set; }
        public int dtlid { get; set; }

    }
    internal class ModaltempResult
    {
        public int? salesmasterid { get; set; }
        public string sonumber { get; set; }
        public int? saledtlid { get; set; }
        public decimal saleqty { get; set; }
        public decimal salerate { get; set; }

        public decimal balance { get; set; }
        public decimal paidamount { get; set; }

    }
    public class SaleController : Controller
    {
        string coaIdx;
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
        public JsonResult ViewAllSales()
        {
            if (Session["LoggedIn"] != null)
            {
                try
                {
                    var purchases = from s in DBClass.db.sales
                                    join sa in DBClass.db.customers on s.customerIdx equals sa.idx
                                    where s.visible == 1
                                    select new { soNumber = s.soNumber, customerName = sa.customerName, salesDate = s.salesDate, netAmount = s.netAmount, description = s.description };
                    //var products = DBClass.db.products.ToList();
                    return Json(new { data = purchases, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
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
                objSaleVM.paymentModesLST = DBClass.db.paymentModes.ToList().Select(p => new PaymentMode_Property
                {
                    idx = p.idx,
                    paymentMode = p.paymentMode1
                }).ToList();

                var bnklist = (from e in DBClass.db.companyBanks
                               join d in DBClass.db.banks on e.bankIdx equals d.idx
                               select new
                               {
                                   bankIdx = e.idx,
                                   bankName = d.bankName


                               }).ToList();
                ViewBag.bnklst = bnklist;
                //ye viewbag waha call krwalo model ki jaga dropdown ma hogya..
                int lastPOid = Convert.ToInt16(DBClass.db.sales.OrderByDescending(x => x.idx).Select(x => x.idx).FirstOrDefault().ToString()) + 1;
                objSaleVM.soNumber = "SI-00" + lastPOid;
                //objsaleVM.purchaseDate =DateTime.Now.ToString("YYYY-DD-MM");
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
                objPOMaster.paymentModeIdx = timeline[0].paymentModeIdx;
                objPOMaster.bankIdx = timeline[0].bankIdx;
                objPOMaster.chequeNumber = timeline[0].chequeNumber;
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
                    var inventorymaster = DBClass.db.inventories.Where(p => p.productIdx == objSaleDetailList.serviceIdx).FirstOrDefault();
                    objSaleDetailList.unitPrice = inventorymaster.unitPrice;
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
                            objinvntrylogs.TransactionTypeID = 2;
                            objinvntrylogs.MasterID = POMasterID;
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
                        objinvntrylogs.TransactionTypeID = 2;
                        objinvntrylogs.MasterID = POMasterID;
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
                objaccountmaster.paymentModeIdx = timeline[0].paymentModeIdx;
                objaccountmaster.bankIdx = timeline[0].bankIdx;
                objaccountmaster.chequeNumber = timeline[0].chequeNumber;

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


                #region forFullPaidSales
                if (objPOMaster.Paid == objPOMaster.netAmount)
                {
                    string sinvoice = timeline[0].soNumber;
                    int glId = acountmsid;
                    var sales = DBClass.db.Database.ExecuteSqlCommand(@"Update sales set Paid=" + objPOMaster.Paid + ",Balance=0,isPaid=1 where idx=" + POMasterID + "");//update Sale
                    var glUpdate = DBClass.db.Database.ExecuteSqlCommand(@"update accountMasterGL set isCredit=0,paidAmount=" + objPOMaster.Paid + ",balance=" + objPOMaster.Balance + " where idxx=" + glId + "");

                    if (objPOMaster.paymentModeIdx == 1)
                    {
                        coaIdx = "56";//for cash
                    }
                    else if (objPOMaster.paymentModeIdx == 2 || objPOMaster.paymentModeIdx == 3)
                    {
                        coaIdx = "64";
                    }
                    var gjUpdate = DBClass.db.Database.ExecuteSqlCommand(@"update accountGJ set coaIdx=" + coaIdx + " where GLIdx=" + glId + " and coaIdx=1");
                }
                #endregion


                #region forUnpaidSales(Partial Paid Inclusive)
                decimal NetAmount = decimal.Parse(objPOMaster.netAmount.ToString());
                decimal balance = decimal.Parse(objPOMaster.Balance.ToString());
                decimal paid = decimal.Parse(objPOMaster.Paid.ToString());
                decimal result = NetAmount - balance;
                if (result >= 0)
                {
                    if (decimal.Parse(objPOMaster.Balance) == objPOMaster.netAmount)
                    {
                        //Don't Update As A General Entry Is For Full Unpaid Sales
                    }
                    else
                    {
                        string sinvoice = timeline[0].soNumber;
                        int glId = acountmsid;
                        var sales = DBClass.db.Database.ExecuteSqlCommand(@"Update sales set Paid=" + objPOMaster.Paid + ",Balance=" + objPOMaster.Balance + ",isPaid=0 where idx=" + POMasterID + "");//update Sale
                        var glUpdate = DBClass.db.Database.ExecuteSqlCommand(@"update accountMasterGL set paidAmount=" + objPOMaster.Paid + ",balance=" + objPOMaster.Balance + " where idxx=" + glId + "");

                        var gjUpdate = DBClass.db.Database.ExecuteSqlCommand(@"update accountGJ set debit=" + objPOMaster.Balance + " where GLIdx=" + glId + " and coaIdx=1");
                        if (objPOMaster.paymentModeIdx == 1)
                        {
                            coaIdx = "56";//for cash
                        }
                        else if (objPOMaster.paymentModeIdx == 2 || objPOMaster.paymentModeIdx == 3)
                        {
                            if (objPOMaster.paymentModeIdx == 2)
                            {
                                //cheque ka scenenrio 
                            }
                            else
                            {
                                coaIdx = "64";
                            }

                        }
                        objacountgj = new accountGJ();
                        objacountgj.tranTypeIdx = 2;
                        objacountgj.GLIdx = glId;
                        objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objacountgj.customerIdx = timeline[0].customerIdx;
                        objacountgj.invoiceNo = timeline[0].soNumber;
                        objacountgj.debit = objPOMaster.Paid;//Net Amount To Be Received
                        objacountgj.credit = 0.00m;
                        objacountgj.coaIdx = int.Parse(coaIdx);//Cash OR Bank
                        objacountgj.createDate = DateTime.Now;
                        DBClass.db.accountGJs.Add(objacountgj);
                        DBClass.db.SaveChanges();

                    }
                }
                #endregion





                //if (Convert.ToDecimal(pdamount) > 0)
                //{
                //    string pinvoice = timeline[0].soNumber;
                //    var previousam = DBClass.db.accountMasterGLs.Where(p => p.invoiceNoIdx == pinvoice && p.isCredit == 1).ToList();
                //    decimal? totalamount = previousam.Sum(x => x.debit);
                //    totalamount = totalamount - Convert.ToDecimal(pdamount);
                //    DBClass.db.Database.ExecuteSqlCommand("UPDATE accountMasterGL SET isCredit = {0} WHERE invoiceNoIdx = {1} ", 0, pinvoice);


                //    objaccountmaster = new accountMasterGL();
                //    objaccountmaster.tranTypeIdx = 2;
                //    objaccountmaster.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                //    objaccountmaster.vendorIdx = timeline[0].customerIdx;
                //    objaccountmaster.invoiceNoIdx = timeline[0].soNumber;
                //    objaccountmaster.debit = totalamount;
                //    objaccountmaster.credit = totalamount;
                //    //objaccountmaster.DueDate = newduedate;
                //    objaccountmaster.isCredit = 1;
                //    objaccountmaster.createDate = DateTime.Now;
                //    DBClass.db.accountMasterGLs.Add(objaccountmaster);
                //    DBClass.db.SaveChanges();

                //    acountmsid = objaccountmaster.idxx;

                //    objacountgj = new accountGJ();
                //    objacountgj.tranTypeIdx = 2;
                //    objacountgj.GLIdx = acountmsid;
                //    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                //    objacountgj.vendorIdx = timeline[0].customerIdx;
                //    objacountgj.invoiceNo = timeline[0].soNumber;
                //    objacountgj.debit = totalamount;
                //    objacountgj.credit = 0.00m;
                //    objacountgj.coaIdx = 60;

                //    objacountgj.createDate = DateTime.Now;
                //    DBClass.db.accountGJs.Add(objacountgj);
                //    DBClass.db.SaveChanges();
                //    objacountgj = new accountGJ();
                //    objacountgj.tranTypeIdx = 2;
                //    objacountgj.GLIdx = acountmsid;
                //    objacountgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                //    objacountgj.vendorIdx = timeline[0].customerIdx;
                //    objacountgj.invoiceNo = timeline[0].soNumber;
                //    objacountgj.debit = 0.00m;
                //    objacountgj.credit = totalamount;
                //    objacountgj.coaIdx = 43;
                //    objacountgj.createDate = DateTime.Now;
                //    DBClass.db.accountGJs.Add(objacountgj);
                //    DBClass.db.SaveChanges();
                //}
                #endregion

                //Inventory




                return Json(new { success = true, Url = "/Sale/ViewSale" }, JsonRequestBehavior.AllowGet);
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
        #region Check Inventory Stock of Product
        public JsonResult CheckInvStock(int id)
        {
            using (var db = new RAJPUT_RICE_DBEntities())

            {
                var data = db.inventories.Where(p => p.productIdx == id).FirstOrDefault();
                return Json(new { data = data }, JsonRequestBehavior.AllowGet);
            }


        }
        #endregion


        #region Sales Return

        public ActionResult SalesReturn()
        {
            if (Session["LoggedIn"] != null)
            {
                SalesReturn_Property objprrtrn = new SalesReturn_Property();
                //List<Sale_Property> saleslist = new List<Sale_Property>();
                //Sale_Property objSale_Property;
                //var data = DBClass.db.sales.Where(p => p.visible == 1).ToList();
                //for(int i = 0; i < data.Count; i++)
                //{
                //    objSale_Property = new Sale_Property();
                //    objSale_Property.soNumber = data[i].soNumber;
                //    saleslist.Add(objSale_Property);
                //}
                //objprrtrn.SaleLiit = saleslist;
                //    DBClass.db.customers.ToList().Select(p => new Customer_Property
                //{
                //    idx = p.idx,
                //    customerName = p.customerName
                //}).ToList();
                objprrtrn.SalesLiSt
                    = DBClass.db.sales.ToList().Select(p => new Sale_Property
                    {
                        idx = p.idx,
                        soNumber = p.soNumber
                    }).ToList();
                //objprrtrn.saledtlid= DBClass.db.salesDetails.ToList().Select(p => new Sale_Details_Property
                //    {
                //        idx = p.idx,
                //        salesIdx =p.salesIdx
                //    }).ToList();
                //   DBClass.db.vendors.ToList();
                return View(objprrtrn);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }

        [HttpPost]
        public JsonResult SearchSales(SalesReturn_Property objsale)
        {
            using (var db = new RAJPUT_RICE_DBEntities())
            {


                int salesMasterId = Convert.ToInt16(objsale.SaleInvoiceNumber.ToString());
                var salesMaster = db.sales.Where(p => p.idx == salesMasterId).FirstOrDefault();
                var saleDTCount = db.salesDetails.Where(p => p.salesIdx == salesMasterId).Count();
                var purchasemaster = DBClass.db.sales.Where(p => p.idx == salesMasterId).FirstOrDefault();

                var tempResults = DBClass.db.Database.SqlQuery<tempResult>(@"select sd.idx as dtlid,inv.stock as inventorystock,pr.idx as productid,pr.itemName as productname,sd.unitPrice as inventoryunitprice,sd.serviceRate as salesRate,sd.salesIdx as saleId,(sd.serviceRate * (select ABS(SUM(stock)) from inventory_logs where MasterID=sd.salesIdx and (TransactionTypeID=2 or TransactionTypeID=17) and productIdx=pr.idx )) as saleTotalAmount,(select ABS(SUM(stock)) from inventory_logs where MasterID=sd.salesIdx and (TransactionTypeID=2 or TransactionTypeID=17) and productIdx=pr.idx ) as saleQty from salesDetails sd
inner join inventory inv on sd.serviceIdx=inv.productIdx
inner join products pr on pr.idx = inv.productIdx
where inv.stock>0 and sd.salesIdx=" + salesMasterId + "").ToList();



                var data = tempResults.Select(t => new
                {
                    productid = t.productid,
                    productname = t.productname,
                    inventorystock = t.inventorystock,
                    inventoryunitprice = t.inventoryunitprice,
                    saleQty = t.saleQty,
                    salesRate = t.salesRate,
                    saleTotalAmount = t.saleTotalAmount,
                    saleId = t.saleId,

                    dtlid = t.dtlid

                }).ToList();

                //int saleqty = 0;
                //var invlogsdata = DBClass.db.inventory_logs.Where(P => P.MasterID == salesMaster.idx && P.TransactionTypeID == 17)
                //.GroupBy(o => o.MasterID)
                //   .Select(g => new { membername = g.Key, updatedquantity = g.Sum(i => i.stock) }).ToList();
                //// var invloggs = DBClass.db.inventory_logs.Where(p => p.TransactionTypeID == purchasemasterid).FirstOrDefault();
                //if (invlogsdata == null)
                //{
                //    saleqty = 0;
                //}
                //else
                //{


                //    saleqty = Convert.ToInt32(invlogsdata[0].updatedquantity);
                //}



                //var data = (from a in db.salesDetails
                //            join B in db.inventories on a.serviceIdx equals B.productIdx
                //            join C in db.products on B.productIdx equals C.idx
                //            where B.stock > 0 && a.salesIdx == salesMaster.idx
                //            select new
                //            {
                //                productid = C.idx,
                //                productname = C.itemName,
                //                inventorystock = B.stock,
                //                inventoryunitprice = a.unitPrice,
                //                saleQty = a.serviceQty - saleqty,
                //                salesRate = a.serviceRate,
                //                saleTotalAmount = (a.serviceRate * a.serviceQty),
                //                saleId = a.salesIdx,

                //                dtlid = a.idx
                //            }
                //            ).ToList();


                return Json(new { data = data }, JsonRequestBehavior.AllowGet);
            }

        }

        public JsonResult CheckInverntoryforProductStock(int id)
        {

            using (var txn = new TransactionScope())
            {
                //var data = (from a in DBClass.db.sales
                //            join b in DBClass.db.salesDetails on a.idx equals b.salesIdx
                //            join c in DBClass.db.accountMasterGLs on a.soNumber equals c.invoiceNoIdx
                //            join d in DBClass.db.accountGJs on c.idxx equals d.GLIdx
                //            join e in DBClass.db.inventories on b.serviceIdx equals e.productIdx
                //            //join c in DBClass.db.sales on a.salesIdx equals c.idx
                //            //join b in DBClass.db.inventories on a.serviceIdx equals b.productIdx
                //            //join d in DBClass.db.accountMasterGLs on a. equals d.
                //            where b.idx == id && c.invoiceNoIdx == a.soNumber
                //            select new
                //            {
                //                salesmasterid = a.idx,
                //                sonumber = a.soNumber,
                //                saledtlid = b.idx,
                //                saleqty = b.serviceQty,
                //                salerate = b.serviceRate,
                //                balance = c.balance,
                //                paidamount = c.paidAmount
                //            }).ToList();

                var tempResults = DBClass.db.Database.SqlQuery<ModaltempResult>(@"select top 1 gl.paidAmount as paidamount,gl.balance ,sl.soNumber as sonumber,sd.idx as saledtlid,inv.stock as inventorystock,pr.idx as productid,pr.itemName as productname,sd.unitPrice as inventoryunitprice,sd.serviceRate as saleRate,sd.salesIdx as salesmasterid,(sd.serviceRate * (select ABS(SUM(stock)) from inventory_logs where MasterID=sd.salesIdx and (TransactionTypeID=2 or TransactionTypeID=17) and productIdx=pr.idx )) as saleTotalAmount,(select ABS(SUM(stock)) from inventory_logs where MasterID=sd.salesIdx and (TransactionTypeID=2 or TransactionTypeID=17) and productIdx=pr.idx ) as saleqty from sales sl
inner join salesDetails sd on sl.idx=sd.salesIdx
inner join inventory inv on sd.serviceIdx=inv.productIdx
inner join products pr on pr.idx = inv.productIdx
inner join accountMasterGL gl  on sl.soNumber=gl.invoiceNoIdx
where  sd.idx={0} and gl.invoiceNoIdx=sl.soNumber
order by gl.createDate asc
", id).ToList();



                var data = tempResults.Select(t => new
                {
                    salesmasterid = t.salesmasterid,
                    sonumber = t.sonumber,
                    saledtlid = t.saledtlid,
                    saleqty = t.saleqty,
                    salerate = t.salerate,
                    balance = t.balance,
                    paidamount = t.paidamount

                }).ToList();
                return Json(new { data = data }, JsonRequestBehavior.AllowGet);
            }



        }


        [HttpPost]
        public JsonResult ReturnSale(SalesReturn_Property objsale)
        {

            using (var db = new RAJPUT_RICE_DBEntities())
            {
                using (var txn = new TransactionScope())
                {

                    decimal returnamount = objsale.returnqty * objsale.Salerate;
                    var saleDtl = db.salesDetails.Where(p => p.idx == objsale.SaleDetailsID).FirstOrDefault();
                    var salesMaster = db.sales.Where(p => p.idx == saleDtl.salesIdx).FirstOrDefault();
                    var acountmaster = db.accountMasterGLs.Where(p => p.invoiceNoIdx == salesMaster.soNumber && p.tranTypeIdx == 2 && p.visible == 1).FirstOrDefault();
                    var acountdtl = db.accountGJs.Where(p => p.GLIdx == acountmaster.idxx).ToList();
                    var invntrymstr = db.inventories.Where(p => p.productIdx == saleDtl.serviceIdx).FirstOrDefault();

                    //new logic of Sales ereturn
                    if (acountmaster.paidAmount == 0 && acountmaster.balance == 0)
                    {
                        Response.Write("Sales had been fully returned");
                    }
                    else
                    {
                        #region INVLogs
                        inventory_logs objinvntrylog = new inventory_logs();
                        objinvntrylog.TransactionTypeID = 17;//Sales Return
                        objinvntrylog.MasterID = salesMaster.idx;
                        objinvntrylog.productIdx = saleDtl.serviceIdx;
                        objinvntrylog.stock = objsale.returnqty * 1;
                        objinvntrylog.unitPrice = saleDtl.unitPrice;
                        objinvntrylog.totalAmount = saleDtl.unitPrice * objinvntrylog.stock;
                        objinvntrylog.creationDate = DateTime.Now;
                        db.inventory_logs.Add(objinvntrylog);
                        db.SaveChanges();
                        #endregion

                        #region Account Entries
                        accountMasterGL objaccounthead = new accountMasterGL();
                        objaccounthead.tranTypeIdx = 17;//Sales Return
                        objaccounthead.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objaccounthead.customerIdx = acountmaster.customerIdx;
                        objaccounthead.invoiceNoIdx = acountmaster.invoiceNoIdx;
                        objaccounthead.debit = saleDtl.serviceRate * objsale.returnqty;
                        objaccounthead.credit = saleDtl.serviceRate * objsale.returnqty;
                        objaccounthead.createDate = DateTime.Now;
                        objaccounthead.paidAmount = saleDtl.serviceRate * objsale.returnqty;
                        objaccounthead.balance = acountmaster.balance - objaccounthead.paidAmount;
                        db.accountMasterGLs.Add(objaccounthead);
                        db.SaveChanges();
                        int acntmsterid = objaccounthead.idxx;
                        //saleReturn Entry
                        accountGJ objgj = new accountGJ();
                        objgj.GLIdx = acntmsterid;
                        objgj.tranTypeIdx = 17;
                        objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objgj.customerIdx = acountmaster.customerIdx;
                        objgj.createDate = DateTime.Now;
                        objgj.coaIdx = 79;//SALES RETURN
                        objgj.credit = 0.00m;
                        objgj.debit = objaccounthead.debit;
                        db.accountGJs.Add(objgj);
                        db.SaveChanges();
                        //Inventory Increase

                        objgj = new accountGJ();
                        objgj.GLIdx = acntmsterid;
                        objgj.tranTypeIdx = 17;
                        objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objgj.customerIdx = acountmaster.customerIdx;
                        objgj.createDate = DateTime.Now;
                        objgj.coaIdx = 60;//INV
                        objgj.credit = 0.00m;
                        objgj.debit = saleDtl.unitPrice * objsale.returnqty;
                        db.accountGJs.Add(objgj);
                        db.SaveChanges();
                        //COGS
                        objgj = new accountGJ();
                        objgj.GLIdx = acntmsterid;
                        objgj.tranTypeIdx = 17;
                        objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                        objgj.customerIdx = acountmaster.customerIdx;
                        objgj.createDate = DateTime.Now;
                        objgj.coaIdx = 78;//COGS
                        objgj.debit = 0.00m;
                        objgj.credit = saleDtl.unitPrice * objsale.returnqty;
                        db.accountGJs.Add(objgj);
                        db.SaveChanges();



                        //detail entries
                        //case 1 rtrnamnt>blnce ... Cash will be recieved from vendor
                        if (returnamount > acountmaster.balance && acountmaster.balance != 0)
                        {
                            //liability acoount payable will be debit 
                            //inventory  debit
                            // cash credit
                            //cash crdit
                            decimal returnDue = returnamount - decimal.Parse(acountmaster.balance.ToString());
                            objgj = new accountGJ();
                            objgj.GLIdx = acntmsterid;
                            objgj.tranTypeIdx = 17;
                            objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objgj.customerIdx = acountmaster.customerIdx;
                            objgj.createDate = DateTime.Now;
                            objgj.coaIdx = 1;
                            objgj.credit = decimal.Parse(acountmaster.balance.ToString());
                            objgj.debit = 0.00m;
                            db.accountGJs.Add(objgj);
                            db.SaveChanges();
                            objgj = new accountGJ();
                            objgj.GLIdx = acntmsterid;
                            objgj.tranTypeIdx = 17;
                            objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objgj.customerIdx = acountmaster.customerIdx;
                            objgj.createDate = DateTime.Now;
                            objgj.coaIdx = 56; //cash bank cheque
                            objgj.credit = returnDue;
                            objgj.debit = 0.00m;
                            db.accountGJs.Add(objgj);
                            db.SaveChanges();

                            db.Database.ExecuteSqlCommand("update accountMasterGL set paidAmount={0},balance={1},isCredit={2} where idxx={3}", acountmaster.paidAmount - returnDue, 0.00m, 0, acountmaster.idxx);
                            db.Database.ExecuteSqlCommand("update sales set paid={0},balance={1},isPaid={2} where idx={3}", acountmaster.paidAmount - returnDue, 0.00m, 1, salesMaster.idx);

                        }
                        else if (returnamount <= acountmaster.balance && acountmaster.balance != 0)
                        {
                            decimal returnDue = decimal.Parse(acountmaster.balance.ToString()) - returnamount;//if O then Update sale to be Paid
                            objgj = new accountGJ();
                            objgj.GLIdx = acntmsterid;
                            objgj.tranTypeIdx = 17;
                            objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objgj.customerIdx = acountmaster.customerIdx;
                            objgj.createDate = DateTime.Now;
                            objgj.coaIdx = 1;
                            objgj.credit = decimal.Parse(returnamount.ToString());
                            objgj.debit = 0.00m;
                            db.accountGJs.Add(objgj);
                            db.SaveChanges();
                            //objgj = new accountGJ();
                            //objgj.GLIdx = acntmsterid;
                            //objgj.tranTypeIdx = 17;
                            //objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            //objgj.customerIdx = acountmaster.customerIdx;
                            //objgj.createDate = DateTime.Now;
                            //objgj.coaIdx = 56; //cash bank cheque
                            //objgj.credit = returnDue;
                            //objgj.debit = 0.00m;
                            // db.accountGJs.Add(objgj);
                            // db.SaveChanges();
                            if (returnDue > 0)
                            {
                                db.Database.ExecuteSqlCommand("update accountMasterGL set balance={0},isCredit={1} where idxx={2}", returnDue, 1, acountmaster.idxx);
                                db.Database.ExecuteSqlCommand("update sales set balance={0},isPaid={1} where idx={2}", returnDue, 0, salesMaster.idx);
                            }
                            else
                            {
                                db.Database.ExecuteSqlCommand("update accountMasterGL set balance={0},isCredit={1} where idxx={2}", returnDue, 0, acountmaster.idxx);
                                db.Database.ExecuteSqlCommand("update sales set balance={0},isPaid={1} where idx={2}", 0.00m, 1, salesMaster.idx);
                            }

                        }


                        else if (acountmaster.balance == 0.00m)
                        {
                            decimal returnDue = decimal.Parse(acountmaster.paidAmount.ToString()) - returnamount;
                            objgj = new accountGJ();
                            objgj.GLIdx = acntmsterid;
                            objgj.tranTypeIdx = 17;
                            objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objgj.customerIdx = acountmaster.customerIdx;
                            objgj.createDate = DateTime.Now;
                            objgj.coaIdx = 56; //cash or bank or cheque
                            objgj.credit = decimal.Parse(returnamount.ToString());
                            objgj.debit = 0.00m;
                            db.accountGJs.Add(objgj);
                            db.SaveChanges();
                            //objgj = new accountGJ();
                            //objgj.GLIdx = acntmsterid;
                            //objgj.tranTypeIdx = 17;
                            //objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            //objgj.customerIdx = acountmaster.customerIdx;
                            //objgj.createDate = DateTime.Now;
                            //objgj.coaIdx = 56; //cash bank cheque
                            //objgj.credit = returnDue;
                            //objgj.debit = 0.00m;
                            // db.accountGJs.Add(objgj);
                            // db.SaveChanges();
                            if (returnDue > 0)
                            {
                                db.Database.ExecuteSqlCommand("update accountMasterGL set paidAmount={0},isCredit={1} where idxx={2}", returnDue, 0, acountmaster.idxx);
                                db.Database.ExecuteSqlCommand("update sales set Paid={0},isPaid={1} where idx={2}", returnDue, 1, salesMaster.idx);
                            }
                            else
                            {
                                db.Database.ExecuteSqlCommand("update accountMasterGL set paidAmount={0},isCredit={1} where idxx={2}", returnDue, 0, acountmaster.idxx);
                                db.Database.ExecuteSqlCommand("update sales set Paid={0},isPaid={1} where idx={2}", returnDue, 1, salesMaster.idx);
                            }

                        }
                        else
                        {
                            objgj = new accountGJ();
                            objgj.GLIdx = acntmsterid;
                            objgj.tranTypeIdx = 16;
                            objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objgj.vendorIdx = acountmaster.vendorIdx;
                            objgj.createDate = DateTime.Now;
                            objgj.coaIdx = 43;
                            objgj.debit = 0.00m;
                            objgj.credit = acountmaster.balance - returnamount;
                            db.accountGJs.Add(objgj);
                            db.SaveChanges();

                            // inventory debit
                            objgj = new accountGJ();
                            objgj.GLIdx = acntmsterid;
                            objgj.tranTypeIdx = 16;
                            objgj.userIdx = Convert.ToInt16(Session["Useridx"].ToString());
                            objgj.vendorIdx = acountmaster.vendorIdx;
                            objgj.createDate = DateTime.Now;
                            objgj.coaIdx = 60;
                            objgj.debit = returnamount;
                            objgj.credit = 0.00m;
                            db.accountGJs.Add(objgj);
                            db.SaveChanges();
                        }



                        #endregion

                        // //for inventry
                        var newstock = invntrymstr.stock + objsale.returnqty;
                        var purchsedtlunitprcsum = Convert.ToDecimal(db.inventories.Where(p => p.productIdx == saleDtl.serviceIdx).Sum(p => p.unitPrice).Value.ToString());
                        //var newunitprice = (saleDtl.unitPrice + purchsedtlunitprcsum) / 2;
                        db.Database.ExecuteSqlCommand("update inventory set stock={0},totalAmount={1} where idx={2}", newstock, newstock * purchsedtlunitprcsum, invntrymstr.idx);





                        //code when previous update logic 

                        // int newqty = objsale.Purchaseqty - objsale.returnqty;
                        // decimal newamnt =Convert.ToDecimal(newqty * saleDtl.unitPrice);
                        // decimal newntamnt = Convert.ToDecimal( salesMaster.netAmount - (objsale.returnqty* saleDtl.unitPrice));
                        // decimal acntblnce = Convert.ToDecimal(acountmaster.balance - (objsale.returnqty * saleDtl.unitPrice));
                        //  db.Database.ExecuteSqlCommand("update pruchaseDetails set qty={0},amount={1} where idx={2}", newqty, newamnt, saleDtl.idx);
                        //  db.Database.ExecuteSqlCommand("update purchase set totalAmount={0},netAmount={1} where idx={1}", newamnt, newntamnt, salesMaster.idx);
                        ////  db.Database.ExecuteSqlCommand("update accountMasterGL set debit={0},credit={1},balance={2} where idx={1}", newamnt, newamnt, acntblnce, acountmaster.idxx);
                        // for(int i = 0; i < acountdtl.Count(); i++)
                        // {
                        //     if (acountdtl[i].debit > 0)
                        //     {
                        //          db.Database.ExecuteSqlCommand("update accountGJ set debit={0} where idx={1}", newamnt, acountdtl[i].idx);

                        //     }
                        //     if (acountdtl[i].credit > 0)
                        //     {
                        //          db.Database.ExecuteSqlCommand("update accountGJ set credit={0} where idx={1}", newamnt, acountdtl[i].idx);

                        //     }

                        // }
                        // //for inventry
                        // var newstock=invntrymstr.stock-objsale.returnqty;
                        // var purchsedtlunitprcsum =Convert.ToDecimal( db.pruchaseDetails.Where(p => p.itemIdx == saleDtl.itemIdx).Sum(p => p.unitPrice).Value.ToString());
                        // var newunitprice = (invntrymstr.unitPrice + purchsedtlunitprcsum) / 2;
                        //  db.Database.ExecuteSqlCommand("update inventory set stock={0},unitPrice={1},totalAmount={2} where idx={3}", newstock, newunitprice, newstock*newunitprice, invntrymstr.idx);

                        txn.Complete();

                    }
                }
            }
            return Json(new { data = "" }, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}