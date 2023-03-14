using SoccerWebsite.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Xml.Linq;

namespace SoccerWebsite.Controllers
{
    public class SystemAdminController : Controller
    {
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Soccer"].ToString());

        // GET: SystemAdmin
        public ActionResult Index()
        {
            return View();
        }


        public ActionResult Login()
        {
            return View();
        }



        public ActionResult AddClub()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }



        public ActionResult DeleteClub()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }

        

        public ActionResult AddStadium()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }



        public ActionResult DeleteStadium()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }



        public ActionResult BlockFan()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
        }


        public ActionResult UnblockFan()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
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


        public ActionResult AllStadiums()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            List<Stadium> stadiums = getAllStadiums();

            return View("AllStadiums", stadiums);
        }


        public ActionResult AllFans()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            List<Fan> fans = getAllFans();

            return View("AllFans", fans);
        }



        public ActionResult Message()
        {
            if (Session["newUser"] == null)
            {
                Message msg = new Message("You are not logged in");
                return View("Message", msg);
            }
            return View();
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


        public List<Stadium> getAllStadiums()
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from Stadium";

            SqlDataReader dr = cmd.ExecuteReader();

            List<Stadium> allStadiums = new List<Stadium>();

            while (dr.Read())
            {
                Stadium stad = new Stadium(dr["name"].ToString(), dr["location"].ToString(), dr["capacity"].ToString());

                allStadiums.Add(stad);
            }
            connection.Close();

            return allStadiums;
        }



        public List<Fan> getAllFans()
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select * from Fan";

            SqlDataReader dr = cmd.ExecuteReader();

            List<Fan> allFans = new List<Fan>();

            while (dr.Read())
            {
                String status;
                
                if (dr["status"].ToString().Equals("True"))
                    status = "Allowed";
                else
                    status = "Blocked";

                Fan fan = new Fan(dr["name"].ToString(), dr["username"].ToString(), dr["national_id"].ToString(), dr["phone_number"].ToString(), dr["address"].ToString(), dr["birth_date"].ToString(), status);

                allFans.Add(fan);
            }
            connection.Close();

            return allFans;
        }




        [HttpPost]
        public ActionResult Login(String username, String password)
        {


            SqlCommand cmd = new SqlCommand("adminLogin", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));


            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if(result.Value.ToString().Equals("1"))
            {
                Session["newUser"] = username;
                return View("AdminComponents");  
            }
            else
            {
                Message msg = new Message("You are not registered, Please create an account");
                return View("Message",msg);
            }


      
        }

        [HttpPost]
        public ActionResult AddClub(String name, String location)
        {
            SqlCommand cmd = new SqlCommand("addClub", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@club_name", name));
            cmd.Parameters.Add(new SqlParameter("@location", location));

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                List<Club> clubs = getAllClubs();

                return View("AllClubs", clubs);
            }
            else
            {
                Message msg = new Message("Club exists already");
                return View("Message", msg);
            }

            
        }


       


        [HttpPost]
        public ActionResult DeleteClub(String name)
        {
            SqlCommand cmd = new SqlCommand("deleteClub", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@club_name", name));

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                List<Club> clubs = getAllClubs();

                return View("AllClubs", clubs);
            }
            else
            {
                Message msg = new Message("Club does not exist");
                return View("Message", msg);
            }
        }


        [HttpPost]
        public ActionResult AddStadium(String name, String location, String capacity)
        {

            
            SqlCommand cmd = new SqlCommand("addStadium", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@stadium_name", name));
            cmd.Parameters.Add(new SqlParameter("@location", location));
            cmd.Parameters.Add(new SqlParameter("@capacity", Int32.Parse(capacity)));

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;



            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                List<Stadium> allStadiums = getAllStadiums();

                return View("AllStadiums", allStadiums);
            }
            else
            {
                Message msg = new Message("Stadium exists already");
                return View("Message", msg);
            }

        }

        [HttpPost]
        public ActionResult DeleteStadium(String name)
        {
            SqlCommand cmd = new SqlCommand("deleteStadium", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@stadium_name", name));

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;


            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                List<Stadium> allStadiums = getAllStadiums();

                return View("AllStadiums", allStadiums);
            }
            else
            {

                Message msg = new Message("Stadium does not exist");
                return View("Message", msg);
            }
        }


        [HttpPost]
        public ActionResult BlockFan(String nationalId)
        {
            SqlCommand cmd = new SqlCommand("blockFan", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@national_id", nationalId));

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;

            //SqlParameter name = cmd.Parameters.Add("@name", SqlDbType.VarChar);
            //name.Direction = ParameterDirection.Output;

            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                List<Fan> fans = getAllFans();

                return View("AllFans", fans);
            }
            else
            {
                Message msg = new Message("There is no fan with such a National ID");
                return View("Message", msg);
            }
        }


        [HttpPost]
        public ActionResult UnblockFan(String nationalId)
        {
            SqlCommand cmd = new SqlCommand("unblockFan", connection);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@national_id", nationalId));

            SqlParameter result = cmd.Parameters.Add("@result", SqlDbType.Int);
            result.Direction = ParameterDirection.Output;

            //SqlParameter name = cmd.Parameters.Add("@name", SqlDbType.VarChar);
            //name.Direction = ParameterDirection.Output;

            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

            if (result.Value.ToString().Equals("1"))
            {
                List<Fan> fans = getAllFans();

                return View("AllFans", fans);
            }
            else
            {
                Message msg = new Message("There is no fan with such a National ID");
                return View("Message", msg);
            }
        }
    }
}