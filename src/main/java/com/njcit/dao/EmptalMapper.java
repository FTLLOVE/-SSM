package com.njcit.dao;

import com.njcit.bean.Emptal;
import com.njcit.bean.EmptalExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface EmptalMapper {
    long countByExample(EmptalExample example);

    int deleteByExample(EmptalExample example);

    int deleteByPrimaryKey(Integer empId);

    int insert(Emptal record);

    int insertSelective(Emptal record); //这个是用自动生成的可选择的插入，传进来的是一个员工对象

    List<Emptal> selectByExample(EmptalExample example);

    Emptal selectByPrimaryKey(Integer empId);

    // 带有部门信息的员工表的查询
    List<Emptal> WithDeptselectByExample(EmptalExample example);

    // 带有部门信息的员工表的单表查询
    Emptal WithDeptselectByPrimaryKey(Integer empId);

    int updateByExampleSelective(@Param("record") Emptal record, @Param("example") EmptalExample example);

    int updateByExample(@Param("record") Emptal record, @Param("example") EmptalExample example);

    int updateByPrimaryKeySelective(Emptal record);

    int updateByPrimaryKey(Emptal record);
}