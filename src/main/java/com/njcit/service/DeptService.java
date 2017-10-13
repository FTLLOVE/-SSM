package com.njcit.service;

import com.njcit.bean.Depttal;
import com.njcit.dao.DepttalMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DeptService {

    @Autowired
    private DepttalMapper depttalMapper;

    public List<Depttal> getDepts() {
        List<Depttal> list = depttalMapper.selectByExample(null);
        return list;
    }
}