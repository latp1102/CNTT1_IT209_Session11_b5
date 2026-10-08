package com.example.bt.service;

import com.example.bt.entity.Product;
import com.example.bt.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {
    private final ProductRepository productRepository;
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    public Product createProduct(Product product) {
        return productRepository.save(product);
    }
    public Product updateProduct(Product product) {
        Product existingProduct = productRepository.findById(product.getId()).orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại"));
        existingProduct.setName(product.getName());
        existingProduct.setPrice(product.getPrice());
        return productRepository.save(existingProduct);
    }
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }
}
