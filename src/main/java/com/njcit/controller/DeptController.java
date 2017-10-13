package com.njcit.controller;

import com.njcit.bean.Depttal;
import com.njcit.bean.Msg;
import com.njcit.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理部门
 */
@Controller
public class DeptController {

    @Autowired
    private DeptService deptService;

    // 返回所有的部门信息
    @RequestMapping(value = "/depts")
    @ResponseBody
    public Msg getDepts() {
        List<Depttal> lists = deptService.getDepts();
        return Msg.success().add("depts", lists);
    }

}