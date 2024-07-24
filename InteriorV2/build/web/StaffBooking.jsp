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
    <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger"%> alert-dismissible fade show" role="alert">
        <%= message%>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <% String billMessage = (String) request.getAttribute("billMessage"); %>
    <% if (billMessage != null) {%>
    <div class="alert <%= billMessage.contains("success") ? "alert-success" : "alert-danger"%> alert-dismissible fade show" role="alert">
        <%= billMessage%>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>


    <div class="card mb-3">
        <div class="card-header">Booking List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">

                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Student" onkeyup="searchStudents()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
                <div class="input-group" style="width: 300px;">
                    <select id="statusFilter" class="form-select" onchange="filterStudents()">
                        <option value="">All Status</option>
                        <option value="APPROVED">Active</option>
                        <option value="REJECTED">REJECTED</option>
                        <option value="PENDING">Pending</option>
                    </select>
                </div>
            </div>

            <sql:query var="book_list" dataSource="${myDatasource}">
                SELECT * FROM BOOKING B
                JOIN SESSION S ON B.SESSIONID = S. SESSIONID
                JOIN STUDENT ST ON B.STDID = ST.STDID
                ORDER BY B.bookingID 
            </sql:query>

            <table class="table" id="studentTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Booking ID</th>
                        <th>Session</th>
                        <th>Student Name</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty book_list.rows}">
                            <tr>
                                <td colspan="7">No booking available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="book" items="${book_list.rows}">
                                <tr>
                                    <% count++;%>
                                    <td width="20px"><%= count%></td>
                                    <td>${book.bookingID}</td>
                                    <td>${book.sessionName}</td>
                                    <td>${book.stdName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${book.bookStatus == 'APPROVED'}">
                                                <span class="badge bg-success">Approved</span>
                                            </c:when>
                                            <c:when test="${book.bookStatus == 'REJECTED'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:when test="${book.bookStatus == 'PENDING'}">
                                                <span class="badge bg-warning">Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#bookingViewModal" 
                                                data-book-id="${book.bookingID}" data-ssn-name="${book.sessionName}" data-std-id="${book.stdID}" data-std-name="${book.stdName}" 
                                                data-std-income="${book.stdIncome}" data-book-status="${book.bookStatus}" data-bs-toggle="tooltip" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-edit ms-1" data-bs-toggle="modal" data-bs-target="#bookingEditModal" 
                                                data-book-id="${book.bookingID}" data-ssn-name="${book.sessionName}" data-std-id="${book.stdID}" data-std-name="${book.stdName}" 
                                                data-std-income="${book.stdIncome}" data-book-status="${book.bookStatus}" data-bs-toggle="tooltip" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-delete ms-1" data-bs-toggle="tooltip" title="Disable"><i class="fas fa-trash"></i></button>
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

        <!-- View Booking Modal -->
        <div class="modal fade" id="bookingViewModal" tabindex="-1" aria-labelledby="bookingViewModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="bookingViewModalLabel">View Booking</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="bookingID" class="form-label">Booking ID</label>
                                <input type="text" class="form-control" id="bookingID" name="bookingID" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="sessionName" class="form-label">Session Name</label>
                                <input type="text" class="form-control" id="sessionName" name="sessionName" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="bookStatus" class="form-label">Booking Status</label>
                                <input type="text" class="form-control" id="bookStatus" name="bookStatus" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="stdName" class="form-label">Student Name</label>
                                <input type="text" class="form-control" id="stdName" name="stdName" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="stdIncome" class="form-label">Student Income (RM)</label>
                                <input type="text" class="form-control" id="stdIncome" name="stdIncome" readonly>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Booking Modal -->
        <div class="modal fade" id="bookingEditModal" tabindex="-1" aria-labelledby="bookingEditModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="bookingEditModalLabel">View Booking</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="EditBookingServlet" method="post">
                            <input type="hidden" class="form-control" id="stdID" name="stdID" readonly>
                            <div class="mb-3">
                                <label for="bookingID" class="form-label">Booking ID</label>
                                <input type="text" class="form-control" id="bookingID" name="bookingID" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="sessionName" class="form-label">Session Name</label>
                                <input type="text" class="form-control" id="sessionName" name="sessionName" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="bookStatus" class="form-label">Booking Status</label>
                                <select class="form-select" id="bookStatus" name="bookStatus">
                                    <option value="APPROVED">Approved</option>
                                    <option value="PENDING">Pending</option>
                                    <option value="REJECTED">Rejected</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="stdName" class="form-label">Student Name</label>
                                <input type="text" class="form-control" id="stdName" name="stdName" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="stdIncome" class="form-label">Student Income (RM)</label>
                                <input type="text" class="form-control" id="stdIncome" name="stdIncome" readonly>
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
    var bookingViewModal = document.getElementById('bookingViewModal');
    bookingViewModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var bookingID = button.getAttribute('data-book-id');
        var sessionName = button.getAttribute('data-ssn-name');
        var bookStatus = button.getAttribute('data-book-status');
        var stdID = button.getAttribute('data-std-id');
        var stdName = button.getAttribute('data-std-name');
        var stdIncome = button.getAttribute('data-std-income');

        var modalBookingID = bookingViewModal.querySelector('#bookingID');
        var modalSessionName = bookingViewModal.querySelector('#sessionName');
        var modalBookStatus = bookingViewModal.querySelector('#bookStatus');
        var modalStdID = bookingEditModal.querySelector('#stdID');
        var modalStdName = bookingViewModal.querySelector('#stdName');
        var modalStdIncome = bookingViewModal.querySelector('#stdIncome');

        modalBookingID.value = bookingID;
        modalSessionName.value = sessionName;
        modalBookStatus.value = bookStatus;
        modalStdID.value = stdID;
        modalStdName.value = stdName;
        modalStdIncome.value = stdIncome;
    });

    // Edit modal
    var bookingEditModal = document.getElementById('bookingEditModal');
    bookingEditModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var bookingID = button.getAttribute('data-book-id');
        var sessionName = button.getAttribute('data-ssn-name');
        var bookStatus = button.getAttribute('data-book-status');
        var stdID = button.getAttribute('data-std-id');
        var stdName = button.getAttribute('data-std-name');
        var stdIncome = button.getAttribute('data-std-income');

        var modalBookingID = bookingEditModal.querySelector('#bookingID');
        var modalSessionName = bookingEditModal.querySelector('#sessionName');
        var modalBookStatus = bookingEditModal.querySelector('#bookStatus');
        var modalStdID = bookingEditModal.querySelector('#stdID');
        var modalStdName = bookingEditModal.querySelector('#stdName');
        var modalStdIncome = bookingEditModal.querySelector('#stdIncome');

        modalBookingID.value = bookingID;
        modalSessionName.value = sessionName;
        modalBookStatus.value = bookStatus;
        modalStdID.value = stdID;
        modalStdName.value = stdName;
        modalStdIncome.value = stdIncome;
    });
</script>
</body>
</html>