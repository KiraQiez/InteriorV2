<%@ include file="StaffHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Session Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>

    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) {%>
    <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger"%> alert-dismissible fade show" role="alert">
        <%= message%>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%
            // Set the message attribute to null after displaying it
            request.setAttribute("message", null);
        } %>


    <div class="card mb-3">
        <div class="card-header">Session List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">

                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Session" onkeyup="searchSession()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>


                <div class="input-group" style="width: 300px;">
                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#sessionAddModal" 
                            data-bs-toggle="tooltip" title="Add Session">
                        <i class="fas fa-plus"></i>
                    </button>
                    <select id="statusFilter" class="form-select" onchange="filterSession()">
                        <option value="">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="INACTIVE">Inactive</option>
                    </select>
                </div>
            </div>

            <sql:query var="session_list" dataSource="${myDatasource}">
                SELECT * FROM SESSION ORDER BY sessionID
            </sql:query>

            <table class="table" id="sessionTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Session ID</th>
                        <th>Session Name</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty session_list.rows}">
                            <tr>
                                <td colspan="7">No session available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="session" items="${session_list.rows}">
                                <tr>
                                    <% count++;%>
                                    <td width="20px"><%= count%></td>
                                    <td>${session.sessionID}</td>
                                    <td>${session.sessionName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${session.sessionStatus == 'ACTIVE'}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:when test="${session.sessionStatus == 'INACTIVE'}">
                                                <span class="badge bg-danger">Inactive</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#sessionViewModal" 
                                                data-id="${session.sessionID}" data-name="${session.sessionName}" data-desc="${report.reportDesc}" 
                                                data-status="${session.sessionStatus}"data-bs-toggle="tooltip" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-edit" data-bs-toggle="modal" data-bs-target="#sessionEditModal" 
                                                data-id="${session.sessionID}" data-name="${session.sessionName}" data-desc="${report.reportDesc}" 
                                                data-status="${session.sessionStatus}"data-bs-toggle="tooltip" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <!--                                        <button type="button" class="btn btn-sm btn-delete ms-1" data-bs-toggle="tooltip" title="Disable"><i class="fas fa-trash"></i></button>-->
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <nav aria-label="Page navigation example">
                <ul class="pagination justify-content-center" id="pagination"></ul>
            </nav>
        </div>
        <!-- Add Session Modal -->
        <div class="modal fade" id="sessionAddModal" tabindex="-1" aria-labelledby="sessionAddModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="sessionAddModalLabel">Add Session</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="AddSessionServlet" method="POST">
                            <div class="mb-3">
                                <label for="sessionID" class="form-label">Session ID</label>
                                <input type="text" class="form-control" id="sessionID" name="sessionID">
                            </div>
                            <div class="mb-3">
                                <label for="sessionName" class="form-label">Session Name</label>
                                <input type="text" class="form-control" id="sessionName" name="sessionName">
                            </div>
                            <div class="mb-3">
                                <label for="sessionStatus" class="form-label">Session Status</label>
                                <select class="form-select" id="sessionStatus" name="sessionStatus">
                                    <option value="ACTIVE">Active</option>
                                    <option value="INACTIVE">Inactive</option>
                                </select>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <input type="submit" class="btn btn-primary" value="Submit">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>



        <!-- Edit Session Modal -->
        <div class="modal fade" id="sessionEditModal" tabindex="-1" aria-labelledby="sessionEditModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="sessionEditModalLabel">Edit Session</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="SessionChangeStatusServlet" method="POST">
                            <div class="mb-3">
                                <label for="sessionID" class="form-label">Session ID</label>
                                <input type="text" class="form-control" id="sessionID" name="sessionID" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="sessionName" class="form-label">Session Name</label>
                                <input type="text" class="form-control" id="sessionName" name="sessionName">
                            </div>
                            <div class="mb-3">
                                <label for="sessionStatus" class="form-label">Session Status</label>
                                <select class="form-select" id="sessionStatus" name="sessionStatus">
                                    <option value="ACTIVE">Active</option>
                                    <option value="INACTIVE">Inactive</option>
                                </select>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <input type="submit" class="btn btn-primary" value="Save changes">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- View Session Modal -->
        <div class="modal fade" id="sessionViewModal" tabindex="-1" aria-labelledby="sessionViewModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="sessionViewModalLabel">View Session</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="sessionID" class="form-label">Session ID</label>
                                <input type="text" class="form-control" id="sessionID" name="sessionID" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="sessionName" class="form-label">Session Name</label>
                                <input type="text" class="form-control" id="sessionName" name="sessionName" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="sessionStatus" class="form-label">Session Status</label>
                                <input type="text" class="form-control" id="sessionStatus" name="sessionStatus" readonly>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
</main>
</div>
</div>

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#sessionTable tbody tr");

    function changePage(page) {
        const pagination = document.getElementById("pagination");
        if (page < 1)
            page = 1;
        if (page > numPages())
            page = numPages();

        pagination.innerHTML = "";

        for (let i = 0; i < rows.length; i++) {
            rows[i].style.display = "none";
        }

        for (let i = (page - 1) * records_per_page; i < (page * records_per_page) && i < rows.length; i++) {
            rows[i].style.display = "";
        }

        if (page === 1) {
            pagination.innerHTML += '<li class="page-item disabled"><a class="page-link" href="javascript:prevPage();">Previous</a></li>';
        } else {
            pagination.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:prevPage();">Previous</a></li>';
        }

        for (let i = 1; i <= numPages(); i++) {
            if (i === page) {
                pagination.innerHTML += '<li class="page-item active"><a class="page-link" href="javascript:changePage(' + i + ');">' + i + '</a></li>';
            } else {
                pagination.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:changePage(' + i + ');">' + i + '</a></li>';
            }
        }

        if (page === numPages()) {
            pagination.innerHTML += '<li class="page-item disabled"><a class="page-link" href="javascript:nextPage();">Next</a></li>';
        } else {
            pagination.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:nextPage();">Next</a></li>';
        }
    }

    function numPages() {
        return Math.ceil(rows.length / records_per_page);
    }

    function prevPage() {
        if (current_page > 1) {
            current_page--;
            changePage(current_page);
        }
    }

    function nextPage() {
        if (current_page < numPages()) {
            current_page++;
            changePage(current_page);
        }
    }

    window.onload = function () {
        changePage(1);
    };

    function searchSession() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterSession(input);
    }

    function filterSession(input = '') {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#sessionTable tbody tr');
        rows.forEach(row => {
            const sessionName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const sessionStatus = row.querySelector('td:nth-child(4) .badge').textContent.toLowerCase();

            const matchesSearch = sessionName.includes(input);
            const matchesStatus = statusFilter === '' || sessionStatus === statusFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    var sessionViewModal = document.getElementById('sessionViewModal');
    sessionViewModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var sessionID = button.getAttribute('data-id');
        var sessionName = button.getAttribute('data-name');
        var sessionStatus = button.getAttribute('data-status');

        var modalID = sessionViewModal.querySelector('#sessionID');
        var modalName = sessionViewModal.querySelector('#sessionName');
        var modalStatus = sessionViewModal.querySelector('#sessionStatus');

        modalID.value = sessionID;
        modalName.value = sessionName;
        modalStatus.value = sessionStatus;
    });

    var sessionEditModal = document.getElementById('sessionEditModal');
    sessionEditModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var sessionID = button.getAttribute('data-id');
        var sessionName = button.getAttribute('data-name');
        var sessionStatus = button.getAttribute('data-status');

        var modalID = sessionEditModal.querySelector('#sessionID');
        var modalName = sessionEditModal.querySelector('#sessionName');
        var modalStatus = sessionEditModal.querySelector('#sessionStatus');

        modalID.value = sessionID;
        modalName.value = sessionName;
        modalStatus.value = sessionStatus;
    });
</script>
</body>
</html>