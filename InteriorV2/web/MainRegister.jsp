<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
    <style>
    body {
        background-image: url('rsc/images/mainbg.svg');
        background-size: cover;
        background-repeat: no-repeat;
        background-color: #f8f9fa;
    }
    .card {
        background-color: rgba(255, 255, 255, 0.9);
        border: none;
        border-radius: 1rem;
    }
    .logo img {
        width: 50px;
        height: 50px;
    }
    .logo h2 {
        margin-left: 0.5rem;
        font-weight: bold;
    }
    </style>
</head>

<body class="d-flex align-items-center min-vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm p-4">
                    <div class="logo d-flex align-items-center mb-4">
                        <img src="rsc/images/logo.svg" alt="logo">
                        <h2 class="ms-3">INTERIOR</h2>
                    </div>
                    <h2 class="card-title text-center mb-4">Register</h2>
                    <% String message = (String) request.getSession().getAttribute("message"); %>
                    <% if (message != null) { %>
                        <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-danger" %> alert-dismissible fade show" role="alert">
                            <%= message %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <%
                            request.getSession().removeAttribute("message");
                        %>
                    <% } %>
                    <form action="RegisterServlet" method="post">

                        <div class="form-floating mb-3">
                            <input type="email" class="form-control" id="floatingInput" name="email"
                                placeholder="name@example.com" required>
                            <label for="floatingInput">Email address</label>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="floatingInput" name="fullname"
                                placeholder="Full Name" required>
                            <label for="floatingInput">Full Name</label>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="floatingInput" name="ic"
                                placeholder="IC Number" required>
                            <label for="floatingInput">IC Number</label>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="floatingInput" name="username"
                                placeholder="Username" required>
                            <label for="floatingInput">Username</label>
                        </div>

                        <div class="form-floating mb-5">
                            <input type="password" class="form-control" id="floatingPassword" name="password" placeholder="Password" required>
                            <label for="floatingPassword">Password</label>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Register</button>
                        <div class="mt-3 text-center">
                            <p>Already have an account? <a href="MainLogin.jsp">Login here</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>

</html>
