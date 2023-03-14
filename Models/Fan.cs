using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class Fan
    {

        public String name { get; set; }
        public String username { get; set; }
        public String nationalId { get; set; }
        public String phoneNumber { get; set; }
        public String address { get; set; }
        public String birthDate { get; set; }
        public String status { get; set; }


        public Fan(string name, string username, string nationalId, string phoneNumber, string address, string birthDate, string status)
        {
            this.name = name;
            this.username = username;
            this.nationalId = nationalId;
            this.phoneNumber = phoneNumber;
            this.address = address;
            this.birthDate = birthDate;
            this.status = status;
        }

    }
}