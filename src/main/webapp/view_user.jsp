<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.model.User" %>
<%@ page import="programacion.exception.UserNotFoundException" %>
<%@ page import="programacion.util.DateUtils" %>
<%@ page import="programacion.dao.*" %>
<%@ page import="programacion.model.Dog" %>

<%@ include file="includes/header.jsp"%>
<%@ include file="includes/navbar_users.jsp"%>

<script>
    function confirmDelete() {
        return confirm("¿Estás seguro de que quieres eliminar este usuario?");
    }
</script>

<div class="album py-5 bg-body-tertiary">
    <div class="container">
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
<%
    int userId = Integer.parseInt(request.getParameter("user_id"));
    Database database = new Database();
    database.connect();
    UserDaoImpl UserDaoImpl = new UserDaoImpl(database.getConnection());
    try {
        User user = UserDaoImpl.get(userId);
        AdoptionDao adoptionDao = new AdoptionDaoImpl(database.getConnection());
        int adoptionNumber = adoptionDao.getAdoptionsByUserId(userId);
        Dog dog = null;


%>
<div class="container d-flex justify-content-center">
    <div class="card" style="width: 50rem;">
        <div class="card-body">
            <h5 class="card-title"><%=user.getUsername()%></h5>
            <p class="card-text"><%=user.getName()%></p>
        </div>
        <ul class="list-group list-group-flush">
            <li class="list-group-item">Email: <%=user.getEmail()%></li>
            <li class="list-group-item">City: <%=user.getCity()%></li>
            <li class="list-group-item">Fecha de nacimiento: <%=DateUtils.format(user.getBirth_date())%></li>
            <li class="list-group-item">Rating: <%=user.getRating()%></li>
            <li class="list-group-item">Role: <%=user.getRole()%></li>
            <li class="list-group-item">Number of adoptions: <%=adoptionNumber%></li>
        </ul>
        <div class="card-body">
            <%
                if (role.equals("user")) {
            %>
            <a href="#" type="button" class="btn btn-primary">Adoptar</a>
            <%
            } else if (role.equals("admin")) {
            %>
            <a href="edit_user.jsp?user_id=<%=user.getId()%>" class="btn btn-sm btn-warning">Edit</a>
            <a onclick="return confirmDelete()" href="delete_user?user_id=<%=user.getId()%>" class="btn btn-sm btn-danger">Eliminar</a>
            <%
            } else {
            %>
            <a href="login.jsp" type="button" class="btn btn-secondary">Log in</a>
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
} catch (UserNotFoundException unfe) {
%>
<%@ include file="includes/user_not_found.jsp"%>
<%
    }
%>
<%@ include file="includes/footer.jsp"%>
