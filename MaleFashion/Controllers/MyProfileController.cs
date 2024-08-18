using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MaleFashion.Models;

namespace MaleFashion.Controllers
{
    public class MyProfileController : Controller
    {
        DBContext dbContext = new DBContext();
        // GET: MyProfile
        [HttpGet]
        public ActionResult Index(int id)
        {
            var objAccount = dbContext.KhachHangs.Where(x => x.MaKH == id).FirstOrDefault();
            return View(objAccount);
        }

        [HttpPost]
        public ActionResult Index(int id, KhachHang objAccount, FormCollection fc)
        {
            KhachHang x = dbContext.KhachHangs.FirstOrDefault(m => m.MaKH == id);
            x.HoTen = objAccount.HoTen;
            x.DiaChi = objAccount.DiaChi;
            x.EMAIL = objAccount.EMAIL;
            x.NgaySinh = objAccount.NgaySinh;
            x.SDT = objAccount.SDT;
            x.MatKhau = objAccount.MatKhau;
            dbContext.Entry(x).State = EntityState.Modified;
            dbContext.SaveChanges();
            return RedirectToAction("Index", "Home");
        }
        [HttpGet]
        public ActionResult ChangePassword(int id)
        {
            var objAccount = dbContext.KhachHangs.Where(x => x.MaKH == id).FirstOrDefault();
            return View(objAccount);
        }

        [HttpPost]
        public ActionResult ChangePassword(int id, string oldPassword, string newPassword)
        {
            var checkOldPassword = GetMD5.MD5(oldPassword);
            var customer = dbContext.KhachHangs.FirstOrDefault(x => x.MaKH == id && x.MatKhau == checkOldPassword);

            if (customer != null)
            {
                customer.MatKhau = GetMD5.MD5(newPassword);
                dbContext.Entry(customer).State = EntityState.Modified;
                dbContext.SaveChanges();
                return RedirectToAction("Index", "Home");
            }
            else
            {
                ViewBag.error = "Mật khẩu cũ không trùng khớp";
                return View();
            }
        }
    }
}