<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, dto.Banners" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Banners</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    </head>
    <body class="bg-light">
        <%
            String checkErrorDeleteBanners = (String) request.getAttribute("checkErrorDeleteBanners");
            String messageDeleteBanners = (String) request.getAttribute("messageDeleteBanners");
        %>

        <div class="container py-4">

            <% if (messageDeleteBanners != null) { %>
            <div class="alert alert-success alert-dismissible fade show"><%= messageDeleteBanners %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (checkErrorDeleteBanners != null) { %>
            <div class="alert alert-danger alert-dismissible fade show"><%= checkErrorDeleteBanners %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            
            <h2 class="text-center mb-4">Danh sách Banners</h2>

            <!-- Ô tìm kiếm -->
            <form class="d-flex mb-3" method="get" action="<%=request.getContextPath()%>/BannerController">
                <input type="hidden" name="action" value="search"/>
                <input class="form-control me-2" type="text" name="keyword" placeholder="Tìm theo tiêu đề..."/>
                <button class="btn btn-primary" type="submit">Tìm</button>
            </form>

            <table class="table table-bordered table-hover bg-white align-middle">
                <thead class="table-light">
                    <tr>
                        <th scope="col" style="width:5%;">ID</th>
                        <th scope="col" style="width:15%;">Ảnh</th>
                        <th scope="col">Tiêu đề</th>
                        <th scope="col" style="width:15%;">Trạng thái</th>
                        <th scope="col" style="width:20%;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        @SuppressWarnings("unchecked")
                        List<Banners> list = (List<Banners>) request.getAttribute("list");
                        if (list != null && !list.isEmpty()) {
                            for (Banners b : list) {
                    %>
                    <tr>
                        <td><%= b.getId() %></td>
                        <td>
                            <% if (b.getImage_url() != null && !b.getImage_url().isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/<%=b.getImage_url()%>" 
                                 alt="banner" style="height:60px; object-fit:cover; border-radius:4px;"/>
                            <% } else { %>
                            <span class="text-muted fst-italic">(Không có ảnh)</span>
                            <% } %>
                        </td>
                        <td><%= b.getTitle() %></td>
                        <td>
                            <span class="badge <%= b.getStatus().equalsIgnoreCase("active") ? "bg-success" : "bg-secondary" %>">
                                <%= b.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <form action="<%=request.getContextPath()%>/BannerController" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="editBanners"/>
                                <input type="hidden" name="id" value="<%= b.getId() %>"/>
                                <button type="submit" class="btn btn-sm btn-outline-secondary">Sửa</button>
                            </form>
                            <form action="<%=request.getContextPath()%>/BannerController" method="post" style="display:inline;"
                                  onsubmit="return confirm('Bạn có chắc chắn muốn xoá banner này?');">
                                <input type="hidden" name="action" value="deleteBanner"/>
                                <input type="hidden" name="id" value="<%= b.getId() %>"/>
                                <button type="submit" class="btn btn-sm btn-outline-danger">Xoá</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="text-center text-muted">Không có banner nào.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <div class="mt-3">
            <a href="bannersUpdate.jsp" class="btn btn-secondary">⬅ Quay về</a>
        </div>

    </body>
</html>
