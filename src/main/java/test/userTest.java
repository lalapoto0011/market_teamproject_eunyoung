package test;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import dao.UserDAO_Mariadb;
import service.UserService;
import service.UserServiceimpl;
import vo.UserVO;

public class userTest {
	
	UserService service = null;
	
	
	@BeforeEach
	void setUp() throws Exception {
		
		UserDAO_Mariadb dao = new UserDAO_Mariadb();
		service = new UserServiceimpl(dao);
	}
	
//	@Test
	void list() {
		service.userList().forEach(i -> {System.out.println(i);} );
	}
	
//	@Test
	void add() {
		UserVO vo = new UserVO();
		vo.setId("dododo00");
		vo.setPassword("qwer1234");
		vo.setName("테스트01");
		vo.setEmail("admin@test.com");
		vo.setPhone("010-9999-1234");
		
		service.userAdd(vo);
		System.out.println("등록 되었습니다.");
	}
	
//	@Test
	void getUser() {
		System.out.println(service.getUser("dododo00"));
	}
	
//	@Test
	void delete() {
		UserVO vo = service.getUser("dododo00");
		if(vo != null) {
			System.out.println(vo);
			service.userDelete(vo.getId());
			System.out.println("삭제 되었습니다.");
		} else {
			System.out.println("존재 하지 않습니다.");
		}
	}
	
//	@Test
	void search() {
		System.out.println("===========검색==========");
		List<UserVO> list = service.userSearch("id", "admin");
		
		list.forEach(i -> {System.out.println(i);} ); //lambda
		
//		for(UserVO data:list) {
//			System.out.printf("%s|%s|%s|%s %n", data.getId(), data.getName(), data.getEmail(), data.getPassword());
//		}
	}
}
