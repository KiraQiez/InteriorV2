<%@ include file="StaffHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Room Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>

    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) {%>
    <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger"%>" role="alert">
        <%= message%>
    </div>
    <% } %>

    <div class="card mb-3">
        <div class="card-header">Report List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Report" onkeyup="searchReport()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
                <div class="input-group" style="width: 300px;">
                    <select id="statusFilter" class="form-select" onchange="filterReport()">
                        <option value="">All Status</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="REJECTED">Rejected</option>
                        <option value="PENDING">Pending</option>
                    </select>
                </div>
            </div>

            <sql:query var="report_list" dataSource="${myDatasource}">
                SELECT R.*, ST.stdName, S1.staffName AS checkedByName, S2.staffName AS handledByName 
                FROM REPORT R 
                JOIN STUDENT ST ON ST.STDID = R.STUDENTID
                LEFT JOIN STAFF S1 ON S1.staffID = R.checkedByStaffID
                LEFT JOIN STAFF S2 ON S2.staffID = R.handledByStaffID
                ORDER BY R.reportID 
            </sql:query>

            <table class="table" id="reportTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Report ID</th>
                        <th>Reported by</th>
                        <th>Status</th>
                        <th>Checked by</th>
                        <th>Handled by</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty report_list.rows}">
                            <tr>
                                <td colspan="7">No report available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="report" items="${report_list.rows}">
                                <tr>
                                    <% count++; %>
                                    <td width="20px"><%= count %></td>
                                    <td>${report.reportID}</td>
                                    <td>${report.stdName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.reportStatus == 'Completed'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:when test="${report.reportStatus == 'Pending'}">
                                                <span class="badge bg-warning">Pending</span>
                                            </c:when>
                                            <c:when test="${report.reportStatus == 'Rejected'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${report.checkedByName == null ? '-' : report.checkedByName}</td>
                                    <td>${report.handledByName == null ? '-' : report.handledByName}</td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#viewReportModal" 
                                                data-id="${report.reportID}" data-title="${report.reportTitle}" data-desc="${report.reportDesc}" 
                                                data-status="${report.reportStatus}" data-std-id="${report.studentID}" 
                                                data-checked-by="${report.checkedByName}" data-handled-by="${report.handledByName}" data-bs-toggle="tooltip" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <c:if test="${report.reportStatus != 'Completed' && report.reportStatus != 'Rejected'}">
                                            <button type="button" class="btn btn-sm btn-edit" data-bs-toggle="modal" data-bs-target="#editReportModal" 
                                                    data-id="${report.reportID}" data-title="${report.reportTitle}" data-desc="${report.reportDesc}" 
                                                    data-status="${report.reportStatus}" data-std-id="${report.studentID}" 
                                                    data-checked-by="${report.checkedByStaffID}" data-bs-toggle="tooltip" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
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
        
        <!-- View Report Modal -->
        <div class="modal fade" id="viewReportModal" tabindex="-1" aria-labelledby="viewReportModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewReportModalLabel">View Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3 row">
                                <label for="viewReportID" class="col-sm-2 col-form-label">Report ID</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="viewReportID" readonly>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="viewReportTitle" class="col-sm-2 col-form-label">Report Title</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="viewReportTitle" readonly>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="viewReportDesc" class="col-sm-2 col-form-label">Report Description</label>
                                <div class="col-sm-10">
                                    <textarea class="form-control" id="viewReportDesc" rows="3" readonly></textarea>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="viewReportStatus" class="col-sm-2 col-form-label">Report Status</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="viewReportStatus" readonly>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="viewCheckedBy" class="col-sm-2 col-form-label">Checked By</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="viewCheckedBy" readonly>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="viewHandledBy" class="col-sm-2 col-form-label">Handled By</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="viewHandledBy" readonly>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Report Modal -->
        <div class="modal fade" id="editReportModal" tabindex="-1" aria-labelledby="editReportModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editReportModalLabel">Edit Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="ReportChangeStatusServlet" method="POST">
                            <input type="hidden" class="form-control" id="editReportID" name="reportID">
                            <div class="mb-3 row">
                                <label for="editReportTitle" class="col-sm-2 col-form-label">Report Title</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="editReportTitle" name="reportTitle">
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="editReportDesc" class="col-sm-2 col-form-label">Report Description</label>
                                <div class="col-sm-10">
                                    <textarea class="form-control" id="editReportDesc" name="reportDesc" rows="3"></textarea>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="editReportStatus" class="col-sm-2 col-form-label">Report Status</label>
                                <div class="col-sm-10">
                                    <select class="form-select" id="editReportStatus" name="reportStatus">
                                        <option value="Completed">Completed</option>
                                        <option value="Rejected">Rejected</option>
                                        <option value="Pending">Pending</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="editCheckedBy" class="col-sm-2 col-form-label">Checked By</label>
                                <div class="col-sm-10">
                                    <select class="form-select" id="editCheckedBy" name="checkedByStaff">
                                        <option value="">Select Staff</option>
                                        <sql:query var="staff_list" dataSource="${myDatasource}">
                                            SELECT staffID, staffName FROM STAFF WHERE staffType NOT IN ('Admin', 'Manager')
                                        </sql:query>
                                        <c:forEach var="staff" items="${staff_list.rows}">
                                            <option value="${staff.staffID}">${staff.staffName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
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
</main>
</div>
</div>

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#reportTable tbody tr");

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
    };

    function searchReport() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterReport(input);
    }

    function filterReport(input = '') {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#reportTable tbody tr');
        rows.forEach(row => {
            const reportID = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const reportStatus = row.querySelector('td:nth-child(4) .badge').textContent.toLowerCase();

            const matchesSearch = reportID.includes(input);
            const matchesStatus = statusFilter === '' || reportStatus === statusFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // View Report Modal
    var viewReportModal = document.getElementById('viewReportModal');
    viewReportModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget; // Button that triggered the modal
        var reportID = button.getAttribute('data-id');
        var reportTitle = button.getAttribute('data-title');
        var reportDesc = button.getAttribute('data-desc');
        var reportStatus = button.getAttribute('data-status');
        var stdID = button.getAttribute('data-std-id');
        var checkedByName = button.getAttribute('data-checked-by');
        var handledByName = button.getAttribute('data-handled-by');

        var modalID = viewReportModal.querySelector('#viewReportID');
        var modalTitle = viewReportModal.querySelector('#viewReportTitle');
        var modalDesc = viewReportModal.querySelector('#viewReportDesc');
        var modalStatus = viewReportModal.querySelector('#viewReportStatus');
        var modalStdID = viewReportModal.querySelector('#viewStdID');
        var modalCheckedBy = viewReportModal.querySelector('#viewCheckedBy');
        var modalHandledBy = viewReportModal.querySelector('#viewHandledBy');

        modalID.value = reportID;
        modalTitle.value = reportTitle;
        modalDesc.value = reportDesc;
        modalStatus.value = reportStatus;
        modalStdID.value = stdID;
        modalCheckedBy.value = checkedByName;
        modalHandledBy.value = handledByName;
    });

    // Edit Report Modal
    var editReportModal = document.getElementById('editReportModal');
    editReportModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget; // Button that triggered the modal
        var reportID = button.getAttribute('data-id');
        var reportTitle = button.getAttribute('data-title');
        var reportDesc = button.getAttribute('data-desc');
        var reportStatus = button.getAttribute('data-status');
        var stdID = button.getAttribute('data-std-id');
        var checkedByStaffID = button.getAttribute('data-checked-by');

        var modalID = editReportModal.querySelector('#editReportID');
        var modalTitle = editReportModal.querySelector('#editReportTitle');
        var modalDesc = editReportModal.querySelector('#editReportDesc');
        var modalStatus = editReportModal.querySelector('#editReportStatus');
        var modalStdID = editReportModal.querySelector('#editStdID');
        var modalCheckedBy = editReportModal.querySelector('#editCheckedBy');

        modalID.value = reportID;
        modalTitle.value = reportTitle;
        modalDesc.value = reportDesc;
        modalStatus.value = reportStatus;
        modalStdID.value = stdID;
        modalCheckedBy.value = checkedByStaffID;
    });
</script>
</body>
</html>
