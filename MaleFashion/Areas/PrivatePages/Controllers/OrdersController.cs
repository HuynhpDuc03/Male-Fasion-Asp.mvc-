using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MaleFashion.Models;
using PagedList;

namespace MaleFashion.Areas.PrivatePages.Controllers
{
    public class OrdersController : Controller
    {
         DBContext db = new DBContext();
        public ActionResult Index(string search, int? page)
        {
            var pageSize = 10;
            var pageNumber = page ?? 1;
            var orders = db.DonDatHangs.AsQueryable();
            if (!string.IsNullOrEmpty(search))
            {
                orders = orders.Where(p => p.TenDH.Contains(search));
            }

            var totalItems = orders.Count();
            var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

            var items = orders.OrderBy(p => p.TenDH).Include(o => o.KhachHang).ToPagedList(pageNumber, pageSize);

            ViewBag.search = search;
            ViewBag.pageNumber = pageNumber;
            ViewBag.totalPages = totalPages;

            return View(items);
        }


        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonDatHang order = db.DonDatHangs.Include(o => o.CTDonHangs.Select(od => od.SanPham)).FirstOrDefault(o => o.MaDH == id);
            if (order == null)
            {
                return HttpNotFound();
            }
            return View(order);
        }


        public ActionResult Create()
        {
            ViewBag.MaKH = new SelectList(db.KhachHangs, "MaKH", "HoTen");
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaDH,MaKH,NgayDatHang,NgayGiao,ThanhToan,TinhTrangDonHang,TenDH,GhiChu,DiaChi")] DonDatHang order)
        {
            if (ModelState.IsValid)
            {
                db.DonDatHangs.Add(order);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.KH = new SelectList(db.KhachHangs , "MaKH", "HoTen", order.MaKH);
            return View(order);
        }


        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonDatHang order = db.DonDatHangs.Find(id);
            if (order == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaKH = new SelectList(db.KhachHangs, "MaKH", "HoTen", order.MaKH);
            return View(order);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include ="MaDH,MaKH,NgayDatHang,NgayGiao,ThanhToan,TinhTrangDonHang,TenDH,GhiChu,DiaChi")] DonDatHang order)
        {
            if (ModelState.IsValid)
            {
                db.Entry(order).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaKH = new SelectList(db.KhachHangs, "MaKH", "HoTen", order.MaKH);
            return View(order);
        }

        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonDatHang order = db.DonDatHangs.Find(id);
            if (order == null)
            {
                return HttpNotFound();
            }
            return View(order);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            DonDatHang order = db.DonDatHangs.Find(id);
            db.DonDatHangs.Remove(order);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        public ActionResult Cancel(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonDatHang order = db.DonDatHangs.Find(id);
            if (order == null)
            {
                return HttpNotFound();
            }
            order.TrangThaiDH = false;
            db.Entry(order).State = EntityState.Modified;
            db.SaveChanges();

            return RedirectToAction("Index");
        }

        public ActionResult Activate(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DonDatHang order = db.DonDatHangs.Find(id);
            if (order == null)
            {
                return HttpNotFound();
            }
            
            order.DaThanhToan = true;
            db.Entry(order).State = EntityState.Modified;
            db.SaveChanges();

            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}