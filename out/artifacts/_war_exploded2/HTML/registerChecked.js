// 登陆校验的功能
$(function () {

    $("#userName").on("blur", function () {
        checkID();
    });

    $("#password").on("blur", function () {
        checkPwd();
    });

    $("#confirmPwd").on("blur", function () {
        checkConfirmPwd1();
    });

    $("#formLogin").on("submit", function () {
        return checkID() && checkPwd() && checkConfirmPwd() && checkConfirmPwd1();
    });

});

/**
 * 判断ID
 * @returns {boolean}
 */
function checkID() {
    return checkout1("userName");
}

/**
 * 判断密码
 * @returns {boolean}
 */
function checkPwd() {
    return checkout1("password");
}

/**
 * 判断确认密码
 * @returns {boolean}
 */
function checkConfirmPwd() {
    return checkout1("confirmPwd");
}

/**
 *  判断密码是否一致
 * @returns {boolean}
 */
function checkConfirmPwd1() {
    return checkConfirm("password", "confirmPwd");
}

/**
 * 校验用户名，密码还有确认密码是否为空的通用方法
 * @param eleID
 * @returns {boolean}
 */
function checkout1(eleID) {
    if ($("#" + eleID).val() == "") {
        $("#" + eleID + "Div").attr("class", "form-group has-error");
        $("#" + eleID + "Span").html("<div class='alert alert-danger'>不能为空</div>");
        return false;
    } else if ($("#" + eleID).val().length >= 15) {
        $("#" + eleID + "Div").attr("class", "form-group has-error");
        $("#" + eleID + "Span").html("<div class='alert alert-danger'>长度不能大于15位</div>");
        return false;
    } else {
        $("#" + eleID + "Div").attr("class", "form-group has-success");
        $("#" + eleID + "Span").html("<div class='alert alert-success'>正确填写</div> ");
        return true;
    }
}

function demo1() {
    var val = $("#userName").val();
    if (val != "") {
        $("#userNameSpan").html("<div class='alert alert-danger'>不能为空</div>");

    }
}

/**
 *  判断前后密码是否一致
 * @returns {boolean}
 */
function checkConfirm(password, confirmPwd) {
    var password1 = $("#" + password).val();
    var confirmPwd1 = $("#" + confirmPwd).val();
    if (password1 == confirmPwd1 && confirmPwd1 != "") {
        $("#" + confirmPwd + "Div").attr("class", "form-group has-success");
        $("#" + confirmPwd + "Span").html("<div class='alert alert-success'>密码一致</div>");
        return true;
    } else {
        $("#" + confirmPwd + "Div").attr("class", "form-group has-error");
        $("#" + confirmPwd + "Span").html("<div class='alert alert-danger'>密码不一致</div>");
        return false;
    }
}

/**
 * 判断复选框是否选择了内容
 */
function checkCheckBox() {
    var selectCheckBox = $('input[name="checkbox"]:checked');
    if (selectCheckBox.length == 0) {
        $("#hobbyDiv").attr("class", "form-group has-error");
        $("#hobbySpan").html("<div class='alert alert-danger'>至少选中一项</div>");
        // window.alert("至少选中一个");
    } else {
        $("#hobbyDiv").attr("class", "form-group has-success");
        $("#hobbySpan").html("<div class='alert alert-success'>已选中</div>");
        // window.alert("已选");
    }
}


