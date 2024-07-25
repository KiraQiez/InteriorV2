<%@ include file="StaffHeader.jsp" %>

<!-- SQL Query to retrieve blocks -->
<sql:query var="block_list" dataSource="${myDatasource}">
    SELECT * FROM BLOCK
</sql:query>

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
    <% if (message != null) { %>
    <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger" %> alert-dismissible fade show" role="alert">
        <%= message %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
    
    <div class="card mb-3">
        <div class="card-header">Room List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                
                <c:choose>
                <c:when test="${staff.staffType == 'Manager' || staff.staffType == 'Admin'}">
                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addRoomModal">Add Room</button>
                </c:when>
                <c:otherwise>
                    <div></div>
                </c:otherwise>
                </c:choose>
                
                <div class="d-flex">
                    <div class="input-group me-2" style="width: 300px;">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search Room" onkeyup="searchRoom()">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                    </div>
                    <div class="input-group" style="width: 200px;">
                        <select id="typeFilter" class="form-select" onchange="filterRooms()">
                            <option value="">All Types</option>
                            <option value="Luxury">Luxury</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Normal">Normal</option>
                        </select>
                    </div>
                </div>
            </div>

            <sql:query var="room_list" dataSource="${myDatasource}">
                SELECT * FROM ROOM
            </sql:query>

            <table class="table" id="roomTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Room ID</th>
                        <th>Block</th>
                        <th>Room Type</th>
                        <th>Max Capacity</th>
                        <th>Availability</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty room_list.rows}">
                            <tr>
                                <td colspan="7">No room available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="room" items="${room_list.rows}">
                                <tr>
                                    <% count++; %>
                                    <td width="20px"><%= count %></td>
                                    <td>${room.roomID}</td>
                                    <td>${room.blockID}</td>
                                    <td>${room.roomType}</td>
                                    <td>${room.maxCapacity}</td>
                                    <td>${room.availability}</td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#viewRoomModal" onclick="viewRoom('${room.roomID}', '${room.blockID}', '${room.roomType}', '${room.maxCapacity}', '${room.availability}')"><i class="fas fa-eye"></i></button>
                                        <c:if test="${staff.staffType == 'Manager' || staff.staffType == 'Admin'}">
                                            <button type="button" class="btn btn-sm btn-delete" data-bs-toggle="modal" data-bs-target="#deleteRoomModal" onclick="prepareDeleteRoom('${room.roomID}')"><i class="fas fa-trash-alt"></i></button>
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
    </div>
</main>
</div>
</div>

<!-- Add Room Modal -->
<div class="modal fade" id="addRoomModal" tabindex="-1" aria-labelledby="addRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addRoomModalLabel">Add Room</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addRoomForm" action="AddRoomServlet" method="post">
                    <div class="mb-3">
                        <label for="blockSelect" class="form-label">Block</label>
                        <select id="blockSelect" name="blockID" class="form-select" required>
                            <option value="">Select Block</option>
                            <c:forEach var="block" items="${block_list.rows}">
                                <option value="${block.blockID}">${block.blockID} - ${block.blockName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="roomType" class="form-label">Type</label>
                        <select id="roomType" name="roomType" class="form-select" required>
                            <option value="Luxury">Luxury</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Normal">Normal</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="maxCapacity" class="form-label">Capacity</label>
                        <input type="number" id="maxCapacity" name="maxCapacity" class="form-control" required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Room</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- View Room Modal -->
<div class="modal fade" id="viewRoomModal" tabindex="-1" aria-labelledby="viewRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewRoomModalLabel">View Room Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label for="viewRoomID" class="form-label">Room ID</label>
                        <input type="text" id="viewRoomID" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewBlockID" class="form-label">Block</label>
                        <input type="text" id="viewBlockID" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewRoomType" class="form-label">Room Type</label>
                        <input type="text" id="viewRoomType" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewMaxCapacity" class="form-label">Max Capacity</label>
                        <input type="text" id="viewMaxCapacity" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewAvailability" class="form-label">Availability</label>
                        <input type="text" id="viewAvailability" class="form-control" readonly>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Delete Room Modal -->
<div class="modal fade" id="deleteRoomModal" tabindex="-1" aria-labelledby="deleteRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteRoomModalLabel">Delete Room</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this room?</p>
                <form id="deleteRoomForm" action="DeleteRoomServlet" method="post">
                    <input type="hidden" id="deleteRoomID" name="roomID">
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#roomTable tbody tr");

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

    function searchRoom() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterRooms(input);
    }

    function filterRooms(input = '') {
        const typeFilter = document.getElementById('typeFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#roomTable tbody tr');
        rows.forEach(row => {
            const roomID = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const roomType = row.querySelector('td:nth-child(4)').textContent.toLowerCase();

            const matchesSearch = roomID.includes(input);
            const matchesType = typeFilter === '' || roomType === typeFilter;

            if (matchesSearch && matchesType) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function viewRoom(roomID, blockID, roomType, maxCapacity, availability) {
        document.getElementById('viewRoomID').value = roomID;
        document.getElementById('viewBlockID').value = blockID;
        document.getElementById('viewRoomType').value = roomType;
        document.getElementById('viewMaxCapacity').value = maxCapacity;
        document.getElementById('viewAvailability').value = availability;
    }

    function prepareDeleteRoom(roomID) {
        document.getElementById('deleteRoomID').value = roomID;
    }
</script>
</body>
</html>
