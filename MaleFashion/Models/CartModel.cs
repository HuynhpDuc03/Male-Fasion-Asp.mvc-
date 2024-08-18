using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MaleFashion.Models;

namespace MaleFashion.Models
{
    public class CartModel
    {
        public SanPham_KichThuoc_MauSac product { get; set; }
        public int Quantity { get; set; }


        public int GetTotalPrice()
        {
            int totalPrice = 0;
            if (product != null)
            {
                if (product.SanPham.GiamGia != null && product.SanPham.GiamGia > 0)
                {
                    var discountPrice = product.SanPham.GiaBan - (product.SanPham.GiaBan * product.SanPham.GiamGia / 100);
                    totalPrice = (int)(discountPrice * Quantity);
                }
                else
                {
                    totalPrice = (int)(product.SanPham.GiaBan * Quantity);
                }
            }
            return totalPrice;
        }

    }
}
