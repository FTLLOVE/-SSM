package com.njcit.test;

import com.njcit.bean.Depttal;
import com.njcit.bean.Emptal;
import com.njcit.bean.EmptalExample;
import com.njcit.dao.DepttalMapper;
import com.njcit.dao.EmptalMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:applicationContext.xml")

public class MapperTest {

    @Autowired
    SqlSession sqlSession;

    @Autowired
    DepttalMapper depttalMapper;

    @Autowired
    EmptalMapper emptalMapper;

    @Test
    public void TestCURD() {
        // 批量插入数据
        EmptalMapper mapper = sqlSession.getMapper(EmptalMapper.class);
        for (int i = 0; i < 200; i++) {
            String s = UUID.randomUUID().toString().substring(0, 5);
            mapper.insertSelective(new Emptal(null, "" + s, 3));
        }
        System.out.println("批量完成！");

    }


}