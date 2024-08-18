using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MaleFashion.Models;

namespace MaleFashion.Models
{
    public class Common
    {
        public IEnumerable<SanPham> Product { get; set; }
        public IEnumerable<BaiViet> Posts { get; set; }
    }
}