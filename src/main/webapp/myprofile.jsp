<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.DogDaoImpl" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="programacion.exception.DogNotFoundException" %>
<%@ page import="programacion.util.CurrencyUtils" %>
<%@ page import="programacion.util.DateUtils" %>
<%@ page import="programacion.dao.DogDao" %>
<%@ page import="programacion.dao.UserDao" %>
<%@ page import="programacion.dao.UserDaoImpl" %>
<%@ page import="programacion.model.User" %>
<%@ page import="programacion.exception.UserNotFoundException" %>

<%@ include file="includes/header.jsp"%>
<%@ include file="includes/navbar.jsp"%>

<div class="album py-5 bg-body-tertiary">
  <div class="container">
<%
  String username = currentSession.getAttribute("username").toString();
  Database database = new Database();
  database.connect();
  UserDao userDao = new UserDaoImpl(database.getConnection());
  try {
    User user = userDao.get(username);
%>
<div class="container d-flex justify-content-center w-50">
  <div class="card" style="width: 50rem;">
    <div class="card-body">
      <h5 class="card-title fw-bold"><%= user.getUsername() %></h5>
      <p class="card-text fw-normal"><%= user.getCity() %> <small class="fw-light fst-italic"> <%= user.getRating()%></small></p>
    </div>
    <ul class="list-group list-group-flush">
      <li class="list-group-item">Nombre: <%= user.getName() %></li>
      <li class="list-group-item">Email: <%= user.getEmail() %></li>
      <li class="list-group-item">Fecha de nacimiento: <%= DateUtils.format( user.getBirth_date()) %></li>
    </ul>
    <div class="card-body">
      <%
        if (role.equals("user")) {
      %>
      <a href="/shelter/edit_user.jsp" type="button" class="btn btn-primary">Edit</a>
      <%
      } else if (role.equals("admin")) {
      %>
      <a href="/shelter/edit_user.jsp" type="button" class="btn btn-primary">Edit</a>
      <%
      } else {
      %>
      <a href="login.jsp" type="button" class="btn btn-warning">Login</a>
      <%
        }
      %>

    </div>
  </div>
</div>
  </div>
</div>

<%
} catch (UserNotFoundException dnfe) {
%>
<%@ include file="includes/dog_not_found.jsp"%>
<%
  }
%>
<%@ include file="includes/footer.jsp"%>
