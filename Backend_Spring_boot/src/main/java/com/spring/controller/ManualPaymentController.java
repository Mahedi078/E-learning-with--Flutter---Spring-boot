package com.spring.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.spring.dao.ManualPaymentRepository;
import com.spring.model.ManualPayment;

@RestController
@RequestMapping("/api/manual-payment")
@CrossOrigin(origins = "*")
public class ManualPaymentController {

    @Autowired
    private ManualPaymentRepository manualPaymentRepository;

    // ✅ Student submits payment
    @PostMapping
    public ResponseEntity<ManualPayment> submitPayment(@RequestBody ManualPayment payment) {
        payment.setStatus("PENDING"); // ensure status is always PENDING
        ManualPayment saved = manualPaymentRepository.save(payment);
        return ResponseEntity.ok(saved);
    }

    // ✅ Student can view their payment history by email
    @GetMapping("/by-email/{email}")
    public List<ManualPayment> getPaymentsByEmail(@PathVariable String email) {
        return manualPaymentRepository.findByEmail(email);
    }

    // ✅ Admin can view all pending payments
    @GetMapping("/pending")
    public List<ManualPayment> getPendingPayments() {
        return manualPaymentRepository.findByStatus("PENDING");
    }

    // ✅ Admin approves or rejects a payment
    @PutMapping("/approve/{id}")
    public ResponseEntity<?> verifyPayment(@PathVariable Long id, @RequestParam String status) {
    	
    	
        Optional<ManualPayment> optional = manualPaymentRepository.findById(id);
        if (optional.isPresent()) {
            ManualPayment payment = optional.get();
            if (!status.equals("APPROVED") && !status.equals("REJECTED")) {
                return ResponseEntity.badRequest().body("Invalid status value.");
            }
            payment.setStatus(status.toUpperCase());
            manualPaymentRepository.save(payment);
            return ResponseEntity.ok().body("Payment " + status.toUpperCase());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
}
