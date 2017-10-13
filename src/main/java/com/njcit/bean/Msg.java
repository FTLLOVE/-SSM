package com.njcit.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 参数类型分别是:
 * 0.代表了成功或者失败的状态码，成功-100，失败-200,
 * 2.代表了成功或者失败返回的信息
 * 3.用户传递给浏览器传递过来的信息
 */
public class Msg {

    private int code;

    private String msg;

    private Map<String, Object> extend = new HashMap<String, Object>();

    // 定义一个返回成功，返回值是Msg对象
    public static Msg success() {
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功");
        return result;
    }

    // 定义一个返回失败，返回值是Msg对象
    public static Msg fail() {
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败");
        return result;
    }

    // 定义一个通用的方法，返回值是Msg对象
    public Msg add(String key, Object object) {
        this.getExtend().put(key, object);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}