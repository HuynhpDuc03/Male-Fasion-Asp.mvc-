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
    public class AuthorsController : Controller
    {
        // GET: PrivatePages/Authors
        DBContext db = new DBContext();
        public ActionResult Index(string search, int? page)
        {
            var pageSize = 10;
            var pageNumber = page ?? 1;
            var ncc = db.NhaCungCaps.AsQueryable();
            if (!string.IsNullOrEmpty(search))
            {
                ncc = ncc.Where(p => p.TenNCC.Contains(search));
            }

            var totalItems = ncc.Count();
            var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

            var items = ncc.OrderBy(p => p.TenNCC).ToPagedList(pageNumber, pageSize);

            ViewBag.search = search;
            ViewBag.pageNumber = pageNumber;
            ViewBag.totalPages = totalPages;

            return View(items);
        }



        public ActionResult Details(int id)
        {
            NhaCungCap ncc = db.NhaCungCaps.Find(id);
            if (ncc == null)
            {
                return HttpNotFound();
            }
            return View(ncc);
        }

        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(NhaCungCap ncc)
        {
            if (ModelState.IsValid)
            {

                db.NhaCungCaps.Add(ncc);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(ncc);
        }


        [HttpGet]
        public ActionResult Edit(int id)
        {
            NhaCungCap ncc = db.NhaCungCaps.Find(id);
            if (ncc == null)
            {
                return HttpNotFound();
            }
            return View(ncc);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(NhaCungCap ncc)
        {
            if (ModelState.IsValid)
            {

                // Cập nhật đối tượng Sach trong cơ sở dữ liệu
                db.Entry(ncc).State = EntityState.Modified;
                db.SaveChanges();

                // Chuyển hướng người dùng đến trang Index
                return RedirectToAction("Index");
            }

            return View(ncc);
        }


        // GET: Sach/Delete/5
        public ActionResult Delete(int id)
        {
            NhaCungCap ncc = db.NhaCungCaps.Find(id);
            if (ncc == null)
            {
                return HttpNotFound();
            }
            return View(ncc);
        }

        // POST: Sach/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            NhaCungCap ncc = db.NhaCungCaps.Find(id);
            db.NhaCungCaps.Remove(ncc);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

    }
}