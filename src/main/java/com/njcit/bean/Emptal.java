package com.njcit.bean;

import javax.validation.constraints.Pattern;

public class Emptal {

    private Integer empId;

    @Pattern(regexp = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5})", message = "后台的用户名必须符合规范")
    private String empName;

    private Integer empDeptId;

    private Depttal depttal;

    public Emptal() {
    }

    public Emptal(Integer empId, String empName, Integer empDeptId) {
        this.empId = empId;
        this.empName = empName;
        this.empDeptId = empDeptId;
    }

    public Integer getEmpId() {
        return empId;
    }

    public void setEmpId(Integer empId) {
        this.empId = empId;
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName == null ? null : empName.trim();
    }

    public Integer getEmpDeptId() {
        return empDeptId;
    }

    public void setEmpDeptId(Integer empDeptId) {
        this.empDeptId = empDeptId;
    }

    public Depttal getDepttal() {
        return depttal;
    }

    public void setDepttal(Depttal depttal) {
        this.depttal = depttal;
    }

    @Override
    public String toString() {
        return "Emptal{" + "empId=" + empId + ", empName='" + empName + '\'' + ", empDeptId=" + empDeptId + ", " +
                "depttal=" + depttal + '}';
    }
}