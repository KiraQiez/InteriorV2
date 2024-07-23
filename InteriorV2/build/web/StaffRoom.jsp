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
    <div class="card mb-3">
        <div class="card-header">Room List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">

                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Room" onkeyup="searchRoom()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>

                <div class="d-flex ">
                    <div class="input-group" style="width: 200px;">
                        <sql:query var="block_list" dataSource="${myDatasource}">
                            SELECT DISTINCT BLOCKID FROM BLOCK
                        </sql:query>
                        <select id="blockFilter" class="form-select" onchange="filterBlock()">
                            <option value="">All Block</option>
                            <c:forEach var="block" items="${block_list.rows}">
                                <option value="${block.blockID}">${block.blockID}</option>
                            </c:forEach>
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
                        <th>Max Capacity</th>
                        <th>Availability</th>
<!--                        <th>File</th>-->
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty room_list.rows}">
                            <tr>
                                <td colspan="6">No room available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="room" items="${room_list.rows}">
                                <tr>
                                    <% count++;%>
                                    <td width="20px"><%= count%></td>
                                    <td>${room.roomID}</td>
                                    <td>${room.blockID}</td>
                                    <td>${room.maxCapacity}</td>
                                    <td>${room.availability}</td>
<!--                                    <td><img src="rsc/images/pdf-icon.png" width="30px" height="30px"></td>-->
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="tooltip" title="View"><i class="fas fa-eye"></i></button>
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="tooltip" title="Download"><i class="fas fa-download"></i></button>
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

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#roomTable tbody tr");

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

    function searchRoom() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterBlock(input);
    }

    function filterBlock(input = '') {
        const blockFilter = document.getElementById('blockFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#roomTable tbody tr');
        rows.forEach(row => {
            const roomNo = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const block = row.querySelector('td:nth-child(3)').textContent.toLowerCase();

            const matchesSearch = roomNo.includes(input);
            const matchesStatus = blockFilter === '' || block === blockFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>