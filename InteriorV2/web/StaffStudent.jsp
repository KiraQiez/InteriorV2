<%@ include file="StaffHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Student Management</h1>
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
    <% } %>
    <div class="card mb-3">
        <div class="card-header">Student List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Student" onkeyup="searchStudents()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
                <div class="input-group" style="width: 300px;">
                    <select id="statusFilter" class="form-select" onchange="filterStudents()">
                        <option value="">All Status</option>
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
            </div>

            <sql:query var="student_list" dataSource="${myDatasource}">
                SELECT * FROM STUDENT ORDER BY stdID
            </sql:query>

            <table class="table" id="studentTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student ID</th>
                        <th>Full Name</th>
                        <th>IC Number</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty student_list.rows}">
                            <tr>
                                <td colspan="7">No students available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="student" items="${student_list.rows}">
                                <tr>
                                    <% count++; %>
                                    <td width="20px"><%= count %></td>
                                    <td>${student.stdID}</td>
                                    <td>${student.stdName}</td>
                                    <td>${student.stdIC}</td>
                                    <td>${student.stdPhone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${student.stdStatus == 'Active'}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#studentViewModal" 
                                                data-student-id="${student.stdID}" data-student-name="${student.stdName}" data-student-ic="${student.stdIC}" 
                                                data-student-phone="${student.stdPhone}" data-student-address="${student.stdAddress}" 
                                                data-student-income="${student.stdIncome}" data-student-parent-phone="${student.stdParentPhoneNum}" 
                                                data-student-status="${student.stdStatus}" data-bs-toggle="tooltip" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <c:if test="${staff.staffType == 'Manager' || staff.staffType == 'Admin'}">
                                        <button type="button" class="btn btn-sm btn-edit ms-1" data-bs-toggle="modal" data-bs-target="#studentEditModal" 
                                                data-student-id="${student.stdID}" data-student-name="${student.stdName}" data-student-phone="${student.stdPhone}" 
                                                data-student-address="${student.stdAddress}" data-student-income="${student.stdIncome}" 
                                                data-student-parent-phone="${student.stdParentPhoneNum}" data-bs-toggle="tooltip" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <c:choose>
                                            
                                            
                                            <c:when test="${student.stdStatus == 'Active'}">
                                                <button type="button" class="btn btn-sm btn-danger ms-1" data-bs-toggle="modal" data-bs-target="#studentDisableModal" 
                                                        data-student-id="${student.stdID}" data-bs-toggle="tooltip" title="Disable">
                                                    <i class="fas fa-ban" ></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-sm btn-success ms-1" data-bs-toggle="modal" data-bs-target="#studentEnableModal" 
                                                        data-student-id="${student.stdID}" data-bs-toggle="tooltip" title="Enable">
                                                    <i class="fas fa-check" ></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        </c:if>
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

        <!-- View Student Modal -->
        <div class="modal fade" id="studentViewModal" tabindex="-1" aria-labelledby="studentViewModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="studentViewModalLabel">View Student</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="viewStudentID" class="form-label">Student ID</label>
                                <input type="text" class="form-control" id="viewStudentID" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="viewStudentName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="viewStudentName" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="viewStudentIC" class="form-label">IC Number</label>
                                <input type="text" class="form-control" id="viewStudentIC" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="viewStudentPhone" class="form-label">Phone</label>
                                <input type="text" class="form-control" id="viewStudentPhone" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="viewStudentAddress" class="form-label">Address</label>
                                <input type="text" class="form-control" id="viewStudentAddress" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="viewStudentIncome" class="form-label">Income</label>
                                <input type="text" class="form-control" id="viewStudentIncome" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="viewStudentParentPhone" class="form-label">Parent Phone</label>
                                <input type="text" class="form-control" id="viewStudentParentPhone" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="viewStudentStatus" class="form-label">Status</label>
                                <input type="text" class="form-control" id="viewStudentStatus" readonly>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Student Modal -->
        <div class="modal fade" id="studentEditModal" tabindex="-1" aria-labelledby="studentEditModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="studentEditModalLabel">Edit Student</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="EditStudentServlet" method="post">
                            <input type="hidden" class="form-control" id="editStudentID" name="studentID">
                            <div class="mb-3">
                                <label for="editStudentName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="editStudentName" name="studentName">
                            </div>
                            <div class="mb-3">
                                <label for="editStudentPhone" class="form-label">Phone</label>
                                <input type="text" class="form-control" id="editStudentPhone" name="studentPhone">
                            </div>
                            <div class="mb-3">
                                <label for="editStudentAddress" class="form-label">Address</label>
                                <input type="text" class="form-control" id="editStudentAddress" name="studentAddress">
                            </div>
                            <div class="mb-3">
                                <label for="editStudentIncome" class="form-label">Income</label>
                                <input type="text" class="form-control" id="editStudentIncome" name="studentIncome">
                            </div>
                            <div class="mb-3">
                                <label for="editStudentParentPhone" class="form-label">Parent Phone</label>
                                <input type="text" class="form-control" id="editStudentParentPhone" name="studentParentPhone">
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

        <!-- Disable Student Modal -->
<div class="modal fade" id="studentDisableModal" tabindex="-1" aria-labelledby="studentDisableModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="studentDisableModalLabel">Disable Student</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to disable this student?</p>
                <input type="hidden" class="form-control" id="disableStudentID">
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                    <button type="button" class="btn btn-danger" onclick="confirmDisableStudent()">Yes</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Enable Student Modal -->
<div class="modal fade" id="studentEnableModal" tabindex="-1" aria-labelledby="studentEnableModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="studentEnableModalLabel">Enable Student</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to enable this student?</p>
                <input type="hidden" class="form-control" id="enableStudentID">
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                    <button type="button" class="btn btn-success" onclick="confirmEnableStudent()">Yes</button>
                </div>
            </div>
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
    const rows = document.querySelectorAll("#studentTable tbody tr");

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

    window.onload = function() {
        changePage(1);
        initializeTooltips();
    };

    function initializeTooltips() {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }

    function searchStudents() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterStudents(input);
    }

    function filterStudents(input = '') {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#studentTable tbody tr');
        rows.forEach(row => {
            const studentName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const studentStatus = row.querySelector('td:nth-child(6) .badge').textContent.toLowerCase();

            const matchesSearch = studentName.includes(input);
            const matchesStatus = statusFilter === '' || studentStatus === statusFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // View modal
    var studentViewModal = document.getElementById('studentViewModal');
    studentViewModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var studentID = button.getAttribute('data-student-id');
        var studentName = button.getAttribute('data-student-name');
        var studentIC = button.getAttribute('data-student-ic');
        var studentPhone = button.getAttribute('data-student-phone');
        var studentAddress = button.getAttribute('data-student-address');
        var studentIncome = button.getAttribute('data-student-income');
        var studentParentPhone = button.getAttribute('data-student-parent-phone');
        var studentStatus = button.getAttribute('data-student-status');

        var modalStudentID = studentViewModal.querySelector('#viewStudentID');
        var modalStudentName = studentViewModal.querySelector('#viewStudentName');
        var modalStudentIC = studentViewModal.querySelector('#viewStudentIC');
        var modalStudentPhone = studentViewModal.querySelector('#viewStudentPhone');
        var modalStudentAddress = studentViewModal.querySelector('#viewStudentAddress');
        var modalStudentIncome = studentViewModal.querySelector('#viewStudentIncome');
        var modalStudentParentPhone = studentViewModal.querySelector('#viewStudentParentPhone');
        var modalStudentStatus = studentViewModal.querySelector('#viewStudentStatus');

        modalStudentID.value = studentID;
        modalStudentName.value = studentName;
        modalStudentIC.value = studentIC;
        modalStudentPhone.value = studentPhone;
        modalStudentAddress.value = studentAddress;
        modalStudentIncome.value = studentIncome;
        modalStudentParentPhone.value = studentParentPhone;
        modalStudentStatus.value = studentStatus;
    });

    // Edit modal
    var studentEditModal = document.getElementById('studentEditModal');
    studentEditModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var studentID = button.getAttribute('data-student-id');
        var studentName = button.getAttribute('data-student-name');
        var studentPhone = button.getAttribute('data-student-phone');
        var studentAddress = button.getAttribute('data-student-address');
        var studentIncome = button.getAttribute('data-student-income');
        var studentParentPhone = button.getAttribute('data-student-parent-phone');

        var modalStudentID = studentEditModal.querySelector('#editStudentID');
        var modalStudentName = studentEditModal.querySelector('#editStudentName');
        var modalStudentPhone = studentEditModal.querySelector('#editStudentPhone');
        var modalStudentAddress = studentEditModal.querySelector('#editStudentAddress');
        var modalStudentIncome = studentEditModal.querySelector('#editStudentIncome');
        var modalStudentParentPhone = studentEditModal.querySelector('#editStudentParentPhone');

        modalStudentID.value = studentID;
        modalStudentName.value = studentName;
        modalStudentPhone.value = studentPhone;
        modalStudentAddress.value = studentAddress;
        modalStudentIncome.value = studentIncome;
        modalStudentParentPhone.value = studentParentPhone;
    });

   // Disable modal
var studentDisableModal = document.getElementById('studentDisableModal');
studentDisableModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var studentID = button.getAttribute('data-student-id');

    var modalStudentID = studentDisableModal.querySelector('#disableStudentID');
    modalStudentID.value = studentID;
});

function confirmDisableStudent() {
    var studentID = document.getElementById('disableStudentID').value;
    if (studentID) {
        var form = document.createElement("form");
        form.setAttribute("method", "post");
        form.setAttribute("action", "DisableStudentServlet");

        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "studentID");
        hiddenField.setAttribute("value", studentID);

        form.appendChild(hiddenField);
        document.body.appendChild(form);
        form.submit();
    }
}

// Enable modal
var studentEnableModal = document.getElementById('studentEnableModal');
studentEnableModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var studentID = button.getAttribute('data-student-id');

    var modalStudentID = studentEnableModal.querySelector('#enableStudentID');
    modalStudentID.value = studentID;
});

function confirmEnableStudent() {
    var studentID = document.getElementById('enableStudentID').value;
    if (studentID) {
        var form = document.createElement("form");
        form.setAttribute("method", "post");
        form.setAttribute("action", "EnableStudentServlet");

        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "studentID");
        hiddenField.setAttribute("value", studentID);

        form.appendChild(hiddenField);
        document.body.appendChild(form);
        form.submit();
    }
}

</script>
</body>
</html>
