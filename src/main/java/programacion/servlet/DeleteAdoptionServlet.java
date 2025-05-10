package programacion.servlet;

import programacion.dao.AdoptionDaoImpl;
import programacion.dao.AdoptionDao;
import programacion.database.Database;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/delete_adoption")
public class DeleteAdoptionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        HttpSession currentSession = request.getSession();
        if (currentSession.getAttribute("role") == null) {
            response.sendRedirect("/shelter/login.jsp");
            return;
        }

        String adoptionId = request.getParameter("adoption_id");
        // TODO Añadir validación

        try {
            Database db = new Database();
            db.connect();
            AdoptionDao adoptionDao = new AdoptionDaoImpl(db.getConnection());
            adoptionDao.delete(Integer.parseInt(adoptionId));

            response.sendRedirect("/shelter/adoptions.jsp");
        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
