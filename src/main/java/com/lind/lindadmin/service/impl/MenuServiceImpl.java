package com.lind.lindadmin.service.impl;

import com.lind.lindadmin.common.BusinessException;
import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.Menu;
import com.lind.lindadmin.entity.UserRole;
import com.lind.lindadmin.repository.MenuRepository;
import com.lind.lindadmin.repository.RoleMenuRepository;
import com.lind.lindadmin.repository.UserRoleRepository;
import com.lind.lindadmin.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 菜单服务实现类
 */
@Service
@RequiredArgsConstructor
public class MenuServiceImpl implements MenuService {

	private final MenuRepository menuRepository;

	private final RoleMenuRepository roleMenuRepository;

	private final UserRoleRepository userRoleRepository;

	@Override
	public Menu findById(Long id) {
		return menuRepository.findById(id).filter(m -> m.getDeleted() == 0)
				.orElseThrow(() -> new BusinessException("菜单不存在"));
	}

	@Override
	public PageResult<Menu> findPage(String menuName, Integer status, Integer pageNum, Integer pageSize) {
		Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
		Page<Menu> page = menuRepository.findByConditions(menuName != null && !menuName.isEmpty() ? menuName : null,
				status, pageable);
		return PageResult.of(page);
	}

	@Override
	public List<Menu> findAll() {
		return menuRepository.findByDeletedOrderBySortOrderAsc(0);
	}

	@Override
	public List<Menu> findTree() {
		List<Menu> allMenus = findAll();
		return buildTree(allMenus, 0L);
	}

	@Override
	public List<Menu> findTreeByRoleIds(Set<Long> roleIds) {
		if (roleIds == null || roleIds.isEmpty()) {
			return new ArrayList<>();
		}
		List<Menu> menus = menuRepository.findByRoleIds(roleIds);
		return buildTree(menus, 0L);
	}

	@Override
	public List<Menu> findTreeByUserId(Long userId) {
		List<UserRole> userRoles = userRoleRepository.findByUserId(userId);
		Set<Long> roleIds = userRoles.stream().map(UserRole::getRoleId).collect(Collectors.toSet());
		return findTreeByRoleIds(roleIds);
	}

	private List<Menu> buildTree(List<Menu> menus, Long parentId) {
		List<Menu> tree = new ArrayList<>();
		for (Menu menu : menus) {
			if (menu.getParentId().equals(parentId)) {
				menu.setChildren(buildTree(menus, menu.getId()));
				tree.add(menu);
			}
		}
		return tree;
	}

	@Override
	@Transactional
	public Menu save(Menu menu) {
		menu.setDeleted(0);
		return menuRepository.save(menu);
	}

	@Override
	@Transactional
	public Menu update(Menu menu) {
		Menu existingMenu = findById(menu.getId());

		existingMenu.setMenuName(menu.getMenuName());
		existingMenu.setMenuNameEn(menu.getMenuNameEn());
		existingMenu.setParentId(menu.getParentId());
		existingMenu.setMenuType(menu.getMenuType());
		existingMenu.setPath(menu.getPath());
		existingMenu.setComponent(menu.getComponent());
		existingMenu.setPermission(menu.getPermission());
		existingMenu.setIcon(menu.getIcon());
		existingMenu.setSortOrder(menu.getSortOrder());
		existingMenu.setVisible(menu.getVisible());
		existingMenu.setStatus(menu.getStatus());
		existingMenu.setRemark(menu.getRemark());

		return menuRepository.save(existingMenu);
	}

	@Override
	@Transactional
	public void delete(Long id) {
		Menu menu = findById(id);
		// 检查是否有子菜单
		List<Menu> children = menuRepository.findByParentIdAndDeletedOrderBySortOrderAsc(id, 0);
		if (!children.isEmpty()) {
			throw new BusinessException("存在子菜单，无法删除");
		}
		menu.setDeleted(1);
		menuRepository.save(menu);
		// 删除角色菜单关联
		roleMenuRepository.deleteByMenuId(id);
	}

	@Override
	@Transactional
	public void deleteBatch(List<Long> ids) {
		ids.forEach(this::delete);
	}

}
