<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.DogDaoImpl" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="programacion.exception.DogNotFoundException" %>
<%@ page import="programacion.util.CurrencyUtils" %>
<%@ page import="programacion.util.DateUtils" %>
<%@ page import="programacion.dao.DogDao" %>
<%@ page import="programacion.dao.AdoptionDao" %>
<%@ page import="programacion.dao.AdoptionDaoImpl" %>
<%@ page import="programacion.model.Adoption" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="programacion.exception.AdoptionNotFoundException" %>

<%@ include file="includes/header.jsp"%>
<%@ include file="includes/navbar.jsp"%>

<%
    int adoptionId = Integer.parseInt(request.getParameter("adoption_id"));
    Database database = new Database();
    database.connect();
    AdoptionDao adoptionDao = new AdoptionDaoImpl(database.getConnection());
    DogDao dogDao = new DogDaoImpl(database.getConnection());
    try {

        Adoption adoption = adoptionDao.getById(adoptionId);
        Dog dog = dogDao.get(adoption.getId_dog());
%>
<div class="container d-flex justify-content-center">
    <div class="card" style="width: 50rem;">
        <img src="./images/<%= dog.getImage() %>" class="card-img-top" alt="...">
        <div class="card-body">
            <h5 class="card-title fw-bold"><%= dog.getName() %></h5>
            <p class="card-text fw-normal"><%= dog.getBreed() %> <small class="fw-light fst-italic"> <%= dog.getGender()%></small></p>
        </div>
        <ul class="list-group list-group-flush">
            <li class="list-group-item">Peso: <%= dog.getWeight() %></li>
            <li class="list-group-item">Castrado: <%= dog.isCastrated() %></li>
            <li class="list-group-item">Fecha de nacimiento: <%= DateUtils.format(dog.getBirth_date()) %></li>
        </ul>
        <div class="card-body">
            <%
                if (role.equals("user")) {
            %>
            <a href="#" type="button" class="btn btn-primary">Adoptar!</a>
            <%
            } else if (role.equals("admin")) {
            %>
            <a href="edit_dog.jsp?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-outline-warning">En Adopcion</a>
            <a href="delete_dog?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-outline-danger">Eliminar</a>
            <%
            } else {
            %>
            <a href="login.jsp" type="button" class="btn btn-warning">Adoptar!</a>
            <%
                }
            %>

        </div>
    </div>
</div>

<%
} catch (DogNotFoundException dnfe) {
%>
<%@ include file="includes/dog_not_found.jsp"%>
<%
    }
%>
<%@ include file="includes/footer.jsp"%>
