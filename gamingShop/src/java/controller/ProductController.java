/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccessoriesDAO;
import dto.Accessories;
import dao.ProductImagesDAO;
import dao.ProductsDAO;
import dto.Page;
import dto.ProductFilter;
import dto.Product_images;
import dto.Products;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ProductController extends HttpServlet {

    private final ProductsDAO productsdao = new ProductsDAO();
    private final ProductImagesDAO productImagesDAO = new ProductImagesDAO();
    private final  AccessoriesDAO accessoriesDAO  = new AccessoriesDAO();

    String INDEX_PAGE = "index.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String url = INDEX_PAGE;
        try {
            String action = request.getParameter("action");

            if ("prepareHome".equals(action) || action == null) {
                handleViewAllProducts_sidebar(request, response);
                url = handleViewAllProducts(request, response);
            } else if (action.equals("searchProduct")) {
                handleViewAllProducts_sidebar(request, response);
                url = handleProductSearching(request, response);
            } else if (action.equals("filterProducts")) {
                handleViewAllProducts_sidebar(request, response);
                url = handleProductFiltering(request, response);
            } else if (action.equals("showAddProductForm")) {
                url = handleShowAddProductForm(request, response);
            } else if (action.equals("addProduct")) {
                url = handleProductAdding(request, response);
//            } else if (action.equals("editProduct")) {
//                url = handleProductEditing(request, response);
// Thêm các action handlers vào processRequest method
            } else if (action.equals("showAddAccessoryForm")) {
                url = handleShowAddAccessoryForm(request, response);
            } else if (action.equals("addAccessory")) {
                url = handleAccessoryAdding(request, response);
            } else if (action.equals("showEditAccessoryForm")) {
//     url = handleShowEditAccessoryForm(request, response);
// } else if (action.equals("editAccessory")) {
//     url = handleAccessoryEditing(request, response);
// } else if (action.equals("removeAccessory")) {
//     url = handleAccessoryRemoving(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Unexpected error: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public void handleViewAllProducts_sidebar(HttpServletRequest request, HttpServletResponse response) {
        List<Products> list = productsdao.getAll();
        request.setAttribute("list", list);
    }

    public String handleViewAllProducts(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Tạo filter mặc định
            ProductFilter filter = new ProductFilter();

            // Lấy tham số page nếu có
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    int page = Integer.parseInt(pageParam);
                    if (page > 0) {
                        filter.setPage(page);
                    }
                } catch (NumberFormatException e) {
                    // Ignore, use default page
                }
            }

            // Lấy dữ liệu với phân trang
            Page<Products> pageResult = productsdao.getProductsWithFilter(filter);

            // Gán hình ảnh cho từng sản phẩm
            for (Products p : pageResult.getContent()) {
                List<Product_images> images = productImagesDAO.getByProductId(p.getId());
                p.setImage(images);
            }

            request.setAttribute("pageResult", pageResult);
            request.setAttribute("currentFilter", filter);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading products: " + e.getMessage());
        }

        return INDEX_PAGE;
    }

    private String handleProductSearching(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String keyword = request.getParameter("keyword");
        List<Products> list;

        if (keyword != null && !keyword.trim().isEmpty()) {
            list = productsdao.getByName(keyword.trim());
            if (list == null || list.isEmpty()) {
                checkError = "No products found with name: " + keyword;
            } else {
                // Lấy danh sách ảnh cho từng sản phẩm
                for (Products p : list) {
                    List<Product_images> imgs = productImagesDAO.getByProductId(p.getId());
                    p.setImage(imgs); // Products giờ có field List<ProductImages> images + setter
                }
            }
        } else {
            list = productsdao.getAll();
            // cũng lấy danh sách ảnh cho tất cả sản phẩm
            for (Products p : list) {
                List<Product_images> imgs = productImagesDAO.getByProductId(p.getId());
                p.setImage(imgs);
            }
        }

        request.setAttribute("keyword", keyword);
        request.setAttribute("list", list);
        request.setAttribute("checkError", checkError);
        return "welcome.jsp";
    }

    /**
     * Xử lý lọc và phân trang sản phẩm
     */
    private String handleProductFiltering(HttpServletRequest request, HttpServletResponse response) {
        try {
            ProductFilter filter = createFilterFromRequest(request);

            Page<Products> pageResult = productsdao.getProductsWithFilter(filter);

            // Gán hình ảnh cho từng sản phẩm
            for (Products p : pageResult.getContent()) {
                List<Product_images> images = productImagesDAO.getByProductId(p.getId());
                p.setImage(images);
            }

            request.setAttribute("pageResult", pageResult);
            request.setAttribute("currentFilter", filter);

            if (pageResult.isEmpty()) {
                request.setAttribute("checkError", "No products found with current filter");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error filtering products: " + e.getMessage());
        }

        return INDEX_PAGE;
    }

    /**
     * Tạo ProductFilter từ request parameters
     */
    private ProductFilter createFilterFromRequest(HttpServletRequest request) {
        ProductFilter filter = new ProductFilter();

        // Tên sản phẩm
        String name = request.getParameter("name");
        if (name != null && !name.trim().isEmpty()) {
            filter.setName(name.trim());
        }

        // Loại sản phẩm
        String productType = request.getParameter("productType");
        if (productType != null && !productType.isEmpty()) {
            filter.setProductType(productType);
        }

        // Giá tối thiểu
        String minPriceStr = request.getParameter("minPrice");
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            try {
                double minPrice = Double.parseDouble(minPriceStr);
                if (minPrice >= 0) {
                    filter.setMinPrice(minPrice);
                }
            } catch (NumberFormatException e) {
                // Ignore invalid number
            }
        }

        // Giá tối đa
        String maxPriceStr = request.getParameter("maxPrice");
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try {
                double maxPrice = Double.parseDouble(maxPriceStr);
                if (maxPrice > 0) {
                    filter.setMaxPrice(maxPrice);
                }
            } catch (NumberFormatException e) {
                // Ignore invalid number
            }
        }

        // Sắp xếp
        String sortBy = request.getParameter("sortBy");
        if (sortBy != null && !sortBy.isEmpty()) {
            filter.setSortBy(sortBy);
        }

        // Trang hiện tại
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                int page = Integer.parseInt(pageStr);
                if (page > 0) {
                    filter.setPage(page);
                }
            } catch (NumberFormatException e) {
                // Ignore, use default page
            }
        }

        return filter;
    }

    private String handleShowAddProductForm(HttpServletRequest request, HttpServletResponse response) {
        // Chỉ forward ra form rỗng, không có dữ liệu sản phẩm
        request.setAttribute("product", null);
        return "productsUpdate.jsp";
    }

    private String handleProductAdding(HttpServletRequest request, HttpServletResponse response) {
        try {
            // ===== Lấy dữ liệu từ form =====
            String name = request.getParameter("name");
            String sku = request.getParameter("sku");
            double price = Double.parseDouble(request.getParameter("price"));
            String productType = request.getParameter("product_type");
            int modelId = Integer.parseInt(request.getParameter("model_id"));
            int memoryId = Integer.parseInt(request.getParameter("memory_id"));
            int guaranteeId = Integer.parseInt(request.getParameter("guarantee_id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String specHtml = request.getParameter("spec_html");
            String status = request.getParameter("status"); // active, inactive, Prominent

            // ===== Tạo sản phẩm trước =====
            Products newProduct = new Products();
            newProduct.setName(name);
            newProduct.setSku(sku);
            newProduct.setPrice(price);
            newProduct.setProduct_type(productType);
            newProduct.setModel_id(modelId);
            newProduct.setMemory_id(memoryId);
            newProduct.setGuarantee_id(guaranteeId);
            newProduct.setQuantity(quantity);
            newProduct.setDescription_html(specHtml);
            newProduct.setStatus(status);

            ProductsDAO productsdao = new ProductsDAO();
            int generatedId = productsdao.createNewProduct(newProduct); // lấy id tự tăng vừa tạo

            if (generatedId > 0) {
                newProduct.setId(generatedId); // fix id
                // ===== Upload ảnh =====
                List<Part> imageParts = new ArrayList<>();
                Part img1 = request.getPart("imageFile1");
                Part img2 = request.getPart("imageFile2");
                Part img3 = request.getPart("imageFile3");
                Part img4 = request.getPart("imageFile4");

                if (img1 != null && img1.getSize() > 0) {
                    imageParts.add(img1);
                }
                if (img2 != null && img2.getSize() > 0) {
                    imageParts.add(img2);
                }
                if (img3 != null && img3.getSize() > 0) {
                    imageParts.add(img3);
                }
                if (img4 != null && img4.getSize() > 0) {
                    imageParts.add(img4);
                }

                String uploadDir = getServletContext().getRealPath("/assets/img/products/");
                new File(uploadDir).mkdirs();

                List<Product_images> imageList = new ArrayList<>();
                int index = 1;
                for (Part imagePart : imageParts) {
                    String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                    String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                    String storedFileName = generatedId + "_" + (index++) + fileExtension;
                    String imagePath = uploadDir + File.separator + storedFileName;

                    // Lưu file vào thư mục
                    imagePart.write(imagePath);

                    // Tạo record ảnh
                    Product_images img = new Product_images();
                    img.setProduct_id(generatedId);
                    img.setImage_url("assets/img/products/" + storedFileName);
                    img.setCaption("");
                    img.setStatus(1); // default
                    imageList.add(img);
                }

                // ===== Lưu ảnh vào DB =====
                ProductImagesDAO imageDao = new ProductImagesDAO();
                for (Product_images img : imageList) {
                    imageDao.create(img);
                }

                // ===== Success =====
                HttpSession session = request.getSession();
                session.removeAttribute("cachedProductListEdit");
                request.setAttribute("messageAddProduct", "New product and images added successfully.");
                request.setAttribute("product", newProduct);
                request.setAttribute("productImages", imageList); // fix
                return "productsUpdate.jsp";
            } else {
                request.setAttribute("checkErrorAddProduct", "Failed to add product.");
                return "productsUpdate.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding product: " + e.getMessage());
            return "error.jsp";
        }
    }

    /**
     * Hiển thị form thêm accessory mới
     */
    private String handleShowAddAccessoryForm(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("accessory", null);
        return "accessoryUpdate.jsp";
    }

    /**
     * Xử lý thêm accessory mới
     */
    private String handleAccessoryAdding(HttpServletRequest request, HttpServletResponse response) {
        try {

            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            // Xử lý upload ảnh
            String imageUrl = "";
            Part imagePart = request.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadDir = getServletContext().getRealPath("/assets/img/accessories/");
                new File(uploadDir).mkdirs();

                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                String storedFileName = System.currentTimeMillis() + fileExtension;
                String imagePath = uploadDir + File.separator + storedFileName;

                imagePart.write(imagePath);
                imageUrl = "assets/img/accessories/" + storedFileName;
            }

            // Tạo accessory mới
            Accessories newAccessory = new Accessories();
            newAccessory.setName(name);
            newAccessory.setQuantity(quantity);
            newAccessory.setPrice(price);
            newAccessory.setDescription(description);
            newAccessory.setImage_url(imageUrl);
            newAccessory.setStatus(status);
            newAccessory.setCreated_at(new java.util.Date());
            newAccessory.setUpdated_at(new java.util.Date());

            // Thêm vào database
            boolean success = accessoriesDAO.create(newAccessory);
            if (success) {
                HttpSession session = request.getSession();
                session.removeAttribute("cachedAccessoryList");
                request.setAttribute("messageAddAccessory", "New accessory added successfully.");
                return "accessoryList.jsp";
            } else {
                request.setAttribute("checkErrorAddAccessory", "Failed to add accessory.");
                request.setAttribute("accessory", newAccessory);
                return "accessoryUpdate.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding accessory: " + e.getMessage());
            return "error.jsp";
        }
    }
}
