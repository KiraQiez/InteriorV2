<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
    <style>
    body {
        background-image: url('rsc/images/mainbg2.svg');
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
                    <h2 class="card-title text-center mb-4">Login</h2>
                    <% 
                        String messsage = request.getParameter("message"); 
                        if (messsage != null) { 
                    %>
                        <div class="alert alert-danger" role="alert">
                            <%= messsage %>
                        </div>
                    <% } %>
                    
                    <% String message = (String) request.getAttribute("message"); %>
                    <% if (message != null) { %>
                        <div class="alert <%= message.contains("successful") ? "alert-success" : "alert-danger" %>" role="alert">
                            <%= message %>
                        </div>
                    <% } %>

                    <form action="LoginServlet" method="POST">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Login</button>
                        <div class="mt-3 text-center">
                            <p>Don't have an account? <a href="MainRegister.jsp">Register here</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js" integrity="sha384-eMN2JSg6EGcEGNdbt9H1DNWrPnnQ4lch2LkZbCxnH6DO0P2KUg+4WZyy8c+gPb0E" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12W8cFJF6F2nqToz8+Zf6Q8tMpoALewrNJ7CejL+dXGq1kcz" crossorigin="anonymous"></script>
</body>

</html>
