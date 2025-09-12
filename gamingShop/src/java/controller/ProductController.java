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
import dto.Guarantees;
import dto.Memories;
import dto.Page;
import dto.Posts;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
// } else if (action.equals("deleteAccessory")) {
//     url = handleAccessoryDelete(request, response);
            } else if (action.equals("editMainProduct")) {
                url = handleUpdateMainProduct(request, response);
            } else if (action.equals("editImageProduct")) {
                url = handleUpdateImageProduct(request, response);
            } else if (action.equals("deleteProduct")) {
                url = handleDeleteProduct(request, response);
            } else if (action.equals("viewAllPost")) {
                url = handleViewAllPost(request, response);
            } else if (action.equals("searchPosts")) {
                url = handlePostSearching(request, response);
            } else if (action.equals("addPosts")) {
                url = handleAddPosts(request, response);
            } else if (action.equals("deletePosts")) {
                url = handleDeletePosts(request, response);
            } else if (action.equals("goToUpdatePosts")) {
                url = handleGoToUpdatePosts(request, response);
            } else if (action.equals("updatePosts")) {
                url = handleUpdatePosts(request, response);
            } else if (action.equals("getProduct")) {
                url = handleGetProduct(request, response);
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
        request.setAttribute("checkErrorSearch", checkError);
        return "welcome.jsp";
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
                request.setAttribute("checkErrorUpdateProductMain", "Quantity must be a valid number.");
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

    private String handleDeleteProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Lấy productId từ tham số form (hidden input "product_id")
            int productId = Integer.parseInt(request.getParameter("product_id"));

            if (productId < 1) {
                request.setAttribute("checkErrorDeleteProduct", "Missing product_id.");
                return "welcome.jsp";
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
            return "welcome.jsp";
        }
        return "MainController?action=prepareHome";
    }

    /**
     * Hiển thị danh sách tất cả accessories với phân trang
     */
    private String handleViewAllAccessories(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy tất cả accessories từ database
            List<Accessories> accessories = accessoriesDAO.getAll();

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
                accessories = accessoriesDAO.getAll();

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
     * Xử lý thêm accessory mới
     */
    private String handleAccessoryAdding(HttpServletRequest request, HttpServletResponse response) {
        try {

            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String gift = request.getParameter("gift");

            // Xử lý upload ảnh
            String imageUrl = "";
            Part imagePart = request.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadDir = getServletContext().getRealPath("/assets/img/accessories/");
                new File(uploadDir).mkdir();

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
            newAccessory.setGift(gift);
            newAccessory.setCreated_at(new java.util.Date());
            newAccessory.setUpdated_at(new java.util.Date());

            // Thêm vào database
            boolean success = accessoriesDAO.create(newAccessory);

            System.out.println("++++++++++++++++++++++dây là san pham duoc them:++++++++++++++++++++===" + newAccessory.getId() + "|" + newAccessory.getName() + "|" + newAccessory.getImage_url() + "|" + newAccessory.getPrice() + "|" + newAccessory.getDescription() + "|" + newAccessory.getQuantity() + "|" + newAccessory.getGift() + "|" + newAccessory.getStatus());
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
     * Xử lý cập nhật accessory
     */
    private String handleAccessoryEditing(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy ID của accessory cần edit
            int accessoryId = Integer.parseInt(request.getParameter("id"));

            // Lấy accessory hiện tại từ database
            Accessories existingAccessory = accessoriesDAO.getById(accessoryId);
            if (existingAccessory == null) {
                request.setAttribute("checkError", "Accessory not found.");
                return "accessoryList.jsp";
            }

            // Cập nhật thông tin từ form
            String name = request.getParameter("name");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String gift = request.getParameter("gift");

            existingAccessory.setName(name);
            existingAccessory.setQuantity(quantity);
            existingAccessory.setPrice(price);
            existingAccessory.setDescription(description);
            existingAccessory.setStatus(status);
            existingAccessory.setGift(gift);
            existingAccessory.setUpdated_at(new java.util.Date());

            // Xử lý upload ảnh mới (nếu có)
            Part imagePart = request.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                // Xóa ảnh cũ nếu có
                String oldImageUrl = existingAccessory.getImage_url();
                if (oldImageUrl != null && !oldImageUrl.isEmpty()) {
                    String oldImagePath = getServletContext().getRealPath("/") + oldImageUrl;
                    File oldImageFile = new File(oldImagePath);
                    if (oldImageFile.exists()) {
                        oldImageFile.delete();
                    }
                }

                // Upload ảnh mới
                String uploadDir = getServletContext().getRealPath("/assets/img/accessories/");
                new File(uploadDir).mkdirs();

                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                String storedFileName = accessoryId + "_" + System.currentTimeMillis() + fileExtension;
                String imagePath = uploadDir + File.separator + storedFileName;

                imagePart.write(imagePath);
                existingAccessory.setImage_url("assets/img/accessories/" + storedFileName);
            }

            // Cập nhật trong database
            boolean success = accessoriesDAO.update(existingAccessory);

            if (success) {
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

        } catch (ServletException | IOException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while updating accessory: " + e.getMessage());
            return "error.jsp";
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
                checkError = "No products found with name: " + keyword;
            }
        } else {
            list = postsDAO.getAll();
        }

        request.setAttribute("keyword", keyword);
        request.setAttribute("list", list);
        request.setAttribute("checkErrorSearchPosts", checkError);
        return "posts.jsp";
    }

    private String handleUpdatePosts(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(request.getParameter("id"));

            // ===== Lấy dữ liệu từ form =====
            String author = request.getParameter("author");
            if (author == null || author.trim().isEmpty()) {
                author = "admin";
            }
            String title = request.getParameter("title");
            String content_html = request.getParameter("content_html");

            // publish_date có thể để trống
            String publishDateStr = request.getParameter("publish_date");
            Date publishDate = null;
            if (publishDateStr != null && !publishDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
                    formatter.setLenient(false);
                    publishDate = formatter.parse(publishDateStr.trim());
                } catch (ParseException e) {
                    publishDate = new Date();
                    e.printStackTrace();
                }
            } else {
                publishDate = new Date();
            }

            int status = 1; // mặc định active
            try {
                status = Integer.parseInt(request.getParameter("status"));
            } catch (Exception ignore) {
                status = 1;
            }

            // ===== Tạo đối tượng Posts và set dữ liệu =====
            Posts updatePost = new Posts();
            updatePost.setAuthor(author);
            updatePost.setTitle(title);
            updatePost.setContent_html(content_html);
            updatePost.setPublish_date(publishDate);
            updatePost.setStatus(status);

            // ===== Xử lý ảnh =====
            String finalImageUrl = null;

            // Lấy ảnh cũ từ hidden input (nếu có)
            String existingImageUrl = request.getParameter("existingImageUrl");

            // Kiểm tra xem có upload ảnh mới không
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception ignore) {
                // Không có part imageFile hoặc lỗi khác
            }

            if (imagePart != null && imagePart.getSize() > 0) {
                // CÓ upload ảnh mới
                String uploadDirPath = request.getServletContext().getRealPath("/assets/img/posts/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Lấy extension
                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0 && dot < originalFileName.length() - 1) {
                    fileExtension = originalFileName.substring(dot);
                }

                // Đặt tên file mới
                String finalName = id + "_1" + fileExtension;
                File finalFile = new File(uploadDir, finalName);

                // Lưu file
                imagePart.write(finalFile.getAbsolutePath());

                finalImageUrl = "assets/img/posts/" + finalName;
            } else {
                // KHÔNG upload ảnh mới, giữ ảnh cũ
                finalImageUrl = existingImageUrl;
            }

            updatePost.setImage_url(finalImageUrl);

            // ===== Thực hiện update =====
            boolean success = postsDAO.updatePost(updatePost, id);

            if (success) {
                HttpSession session = request.getSession();
                session.removeAttribute("cachedPostsListEdit");

                request.setAttribute("messageAddPost", "Post updated successfully.");

                // Load lại post đã update để hiển thị
                Posts updatedPost = postsDAO.getById(id);
                request.setAttribute("post", updatedPost);
            } else {
                request.setAttribute("checkErrorAddPost", "Failed to update post.");

                // Load lại post cũ khi lỗi
                Posts post = postsDAO.getById(id);
                request.setAttribute("post", post);
            }

            return "postsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while updating post: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleAddPosts(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // ===== Lấy dữ liệu từ form =====
            String author = request.getParameter("author");
            if (author == null) {
                author = "admin";
            }
            String title = request.getParameter("title");
            String content_html = request.getParameter("content_html");

            // publish_date có thể để trống
            String publishDateStr = request.getParameter("publish_date");
            Date publishDate;
            if (publishDateStr != null && !publishDateStr.trim().isEmpty()) {
                try {
                    // ĐÚNG với <input type="date">
                    SimpleDateFormat iso = new SimpleDateFormat("yyyy-MM-dd");
                    iso.setLenient(false);
                    publishDate = iso.parse(publishDateStr.trim());
                } catch (ParseException e1) {
                    try {
                        // Fallback khi client gửi dd-MMM-yyyy (ví dụ 13-Sep-2025)
                        SimpleDateFormat alt = new SimpleDateFormat("dd-MMM-yyyy", java.util.Locale.ENGLISH);
                        alt.setLenient(false);
                        publishDate = alt.parse(publishDateStr.trim());
                    } catch (ParseException e2) {
                        publishDate = new Date(); // Cuối cùng lấy ngày hiện tại
                    }
                }
            } else {
                publishDate = new Date();
            }

            int status = 0;
            try {
                status = Integer.parseInt(request.getParameter("status"));
            } catch (Exception ignore) {
                // để mặc định 0 nếu không parse được
            }

            // ===== Tạo đối tượng Posts và set dữ liệu =====
            Posts newPost = new Posts();
            newPost.setAuthor(author);
            newPost.setTitle(title);
            newPost.setContent_html(content_html);
            newPost.setPublish_date(publishDate);
            newPost.setStatus(status);

            // ===== Upload 1 ảnh (nếu có) và set vào image_url =====
            // Tên field trong form: "imageFile"
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception ignore) {
            }

            String storedRelativeUrl = null; // ví dụ: "assets/img/posts/123_1.jpg"
            if (imagePart != null && imagePart.getSize() > 0) {
                // Thư mục lưu ảnh trên server
                String uploadDirPath = request.getServletContext().getRealPath("/assets/img/posts/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Lấy extension an toàn
                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0 && dot < originalFileName.length() - 1) {
                    fileExtension = originalFileName.substring(dot); // gồm cả dấu chấm
                }

                // TẠM thời đặt tên file trước khi có id, sẽ đặt lại sau khi insert có id
                // Lưu tạm với tên ngẫu nhiên để tránh đụng
                String tempName = "tmp_" + System.currentTimeMillis() + fileExtension;
                File tempFile = new File(uploadDir, tempName);
                imagePart.write(tempFile.getAbsolutePath());

                // Tạm set image_url là file tạm để vẫn insert được nếu cần (có thể để null)
                newPost.setImage_url(null);

                // ===== Insert để lấy generatedId =====
                int generatedId = postsDAO.createNewPost(newPost);
                if (generatedId > 0) {
                    newPost.setId(generatedId);

                    // Đặt lại tên file theo quy ước: {postId}_1{ext}
                    String finalName = generatedId + "_1" + fileExtension;
                    File finalFile = new File(uploadDir, finalName);

                    // Đổi tên file tạm -> file chính thức
                    boolean renamed = tempFile.renameTo(finalFile);
                    if (!renamed) {
                        // Nếu rename thất bại thì copy rồi xóa tạm
                        try ( java.io.InputStream in = new java.io.FileInputStream(tempFile);  java.io.OutputStream out = new java.io.FileOutputStream(finalFile)) {
                            byte[] buf = new byte[8192];
                            int len;
                            while ((len = in.read(buf)) > 0) {
                                out.write(buf, 0, len);
                            }
                        }
                        tempFile.delete();
                    }

                    storedRelativeUrl = "assets/img/posts/" + finalName;
                    newPost.setImage_url(storedRelativeUrl);

                    // Cập nhật lại image_url vào DB nếu cần (vì INSERT lúc đầu chưa có url)
                    // Ở đây bạn có thể viết thêm 1 hàm updateImageUrl(postId, url).
                    // Nếu CHƯA có hàm update, cách đơn giản là: nếu bắt buộc cần image_url ngay,
                    // hãy set image_url trước rồi mới insert (xem biến thể bên dưới).
                } else {
                    // Insert thất bại -> xóa file tạm (nếu có)
                    if (tempFile.exists()) {
                        tempFile.delete();
                    }
                    request.setAttribute("checkErrorAddPost", "Failed to add post.");
                    return "postsUpdate.jsp";
                }

            } else {
                // KHÔNG có ảnh upload -> insert luôn
                newPost.setImage_url(null);
                int generatedId = postsDAO.createNewPost(newPost);
                if (generatedId <= 0) {
                    request.setAttribute("checkErrorAddPost", "Failed to add post.");
                    return "postsUpdate.jsp";
                }
                newPost.setId(generatedId);
            }

            // ===== Success =====
            HttpSession session = request.getSession();
            // Nếu trước đó có cache gì liên quan posts thì xóa, ví dụ:
            session.removeAttribute("cachedPostsListEdit");

            request.setAttribute("messageAddPost", "New post added successfully.");
            request.setAttribute("post", newPost); // để JSP show ra chi tiết

            return "postsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding post: " + e.getMessage());
            return "error.jsp";
        }
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

            boolean success = postsDAO.deleteProductById(id);

            if (success) {
                // Nếu có cache list sản phẩm để edit trong session thì xoá để lần sau nạp mới
                request.getSession().removeAttribute("cachedProductListEdit");
                request.setAttribute("messageDeletePosts", "Product deleted successfully.");
            } else {
                request.setAttribute("checkErrorDeletePosts", "Failed to delete product.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorDeletePosts", "Unexpected error: " + e.getMessage());
            return "posts.jsp";
        }
        return "MainController?action=viewAllPost";
    }

    private String handleGoToUpdatePosts(HttpServletRequest request, HttpServletResponse response) {
        int id = Integer.parseInt(request.getParameter("id"));
        PostsDAO pd = new PostsDAO();
        try {
            Posts post = pd.getById(id);
            request.setAttribute("post", post);
        } catch (Exception e) {
        }
        return "postsUpdate.jsp";
    }

    private String handleGetProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Lấy productId từ tham số form (hidden input "product_id")
            int productId = Integer.parseInt(request.getParameter("idProduct"));

            if (productId < 1) {
                request.setAttribute("checkErrorDeleteProduct", "Missing product_id.");
                return "welcome.jsp";
            }
            List<Product_images> imgList = new ArrayList<>();
            imgList = productImagesDAO.getByAllProductId(productId);
            Products productDetail = productsdao.getById(productId);
            productDetail.setImage(imgList);
            Guarantees guarantee = guaranteesDAO.getById(productDetail.getGuarantee_id());
            Memories memory = memoriesDAO.getById(productDetail.getMemory_id());
            String guaranteeProduct = guarantee.getGuarantee_type();
            String memoryProduct = memory.getMemory_type();
            request.setAttribute("productDetail", productDetail);
            request.setAttribute("guaranteeProduct", guaranteeProduct);
            request.setAttribute("memoryProduct", memoryProduct);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorDeleteProduct", "Unexpected error: " + e.getMessage());
            return "welcome.jsp";
        }
        return "productDetail.jsp";

    }

}
