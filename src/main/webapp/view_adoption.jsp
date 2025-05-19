<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="programacion.exception.DogNotFoundException" %>
<%@ page import="programacion.util.DateUtils" %>
<%@ page import="programacion.model.Adoption" %>
<%@ page import="programacion.exception.AdoptionNotFoundException" %>
<%@ page import="programacion.dao.*" %>
<%@ page import="programacion.model.User" %>

<%@ include file="includes/header.jsp"%>
<%@ include file="includes/navbar.jsp"%>
<div class="album">
    <script>
        function confirmDelete() {
            return confirm("¿Estás seguro de que quieres eliminar esta adopción?");
        }

    </script>
<%
    Database database = new Database();
    database.connect();
    AdoptionDao adoptionDao = new AdoptionDaoImpl(database.getConnection());
    DogDao dogDao = new DogDaoImpl(database.getConnection());
    UserDao userDao = new UserDaoImpl(database.getConnection());

    int adoptionId = Integer.parseInt(request.getParameter("adoption_id"));

    try {
        Adoption adoption = adoptionDao.getById(adoptionId);
        Dog dog = dogDao.get(adoption.getId_dog());
        User user = userDao.get(adoption.getId_user());


%>
<div class="container d-flex justify-content-center">
    <div class="card" style="width: 50rem;">
        <img class="img-thumbnail" src="/shelter_images/<%= dog.getImage() %>" style="width: 100%; height: auto">
        <div class="card-body">
            <h5 class="card-title fw-bold"><%= dog.getName() %></h5>
            <p class="card-text fw-normal"><%= dog.getBreed() %> <small class="fw-light fst-italic"> <%= dog.getGender()%></small></p>
        </div>
        <div class="card-body">
            <h5 class="card-title fw-bold"><%= user.getUsername() %></h5>
            <p class="card-text fw-normal"><%= user.getName() %> <small class="fw-light fst-italic"> <%= user.getCity()%></small></p>
        </div>
        <ul class=" list-group-flush ">
            <li class="list-group-item">Comentarios: <%= adoption.getNotes() %></li>
            <li class="list-group-item">Donation: <%= adoption.getDonation() %> Euros</li>
            <li class="list-group-item">Fecha de adopcion: <%= DateUtils.format(adoption.getAdoption_date()) %></li>
        </ul>
        <div class="card-body">
            <%
            if (role.equals("admin")) {
            %>
            <a href="edit_dog.jsp?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-warning">Editar Perro</a>
            <a href="edit_admin_user.jsp?user_id=<%= user.getId() %>" class="btn btn-sm btn-warning">Editar User</a>
            <a href="edit_adoption.jsp?adoption_id=<%= adoption.getId() %>" class="btn btn-sm btn-warning">Editar Adoption</a>
            <a onclick="return confirmDelete()" href="delete_dog?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-danger">Eliminar</a>
            <%
            } else {
            %>
            <a href="login.jsp" type="button" class="btn btn-warning">Log In</a>
            <%
                }
            %>

        </div>
    </div>
</div>
        </div>


<%
} catch (DogNotFoundException dnfe) {
%>
<%@ include file="includes/dog_not_found.jsp"%>
<%
    } catch (AdoptionNotFoundException anfe) {
%>
<%@ include file="includes/adoption_not_found.jsp"%>
<%
    }
%>
<%@ include file="includes/footer.jsp"%>
