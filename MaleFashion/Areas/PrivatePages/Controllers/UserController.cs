using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MaleFashion.Models;
using PagedList;

namespace MaleFashion.Areas.PrivatePages.Controllers
{
    public class UserController : Controller
    {
        // GET: PrivatePages/User
        DBContext db = new DBContext();
        public ActionResult Index(string search, int? page)
        {
            var pageSize = 10;
            var pageNumber = page ?? 1;
            var users = db.KhachHangs.AsQueryable();
            if (!string.IsNullOrEmpty(search))
            {
                users = users.Where(p => p.HoTen.Contains(search));
            }

            var totalItems = users.Count();
            var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

            var items = users.OrderBy(p => p.HoTen).ToPagedList(pageNumber, pageSize);

            ViewBag.search = search;
            ViewBag.pageNumber = pageNumber;
            ViewBag.totalPages = totalPages;

            return View(items);
        }


        public ActionResult Details(int id)
        {
            KhachHang khach = db.KhachHangs.Find(id);
            if (khach == null)
            {
                return HttpNotFound();
            }
            return View(khach);
        }


        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(KhachHang khach)
        {
            if (ModelState.IsValid)
            {
                var pass = GetMD5.MD5(khach.MatKhau);
                khach.MatKhau = pass;
                db.KhachHangs.Add(khach);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(khach);
        }



        [HttpGet]
        public ActionResult Edit(int id)
        {
            KhachHang khach = db.KhachHangs.Find(id);
            if (khach == null)
            {
                return HttpNotFound();
            }
            return View(khach);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(KhachHang khach)
        {
            if (ModelState.IsValid)
            {

                // Cập nhật đối tượng Sach trong cơ sở dữ liệu
                db.Entry(khach).State = EntityState.Modified;
                db.SaveChanges();

                // Chuyển hướng người dùng đến trang Index
                return RedirectToAction("Index");
            }

            return View(khach);
        }

        public ActionResult Delete(int id)
        {
            KhachHang khach = db.KhachHangs.Find(id);
            if (khach == null)
            {
                return HttpNotFound();
            }
            return View(khach);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            KhachHang khach = db.KhachHangs.Find(id);
            db.KhachHangs.Remove(khach);
            db.SaveChanges();
            return RedirectToAction("Index");
        }


    }
}