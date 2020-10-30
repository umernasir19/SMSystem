using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Configuration;
using System.Data;

namespace HrProperty
{
    public static class SessionManager
    {
        public struct CurrentUser
        {
            public static int? ID
            {
                get
                {
                    
                    if (HttpContext.Current.Session["ID"] != null)
                        return Int32.Parse(HttpContext.Current.Session["ID"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["ID"] = value;
                }
            }

            public static int? Code
            {
                get
                {
                    if (HttpContext.Current.Session["code"] != null)
                        return Int32.Parse(HttpContext.Current.Session["code"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["Code"] = value;
                }
            }

            public static int? DistributorID
            {
                get
                {
                    if (HttpContext.Current.Session["DistributorID"] != null)
                        return Int32.Parse(HttpContext.Current.Session["DistributorID"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["DistributorID"] = value;
                }
            }

            public static int? CompanyID
            {
                get
                {
                    if (HttpContext.Current.Session["CompanyID"] != null)
                        return Int32.Parse(HttpContext.Current.Session["CompanyID"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["CompanyID"] = value;
                }
            }

            public static string UserName
            {
                get
                {
                    if (HttpContext.Current.Session["UserName"] != null)
                        return HttpContext.Current.Session["UserName"].ToString();
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["UserName"] = value;
                }
            }

            public static string FirstName
            {
                get
                {
                    if (HttpContext.Current.Session["FirstName"] != null)
                        return HttpContext.Current.Session["FirstName"].ToString();
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["FirstName"] = value;
                }
            }

            public static string LastName
            {
                get
                {
                    if (HttpContext.Current.Session["LastName"] != null)
                        return HttpContext.Current.Session["LastName"].ToString();
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["LastName"] = value;
                }
            }

            public static string Email
            {
                get
                {
                    if (HttpContext.Current.Session["Email"] != null)
                        return HttpContext.Current.Session["Email"].ToString();
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["Email"] = value;
                }
            }
            public static List<string> RegionalLocations
            {
                get
                {
                    if (HttpContext.Current.Session["RegionalLocations"] != null)
                        return (HttpContext.Current.Session["RegionalLocations"] as List<string>);
                    else
                    {
                        //HttpContext.Current.Response.Redirect("/Account/Login");
                        return (null as List<string>);
                    }
                }
                set
                {
                    HttpContext.Current.Session["RegionalLocations"] = value;
                }
            }

            public static DataTable RegionalLocationsDT
            {
                get
                {
                    if (HttpContext.Current.Session["RegionalLocationsDT"] != null)
                        return (HttpContext.Current.Session["RegionalLocationsDT"] as DataTable);
                    else
                    {
                        //HttpContext.Current.Response.Redirect("/Account/Login");
                        return (null as DataTable);
                    }
                }
                set
                {
                    HttpContext.Current.Session["RegionalLocationsDT"] = value;
                }
            }
            public static bool IsRegionalUser
            {
                get
                {
                    if (HttpContext.Current.Session["IsRegionalUser"] != null)
                        return Convert.ToBoolean(HttpContext.Current.Session["IsRegionalUser"]);
                    else
                    {
                        //HttpContext.Current.Response.Redirect("/Account/Login");
                        return false;
                    }
                }
                set
                {
                    HttpContext.Current.Session["IsRegionalUser"] = value;
                }
            }
            public static string UserID
            {
                get
                {
                    if (HttpContext.Current.Session["UserID"] != null)
                        return HttpContext.Current.Session["UserID"].ToString();
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["UserID"] = value;
                }
            }
            public static string Password
            {
                get
                {
                    if (HttpContext.Current.Session["Password"] != null)
                        return HttpContext.Current.Session["Password"].ToString();
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["Password"] = value;
                }
            }

            public static int? Active
            {
                get
                {
                    if (HttpContext.Current.Session["Active"] != null)
                        return Int32.Parse(HttpContext.Current.Session["Active"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["Active"] = value;
                }
            }

            public static int? InsertBy
            {
                get
                {
                    if (HttpContext.Current.Session["InsertBy"] != null)
                        return Int32.Parse(HttpContext.Current.Session["InsertBy"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["InsertBy"] = value;
                }
            }

            public static DateTime? InsertionDate
            {
                get
                {
                    if (HttpContext.Current.Session["InsertionDate"] != null)
                        return Convert.ToDateTime(HttpContext.Current.Session["InsertionDate"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["InsertionDate"] = value;
                }
            }

            public static int? LocationID
            {
                get
                {
                    if (HttpContext.Current.Session["Location_Setup_ID"] != null)
                        return Int32.Parse(HttpContext.Current.Session["Location_Setup_ID"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["Location_Setup_ID"] = value;
                }
            }

            public static DateTime? FinancialDate
            {
                get
                {
                    if (HttpContext.Current.Session["FinancialDate"] != null)
                        return Convert.ToDateTime(HttpContext.Current.Session["FinancialDate"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["FinancialDate"] = value;
                }
            }

            public static string FinancialDay
            {
                get
                {
                    if (HttpContext.Current.Session["FinancialDay"] != null)
                        return HttpContext.Current.Session["FinancialDay"].ToString();
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["FinancialDay"] = value;
                }
            }

            public static int? FinancialDayNoOfWeek
            {
                get
                {
                    if (HttpContext.Current.Session["FinancialDayNoOfWeek"] != null)
                        return Convert.ToInt32(HttpContext.Current.Session["FinancialDayNoOfWeek"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["FinancialDayNoOfWeek"] = value;
                }
            }

            public static int? FinancialCalendarID
            {
                get
                {
                    if (HttpContext.Current.Session["FinancialCalendarID"] != null)
                        return Convert.ToInt32(HttpContext.Current.Session["FinancialCalendarID"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["FinancialCalendarID"] = value;
                }
            }

            public static int? EmployeeID
            {
                get
                {

                    if (HttpContext.Current.Session["EmployeeID"] != null)
                        return Int32.Parse(HttpContext.Current.Session["EmployeeID"].ToString());
                    else
                    {
                        HttpContext.Current.Response.Redirect("/Account/Login");
                        return null;
                    }
                }
                set
                {
                    HttpContext.Current.Session["EmployeeID"] = value;
                }
            }
        }
    }
}
