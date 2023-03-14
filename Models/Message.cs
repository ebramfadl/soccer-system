using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoccerWebsite.Models
{
    public class Message
    {
        public String content { get; set; }

        public Message(String content)
        {
            this.content = content;
        }
    }
}