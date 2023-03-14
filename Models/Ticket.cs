using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class Ticket
    {
        public Ticket(string fanName, string hostName, string guestNAme, string starts, string stadName)
        {
            this.fanName = fanName;
            this.hostName = hostName;
            this.guestName = guestNAme;
            this.starts = starts;
            this.stadName = stadName;
        }

        public String fanName { get; set; }
        public String hostName { get; set; }
        public String guestName { get; set; }
        public String starts { get; set; }
        public String stadName { get; set; }



    }
}