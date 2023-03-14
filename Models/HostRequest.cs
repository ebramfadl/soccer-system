using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class HostRequest
    {
        public String senderName { get; set; }
        public String hostName { get; set; }
        public String guestName { get; set; }

        public String starts { get; set; }

        public String ends { get; set; }

        public String status { get; set; }







        public HostRequest(String senderName, String hostname, String guestname, String starts, String ends, String status)
        {
            this.senderName = senderName;
            this.hostName = hostname;
            this.guestName=guestname;
            this.status = status;
            this.starts = starts;
            this.ends = ends;
        }

      

    }

    
}