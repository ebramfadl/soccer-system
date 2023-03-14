using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class Club
    {
        public String name { get; set; }
        public String location { get; set; }

        public Club(String name, String location)
        {
            this.name = name;
            this.location = location;
        }

        public Club()
        {
           
        }

    }

    
}