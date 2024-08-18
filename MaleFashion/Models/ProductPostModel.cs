using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MaleFashion.Models
{
    public class ProductPostModel
    {
        public IEnumerable<SanPham> Products { get; set; }
        public IEnumerable<BaiViet> Posts { get; set; }
    }
}