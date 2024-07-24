<%@ include file="StaffHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Staff Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>
    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) { %>
    <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger" %> alert-dismissible fade show" role="alert">
        <%= message %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
    <div class="card mb-3">
        <div class="card-header">Staff List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addStaffModal">Add Staff</button>
                
                <div class="d-flex">
                    <div class="input-group me-2" style="width: 300px;">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search Staff" onkeyup="searchStaff()">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                    </div>
                    <div class="input-group" style="width: 300px;">
                        <sql:query var="staff_list" dataSource="${myDatasource}">
                            SELECT DISTINCT staffType FROM STAFF
                        </sql:query>
                        <select id="staffFilter" class="form-select" onchange="filterStaff()">
                            <option value="">All Staff</option>
                            <c:forEach var="staff" items="${staff_list.rows}">
                                <option value="${staff.staffType}">${staff.staffType}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <sql:query var="staff_list" dataSource="${myDatasource}">
                SELECT s.staffID, s.staffName, s.staffType, u.username, u.email 
                FROM STAFF s 
                JOIN USERS u ON s.staffID = u.userID 
                ORDER BY s.staffID
            </sql:query>

            <table class="table" id="staffTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Staff ID</th>
                        <th>Full Name</th>
                        <th>Type</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty staff_list.rows}">
                            <tr>
                                <td colspan="7">No staff available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="staff" items="${staff_list.rows}">
                                <tr>
                                    <% count++; %>
                                    <td width="20px"><%= count %></td>
                                    <td>${staff.staffID}</td>
                                    <td>${staff.staffName}</td>
                                    <td>${staff.staffType}</td>
                                    <td>${staff.username}</td>
                                    <td>${staff.email}</td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#viewStaffModal"
                                                data-staff-id="${staff.staffID}" data-staff-name="${staff.staffName}" 
                                                data-staff-username="${staff.username}" data-staff-email="${staff.email}"
                                                data-staff-type="${staff.staffType}" data-staff-password="********" data-bs-toggle="tooltip" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-edit ms-1" data-bs-toggle="modal" data-bs-target="#editStaffModal"
                                                data-staff-id="${staff.staffID}" data-staff-name="${staff.staffName}" 
                                                data-staff-username="${staff.username}" data-staff-email="${staff.email}"
                                                data-staff-type="${staff.staffType}" data-staff-password="********" data-bs-toggle="tooltip" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-delete ms-1" data-bs-toggle="modal" data-bs-target="#deleteStaffModal"
                                                data-staff-id="${staff.staffID}" data-bs-toggle="tooltip" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
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
    </div>
</main>
</div>
</div>

<!-- Add Staff Modal -->
<div class="modal fade" id="addStaffModal" tabindex="-1" aria-labelledby="addStaffModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addStaffModalLabel">Add Staff</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addStaffForm" action="AddStaffServlet" method="post">
                    <div class="mb-3">
                        <label for="staffName" class="form-label">Full Name</label>
                        <input type="text" id="staffName" name="staffName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="staffEmail" class="form-label">Email</label>
                        <input type="email" id="staffEmail" name="staffEmail" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="staffUsername" class="form-label">Username</label>
                        <input type="text" id="staffUsername" name="staffUsername" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="staffPassword" class="form-label">Password</label>
                        <input type="password" id="staffPassword" name="staffPassword" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="staffType" class="form-label">Type</label>
                        <select id="staffType" name="staffType" class="form-select" required>
                            <option value="">Select Type</option>
                            <option value="Admin">Admin</option>
                            <option value="Manager">Manager</option>
                            <option value="Cleaner">Cleaner</option>
                            <option value="Maintenance">Maintenance</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Staff</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- View Staff Modal -->
<div class="modal fade" id="viewStaffModal" tabindex="-1" aria-labelledby="viewStaffModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewStaffModalLabel">View Staff</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label for="viewStaffID" class="form-label">Staff ID</label>
                        <input type="text" class="form-control" id="viewStaffID" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewStaffName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="viewStaffName" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewStaffUsername" class="form-label">Username</label>
                        <input type="text" class="form-control" id="viewStaffUsername" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewStaffEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="viewStaffEmail" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewStaffType" class="form-label">Type</label>
                        <input type="text" class="form-control" id="viewStaffType" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewStaffPassword" class="form-label">Password</label>
                        <input type="text" class="form-control" id="viewStaffPassword" readonly>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Edit Staff Modal -->
<div class="modal fade" id="editStaffModal" tabindex="-1" aria-labelledby="editStaffModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editStaffModalLabel">Edit Staff</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="EditStaffServlet" method="post">
                    <input type="hidden" class="form-control" id="editStaffID" name="staffID">
                    <div class="mb-3">
                        <label for="editStaffName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="editStaffName" name="staffName">
                    </div>
                    <div class="mb-3">
                        <label for="editStaffUsername" class="form-label">Username</label>
                        <input type="text" class="form-control" id="editStaffUsername" name="staffUsername">
                    </div>
                    <div class="mb-3">
                        <label for="editStaffEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="editStaffEmail" name="staffEmail">
                    </div>
                    <div class="mb-3">
                        <label for="editStaffType" class="form-label">Type</label>
                        <select class="form-select" id="editStaffType" name="staffType">
                            <option value="Admin">Admin</option>
                            <option value="Manager">Manager</option>
                            <option value="Cleaner">Cleaner</option>
                            <option value="Maintenance">Maintenance</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editStaffPassword" class="form-label">Password</label>
                        <input type="password" class="form-control" id="editStaffPassword" name="staffPassword">
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

<!-- Delete Staff Modal -->
<div class="modal fade" id="deleteStaffModal" tabindex="-1" aria-labelledby="deleteStaffModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteStaffModalLabel">Delete Staff</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this staff member?</p>
                <input type="hidden" class="form-control" id="deleteStaffID">
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                    <button type="button" class="btn btn-danger" onclick="confirmDeleteStaff()">Yes</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#staffTable tbody tr");

    function changePage(page) {
        const pagination = document.getElementById("pagination");
        if (page < 1) page = 1;
        if (page > numPages()) page = numPages();

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
        initializeTooltips();
    };

    function initializeTooltips() {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }

    function searchStaff() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterStaff(input);
    }

    function filterStaff(input = '') {
        const staffFilter = document.getElementById('staffFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#staffTable tbody tr');
        rows.forEach(row => {
            const staffName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const staffType = row.querySelector('td:nth-child(4)').textContent.toLowerCase();

            const matchesSearch = staffName.includes(input);
            const matchesStatus = staffFilter === '' || staffType === staffFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // View modal
    var viewStaffModal = document.getElementById('viewStaffModal');
    viewStaffModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var staffID = button.getAttribute('data-staff-id');
        var staffName = button.getAttribute('data-staff-name');
        var staffUsername = button.getAttribute('data-staff-username');
        var staffEmail = button.getAttribute('data-staff-email');
        var staffType = button.getAttribute('data-staff-type');
        var staffPassword = button.getAttribute('data-staff-password');

        var modalStaffID = viewStaffModal.querySelector('#viewStaffID');
        var modalStaffName = viewStaffModal.querySelector('#viewStaffName');
        var modalStaffUsername = viewStaffModal.querySelector('#viewStaffUsername');
        var modalStaffEmail = viewStaffModal.querySelector('#viewStaffEmail');
        var modalStaffType = viewStaffModal.querySelector('#viewStaffType');
        var modalStaffPassword = viewStaffModal.querySelector('#viewStaffPassword');

        modalStaffID.value = staffID;
        modalStaffName.value = staffName;
        modalStaffUsername.value = staffUsername;
        modalStaffEmail.value = staffEmail;
        modalStaffType.value = staffType;
        modalStaffPassword.value = staffPassword;
    });

    // Edit modal
    var editStaffModal = document.getElementById('editStaffModal');
    editStaffModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var staffID = button.getAttribute('data-staff-id');
        var staffName = button.getAttribute('data-staff-name');
        var staffUsername = button.getAttribute('data-staff-username');
        var staffEmail = button.getAttribute('data-staff-email');
        var staffType = button.getAttribute('data-staff-type');
        var staffPassword = button.getAttribute('data-staff-password');

        var modalStaffID = editStaffModal.querySelector('#editStaffID');
        var modalStaffName = editStaffModal.querySelector('#editStaffName');
        var modalStaffUsername = editStaffModal.querySelector('#editStaffUsername');
        var modalStaffEmail = editStaffModal.querySelector('#editStaffEmail');
        var modalStaffType = editStaffModal.querySelector('#editStaffType');
        var modalStaffPassword = editStaffModal.querySelector('#editStaffPassword');

        modalStaffID.value = staffID;
        modalStaffName.value = staffName;
        modalStaffUsername.value = staffUsername;
        modalStaffEmail.value = staffEmail;
        modalStaffType.value = staffType;
        modalStaffPassword.value = staffPassword;
    });

    // Delete modal
    var deleteStaffModal = document.getElementById('deleteStaffModal');
    deleteStaffModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var staffID = button.getAttribute('data-staff-id');

        var modalStaffID = deleteStaffModal.querySelector('#deleteStaffID');
        modalStaffID.value = staffID;
    });

    function confirmDeleteStaff() {
        var staffID = document.getElementById('deleteStaffID').value;
        if (staffID) {
            var form = document.createElement("form");
            form.setAttribute("method", "post");
            form.setAttribute("action", "DeleteStaffServlet");

            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", "staffID");
            hiddenField.setAttribute("value", staffID);

            form.appendChild(hiddenField);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>
