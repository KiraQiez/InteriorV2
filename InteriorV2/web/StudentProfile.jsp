<%@ include file="StudentHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Profile Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>
    
    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) { %>
        <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger" %>" role="alert">
            <%= message %>
        </div>
    <% } %>
    
    <div class="card mb-3">
        <div class="card-header">My Profile</div>
        <div class="card-body ">
            <div class="row">
                <div class="col-md-4">
                    <div class="card mb-3">
                        <div class="card-header">Profile Picture</div>
                        <div class="card-body text-center">
                            <img src="rsc/images/profilePic.png" alt="Profile Picture" class="profile-img">
                            <h4 class="mt-3">${user.username}</h4>
                            <p>${user.email}</p>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#changePictureModal">Change Picture</button>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">Edit Profile</button>
                        </div>
                    </div>
                </div>

                <sql:query var="student_data" dataSource="${myDatasource}">
                    SELECT * FROM STUDENT WHERE STDID = ?
                    <sql:param value="${user.userid}" />
                </sql:query>

                <div class="col-md-8 ">
                    <div class="card mb-3">
                        <div class="card-header">Personal Information</div>
                        <div class="card-body student-info" >
                            <c:choose>
                                <c:when test="${not empty student_data.rows}">
                                    <c:forEach var="student" items="${student_data.rows}">
                                        <p><strong>Student ID:</strong> <c:out value="${student.stdid}" default="Not Set" /></p>
                                        <p><strong>Name:</strong> <c:out value="${student.stdName}" default="Not Set" /></p>
                                        <p><strong>IC Number:</strong> <c:out value="${student.stdic}" default="Not Set" /></p>
                                        <p><strong>Phone Number:</strong> <c:out value="${student.stdphone}" default="Not Set" /></p>
                                        <p><strong>Address:</strong> <c:out value="${student.stdaddress}" default="Not Set" /></p>
                                        <p><strong>Income:</strong> RM <c:out value="${student.stdincome}" default="Not Set" /></p>
                                        <p><strong>Parent Contact No:</strong> <c:out value="${student.stdparentphonenum}" default="Not Set" /></p>
                                        <p><strong>Status:</strong> <c:out value="${student.stdstatus}" default="Not Set" /></p>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p>No student information found.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="EditProfileServlet" method="post">
                    <div class="modal-body">
                        <c:forEach var="student" items="${student_data.rows}">
                            <div class="mb-3">
                                <label for="name" class="form-label">Name</label>
                                <input type="text" class="form-control" id="name" name="name" value="${student.stdName}">
                            </div>
                            <div class="mb-3">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="text" class="form-control" id="phone" name="phone" value="${student.stdphone}">
                            </div>
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <input type="text" class="form-control" id="address" name="address" value="${student.stdaddress}">
                            </div>
                            <div class="mb-3">
                                <label for="income" class="form-label">Income</label>
                                <input type="text" class="form-control" id="income" name="income" value="${student.stdincome}">
                            </div>
                            <div class="mb-3">
                                <label for="parentPhone" class="form-label">Parent Contact No</label>
                                <input type="text" class="form-control" id="parentPhone" name="parentPhone" value="${student.stdparentphonenum}">
                            </div>
                        </c:forEach>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>
</div>
</div>
</body>
</html>
