using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MaleFashion.Models;

namespace MaleFashion.Controllers
{
    public class CartController : Controller
    {
        DBContext db = new DBContext();
        // GET: Cart
        public ActionResult Index()
        {
            if (Session["cart"] == null || ((List<CartModel>)Session["cart"]).Count == 0)
            {
                ViewBag.Message = "Không có sản phẩm để thanh toán";
                return View();
            }
            else
            {
                return View((List<CartModel>)Session["cart"]);
            }
        }

        public ActionResult AddToCart(string id, int quantity, int kichThuoc, int mauSac)
        {
            // Kiểm tra xem session "cart" đã tồn tại chưa
            if (Session["cart"] == null)
            {
                List<CartModel> cart = new List<CartModel>();
                cart.Add(new CartModel
                {
                    product = db.SanPham_KichThuoc_MauSac.Where(x => x.MaSP == id && x.MaKT.Equals(kichThuoc) && x.MaMau.Equals(mauSac)).FirstOrDefault(),
                    Quantity = quantity,
                });
                Session["cart"] = cart;
                Session["count"] = 1;
            }
            else
            {
                List<CartModel> cart = (List<CartModel>)Session["cart"];
                // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
                int index = isExist(id, kichThuoc, mauSac);
                if (index != -1)
                {
                    // Nếu sản phẩm đã tồn tại trong giỏ hàng, cộng thêm số lượng
                    cart[index].Quantity += quantity;
                }
                else
                {
                    // Nếu sản phẩm chưa tồn tại, thêm sản phẩm vào giỏ hàng
                    cart.Add(new CartModel
                    {
                        product = db.SanPham_KichThuoc_MauSac.Where(x => x.MaSP == id && x.MaKT.Equals(kichThuoc) && x.MaMau.Equals(mauSac)).FirstOrDefault(),
                        Quantity = quantity,

                    });
                    // Tính lại số lượng sản phẩm trong giỏ hàng
                    Session["count"] = Convert.ToInt32(Session["count"]) + 1;
                }
                Session["cart"] = cart;
            }

            return Json(new { Message = "Thành công" });
        }


        private int isExist(string id, int kichThuoc, int mauSac)
        {
            List<CartModel> cart = (List<CartModel>)Session["cart"];
            return cart.FindIndex(x => x.product.MaSP == id && x.product.MaKT == kichThuoc && x.product.MaMau == mauSac);
        }



        //xóa sản phẩm khỏi giỏ hàng theo id
        public ActionResult Remove(string Id)
        {
            List<CartModel> li = (List<CartModel>)Session["cart"];
            CartModel itemToRemove = li.FirstOrDefault(x => x.product.MaSP == Id);

            if (itemToRemove != null)
            {
                li.Remove(itemToRemove);
                Session["cart"] = li;

                int count = Convert.ToInt32(Session["count"]);
                count--;
                Session["count"] = count;
            }

            return Json(new { Message = "Thành công" }, JsonRequestBehavior.AllowGet);
        }



        [HttpPost]
        public ActionResult Update(FormCollection fc)
        {
            string[] quantities = fc.GetValues("quantity");
            List<CartModel> cart = (List<CartModel>)Session["cart"];
            for (int i = 0; i < cart.Count; i++)
            {
                if (Convert.ToInt32(quantities[i]) <= 0)
                {
                    cart.RemoveAt(i); 
                }
                else
                {
                    cart[i].Quantity = Convert.ToInt32(quantities[i]);
                }
            }

            if (cart.Count == 0)
            {
                Session["cart"] = null;
                ViewBag.Message = "Không có sản phẩm";
            }
            else
            {
                Session["cart"] = cart;
            }

            return RedirectToAction("Index");
        }
        
    }
}