using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using SoccerWebsite.Models;
using System.Web.Http.Results;

namespace SoccerWebsite.Controllers
{
    public class StadiumManagerController : Controller
    {
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Soccer"].ToString());

        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Login()
        {
            return View();
        }

        public ActionResult Register()
        {
            return View();
        }


        


        


        [HttpPost]
        public ActionResult Login(String username, String password)
        {


            SqlCommand cmd = new SqlCommand("stadManLogin", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));


            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                Session["newUser"] = username;
                return View("StadiumManagerComponents");
            }
            else
            {
                Message msg = new Message("You are not registered, Please create an account");
                return View("Message", msg);
            }



        }

        [HttpPost]
        public ActionResult Register(String name,  String username, String password,String stadiumName)
        {
            SqlCommand cmd = new SqlCommand("addStadiumManager", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@manager_name", name));
            cmd.Parameters.Add(new SqlParameter("@stadium_name", stadiumName));
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));



            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                Session["newUser"] = username;
                return View("StadiumManagerComponents");
            }
            else
            {
                Message msg = new Message("There is a user exists already with that username");
                return View("Message", msg);
            }
        }

        public ActionResult ViewStadiumData()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            SqlCommand cmd = new SqlCommand("getStadName", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@manUsername", Session["newUser"].ToString()));

            SqlParameter result = cmd.Parameters.Add("@stadName", SqlDbType.NVarChar,20);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();

            SqlCommand cmd2 = new SqlCommand();
            cmd2.Connection = connection;
            cmd2.CommandText = "select * from Stadium where name =" + "'" + result.Value.ToString() + "'";

            SqlDataReader dr = cmd2.ExecuteReader();

            List<Stadium> allStadium = new List<Stadium>();

            while (dr.Read())
            {
                Stadium stadium = new Stadium(dr["name"].ToString(), dr["location"].ToString(), dr["capacity"].ToString());

                allStadium.Add(stadium);
            }
            connection.Close();
            return View("ViewStadiumData", allStadium);

          }

        public ActionResult AllHostRequest()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            connection.Open();  

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from dbo.getAllRequests('" + Session["newUser"].ToString() + "')" ;

            SqlDataReader dr = cmd.ExecuteReader();

            List<HostRequest> allHostRequest = new List<HostRequest>();

            while (dr.Read())
            {
                String status;

                if (dr["status"].ToString().Equals("True"))
                    status = "Accepted";
                else if (dr["status"].ToString().Equals("False"))
                    status = "Rejected";
                else
                    status = "Unhandled";
                HostRequest hostRequest = new HostRequest(dr["senderName"].ToString(), dr["hostName"].ToString(), dr["guestName"].ToString(), dr["starts"].ToString(), dr["ends"].ToString(), status);

                allHostRequest.Add(hostRequest);
            }

            connection.Close();
            return View("AllHostRequest", allHostRequest);

        }

      
        public ActionResult DetermineRequest(String hostName, String guestName,String start,int flag)
        {
            String newFormatString = start[3] +""+ start[4] + "/" + start[0] +""+ start[1] + "/" + start.Substring(6,4);
            
            String procedure;
            if (flag == 0)
                procedure = "rejectRequest";
            else
                procedure = "acceptRequest";

            SqlCommand cmd = new SqlCommand(procedure, connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            DateTime startTime = DateTime.ParseExact(newFormatString, "MM/dd/yyyy", null);

            cmd.Parameters.Add(new SqlParameter("@username", Session["newUser"].ToString()));
            cmd.Parameters.Add(new SqlParameter("@host_club_name", hostName));
            cmd.Parameters.Add(new SqlParameter("@guest_club_name", guestName));
            cmd.Parameters.Add(new SqlParameter("@match_time", startTime));



            connection.Open();
            cmd.ExecuteNonQuery();

            connection.Close();


          
            return RedirectToAction("AllHostRequest");
           


        }


















    }
}