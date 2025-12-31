package com.lind.lindadmin;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Lind后台管理系统启动类
 */
@SpringBootApplication
public class LindAdminApplication {

    public static void main(String[] args) {
        SpringApplication.run(LindAdminApplication.class, args);
        System.out.println("========================================");
        System.out.println("  Lind后台管理系统启动成功!");
        System.out.println("  访问地址: http://localhost:8080");
        System.out.println("  默认账户: admin / admin123");
        System.out.println("========================================");
    }
}
