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
    public class ClubRepController : Controller
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
            if(Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }

            return View();
        }

        public ActionResult SendRequest()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();  
        }

        public ActionResult ShowRepsData()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }

            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from getAllClubReps";

            SqlDataReader dr = cmd.ExecuteReader();

            List<ClubRep> allClubReps = new List<ClubRep>();

            while (dr.Read())
            {
                ClubRep clubRep = new ClubRep(dr["repName"].ToString(), dr["clubName"].ToString(), dr["location"].ToString());

                allClubReps.Add(clubRep);
            }
            connection.Close();

            return View(allClubReps);
        }


        public ActionResult ShowManagersData()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from getAllStadiumManagers";

            SqlDataReader dr = cmd.ExecuteReader();

            List<StadiumManager> stadManagers = new List<StadiumManager>();

            while (dr.Read())
            {
                StadiumManager stadMan = new StadiumManager(dr["manName"].ToString(), dr["stadName"].ToString(), dr["location"].ToString());

                stadManagers.Add(stadMan);
            }
            connection.Close();

            return View(stadManagers);
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
            cmd.CommandText = "select * from getSystemRequests";

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
            return View("AllHostRequest",allHostRequest);

        }


        [HttpPost]
        public ActionResult Login(String username, String password)
        {


            SqlCommand cmd = new SqlCommand("clubRepLogin", connection);
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
                return View("ClubRepComponents");
            }
            else
            {
                Message msg = new Message("You are not registered, Please create an account");
                return View("Message", msg);
            }



        }

        [HttpPost]
        public ActionResult Register(String repName, String clubName, String username, String password)
        {
            SqlCommand cmd = new SqlCommand("addRepresentative", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@rep_name", repName));
            cmd.Parameters.Add(new SqlParameter("@club_name", clubName));
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
                return View("ClubRepComponents");
            }
            else
            {
                Message msg = new Message("There is a user exists already with that username");
                return View("Message", msg);
            }
        }

        public ActionResult ViewClubData()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            SqlCommand cmd = new SqlCommand("getClubName", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@repUsername", Session["newUser"].ToString()));

            SqlParameter result = cmd.Parameters.Add("@clubName", SqlDbType.NVarChar,20);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();

            SqlCommand cmd2 = new SqlCommand();
            cmd2.Connection = connection;
            cmd2.CommandText = "select * from Club where name =" + "'" + result.Value.ToString() + "'";

            SqlDataReader dr = cmd2.ExecuteReader();

            List<Club> allClubs = new List<Club>();

            while (dr.Read())
            {
                Club club = new Club(dr["name"].ToString(), dr["location"].ToString());

                allClubs.Add(club);
            }
            connection.Close();
            return View("ClubInfo", allClubs);

          }

        public ActionResult UpcomingMatches()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }

            SqlCommand cmd = new SqlCommand("getClubName", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@repUsername", Session["newUser"].ToString()));

            SqlParameter result = cmd.Parameters.Add("@clubName", SqlDbType.NVarChar, 20);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();

            SqlCommand cmd2 = new SqlCommand();
            cmd2.Connection = connection;
            cmd2.CommandText = "select * from dbo.upcomingMatchesOfClub('" + result.Value.ToString() + "')" ;

            SqlDataReader dr = cmd2.ExecuteReader();

            List<Match> allMatches = new List<Match>();

            while (dr.Read())
            {
                Match match = new Match(dr["firstClub"].ToString(), dr["secondClub"].ToString(), dr["starts"].ToString(), dr["ends"].ToString(), dr["stadName"].ToString(),null);

                allMatches.Add(match);
            }

            connection.Close();
            return View("UpcomingMatches", allMatches);

        }

        [HttpPost]
        public ActionResult AvailableStadiumsOn(String date)
        {

            try
            {
                if (!(date[2].ToString().Equals("/") && date[5].ToString().Equals("/")) || date.Length != 10)
                {
                    Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                    return View("Message", msg);
                }
                else
                {
                    int month = Int32.Parse(date[0] + "" + date[1]);
                    int day = Int32.Parse(date[3] + "" + date[4]);

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

            connection.Open();
        
            SqlCommand cmd2 = new SqlCommand();
            cmd2.Connection = connection;
            cmd2.CommandText = "select * from dbo.viewAvailableStadiumsOn('" + date + "')";

            SqlDataReader dr = cmd2.ExecuteReader();

            List<Stadium> allStadiums = new List<Stadium>();

            while (dr.Read())
            {
                Stadium stadium = new Stadium(dr["stadiumName"].ToString(), dr["location"].ToString(), dr["capacity"].ToString());
                allStadiums.Add(stadium);
            }

            connection.Close();
            return View("AvailableStadiumsOn", allStadiums);
         }


        [HttpPost]

        public ActionResult SendRequest(String stadName, String date) 
        {
            try
            {
                if (!(date[2].ToString().Equals("/") && date[5].ToString().Equals("/")) || date.Length != 10)
                {
                    Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                    return View("Message", msg);
                }
                else
                {
                    int month = Int32.Parse(date[0] + "" + date[1]);
                    int day = Int32.Parse(date[3] + "" + date[4]);

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

            SqlCommand cmd = new SqlCommand("getClubName", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@repUsername", Session["newUser"].ToString()));

            SqlParameter result = cmd.Parameters.Add("@clubName", SqlDbType.NVarChar, 20);
            result.Direction = ParameterDirection.Output;

            connection.Open();
            cmd.ExecuteNonQuery();

            SqlCommand cmd2 = new SqlCommand("addHostRequest", connection);
            cmd2.CommandType = System.Data.CommandType.StoredProcedure;

            cmd2.Parameters.Add(new SqlParameter("@stadium_name", stadName));
            cmd2.Parameters.Add(new SqlParameter("@start_time", date));
            cmd2.Parameters.Add(new SqlParameter("@club_name", result.Value.ToString()));

            SqlParameter result2 = cmd2.Parameters.Add("@result", SqlDbType.Int);
            result2.Direction = ParameterDirection.Output;

            cmd2.ExecuteNonQuery();

            if (result2.Value.ToString().Equals("1"))
            {
                return RedirectToAction("AllHostRequest");
            }
            else
            {
                Message msg = new Message("Wrong info, Request was not sent");
                return View("Message", msg);
            }
            







        }








    }
}