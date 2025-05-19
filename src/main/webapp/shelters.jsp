<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="programacion.dao.ShelterDao" %>
<%@ page import="programacion.dao.ShelterDaoImpl" %>
<%@ page import="programacion.model.Shelter" %>

<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>

<script>
  function confirmDelete() {
    return confirm("¿Estás seguro de que quieres eliminar este refugio?");
  }
</script>

<%
  String search = request.getParameter("search");
%>

<div class="album">
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
        ShelterDao shelterDao = new ShelterDaoImpl(database.getConnection());

        List<Shelter> shelterList = null;
        try {
          shelterList = shelterDao.getAll(search);
        } catch (SQLException e) {
          throw new RuntimeException(e);
        }

        for (Shelter shelter : shelterList) {

      %>
      <div class="col">
        <div class="card shadow-sm">

          <div class="card-body">
            <h4 class="card-text"><%= shelter.getName() %></h4>
            <p class="card-text"><%= shelter.getCity() %></p>
            <p class="card-text"><%= shelter.getAddress() %></p>
            <div class="d-flex justify-content-between align-items-center">
              <div class="btn-group">
                <a href="view_shelter.jsp?shelter_id=<%= shelter.getId() %>" class="btn btn-sm btn-secondary">Mas info</a>
                <%
                 if (role.equals("admin")) {
                %>
                <a href="edit_shelter.jsp?shelter_id=<%= shelter.getId()  %>" class="btn btn-sm btn-warning">Modificar</a>
                <a onclick="return confirmDelete()" href="delete_shelter?shelter_id=<%= shelter.getId()  %>" class="btn btn-sm btn-danger">Eliminar</a>
                <%
                  }
                %>
              </div>
              <small class="text-body-secondary"> <%= shelter.getRating() %> </small>
            </div>
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
