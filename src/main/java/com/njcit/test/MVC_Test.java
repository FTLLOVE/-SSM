package com.njcit.test;

import com.github.pagehelper.PageInfo;
import com.njcit.bean.Emptal;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.Result;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.EnumMap;
import java.util.List;

/**
 * 测试页面的显示,spring,springMVC
 * 并且测试是否可以
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:spring-mvc.xml"})

public class MVC_Test {
    @Autowired
    private WebApplicationContext context;
    MockMvc mockMvc;

    @Before
    public void initMock() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "2")).andReturn();
        MockHttpServletRequest request = result.getRequest();
        PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页面是:" + pi.getPageNum());
        System.out.println("总页码" + pi.getPages());
        System.out.println("总记录数:" + pi.getTotal());
        int[] nums = pi.getNavigatepageNums();
        for (int i : nums) {
            System.out.println("   " + i);
        }
        List<Emptal> list = pi.getList();
        for (Emptal emptal : list) {
            System.out.println("ID:" + emptal.getEmpId() + "                 Name:" + emptal.getEmpName() + "        " +
                    "           EmpiD:" + emptal.getDepttal());
        }
    }


}