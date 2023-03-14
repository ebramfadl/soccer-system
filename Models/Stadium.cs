
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class Stadium
    {
        public String stadName { get; set; }
        public String location { get; set; }
        public String capacity { get; set; }
 
       public Stadium(String stadName, String location, String capacity)
        {
            this.stadName = stadName;
            this.location = location;
            this.capacity = capacity;
        }

        public override String ToString()
        {
            return stadName + " . " + location + " . " + capacity;
        }
    }
}
