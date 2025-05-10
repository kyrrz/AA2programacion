<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.model.Adoption" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="programacion.exception.AdoptionNotFoundException" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="programacion.dao.*" %>
<%@ page import="programacion.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>

<!-- TODO Retringir acceso a los no administradores -->
<%
    if ((currentSession.getAttribute("role") == null) || (!currentSession.getAttribute("role").equals("admin"))) {
        response.sendRedirect("/shelter/login.jsp");
    }

    String action;
    Adoption adoption = null;
    String adoptionId = request.getParameter("adoption_id");
    System.out.println("Adoption id :" + adoptionId);

    Dog dog = null;
    if (adoptionId != null) {
        action = "Modificar";
        Database database = new Database();
        try {
            database.connect();
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException(e);
        }
        AdoptionDao adoptionDao = new AdoptionDaoImpl(database.getConnection());
        try {
            adoption = adoptionDao.getById(Integer.parseInt(adoptionId));
            DogDao dogDao = new DogDaoImpl(database.getConnection());
            dog = dogDao.get(adoption.getId_dog());
        } catch (SQLException | AdoptionNotFoundException e) {
            throw new RuntimeException(e);
        }
    } else {
        action = "Registrar";
    }

    String dogImage;
    if (dog == null) {
        dogImage = "default.jpg";
    } else {
        dogImage = dog.getImage();
    }

%>

<script type="text/javascript">
  $(document).ready(function() {
    $("form").on("submit", function(event) {
      event.preventDefault();
      const form = $("#adoption-form")[0];
      const formValue = new FormData(form);
      console.log(formValue);
      $.ajax({
        url: "edit_adoption",
        type: "POST",
        enctype: "multipart/form-data",
        data: formValue,
        processData: false,
        contentType: false,
        cache: false,
        timeout: 10000,
        statusCode: {
          200: function(response) {
            console.log(response);
            if (response === "ok") {
              // TODO Limpiar el formulario?
              $("#result").html("<div class='alert alert-success' role='alert'>" + response + "</div>");
            } else {
              $("#result").html("<div class='alert alert-danger' role='alert'>" + response + "</div>");
            }
          },
          404: function(response) {
            $("#result").html("<div class='alert alert-danger' role='alert'>Error al enviar los datos</div>");
          },
          500: function(response) {
            console.log(response);
            $("#result").html("<div class='alert alert-danger' role='alert'>" + response.toString() + "</div>");
          }
        }
      });
    });
  });


  function confirmModify() {
      return confirm("¿Estás seguro de que quieres modificar esta adopción?");
  }

</script>
<div class="container d-flex justify-content-center">
  <div class="card" style="width: 50rem;">
    <img class="img-thumbnail" src="/shelter_images/<%= dogImage%>" style="width: 100%; height: auto;">
    <form class="row g-2 p-5" id="adoption-form" method="post" enctype="multipart/form-data">
      <h1 class="h3 mb-3 fw-normal"><%=action%> una adopcion</h1>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="id_dog" class="form-control" placeholder="Dog Id"
               value="<%=adoption != null ? adoption.getId_dog() : ""%>">
          <label for="floatingTextarea">Dog ID</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="id_user" class="form-control" placeholder="User Id"
               value="<%=adoption != null ? adoption.getId_user() : ""%>">
          <label for="floatingTextarea">User ID</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="date" id="floatingTextarea" name="adoption_date" class="form-control" placeholder="Adoption Date"
               value="<%=adoption != null ? adoption.getAdoption_date() : ""%>">
          <label for="floatingTextarea">Fecha de adopcion</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="accepted" class="form-control" placeholder="Aceptado"
               value="<%=adoption != null ? adoption.isAccepted() : ""%>">
          <label for="floatingTextarea">Aceptada? (true/false)</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="donation" class="form-control" placeholder="Donation"
               value="<%=adoption != null ? adoption.getDonation() : ""%>">
          <label for="floatingTextarea">Donacion</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="notes" class="form-control" placeholder="Notes"
               value="<%=adoption != null ? adoption.getNotes() : ""%>">
          <label for="floatingTextarea">Notas</label>
      </div>


      <div class="input-group mb-3">
        <input onclick="return confirmModify()" class="btn btn-primary" type="submit" value="Guardar">
      </div>

      <input type="hidden" name="action" value="<%=action%>">
        <div id="result"></div>
        <table class="table table-striped table-bordered mt-4">
            <thead class="table-dark">
            <tr>
                <th scope="col">Dog Id</th>
                <th scope="col">Dog Name</th>
            </tr>
            </thead>
            <tbody>
            <%
                Database db = new Database();
                try {
                    db.connect();
                } catch (ClassNotFoundException | SQLException e) {
                    throw new RuntimeException(e);
                }
                DogDao dogDao = new DogDaoImpl(db.getConnection());
                UserDao userDao = new UserDaoImpl(db.getConnection());
                List<Dog> dogList = dogDao.getNonAdopted();
                for (Dog dogL : dogList) {

            %>
            <tr>
                <td><%= dogL.getId() %></td>
                <td><%= dogL.getName() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <table class="table table-striped table-bordered mt-4">
            <thead class="table-dark">
            <tr>
                <th scope="col">User Id</th>
                <th scope="col">Username</th>
                <th scope="col">Name</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<User> userList = userDao.getAll();
                for (User userL : userList) {

            %>
            <tr>
                <td><%= userL.getId() %></td>
                <td><%= userL.getUsername() %></td>
                <td><%= userL.getName() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
      <%
          if (action.equals("Modificar")) {
      %>
      <input type="hidden" name="id" value="<%=Integer.parseInt(adoptionId)%>">
      <%
          }
      %>


    </form>
  </div>
</div>

<%@include file="includes/footer.jsp"%>
