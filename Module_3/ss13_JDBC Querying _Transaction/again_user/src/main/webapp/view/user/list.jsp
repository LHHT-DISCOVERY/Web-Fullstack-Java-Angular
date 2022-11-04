<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 11/4/2022
  Time: 6:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>User Management Application</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</head>
<body>
<h1>LIST USER</h1>
<p>
    <a href="/user?action=add"> ADD User </a>
</p>
<form method="post" action="/user?action=find_country">
    <input type="text" name="country" placeholder="Enter Country User">
    <button type="submit"> Search User</button>
</form>
<form method="post" action="/user?action=sort">
    <%--    <input type="hidden" name="sort">--%>
    <button type="submit"> SORT NAME </button>
</form>

<table class="table table-striped">
    <tr>
        <th>STT</th>
        <th>ID</th>
        <th>Name User</th>
        <th>Email</th>
        <th>Country</th>
        <th>Edit</th>
        <th>Delete</th>
    </tr>

    <c:forEach var="user" items="${userList}" varStatus="status">
        <tr>
            <td>${status.count}</td>
            <td>${user.getId()}</td>
            <td><a href="/user?action=view&id=${user.getId()}">${user.getName()} </a></td>
            <td>${user.getEmail()}</td>
            <td>${user.getCountry()}</td>
            <td>
                <button type="button"  class="btn btn-primary bg-dark">
                    <a href="/user?action=update&id=${user.getId()}" style="text-decoration: none" class="text-light ">Edit</a>
                </button>
            </td>
            <td>
                <button type="button" onclick="infoDelete('${user.getId()}','${user.getName()}')" class="btn btn-primary bg-danger" data-bs-toggle="modal" data-bs-target="#exampleModal">
                    Delete
                </button>
            </td>
        </tr>
    </c:forEach>
    <a href="/user"> show List user</a>
</table>
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="/user" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input name="action" value="delete" hidden>
                    <input name="deleteId" id="deleteId" hidden>
                    <span class="text-danger">Bạn có muốn xoá  </span><span id="deleteName"></span>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Delete</button>
                </div>
            </div>
        </form>

    </div>
</div>
<script>
    function infoDelete(id, name){
        document.getElementById("deleteName").innerText = name;
        document.getElementById("deleteId").value = id;
    }
</script>
</body>
</html>