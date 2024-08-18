using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MaleFashion.Models;

namespace MaleFashion.Controllers
{
    public class HomeController : Controller
    {
        DBContext db = new DBContext();
        public ActionResult Index()
        {
            List<BaiViet> posts = db.BaiViets.Where(x => x.DaDuyet == true).OrderByDescending(x => x.NgayDang).ToList();
            List<SanPham> products = db.SanPhams.ToList();

            var model = new ProductPostModel
            {
                Products = products,
                Posts = posts
            };
            return View(model);


        }

        [HttpGet]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Register(KhachHang acc)
        {
            if (ModelState.IsValid)
            {
                var taiKhoan = acc.TenDangNhap.ToLower();
                var check = db.KhachHangs.FirstOrDefault(s => s.TenDangNhap.Equals(taiKhoan) || s.EMAIL.Equals(acc.EMAIL));
                if (check == null)
                {
                    acc.TenDangNhap = taiKhoan;
                    acc.MatKhau = GetMD5.MD5(acc.MatKhau);
                    db.Configuration.ValidateOnSaveEnabled = false;
                    db.KhachHangs.Add(acc);
                    db.SaveChanges();
                    return RedirectToAction("Login");
                }
                else
                {
                    ViewBag.error = "Tài khoản hoặc email đã tồn tại trong hệ thống";
                    return View();
                }
            }
            return View();
        }

        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(string TenDangNhap, string MatKhau)
        {
            if (ModelState.IsValid)
            {
                var f_password = GetMD5.MD5(MatKhau);
                var taiKhoan = TenDangNhap.ToLower();
                //var admin = db.Administrators.Where(s => s.UserAdmin.Equals(taiKhoan) && s.PassAdmin.Equals(f_password)).ToList();
                var data = db.KhachHangs.Where(s => s.TenDangNhap.Equals(taiKhoan) && s.MatKhau.Equals(f_password)).ToList();
                if (data.Count() > 0)
                {
                    //add session

                    Session["FullName"] = data.FirstOrDefault().HoTen;
                    Session["AccountID"] = data.FirstOrDefault().MaKH;
                    //if (admin.Count() > 0)
                    //    Session["Admin"] = admin.FirstOrDefault().UserAdmin;
                    return RedirectToAction("Index");
                }
                else
                {
                    ViewBag.error = "Tài khoản hoặc mật khẩu không đúng.";
                    return View();
                }
            }
            return View();
        }
        //Logout
        public ActionResult Logout()
        {
            Session.Clear();//remove session
            return RedirectToAction("Login");
        }


    }
}