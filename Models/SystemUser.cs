using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class SystemUser
    {
        public String username { get; set; } 
        public String password { get; set; }

        public SystemUser(String username,String password)
        {
            this.username = username;
            this.password = password;
        }

        public SystemUser()
        {

        }


    }

    
}