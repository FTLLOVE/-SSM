<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path +
                "/";
        request.setAttribute("ssm_path", basePath);
    %>
    <title>用户显示界面</title>
    <script src="JQuery/jquery-3.2.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="/BootStrap/css/bootstrap.min.css" type="text/css">
    <script src="BootStrap/js/bootstrap.min.js" type="text/javascript"></script>

    <%--
        这边是使用AJAX的请求的方式来发送请求来获取JSON里面的数据
        页面加载成功后发送一个AJAX请求，获取数据
    --%>
    <script type="text/javascript">
        var total;
        var currentPage;
        $(function () {
            toPages(1);
        });

        function toPages(pn) {
            $.ajax({
                url: "${ssm_path}emps",
                data: "pn=" + pn,
                type: "GET",
                success: function (result) {
                    // Counts：调用success方法. 这里的result获取到的数据就是所有的请求数据

                    // 1、解析并且显示列表信息
                    build_emps_table(result);

                    // 2、解析并且显示分页信息
                    build_page_info(result);

                    // 3、解析并且显示导航条信息
                    build_page_nav(result);

                }
            });
        }

        /**
         * 1、解析并且显示列表信息
         *       A、首先需要把上一次的数据全部清空
         *       B、获取JSON里面List数据
         *       C、然后遍历数据
         *       D、传递一个方法，里面的参数分别代表着索引和整条数据
         */
        function build_emps_table(result) {
            $("#emps_tables tbody").empty();
            var emps = result.extend.pageInfo.list;
            $.each(emps, function (index, item) {
                var checkBokTd = $("<td><input type='checkbox' class='check_item'/></td>"); //前面的复选框
                var empId = $("<td></td>").append(item.empId); // 员工的ID
                var empName = $("<td></td>").append(item.empName); //员工的姓名
                var deptName = $("<td></td>").append(item.depttal.deptName); // 员工的所在部门
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn").append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                // 给editBtn添加一个属性，里面值正好作为当前员工的id
                editBtn.attr("edit-id", item.empId);
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn").append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                // delBtn，里面值正好作为当前员工的id
                delBtn.attr("delete-id", item.empId);
                var edbtn = $("<td></td>").append(editBtn).append("  ").append(delBtn); // 将两个按钮放到一行数据中

                $("<tr></tr>")
                    .append(checkBokTd)
                    .append(empId)
                    .append(empName)
                    .append(deptName)
                    .append(edbtn)
                    .appendTo("#emps_tables tbody");
            });
        }

        /**
         * 2、解析并且显示分页信息
         *      A、还是需要把上一次的数据全部清空
         *      B、解析获取到的JSON的数据,并且设置
         */
        function build_page_info(result) {
            $("#page_info").empty();
            $("#page_info").append("第 " + result.extend.pageInfo.pageNum + " 页,共 " + result.extend.pageInfo.pages + " 页,共 " + result.extend.pageInfo.total + " 条记录");
            total = result.extend.pageInfo.total; // 将每次发送的AJAX请求的返回的总记录获取
            currentPage = result.extend.pageInfo.pageNum;
        }

        /**
         * 3、 解析并且显示分页条的信息
         *      A、首先还是需要把上一次的数据清空
         *      B、需要创建一个nav标签里面包裹的ul标签，并且添加样式
         *      C、 创建首页和上一页并且添加超链接样式，然后接着需要判断当前页面有没有上一页了
         *          要是没有上一页就证明当前页面是第一页.那么就给首页，上一页的超链接添加不可点击
         *          的样式，要是当前页面不是首页的话，就分别给首页和上一页添加点击事件，
         *          重新发送AJAX的请求，点击首页就让页面传递的页面值变成1，要是点击上一页的话就让
         *          当前页面的值 - 1；然后按照相应的顺序来添加到标签组件(ul)
         *      D、 遍历navigatepageNums(导航页码)，然后创建每个页码的超链接标签，并且把遍历出来的页码添加进去
         *          然后判断当前的页面是不是正好遍历的页码，如果是就给当前的页码添加相应的样式，接着就是给每个页面
         *          添加点击事件，还是继续发送AJAX的请求来获取相应页面的数据，最后添加到标签组件里面(ul)
         *      E、同理，创建下一页和末页的并且添加超链接样式，然后还需要判断当前也买了有没有下一页了，
         *          要是没有下一页就证明当前页面是最后一页，就分别给末页和下一页超链接添加不可点击的样式，
         *          要是当前也买了不是末页的话，就分别给下一页和末页添加点击事件,还是重新发送AJAX的请求，
         *          点击末页就让页面传递的页码是总页码数,要是点击下一页的话就让当前的页面 + 1，然后按照下一页 -> 末页
         *          添加到标签组件(ul)
         *      F、创建nav标签并且添加ul标签
         *      G、将nav组件添加到id=page_nav里面
         *      注意：在判断是否是首页或者末页的时候需要禁用首页，上一页，末页，下一页的AJAX的请求
         *              也就是在判断的后面添加else语句来做到不再发送AJAX的请求
         *
         */
        function build_page_nav(result) {
            $("#page_nav").empty();
            var uList = $("<ul></ul>").addClass("pagination");  // 设置外面包裹着导航的各种信息的ul标签

            // 1、首页和上一页的设置,并且判断是否是首页，如果不是首页的话就可以让首页，上一页的链接可以点击
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#")); //添加首页的超链接
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));  // 添加可以上一页的超链接
            if (result.extend.pageInfo.hasPreviousPage == false) {
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            } else {
                firstPageLi.click(function () {
                    toPages(1);
                });

                prePageLi.click(function () {
                    toPages(result.extend.pageInfo.pageNum - 1);
                });
            }

            // 2、添加首页和上一页提示到ul标签中
            uList.append(firstPageLi).append(prePageLi);

            // 3、遍历页码提示
            $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
                var numLi = $("<li></li>").append($("<a></a>").append(item));
                if (result.extend.pageInfo.pageNum == item) {
                    numLi.addClass("active");
                }
                // 给每个页码添加跳转功能
                numLi.click(function () {
                    toPages(item)
                });

                uList.append(numLi);
            });

            // 4、下一页和末页的设置,并且判断是否是末页，如果不是末页的话就可以让末页，和下一页可以点击，触发事件
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;")); // 添加下一页的超链接
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#")); // 添加末页的超链接
            if (result.extend.pageInfo.hasNextPage == false) {
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            } else {
                nextPageLi.click(function () {
                    toPages(result.extend.pageInfo.pageNum + 1);
                });

                lastPageLi.click(function () {
                    toPages(result.extend.pageInfo.pages);
                });
            }

            // 5、添加下一页和末页提示
            uList.append(nextPageLi).append(lastPageLi);

            // 6、将构建好的ul添加到nav里面
            var navEle = $("<nav></nav>").append(uList);
            navEle.appendTo("#page_nav");

        }

    </script>

    <%-- 加载页面2--%>
    <script type="text/javascript">
        window.onload = function () {
//        1、点击修改员工的按钮触发的事件,但是这样是绑定不上的，为什么这样说 ? 原因是很简单的，因为这个按钮是我们在发送AJAX请求的时候动态创建的，所以当我们点击按钮的时候，实际上是没有这个按钮的出现的，解决方法就是JQuery提供了一个live方法,
//             可以在我们发送请求前就绑定点击事件：live() 但是这个方法已经失效了，
//             取而代之的是on()方法：on(events,[selector],[data],fn)

            // 1、点击编辑按钮触发的事件
            $(document).on("click", ".edit_btn", function () {
                // 清除所有的CSS样式
                $("#updateEmpNameDiv").removeClass("has-error has-success");
                $("#helpBlock3").text("");
                // 1、 获取所有的部门名
                getDepts("#dept_update_select");
                // 2、 回显员工信息
                getEmp($(this).attr("edit-id"));
                // 3、将员工id传给更新按钮
                $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
                // 4、显示模态框
                $("#emp_update_modal").modal({
                    backdrop: "static"
                })
            });

            // 2、点击更新按钮触发的事件：这里面需要修改的信息就是用户名，但是在修改后需要判断用户名是否合法
            $("#emp_update_btn").click(function () {
                var empName = $("#update_empName").val();
                var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
                if (!regName.test(empName)) {
                    show_validate_info("#update_empName", "error", "用户名格式为2-5位字符或3-16位数字和字母组合");
                    console.log("用户名格式为2-5位字符或3-16位数字和字母组合");
                    return false;
                } else {
                    show_validate_info("#update_empName", "success", "用户名格式输入正确");
                }

                $.ajax({
                    url: "${ssm_path}emp/" + $(this).attr("edit-id"),
                    type: "PUT",
                    data: $("#emp_update_modal form").serialize(),
                    success: function (result) {
                        window.alert(result.msg);
                        // 1、关闭模态框
                        $("#emp_update_modal").modal("hide");
                        // 2、回到相应修改的页面
                        toPages(currentPage);
                    }

                });

            });

//         3、发送AJAX请求来获取员工表里面的信息
            function getEmp(id) {
                $.ajax({
                    url: "${ssm_path}emp/" + id,
                    type: "GET",
                    success: function (result) {
                        var empData = result.extend.emp;
                        var empId = empData.empId;
                        var empName = empData.empName;
                        var empDeptId = empData.empDeptId;
                        $("#empId_update_static").text(empId);
                        $("#update_empName").val(empName);
                        $("#emp_update_modal select").val(empDeptId);

                    }
                });
            }

//         1、点击新增员工的按钮触发的事件
            $("#emp_add_model_btn").click(function () {
                // 在点击出现模态框之前清除上一次表单里面的数据和样式
                reset_form($("#emp_add_modal form"));

                // 在显示模态框之前发送AJAX请求来获取部门信息
                getDepts("#dept_add_select");

                // 显示模态框.
                $("#emp_add_modal").modal({
                    backdrop: "static"
                });
            });

//         2、清除样式和数据
            function reset_form(ele) {
                $(ele)[0].reset(); //清空表单里面的数据
                $(ele).find("#nameDiv").removeClass("has-error has-success"); // 清除里面的CSS样式
                $(ele).find(".help-block").text(""); // 清空友好提示框里面的信息
            }

            // 1.1、发送AJAX请求来获取部门信息的数据，并且添加到option标签中
            function getDepts(ele) {
                // 在每次发送AJAX请求之前都把上一次的部门数据清除
                $(ele).empty();
                // 发送AJAX请求来获取部门表里面的部门的信息，并且添加到select的标签中
                $.ajax({
                    url: "${ssm_path}depts",
                    type: "GET",
                    success: function (result) {
                        $.each(result.extend.depts, function (index, item) {
                            var optionEle = $("<option></option>").append(item.deptName).attr("value", item.deptId);
                            optionEle.appendTo(ele);
                        });
                    }
                });
            };


            // 判断用户名是否可用(判断用户名是否已经存在)
            $("#empName").change(function () {
                var empName = this.value; // 获取输入的用户名 . 另外一种写法：var data={};data.empName=empName;
                $.ajax({
                    url: "${ssm_path}checkUser",
                    data: "empName=" + empName,//注意：这个地方千万不能有空格出现
                    type: "POST",
                    success: function (result) {
                        if (result.code == 100) {
                            show_validate_info("#empName", "success", "用户名可用");
                            $("#emp_save_btn").attr("ajax-val", "success"); //给当前的按钮添加是否可提交的属性
                            return true;
                        } else {
                            show_validate_info("#empName", "error", "用户名不可用");
                            $("#emp_save_btn").attr("ajax-val", "error"); //给当前的按钮添加是否可提交的属性
                            return false;
                        }
                    }
                });
            });
//        2、点击保存按钮触发的事件，要来校验
            $("#emp_save_btn").click(function () {
                // 1、很重要: 完成前端数据的校验(判断输入的用户名是否是符合规范的)，要是true就进行AJAX请求，要是为false的话就不发送请求
                if (!validate_add_form()) {
                    show_validate_info();
                    return false;
                }

                // 2、很重要：判断当前的按钮里面的属性是否存在(是否可用)
                if ($(this).attr("ajax-val") == "error") {
                    return false;
                }

                // 将表单填写的数据封装成一个Emptal对象
//                这里面的这个技术是用JQuery的里面的一个技术来获取表单里面的数据用来实例化
//                var forms = $("#emp_add_modal form").serialize();
//                window.alert(forms);
                // 3、发送AJAX请求来发送请求进行保存
                $.ajax({
                    url: "${ssm_path}emp",
                    type: "POST",
                    data: $("#emp_add_modal form").serialize(), // 向服务器发送的数据,这里面的方法是通过JQuery里面的方法来获取表单里面所填写的数据，将数据作为对象插入到数据库中
                    success: function (result) {
                        // 2、处理成功就让当前的模态框隐藏,并且让页面跳转到最后一页(重新发送一个AJAX的请求，获取页码)
                        if (result.code == 100) {
                            $("#emp_add_modal").modal('hide');
                            toPages(total);
                        } else {
//                            console.log(result);  // 显示错误信息,这里面返回的result是一个JSON形式的数据
                            // 很重要:后台校验显示错误信息,如果前端你的数据被破解后，那么就需要后端来进行校验安全
                            // 要是该用户是使用过的肯定还是定义过的(defined)，要是没有使用过的话就会是未定义的(undefined)
                            if (undefined != result.extend.errorfields.empName) {
                                show_validate_info("#empName", "error", result.extend.errorfields.empName);
                            }
                        }
                    }
                });
            });


            // 2、点击删除按钮触发的事件
            $(document).on("click", ".delete_btn", function () {
//                window.alert($(this).parents("tr").find("td:eq(2)").text());
                var empName = $(this).parents("tr").find("td:eq(2)").text(); //获得要删除的员工的名字
                var empId = $(this).attr("delete-id");
                if (confirm("确认删除用户[" + empName + "]吗?")) {
                    $.ajax({
                        url: "${ssm_path}emp/" + empId,
                        type: "DELETE",
                        success: function (result) {
                            alert("删除成功!");
                            toPages(currentPage);
                        }
                    });
                }

            });


            //  2.1、前端校验用户名的输入合法性(采用正则表达式的形式进行校验)
            function validate_add_form() {
                var empName = $("#empName").val();
                var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
                if (!regName.test(empName)) {
                    show_validate_info("#empName", "error", "用户名格式为2-5位字符或3-16位数字和字母组合");
                    return false;
                } else {
                    show_validate_info("#empName", "success", "用户名格式输入正确");
                }
                return true;
            }

            // 2.1.1、显示友好提示
            function show_validate_info(ele, status, msg) {
                if (status == "success") {
                    $(ele).parent().addClass("has-success");
                    $(ele).next("span").text(msg);
                } else if (status == "error") {
                    $(ele).parent().addClass("has-error");
                    $(ele).next("span").text(msg);
                }
            }

//         3、完成全选/全不选的操作
            $("#checkBox_all").click(function () {
                // prop是用来来获取原生的属性的值，而attr是获取自定义的属性的值
                $(".check_item").prop("checked", $(this).prop("checked")); // 将单条记录的复选框的状态和check_all复选框的状态一致
            });

            // 单条记录的复选框的点击事件
            $(document).on("click", ".check_item", function () {
                // 判断选中的和未选中的个数是否一致,要是一致就说明全选按钮选中，要是不一致就说明全选按钮未选中,
                // 这里面的flag是一个boolean，这样的原理就是: 同步
                var flag = $(".check_item:checked").length == $(".check_item").length;
                $("#checkBox_all").prop("checked", flag);
                console.log(flag);
            });

            // 批量删除
            $("#emp_delete_model_btn").click(function () {
                var empNames = "";
                var delete_empNames = "";
                $.each($(".check_item:checked"), function () {
                    empNames += $(this).parents("tr").find("td:eq(2)").text() + ","; //拼接用户名
                    delete_empNames += $(this).parents("tr").find("td:eq(1)").text() + "-";
                });

                // 截取可用的字符串
                empNames = empNames.substring(0, empNames.length - 1);
                delete_empNames = delete_empNames.substring(0, delete_empNames.length - 1);
                if (confirm("确认删除[" + empNames + "]吗?")) {
                    $.ajax({
                        url: "${ssm_path}emp/" + delete_empNames,
                        type: "DELETE",
                        success: function (result) {
                            alert("批量删除成功!");
                            toPages(currentPage);
                        }

                    });

                }
            });
        };


    </script>
</head>
<style type="text/css">
    .form-control {
        display: block;
        width: 72%;
        height: 34px;
        padding: 6px 12px;
        font-size: 14px;
        line-height: 1.42857143;
        color: #555;
        background: #fff none;
        border: 1px solid #ccc;
        border-radius: 4px;
        -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
        box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
        -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
        -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
    }

    .btn-primary {
        margin-left: -27px;
        color: #fff;
        background-color: #337ab7;
        border-color: #2e6da4;
        margin-bottom: 7px;
        margin-top: 7px;
    }

    .btn-danger {
        margin-top: 7px;
        margin-left: 3px;
        color: #fff;
        background-color: #d9534f;
        border-color: #d43f3a;
        margin-bottom: 7px;
    }

    .btn-default {
        margin-top: 7px;
        color: #333;
        background-color: #fff;
        border-color: #ccc;
    }
</style>
<body style="background-color: inherit">

<%-- 员工的添加的模态框 --%>
<div class="modal fade" id="emp_add_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel" style="color: #2aabd2">
                    <div>
                        新增员工
                    </div>
                </h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10" id="nameDiv">
                            <%-- 这边的name里面的属性是JavaBean里面的字段名，必须一致，不然数据库找不到--%>
                            <input type="text" class="form-control" name="empName" id="empName"
                                   placeholder="enter your name"/>
                            <%-- 显示错误信息 --%>
                            <span id="helpBlock2" class="help-block">

                            </span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="empDeptId" id="dept_add_select">

                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    取消
                </button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">
                    保存
                </button>
            </div>
        </div>
    </div>
</div>

<%-- 员工的修改的模态框 --%>
<div class="modal fade" id="emp_update_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="UpdateModalLabel" style="color: #2aabd2">
                    <div>
                        修改员工
                    </div>
                </h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">ID:</label>
                        <div class="col-sm-10" id="updateEmpIdDiv">
                            <p class="form-control-static" id="empId_update_static">email@example.com</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名:</label>
                        <div class="col-sm-10" id="updateEmpNameDiv">
                            <input type="text" class="form-control" name="empName" id="update_empName"
                                   placeholder="enter your name"/>
                            <%-- 友好提示框 --%>
                            <span id="helpBlock3" class="help-block">
                            </span>

                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门:</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="empDeptId" id="dept_update_select">
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    取消
                </button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">
                    更新
                </button>
            </div>
        </div>
    </div>
</div>


<%-- 显示框 --%>
<div class="container">
    <fieldset>
        <%-- 标题栏 --%>
        <legend>
            <div class="row">
                <div class="col-md-12">
                    <h1>员工列表</h1>
                </div>
            </div>
        </legend>

        <%-- 按钮 --%>
        <div class="row">
            <div class="col-md-3 col-lg-offset-8">
                <button class="btn btn-primary" id="emp_add_model_btn">新 增</button>
                <button class="btn btn-danger" id="emp_delete_model_btn">删 除</button>
            </div>
        </div>

        <%-- 表格信息--%>
        <div class="row">
            <table class="table table-striped table-hover" id="emps_tables">
                <thead>
                <tr>
                    <th>
                        <%-- 全选/全不选的复选框--%>
                        <input type="checkbox" id="checkBox_all"/>
                    </th>
                    <th>ID</th>
                    <th>姓　名</th>
                    <th>所在部门</th>
                    <th>操　作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>

        <!-- 分页ROW-->
        <div class="row">

            <!-- 分页文字信息 -->
            <div class="col-md-6" id="page_info">
            </div>

            <!-- 分页条 -->
            <div class="col-md-6" id="page_nav">

            </div>
        </div>
    </fieldset>
</div>
</body>
</html>