<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="includes/header.jsp"%>

<script type="text/javascript">
  $(document).ready(function() {
    $("form").on("submit", function(event) {
      event.preventDefault();
      const formValue = $(this).serialize();
      $.ajax("register", {
        type: "POST",
        data: formValue,
        statusCode: {
          200: function(response) {
            console.log(response);
            if (response === "ok") {
              window.location.href = "/shelter";
            } else {
              $("#result").html("<div class='alert alert-danger' role='alert'>" + response + "</div>");
            }
          }
        }
      });
    });
  });
</script>

<main>
  <div class="container d-flex justify-content-center">
    <form>
      <h1 class="h3 mb-3 fw-normal">Iniciar sesión</h1>
      <div class="input-group mb-3">
        <input type="text" name="username" class="form-control" placeholder="Usuario">
      </div>

      <div class="input-group mb-3">
        <input type="password" name="password" class="form-control" placeholder="Contraseña">
      </div>

      <div class="input-group mb-3">
        <input class="btn btn-primary" type="submit" value="Iniciar sesión">
      </div>

      <div class="input-group mb-3">
        ¿No tienes usuario? <a href="register.jsp"> Regístrate aqui</a>
      </div>

      <div id="result"></div>
    </form>

  </div>

<%@include file="includes/footer.jsp"%>