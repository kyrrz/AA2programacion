package programacion.servlet;

import programacion.dao.DogDao;
import programacion.dao.DogDaoImpl;
import programacion.dao.UserDao;
import programacion.dao.UserDaoImpl;
import programacion.database.Database;
import programacion.model.Dog;
import programacion.model.User;

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

@WebServlet("/edit_user")
@MultipartConfig
public class EditUserServlet extends HttpServlet {

    private ArrayList<String> errors;

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        HttpSession currentSession = request.getSession();

        if (currentSession.getAttribute("role") == null || (currentSession.getAttribute("role").equals("anonymous"))) {
            response.sendRedirect("/shelter/login.jsp");
            return;
        }

        if (!validate(request)) {
            response.getWriter().println(errors.toString());
            return;
        }

        String action = request.getParameter("action");
        System.out.println(action);

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String birth_date = request.getParameter("birth_date");
        String canAdopt = request.getParameter("canAdopt");
        String rating = request.getParameter("rating");
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");



        //Part image = request.getPart("image");


        try {
           Database database = new Database();
           database.connect();
           UserDao userDao = new UserDaoImpl(database.getConnection());
           User user = new User();
           User userId = userDao.get(currentSession.getAttribute("username").toString());

           user.setId(userId.getId());
           user.setName(name);
           user.setEmail(email);
           user.setPhone(Integer.parseInt(phone));
           user.setCity(city);
           user.setBirth_date(Date.valueOf(birth_date));
           user.setCanAdopt(Boolean.parseBoolean(canAdopt));
           user.setRating(Double.parseDouble(rating));
           user.setRole(role);
           user.setUsername(username);
           user.setPassword(password);

           System.out.println(user);
           boolean done = userDao.modify(user);

            if (done) {
                response.getWriter().print("ok");
            } else {
                response.getWriter().print("No se ha podido guardar el usuario");
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
        if (request.getParameter("username").isEmpty()) {
            errors.add("El usuario es un campo obligatorio");
        }
        if ((request.getParameter("password").isEmpty())) {
            errors.add("Las contraseña esta vacia");
        }
        if ((!request.getParameter("password").equals(request.getParameter("passwordCheck")))) {
            errors.add("Las contraseñas no coinciden");
        }

        return errors.isEmpty();
    }
}
