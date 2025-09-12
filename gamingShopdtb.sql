/* ============================================================
   DATABASE & OPTIONS
   ============================================================ */
IF DB_ID(N'GamingShop') IS NULL
    CREATE DATABASE GamingShop;
GO
USE GamingShop;
GO

/* (Tùy chọn) Chuẩn hóa SET để tránh lỗi thời điểm chạy script */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

/* ============================================================
   2) accounts (quản trị viên)
   ============================================================ */
IF OBJECT_ID(N'dbo.Accounts', N'U') IS NOT NULL DROP TABLE dbo.Accounts;
GO
CREATE TABLE dbo.Accounts (
  id            INT IDENTITY(1,1) PRIMARY KEY,
  username      NVARCHAR(50)  NOT NULL UNIQUE,
  password_hash NVARCHAR(255)) NOT NULL,             -- SHA2_256 = 32 bytes
  email         NVARCHAR(100) NOT NULL UNIQUE,
  full_name     NVARCHAR(100) NULL,
  phone         NVARCHAR(20)  NULL,
  created_at    DATETIME2(3)  NOT NULL CONSTRAINT DF_accounts_created_at DEFAULT SYSDATETIME(),
  updated_at    DATETIME2(3)  NOT NULL CONSTRAINT DF_accounts_updated_at DEFAULT SYSDATETIME()
);
GO

/* ============================================================
   3) models
   ============================================================ */
IF OBJECT_ID(N'dbo.Models', N'U') IS NOT NULL DROP TABLE dbo.Models;
GO
CREATE TABLE dbo.Models (
  id               INT IDENTITY(1,1) PRIMARY KEY,
  model_type       NVARCHAR(100) NOT NULL,
  description_html NVARCHAR(MAX) NULL,
  image_url        NVARCHAR(1024) NULL,
  created_at       DATETIME2(3) NOT NULL CONSTRAINT DF_models_created_at DEFAULT SYSDATETIME(),
  updated_at       DATETIME2(3) NOT NULL CONSTRAINT DF_models_updated_at DEFAULT SYSDATETIME(),
  status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Models_Status CHECK (status IN (N'active', N'inactive')),
  CONSTRAINT UK_models_type UNIQUE (model_type)
);
GO

/* ============================================================
   4) memories
   ============================================================ */
IF OBJECT_ID(N'dbo.Memories', N'U') IS NOT NULL DROP TABLE dbo.Memories;
GO
CREATE TABLE dbo.Memories (
  id               INT IDENTITY(1,1) PRIMARY KEY,
  memory_type      NVARCHAR(50) NOT NULL,  -- ví dụ 32GB, 64GB...
  description_html NVARCHAR(MAX) NULL,
  quantity         INT NOT NULL CONSTRAINT CK_memories_qty CHECK (quantity >= 0),
  price            DECIMAL(10,2) NOT NULL CONSTRAINT CK_memories_price CHECK (price >= 0),
  image_url        NVARCHAR(1024) NULL,
  created_at       DATETIME2(3) NOT NULL CONSTRAINT DF_memories_created_at DEFAULT SYSDATETIME(),
  updated_at       DATETIME2(3) NOT NULL CONSTRAINT DF_memories_updated_at DEFAULT SYSDATETIME(),
  status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Memories_Status CHECK (status IN (N'active', N'inactive')),
  CONSTRAINT UK_memories_type UNIQUE (memory_type)
);
GO

/* ============================================================
   5) guarantees
   ============================================================ */
IF OBJECT_ID(N'dbo.Guarantes', N'U') IS NOT NULL DROP TABLE dbo.Guarantes;
GO
-- Sửa tên đúng: Guarantees
IF OBJECT_ID(N'dbo.Guarantees', N'U') IS NOT NULL DROP TABLE dbo.Guarantees;
GO
CREATE TABLE dbo.Guarantees (
  id               INT IDENTITY(1,1) PRIMARY KEY,
  guarantee_type   NVARCHAR(100) NOT NULL,
  description_html NVARCHAR(MAX) NULL,
  created_at       DATETIME2(3) NOT NULL CONSTRAINT DF_guarantees_created_at DEFAULT SYSDATETIME(),
  updated_at       DATETIME2(3) NOT NULL CONSTRAINT DF_guarantees_updated_at DEFAULT SYSDATETIME(),
  status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Guarantees_Status CHECK (status IN (N'active', N'inactive')),
  CONSTRAINT UK_guarantees_type UNIQUE (guarantee_type)
);
GO

/* ============================================================
   6) accessories
   ============================================================ */
IF OBJECT_ID(N'dbo.Accessories', N'U') IS NOT NULL DROP TABLE dbo.Accessories;
GO
CREATE TABLE dbo.Accessories (
  id               INT IDENTITY(1,1) PRIMARY KEY,
  name             NVARCHAR(255) NOT NULL,
  quantity         INT NOT NULL CONSTRAINT CK_accessories_qty CHECK (quantity >= 0),
  price            DECIMAL(10,2) NOT NULL CONSTRAINT CK_accessories_price CHECK (price >= 0),
  description_html NVARCHAR(MAX) NULL,
  image_url        NVARCHAR(1024) NULL,
  created_at       DATETIME2(3) NOT NULL CONSTRAINT DF_accessories_created_at DEFAULT SYSDATETIME(),
  updated_at       DATETIME2(3) NOT NULL CONSTRAINT DF_accessories_updated_at DEFAULT SYSDATETIME(),
  status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Accessories_Status CHECK (status IN (N'active', N'inactive')),
  CONSTRAINT UK_accessories_name UNIQUE (name)
);
GO

/* ============================================================
   7) products
   ============================================================ */
IF OBJECT_ID(N'dbo.Products', N'U') IS NOT NULL DROP TABLE dbo.Products;
GO
CREATE TABLE dbo.Products (
  id               INT IDENTITY(1,1) PRIMARY KEY,
  name             NVARCHAR(255) NOT NULL,
  sku              NVARCHAR(100) NULL,
  price            DECIMAL(10,2) NOT NULL CONSTRAINT CK_products_price CHECK (price >= 0),
  product_type     VARCHAR(10)   NOT NULL CONSTRAINT CK_products_type CHECK (product_type IN ('new','used')),
  quantity         INT NOT NULL CONSTRAINT CK_products_qty CHECK (quantity >= 0),
  model_id         INT NULL,
  memory_id        INT NULL,
  guarantee_id     INT NULL,
  description_html NVARCHAR(MAX) NULL,
  status           NVARCHAR(10)  NULL
                     CONSTRAINT CK_Products_status CHECK (status IN (N'active', N'inactive')),
  created_at       DATETIME2(3) NOT NULL CONSTRAINT DF_products_created_at DEFAULT SYSDATETIME(),
  updated_at       DATETIME2(3) NOT NULL CONSTRAINT DF_products_updated_at DEFAULT SYSDATETIME(),
  CONSTRAINT FK_products_model     FOREIGN KEY (model_id)     REFERENCES dbo.Models(id)      ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT FK_products_memory    FOREIGN KEY (memory_id)    REFERENCES dbo.Memories(id)    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT FK_products_guarantee FOREIGN KEY (guarantee_id) REFERENCES dbo.Guarantees(id)  ON UPDATE CASCADE ON DELETE SET NULL
);
GO
CREATE INDEX IX_products_type      ON dbo.Products(product_type);
CREATE INDEX IX_products_model     ON dbo.Products(model_id);
CREATE INDEX IX_products_memory    ON dbo.Products(memory_id);
CREATE INDEX IX_products_guarantee ON dbo.Products(guarantee_id);
CREATE INDEX IX_products_name      ON dbo.Products(name);
GO

/* ============================================================
   8) product_accessories (N-N)
   ============================================================ */
IF OBJECT_ID(N'dbo.Product_accessories', N'U') IS NOT NULL DROP TABLE dbo.Product_accessories;
GO
CREATE TABLE dbo.Product_accessories (
  product_id  INT NOT NULL,
  accessory_id INT NOT NULL,
  quantity    INT NOT NULL CONSTRAINT CK_pa_qty CHECK (quantity > 0) CONSTRAINT DF_pa_qty DEFAULT (1),
  CONSTRAINT PK_product_accessories PRIMARY KEY (product_id, accessory_id),
  CONSTRAINT FK_pa_product   FOREIGN KEY (product_id)  REFERENCES dbo.Products(id)    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_pa_accessory FOREIGN KEY (accessory_id) REFERENCES dbo.Accessories(id) ON UPDATE CASCADE ON DELETE NO ACTION,
  status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Product_accessories_Status CHECK (status IN (N'active', N'inactive'))
);
GO

/* ============================================================
   9) product_images
   ============================================================ */
IF OBJECT_ID(N'dbo.Product_images', N'U') IS NOT NULL DROP TABLE dbo.Product_images;
GO
CREATE TABLE dbo.Product_images (
  id          INT IDENTITY(1,1) PRIMARY KEY,
  product_id  INT NOT NULL,
  image_url   NVARCHAR(1024) NOT NULL,
  caption     NVARCHAR(255) NULL,
  sort_order  INT NOT NULL CONSTRAINT DF_product_images_sort DEFAULT (0),
  status      INT NOT NULL
                CONSTRAINT CK_product_images_status CHECK (status IN (0, 1))
                CONSTRAINT DF_product_images_status DEFAULT (1), -- 1 = active
  created_at  DATETIME2(3) NOT NULL CONSTRAINT DF_product_images_created_at DEFAULT SYSDATETIME(),
  updated_at  DATETIME2(3) NOT NULL CONSTRAINT DF_product_images_updated_at DEFAULT SYSDATETIME(),
  CONSTRAINT FK_product_images_product FOREIGN KEY (product_id) REFERENCES dbo.Products(id) ON UPDATE CASCADE ON DELETE CASCADE
);
GO
CREATE INDEX IX_product_images_product ON dbo.Product_images(product_id);
CREATE INDEX IX_product_images_sort    ON dbo.Product_images(product_id, sort_order);
GO

/* ============================================================
   10) services
   ============================================================ */
IF OBJECT_ID(N'dbo.Services', N'U') IS NOT NULL DROP TABLE dbo.Services;
GO
CREATE TABLE dbo.Services (
  id               INT IDENTITY(1,1) PRIMARY KEY,
  service_type     NVARCHAR(50) NOT NULL,
  description_html NVARCHAR(MAX) NULL,
  price            DECIMAL(10,2) NOT NULL CONSTRAINT CK_services_price CHECK (price >= 0),
  created_at       DATETIME2(3) NOT NULL CONSTRAINT DF_services_created_at DEFAULT SYSDATETIME(),
  updated_at       DATETIME2(3) NOT NULL CONSTRAINT DF_services_updated_at DEFAULT SYSDATETIME(),
  status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Services_Status CHECK (status IN (N'active', N'inactive')),
	CONSTRAINT UK_services_type UNIQUE (service_type)
);
GO
CREATE INDEX IX_services_price ON dbo.Services(price);
GO

/* ============================================================
   11) posts (newsfeed)
   ============================================================ */
IF OBJECT_ID(N'dbo.Posts', N'U') IS NOT NULL DROP TABLE dbo.Posts;
GO
CREATE TABLE dbo.Posts (
  id           INT IDENTITY(1,1) PRIMARY KEY,
  author       NVARCHAR(100) NULL,
  title        NVARCHAR(255) NOT NULL,
  content_html NVARCHAR(MAX) NULL,
  image_url    NVARCHAR(1024) NULL,
  publish_date DATE NULL,
  status      INT NOT NULL
                CONSTRAINT CK_Posts_status CHECK (status IN (0, 1))
                CONSTRAINT DF_Posts_status DEFAULT (1), -- 1 = active
  created_at   DATETIME2(3) NOT NULL CONSTRAINT DF_posts_created_at DEFAULT SYSDATETIME(),
  updated_at   DATETIME2(3) NOT NULL CONSTRAINT DF_posts_updated_at DEFAULT SYSDATETIME()
);
GO
CREATE INDEX IX_posts_publish_date ON dbo.Posts(publish_date);
GO

/* ============================================================
   TRIGGERS cập nhật updated_at khi UPDATE
   (tạo cho các bảng có cột updated_at)
   ============================================================ */
-- Ghi chú: dùng SYSDATETIME(); nếu muốn UTC thì SYSUTCDATETIME()

CREATE OR ALTER TRIGGER trg_Accounts_set_updated_at
ON dbo.Accounts
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE a SET updated_at = SYSDATETIME()
  FROM dbo.Accounts a
  INNER JOIN inserted i ON a.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Models_set_updated_at
ON dbo.Models
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE m SET updated_at = SYSDATETIME()
  FROM dbo.Models m
  INNER JOIN inserted i ON m.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Memories_set_updated_at
ON dbo.Memories
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE t SET updated_at = SYSDATETIME()
  FROM dbo.Memories t
  INNER JOIN inserted i ON t.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Guarantees_set_updated_at
ON dbo.Guarantees
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE g SET updated_at = SYSDATETIME()
  FROM dbo.Guarantees g
  INNER JOIN inserted i ON g.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Accessories_set_updated_at
ON dbo.Accessories
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE a SET updated_at = SYSDATETIME()
  FROM dbo.Accessories a
  INNER JOIN inserted i ON a.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Products_set_updated_at
ON dbo.Products
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE p SET updated_at = SYSDATETIME()
  FROM dbo.Products p
  INNER JOIN inserted i ON p.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Product_images_set_updated_at
ON dbo.Product_images
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE pi SET updated_at = SYSDATETIME()
  FROM dbo.Product_images pi
  INNER JOIN inserted i ON pi.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Services_set_updated_at
ON dbo.Services
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE s SET updated_at = SYSDATETIME()
  FROM dbo.Services s
  INNER JOIN inserted i ON s.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_Posts_set_updated_at
ON dbo.Posts
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE p SET updated_at = SYSDATETIME()
  FROM dbo.Posts p
  INNER JOIN inserted i ON p.id = i.id;
END;
GO

/* ============================================================
   TRIGGER tự gán sort_order = max+1 khi INSERT vào Product_images
   (Chỉ áp dụng cho các hàng có sort_order = 0; không đổi cấu trúc cột)
   ============================================================ */
IF OBJECT_ID('dbo.trg_Product_images_autosort', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Product_images_autosort;
GO

CREATE TRIGGER dbo.trg_Product_images_autosort
ON dbo.Product_images
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH need_auto AS (
        SELECT i.id, i.product_id,
               ROW_NUMBER() OVER (PARTITION BY i.product_id ORDER BY i.id) AS rn
        FROM inserted AS i
        WHERE i.sort_order = 0       -- chỉ auto cho các dòng để mặc định 0
    ),
    base_max AS (
        SELECT i.product_id,
               MAX(p.sort_order) AS max_sort
        FROM inserted AS i
        JOIN dbo.Product_images AS p
          ON p.product_id = i.product_id
        LEFT JOIN need_auto AS na
          ON na.id = p.id
        WHERE na.id IS NULL          -- loại trừ chính các dòng vừa chèn có sort_order = 0
        GROUP BY i.product_id
    )
    UPDATE t
    SET t.sort_order = ISNULL(b.max_sort, -1) + na.rn
    FROM dbo.Product_images AS t
    JOIN need_auto      AS na ON na.id = t.id
    LEFT JOIN base_max  AS b  ON b.product_id = na.product_id;
END;
GO

ALTER TABLE [GamingShop].[dbo].[Services]
	ADD status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Services_Status CHECK (status IN (N'active', N'inactive'));

	ALTER TABLE [GamingShop].[dbo].[Product_accessories]
	ADD status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Product_accessories_Status CHECK (status IN (N'active', N'inactive'));

	ALTER TABLE [GamingShop].[dbo].[Models]
	ADD status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Models_Status CHECK (status IN (N'active', N'inactive'));

	ALTER TABLE [GamingShop].[dbo].[Memories]
	ADD status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Memories_Status CHECK (status IN (N'active', N'inactive'));

	ALTER TABLE [GamingShop].[dbo].[Guarantees]
	ADD status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Guarantees_Status CHECK (status IN (N'active', N'inactive'));

	ALTER TABLE [GamingShop].[dbo].[Accessories]
	ADD status NVARCHAR(50) NOT NULL 
    CONSTRAINT CK_Accessories_Status CHECK (status IN (N'active', N'inactive'));

/* ============================================================
   DỮ LIỆU MẪU THẬT
   ============================================================ */

-- 1) accounts
INSERT INTO dbo.Accounts (username, password_hash, email, full_name, phone)
VALUES
(N'admin', N'123123',
 N'admin@example.com', N'Nguyen Van A', N'0909123456');

-- 2) models
INSERT INTO dbo.Models (model_type, description_html, image_url)
VALUES
(N'PlayStation 5', N'Máy chơi game Sony PlayStation 5 chính hãng', N'https://example.com/img/ps5.jpg'),
(N'Nintendo Switch', N'Máy chơi game cầm tay Nintendo Switch OLED', N'https://example.com/img/switch.jpg');

-- 3) memories
INSERT INTO dbo.Memories (memory_type, description_html, quantity, price, image_url)
VALUES
(N'64GB',  N'Thẻ nhớ 64GB chính hãng SanDisk', 50, 350000, N'https://example.com/img/64gb.jpg'),
(N'128GB', N'Thẻ nhớ 128GB tốc độ cao',        30, 650000, N'https://example.com/img/128gb.jpg');

-- 4) guarantees
INSERT INTO dbo.Guarantees (guarantee_type, description_html)
VALUES
(N'12 tháng', N'Bảo hành 12 tháng chính hãng'),
(N'24 tháng', N'Bảo hành 24 tháng mở rộng');

-- 5) accessories
INSERT INTO dbo.Accessories (name, quantity, price, description_html, image_url)
VALUES
(N'Tay cầm PS5 DualSense', 100, 1500000, N'Tay cầm không dây chính hãng Sony', N'https://example.com/img/dualsense.jpg'),
(N'Dock sạc Nintendo Switch', 20, 1200000, N'Dock sạc và HDMI hub cho Nintendo Switch', N'https://example.com/img/switch-dock.jpg');

-- 6) products
INSERT INTO dbo.Products (name, sku, price, product_type, quantity, model_id, memory_id, guarantee_id, description_html)
VALUES
(N'PlayStation 5 Standard Edition', N'PS5-STD-001', 14990000, 'new', 10, 1, NULL, 1,
 N'<p>Bản tiêu chuẩn PlayStation 5, kèm 1 tay cầm DualSense.</p>'),
(N'Nintendo Switch OLED', N'SWITCH-OLED-001', 9490000, 'new', 15, 2, NULL, 1,
 N'<p>Nintendo Switch OLED, màn hình 7 inch, bộ nhớ 64GB.</p>'),
(N'Thẻ nhớ SanDisk 128GB cho Nintendo Switch', N'SD-128-NS', 650000, 'new', 40, NULL, 2, NULL,
 N'<p>Thẻ nhớ microSD 128GB, tốc độ cao cho máy Switch.</p>');

-- 7) product_accessories
INSERT INTO dbo.Product_accessories (product_id, accessory_id, quantity)
VALUES
(1, 1, 1),  -- PS5 có sẵn DualSense
(2, 2, 1);  -- Switch OLED có Dock sạc

-- 8) product_images
INSERT INTO dbo.Product_images (product_id, image_url, caption, sort_order)
VALUES
(1, N'https://example.com/img/ps5-front.jpg',   N'PS5 mặt trước', 1),
(1, N'https://example.com/img/ps5-back.jpg',    N'PS5 mặt sau',   2),
(2, N'https://example.com/img/switch-front.jpg',N'Switch OLED màn hình', 1);

-- 9) services
INSERT INTO dbo.Services (service_type, description_html, price)
VALUES
(N'Cài đặt game bản quyền', N'Hỗ trợ cài đặt game bản quyền tận nơi', 200000),
(N'Vệ sinh bảo dưỡng máy', N'Vệ sinh PlayStation/Nintendo, tra keo tản nhiệt', 300000);

-- 10) posts
INSERT INTO dbo.Posts (author, title, content_html, image_url, status ,publish_date)
VALUES
(N'Admin', N'Sony ra mắt PS5 Slim', N'<p>Phiên bản PS5 Slim nhẹ hơn, mỏng hơn, dự kiến phát hành cuối năm.</p>',
 N'https://example.com/img/ps5-slim.jpg', 1,'2025-08-01'),
(N'Admin', N'Nintendo công bố game Zelda mới', N'<p>Zelda: Breath of the Wild 2 chính thức có trailer mới tại E3.</p>',
 N'https://example.com/img/zelda.jpg', 1,'2025-08-15');
GO
