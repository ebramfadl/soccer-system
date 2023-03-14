using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class StadiumManager
    {
        public StadiumManager(string name, string stadName, string location)
        {
            this.name = name;
            this.stadName = stadName;
            this.location = location;
        }

        public String name { get; set; }
        public String stadName { get; set; }
        public String location { get; set; }
    }
}