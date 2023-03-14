using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class ClubRep
    {
        public ClubRep(string name, string clubName, string location)
        {
            this.name = name;
            this.clubName = clubName;
            this.location = location;
        }

        public String name { get; set; }
        public String clubName { get; set; }
        public String location { get; set; }


    }
}