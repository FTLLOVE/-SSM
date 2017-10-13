package com.njcit.service;

import com.njcit.bean.Emptal;
import com.njcit.bean.EmptalExample;
import com.njcit.dao.EmptalMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmplService {


    @Autowired
    private EmptalMapper emptalMapper;

    // 查询所有的员工，但是,不是分页查询
    public List<Emptal> getAll() {
        return emptalMapper.WithDeptselectByExample(null);
    }

    // 员工保存 ，获得数据来插入到数据库中
    public void saveEmps(Emptal emptal) {
        emptalMapper.insertSelective(emptal);
    }

    // 检验用户名是否可用
    public boolean checkUser(String empName) {
        EmptalExample example = new EmptalExample();
        EmptalExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = emptalMapper.countByExample(example);
        return count == 0;

    }

    // 根据员工的ID来查询相应的员工信息
    public Emptal getEmp(Integer id) {
        Emptal emptal = emptalMapper.selectByPrimaryKey(id);
        return emptal;
    }

    // 更新 -> 保存用户
    public void updateEmp(Emptal emptal) {
        emptalMapper.updateByPrimaryKeySelective(emptal);
    }

    // 删除 -> 保存用户
    public void deleteEmp(Integer id) {
        emptalMapper.deleteByPrimaryKey(id);
    }

    // 批量删除用户
    public void deleteBatch(List<Integer> ids) {
        EmptalExample example = new EmptalExample();
        EmptalExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(ids);
        emptalMapper.deleteByExample(example);

    }
}