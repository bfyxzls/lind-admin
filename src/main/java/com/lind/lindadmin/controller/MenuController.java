package com.lind.lindadmin.controller;

import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.Menu;
import com.lind.lindadmin.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 菜单管理Controller
 */
@RestController
@RequestMapping("/api/menu")
@RequiredArgsConstructor
public class MenuController {

    private final MenuService menuService;

    /**
     * 查询菜单树
     */
    @GetMapping("/tree")
    @PreAuthorize("hasAuthority('system:menu:list')")
    public Result<List<Menu>> tree() {
        return Result.success(menuService.findTree());
    }

    /**
     * 查询所有菜单
     */
    @GetMapping("/list")
    @PreAuthorize("hasAuthority('system:menu:list')")
    public Result<List<Menu>> list() {
        return Result.success(menuService.findAll());
    }

    /**
     * 根据ID查询菜单
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('system:menu:list')")
    public Result<Menu> get(@PathVariable Long id) {
        return Result.success(menuService.findById(id));
    }

    /**
     * 新增菜单
     */
    @PostMapping
    @PreAuthorize("hasAuthority('system:menu:add')")
    public Result<Menu> save(@RequestBody Menu menu) {
        return Result.success(menuService.save(menu));
    }

    /**
     * 更新菜单
     */
    @PutMapping
    @PreAuthorize("hasAuthority('system:menu:edit')")
    public Result<Menu> update(@RequestBody Menu menu) {
        return Result.success(menuService.update(menu));
    }

    /**
     * 删除菜单
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('system:menu:delete')")
    public Result<Void> delete(@PathVariable Long id) {
        menuService.delete(id);
        return Result.success();
    }

    /**
     * 批量删除菜单
     */
    @DeleteMapping("/batch")
    @PreAuthorize("hasAuthority('system:menu:delete')")
    public Result<Void> deleteBatch(@RequestBody List<Long> ids) {
        menuService.deleteBatch(ids);
        return Result.success();
    }
}

