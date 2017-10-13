<%@ page import="com.github.pagehelper.PageInfo" %>
<%@ page import="javax.sound.midi.Soundbank" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
        request.setAttribute("ssm_path", basePath);
    %>
    <title>用户显示界面</title>
    <script src="../../JQuery/jquery-3.2.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../BootStrap/css/bootstrap.min.css" type="text/css">
    <script src="../../BootStrap/js/bootstrap.min.js" type="text/javascript"></script>
</head>
<style type="text/css">
    .btn-primary {
        margin-left: -25px;
        color: #fff;
        background-color: #337ab7;
        border-color: #2e6da4;
        margin-bottom: 7px;
    }

    .btn-danger {
        color: #fff;
        background-color: #d9534f;
        border-color: #d43f3a;
        margin-bottom: 7px;
    }
</style>
<body>
<div class="container">
    <fieldset>
        <%-- 标题栏 --%>
        <legend>
            <div class="row">
                <div class="col-md-12">
                    <h1>Employee-List </h1>
                </div>
            </div>
        </legend>

        <%-- 按钮 --%>
        <div class="row">
            <div class="col-md-3 col-lg-offset-8">
                <button class="btn btn-primary">新 增</button>
                <button class="btn btn-danger">删 除</button>
            </div>
        </div>

        <%-- 表格信息--%>
        <div class="row">
            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th>序号</th>
                    <th>ID</th>
                    <th>姓名</th>
                    <th>所在部门</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <th>${emp.empId}</th>
                        <th>${emp.empId }</th>
                        <th>${emp.empName }</th>
                        <th>${emp.depttal.deptName}</th>
                        <th>
                            <button type="button" class="btn btn-primary btn-xs">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button type="button" class="btn btn-danger btn-xs">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </th>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <%-- 分页--%>
        <div class="row">
            <!-- 分页文字信息 -->
            <div class="col-md-6">
                第${pageInfo.pageNum}页,共${pageInfo.pages}页,共${pageInfo.total}条记录
            </div>
            <!-- 分页条 -->
            <div class="col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li><a href=${requestScope.get("ssm_path")}emps?pn=1>首页</a></li>
                        <!-- 是否有前一页 -->
                        <c:if test="${pageInfo.hasPreviousPage }">
                            <li>
                                <a href="${requestScope.get("ssm_path")}emps?pn=${pageInfo.pageNum-1}"
                                   aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach items="${pageInfo.navigatepageNums }" var="pNum">
                            <c:if test="${pNum == pageInfo.pageNum }">
                                <li class="active"><a href="#">${pNum }</a></li>
                            </c:if>
                            <c:if test="${pNum != pageInfo.pageNum }">
                                <li><a href="${requestScope.get("ssm_path")}emps?pn=${pNum }">${pNum }</a></li>
                            </c:if>
                        </c:forEach>

                        <!-- 是否有下一页 -->
                        <c:if test="${pageInfo.hasNextPage }">
                            <li>
                                <a href="${SSM_PATH }/emps?pn=${pageInfo.pageNum+1 }" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <li><a href="${SSM_PATH }/emps?pn=${pageInfo.pages }">尾页</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </fieldset>
</div>
</body>
</html>