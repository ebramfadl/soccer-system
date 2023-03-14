using SoccerWebsite.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Text.RegularExpressions;
using Match = SoccerWebsite.Models.Match;
using System.Web.Http.Results;

namespace SoccerWebsite.Controllers
{
    public class SportManagerController : Controller
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


        public ActionResult AddNewMatch()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }

        public ActionResult DeleteMatch()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }


        public ActionResult AllMatches()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            List<Match> matches = getAllMatches();

            return View("AllMatches",matches);
        }

        public List<Match> getAllMatches()
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from getAllMatches";

            SqlDataReader dr = cmd.ExecuteReader();

            List<Match> allMatches = new List<Match>();

            while (dr.Read())
            {
                String stadName;
                String location;

                if (dr["stadName"].ToString().Equals("")) {
                    stadName = "Undetermined";
                    location = "Undetermined";
                }
                else
                {
                    stadName = dr["stadName"].ToString();
                    location = dr["location"].ToString();
                }

                Match match = new Match(dr["hostName"].ToString(), dr["guestName"].ToString(), dr["starts"].ToString(), dr["ends"].ToString(), stadName, location);

                allMatches.Add(match);
            }
            connection.Close();

            return allMatches;
        }

        public List<Club> getAllClubs()
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from Club";

            SqlDataReader dr = cmd.ExecuteReader();

            List<Club> allClubs = new List<Club>();

            while (dr.Read())
            {
                Club club = new Club(dr["name"].ToString(), dr["location"].ToString());

                allClubs.Add(club);
            }
            connection.Close();

            return allClubs;
        }

        public ActionResult AllClubs()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            List<Club> clubs = getAllClubs();

            return View("AllClubs", clubs);
        }


        [HttpPost]
        public ActionResult Login(String username, String password)
        {


            SqlCommand cmd = new SqlCommand("sportAssociacionLogin", connection);
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
                return View("SportManagerComponents");
            }
            else
            {
                Message msg = new Message("You are not registered, Please create an account");
                return View("Message", msg);
            }



        }



        [HttpPost]
        public ActionResult Register(String name, String username, String password)
        {
            SqlCommand cmd = new SqlCommand("addAssociationManager", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@manager_name", name));
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
                return View("SportManagerComponents");
            }
            else
            {
                Message msg = new Message("There is a user exists already with that username");
                return View("Message", msg);
            }
        }


        [HttpPost]
        public ActionResult AddNewMatch(String hostName, String guestName, String startTime, String endTime)
        {
            try
            {
                if ((!(startTime[2].ToString().Equals("/") && startTime[5].ToString().Equals("/")) || startTime.Length != 10 ) || (!(endTime[2].ToString().Equals("/") && endTime[5].ToString().Equals("/")) || endTime.Length != 10))
                {
                    Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                    return View("Message", msg);
                }
                else
                {
                    int monthStart = Int32.Parse(startTime[0] + "" + startTime[1]);
                    int dayStart = Int32.Parse(startTime[3] + "" + startTime[4]);

                    int monthEnd = Int32.Parse(endTime[0] + "" + endTime[1]);
                    int dayEnd = Int32.Parse(endTime[3] + "" + endTime[4]);

                    if (monthStart > 12 || monthStart < 1 || dayStart > 30 || dayStart < 1 || monthEnd > 12 || monthEnd < 1 || dayEnd > 30 || dayEnd < 1)
                    {
                        Message msg = new Message("Please enter a valid date format Month/Day/Year");
                        return View("Message", msg);
                    }
                }
            }
            catch(Exception e)
            {
                Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                return View("Message", msg);
            }
            //String newFormatString = startTime[3] + "" + startTime[4] + "/" + startTime[0] + "" + startTime[1] + "/" + startTime.Substring(6, 4);
            //String newFormatStringEnd = endTime[3] + "" + endTime[4] + "/" + endTime[0] + "" + endTime[1] + "/" + endTime.Substring(6, 4);

            SqlCommand cmd = new SqlCommand("addNewMatch", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            DateTime start = DateTime.ParseExact(startTime, "MM/dd/yyyy", null);
            DateTime end = DateTime.ParseExact(endTime, "MM/dd/yyyy", null);



            cmd.Parameters.Add(new SqlParameter("@host_name", hostName));
            cmd.Parameters.Add(new SqlParameter("@guest_name", guestName));
            cmd.Parameters.Add(new SqlParameter("@start_time", start));
            cmd.Parameters.Add(new SqlParameter("@end_time", end));

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();


            if (result.Value.ToString().Equals("1"))
            {
                List<Match> allMatches = getAllMatches();

                return View("AllMatches",allMatches);
            }
            else
            {
                Message msg = new Message("There is a match exists already with the same data or no clubs with the chosen names");
                return View("Message", msg);
            }


        }



        [HttpPost]
        public ActionResult DeleteMatch(String hostName, String guestName, String startTime, String endTime)
        {
            try
            {
                if ((!(startTime[2].ToString().Equals("/") && startTime[5].ToString().Equals("/")) || startTime.Length != 10) || (!(endTime[2].ToString().Equals("/") && endTime[5].ToString().Equals("/")) || endTime.Length != 10))
                {
                    Message msg = new Message("Please enter a valid date format for Month/Day/Year");
                    return View("Message", msg);
                }
                else
                {
                    int monthStart = Int32.Parse(startTime[0] + "" + startTime[1]);
                    int dayStart = Int32.Parse(startTime[3] + "" + startTime[4]);

                    int monthEnd = Int32.Parse(endTime[0] + "" + endTime[1]);
                    int dayEnd = Int32.Parse(endTime[3] + "" + endTime[4]);

                    if (monthStart > 12 || monthStart < 1 || dayStart > 30 || dayStart < 1 || monthEnd > 12 || monthEnd < 1 || dayEnd > 30 || dayEnd < 1)
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



            SqlCommand cmd = new SqlCommand("deleteMatch", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            DateTime start = DateTime.ParseExact(startTime.Substring(0,10), "MM/dd/yyyy", null);

            cmd.Parameters.Add(new SqlParameter("@host_name", hostName));
            cmd.Parameters.Add(new SqlParameter("@guest_name", guestName));
            cmd.Parameters.Add(new SqlParameter("@start_time", start));


            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                List<Match> allMatches = getAllMatches();

                return View("AllMatches", allMatches);
            }
            else
            {
                Message msg = new Message("There is no match exists with the chosen data");
                return View("Message", msg);
            }

        }



        public ActionResult AllComingMatches()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from allComingMatches";

            SqlDataReader dr = cmd.ExecuteReader();

            List<Match> allMatches = new List<Match>();

            while (dr.Read())
            {
                String stadName;
                String location;

                if (dr["stadName"].ToString().Equals(""))
                {
                    stadName = "Undetermined";
                    location = "Undetermined";
                }
                else
                {
                    stadName = dr["stadName"].ToString();
                    location = dr["location"].ToString();
                }

                Match match = new Match(dr["hostName"].ToString(), dr["guestName"].ToString(), dr["starts"].ToString(), dr["ends"].ToString(),stadName,location);

                allMatches.Add(match);
            }

            connection.Close();

            return View("AllMatches", allMatches);
        }


        public ActionResult AllPlayedMatches()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from allPlayedMatches";

            SqlDataReader dr = cmd.ExecuteReader();

            List<Match> allMatches = new List<Match>();

            while (dr.Read())
            {
                String stadName;
                String location;

                if (dr["stadName"].ToString().Equals(""))
                {
                    stadName = "Undetermined";
                    location = "Undetermined";
                }
                else
                {
                    stadName = dr["stadName"].ToString();
                    location = dr["location"].ToString();
                }
                Match match = new Match(dr["hostName"].ToString(), dr["guestName"].ToString(), dr["starts"].ToString(), dr["ends"].ToString(), stadName,location);

                allMatches.Add(match);
            }

            connection.Close();

            return View("AllMatches", allMatches);
        }



        public ActionResult ClubsNeverMatched()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from clubsNeverMatched";

            SqlDataReader dr = cmd.ExecuteReader();

            List<Match> allMatches = new List<Match>();

            while (dr.Read())
            {
                Match match = new Match(dr["firstClub"].ToString(), dr["secondClub"].ToString(), null, null,null,null);

                allMatches.Add(match);
            }

            connection.Close();

            return View("ClubsNeverMatched", allMatches);
        }
    }
}