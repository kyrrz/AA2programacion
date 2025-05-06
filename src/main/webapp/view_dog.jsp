<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.DogDaoImpl" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="programacion.exception.DogNotFoundException" %>
<%@ page import="programacion.util.CurrencyUtils" %>
<%@ page import="programacion.util.DateUtils" %>

<%@ include file="includes/header.jsp"%>
<%@ include file="includes/navbar_users.jsp"%>

<%
  // TODO Controlar el fallo cuando dog_id no pueda parsearse como entero
  int dogId = Integer.parseInt(request.getParameter("dog_id"));
  Database database = new Database();
  database.connect();
  DogDaoImpl DogDaoImpl = new DogDaoImpl(database.getConnection());
  try {
    Dog dog = DogDaoImpl.get(dogId);
%>
<div class="container d-flex justify-content-center">
  <div class="card" style="width: 50rem;">
    <img src="./images/<%= dog.getImage() %>" class="card-img-top" alt="...">
    <div class="card-body">
      <h5 class="card-title"><%= dog.getName() %></h5>
      <p class="card-text"><%= dog.getBreed() %></p>
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
