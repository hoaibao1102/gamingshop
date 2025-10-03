<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Banner</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            .wrapper{
                display:grid;
                grid-template-columns:260px 1fr;
                min-height:100vh
            }
            .sidebar{
                background:#111827
            }
            .Main_content{
                background:#f5f7fb;
                overflow-x:hidden
            }
            .container{
                padding:16px
            }

            body {
                min-height: 100vh;
            }

            .header {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 40px 20px;
                color: #333;
                text-align: center;
                margin-bottom: 50px;
                animation: fadeInDown 0.6s ease;
            }

            .header h1 {
                color: #fff;
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 10px;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
            }

            .header p {
                color: rgba(255,255,255,0.9);
                font-size: 1.1rem;
            }

            .card {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.15);
                overflow: hidden;
                animation: fadeInUp 0.6s ease;
            }

            .table-container {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            thead tr td {
                color: #fff;
                font-weight: 600;
                padding: 20px 25px;
                font-size: 0.95rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            thead tr td:first-child {
                width: 70%;
            }

            thead tr td:last-child {
                width: 30%;
            }

            tbody tr {
                border-bottom: 1px solid #f0f0f0;
                transition: all 0.3s ease;
            }

            tbody tr:hover {
                background: #f8f9ff;
                transform: scale(1.01);
            }

            tbody tr:last-child {
                border-bottom: none;
            }

            tbody tr td {
                padding: 25px;
                font-size: 0.95rem;
                color: #555;
            }

            tbody tr td:first-child {
                font-weight: 500;
                color: #333;
            }

            input[type="text"] {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 0.95rem;
                font-family: 'Inter', sans-serif;
                transition: all 0.3s ease;
                background: #f9f9f9;
            }

            input[type="text"]:focus {
                outline: none;
                border-color: #667eea;
                background: #fff;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .btn {
                color: black;
                padding: 10px 24px;
                border: none;
                border-radius: 10px;
                font-size: 0.9rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-family: 'Inter', sans-serif;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-edit {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #AB;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .btn-edit:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            .btn-save {
                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                color: #134a16;
                box-shadow: 0 4px 15px rgba(17, 153, 142, 0.3);
            }

            .btn-save:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(17, 153, 142, 0.4);
            }

            .btn-save:active, .btn-edit:active {
                transform: translateY(0);
            }

            .action-cell {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #999;
            }

            .empty-state i {
                font-size: 4rem;
                margin-bottom: 20px;
                opacity: 0.3;
            }

            @media (max-width: 768px) {
                .header h1 {
                    font-size: 1.8rem;
                }

                thead tr td {
                    padding: 15px;
                    font-size: 0.85rem;
                }

                tbody tr td {
                    padding: 15px;
                    font-size: 0.85rem;
                }

                .btn {
                    padding: 8px 16px;
                    font-size: 0.85rem;
                }

                .action-cell {
                    flex-direction: column;
                    align-items: stretch;
                }
            }
        </style>
        <script type="text/javascript">
            function editDescription(id, currentText) {
                document.getElementById('descriptionInput_' + id).style.display = 'block';
                document.getElementById('descriptionDisplay_' + id).style.display = 'none';
                document.getElementById('editButton_' + id).style.display = 'none';
                document.getElementById('saveButton_' + id).style.display = 'inline-flex';
                document.getElementById('descriptionInput_' + id).value = currentText;
                document.getElementById('descriptionInput_' + id).focus();
            }

            function saveDescription(id) {
                var updatedDescription = document.getElementById('descriptionInput_' + id).value;
                document.getElementById('description_' + id).value = updatedDescription;
            }
        </script>
    </head>
    <body>
        
        <div class="wrapper">
            <div class="sidebar"><jsp:include page="sidebar.jsp"/></div>
            <div class="Main_content">
                <jsp:include page="header.jsp"/>
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-bullhorn"></i> Quản Lý Banner</h1>
                <p>Chỉnh sửa nội dung banner hiển thị trên trang web</p>
            </div>

            <div class="card">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <td><i class="fas fa-align-left"></i> Nội Dung</td>
                                <td><i class="fas fa-cog"></i> Thao Tác</td>
                            </tr>                   
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${listBannerText}">
                                <tr>
                                    <td>
                                        <div id="descriptionDisplay_${item.id}">${item.bannerText}</div>
                                        <input type="text" id="descriptionInput_${item.id}" name="bannerText" style="display:none;">
                                    </td>
                                    <td>
                                        <div class="action-cell">
                                            <button type="button" class="btn btn-edit" id="editButton_${item.id}" onclick="editDescription(${item.id}, '${item.bannerText}')">
                                                <i class="fas fa-edit"></i> Sửa
                                            </button>
                                            
                                            <form action="MainController" method="get" style="display:inline;" onsubmit="saveDescription(${item.id})">
                                                <input type="hidden" name="action" value="updateBannerText">
                                                <input type="hidden" name="id" value="${item.id}">
                                                <input type="hidden" id="description_${item.id}" name="description">
                                                
                                                <button type="submit" class="btn btn-save" id="saveButton_${item.id}" style="display:none;">
                                                    <i class="fas fa-check"></i> Lưu
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        </div>
        </div>
    </body>
</html>