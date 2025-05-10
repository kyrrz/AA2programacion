<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.ShelterDaoImpl" %>
<%@ page import="programacion.model.Shelter" %>
<%@ page import="programacion.exception.ShelterNotFoundException" %>
<%@ page import="programacion.util.DateUtils" %>
<%@ page import="programacion.dao.ShelterDao" %>
<%@ page import="java.sql.SQLException" %>

<%@ include file="includes/header.jsp"%>
<%@ include file="includes/navbar.jsp"%>
<div class="album py-5 bg-body-tertiary">
  <div class="container">
    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
<%
  int shelterId = Integer.parseInt(request.getParameter("shelter_id"));
  Database database = new Database();
  database.connect();
  ShelterDao shelterDao = new ShelterDaoImpl(database.getConnection());
  try {
      Shelter shelter = null;
      try {
          shelter = shelterDao.get(shelterId);
      } catch (SQLException e) {
          throw new RuntimeException(e);
      }
%>
<div class="container d-flex justify-content-center">
  <div class="card" style="width: 50rem;">
    <div class="card-body">
      <h5 class="card-title fw-bold"><%= shelter.getName() %></h5>
      <p class="card-text fw-normal"><%= shelter.getCity() %> <small class="fw-light fst-italic"> <%= shelter.getRating()%></small></p>
    </div>
    <ul class="list-group list-group-flush">
      <li class="list-group-item">Address: <%= shelter.getAddress() %></li>
      <li class="list-group-item">Activo: <%= shelter.isActive() %></li>
      <li class="list-group-item">Fecha de creacion: <%= DateUtils.format(shelter.getFoundation_date()) %></li>
    </ul>
    <div class="card-body">
      <%
        if (role.equals("user")) {
      %>
      <a href="#" type="button" class="btn btn-primary disabled">Contactar</a>
      <%
      } else if (role.equals("admin")) {
      %>
      <div class="btn-group d-flex justify-content-between" role="group" aria-label="Basic example">
      <a href="edit_shelter.jsp?shelter_id=<%= shelter.getId() %>" class="btn btn-sm btn-warning">Editar</a>
      <a href="delete_shelter?shelter_id=<%= shelter.getId() %>" class="btn btn-sm btn-danger">Eliminar</a>
      </div>
      <%
      } else {
      %>
      <a href="login.jsp" type="button" class="btn btn-warning">Contactar</a>
      <%
        }
      %>

    </div>
  </div>
</div>
    </div>
  </div>
</div>

<%
} catch (ShelterNotFoundException snfe) {
%>
<%@ include file="includes/shelter_not_found.jsp"%>
<%
  }
%>
<%@ include file="includes/footer.jsp"%>
