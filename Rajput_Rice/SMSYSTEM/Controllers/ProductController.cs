using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SMSYSTEM.Controllers
{
    public class ProductController : Controller
    {
        // GET: Product
        public ActionResult ViewProducts()
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
        public JsonResult ViewAllProducts()
        {
            if (Session["LoggedIn"] != null)
            {
                try
                {
                    var products = from s in DBClass.db.products
                                   join sa in DBClass.db.productTypes on s.productTypeIdx equals sa.idx
                                   where s.visible == 1
                                   select new { ID = s.idx, productType = sa.productType1, itemCode = s.itemCode, itemName = s.itemName, description = s.description, creationDate = s.creationDate };
                    //var products = DBClass.db.products.ToList();
                    return Json(new { data = products, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
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

        public ActionResult AddNewProduct(int? id)
        {
            if (Session["LoggedIn"] != null)
            {
                ProductVM objprdctvm = new ProductVM();

                if (id != null && id > 0)
                {
                    //ViewBag.ptlist = DBClass.db.productTypes.ToList();
                    ViewBag.ptlist = DBClass.db.productTypes.ToList();
                    objprdctvm = DBClass.db.products.Where(p => p.idx == id).Select(p => new ProductVM
                    {
                        idx = p.idx,
                        productTypeIdx = p.productTypeIdx,
                        itemCode = p.itemCode,
                        itemName = p.itemName,
                        unit = p.unit,
                        description = p.description

                    }).FirstOrDefault();

                    objprdctvm.Producttypelst = DBClass.db.productTypes.ToList().Select(p => new ProductType_Property
                    {
                        productType = p.productType1,
                        idx = p.idx
                    }).ToList();
                }
                else
                {
                    //ViewBag.ptlist = DBClass.db.productTypes.ToList();
                    // ProductVM objprdctvm = new ProductVM();
                    objprdctvm.Producttypelst = DBClass.db.productTypes.ToList().Select(p => new ProductType_Property
                    {
                        productType = p.productType1,
                        idx = p.idx
                    }).ToList();


                }




                return PartialView("_AddNewProduct", objprdctvm);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }
        [HttpPost]
        public JsonResult AddUpdate(ProductVM objproducttypeVm)
        {
            if (Session["LoggedIn"] != null)
            {
                if (ModelState.IsValid)
                {//if valid

                    try
                    {
                        //Checking Database 
                        //var producttype = DBClass.db.productTypes.Where(p => p.productType1 == objproducttype.productType).FirstOrDefault();
                        //if (producttype != null)
                        //{
                        //    return Json(new { success = true, statuscode = 409, msg = "ProductType Already Exist", url = "#" }, JsonRequestBehavior.AllowGet);

                        //}
                        //else
                        //{
                        product objProduct;
                        if (objproducttypeVm.idx > 0)
                        {
                            objProduct = DBClass.db.products.Where(x => x.idx == objproducttypeVm.idx).FirstOrDefault();

                            objProduct.productTypeIdx = objproducttypeVm.productTypeIdx;
                            objProduct.itemName = objproducttypeVm.itemName;
                            objProduct.itemCode = objproducttypeVm.itemCode;
                            objProduct.unit = objproducttypeVm.unit;
                            objProduct.description = objproducttypeVm.description;
                            objProduct.lastModificationDate = DateTime.Now.Date.ToString("yyyy-MM-dd");
                            objProduct.lastModifiedByUserIdx = Convert.ToInt32(Session["Useridx"].ToString());
                            objProduct.visible = 1;
                            using (var db = new RAJPUT_RICE_DBEntities())
                            {
                                //db.companyBanks.Add(objProduct);
                                //db.SaveChanges();
                                //db.companyBanks.Attach(objProduct);
                                db.Entry(objProduct).State = EntityState.Modified;
                                db.SaveChanges();
                            }
                            return Json(new { success = true, statuscode = 200, msg = "Updated Successfully", url = "/Product/ViewProducts" }, JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            product objproduct = new product()
                            {
                                productTypeIdx = objproducttypeVm.productTypeIdx,
                                itemName = objproducttypeVm.itemName,
                                itemCode = objproducttypeVm.itemCode,
                                unit = 1,
                                description = objproducttypeVm.description,
                                creationDate = DateTime.Now,
                                createdByUserIdx = Convert.ToInt32(Session["Useridx"].ToString()),
                                visible = 1
                            };
                            using (var db = new RAJPUT_RICE_DBEntities())
                            {
                                //db.companyBanks.Add(objProduct);
                                //db.SaveChanges();
                                //db.companyBanks.Attach(objProduct);
                                db.products.Add(objproduct);
                                db.SaveChanges();
                            }
                            return Json(new { success = true, statuscode = 200, msg = "Added Successfully", url = "/Product/ViewProducts" }, JsonRequestBehavior.AllowGet);
                        }



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


        public JsonResult DeleteProduct(int id)
        {
            try
            {
                if (Session["LoggedIn"] != null)
                {
                    product objProduct;
                    if (id > 0)
                    {
                        objProduct = DBClass.db.products.Where(x => x.idx == id).FirstOrDefault();
                        objProduct.visible = 0;
                        using (var db = new RAJPUT_RICE_DBEntities())
                        {
                            //db.companyBanks.Add(objProduct);
                            //db.SaveChanges();
                            //db.companyBanks.Attach(objProduct);
                            db.Entry(objProduct).State = EntityState.Modified;
                            db.SaveChanges();
                        }
                        return Json(new { success = true, statuscode = 200, msg = "Delete Successfully", url = "/CompanyBank/ViewCompanyBanks" }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, statuscode = 500, msg = "Error Occured", url = "/CompanyBank/ViewCompanyBanks" }, JsonRequestBehavior.AllowGet);
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




        //product types
        public ActionResult ViewProductType()
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

        public JsonResult ViewALLProductType()
        {
            if (Session["LoggedIn"] != null)
            {
                try
                {
                    var productstypes = DBClass.db.productTypes.ToList();
                    return Json(new { data = productstypes, success = true, statuscode = 200 }, JsonRequestBehavior.AllowGet);
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

        public ActionResult AddNewProductType(int? Id)
        {
            ProductType_Property _producttype = new ProductType_Property();
            if (Session["LoggedIn"] != null)
            {
                if (Id > 0)
                {
                    var prdcttype = DBClass.db.productTypes.Where(p => p.idx == Id).FirstOrDefault();
                    _producttype.idx = prdcttype.idx;
                    _producttype.productType = prdcttype.productType1;
                }
                return PartialView("_AddNewProductType", _producttype);
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }

        [HttpPost]
        public JsonResult AddProductType(ProductType_Property objproducttype)
        {
            if (Session["LoggedIn"] != null)
            {
                if (ModelState.IsValid)
                {//if valid

                    try
                    {
                        //Checking Database 


                        if (objproducttype.idx > 0)
                        {

                            productType data = DBClass.db.productTypes.Where(p => p.idx == objproducttype.idx).FirstOrDefault();

                            data.idx = objproducttype.idx;
                            data.productType1 = objproducttype.productType;
                            data.creationDate = objproducttype.creationDate;
                            data.createdByUserIdx = objproducttype.createdByUserIdx;
                            var producttype = DBClass.db.productTypes.Where(p => p.productType1 == data.productType1).FirstOrDefault();
                            if (producttype != null)
                            {
                                return Json(new { success = true, statuscode = 409, msg = "ProductType Already Exist", url = "#" }, JsonRequestBehavior.AllowGet);

                            }
                            else
                            {
                                DBClass.db.Entry(data).State = EntityState.Modified;
                                DBClass.db.SaveChanges();
                                return Json(new { success = true, statuscode = 200, msg = "Updated Successfully", url = "/Product/ViewProductType" }, JsonRequestBehavior.AllowGet);
                            }



                        }
                        else
                        {

                            productType objProdctType = new productType()
                            {
                                productType1 = objproducttype.productType,
                                creationDate = DateTime.Now,
                                createdByUserIdx = Convert.ToInt32(Session["Useridx"].ToString())
                            };
                            var producttype = DBClass.db.productTypes.Where(p => p.productType1 == objProdctType.productType1).FirstOrDefault();
                            if (producttype != null)
                            {
                                return Json(new { success = true, statuscode = 409, msg = "ProductType Already Exist", url = "#" }, JsonRequestBehavior.AllowGet);

                            }
                            else
                            {
                                DBClass.db.productTypes.Add(objProdctType);
                                DBClass.db.SaveChanges();
                                return Json(new { success = true, statuscode = 200, msg = "Added Successfully", url = "/Product/ViewProductType" }, JsonRequestBehavior.AllowGet);

                            }
                        }


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
        public JsonResult DeleteProductType(int id)
        {
            try
            {
                if (Session["LoggedIn"] != null)
                {
                    productType objProductType;
                    if (id > 0)
                    {
                        objProductType = DBClass.db.productTypes.Where(x => x.idx == id).FirstOrDefault();
                        List<product> productsOfThisDataType = DBClass.db.products.Where(x => x.productTypeIdx == id && x.visible == 1).ToList<product>();
                        if (productsOfThisDataType.Count > 0)
                        {
                            return Json(new { success = true, statuscode = 500, msg = "Products Exist For This Product Types !", url = "#" }, JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            using (var db = new RAJPUT_RICE_DBEntities())
                            {
                                //db.companyBanks.Add(objCompanyBank);
                                //db.SaveChanges();
                                //db.companyBanks.Attach(objCompanyBank);
                                var productType = new productType { idx = id };
                                db.Entry(productType).State = EntityState.Deleted;
                                db.SaveChanges();
                                //db.Entry(objProductType).Re = EntityState.Modified;
                                //db.SaveChanges();
                            }

                        }
                        return Json(new { success = true, statuscode = 200, msg = "Delete Successfully", url = "/Product/ViewProductType" }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, statuscode = 500, msg = "Error Occured", url = "/Product/ViewProductType" }, JsonRequestBehavior.AllowGet);
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