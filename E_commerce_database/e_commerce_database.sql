-- Create the database
CREATE DATABASE ecommerce_platform;
-- to add table in this database
USE ecommerce_platform;

-- Create brand table
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    brand_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create product_category table
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT NULL,
    category_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
);

-- Create size_category table
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create size_option table
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_value VARCHAR(20) NOT NULL,
    size_description VARCHAR(100),
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Create color table
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create attribute_category table
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Create attribute_type table
CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id),
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id)
);

-- Create product_image table
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    image_alt_text VARCHAR(255),
    display_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Create product_variation table
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    variation_name VARCHAR(100) NOT NULL,
    variation_type ENUM('size', 'color', 'material', 'other') NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Create product_item table
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Create product_attribute table
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    attribute_category_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_description TEXT,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id)
);

-- Create junction table for product_item and color
CREATE TABLE product_item_color (
    item_id INT NOT NULL,
    color_id INT NOT NULL,
    PRIMARY KEY (item_id, color_id),
    FOREIGN KEY (item_id) REFERENCES product_item(item_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id)
);

-- Create junction table for product_item and size_option
CREATE TABLE product_item_size (
    item_id INT NOT NULL,
    size_id INT NOT NULL,
    PRIMARY KEY (item_id, size_id),
    FOREIGN KEY (item_id) REFERENCES product_item(item_id),
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
);

-- Create junction table for product and product_attribute
CREATE TABLE product_attribute_value (
    product_id INT NOT NULL,
    attribute_id INT NOT NULL,
    attribute_value TEXT NOT NULL,
    PRIMARY KEY (product_id, attribute_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attribute_id) REFERENCES product_attribute(attribute_id)
);

