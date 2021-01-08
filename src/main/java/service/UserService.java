package service;

import java.util.List;

import vo.UserVO;

public interface UserService {
	public List<UserVO> userList();
	
	public void userAdd(UserVO vo);
	
	public UserVO getUser(String id);
	
	public void userDelete(String id);
	
	public UserVO login(String email, String password);
	
	public List<UserVO> userSearch(String condition, String keyword);
}
