<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.DogDao" %>
<%@ page import="programacion.dao.DogDaoImpl" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="programacion.exception.DogNotFoundException" %>
<%@ page import="programacion.dao.ShelterDao" %>
<%@ page import="programacion.dao.ShelterDaoImpl" %>
<%@ page import="programacion.model.Shelter" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>


<%
    if ((currentSession.getAttribute("role") == null) || (!currentSession.getAttribute("role").equals("admin"))) {
        response.sendRedirect("/shelter/login.jsp");
    }

    String action;
    Dog dog = null;
    Shelter shelter = null;
    String dogId = request.getParameter("dog_id");
    System.out.println("Dog id :" + dogId);

    if (dogId != null) {
        action = "Modificar";
        Database database = new Database();
        try {
            database.connect();
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException(e);
        }
        DogDao dogDao = new DogDaoImpl(database.getConnection());
        try {
            dog = dogDao.get(Integer.parseInt(dogId));
        } catch (SQLException | DogNotFoundException e) {
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
      const form = $("#dog-form")[0];
      const formValue = new FormData(form);
      console.log(formValue);
      $.ajax({
        url: "edit_dog",
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
      return confirm("¿Estás seguro de que quieres modificar este perro?");
  }
</script>

<div class="container d-flex justify-content-center">
  <div class="card" style="width: 50rem;">
    <img class="img-thumbnail" src="/shelter_images/<%=dogImage%>" style="width: 100%; height: auto;">
    <form class="row g-2 p-5" id="dog-form" method="post" enctype="multipart/form-data">
      <h1 class="h3 mb-3 fw-normal"><%=action%> un perro</h1>
      <div class="form-floating col-md-6">
          <select class="form-control" id="floatingTextarea" name="id_shelter" required>
              <option value="" disabled selected> Selecciona el refugio </option>
                  <%
                      Database db = new Database();
                      try {
                          db.connect();
                      } catch (ClassNotFoundException | SQLException e) {
                          throw new RuntimeException(e);
                      }
                      ShelterDao shelterDao = new ShelterDaoImpl(db.getConnection());
                      List<Shelter> shelterList = shelterDao.getAll();
                      for (Shelter shelterL : shelterList) {
                  %>
              <option value="<%=shelterL.getId() %>"><%= shelterL.getId() %>, <%= shelterL.getName() %> </option>

                  <% } %>

          </select>
          <label for="shelterSelect">Refugio</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="name" class="form-control" placeholder="Nombre"
               value="<%=dog != null ? dog.getName() : ""%>">
          <label for="floatingTextarea">Nombre</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="breed" class="form-control" placeholder="raza"
               value="<%=dog != null ? dog.getBreed() : ""%>">
          <label for="floatingTextarea">Raza</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="gender" class="form-control" placeholder="genero"
               value="<%=dog != null ? dog.getGender() : ""%>">
          <label for="floatingTextarea">Genero</label>
      </div>
      <div class="form-floating col-md-6">
        <input type="date" id="floatingTextarea" name="birth_date" class="form-control" placeholder="fecha de nacimiento"
               value="<%=dog != null ? dog.getBirth_date() : ""%>">
          <label for="floatingTextarea">Fecha de nacimiento</label>
      </div>

      <div class="form-floating col-md-6">
        <input type="file" id="floatingTextarea" name="image" class="form-control" placeholder="Imagen">
          <label for="floatingTextarea">Imagen</label>
      </div>

      <div class="form-floating col-md-6">
        <input type="text" id="floatingTextarea" name="weight" class="form-control" placeholder="Weight"
               value="<%=dog != null ? dog.getWeight() : ""%>">
          <label for="floatingTextarea">Peso</label>
      </div>


        <div class="col-md-6 d-flex align-items-center justify-content-center">
            <div class="form-check">
                <input id="activebox" class="form-check-input" type="checkbox" name="castrated"
                    <%= dog != null && dog.isCastrated() ? "checked" : "" %>>
                <label class="form-check-label" for="activebox"> Castrado</label>
            </div>
        </div>


        <div class="input-group mb-3">
        <input onclick="return confirmModify()" class="btn btn-primary rounded-pill" type="submit" value="Guardar">
      </div>

      <input type="hidden" name="action" value="<%=action%>">
        <div id="result"></div>

      <%
          if (action.equals("Modificar")) {
      %>
      <input type="hidden" name="id" value="<%=Integer.parseInt(dogId)%>">
      <%
          }
      %>


    </form>
  </div>
</div>

<%@include file="includes/footer.jsp"%>
