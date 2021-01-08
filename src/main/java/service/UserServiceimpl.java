package service;

import java.util.List;

import dao.UserDAO_Mariadb;
import vo.UserVO;

public class UserServiceimpl implements UserService {
	private UserDAO_Mariadb dao = null; //DB연동


	public UserServiceimpl() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public UserServiceimpl(UserDAO_Mariadb dao) { //using field
		super();
		this.dao = dao;
	}

	@Override
	public List<UserVO> userList() {
		// TODO Auto-generated method stub
		return dao.userList();
	}

	@Override
	public void userAdd(UserVO vo) {
		// TODO Auto-generated method stub
		dao.userAdd(vo);
	}

	@Override
	public UserVO getUser(String id) {
		// TODO Auto-generated method stub
		return dao.getUser(id);
	}

	@Override
	public void userDelete(String id) {
		// TODO Auto-generated method stub
		dao.userDelete(id);
	}

	@Override
	public UserVO login(String email, String password) {
		// TODO Auto-generated method stub
		return dao.login(email, password);
	}

	@Override
	public List<UserVO> userSearch(String condition, String keyword) {
		// TODO Auto-generated method stub
		return dao.userSearch(condition, keyword);
	}
	
	

}
