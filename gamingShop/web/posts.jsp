
<%-- 
    Document   : welcome
    Created on : Sep 2, 2025, 12:36:54 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Accounts" %>
<%@page import="utils.AuthUtils" %>
<%@page import="java.util.List" %>
<%@page import="dto.Posts" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome Page</title>
        <style>
            .products-table img {
                width: 100px;
                height: auto;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <%
            Accounts accounts = AuthUtils.getCurrentUser(request);
            String keyword = (String) request.getAttribute("keyword");
            String checkErrorSearchPosts = (String) request.getAttribute("checkErrorSearchPosts");
            String messageSearchPosts = (String) request.getAttribute("messageSearchPosts");
            String messageDeletePosts = (String) request.getAttribute("messageDeletePosts");
            String checkErrorDeletePosts = (String) request.getAttribute("checkErrorDeletePosts");
            List<Posts> list = (List<Posts>) request.getAttribute("list");
        %>
        <div class="container">
            <div class="content">
                <div class="search-section">
                    <form action="MainController" method="post" class="search-form">
                        <input type="hidden" name="action" value="searchPosts"/>
                        <label>Search the all post by title</label>
                        <input type="text" name="keyword" 
                               value="<%= (keyword != null) ? keyword : "" %>" 
                               placeholder="Enter post title..."/>
                        <input type="submit" value="Search"/>
                    </form>
                </div><br>

                <% if (list != null && !list.isEmpty()) { %>
                <table class="products-table" border="1" cellpadding="8" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Posts ID</th>
                            <th>Author</th>
                            <th>Description</th>
                            <th>Publish Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            for (Posts p : list) {
                            if (p.getStatus() == 0) { 
                                    continue; 
                                }
                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                        %>
                        <tr>
                            <td>
                                <img src="<%= p.getImage_url() %>" alt="<%= p.getTitle() %>"/>
                            </td>
                            <td><%= p.getId() %></td>
                            <td><%= p.getAuthor() %></td>
                            <td><%= p.getContent_html() %></td>
                            <td><%= (p.getPublish_date() != null) ? sdf.format(p.getPublish_date()) : "" %></td>
                            <td><%= p.getStatus() %></td>
                            <td>
                                <form action="MainController" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="goToUpdatePosts"/>
                                    <input type="hidden" name="id" value="<%= p.getId() %>"/>
                                    <input type="hidden" name="keyword" value="<%= (keyword != null) ? keyword : "" %>" />
                                    <input type="submit" value="Edit" class="edit-btn" />
                                </form>

                                <form action="MainController" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deletePosts"/>
                                    <input type="hidden" name="id" value="<%= p.getId() %>"/>
                                    <input type="hidden" name="keyword" value="<%= (keyword != null) ? keyword : "" %>" />
                                    <input type="submit" value="Delete" class="edit-btn" />
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else if (checkErrorSearchPosts != null && !checkErrorSearchPosts.isEmpty()) { %>
                <div class="alert alert-danger"><%= checkErrorSearchPosts %></div>
                <% } else if (messageSearchPosts != null && !messageSearchPosts.isEmpty()) { %>
                <div class="alert alert-success"><%= messageSearchPosts %></div>
                <% } else if (messageDeletePosts != null) { %>
                <div class="alert alert-success"><%= messageDeletePosts %></div>
                <% } else if (checkErrorDeletePosts != null) { %>
                <div class="alert alert-danger"><%= checkErrorDeletePosts %></div>
                <% } %>
            </div>
        </div>
    </body>
</html>