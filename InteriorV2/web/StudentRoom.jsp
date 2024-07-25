<%@ include file="StudentHeader.jsp" %>
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
    <div class="card mb-3">
        <div class="card-header">My Room</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <div class="d-flex">
                    <div class="input-group me-2" style="width: 200px;">
                        <select id="statusFilter" class="form-select" onchange="filterBookings()">
                            <option value="">All Status</option>
                            <option value="Pending">Pending</option>
                            <option value="Accepted">Accepted</option>
                            <option value="Rejected">Rejected</option>
                        </select>
                    </div>
                    <div class="input-group" style="width: 300px;">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search Booking ID" onkeyup="searchBookings()">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                    </div>
                </div>
            </div>

            <sql:query var="booking_list" dataSource="${myDatasource}">
                SELECT *
                FROM BOOKING B
                JOIN SESSION S ON B.SESSIONID = S.SESSIONID
                WHERE B.stdID = ?
                AND B.BOOKSTATUS = 'APPROVED'
                ORDER BY B.bookingDate DESC
                <sql:param value="${user.userid}" />
            </sql:query>

            <table class="table" id="bookingTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Booking ID</th>
                        <th>Session Time</th>
                        <th>Room ID</th>
                        <th>Booking Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty booking_list.rows}">
                            <tr>
                                <td colspan="6">No bookings available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="booking" items="${booking_list.rows}">
                                <tr>
                                    <% count++;%>
                                    <td width="20px"><%= count%></td>
                                    <td>${booking.bookingID}</td>
                                    <td>${booking.sessionName}</td>
                                    <td>${booking.roomID}</td>
                                    <td>${booking.bookingDate}</td>
                                    <td width="150px">
                                        <c:choose>
                                            <c:when test="${booking.BOOKINGCHECKOUT == null}">
                                                <button type="button" class="btn btn-sm btn-danger">Check Out</button>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Checked Out</span>
                                            </c:otherwise>
                                        </c:choose>
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

    <!-- Add Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1" aria-labelledby="addBookingModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addBookingModalLabel">Add Booking</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="AddBookingServlet" method="post" >
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="blockID" class="form-label">Block</label>
                            <select class="form-select" id="blockID" name="blockID" required>
                                <option value="">Select Block</option>
                                <sql:query var="block_list" dataSource="${myDatasource}">
                                    SELECT blockID, blockName FROM BLOCK
                                </sql:query>
                                <c:forEach var="block" items="${block_list.rows}">
                                    <option value="${block.blockID}">${block.blockID} - ${block.blockName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="roomType" class="form-label">Room Type</label>
                            <select class="form-select" id="roomType" name="roomType" required>
                                <option value="">Select Room Type</option>
                                <option value="LUXURY">Luxury</option>
                                <option value="DELUXE">Deluxe</option>
                                <option value="NORMAL">Normal</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="roomID" class="form-label">Room ID:</label>
                            <select class="form-select custom-select" id="roomID" name="roomID" required>
                                <option value="">Select Room ID</option>
                                <!-- Room options will be populated here by AJAX -->
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="sessionID" class="form-label">Session</label>
                            <select class="form-select " id="sessionID" name="sessionID" required>
                                <option value="">Select Session</option>
                                <sql:query var="session_list" dataSource="${myDatasource}">
                                    SELECT sessionID, sessionName FROM SESSION WHERE sessionStatus = 'ACTIVE'
                                </sql:query>
                                <c:forEach var="session" items="${session_list.rows}">
                                    <option value="${session.sessionID}">${session.sessionName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <input type="hidden" name="stdID" value="${user.userid}">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save Booking</button>
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

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#bookingTable tbody tr");

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

    function searchBookings() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterBookings(input);
    }

    function filterBookings(input = '') {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#bookingTable tbody tr');
        rows.forEach(row => {
            const bookingID = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const bookingStatus = row.querySelector('td:nth-child(4) .badge').textContent.toLowerCase();

            const matchesSearch = bookingID.includes(input);
            const matchesStatus = statusFilter === '' || bookingStatus === statusFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function loadRoomIDs() {
        const blockID = document.getElementById('blockID').value;
        const roomType = document.getElementById('roomType').value;

        console.log("Selected blockID: " + blockID);
        console.log("Selected roomType: " + roomType);

        if (blockID && roomType) {
            const params = new URLSearchParams();
            params.append("blockID", blockID);
            params.append("roomType", roomType);

            const url = "LoadRoomIDsServlet?" + params.toString();

            fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(`Error loading room IDs: ${response.statusText}`);
                        }
                        return response.json();
                    })
                    .then(data => {
                        const roomIDSelect = document.getElementById('roomID');
                        roomIDSelect.innerHTML = '<option value="">Select Room ID</option>';
                        data.forEach(room => {
                            roomIDSelect.innerHTML += `<option value="${room.roomID}">${room.roomID}</option>`;
                        });
                        console.log("Room IDs loaded: ", data);
                    })
                    .catch(error => console.error('Error loading room IDs:', error));
        } else {
            console.error('Missing blockID or roomType');
        }
    }

//    function fetchRoom() {
//        var blockID = document.getElementById("blockID").value;
//        var xmlhttp = new XMLHttpRequest();
//        xmlhttp.onreadystatechange = function () {
//            if (this.readyState == 4 && this.status == 200) {
//                document.getElementById("roomID").innerHTML = this.responseText;
//            }
//        };
//        xmlhttp.open("GET", "fetchRoom.jsp?blockID=" + blockID, true);
//        xmlhttp.send();
//    }

    function fetchRoom() {
        var blockID = document.getElementById("blockID").value;
        var roomType = document.getElementById("roomType").value;
        if (blockID && roomType) {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("roomID").innerHTML = this.responseText;
                }
            };
            xmlhttp.open("GET", "fetchRoom.jsp?blockID=" + blockID + "&roomType=" + roomType, true);
            xmlhttp.send();
        }
    }

    document.getElementById("blockID").addEventListener("change", fetchRoom);
    document.getElementById("roomType").addEventListener("change", fetchRoom);

</script>
