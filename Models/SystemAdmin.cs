using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class SystemAdmin : SystemUser
    {
        public SystemAdmin(string username, string password) : base(username, password)
        {

        }
        public SystemAdmin()
        {

        }
    }
}