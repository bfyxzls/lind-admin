package com.lind.lindadmin.security;

import com.lind.lindadmin.entity.User;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Security用户详情
 */
@Getter
public class SecurityUserDetails implements UserDetails {

	private final Long userId;

	private final String username;

	private final String password;

	private final String nickname;

	private final Integer status;

	private final Set<String> permissions;

	private final Collection<? extends GrantedAuthority> authorities;

	public SecurityUserDetails(User user, Set<String> permissions) {
		this.userId = user.getId();
		this.username = user.getUsername();
		this.password = user.getPassword();
		this.nickname = user.getNickname();
		this.status = user.getStatus();
		this.permissions = permissions;
		this.authorities = permissions.stream().map(SimpleGrantedAuthority::new).collect(Collectors.toSet());
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}

	@Override
	public String getPassword() {
		return password;
	}

	@Override
	public String getUsername() {
		return username;
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return status == 1;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return status == 1;
	}

}
