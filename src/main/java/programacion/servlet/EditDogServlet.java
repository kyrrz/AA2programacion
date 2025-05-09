package programacion.servlet;

import programacion.dao.DogDao;
import programacion.dao.DogDaoImpl;
import programacion.database.Database;
import programacion.model.Dog;

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

@WebServlet("/edit_dog")
@MultipartConfig
public class EditDogServlet extends HttpServlet {

    private ArrayList<String> errors;

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        HttpSession currentSession = request.getSession();
        if ((currentSession.getAttribute("role") == null) || (!currentSession.getAttribute("role").equals("admin"))) {
            response.sendRedirect("/shelter/login.jsp");
            return;
        }

        if (!validate(request)) {
            response.getWriter().println(errors.toString());
            return;
        }

        String action = request.getParameter("action");

        String shelterId = request.getParameter("id_shelter");
        String name = request.getParameter("name");
        String breed = request.getParameter("breed");
        String birth_date = request.getParameter("birth_date");
        String gender = request.getParameter("gender");
        String weight = request.getParameter("weight");
        String castrated = request.getParameter("castrated");
        Part image = request.getPart("image");


        try {
            Database database = new Database();
            database.connect();
            DogDao dogDao = new DogDaoImpl(database.getConnection());
            Dog dog = new Dog();
            dog.setId_shelter(Integer.parseInt(shelterId));
            dog.setName(name);
            dog.setBreed(breed);
            dog.setBirth_date(Date.valueOf(birth_date));
            dog.setGender(gender);
            dog.setWeight(Double.parseDouble(weight));
            dog.setCastrated(Boolean.parseBoolean(castrated));




            // Procesa la imagen del perro
            if (action.equals("Registrar")) {
                String filename = "default.jpg";
                String imagePath = "C:/Users/kyrrz/Desktop/apache-tomcat-9.0.104/webapps/shelter_images";
                if (image.getSize() != 0) {
                    filename = UUID.randomUUID() + ".jpg";    // TODO por ahora solamente soportamos jpg
                    // TODO Comprobar porque fallaba utilizar el contexto del servlet

                    InputStream inputStream = image.getInputStream();
                    Files.copy(inputStream, Path.of(imagePath + File.separator + filename));
                }

                dog.setImage(filename);
            } else {
                dog.setId(Integer.parseInt(request.getParameter("id")));
            }


            boolean done = false;
            if (action.equals("Registrar")) {
                done = dogDao.add(dog);
            } else {
                done = dogDao.modify(dog);
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
        if ((request.getParameter("weight").isEmpty()) || (!request.getParameter("weight").matches("[0-9][0-9].[0-9]*"))) {
            errors.add("El peso es un campo numérico");
        }
        // TODO más validaciones

        return errors.isEmpty();
    }
}
