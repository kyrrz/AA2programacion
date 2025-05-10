<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="programacion.model.Adoption" %>
<%@ page import="programacion.dao.*" %>
<%@ page import="programacion.model.User" %>


<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>



<%
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
        AdoptionDao adoptionDao = new AdoptionDaoImpl(database.getConnection());

        List<Adoption> adoptionList = null;
        try {
            adoptionList = adoptionDao.getAll(search);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        for (Adoption adoption : adoptionList) {
          DogDao dogDao = new DogDaoImpl(database.getConnection());
          Dog dog = dogDao.get(adoption.getId_dog());

          UserDao userDao = new UserDaoImpl(database.getConnection());
          User user = userDao.get(adoption.getId_user());

          System.out.println(adoption.getId_dog());
          System.out.println(dogDao.get(adoption.getId_dog()));
    %>
    <div class="col">
      <div class="card shadow-sm">
          <img class="img-thumbnail" src="/shelter_images/<%= dog.getImage() %>" style="width: 100%; height: 225px; object-fit: cover;">
        <div class="card-body">
         <h4 class="card-text"><%= adoption.getAdoption_date() %></h4>
         <p class="card-text">Perro: <%= dog.getName() %></p>
         <p class="card-text">Adoptado por: <%= user.getName() %></p>
         <p class="card-text">Observaciones: <%= adoption.getNotes() %></p>
         <div class="d-flex justify-content-between align-items-center">
           <div class="btn-group">
               <%
                   if (role.equals("anonymous")) {
               %>
               <a href="login.jsp" class="btn btn-sm btn-secondary">Log In</a>
             <%
                   } else if (role.equals("user")) {
             %>
               <a href="view_adoption.jsp?adoption_id=<%= adoption.getId() %>" class="btn btn-sm btn-secondary">Mas info</a>
             <%
                   } else if (role.equals("admin")) {
             %><a href="view_adoption.jsp?adoption_id=<%= adoption.getId() %>" class="btn btn-sm btn-secondary">Mas info</a>
             <a href="edit_adoption.jsp?adoption_id=<%= adoption.getId()%>" class="btn btn-sm btn-warning">Modificar</a>
             <a href="delete_adoption?adoption_id=<%= adoption.getId() %>" class="btn btn-sm btn-danger">Eliminar</a>
             <%
               }
             %>
           </div>
           <small class="text-body-secondary"> <%= adoption.getDonation() %> </small>
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
