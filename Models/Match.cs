
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class Match
    {
        public String hostName { get; set; }
        public String guestName { get; set; }
        public String starts { get; set; }
        public String ends { get; set; }

        public String stadiumName { get; set; }

         public String location { get; set; }



        public Match(String hostName, String guestName, String starts, String ends, String stadiumName, string location)
        {
            this.hostName = hostName;
            this.guestName = guestName;
            this.starts = starts;
            this.ends = ends;
            this.stadiumName = stadiumName;
            this.location = location;
        }
    }
}
