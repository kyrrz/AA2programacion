<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.UserDaoImpl" %>
<%@ page import="programacion.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="programacion.dao.UserDao" %>
<%@ page import="java.sql.SQLException" %>

<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>
<script>
  function confirmDelete() {
    return confirm("¿Estás seguro de que quieres eliminar este usuario?");
  }
</script>
<%
  if ((currentSession.getAttribute("role") == null || !currentSession.getAttribute("role").equals("admin"))) {
    response.sendRedirect("/shelter/login.jsp");
  }

  String search = request.getParameter("search");
%>

<div class="album py-5 bg-body-tertiary">
  <div class="container mb-5">
    <form method="get" action="<%= request.getRequestURI() %>">
      <input type="text" name="search" id="search" class="form-control" placeholder="Buscar" value="<%= search != null ? search : "" %>">
    </form>
  </div>

  <div class="container">

    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
      <%
        Database database = new Database();
        try {
          database.connect();
        } catch (ClassNotFoundException | SQLException e) {
          throw new RuntimeException(e);
        }
          UserDao userDao = new UserDaoImpl(database.getConnection());

          List<User> userList = null;
          try {
              userList = userDao.getAll(search);
          } catch (SQLException e) {
              throw new RuntimeException(e);
          }
          for (User user : userList) {
      %>

        <div class="card shadow-sm">
          <div class="card-body">
            <h4 class="card-text"><%= user.getName() %></h4>
            <p class="card-text"><%= user.getUsername() %></p>
            <div class="d-flex justify-content-between align-items-center">
              <div class="btn-group">
                <a href="view_user.jsp?user_id=<%= user.getId() %>" class="btn btn-sm btn-secondary">Info</a>
                <a href="edit_admin_user.jsp?user_id=<%= user.getId() %>" class="btn btn-sm btn-warning">Admin</a>
                <a onclick="return confirmDelete()" href="delete_user?user_id=<%= user.getId() %>" class="btn btn-sm btn-danger">Eliminar</a>
              </div>
              <small class="text-body-secondary"> <%= user.getRole() %> </small>
            </div>
          </div>
        </div>

      <%
        }
      %>
    </div>
  </div>
</div>

<%@include file="includes/footer.jsp"%>
