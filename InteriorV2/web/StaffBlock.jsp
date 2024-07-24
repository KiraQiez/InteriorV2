<%@ include file="StaffHeader.jsp" %>

<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Block Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>
    <div class="card mb-3">
        <div class="card-header">Block List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                
                <c:choose>
                <c:when test="${staff.staffType == 'Manager' || staff.staffType == 'Admin'}">
               <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addBlockModal">Add Block</button>
                </c:when>
                <c:otherwise>
                    <div></div>
                </c:otherwise>
                
                </c:choose>
                
                <div class="d-flex">
                    <div class="input-group me-2" style="width: 300px;">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search Block" onkeyup="searchBlock()">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                    </div>
                </div>
            </div>

            <sql:query var="block_list" dataSource="${myDatasource}">
                SELECT * FROM BLOCK
            </sql:query>

            <table class="table" id="blockTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Block ID</th>
                        <th>Block Name</th>
                        <th>Description</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty block_list.rows}">
                            <tr>
                                <td colspan="5">No block available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="block" items="${block_list.rows}">
                                <tr>
                                    <% count++;%>
                                    <td width="20px"><%= count %></td>
                                    <td>${block.blockID}</td>
                                    <td>${block.blockName}</td>
                                    <td>${block.blockDesc}</td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#viewBlockModal" onclick="viewBlock('${block.blockID}', '${block.blockName}', '${block.blockDesc}')"><i class="fas fa-eye"></i></button>
                                        <c:if test="${staff.staffType == 'Manager' || staff.staffType == 'Admin'}">
                                        <button type="button" class="btn btn-sm btn-delete" data-bs-toggle="modal" data-bs-target="#deleteBlockModal" onclick="prepareDeleteBlock('${block.blockID}')"><i class="fas fa-trash-alt"></i></button>
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

<!-- Add Block Modal -->
<div class="modal fade" id="addBlockModal" tabindex="-1" aria-labelledby="addBlockModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addBlockModalLabel">Add Block</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addBlockForm" action="AddBlockServlet" method="post">
                    <div class="mb-3">
                        <label for="blockID" class="form-label">Block ID</label>
                        <input type="text" id="blockID" name="blockID" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="blockName" class="form-label">Block Name</label>
                        <input type="text" id="blockName" name="blockName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="blockDesc" class="form-label">Description</label>
                        <textarea id="blockDesc" name="blockDesc" class="form-control" required></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Block</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- View Block Modal -->
<div class="modal fade" id="viewBlockModal" tabindex="-1" aria-labelledby="viewBlockModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewBlockModalLabel">View Block Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label for="viewBlockID" class="form-label">Block ID</label>
                        <input type="text" id="viewBlockID" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewBlockName" class="form-label">Block Name</label>
                        <input type="text" id="viewBlockName" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="viewBlockDesc" class="form-label">Description</label>
                        <textarea id="viewBlockDesc" class="form-control" readonly></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Delete Block Modal -->
<div class="modal fade" id="deleteBlockModal" tabindex="-1" aria-labelledby="deleteBlockModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteBlockModalLabel">Delete Block</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this block?</p>
                <form id="deleteBlockForm" action="DeleteBlockServlet" method="post">
                    <input type="hidden" id="deleteBlockID" name="blockID">
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
    const rows = document.querySelectorAll("#blockTable tbody tr");

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

    function searchBlock() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterBlocks(input);
    }

    function filterBlocks(input = '') {
        const rows = document.querySelectorAll('#blockTable tbody tr');
        rows.forEach(row => {
            const blockID = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const matchesSearch = blockID.includes(input);

            if (matchesSearch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function viewBlock(blockID, blockName, blockDesc) {
        document.getElementById('viewBlockID').value = blockID;
        document.getElementById('viewBlockName').value = blockName;
        document.getElementById('viewBlockDesc').value = blockDesc;
    }

    function prepareDeleteBlock(blockID) {
        document.getElementById('deleteBlockID').value = blockID;
    }
</script>
</body>
</html>
