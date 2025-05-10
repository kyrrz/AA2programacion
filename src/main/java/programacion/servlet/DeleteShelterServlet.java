package programacion.servlet;

import programacion.dao.ShelterDao;
import programacion.dao.ShelterDaoImpl;
import programacion.database.Database;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/delete_shelter")
public class DeleteShelterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        HttpSession currentSession = request.getSession();
        if (currentSession.getAttribute("role") == null) {
            response.sendRedirect("/shelter/login.jsp");
            return;
        }

        String shelterId = request.getParameter("shelter_id");
        // TODO Añadir validación

        try {
            Database db = new Database();
            db.connect();
            ShelterDao shelterDao = new ShelterDaoImpl(db.getConnection());
            shelterDao.delete(Integer.parseInt(shelterId));
            // TODO Borrar también la foto

            response.sendRedirect("/shelter");
        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
