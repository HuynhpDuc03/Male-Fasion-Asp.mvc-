using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MaleFashion.Models;

namespace MaleFashion.Areas.PrivatePages.Controllers
{
    public class NewArticlesController : Controller
    {
        public ActionResult SaveData(string originalValue)
        {
            string encodedValue = System.Web.HttpUtility.HtmlEncode(originalValue);

            // Lưu trữ encodedValue vào cơ sở dữ liệu

            return View();
        }
        // GET: PrivatePages/NewArticles
        DBContext db = new DBContext();
        [HttpGet]
        public ActionResult Index()
        {
            BaiViet x = new BaiViet();
            x.NgayDang = DateTime.Now;
            x.LuotXem = 0;
            x.MaTK = int.Parse(Session["AccountID"].ToString());
            ViewBag.Thumb = "blog-9.jpg";

            return View(x);
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Index(BaiViet x, HttpPostedFileBase imgUpload)
        {
            x.DaDuyet = false;
            x.NgayDang = DateTime.Now;
            x.MaTK = int.Parse(Session["AccountID"].ToString());
            x.LuotXem = 0;
            x.LoaiTin = "QC";
            if (imgUpload != null)
            {
                var virPath = "~/img/blog/";
                var fileName = Path.GetFileNameWithoutExtension(imgUpload.FileName); // Get the filename without extension
                var fileExtension = Path.GetExtension(imgUpload.FileName); // Get the file extension
                var uniqueFileName = "HBV" + DateTime.Now.Ticks + Session["AccountID"] + fileExtension;
                var path = Path.Combine(Server.MapPath(virPath), uniqueFileName);
                imgUpload.SaveAs(path);
                x.HinhAnh = uniqueFileName;
                ViewBag.Thumb = x.HinhAnh;
            }
            else
            {
                x.HinhAnh = "";
            }

            db.BaiViets.Add(x);
            db.SaveChanges();

            return View(x);
        }

    }
}