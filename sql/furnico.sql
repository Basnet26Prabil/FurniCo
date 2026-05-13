DROP DATABASE IF EXISTS furnico;
CREATE DATABASE furnico;
USE furnico;

CREATE TABLE category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    image VARCHAR(100)
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT NOT NULL,
    image VARCHAR(100) NOT NULL,
    stock INT NOT NULL DEFAULT 10,
    rating DECIMAL(2,1) NOT NULL DEFAULT 4.5,
    rating_count INT NOT NULL DEFAULT 0,
    sales_count INT NOT NULL DEFAULT 0,
    is_best_seller TINYINT(1) GENERATED ALWAYS AS (
        CASE WHEN sales_count >= 100 THEN 1 ELSE 0 END
    ) STORED,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_product_price CHECK (price > 0),
    CONSTRAINT chk_product_stock CHECK (stock >= 0),
    CONSTRAINT chk_product_rating CHECK (rating >= 0 AND rating <= 5),
    CONSTRAINT chk_product_rating_count CHECK (rating_count >= 0),
    CONSTRAINT chk_product_sales_count CHECK (sales_count >= 0)
);

CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE,
    dob DATE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'customer') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    note VARCHAR(500),
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_request_user
        FOREIGN KEY (user_id)
        REFERENCES user(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_request_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_request_quantity CHECK (quantity >= 1)
);

CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_name ON product(product_name);
CREATE INDEX idx_user_role ON user(role);
CREATE INDEX idx_request_user ON requests(user_id);
CREATE INDEX idx_request_status ON requests(status);

INSERT INTO category (category_name, description, image) VALUES
('Sofas',    'Comfortable and stylish sofas',  'cat-sofa.jpg'),
('Chairs',   'Designer chairs for every room', 'cat-chair.jpg'),
('Tables',   'Dining and accent tables',       'cat-table.jpg'),
('Beds',     'Beds and bed frames',            'cat-bed.jpg'),
('Storage',  'Sideboards and storage units',   'cat-storage.jpg'),
('Lighting', 'Lamps and lighting fixtures',    'cat-lighting.jpg');

INSERT INTO product (product_name, category_id, price, description, image, stock, rating, rating_count, sales_count) VALUES
('Luna Velvet Sofa',       1, 45000.00, 'A plush three-seater velvet sofa in deep emerald, perfect for elegant living rooms.', 'luna-sofa.jpg',        5, 4.6, 124, 168),
('Sectional Corner Sofa',  1, 85000.00, 'Spacious L-shaped sectional sofa in classic neutral fabric.',                         'sectional-sofa.jpg',   3, 4.5, 203, 214),
('Zenith Lounge Chair',    2, 28000.00, 'Modern tufted lounge chair with curved wooden legs.',                                 'zenith-chair.jpg',     8, 4.4,  63, 126),
('Aria Accent Chair',      2, 18000.00, 'Statement accent chair with brass details.',                                          'aria-chair.jpg',       6, 4.3,  47,  58),
('Aurora Dining Table',    3, 65000.00, 'Six-seater dining table with marble top and gold legs.',                              'aurora-table.jpg',     4, 4.5,  87, 142),
('Noah Coffee Table',      3, 22000.00, 'Wooden coffee table with sleek mid-century design.',                                  'noah-table.jpg',      10, 4.2,  39,  44),
('Vesta Side Table',       3, 12000.00, 'Compact side table with marble top.',                                                 'vesta-table.jpg',     12, 4.1,  28,  35),
('Platform Bed',           4, 55000.00, 'Low-profile platform bed in solid wood.',                                             'platform-bed.jpg',     5, 4.5, 118,  80),
('Soren King Bed',         4, 95000.00, 'Premium upholstered king bed with wingback headboard.',                               'soren-bed.jpg',        2, 4.7,  95, 151),
('Everly Sideboard',       5, 48000.00, 'Six-door sideboard for dining or living room storage.',                               'everly-sideboard.jpg', 4, 4.3,  52,  67),
('Hayden TV Unit',         5, 32000.00, 'Modern TV stand with cable management and shelves.',                                  'hayden-tv.jpg',        6, 4.2,  41,  55),
('Arc Floor Lamp',         6, 15000.00, 'Tall arc floor lamp with marble base and brass arm.',                                 'arc-lamp.jpg',         9, 4.4,  71,  73);

INSERT INTO user (first_name, last_name, email, phone, dob, password, role) VALUES
('FurniCo', 'Admin', 'admin@furnico.com', '9800000000', '2000-01-01',
 '$2a$10$NzjkOqPvKKCIsr4PDA6aPu.Td2/vIegqlN9kAO42EStxycEL4KsIe', 'admin');
