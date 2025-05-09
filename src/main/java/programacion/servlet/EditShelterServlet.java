package programacion.servlet;

import programacion.dao.ShelterDao;
import programacion.dao.ShelterDaoImpl;
import programacion.database.Database;
import programacion.model.Shelter;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

@WebServlet("/edit_shelter")
@MultipartConfig
public class EditShelterServlet extends HttpServlet {

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

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String number = request.getParameter("number");
        String foundation_date = request.getParameter("foundation_date");
        String rating = request.getParameter("rating");
        String active = request.getParameter("active");



        try {
            Database database = new Database();
            database.connect();
            ShelterDao shelterDao = new ShelterDaoImpl(database.getConnection());
            Shelter shelter = new Shelter();
            shelter.setName(name);
            shelter.setAddress(address);
            shelter.setCity(city);
            shelter.setNumber(Integer.parseInt(number));
            shelter.setFoundation_date(Date.valueOf(foundation_date));
            shelter.setRating(Double.parseDouble(rating));
            shelter.setActive(Boolean.parseBoolean(active));

            if (action.equals("Modificar")) {
                shelter.setId(Integer.parseInt(request.getParameter("id")));
            }


            boolean done = false;
            if (action.equals("Registrar")) {
                done = shelterDao.add(shelter);
            } else {
                done = shelterDao.modify(shelter);
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
        if (request.getParameter("name").isEmpty()) {
            errors.add("El nombre es un campo obligatorio");
        }
        if (request.getParameter("city").isEmpty()) {
            errors.add("La ciudad es un campo obligatorio");
        }
        // TODO más validaciones

        return errors.isEmpty();
    }
}
