using HrProperty.Models;
using SMSYSTEM.Models;
using System;
using System.Collections.Generic;
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
                                   select new { productType = sa.productType1, itemCode = s.itemCode, itemName = s.itemName, description = s.description, creationDate = s.creationDate };
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
                    ViewBag.ptlist = DBClass.db.productTypes.ToList();
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
                        DBClass.db.products.Add(objproduct);
                        DBClass.db.SaveChanges();
                        return Json(new { success = true, statuscode = 200, msg = "Added Successfully", url = "/Product/ViewProducts" }, JsonRequestBehavior.AllowGet);

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

        public ActionResult AddNewProductType()
        {
            if (Session["LoggedIn"] != null)
            {
                return PartialView("_AddNewProductType");
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
                if (!ModelState.IsValid)
                {//if valid

                    try
                    {
                        //Checking Database 
                        var producttype = DBClass.db.productTypes.Where(p => p.productType1 == objproducttype.productType).FirstOrDefault();
                        if (producttype != null)
                        {
                            return Json(new { success = true, statuscode = 409, msg = "ProductType Already Exist", url = "#" }, JsonRequestBehavior.AllowGet);

                        }
                        else
                        {
                            productType objProdctType = new productType()
                            {
                                productType1 = objproducttype.productType,
                                creationDate = DateTime.Now,
                                createdByUserIdx = Convert.ToInt32(Session["Useridx"].ToString())
                            };
                            DBClass.db.productTypes.Add(objProdctType);
                            DBClass.db.SaveChanges();
                            return Json(new { success = true, statuscode = 200, msg = "Added Successfully", url = "/Product/ViewProductType" }, JsonRequestBehavior.AllowGet);

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
    }
}