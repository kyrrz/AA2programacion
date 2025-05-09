package programacion.servlet;

import programacion.dao.DogDaoImpl;
import programacion.dao.DogDao;
import programacion.dao.UserDao;
import programacion.dao.UserDaoImpl;
import programacion.database.Database;
import programacion.model.Dog;
import programacion.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/delete_user")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        HttpSession currentSession = request.getSession();
        if (currentSession.getAttribute("role") == null) {
            response.sendRedirect("/shelter/login.jsp");
            return;
        }

        String userId = request.getParameter("user_id");
        // TODO Añadir validación

        try {
            Database database = new Database();
            database.connect();
            UserDao userDao = new UserDaoImpl(database.getConnection());
            User user = userDao.get(Integer.parseInt(userId));
            System.out.println(user);
            System.out.println(currentSession.getAttribute("username"));
            if (currentSession.getAttribute("username").equals(user.getUsername())) {
                userDao.delete(Integer.parseInt(userId));
                response.sendRedirect("/shelter");
                currentSession.invalidate();
            } else {
                userDao.delete(Integer.parseInt(userId));
                response.sendRedirect("/shelter/users.jsp");
            }


        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
