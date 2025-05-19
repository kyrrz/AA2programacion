package programacion.servlet;

import programacion.dao.AdoptionDao;
import programacion.dao.AdoptionDaoImpl;
import programacion.database.Database;
import programacion.model.Adoption;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;


@WebServlet("/edit_adoption")
@MultipartConfig
public class EditAdoptionServlet extends HttpServlet {

    private ArrayList<String> errors;

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        HttpSession currentSession = request.getSession();
        if ((currentSession.getAttribute("role") == null) || (!currentSession.getAttribute("role").equals("admin"))) {
            response.sendRedirect("/shelter/login.jsp");
        }

        if (!validate(request)) {
            response.getWriter().println(errors.toString());
            return;
        }

        String action = request.getParameter("action");

        String dogId = request.getParameter("id_dog");
        String userId = request.getParameter("id_user");
        String adoption_date = request.getParameter("adoption_date");
        String acceptedParam = request.getParameter("accepted");
        String donation = request.getParameter("donation");
        String notes  = request.getParameter("notes");
        boolean accepted = "on".equals(acceptedParam) || "1".equals(acceptedParam) || "true".equals(acceptedParam);

        try {
            Database database = new Database();
            database.connect();
            AdoptionDao adoptionDao = new AdoptionDaoImpl(database.getConnection());
            Adoption adoption = new Adoption();
            adoption.setId_dog(Integer.parseInt(dogId));
            adoption.setId_user(Integer.parseInt(userId));
            adoption.setAdoption_date(Date.valueOf(adoption_date));
            adoption.setAccepted(accepted);
            adoption.setDonation(Double.parseDouble(donation));
            adoption.setNotes(notes);




            // Procesa la imagen del perro
            if (action.equals("Modificar")) {
                adoption.setId(Integer.parseInt(request.getParameter("id")));
            }


            boolean done = false;
            if (action.equals("Registrar")) {
                done = adoptionDao.add(adoption);
            } else {
                done = adoptionDao.modify(adoption);
            }

            if (done) {
                response.getWriter().print("ok");
            } else {
                response.getWriter().print("No se ha podido guardar el perro");
            }
        } catch (SQLException sqle) {
            response.getWriter().println("No se ha podido conectar con la base de datos");
            sqle.printStackTrace();
        } catch (ClassNotFoundException cnfe) {
            response.getWriter().println("No se ha podido cargar el driver de la base de datos");
            cnfe.printStackTrace();
        } catch (IOException ioe) {
            response.getWriter().println("Error no esperado: " + ioe.getMessage());
            ioe.printStackTrace();
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private boolean validate(HttpServletRequest request) {
        errors = new ArrayList<>();
        if (request.getParameter("id_dog").isEmpty()) {
            errors.add("El Dog ID es un campo obligatorio");
        }
        if ((request.getParameter("id_user").isEmpty())) {
            errors.add("El User ID es un campo obligatorio");
        }
        // TODO más validaciones

        return errors.isEmpty();
    }
}
