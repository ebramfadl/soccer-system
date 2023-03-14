using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Web.UI.WebControls;
using SoccerWebsite.Models;
using System.Web.Http.Results;

namespace SoccerWebsite.Controllers
{
    public class FanController : Controller
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
        public ActionResult InputDate()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }


        public ActionResult AllTickets()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            connection.Open();

            SqlCommand cmd2 = new SqlCommand();
            cmd2.Connection = connection;
            cmd2.CommandText = "select * from dbo.getAllTickets('" + Session["newUser"].ToString() + "')";

            SqlDataReader dr = cmd2.ExecuteReader();

            List<Ticket> allTickets = new List<Ticket>();

            while (dr.Read())
            {
                Ticket ticket = new Ticket(dr["fanName"].ToString(), dr["hostName"].ToString(), dr["guestName"].ToString(), dr["starts"].ToString(), dr["stadName"].ToString());

                allTickets.Add(ticket);
            }

            connection.Close();
            return View("AllTickets", allTickets);
        }

        [HttpPost]
        public ActionResult Login(String username, String password,String id)
        {


            SqlCommand cmd = new SqlCommand("fanLogIn", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));
            cmd.Parameters.Add(new SqlParameter("@fan_id", id));


            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                Session["newUser"] = id;
                return View ("FanComponents");

            }
            else
            {
                Message msg = new Message("You are not registered, Please create an account or you are blocked from using the system");
                return View("Message", msg);
            }

        }
        [HttpPost]
        public ActionResult Register(String fanName, String nationalId, String password, String username,String phoneNumber,String birthdate,String address)
        {

            try
            {
                if (!(birthdate[2].ToString().Equals("/") && birthdate[5].ToString().Equals("/")) || birthdate.Length != 10)
                {
                    Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                    return View("Message", msg);
                }
                else
                {
                    int month = Int32.Parse(birthdate[0] + "" + birthdate[1]);
                    int day = Int32.Parse(birthdate[3] + "" + birthdate[4]);

                    if (month > 12 || month < 1 || day > 30 || day < 1)
                    {
                        Message msg = new Message("Please enter a valid date format Month/Day/Year");
                        return View("Message", msg);
                    }
                }
            }
            catch (Exception e)
            {
                Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                return View("Message", msg);
            }

            SqlCommand cmd = new SqlCommand("addFan", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@name", fanName));
            cmd.Parameters.Add(new SqlParameter("@national_id_number", nationalId));
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));
            cmd.Parameters.Add(new SqlParameter("@address", address));
            cmd.Parameters.Add(new SqlParameter("@phone_number", phoneNumber));
            cmd.Parameters.Add(new SqlParameter("@birth_date", birthdate));



            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                Session["newUser"] = nationalId;
                return View("FanComponents");
            }
            else
            {
                Message msg = new Message("There is a user exists already with that username");
                return View("Message", msg);
            }

        }
        [HttpPost]
        public ActionResult AvailableMatches(String date)
        {

            

            connection.Open();
            

            SqlCommand cmd2 = new SqlCommand();
            cmd2.Connection = connection;
            cmd2.CommandText = "select * from dbo.viewAllMatches('" + date + "')";

            SqlDataReader dr = cmd2.ExecuteReader();

            List<Match> allMatches = new List<Match>();

            while (dr.Read())
            {
                Match match = new Match(dr["hostName"].ToString(), dr["guestName"].ToString(), dr["starts"].ToString(), null,dr["stadName"].ToString(), dr["location"].ToString());

                allMatches.Add(match);
            }

            connection.Close();
            return View("AvailableMatches", allMatches);

        }
        public ActionResult PurchaseTicket(String hostName, String guestName, String start)
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            try
            {
                if (!(start[2].ToString().Equals("/") && start[5].ToString().Equals("/")) || start.Length != 10)
                {
                    Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                    return View("Message", msg);
                }
                else
                {
                    int month = Int32.Parse(start[0] + "" + start[1]);
                    int day = Int32.Parse(start[3] + "" + start[4]);

                    if (month > 12 || month < 1 || day > 30 || day < 1)
                    {
                        Message msg = new Message("Please enter a valid date format Month/Day/Year");
                        return View("Message", msg);
                    }
                }
            }
            catch (Exception e)
            {
                Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                return View("Message", msg);
            }

            String newFormatString = start[3] + "" + start[4] + "/" + start[0] + "" + start[1] + "/" + start.Substring(6, 4);

            SqlCommand cmd = new SqlCommand("purchaseTicket", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            DateTime startTime = DateTime.ParseExact(newFormatString, "MM/dd/yyyy", null);

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;

            cmd.Parameters.Add(new SqlParameter("@national_id", Session["newUser"].ToString()));
            cmd.Parameters.Add(new SqlParameter("@host_club_name", hostName));
            cmd.Parameters.Add(new SqlParameter("@guest_club_name", guestName));
            cmd.Parameters.Add(new SqlParameter("@start_time", startTime));



            connection.Open();
            cmd.ExecuteNonQuery();

            connection.Close();
            if (result.Value.ToString().Equals("1"))
            {
             
                return RedirectToAction("AllTickets");

            }
            else
            {
                Message msg = new Message("Failed to purchase, you are blocked or no tickets avilable");
                return View("Message", msg);
            }

        }










    }

}
