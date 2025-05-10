package programacion.servlet;

import programacion.dao.UserDao;
import programacion.dao.UserDaoImpl;
import programacion.database.Database;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String passwordCheck = request.getParameter("passwordCheck");

        if (!password.equals(passwordCheck)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Passwords do not match.");
            return;
        }

        Database database = new Database();
        try {

            database.connect();
            UserDao userDao = new UserDaoImpl(database.getConnection());
            boolean done = userDao.register(username, email, password, passwordCheck);

            if (!done) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("Registration failed.");
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", "user");

            response.getWriter().print("ok");

        } catch (SQLException sqle) {
            try {
                response.getWriter().println("No se ha podido conectar con la base de datos");
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
            sqle.printStackTrace();
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }

    }
}
