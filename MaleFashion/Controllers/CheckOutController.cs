using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MaleFashion.Models;


namespace MaleFashion.Controllers
{
    public class CheckOutController : Controller
    {
        // GET: CheckOut
        DBContext db = new DBContext();

        [HttpGet]
        public ActionResult Index()
        {
            List<CartModel> gh = (List<CartModel>)Session["cart"];
            ViewBag.cart = gh;
            return View();
        }
        [HttpPost]
        public ActionResult SaveToDataBase(FormCollection fc)
        {
            if (Session["AccountID"] == null)
            {
                return RedirectToAction("Login", "Home");
            }
            else
            {
                var makh = Session["AccountID"];
                var lstCart = (List<CartModel>)Session["cart"];
                DonDatHang objOder = new DonDatHang();
                objOder.TenDH = "DonHang-" + DateTime.Now.ToString("yyyyMMddHHmmss");
                objOder.MaKH = int.Parse(makh.ToString());
                objOder.NgayDatHang = DateTime.Now;
                objOder.NgayGiao = DateTime.Now.AddDays(3);
                objOder.HoTen = fc["FullName_order"];
                objOder.DiaChi = fc["Address_Order"];
                objOder.SDT = fc["phone"];
                objOder.GhiChu = fc["Note"];
                objOder.Email = fc["Email"];
                db.DonDatHangs.Add(objOder);
                db.SaveChanges();
                int intOrderId = objOder.MaDH;
                List<CTDonHang> lstOrderDetail = new List<CTDonHang>();
                foreach (var item in lstCart)
                {
                    CTDonHang obj = new CTDonHang();
                    obj.SoLuong = item.Quantity;
                    obj.MaDH = intOrderId;
                    obj.MaSP = item.product.MaSP;
                    obj.MaKT = item.product.MaKT;
                    obj.MaMau = item.product.MaMau;
                    obj.NgayTao = DateTime.Now;
                    obj.GiamGia = item.product.SanPham.GiamGia;
                    if (item.product.SanPham.GiamGia != null && item.product.SanPham.GiamGia > 0)
                        obj.GiaBan = (decimal)(item.product.SanPham.GiaBan * (100 - item.product.SanPham.GiamGia) / 100);
                    else
                        obj.GiaBan = item.product.SanPham.GiaBan;
                    obj.TongTien = item.GetTotalPrice();
                    lstOrderDetail.Add(obj);
                }

                db.CTDonHangs.AddRange(lstOrderDetail);
                db.SaveChanges();
                Session.Remove("Cart");
                Session.Remove("count");
            }
            return RedirectToAction("PaymentSuccess");
        }

        public ActionResult PaymentSuccess()
        {
            return View();
        }
    }
}