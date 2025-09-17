/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccessoriesDAO;
import dto.Accessories;
import dao.GuaranteesDAO;
import dao.MemoriesDAO;
import dao.ModelsDAO;
import dao.PostsDAO;
import dao.ProductImagesDAO;
import dao.ProductsDAO;
import dao.ServicesDAO;
import dto.Guarantees;
import dto.Memories;
import dto.Models;
import dto.Page;
import dto.Posts;
import dto.ProductFilter;
import dto.Product_images;
import dto.Products;
import dto.Services;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import utils.AuthUtils;

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
    private final AccessoriesDAO accessoriesDAO = new AccessoriesDAO();
    private final PostsDAO postsDAO = new PostsDAO();
    private final GuaranteesDAO guaranteesDAO = new GuaranteesDAO();
    private final MemoriesDAO memoriesDAO = new MemoriesDAO();
    private final ModelsDAO modelsDAO = new ModelsDAO();
    private final ServicesDAO servicesDAO = new ServicesDAO();
   
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
                url = handleProductSearching(request, response);
            } else if (action.equals("filterProducts")) {
                url = handleProductFiltering(request, response);
            } else if (action.equals("showAddProductForm")) {
                url = handleShowAddProductForm(request, response);
            } else if (action.equals("addProduct")) {
                url = handleProductAdding(request, response);
// ***Thêm các action handlers vào processRequest method ACCESSORY***
            } else if (action.equals("viewAllAccessories")) {
                url = handleViewAllAccessories(request, response);
            } else if (action.equals("searchAccessory")) {
                url = handleAccessorySearching(request, response);
            } else if (action.equals("showAddAccessoryForm")) {
                url = handleShowAddAccessoryForm(request, response);
            } else if (action.equals("addAccessory")) {
                url = handleAccessoryAdding(request, response);
            } else if (action.equals("showEditAccessoryForm")) {
                url = handleShowEditAccessoryForm(request, response);
            } else if (action.equals("editAccessory")) {
                url = handleAccessoryEditing(request, response);
            } else if (action.equals("deleteAccessory")) {
                url = handleAccessoryDelete(request, response);
                //========================================
            } else if (action.equals("editMainProduct")) {
                url = handleUpdateMainProduct(request, response);
            } else if (action.equals("editImageProduct")) {
                url = handleUpdateImageProduct(request, response);
            } else if (action.equals("deleteProduct")) {
                url = handleDeleteProduct(request, response);
            } else if (action.equals("deleteImageProduct")) {
                url = handleDeleteImageProduct(request, response);
                //========================================
            } else if (action.equals("viewAllPost")) {
                url = handleViewAllPost(request, response);
            } else if (action.equals("searchPosts")) {
                url = handlePostSearching(request, response);
            } else if (action.equals("addPosts")) {
                url = handleAddPosts(request, response);
            } else if (action.equals("deletePosts")) {
                url = handleDeletePosts(request, response);
            } else if (action.equals("deleteImagePost")) {
                url = handleDeleteImagePost(request, response);
            } else if (action.equals("goToUpdatePosts")) {
                url = handleGoToUpdatePosts(request, response);
            } else if (action.equals("updatePosts")) {
                url = handleUpdatePosts(request, response);
                //========================================
            } else if (action.equals("getProduct")) {
                url = handleGetProduct(request, response);
            } else if (action.equals("getProminentList")) {
                url = handleGetProminentList(request, response);
                //===============MODEL==================
            } else if (action.equals("viewModelList")) {
                url = handleModelList(request, response);
            } else if (action.equals("addModel")) {
                url = handleModelAdding(request, response);
            } else if (action.equals("showEditModel")) {
                url = handleModelEditForm(request, response);
            } else if (action.equals("editModel")) {
                url = handleModelEditing(request, response);
            } else if (action.equals("showAddModel")) {
                url = handleModelAddForm(request, response);
            } else if (action.equals("deleteModel")) {
                url = handleModelDelete(request, response);
                //==============SERVICES===============
            } else if (action.equals("viewServiceList")) {
                url = handleServiceList(request, response);
            } else if (action.equals("addService")) {
                url = handleServiceAdding(request, response);
            } else if (action.equals("showEditService")) {
                url = handleServiceEditForm(request, response);
            } else if (action.equals("editService")) {
                url = handleServiceEditing(request, response);
            } else if (action.equals("showAddService")) {
                url = handleServiceAddForm(request, response);
            } else if (action.equals("deleteService")) {
                url = handleServiceDelete(request, response);
            } else if (action.equals("listMayChoiGame")) {
                url = handleListMayChoiGame(request, response);
            }else if (action.equals("listTheGame")) {
                url = handleListTheGame(request, response);

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
        request.getSession().setAttribute("listForSidebar", list);
    }

    public String handleViewAllProducts(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
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
                if (images.size() > 0) {
                    p.setCoverImg(images.get(0).getImage_url());
                } else {
                    p.setCoverImg("");
                }
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
        request.setAttribute("checkErrorSearch", checkError);
        return "products.jsp";
    }

    /**
     * Xử lý lọc và phân trang sản phẩm
     */
    private String handleProductFiltering(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
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
        // nạp lại danh sách dropdown
        loadDropdownData(request);

        request.setAttribute("product", null);
        return "productsUpdate.jsp";
    }

    private String handleProductAdding(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
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
            String status = request.getParameter("status"); // trạng thái: active, inactive, prominent

            // ===== Tạo đối tượng Products và set dữ liệu =====
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
            // Lưu sản phẩm mới vào DB, trả về id tự tăng vừa tạo
            int generatedId = productsdao.createNewProduct(newProduct);

            if (generatedId > 0) {
                // Set lại id cho product (vì trước đó là null)
                newProduct.setId(generatedId);

                // ===== Upload ảnh =====
                List<Part> imageParts = new ArrayList<>();
                Part img1 = request.getPart("imageFile1");
                Part img2 = request.getPart("imageFile2");
                Part img3 = request.getPart("imageFile3");
                Part img4 = request.getPart("imageFile4");

                // Chỉ thêm file nào có upload (size > 0)
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

                // Thư mục lưu ảnh trên server
                String uploadDir = getServletContext().getRealPath("/assets/img/products/");
                new File(uploadDir).mkdirs();

                List<Product_images> imageList = new ArrayList<>();
                int index = 1;

                try {
                    // Lặp qua từng ảnh upload
                    for (Part imagePart : imageParts) {
                        String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                        // Đặt tên file: productId_index.ext
                        String storedFileName = generatedId + "_" + (index) + fileExtension;
                        String imagePath = uploadDir + File.separator + storedFileName;

                        // Ghi file vào thư mục
                        imagePart.write(imagePath);

                        // Tạo đối tượng Product_images
                        Product_images img = new Product_images();
                        img.setProduct_id(generatedId);
                        img.setImage_url("assets/img/products/" + storedFileName);
                        img.setCaption("");
                        img.setSort_order(index);   // QUAN TRỌNG: thứ tự ảnh (1..n)
                        img.setStatus(1);

                        imageList.add(img);
                        index++;
                    }

                    // Lưu ảnh vào DB
                    ProductImagesDAO imageDao = new ProductImagesDAO();
                    for (Product_images img : imageList) {
                        imageDao.create(img);
                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                    // Nếu lưu ảnh thất bại, vẫn tạo được product, nhưng báo warning
                    request.setAttribute("warning", "Product created but failed to upload some images: " + ex.getMessage());
                }

                // ===== Success =====
                HttpSession session = request.getSession();
                // Xoá cache danh sách edit product để reload lại
                session.removeAttribute("cachedProductListEdit");
                request.setAttribute("messageAddProduct", "New product and images added successfully.");
                request.setAttribute("product", newProduct);
                request.setAttribute("productImages", imageList); // gắn list ảnh để show ra

                // Đặt cờ: vừa Add xong (để JSP ẩn phần update 4 slot)
                request.setAttribute("justAdded", Boolean.TRUE);

                // Load dữ liệu cho dropdown (model, memory, guarantee…)
                loadDropdownData(request);

                // Quay lại trang productsUpdate.jsp
                return "productsUpdate.jsp";
            } else {
                // Nếu tạo thất bại
                request.setAttribute("checkErrorAddProduct", "Failed to add product.");
                loadDropdownData(request);
                return "productsUpdate.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding product: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleUpdateMainProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Lấy product_id từ form (tham số hidden "product_id")
            int product_id = Integer.parseInt(request.getParameter("product_id"));

            // Lấy các trường dữ liệu text cơ bản từ form
            String name = request.getParameter("name");
            String sku = request.getParameter("sku");

            // Biến price khởi tạo = 0, sẽ parse từ request
            double price = 0;
            try {
                // Lấy giá dạng chuỗi rồi parse double
                String priceString = request.getParameter("price");
                price = Double.parseDouble(priceString);
            } catch (NumberFormatException e) {
                // Nếu người dùng nhập giá không hợp lệ (không parse được số),
                // thì nạp lại sản phẩm hiện tại để hiển thị
                request.setAttribute("product", productsdao.getById(product_id));

                // Thêm: load danh sách ảnh của sản phẩm để tiếp tục hiển thị trong JSP
                ProductImagesDAO imageDao = new ProductImagesDAO();
                List<Product_images> productImages = imageDao.getByProductId(product_id);
                request.setAttribute("productImages", productImages);

                // Nạp lại dữ liệu cho các dropdown (model/memory/guarantee)
                loadDropdownData(request);

                // Quay về trang chỉnh sửa cùng với dữ liệu đã nạp
                return "productsUpdate.jsp";
            }

            // Validate: giá phải >= 0, nếu không thì báo lỗi và giữ nguyên trang
            if (price < 0) {
                request.setAttribute("checkErrorUpdateProductMain", "Price must be >= 0.");
                request.setAttribute("product", productsdao.getById(product_id));

                // Thêm: load lại ảnh để không mất khi reload trang
                ProductImagesDAO imageDao = new ProductImagesDAO();
                List<Product_images> productImages = imageDao.getByProductId(product_id);
                request.setAttribute("productImages", productImages);

                loadDropdownData(request);
                return "productsUpdate.jsp";
            }

            // Parse quantity, nếu nhập sai định dạng thì trả về trang cùng thông báo
            int quantity = 0;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException e) {
//                request.setAttribute("checkErrorUpdateProductMain", "Quantity must be a valid number.");
                request.setAttribute("product", productsdao.getById(product_id));

                // Thêm: load ảnh khi có lỗi để tránh mất ảnh trên giao diện
                ProductImagesDAO imageDao = new ProductImagesDAO();
                List<Product_images> productImages = imageDao.getByProductId(product_id);
                request.setAttribute("productImages", productImages);

                loadDropdownData(request);
                return "productsUpdate.jsp";
            }

            // Lấy các trường còn lại từ form
            String productType = request.getParameter("product_type");
            int model_id = Integer.parseInt(request.getParameter("model_id"));
            int memory_id = Integer.parseInt(request.getParameter("memory_id"));
            int guarantee_id = Integer.parseInt(request.getParameter("guarantee_id"));
            String specHtml = request.getParameter("spec_html");
            String status = request.getParameter("status");

            // Giữ keyword (nếu có) để sau khi update xong còn dùng lại (ví dụ khi quay về list)
            String keyword = request.getParameter("keyword");

            // Tạo đối tượng Products và set lại các thông tin mới từ form
            Products newProduct = new Products();
            newProduct.setId(product_id);
            newProduct.setName(name);
            newProduct.setSku(sku);
            newProduct.setPrice(price);
            newProduct.setProduct_type(productType);
            newProduct.setModel_id(model_id);
            newProduct.setMemory_id(memory_id);
            newProduct.setGuarantee_id(guarantee_id);
            newProduct.setQuantity(quantity);
            newProduct.setDescription_html(specHtml);
            newProduct.setStatus(status);

            // Thực hiện update vào DB
            boolean success = productsdao.update(newProduct);

            // Đặt thông báo tuỳ theo kết quả update
            if (success) {
                // Xoá cache list sản phẩm trong session (nếu có) để đảm bảo dữ liệu mới
                request.getSession().removeAttribute("cachedProductListEdit");
                request.setAttribute("messageUpdateProductMain", "Product updated successfully.");
            } else {
                request.setAttribute("checkErrorUpdateProductMain", "Failed to update product.");
            }

            // Sau khi update, nạp lại sản phẩm mới nhất từ DB để hiển thị chính xác
            Products refreshedProduct = productsdao.getById(product_id);
            request.setAttribute("product", refreshedProduct);

            // Load ảnh hiện tại của sản phẩm (chỉ lấy ảnh status=1 theo DAO của bạn)
            ProductImagesDAO imageDao = new ProductImagesDAO();
            List<Product_images> productImages = imageDao.getByProductId(product_id);
            request.setAttribute("productImages", productImages);

            // Giữ lại keyword (nếu có) để JSP sử dụng (ví dụ gắn vào link/back)
            request.setAttribute("keyword", keyword);

            // Luôn nạp lại dữ liệu dropdown để form không bị mất option
            loadDropdownData(request);

            // Quay lại trang cập nhật sản phẩm
            return "productsUpdate.jsp";
        } catch (Exception e) {
            // Bắt mọi lỗi không lường trước, log ra và chuyển đến trang error.jsp
            e.printStackTrace();
            request.setAttribute("checkError", "Unexpected error: " + e.getMessage());

            // Thêm thông tin quyền truy cập/đăng nhập nếu có dùng cơ chế AuthUtils trong error.jsp
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());

            return "error.jsp";
        }
    }

    private void loadDropdownData(HttpServletRequest request) {
        ModelsDAO modelTypeDAO = new ModelsDAO();
        MemoriesDAO memoryTypeDAO = new MemoriesDAO();
        GuaranteesDAO guaranteeTypeDAO = new GuaranteesDAO();

        request.setAttribute("modelTypes", modelTypeDAO.getAll());
        request.setAttribute("memoryTypes", memoryTypeDAO.getAll());
        request.setAttribute("guaranteeTypes", guaranteeTypeDAO.getAll());
    }

    private String handleUpdateImageProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Lấy productId từ tham số form (hidden input "product_id")
            int productId = Integer.parseInt(request.getParameter("product_id"));
            // Lấy keyword (nếu có) để gán lại cho JSP sau khi xử lý
            String keyword = request.getParameter("keyword");

            // Xác định thư mục lưu ảnh vật lý trên server: /assets/img/products/ trong webapp
            String uploadPath = request.getServletContext().getRealPath("/assets/img/products/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                // Nếu thư mục chưa tồn tại thì tạo mới
                uploadDir.mkdirs();
            }

            // Cờ tổng hợp kết quả xử lý; dùng &= để "AND dồn" nhiều kết quả con
            boolean success = true;

            // Duyệt đủ 4 "slot" ảnh (imageFile1..imageFile4), mỗi slot tương ứng sort_order = 1..4
            for (int slot = 1; slot <= 4; slot++) {
                // Lấy Part tương ứng tên input file của slot hiện tại
                Part p = request.getPart("imageFile" + slot); // imageFile1..imageFile4
                // Chỉ xử lý khi có file được chọn (size > 0)
                if (p != null && p.getSize() > 0) {
                    // 1) Soft delete ảnh hiện tại của slot này (nếu có)
                    //    Hàm này được kỳ vọng sẽ tìm ảnh theo (product_id, sort_order=slot) và set status=0
                    productImagesDAO.softDeleteByProductAndSlot(productId, slot);

                    // 2) Upload ảnh mới lên thư mục đích
                    //    - Lấy tên file gốc
                    String fileName = Paths.get(p.getSubmittedFileName()).getFileName().toString();
                    //    - Tạo tên file lưu trữ duy nhất: {productId}_{timestamp}_{originalName}
                    String storedFileName = productId + "_" + System.currentTimeMillis() + "_" + fileName;
                    //    - Đường dẫn đầy đủ tới file đích
                    String filePath = uploadPath + File.separator + storedFileName;
                    //    - Ghi dữ liệu file vào ổ đĩa
                    p.write(filePath);

                    // 3) Tạo record ảnh mới vào DB, gắn đúng sort_order = slot, bật status=1 (đang hoạt động)
                    Product_images newImg = new Product_images();
                    newImg.setProduct_id(productId);
                    //     Đường dẫn ảnh để client truy cập (tính từ context root)
                    newImg.setImage_url("assets/img/products/" + storedFileName);
                    //     Chưa nhập caption => để rỗng (nếu muốn giữ caption cũ, cần query trước đó)
                    newImg.setCaption("");
                    //     Giữ đúng vị trí hiển thị bằng sort_order
                    newImg.setSort_order(slot);
                    //     1 = active/hiển thị
                    newImg.setStatus(1);
                    //     Ghi DB; dùng &= để dồn kết quả với các slot khác
                    success &= productImagesDAO.create(newImg);
                }
            }

            // Đặt thông báo thành công/thất bại tổng thể cho lần cập nhật
            if (success) {
                // Nếu có cache list sản phẩm để edit trong session thì xoá để lần sau nạp mới
                request.getSession().removeAttribute("cachedProductListEdit");
                request.setAttribute("messageUpdateProductImage", "Product images updated successfully.");
            } else {
                request.setAttribute("checkErrorUpdateProductImage", "Failed to update product images.");
            }

            // Sau khi cập nhật xong, reload lại dữ liệu sản phẩm + danh sách ảnh để hiển thị chính xác
            Products product = productsdao.getById(productId);
            // Lấy danh sách ảnh đang active (status=1). DAO nên trả về theo sort_order nếu đã sắp xếp.
            List<Product_images> images = productImagesDAO.getByProductId(productId);
            product.setImage(images);

            // Gắn lại các attribute cho JSP
            request.setAttribute("product", product);
            request.setAttribute("productImages", images);
            request.setAttribute("keyword", keyword);

            // Quay lại trang cập nhật sản phẩm
            return "productsUpdate.jsp";
        } catch (Exception e) {
            // Bắt mọi lỗi không lường trước, log ra và hiển thị thông báo lỗi nhẹ nhàng trên JSP
            e.printStackTrace();
            request.setAttribute("checkErrorUpdateProductImage", "Unexpected error: " + e.getMessage());
            return "productsUpdate.jsp";
        }
    }

    private String handleDeleteImageProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            String deleteImgId = request.getParameter("deleteImgId");
            if (deleteImgId != null && !deleteImgId.isEmpty()) {
                int imgId = Integer.parseInt(deleteImgId);
                boolean success = productImagesDAO.deleteImageById(imgId);
                if (success) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("OK");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Failed");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing image ID");
            }
            return null; // vì Ajax không cần forward/redirect JSP
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error: " + e.getMessage());
            } catch (IOException ignored) {
            }
            return null;
        }
    }

    private String handleDeleteProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Lấy productId từ tham số form (hidden input "product_id")
            int productId = Integer.parseInt(request.getParameter("product_id"));

            if (productId < 1) {
                request.setAttribute("checkErrorDeleteProduct", "Missing product_id.");
                return "MainController?action=searchProduct";
            }

            boolean success = productsdao.deleteProductById(productId);

            if (success) {
                // Nếu có cache list sản phẩm để edit trong session thì xoá để lần sau nạp mới
                request.getSession().removeAttribute("cachedProductListEdit");
                request.setAttribute("messageDeleteProduct", "Product deleted successfully.");
            } else {
                request.setAttribute("checkErrorDeleteProduct", "Failed to delete product.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorDeleteProduct", "Unexpected error: " + e.getMessage());
            return "MainController?action=searchProduct";
        }
        return "MainController?action=searchProduct";
    }

    /**
     * Hiển thị danh sách tất cả accessories với phân trang
     */
    private String handleViewAllAccessories(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy tất cả accessories từ database
            List<Accessories> accessories = accessoriesDAO.getAllActive();

            // Set vào request để JSP hiển thị
            request.setAttribute("accessories", accessories);

            // Thông báo nếu không có dữ liệu
            if (accessories == null || accessories.isEmpty()) {
                request.setAttribute("checkError", "No accessories found. Start by adding your first accessory.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading accessories: " + e.getMessage());
            // Set empty list để tránh null pointer trong JSP
            request.setAttribute("accessories", new ArrayList<Accessories>());
        }

        return "accessoryList.jsp";
    }

    /**
     * Tìm kiếm accessories theo từ khóa
     */
    private String handleAccessorySearching(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy từ khóa tìm kiếm
            String keyword = request.getParameter("keyword");
            List<Accessories> accessories = new ArrayList<>();

            if (keyword != null && !keyword.trim().isEmpty()) {
                String trimmedKeyword = keyword.trim();

                // Tìm kiếm theo tên
                accessories = accessoriesDAO.getByName(trimmedKeyword);

                // Set keyword để hiển thị lại trong form
                request.setAttribute("keyword", trimmedKeyword);

                if (accessories == null || accessories.isEmpty()) {
                    request.setAttribute("checkError", "No accessories found with name containing: \"" + trimmedKeyword + "\"");
                    accessories = new ArrayList<>(); // Ensure not null
                } else {
                    // Thông báo số kết quả tìm được
                    request.setAttribute("searchResultCount", accessories.size());
                }
            } else {
                // Nếu không có từ khóa, hiển thị tất cả accessories
                accessories = accessoriesDAO.getAllActive();

                if (accessories == null) {
                    accessories = new ArrayList<>();
                }

                if (accessories.isEmpty()) {
                    request.setAttribute("checkError", "No accessories available.");
                }

                // Clear keyword
                request.setAttribute("keyword", "");
            }

            // Set accessories list
            request.setAttribute("accessories", accessories);

            // Set thông tin cho pagination (disable pagination trong search mode)
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalAccessories", accessories.size());
            request.setAttribute("isSearchMode", true); // Flag để JSP biết đang ở search mode

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error searching accessories: " + e.getMessage());

            // Set empty results
            request.setAttribute("accessories", new ArrayList<Accessories>());
            request.setAttribute("keyword", request.getParameter("keyword"));
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalAccessories", 0);
        }

        return "accessoryList.jsp";
    }

    /**
     * Hiển thị form thêm accessory mới
     */
    private String handleShowAddAccessoryForm(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("accessory", null);
        return "accessoryUpdate.jsp";
    }

    /**
     * DEBUG VERSION - Xử lý thêm accessory mới
     */
    private String handleAccessoryAdding(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // ===== Lấy dữ liệu từ form =====
            String name = request.getParameter("name");
            String quantityStr = request.getParameter("quantity");
            String priceStr = request.getParameter("price");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String gift = request.getParameter("gift");

            // ===== VALIDATION SECTION - ENHANCED =====
            // 1. Validate name - required and not empty
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("checkErrorAddAccessory", "Accessory name is required.");
                return "accessoryUpdate.jsp";
            }

            // 2. Validate name length (reasonable limit)
            if (name.trim().length() > 255) {
                request.setAttribute("checkErrorAddAccessory", "Accessory name must be 255 characters or less.");
                return "accessoryUpdate.jsp";
            }

            // 3. NEW: Check for duplicate name (UNIQUE constraint validation)
            try {

                if (accessoriesDAO.isNameExists(name)) {
                    request.setAttribute("checkErrorAddAccessory", "Accessory name '" + name.trim() + "' already exists. Please choose a different name.");
                    return "accessoryUpdate.jsp";
                }
            } catch (Exception e) {
                // If we can't check, continue but log the error
                e.printStackTrace();
            }

            // 4. Validate quantity - required, numeric, and non-negative
            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                request.setAttribute("checkErrorAddAccessory", "Quantity is required.");
                return "accessoryUpdate.jsp";
            }

            // 5. Validate price - required, numeric, and non-negative
            if (priceStr == null || priceStr.trim().isEmpty()) {
                request.setAttribute("checkErrorAddAccessory", "Price is required.");
                return "accessoryUpdate.jsp";
            }

            int quantity = 0;
            double price = 0.0;
            try {
                quantity = Integer.parseInt(quantityStr.trim());

                // 6. Validate quantity range
                if (quantity < 0) {
                    request.setAttribute("checkErrorAddAccessory", "Quantity cannot be negative.");
                    return "accessoryUpdate.jsp";
                }

                // Optional: reasonable upper limit for quantity
                if (quantity > 999999) {
                    request.setAttribute("checkErrorAddAccessory", "Quantity cannot exceed 999,999.");
                    return "accessoryUpdate.jsp";
                }

            } catch (NumberFormatException e) {
                request.setAttribute("checkErrorAddAccessory", "Invalid quantity format. Please enter a valid number.");
                return "accessoryUpdate.jsp";
            }

            try {
                price = Double.parseDouble(priceStr.trim());

                // 7. Validate price range
                if (price < 0) {
                    request.setAttribute("checkErrorAddAccessory", "Price cannot be negative.");
                    return "accessoryUpdate.jsp";
                }

                // Optional: reasonable upper limit for price
                if (price > 999999999.99) {
                    request.setAttribute("checkErrorAddAccessory", "Price cannot exceed 999,999,999.99.");
                    return "accessoryUpdate.jsp";
                }

            } catch (NumberFormatException e) {
                e.getMessage();
                request.setAttribute("checkErrorAddAccessory", "Invalid price format. Please enter a valid decimal number.");
                return "accessoryUpdate.jsp";
            }

            // 8. NEW: Validate status value
            if (status != null && !status.trim().isEmpty()) {
                String normalizedStatus = status.trim().toLowerCase();
                if (!normalizedStatus.equals("active") && !normalizedStatus.equals("inactive")) {
                    request.setAttribute("checkErrorAddAccessory", "Status must be either 'active' or 'inactive'.");
                    return "accessoryUpdate.jsp";
                }
            }

            // 9. NEW: Validate gift value
            if (gift != null && !gift.trim().isEmpty()) {
                String normalizedGift = gift.trim();
                if (!normalizedGift.equals("Phụ kiện tặng kèm") && !normalizedGift.equals("Phụ kiện bán")) {
                    request.setAttribute("checkErrorAddAccessory", "Gift option must be either 'Phụ kiện bán' or 'Phụ kiện tặng kèm'.");
                    return "accessoryUpdate.jsp";
                }
            }

            // 10. NEW: Validate description length (optional but if provided, should be reasonable)
            if (description != null && description.trim().length() > 5000) {
                request.setAttribute("checkErrorAddAccessory", "Description must be 5000 characters or less.");
                return "accessoryUpdate.jsp";
            }

            // ===== Tạo đối tượng Accessories và set dữ liệu =====
            Accessories newAccessory = new Accessories();
            newAccessory.setName(name.trim());
            newAccessory.setQuantity(quantity);
            newAccessory.setPrice(price);
            newAccessory.setDescription(description != null ? description.trim() : "");
            newAccessory.setStatus(status != null ? status.trim() : "active");
            newAccessory.setGift(gift != null ? gift.trim() : "Phụ kiện tặng kèm");
            newAccessory.setCreated_at(new java.util.Date());
            newAccessory.setUpdated_at(new java.util.Date());

            // ===== Upload ảnh (nếu có) =====
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
//                System.out.println("DEBUG: Image part retrieved - "
//                        + (imagePart != null ? "Size: " + imagePart.getSize() + ", FileName: " + imagePart.getSubmittedFileName() : "NULL"));
            } catch (Exception e) {
                e.getMessage();
            }

            // 11. NEW: Validate image file if provided
            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Check file size (e.g., max 5MB)
                long maxFileSize = 5 * 1024 * 1024; // 5MB in bytes
                if (imagePart.getSize() > maxFileSize) {
                    request.setAttribute("checkErrorAddAccessory", "Image file size cannot exceed 5MB.");
                    return "accessoryUpdate.jsp";
                }

                // Check file extension
                String fileName = imagePart.getSubmittedFileName().toLowerCase();
                if (!fileName.endsWith(".jpg") && !fileName.endsWith(".jpeg")
                        && !fileName.endsWith(".png") && !fileName.endsWith(".gif")
                        && !fileName.endsWith(".bmp") && !fileName.endsWith(".webp")) {
                    request.setAttribute("checkErrorAddAccessory", "Only image files (jpg, jpeg, png, gif, bmp, webp) are allowed.");
                    return "accessoryUpdate.jsp";
                }
            }

            String storedImageUrl = null;
            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Thư mục lưu ảnh
                String uploadDirPath = request.getServletContext().getRealPath("/assets/accessories/");

                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Lấy extension
                String originalFileName = imagePart.getSubmittedFileName();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0 && dot < originalFileName.length() - 1) {
                    fileExtension = originalFileName.substring(dot);
                }

                // Tạo tên file tạm
                String tempName = "tmp_" + System.currentTimeMillis() + fileExtension;
                File tempFile = new File(uploadDir, tempName);

                try {
                    imagePart.write(tempFile.getAbsolutePath());
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("checkErrorAddAccessory", "Failed to upload image. Please try again.");
                    return "accessoryUpdate.jsp";
                }

                // Set image_url tạm thời là null để insert trước
                newAccessory.setImage_url(null);

                // ===== Insert để lấy generated ID =====
                boolean success = accessoriesDAO.create(newAccessory);

                if (success && newAccessory.getId() > 0) {
                    // Đổi tên file theo ID thực
                    String finalName = "acc_" + newAccessory.getId() + "_1" + fileExtension;
                    File finalFile = new File(uploadDir, finalName);

                    boolean renamed = tempFile.renameTo(finalFile);

                    if (!renamed) {
                        // Copy và xóa file tạm nếu rename thất bại
                        try ( java.io.InputStream in = new java.io.FileInputStream(tempFile);  java.io.OutputStream out = new java.io.FileOutputStream(finalFile)) {
                            byte[] buf = new byte[8192];
                            int len;
                            while ((len = in.read(buf)) > 0) {
                                out.write(buf, 0, len);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    storedImageUrl = "assets/accessories/" + finalName;
                    newAccessory.setImage_url(storedImageUrl);

                    // Update image_url vào DB
                    accessoriesDAO.update(newAccessory);

                } else {
                    // Insert thất bại -> xóa file tạm
                    if (tempFile.exists()) {
                        tempFile.delete();
                    }
                    request.setAttribute("checkErrorAddAccessory", "Failed to add accessory.");
                    return "accessoryUpdate.jsp";
                }

            } else {
                // KHÔNG có ảnh -> insert luôn
                newAccessory.setImage_url(null);
                boolean success = accessoriesDAO.create(newAccessory);

                if (!success) {
                    request.setAttribute("checkErrorAddAccessory", "Failed to add accessory.");
                    return "accessoryUpdate.jsp";
                }
            }

            // ===== Success =====
            HttpSession session = request.getSession();
            session.removeAttribute("cachedAccessoryList");

            request.setAttribute("messageAddAccessory", "New accessory added successfully.");
            request.setAttribute("accessory", newAccessory);
            return handleViewAllAccessories(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorAddAccessory", "Error while adding accessory: " + e.getMessage());
            return "accessoryUpdate.jsp";
        }
    }

    /**
     * Hiển thị form edit accessory
     */
    private String handleShowEditAccessoryForm(HttpServletRequest request, HttpServletResponse response) {
        try {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int accessoryId = Integer.parseInt(idStr);
                Accessories accessory = accessoriesDAO.getById(accessoryId);

                if (accessory != null) {
                    request.setAttribute("accessory", accessory);
                    return "accessoryUpdate.jsp";
                } else {
                    request.setAttribute("checkError", "Accessory not found with ID: " + accessoryId);
                }
            } else {
                request.setAttribute("checkError", "Invalid accessory ID.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("checkError", "Invalid accessory ID format.");
        } catch (Exception e) {
            request.setAttribute("checkError", "Error loading accessory: " + e.getMessage());
        }

        return "accessoryList.jsp";
    }

    /**
     * Xử lý cập nhật
     */
    private String handleAccessoryEditing(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // Lấy ID
            int accessoryId = Integer.parseInt(request.getParameter("id"));
            Accessories existingAccessory = accessoriesDAO.getById(accessoryId);

            if (existingAccessory == null) {
                request.setAttribute("checkErrorEditAccessory", "Accessory not found.");
                return "accessoryUpdate.jsp";
            }

            // ===== Lấy dữ liệu từ form =====
            String name = request.getParameter("name");
            String quantityStr = request.getParameter("quantity");
            String priceStr = request.getParameter("price");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String gift = request.getParameter("gift");

            // Validate
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("checkErrorEditAccessory", "Accessory name is required.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

            int quantity;
            double price;
            try {
                quantity = Integer.parseInt(quantityStr);
                price = Double.parseDouble(priceStr);
            } catch (NumberFormatException e) {
                request.setAttribute("checkErrorEditAccessory", "Invalid quantity or price format.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

            // Update basic info
            existingAccessory.setName(name.trim());
            existingAccessory.setQuantity(quantity);
            existingAccessory.setPrice(price);
            existingAccessory.setDescription(description != null ? description.trim() : "");
            existingAccessory.setStatus(status);
            existingAccessory.setGift(gift);
            existingAccessory.setUpdated_at(new java.util.Date());

            // ===== Xử lý ảnh mới (nếu có) =====
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception ignore) {
            }

            String oldImageUrl = existingAccessory.getImage_url();

            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Upload ảnh mới
                String uploadDirPath = request.getServletContext().getRealPath("/uploads/accessories/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFileName = imagePart.getSubmittedFileName();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0) {
                    fileExtension = originalFileName.substring(dot);
                }

                String newFileName = "acc_" + accessoryId + "_" + System.currentTimeMillis() + fileExtension;
                File newFile = new File(uploadDir, newFileName);
                imagePart.write(newFile.getAbsolutePath());

                existingAccessory.setImage_url("assets/accessories/" + newFileName);
            }

            // ===== Update database =====
            boolean success = accessoriesDAO.update(existingAccessory);

            if (success) {
                // Xóa ảnh cũ nếu có ảnh mới
                if (imagePart != null && imagePart.getSize() > 0
                        && oldImageUrl != null && !oldImageUrl.isEmpty()) {
                    File oldFile = new File(request.getServletContext().getRealPath("/" + oldImageUrl));
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                HttpSession session = request.getSession();
                session.removeAttribute("cachedAccessoryList");

                request.setAttribute("messageEditAccessory", "Accessory updated successfully.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            } else {
                request.setAttribute("checkErrorEditAccessory", "Failed to update accessory.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorEditAccessory", "Error while updating accessory: " + e.getMessage());
            return "accessoryUpdate.jsp";
        }
    }

    /**
     * Xử lý xóa accessory - Soft delete bằng cách chuyển status thành
     * "inactive"
     */
    private String handleAccessoryDelete(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // Lấy ID từ parameter
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("checkError", "Accessory ID is required.");
                return "accessoryList.jsp";
            }

            int accessoryId;
            try {
                accessoryId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                request.setAttribute("checkError", "Invalid accessory ID format.");
                return "accessoryList.jsp";
            }

            // Kiểm tra accessory có tồn tại không
            Accessories existingAccessory = accessoriesDAO.getById(accessoryId);
            if (existingAccessory == null) {
                request.setAttribute("checkError", "Accessory not found.");
                return "accessoryList.jsp";
            }

            // Kiểm tra xem đã inactive chưa
            if ("inactive".equalsIgnoreCase(existingAccessory.getStatus())) {
                request.setAttribute("checkError", "Accessory is already inactive.");
                return "accessoryList.jsp";
            }

            // Soft delete: chuyển status thành "inactive"
            existingAccessory.setStatus("inactive");
            existingAccessory.setUpdated_at(new java.util.Date());

            // Cập nhật vào database
            boolean success = accessoriesDAO.update(existingAccessory);

            if (success) {
                // Xóa cache nếu có
                HttpSession session = request.getSession();
                session.removeAttribute("cachedAccessoryList");

                request.setAttribute("messageDeleteAccessory",
                        "Accessory '" + existingAccessory.getName() + "' has been deactivated successfully.");

                // Có thể redirect về danh sách hoặc return view
                return handleViewAllAccessories(request, response);

            } else {
                request.setAttribute("checkError",
                        "Failed to deactivate accessory. Please try again.");
                return "accessoryList.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError",
                    "Error while deactivating accessory: " + e.getMessage());
            return "accessoryList.jsp";
        }
    }

    private String handleViewAllPost(HttpServletRequest request, HttpServletResponse response) {
        List<Posts> list = postsDAO.getAll();
        request.setAttribute("list", list);
        return "posts.jsp";
    }

    private String handlePostSearching(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String keyword = request.getParameter("keyword");
        List<Posts> list;

        if (keyword != null && !keyword.trim().isEmpty()) {
            list = postsDAO.getByName(keyword.trim());
            if (list == null || list.isEmpty()) {
                checkError = "No posts found with name: " + keyword;
            }
        } else {
            list = postsDAO.getAll();
        }

        request.setAttribute("keyword", keyword);
        request.setAttribute("list", list);
        request.setAttribute("checkErrorSearchPosts", checkError);
        return "posts.jsp";
    }

    private String handleAddPosts(HttpServletRequest request, HttpServletResponse response) {
        String message = "";
        String checkError = "";
        try {
            request.setCharacterEncoding("UTF-8");
            String author = request.getParameter("author");
            String title = request.getParameter("title");
            String content = request.getParameter("content_html");
            String statusStr = request.getParameter("status");
            String publishDateStr = request.getParameter("publish_date");
            int status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : 0;
            Date publishDate = null;
            if (publishDateStr != null && !publishDateStr.isEmpty()) {
                try {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                    publishDate = sdf.parse(publishDateStr);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // --- Xử lý file upload ---
            Part filePart = request.getPart("image"); // input name="image"
            String fileName = null;
            String imageUrl = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = request.getServletContext().getRealPath("/assets/img/posts");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                imageUrl = "assets/img/posts/" + fileName;
            }

            // --- Tạo object ---
            Posts post = new Posts();
            post.setAuthor(author);
            post.setTitle(title);
            post.setContent_html(content);
            post.setImage_url(imageUrl);
            post.setPublish_date(publishDate);
            post.setStatus(status);

            // --- Lưu xuống DB ---
            PostsDAO dao = new PostsDAO();
            int newId = dao.createNewPost(post);
            if (newId > 0) {
                message = "Post created successfully";
                request.setAttribute("messageAddPosts", message);
            } else {
                checkError = "Failed to create post.";
                request.setAttribute("checkErrorAddPosts", checkError);
            }

            // --- set lại dữ liệu nhập ---
            request.setAttribute("post", post); // ✅ Quan trọng: đưa object post vào request
            request.setAttribute("author", author);
            request.setAttribute("title", title);
            request.setAttribute("content_html", content);
            request.setAttribute("publish_date", publishDateStr); // giữ nguyên string cho input date
            request.setAttribute("status", statusStr);
            request.setAttribute("image_url", imageUrl);

        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
            request.setAttribute("messageAddPosts", message);
        }
        return "postsUpdate.jsp";
    }

    private String handleDeletePosts(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Lấy productId từ tham số form (hidden input "product_id")
            int id = Integer.parseInt(request.getParameter("id"));

            if (id < 1) {
                request.setAttribute("checkErrorDeletePosts", "Missing product_id.");
                return "posts.jsp";
            }

            boolean success = postsDAO.deletePostById(id);

            if (success) {
                // Nếu có cache list sản phẩm để edit trong session thì xoá để lần sau nạp mới
                request.getSession().removeAttribute("cachedProductListEdit");
                request.setAttribute("messageDeletePosts", "Posts deleted successfully.");
            } else {
                request.setAttribute("checkErrorDeletePosts", "Failed to delete posts.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorDeletePosts", "Unexpected error: " + e.getMessage());
            return "posts.jsp";
        }
        return "MainController?action=viewAllPost";
    }

    private String handleUpdatePosts(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(request.getParameter("id"));

            // ===== Lấy dữ liệu từ form =====
            String author = request.getParameter("author");
            if (author == null || author.trim().isEmpty()) {
                author = "Admin";
            }
            String title = request.getParameter("title");
            String content_html = request.getParameter("content_html");

            // publish_date
            String publishDateStr = request.getParameter("publish_date");
            Date publishDate = null;
            if (publishDateStr != null && !publishDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                    publishDate = formatter.parse(publishDateStr.trim());
                } catch (ParseException e) {
                    publishDate = new Date();
                }
            } else {
                publishDate = new Date();
            }

            // status
            int status = 1;

            try {
                status = Integer.parseInt(request.getParameter("status"));
            } catch (Exception ignore) {
            }

            // ===== Lấy post cũ để giữ ảnh nếu không upload mới =====
            Posts oldPost = postsDAO.getById(id);
            String imageUrl = oldPost != null ? oldPost.getImage_url() : null;

            // ===== Xử lý ảnh upload =====
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = request.getServletContext().getRealPath("/assets/img/posts");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                imageUrl = "assets/img/posts/" + fileName;
            }

            // ===== Tạo đối tượng mới =====
            Posts updatePost = new Posts();
            updatePost.setId(id);
            updatePost.setAuthor(author);
            updatePost.setTitle(title);
            updatePost.setContent_html(content_html);
            updatePost.setPublish_date(publishDate);
            updatePost.setStatus(status);
            updatePost.setImage_url(imageUrl);

            // ===== Update vào DB =====
            boolean success = postsDAO.updatePost(updatePost, id);
            if (success) {
                request.setAttribute("messageUpdatePosts", "Post updated successfully.");
                request.setAttribute("post", postsDAO.getById(id)); // set lại để hiện ra trong form
                return "postsUpdate.jsp"; // quay lại form edit
            } else {
                request.setAttribute("checkErrorUpdatePosts", "Failed to update post.");
                return "postsUpdate.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorUpdatePosts", "Error while updating post: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleGoToUpdatePosts(HttpServletRequest request, HttpServletResponse response) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Posts post = postsDAO.getById(id);
            if (post != null) {
                request.setAttribute("post", post);
                return "postsUpdate.jsp"; // trang form edit
            } else {
                request.setAttribute("errorMessage", "Post not found!");
                return "error.jsp"; // hoặc quay về danh sách
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error while loading post for edit: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleDeleteImagePost(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            String imageIdStr = request.getParameter("image_id");

            if (imageIdStr != null && !imageIdStr.isEmpty()) {
                int imgId = Integer.parseInt(imageIdStr);

                // gọi DAO để xoá ảnh (chú ý: cần có hàm deleteImageById, 
                // đừng nhầm với deletePostById nhé)
                boolean success = postsDAO.deletePostById(imgId);

                if (success) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("OK");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Failed");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing image ID");
            }

            return null; // Ajax nên trả JSON/text, không forward sang JSP
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error: " + e.getMessage());
            } catch (IOException ignored) {
            }
            return null;
        }
    }

    private String handleGetProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding(java.nio.charset.StandardCharsets.UTF_8.name());

            // 1) Lấy & validate id (Java 8: không dùng isBlank)
            final String rawId = request.getParameter("idProduct");
            if (rawId == null || rawId.trim().isEmpty()) {
                request.setAttribute("checkErrorDeleteProduct", "Thiếu tham số idProduct");
                return "productDetail.jsp";
            }

            final int productId;
            try {
                productId = Integer.parseInt(rawId.trim());
            } catch (NumberFormatException nfe) {
                request.setAttribute("checkErrorDeleteProduct", "idProduct không hợp lệ");
                return "productDetail.jsp";
            }
            if (productId < 1) {
                request.setAttribute("checkErrorDeleteProduct", "Không có sản phẩm phù hợp");
                return "productDetail.jsp";
            }

            // 2) Lấy product + images
            final Products product = productsdao.getById(productId);
            if (product == null) {
                request.setAttribute("checkErrorDeleteProduct", "Không tìm thấy sản phẩm");
                return "productDetail.jsp";
            }

            final java.util.List<Product_images> images
                    = productImagesDAO.getByAllProductId(productId) != null
                    ? productImagesDAO.getByAllProductId(productId)
                    : java.util.Collections.<Product_images>emptyList();
            product.setImage(images);

            // 3) Lấy text bảo hành / bộ nhớ (an toàn null)
            String guaranteeProduct = "Không có";
            // Nếu field là Integer, check != null; nếu là int primitive, đổi sang > 0
            Integer guaranteeId = product.getGuarantee_id();
            if (guaranteeId != null && guaranteeId > 0) {
                Guarantees g = guaranteesDAO.getById(guaranteeId);
                if (g != null && g.getGuarantee_type() != null) {
                    guaranteeProduct = g.getGuarantee_type();
                }
            }

            String memoryProduct = "Không có";
            Integer memoryId = product.getMemory_id();
            if (memoryId != null && memoryId > 0) {
                Memories m = memoriesDAO.getById(memoryId);
                if (m != null && m.getMemory_type() != null) {
                    memoryProduct = m.getMemory_type();
                }
            }

            // 4) Gán attribute ra view
            request.setAttribute("productDetail", product);
            request.setAttribute("guaranteeProduct", guaranteeProduct);
            request.setAttribute("memoryProduct", memoryProduct);
            request.setAttribute("checkErrorDeleteProduct", null);

            return "productDetail.jsp";

        } catch (Exception e) {
            e.printStackTrace(); // nên thay bằng logger
            request.setAttribute("checkErrorDeleteProduct", "Unexpected error: " + e.getMessage());
            return "productDetail.jsp";
        }
    }

    private String handleGetProminentList(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
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
            Page<Products> pageResult = productsdao.getProminentProducts(filter);

            // ===== Gán ảnh cho từng sản phẩm =====
            for (Products p : pageResult.getContent()) {
                // Lấy 1 ảnh cover (status=1) thay vì toàn bộ
                Product_images coverImg = productImagesDAO.getCoverImgByProductId(p.getId());
                if (coverImg != null) {
                    p.setCoverImg(coverImg.getImage_url());

                }else p.setCoverImg("");
            }

            request.setAttribute("listProductsByCategory", pageResult);
//            đánh dấu là lấy ds sp nổi bật nên không hiện biên sidebar.jsp nữa
            request.setAttribute("isListProminent", "true");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading products: " + e.getMessage());
        }
        return "index.jsp";
    }


    // ===============================================
    // MODELS CRUD CONTROLLER METHODS
    // ===============================================
    /**
     * Xử lý thêm model mới
     */
    private String handleModelAdding(HttpServletRequest request, HttpServletResponse response) {

        try {
            request.setCharacterEncoding("UTF-8");

            // ===== Lấy dữ liệu từ form =====
            String modelType = request.getParameter("model_type");
            String descriptionHtml = request.getParameter("description_html");
            String status = request.getParameter("status");

            // ===== VALIDATION SECTION =====
            // 1. Validate model_type - required and not empty
            if (modelType == null || modelType.trim().isEmpty()) {
                request.setAttribute("checkErrorAddModel", "Model type is required.");
                return "modelUpdate.jsp";
            }

            // 2. Validate model_type length
            if (modelType.trim().length() > 100) {
                request.setAttribute("checkErrorAddModel", "Model type must be 100 characters or less.");
                return "modelUpdate.jsp";
            }

            // 3. Check for duplicate model_type (UNIQUE constraint)
//            try {
//                boolean typeExists = modelsDAO.isModelTypeExists(modelType.trim());
//                if (typeExists) {
//                    request.setAttribute("checkErrorAddModel", "Model type '" + modelType.trim() + "' already exists. Please choose a different model type.");
//                    return "modelUpdate.jsp";
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }

            // 4. Validate status value
            if (status != null && !status.trim().isEmpty()) {
                String normalizedStatus = status.trim();
                if (!normalizedStatus.equals("active") && !normalizedStatus.equals("inactive")) {
                    request.setAttribute("checkErrorAddModel", "Status must be either 'active' or 'inactive'.");
                    return "modelUpdate.jsp";
                }
            }

            // 5. Validate description length (optional but if provided, should be reasonable)
            if (descriptionHtml != null && descriptionHtml.trim().length() > 10000) {
                request.setAttribute("checkErrorAddModel", "Description must be 10000 characters or less.");
                return "modelUpdate.jsp";
            }

            // ===== Tạo đối tượng Models và set dữ liệu =====
            Models newModel = new Models();
            newModel.setModel_type(modelType.trim());
            newModel.setDescription_html(descriptionHtml != null ? descriptionHtml.trim() : "");
            newModel.setStatus(status != null ? status.trim() : "active");
            newModel.setCreated_at(new java.util.Date());
            newModel.setUpdated_at(new java.util.Date());

            // ===== Upload ảnh (nếu có) =====
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception e) {
                e.getMessage();
            }

            // Validate image file if provided
            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Check file size (max 5MB)
                long maxFileSize = 5 * 1024 * 1024;
                if (imagePart.getSize() > maxFileSize) {
                    request.setAttribute("checkErrorAddModel", "Image file size cannot exceed 5MB.");
                    return "modelUpdate.jsp";
                }

                // Check file extension
                String fileName = imagePart.getSubmittedFileName().toLowerCase();
                if (!fileName.endsWith(".jpg") && !fileName.endsWith(".jpeg")
                        && !fileName.endsWith(".png") && !fileName.endsWith(".gif")
                        && !fileName.endsWith(".bmp") && !fileName.endsWith(".webp")) {
                    request.setAttribute("checkErrorAddModel", "Only image files (jpg, jpeg, png, gif, bmp, webp) are allowed.");
                    return "modelUpdate.jsp";
                }
            }

            String storedImageUrl = null;
            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                String uploadDirPath = request.getServletContext().getRealPath("/assets/models/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                //take extention
                String originalFileName = imagePart.getSubmittedFileName();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0) {
                    fileExtension = originalFileName.substring(dot);
                }
                
                // create temporary file
                String tempName = "tmp_" + System.currentTimeMillis() + fileExtension;
                File tempFile = new File(uploadDir, tempName);

                try {
                    imagePart.write(tempFile.getAbsolutePath());
                } catch (Exception e) {
                    e.getMessage();
                    request.setAttribute("checkErrorAddModel", "Failed to upload image. Please try again.");
                    return "modelUpdate.jsp";
                }
                // Set image_url tạm thời là null để insert trước
                newModel.setImage_url(null);
                
                // ===== Insert để lấy generated ID =====
                if (modelsDAO.create(newModel) && newModel.getId() > 0) {
                    String finalName = "model_" + newModel.getId() + "_1" + fileExtension;
                    File finalFile = new File(uploadDir, finalName);

                    boolean renamed = tempFile.renameTo(finalFile);
                    if (!renamed) {
                        // Copy method if rename fails
                        try ( java.io.InputStream in = new java.io.FileInputStream(tempFile);  java.io.OutputStream out = new java.io.FileOutputStream(finalFile)) {
                            byte[] buf = new byte[8192];
                            int len;
                            while ((len = in.read(buf)) > 0) {
                                out.write(buf, 0, len);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        tempFile.delete();
                    }

                    storedImageUrl = "assets/models/" + finalName;
                    newModel.setImage_url(storedImageUrl);
                    modelsDAO.update(newModel);

                } else {
                    if (tempFile.exists()) {
                        tempFile.delete();
                    }
                    request.setAttribute("checkErrorAddModel", "Failed to add model.");
                    return "modelUpdate.jsp";
                }

            } else {
                // No image provided
                newModel.setImage_url(null);
                boolean success = modelsDAO.create(newModel);
                
                if (!success) {
                    request.setAttribute("checkErrorAddModel", "Failed to add model.");
                    return "modelUpdate.jsp";
                }
            }

            // Success
            HttpSession session = request.getSession();
            session.removeAttribute("cachedModelList");

            request.setAttribute("messageAddModel", "New model added successfully.");
            request.setAttribute("model", newModel);
            return "modelUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorAddModel", "Error while adding model: " + e.getMessage());
            return "modelUpdate.jsp";
        }
    }

    /**
     * Xử lý cập nhật model
     */
    private String handleModelEditing(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Lấy ID
            int modelId = Integer.parseInt(request.getParameter("id"));
            Models existingModel = modelsDAO.getById(modelId);
            if (existingModel == null) {
                request.setAttribute("checkErrorEditModel", "Model not found.");
                return "modelUpdate.jsp";
            }

            // Lấy dữ liệu từ form
            String modelType = request.getParameter("model_type");
            String descriptionHtml = request.getParameter("description_html");
            String status = request.getParameter("status");

            // Validate
            if (modelType == null || modelType.trim().isEmpty()) {
                request.setAttribute("checkErrorEditModel", "Model type is required.");
                request.setAttribute("model", existingModel);
                return "modelUpdate.jsp";
            }

            if (modelType.trim().length() > 100) {
                request.setAttribute("checkErrorEditModel", "Model type must be 100 characters or less.");
                request.setAttribute("model", existingModel);
                return "modelUpdate.jsp";
            }

            // Check duplicate model_type (exclude current record)
//            try {
//                boolean typeExists = modelsDAO.isModelTypeExistsExcept(modelType.trim(), modelId);
//                if (typeExists) {
//                    request.setAttribute("checkErrorEditModel", "Model type '" + modelType.trim() + "' already exists. Please choose a different model type.");
//                    request.setAttribute("model", existingModel);
//                    return "modelUpdate.jsp";
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }

            // Validate status
            if (status != null && !status.trim().isEmpty()) {
                String normalizedStatus = status.trim();
                if (!normalizedStatus.equals("active") && !normalizedStatus.equals("inactive")) {
                    request.setAttribute("checkErrorEditModel", "Status must be either 'active' or 'inactive'.");
                    request.setAttribute("model", existingModel);
                    return "modelUpdate.jsp";
                }
            }

            // Update basic info
            existingModel.setModel_type(modelType.trim());
            existingModel.setDescription_html(descriptionHtml != null ? descriptionHtml.trim() : "");
            existingModel.setStatus(status != null ? status.trim() : "active");
            existingModel.setUpdated_at(new java.util.Date());

            // Handle image upload
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception ignore) {
            }

            String oldImageUrl = existingModel.getImage_url();

            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Upload new image
                String uploadDirPath = request.getServletContext().getRealPath("/assets/models/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFileName = imagePart.getSubmittedFileName();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0) {
                    fileExtension = originalFileName.substring(dot);
                }

                String newFileName = "model_" + modelId + "_" + System.currentTimeMillis() + fileExtension;
                File newFile = new File(uploadDir, newFileName);
                imagePart.write(newFile.getAbsolutePath());

                existingModel.setImage_url("assets/models/" + newFileName);
            }
            // Update database
            boolean success = modelsDAO.update(existingModel);
            if (success) {
                // Delete old image if new image uploaded
                if (imagePart != null && imagePart.getSize() > 0
                        && oldImageUrl != null && !oldImageUrl.isEmpty()) {
                    File oldFile = new File(request.getServletContext().getRealPath("/" + oldImageUrl));
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                HttpSession session = request.getSession();
                session.removeAttribute("cachedModelList");

                request.setAttribute("messageEditModel", "Model updated successfully.");
                request.setAttribute("model", existingModel);
                return handleModelEditForm(request, response);
            } else {
                request.setAttribute("checkErrorEditModel", "Failed to update model.");
                request.setAttribute("model", existingModel);
                return "modelUpdate.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorEditModel", "Error while updating model: " + e.getMessage());
            return "modelUpdate.jsp";
        }
    }

    /**
     * Xử lý xóa model - Soft delete bằng cách chuyển status thành "inactive"
     */
    private String handleModelDelete(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("checkErrorDeleteModel", "Model ID is required.");
                return "modelList.jsp";
            }

            int modelId;
            try {
                modelId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                request.setAttribute("checkErrorDeleteModel", "Invalid model ID format.");
                return "modelList.jsp";
            }

            Models existingModel = modelsDAO.getById(modelId);
            if (existingModel == null) {
                request.setAttribute("checkErrorDeleteModel", "Model not found.");
                return "modelList.jsp";
            }

            if ("inactive".equalsIgnoreCase(existingModel.getStatus())) {
                request.setAttribute("checkErrorDeleteModel", "Model is already inactive.");
                return "modelList.jsp";
            }

            // Soft delete: change status to "inactive"
            existingModel.setStatus("inactive");
            existingModel.setUpdated_at(new java.util.Date());

            if (modelsDAO.update(existingModel)) {
                HttpSession session = request.getSession();
                session.removeAttribute("cachedModelList");

                request.setAttribute("messageDeleteModel",
                        "Model '" + existingModel.getModel_type() + "' has been deactivated successfully.");

                return handleModelList(request, response);
            } else {
                request.setAttribute("checkErrorDeleteModel",
                        "Failed to deactivate model. Please try again.");
                return "modelList.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorDeleteModel",
                    "Error while deactivating model: " + e.getMessage());
            return "modelList.jsp";
        }
    }

    /**
     * Xử lý hiển thị danh sách models
     */
    private String handleModelList(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession();

            // Check cache first
            List<Models> modelList = (List<Models>) session.getAttribute("cachedModelList");

            if (modelList == null) {
                // Get from database
                modelList = modelsDAO.getAllActive(); // Only get active models (de sau check lai trong cai modelDao)
                session.setAttribute("cachedModelList", modelList);
            }

            request.setAttribute("modelList", modelList);
            return "modelList.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorModelList", "Error loading model list: " + e.getMessage());
            return "modelList.jsp";
        }
    }

    /**
     * Xử lý hiển thị chi tiết model để edit
     */
    private String handleModelEditForm(HttpServletRequest request, HttpServletResponse response) {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("checkErrorModelDetail", "Model ID is required.");
                return "modelUpdate.jsp";
            }

            int modelId = Integer.parseInt(idStr);
            Models model = modelsDAO.getById(modelId);

            if (model == null) {
                request.setAttribute("checkErrorModelDetail", "Model not found.");
                return "modelUpdate.jsp";
            }

            request.setAttribute("model", model);
            return "modelUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorModelDetail", "Error loading model details: " + e.getMessage());
            return "modelUpdate.jsp";
        }
    }

    private String handleModelAddForm(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("model", null);
        return "modelUpdate.jsp";
    }
    
// ===============================================
// SERVICES CRUD CONTROLLER METHODS
// ===============================================

/**
 * Xử lý thêm service mới
 */
private String handleServiceAdding(HttpServletRequest request, HttpServletResponse response) {

    try {
        request.setCharacterEncoding("UTF-8");

        // ===== Lấy dữ liệu từ form =====
        String serviceType = request.getParameter("service_type");
        String descriptionHtml = request.getParameter("description_html");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");

        // ===== VALIDATION SECTION =====
        // 1. Validate service_type - required and not empty
        if (serviceType == null || serviceType.trim().isEmpty()) {
            request.setAttribute("checkErrorAddService", "Service type is required.");
            return "serviceUpdate.jsp";
        }

        // 2. Validate service_type length
        if (serviceType.trim().length() > 100) {
            request.setAttribute("checkErrorAddService", "Service type must be 100 characters or less.");
            return "serviceUpdate.jsp";
        }

        // 3. Check for duplicate service_type (UNIQUE constraint)
//        try {
//            boolean typeExists = servicesDAO.isServiceTypeExists(serviceType.trim());
//            if (typeExists) {
//                request.setAttribute("checkErrorAddService", "Service type '" + serviceType.trim() + "' already exists. Please choose a different service type.");
//                return "serviceUpdate.jsp";
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

        // 4. Validate price
        double price = 0.0;
        if (priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("checkErrorAddService", "Price is required.");
            return "serviceUpdate.jsp";
        }
        
        try {
            price = Double.parseDouble(priceStr.trim());
            if (price < 0) {
                request.setAttribute("checkErrorAddService", "Price cannot be negative.");
                return "serviceUpdate.jsp";
            }
            if (price > 999999999.99) {
                request.setAttribute("checkErrorAddService", "Price is too large.");
                return "serviceUpdate.jsp";
            }
        } catch (NumberFormatException e) {
            request.setAttribute("checkErrorAddService", "Invalid price format. Please enter a valid number.");
            return "serviceUpdate.jsp";
        }

        // 5. Validate status value
        if (status != null && !status.trim().isEmpty()) {
            String normalizedStatus = status.trim();
            if (!normalizedStatus.equals("active") && !normalizedStatus.equals("inactive")) {
                request.setAttribute("checkErrorAddService", "Status must be either 'active' or 'inactive'.");
                return "serviceUpdate.jsp";
            }
        }

        // 6. Validate description length (optional but if provided, should be reasonable)
        if (descriptionHtml != null && descriptionHtml.trim().length() > 10000) {
            request.setAttribute("checkErrorAddService", "Description must be 10000 characters or less.");
            return "serviceUpdate.jsp";
        }

        // ===== Tạo đối tượng Services và set dữ liệu =====
        Services newService = new Services();
        newService.setService_type(serviceType.trim());
        newService.setDescription_html(descriptionHtml != null ? descriptionHtml.trim() : "");
        newService.setPrice(price);
        newService.setStatus(status != null ? status.trim() : "active");
        newService.setCreated_at(new java.util.Date());
        newService.setUpdated_at(new java.util.Date());

        // ===== Insert vào database =====
        boolean success = servicesDAO.create(newService);
        
        if (!success) {
            request.setAttribute("checkErrorAddService", "Failed to add service.");
            return "serviceUpdate.jsp";
        }

        // Success
        HttpSession session = request.getSession();
        session.removeAttribute("cachedServiceList");

        request.setAttribute("messageAddService", "New service added successfully.");
        request.setAttribute("service", newService);
        return "serviceUpdate.jsp";

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("checkErrorAddService", "Error while adding service: " + e.getMessage());
        return "serviceUpdate.jsp";
    }
}

/**
 * Xử lý cập nhật service
 */
private String handleServiceEditing(HttpServletRequest request, HttpServletResponse response) {
    try {
        request.setCharacterEncoding("UTF-8");
        
        // Lấy ID
        int serviceId = Integer.parseInt(request.getParameter("id"));
        Services existingService = servicesDAO.getById(serviceId);
        if (existingService == null) {
            request.setAttribute("checkErrorEditService", "Service not found.");
            return "serviceUpdate.jsp";
        }

        // Lấy dữ liệu từ form
        String serviceType = request.getParameter("service_type");
        String descriptionHtml = request.getParameter("description_html");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");

        // Validate service_type
        if (serviceType == null || serviceType.trim().isEmpty()) {
            request.setAttribute("checkErrorEditService", "Service type is required.");
            request.setAttribute("service", existingService);
            return "serviceUpdate.jsp";
        }

        if (serviceType.trim().length() > 100) {
            request.setAttribute("checkErrorEditService", "Service type must be 100 characters or less.");
            request.setAttribute("service", existingService);
            return "serviceUpdate.jsp";
        }

        // Check duplicate service_type (exclude current record)
//        try {
//            boolean typeExists = servicesDAO.isServiceTypeExistsExcept(serviceType.trim(), serviceId);
//            if (typeExists) {
//                request.setAttribute("checkErrorEditService", "Service type '" + serviceType.trim() + "' already exists. Please choose a different service type.");
//                request.setAttribute("service", existingService);
//                return "serviceUpdate.jsp";
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

        // Validate price
        double price = 0.0;
        if (priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("checkErrorEditService", "Price is required.");
            request.setAttribute("service", existingService);
            return "serviceUpdate.jsp";
        }
        
        try {
            price = Double.parseDouble(priceStr.trim());
            if (price < 0) {
                request.setAttribute("checkErrorEditService", "Price cannot be negative.");
                request.setAttribute("service", existingService);
                return "serviceUpdate.jsp";
            }
            if (price > 999999999.99) {
                request.setAttribute("checkErrorEditService", "Price is too large.");
                request.setAttribute("service", existingService);
                return "serviceUpdate.jsp";
            }
        } catch (NumberFormatException e) {
            request.setAttribute("checkErrorEditService", "Invalid price format. Please enter a valid number.");
            request.setAttribute("service", existingService);
            return "serviceUpdate.jsp";
        }

        // Validate status
        if (status != null && !status.trim().isEmpty()) {
            String normalizedStatus = status.trim();
            if (!normalizedStatus.equals("active") && !normalizedStatus.equals("inactive")) {
                request.setAttribute("checkErrorEditService", "Status must be either 'active' or 'inactive'.");
                request.setAttribute("service", existingService);
                return "serviceUpdate.jsp";
            }
        }

        // Validate description length
        if (descriptionHtml != null && descriptionHtml.trim().length() > 10000) {
            request.setAttribute("checkErrorEditService", "Description must be 10000 characters or less.");
            request.setAttribute("service", existingService);
            return "serviceUpdate.jsp";
        }

        // Update basic info
        existingService.setService_type(serviceType.trim());
        existingService.setDescription_html(descriptionHtml != null ? descriptionHtml.trim() : "");
        existingService.setPrice(price);
        existingService.setStatus(status != null ? status.trim() : "active");
        existingService.setUpdated_at(new java.util.Date());

        // Update database
        boolean success = servicesDAO.update(existingService);
        if (success) {
            HttpSession session = request.getSession();
            session.removeAttribute("cachedServiceList");

            request.setAttribute("messageEditService", "Service updated successfully.");
            request.setAttribute("service", existingService);
            return handleServiceEditForm(request, response);
        } else {
            request.setAttribute("checkErrorEditService", "Failed to update service.");
            request.setAttribute("service", existingService);
            return "serviceUpdate.jsp";
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("checkErrorEditService", "Error while updating service: " + e.getMessage());
        return "serviceUpdate.jsp";
    }
}

/**
 * Xử lý xóa service - Soft delete bằng cách chuyển status thành "inactive"
 */
private String handleServiceDelete(HttpServletRequest request, HttpServletResponse response) {
    try {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("checkErrorDeleteService", "Service ID is required.");
            return "serviceList.jsp";
        }

        int serviceId;
        try {
            serviceId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("checkErrorDeleteService", "Invalid service ID format.");
            return "serviceList.jsp";
        }

        Services existingService = servicesDAO.getById(serviceId);
        if (existingService == null) {
            request.setAttribute("checkErrorDeleteService", "Service not found.");
            return "serviceList.jsp";
        }

        if ("inactive".equalsIgnoreCase(existingService.getStatus())) {
            request.setAttribute("checkErrorDeleteService", "Service is already inactive.");
            return "serviceList.jsp";
        }

        // Soft delete: change status to "inactive"
        existingService.setStatus("inactive");
        existingService.setUpdated_at(new java.util.Date());

        if (servicesDAO.update(existingService)) {
            HttpSession session = request.getSession();
            session.removeAttribute("cachedServiceList");

            request.setAttribute("messageDeleteService",
                    "Service '" + existingService.getService_type() + "' has been deactivated successfully.");

            return handleServiceList(request, response);
        } else {
            request.setAttribute("checkErrorDeleteService",
                    "Failed to deactivate service. Please try again.");
            return "serviceList.jsp";
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("checkErrorDeleteService",
                "Error while deactivating service: " + e.getMessage());
        return handleServiceList(request, response);
    }
}

/**
 * Xử lý hiển thị danh sách services
 */
private String handleServiceList(HttpServletRequest request, HttpServletResponse response) {
    try {
        HttpSession session = request.getSession();

        // Check cache first
        List<Services> serviceList = (List<Services>) session.getAttribute("cachedServiceList");

        if (serviceList == null) {
            // Get from database
            serviceList = servicesDAO.getAllActive(); // Only get active services
            session.setAttribute("cachedServiceList", serviceList);
        }

        request.setAttribute("serviceList", serviceList);
        return "serviceList.jsp";

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("checkErrorServiceList", "Error loading service list: " + e.getMessage());
        return "serviceList.jsp";
    }
}

/**
 * Xử lý hiển thị chi tiết service để edit
 */
private String handleServiceEditForm(HttpServletRequest request, HttpServletResponse response) {
    try {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("checkErrorServiceDetail", "Service ID is required.");
            return "serviceUpdate.jsp";
        }

        int serviceId = Integer.parseInt(idStr);
        Services service = servicesDAO.getById(serviceId);

        if (service == null) {
            request.setAttribute("checkErrorServiceDetail", "Service not found.");
            return "serviceUpdate.jsp";
        }

        request.setAttribute("service", service);
        return "serviceUpdate.jsp";

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("checkErrorServiceDetail", "Error loading service details: " + e.getMessage());
        return "serviceUpdate.jsp";
    }
}

/**
 * Xử lý hiển thị form thêm service mới
 */
private String handleServiceAddForm(HttpServletRequest request, HttpServletResponse response) {
    request.setAttribute("service", null);
    return "serviceUpdate.jsp";
}
    
    
    private String handleListMayChoiGame(HttpServletRequest request, HttpServletResponse response){
        String condition = request.getParameter("condition");
        if (condition == null) {
            return handleListMayChoiGameWithCondition(request, response, "all");
        }else if (condition.equals("new")){
            return handleListMayChoiGameWithCondition(request, response, "new");
        }else if (condition.equals("likenew")){
            return handleListMayChoiGameWithCondition(request, response, "likenew");
        }
        return "";
    }

    private String handleListMayChoiGameWithCondition(HttpServletRequest request, HttpServletResponse response, String condition) {
        
        //truong hop lay may choi game khong chia moi hay cu
        
            try {
                request.setCharacterEncoding("UTF-8");
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
                Page<Products> pageResult = productsdao.getMayChoiGame(filter, condition);
                 // ===== Gán ảnh cho từng sản phẩm =====
                for (Products p : pageResult.getContent()) {
                    System.out.println(p.getId());
                }


                // ===== Gán ảnh cho từng sản phẩm =====
                for (Products p : pageResult.getContent()) {
                    // Lấy 1 ảnh cover (status=1) thay vì toàn bộ
                    Product_images coverImg = productImagesDAO.getCoverImgByProductId(p.getId());
                    if (coverImg != null) {
                        p.setCoverImg(coverImg.getImage_url());
                    }else p.setCoverImg("");
                }

                request.setAttribute("listProductsByCategory", pageResult);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("checkError", "Error loading products: " + e.getMessage());
            }

        
            
        return INDEX_PAGE;
    }

    private String handleListTheGame(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
